#!/usr/bin/env bash
# PreToolUse | Bash — enforces --profile jg-sandbox on all aws CLI commands
INPUT=$(cat)
COMMAND=$(printf '%s' "${INPUT:-${CLAUDE_TOOL_INPUT:-}}" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")

if [[ -z "$COMMAND" ]]; then
    exit 0
fi

# Only act on aws CLI commands
if ! printf '%s' "$COMMAND" | grep -qE '(^|[[:space:];|&])aws[[:space:]]'; then
    exit 0
fi

if printf '%s' "$COMMAND" | grep -qE '\-\-profile[[:space:]]+jg-sandbox|--profile=jg-sandbox'; then
    exit 0
fi

printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"BLOCKED: aws CLI command missing --profile jg-sandbox. All aws commands must include --profile jg-sandbox."}}\n'
exit 0
