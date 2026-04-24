#!/usr/bin/env bash
# PostToolUse | Bash matcher
# Logs every Bash command to audit log (always exit 0)
set -euo pipefail

command=$(echo "${CLAUDE_TOOL_INPUT:-$(cat)}" | jq -r '.command // .tool_input.command // empty')

# Determine repo root for log path
repo_root=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
log_dir="$repo_root/logs/audit"
mkdir -p "$log_dir"

timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
agent="${CLAUDE_AGENT:-interactive}"

# Escape command as JSON string
command_json=$(echo "$command" | jq -Rs '.')

printf '{"timestamp":"%s","agent":"%s","tool":"Bash","command":%s,"blocked":false}\n' \
  "$timestamp" "$agent" "$command_json" >> "$log_dir/commands.jsonl"

exit 0
