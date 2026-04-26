#!/usr/bin/env bash
set -euo pipefail

# guard_deploy_context.sh
#
# Template deploy-context guard.
# Bootstrap a concrete project by replacing the placeholder variables below.

usage() {
  cat <<'EOF'
Usage:
  guard_deploy_context.sh [options]

Options:
  --context-value <value>    Explicit environment/context value to validate
  --help                     Show help

Environment:
  DEPLOY_CONTEXT_KEY         Config key or variable name that determines deploy context
  DEPLOY_CONTEXT_VALUE       Explicit deploy context value, if already known
  DEPLOY_ALLOWED_VALUES      Comma-separated allow-list
  DEPLOY_FORBIDDEN_VALUES    Comma-separated deny-list

Notes:
  A concrete project bootstrap should replace placeholder defaults and may add
  project-specific config-file lookup logic here.
EOF
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

contains_csv_value() {
  local csv="$1"
  local needle="$2"
  local item
  IFS=',' read -r -a items <<< "$csv"
  for item in "${items[@]}"; do
    [[ "$item" == "$needle" ]] && return 0
  done
  return 1
}

CONTEXT_VALUE="${DEPLOY_CONTEXT_VALUE:-}"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --context-value) CONTEXT_VALUE="${2:-}"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) die "Unknown argument: $1" ;;
  esac
done

DEPLOY_CONTEXT_KEY="${DEPLOY_CONTEXT_KEY:-UNRESOLVED_DEPLOY_CONTEXT_KEY}"
DEPLOY_ALLOWED_VALUES="${DEPLOY_ALLOWED_VALUES:-sandbox,default,dev}"
DEPLOY_FORBIDDEN_VALUES="${DEPLOY_FORBIDDEN_VALUES:-prod,production,staging,main}"

if [[ -z "$CONTEXT_VALUE" ]]; then
  CONTEXT_VALUE="${DEPLOY_ENV:-${APP_ENV:-${ENVIRONMENT:-}}}"
fi

if [[ -z "$CONTEXT_VALUE" ]]; then
  die "No deploy context value provided. Set DEPLOY_ENV/APP_ENV/ENVIRONMENT or pass --context-value. DEPLOY_CONTEXT_KEY is currently $DEPLOY_CONTEXT_KEY."
fi

if contains_csv_value "$DEPLOY_FORBIDDEN_VALUES" "$CONTEXT_VALUE"; then
  die "Deploy context '$CONTEXT_VALUE' is forbidden"
fi

if ! contains_csv_value "$DEPLOY_ALLOWED_VALUES" "$CONTEXT_VALUE"; then
  die "Deploy context '$CONTEXT_VALUE' is not in allow-list"
fi

echo "deploy context ok: $CONTEXT_VALUE"
