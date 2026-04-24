#!/usr/bin/env bash
# PostToolUse | Edit AND Write matchers
# Logs file path of every Edit/Write to audit log (always exit 0)
set -euo pipefail

file_path=$(echo "${CLAUDE_TOOL_INPUT:-$(cat)}" | jq -r '.file_path // .tool_input.file_path // empty')

# Determine repo root for log path
repo_root=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
log_dir="$repo_root/logs/audit"
mkdir -p "$log_dir"

timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
agent="${CLAUDE_AGENT:-interactive}"
tool="${CLAUDE_TOOL:-unknown}"

printf '{"timestamp":"%s","agent":"%s","tool":"%s","file_path":"%s"}\n' \
  "$timestamp" "$agent" "$tool" "$file_path" >> "$log_dir/file-changes.jsonl"

exit 0
