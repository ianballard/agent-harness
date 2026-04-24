#!/usr/bin/env bash
# SessionEnd hook — extracts session context and appends to .claude/memories.md
set -euo pipefail
INPUT=$(cat)

session_id=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
transcript=$(echo "$INPUT" | jq -r '.transcript_path // empty')
reason=$(echo "$INPUT" | jq -r '.reason // "unknown"')

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
mem_file="$repo_root/.claude/memories.md"
timestamp=$(date -u +"%Y-%m-%d %H:%M UTC")

last_msg=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  last_msg=$(tail -200 "$transcript" \
    | jq -r 'select(.type == "assistant") | .message.content[]? | select(.type == "text") | .text' 2>/dev/null \
    | tail -1 \
    | head -c 2000 || true)
fi

changed_files=""
if cd "$repo_root" 2>/dev/null; then
  changed_files=$(git diff --name-only HEAD 2>/dev/null | head -20 || true)
fi

has_content=false
if [ -n "$changed_files" ] || [ -n "$last_msg" ]; then
  has_content=true
fi

# Skip writing if there's nothing meaningful to record
[ "$has_content" = false ] && exit 0

{
  echo ""
  echo "## $timestamp — session end ($reason) [session:${session_id:0:8}]"
  echo ""
  if [ -n "$changed_files" ]; then
    echo "**Files touched:**"
    echo '```'
    echo "$changed_files"
    echo '```'
    echo ""
  fi
  if [ -n "$last_msg" ]; then
    echo "**Last response (truncated):**"
    echo "$last_msg" | head -30
    echo ""
  fi
} >> "$mem_file"

exit 0
