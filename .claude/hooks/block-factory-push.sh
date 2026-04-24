#!/usr/bin/env bash
# PreToolUse | Bash matcher
# Blocks git push when running as a factory agent (CLAUDE_AGENT=coordinator or coder)
# Allows git push in interactive mode (CLAUDE_AGENT not set)

INPUT=$(cat)
command=$(printf '%s' "${INPUT:-${CLAUDE_TOOL_INPUT:-}}" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")

if [[ -z "$command" ]]; then
  exit 0
fi

# Only apply restriction when running as a factory agent
agent="${CLAUDE_AGENT:-}"

if [[ "$agent" == "coordinator" || "$agent" == "coder" ]]; then
  if echo "$command" | grep -qE '\bgit\s+(push)\b'; then
    echo "BLOCKED: git push is prohibited when running as agent '$agent'. Merge to local main only." >&2
    exit 2
  fi
fi

exit 0
