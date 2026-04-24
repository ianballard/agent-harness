#!/usr/bin/env bash
# SubagentStop hook — captures subagent completion summaries to .claude/memories.md
set -euo pipefail
INPUT=$(cat)

agent_type=$(echo "$INPUT" | jq -r '.agent_type // "unknown"')
session_id=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
last_msg=$(echo "$INPUT" | jq -r '.last_assistant_message // empty')

[ -z "$last_msg" ] && exit 0

# Truncate to keep entries reasonable
last_msg=$(echo "$last_msg" | head -c 1500)

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
mem_file="$repo_root/.claude/memories.md"
timestamp=$(date -u +"%Y-%m-%d %H:%M UTC")

{
  echo ""
  echo "### $timestamp — agent:$agent_type finished [session:${session_id:0:8}]"
  echo ""
  echo "$last_msg" | head -20
  echo ""
} >> "$mem_file"

exit 0
