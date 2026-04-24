#!/usr/bin/env bash
set -euo pipefail

# diagnose_error.sh
#
# Generic root-cause helper:
# 1. query a narrow set of entry-point logs for a bounded time range / request id
# 2. inspect those logs for likely downstream source names
# 3. fan out only to the discovered sources

usage() {
  cat <<'EOF'
Usage:
  diagnose_error.sh [options]

Options:
  --mode <auto|local|remote>      Query mode. Default: auto
  --entry-points <a,b,c>          Narrow first-pass sources
  --fanout-sources <a,b,c>        Optional allow-list for fanout branches
  --since <duration>              Time range start (e.g. 15m, 2h, 1d)
  --until <duration>              Optional time range end offset
  --request-id <id>               Request identifier
  --correlation-id <id>           Correlation identifier
  --session-id <id>               Session identifier
  --filter <regex>                Additional filter
  --all-events                    Do not default to errors-only mode
  --limit <n>                     Maximum lines per source. Default: 100
  --output <path>                 Write output to file instead of stdout
  --help                          Show help

Environment:
  LOG_ENTRY_POINTS                Default entry-point sources (comma-separated)
  LOG_FANOUT_SOURCES              Optional allow-list of branchable sources
  LOG_BRANCH_FIELD_HINTS          Field names inspected for downstream sources
EOF
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

MODE="auto"
ENTRY_POINTS="${LOG_ENTRY_POINTS:-entry,app,api,web}"
FANOUT_SOURCES="${LOG_FANOUT_SOURCES:-}"
SINCE=""
UNTIL=""
REQUEST_ID=""
CORRELATION_ID=""
SESSION_ID=""
FILTER_REGEX=""
ALL_EVENTS=0
LIMIT=100
OUTPUT=""
BRANCH_FIELD_HINTS="${LOG_BRANCH_FIELD_HINTS:-source,service,component,target,tool,logger}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode) MODE="${2:-}"; shift 2 ;;
    --entry-points) ENTRY_POINTS="${2:-}"; shift 2 ;;
    --fanout-sources) FANOUT_SOURCES="${2:-}"; shift 2 ;;
    --since) SINCE="${2:-}"; shift 2 ;;
    --until) UNTIL="${2:-}"; shift 2 ;;
    --request-id) REQUEST_ID="${2:-}"; shift 2 ;;
    --correlation-id) CORRELATION_ID="${2:-}"; shift 2 ;;
    --session-id) SESSION_ID="${2:-}"; shift 2 ;;
    --filter) FILTER_REGEX="${2:-}"; shift 2 ;;
    --all-events) ALL_EVENTS=1; shift ;;
    --limit) LIMIT="${2:-}"; shift 2 ;;
    --output) OUTPUT="${2:-}"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) die "Unknown argument: $1" ;;
  esac
done

[[ "$LIMIT" =~ ^[0-9]+$ ]] || die "--limit must be an integer"

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT
RESULT_TMP="$WORKDIR/diagnosis.txt"
: > "$RESULT_TMP"

query_source() {
  local source="$1"
  local label="$2"
  local out="$WORKDIR/${source//[^A-Za-z0-9_.-]/_}.log"

  local -a cmd
  cmd=(scripts/query_logs.sh --mode "$MODE" --source "$source" --limit "$LIMIT" --output "$out")
  [[ -n "$SINCE" ]] && cmd+=(--since "$SINCE")
  [[ -n "$UNTIL" ]] && cmd+=(--until "$UNTIL")
  [[ -n "$REQUEST_ID" ]] && cmd+=(--request-id "$REQUEST_ID")
  [[ -n "$CORRELATION_ID" ]] && cmd+=(--correlation-id "$CORRELATION_ID")
  [[ -n "$SESSION_ID" ]] && cmd+=(--session-id "$SESSION_ID")
  [[ -n "$FILTER_REGEX" ]] && cmd+=(--filter "$FILTER_REGEX")
  [[ "$ALL_EVENTS" -eq 0 ]] && cmd+=(--errors-only)
  "${cmd[@]}"

  {
    printf '===== SOURCE: %s (%s) =====\n' "$source" "$label"
    if [[ -s "$out" ]]; then
      cat "$out"
    else
      echo "[no matching events]"
    fi
    printf '\n'
  } >> "$RESULT_TMP"
}

