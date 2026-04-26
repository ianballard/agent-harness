#!/usr/bin/env bash
set -euo pipefail

# log_remote_adapter.sh
#
# Template remote log adapter.
# Bootstrap a concrete project by replacing placeholders and implementing the
# provider-specific query command(s) required by scripts/query_logs.sh.

usage() {
  cat <<'EOF'
Usage:
  log_remote_adapter.sh [options]

Options:
  --source <name[,name...]>   Remote source alias or source name
  --since <duration>          Time range start (e.g. 15m, 2h, 1d)
  --until <duration>          Optional time range end offset
  --request-id <id>           Request identifier
  --correlation-id <id>       Correlation identifier
  --session-id <id>           Session identifier
  --filter <regex>            Additional filter
  --errors-only               Restrict output to common error patterns
  --limit <n>                 Maximum lines to emit
  --help                      Show help

Environment:
  REMOTE_LOG_BACKEND          Backend name
  REMOTE_LOG_ENV_SELECTOR     Optional environment/project selector

Notes:
  This script is invoked by scripts/query_logs.sh when LOG_REMOTE_QUERY_ADAPTER
  points here. Replace placeholders and implement provider-specific query logic.
EOF
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

SOURCE=""
SINCE=""
UNTIL=""
REQUEST_ID=""
CORRELATION_ID=""
SESSION_ID=""
FILTER_REGEX=""
ERRORS_ONLY=0
LIMIT=200

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source) SOURCE="${2:-}"; shift 2 ;;
    --since) SINCE="${2:-}"; shift 2 ;;
    --until) UNTIL="${2:-}"; shift 2 ;;
    --request-id) REQUEST_ID="${2:-}"; shift 2 ;;
    --correlation-id) CORRELATION_ID="${2:-}"; shift 2 ;;
    --session-id) SESSION_ID="${2:-}"; shift 2 ;;
    --filter) FILTER_REGEX="${2:-}"; shift 2 ;;
    --errors-only) ERRORS_ONLY=1; shift ;;
    --limit) LIMIT="${2:-}"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) die "Unknown argument: $1" ;;
  esac
done

REMOTE_LOG_BACKEND="${REMOTE_LOG_BACKEND:-UNRESOLVED}"
REMOTE_LOG_ENV_SELECTOR="${REMOTE_LOG_ENV_SELECTOR:-jg-sandbox}"

if [[ "$REMOTE_LOG_BACKEND" == "UNRESOLVED" ]]; then
  die "Remote logging backend is unresolved for this project. Configure REMOTE_LOG_BACKEND before using remote mode."
fi

cat <<EOF
Bootstrap required: implement remote log query logic for backend '$REMOTE_LOG_BACKEND'
source=$SOURCE
since=$SINCE
until=$UNTIL
request_id=$REQUEST_ID
correlation_id=$CORRELATION_ID
session_id=$SESSION_ID
filter=$FILTER_REGEX
errors_only=$ERRORS_ONLY
limit=$LIMIT
env_selector=$REMOTE_LOG_ENV_SELECTOR
EOF
