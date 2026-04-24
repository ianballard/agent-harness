#!/usr/bin/env bash
# PostCompact hook — appends the compact summary to .claude/memories.md
set -euo pipefail
INPUT=$(cat)

summary=$(echo "$INPUT" | jq -r '.compact_summary // empty')
session_id=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
trigger=$(echo "$INPUT" | jq -r '.trigger // "unknown"')

[ -z "$summary" ] && exit 0

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
mem_file="$repo_root/.claude/memories.md"
timestamp=$(date -u +"%Y-%m-%d %H:%M UTC")

{
  echo ""
  echo "## $timestamp — compact ($trigger) [session:${session_id:0:8}]"
  echo ""
  echo "$summary"
  echo ""
} >> "$mem_file"

exit 0