discover_branches() {
  local input="$1"
  local hints_regex
  local allow_tmp="$WORKDIR/allow.txt"
  local discovered_tmp="$WORKDIR/discovered.txt"

  hints_regex="$(echo "$BRANCH_FIELD_HINTS" | sed 's/,/|/g')"
  : > "$discovered_tmp"

  if command -v rg >/dev/null 2>&1; then
    rg -oN "\"(${hints_regex})\"[[:space:]]*:[[:space:]]*\"[^\"]+\"" "$input" \
      | sed -E 's/^"[^"]+"[[:space:]]*:[[:space:]]*"([^"]+)".*$/\1/' >> "$discovered_tmp" || true
    rg -oN "(${hints_regex})[=:][A-Za-z0-9_.:-]+" "$input" \
      | sed -E 's/^[^=:]+[=:]//' >> "$discovered_tmp" || true
  else
    grep -Eo "\"(${hints_regex})\"[[:space:]]*:[[:space:]]*\"[^\"]+\"" "$input" \
      | sed -E 's/^"[^"]+"[[:space:]]*:[[:space:]]*"([^"]+)".*$/\1/' >> "$discovered_tmp" || true
    grep -Eo "(${hints_regex})[=:][A-Za-z0-9_.:-]+" "$input" \
      | sed -E 's/^[^=:]+[=:]//' >> "$discovered_tmp" || true
  fi

  sed -E '/^[[:space:]]*$/d' "$discovered_tmp" | awk '!seen[$0]++' > "${discovered_tmp}.1"
  mv "${discovered_tmp}.1" "$discovered_tmp"

  if [[ -n "$FANOUT_SOURCES" ]]; then
    printf '%s\n' "${FANOUT_SOURCES//,/\\n}" | sed '/^$/d' > "$allow_tmp"
    grep -Fx -f "$allow_tmp" "$discovered_tmp" || true
  else
    cat "$discovered_tmp"
  fi
}

{
  echo "Diagnosis scope:"
  echo "  mode=$MODE"
  echo "  entry_points=$ENTRY_POINTS"
  [[ -n "$SINCE" ]] && echo "  since=$SINCE"
  [[ -n "$UNTIL" ]] && echo "  until=$UNTIL"
  [[ -n "$REQUEST_ID" ]] && echo "  request_id=$REQUEST_ID"
  [[ -n "$CORRELATION_ID" ]] && echo "  correlation_id=$CORRELATION_ID"
  [[ -n "$SESSION_ID" ]] && echo "  session_id=$SESSION_ID"
  [[ -n "$FILTER_REGEX" ]] && echo "  filter=$FILTER_REGEX"
  echo
} >> "$RESULT_TMP"

IFS=',' read -r -a ENTRY_ARRAY <<< "$ENTRY_POINTS"
declare -A QUERIED=()
for src in "${ENTRY_ARRAY[@]}"; do
  [[ -n "$src" ]] || continue
  QUERIED["$src"]=1
  query_source "$src" "entry"
done

BRANCHES="$(discover_branches "$RESULT_TMP" || true)"
if [[ -n "$BRANCHES" ]]; then
  {
    echo "Branching:"
    while IFS= read -r src; do
      [[ -n "$src" ]] && printf '  %s\n' "$src"
    done <<< "$BRANCHES"
    echo
  } >> "$RESULT_TMP"

  while IFS= read -r src; do
    [[ -n "$src" ]] || continue
    if [[ -z "${QUERIED[$src]:-}" ]]; then
      QUERIED["$src"]=1
      query_source "$src" "branch"
    fi
  done <<< "$BRANCHES"
fi

if [[ -n "$OUTPUT" ]]; then
  mkdir -p "$(dirname "$OUTPUT")"
  cp "$RESULT_TMP" "$OUTPUT"
else
  cat "$RESULT_TMP"
fi
