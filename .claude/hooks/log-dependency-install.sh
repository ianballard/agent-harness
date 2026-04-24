#!/usr/bin/env bash
# PreToolUse | Bash matcher | AUDIT ONLY (always exit 0)
# Logs dependency install commands (pip/pip3/npm/yarn) to audit log

INPUT=$(cat)
command=$(printf '%s' "${INPUT:-${CLAUDE_TOOL_INPUT:-}}" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")

if [[ -z "$command" ]]; then
  exit 0
fi

# Only log if it's a dependency install command
if ! echo "$command" | grep -qE '\b(pip3?\s+install|npm\s+install|yarn\s+add)\b'; then
  exit 0
fi

# Determine repo root for log path
repo_root=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
log_dir="$repo_root/logs/audit"
mkdir -p "$log_dir"

timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
agent="${CLAUDE_AGENT:-interactive}"

# Escape command as JSON string
command_json=$(echo "$command" | jq -Rs '.')

printf '{"timestamp":"%s","agent":"%s","type":"dependency_install","command":%s}\n' \
  "$timestamp" "$agent" "$command_json" >> "$log_dir/commands.jsonl"

exit 0
