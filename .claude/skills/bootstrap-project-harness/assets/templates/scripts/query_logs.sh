#!/usr/bin/env bash
set -euo pipefail

# query_logs.sh
#
# Generic log-query wrapper.
# - Local mode reads files under LOG_LOCAL_ROOT (default: ./logs)
# - Remote mode shells out to LOG_REMOTE_QUERY_ADAPTER, which must accept the
#   same flags and write matching log lines to stdout
#
# Designed to be redirected into a temp file for triage:
#   scripts/query_logs.sh --source app --request-id abc --since 30m > /tmp/logs.txt

usage() {
  cat <<'EOF'
Usage:
  query_logs.sh [options]

Options:
  --mode <auto|local|remote>   Query mode. Default: auto
  --source <name[,name...]>    Log source alias, file path, or adapter source
  --since <duration>           Narrow query window (e.g. 15m, 2h, 1d)
  --until <duration>           Optional end window offset (same format)
  --request-id <id>            Request identifier filter
  --correlation-id <id>        Correlation identifier filter
  --session-id <id>            Session identifier filter
  --filter <regex>             Additional regex filter
  --errors-only                Restrict output to common error patterns
  --limit <n>                  Maximum lines to emit. Default: 200
  --output <path>              Write output to file instead of stdout
  --help                       Show this help

Environment:
  LOG_LOCAL_ROOT               Root directory for local logs (default: ./logs)
  LOG_REMOTE_QUERY_ADAPTER     Executable used for remote log queries
EOF
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

duration_to_mins() {
  local raw="${1:-}"
  if [[ "$raw" =~ ^([0-9]+)m$ ]]; then
    echo "${BASH_REMATCH[1]}"
  elif [[ "$raw" =~ ^([0-9]+)h$ ]]; then
    echo "$(( ${BASH_REMATCH[1]} * 60 ))"
  elif [[ "$raw" =~ ^([0-9]+)d$ ]]; then
    echo "$(( ${BASH_REMATCH[1]} * 1440 ))"
  else
    return 1
  fi
}

write_output() {
  local src="$1"
  local output_path="$2"
  if [[ -n "$output_path" ]]; then
    mkdir -p "$(dirname "$output_path")"
    cp "$src" "$output_path"
  else
    cat "$src"
  fi
}

MODE="auto"
SOURCE=""
SINCE=""
UNTIL=""
REQUEST_ID=""
CORRELATION_ID=""
SESSION_ID=""
FILTER_REGEX=""
ERRORS_ONLY=0
LIMIT=200
OUTPUT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode) MODE="${2:-}"; shift 2 ;;
    --source) SOURCE="${2:-}"; shift 2 ;;
    --since) SINCE="${2:-}"; shift 2 ;;
    --until) UNTIL="${2:-}"; shift 2 ;;
    --request-id) REQUEST_ID="${2:-}"; shift 2 ;;
    --correlation-id) CORRELATION_ID="${2:-}"; shift 2 ;;
    --session-id) SESSION_ID="${2:-}"; shift 2 ;;
    --filter) FILTER_REGEX="${2:-}"; shift 2 ;;
    --errors-only) ERRORS_ONLY=1; shift ;;
    --limit) LIMIT="${2:-}"; shift 2 ;;
    --output) OUTPUT="${2:-}"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) die "Unknown argument: $1" ;;
  esac
done

[[ "$MODE" =~ ^(auto|local|remote)$ ]] || die "--mode must be auto, local, or remote"
[[ "$LIMIT" =~ ^[0-9]+$ ]] || die "--limit must be an integer"

LOCAL_ROOT="${LOG_LOCAL_ROOT:-./logs}"
REMOTE_ADAPTER="${LOG_REMOTE_QUERY_ADAPTER:-}"

select_mode() {
  case "$MODE" in
    local|remote) echo "$MODE" ;;
    auto)
      if [[ -n "$REMOTE_ADAPTER" && ! -d "$LOCAL_ROOT" ]]; then
        echo "remote"
      else
        echo "local"
      fi
      ;;
  esac
}

resolve_local_files() {
  local root="$1"
  local source_csv="$2"
  local -a requested=()
  local -a files=()
  local token

  if [[ -z "$source_csv" ]]; then
    if [[ -d "$root" ]]; then
      while IFS= read -r token; do
        files+=("$token")
      done < <(find "$root" -type f | sort)
    fi
  else
    IFS=',' read -r -a requested <<< "$source_csv"
    for token in "${requested[@]}"; do
      if [[ -f "$token" ]]; then
        files+=("$token")
        continue
      fi
      if [[ -d "$root" ]]; then
        while IFS= read -r match; do
          files+=("$match")
        done < <(find "$root" -type f \( -name "*${token}*" -o -path "*${token}*" \) | sort)
      fi
    done
  fi

  if [[ "${#files[@]}" -eq 0 ]]; then
    return 1
  fi

  printf '%s\n' "${files[@]}" | awk '!seen[$0]++'
}

