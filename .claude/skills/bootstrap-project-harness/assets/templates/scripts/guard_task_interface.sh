#!/usr/bin/env bash
set -euo pipefail

# guard_task_interface.sh
#
# Template task-interface guard.
# Bootstrap a concrete project by replacing the placeholder variables below and,
# if needed, adding project-specific command/API validation.

usage() {
  cat <<'EOF'
Usage:
  guard_task_interface.sh [options]

Options:
  --operation <name>         Task operation being attempted
  --help                     Show help

Environment:
  TASK_SYSTEM_NAME           Human-readable task system name
  TASK_ALLOWED_OPERATIONS    Comma-separated allowed operations

Notes:
  A concrete project bootstrap should replace placeholder defaults and may add
  project-specific validation of required CLI/API usage.
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

OPERATION=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --operation) OPERATION="${2:-}"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) die "Unknown argument: $1" ;;
  esac
done

TASK_SYSTEM_NAME="${TASK_SYSTEM_NAME:-<task-system-name>}"
TASK_ALLOWED_OPERATIONS="${TASK_ALLOWED_OPERATIONS:-<allowed-task-operations>}"

if [[ "$TASK_SYSTEM_NAME" == "<task-system-name>" ]]; then
  die "Bootstrap required: replace TASK_SYSTEM_NAME placeholder"
fi
if [[ "$TASK_ALLOWED_OPERATIONS" == "<allowed-task-operations>" ]]; then
  die "Bootstrap required: replace TASK_ALLOWED_OPERATIONS placeholder"
fi
if [[ -z "$OPERATION" ]]; then
  die "No task operation provided"
fi

if ! contains_csv_value "$TASK_ALLOWED_OPERATIONS" "$OPERATION"; then
  die "Task operation '$OPERATION' is not allowed for task system '$TASK_SYSTEM_NAME'"
fi

echo "task interface ok: system=$TASK_SYSTEM_NAME operation=$OPERATION"
