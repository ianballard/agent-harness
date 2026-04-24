#!/usr/bin/env bash
# PreToolUse | Bash matcher
# Blocks destructive git commands: reset --hard, clean -f*, checkout -- .

INPUT=$(cat)
command=$(printf '%s' "${INPUT:-${CLAUDE_TOOL_INPUT:-}}" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")

if [[ -z "$command" ]]; then
  exit 0
fi

# Block git reset --hard
if echo "$command" | grep -qE '\bgit\s+reset\s+.*--hard\b'; then
  echo "BLOCKED: git reset --hard is prohibited (destructive operation)" >&2
  exit 2
fi

# Block git clean -f (any flag combination containing f)
if echo "$command" | grep -qE '\bgit\s+clean\s+.*-[a-zA-Z]*f[a-zA-Z]*'; then
  echo "BLOCKED: git clean -f (force) is prohibited (destructive operation)" >&2
  exit 2
fi

# Block git checkout -- . (discard all working-tree changes)
if echo "$command" | grep -qE '\bgit\s+checkout\s+--\s+\.'; then
  echo "BLOCKED: git checkout -- . is prohibited (destructive operation)" >&2
  exit 2
fi

exit 0