run_local_query() {
  local tmp="$1"
  local files_list="$2"
  local since_mins=""
  local until_mins=""
  local -a files=()
  local line
  local scan_tmp
  scan_tmp="$(mktemp)"

  if [[ -n "$SINCE" ]]; then
    since_mins="$(duration_to_mins "$SINCE")" || die "Unsupported --since format: $SINCE"
  fi
  if [[ -n "$UNTIL" ]]; then
    until_mins="$(duration_to_mins "$UNTIL")" || die "Unsupported --until format: $UNTIL"
  fi

  while IFS= read -r line; do
    [[ -n "$line" ]] || continue
    files+=("$line")
  done <<< "$files_list"

  : > "$scan_tmp"
  for line in "${files[@]}"; do
    if [[ -n "$since_mins" || -n "$until_mins" ]]; then
      local age_mins
      age_mins="$(( ( $(date +%s) - $(stat -f %m "$line") ) / 60 ))"
      if [[ -n "$since_mins" && "$age_mins" -gt "$since_mins" ]]; then
        continue
      fi
      if [[ -n "$until_mins" && "$age_mins" -lt "$until_mins" ]]; then
        continue
      fi
    fi
    printf '%s\n' "$line" >> "$scan_tmp"
  done

  if [[ ! -s "$scan_tmp" ]]; then
    : > "$tmp"
    rm -f "$scan_tmp"
    return 0
  fi

  if has_cmd rg; then
    xargs rg -nH --no-heading '.' < "$scan_tmp" > "$tmp"
  else
    xargs grep -nH '.' < "$scan_tmp" > "$tmp"
  fi

  if [[ -n "$REQUEST_ID" ]]; then
    grep -F "$REQUEST_ID" "$tmp" > "${tmp}.1" || true
    mv "${tmp}.1" "$tmp"
  fi
  if [[ -n "$CORRELATION_ID" ]]; then
    grep -F "$CORRELATION_ID" "$tmp" > "${tmp}.1" || true
    mv "${tmp}.1" "$tmp"
  fi
  if [[ -n "$SESSION_ID" ]]; then
    grep -F "$SESSION_ID" "$tmp" > "${tmp}.1" || true
    mv "${tmp}.1" "$tmp"
  fi
  if [[ "$ERRORS_ONLY" -eq 1 ]]; then
    grep -Ei 'error|exception|traceback|fatal|denied|timeout' "$tmp" > "${tmp}.1" || true
    mv "${tmp}.1" "$tmp"
  fi
  if [[ -n "$FILTER_REGEX" ]]; then
    grep -Ei "$FILTER_REGEX" "$tmp" > "${tmp}.1" || true
    mv "${tmp}.1" "$tmp"
  fi

  head -n "$LIMIT" "$tmp" > "${tmp}.1" || true
  mv "${tmp}.1" "$tmp"
  rm -f "$scan_tmp"
}

run_remote_query() {
  local tmp="$1"
  [[ -n "$REMOTE_ADAPTER" ]] || die "Remote mode requires LOG_REMOTE_QUERY_ADAPTER"
  [[ -x "$REMOTE_ADAPTER" ]] || die "LOG_REMOTE_QUERY_ADAPTER is not executable: $REMOTE_ADAPTER"

  local -a cmd
  cmd=("$REMOTE_ADAPTER")
  [[ -n "$SOURCE" ]] && cmd+=(--source "$SOURCE")
  [[ -n "$SINCE" ]] && cmd+=(--since "$SINCE")
  [[ -n "$UNTIL" ]] && cmd+=(--until "$UNTIL")
  [[ -n "$REQUEST_ID" ]] && cmd+=(--request-id "$REQUEST_ID")
  [[ -n "$CORRELATION_ID" ]] && cmd+=(--correlation-id "$CORRELATION_ID")
  [[ -n "$SESSION_ID" ]] && cmd+=(--session-id "$SESSION_ID")
  [[ -n "$FILTER_REGEX" ]] && cmd+=(--filter "$FILTER_REGEX")
  [[ "$ERRORS_ONLY" -eq 1 ]] && cmd+=(--errors-only)
  cmd+=(--limit "$LIMIT")
  "${cmd[@]}" > "$tmp"
}

QUERY_MODE="$(select_mode)"
RESULT_TMP="$(mktemp)"

if [[ "$QUERY_MODE" == "local" ]]; then
  FILES="$(resolve_local_files "$LOCAL_ROOT" "$SOURCE" || true)"
  if [[ -z "$FILES" ]]; then
    : > "$RESULT_TMP"
  else
    run_local_query "$RESULT_TMP" "$FILES"
  fi
else
  run_remote_query "$RESULT_TMP"
fi

write_output "$RESULT_TMP" "$OUTPUT"
rm -f "$RESULT_TMP"
