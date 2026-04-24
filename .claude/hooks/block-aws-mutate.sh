#!/usr/bin/env bash
# PreToolUse | Bash matcher
# Blocks AWS CLI mutating subcommands (create-, delete-, put-, update-, remove-, terminate-)

INPUT=$(cat)
command=$(printf '%s' "${INPUT:-${CLAUDE_TOOL_INPUT:-}}" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")

if [[ -z "$command" ]]; then
  exit 0
fi

if echo "$command" | grep -qE '\baws\s+\S+\s+(create-|delete-|put-|update-|remove-|terminate-)'; then
  echo "BLOCKED: AWS mutating CLI commands are prohibited in automated agents (create-, delete-, put-, update-, remove-, terminate-)" >&2
  exit 2
fi

exit 0
