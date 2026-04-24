#!/usr/bin/env bash
# PreToolUse | Bash matcher
# Blocks indirect execution of blocked commands (terraform apply/destroy via subprocess, pipe to shell, etc.)

INPUT=$(cat)
command=$(printf '%s' "${INPUT:-${CLAUDE_TOOL_INPUT:-}}" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")

if [[ -z "$command" ]]; then
  exit 0
fi

# Block subprocess calls that invoke terraform apply/destroy
if echo "$command" | grep -qE 'subprocess.*terraform\s+(apply|destroy)'; then
  echo "BLOCKED: Indirect execution of terraform apply/destroy via subprocess is prohibited" >&2
  exit 2
fi

# Block piping terraform apply/destroy into a shell
if echo "$command" | grep -qE '(echo|printf|cat).*terraform\s+(apply|destroy).*\|\s*(ba)?sh'; then
  echo "BLOCKED: Piping terraform apply/destroy into a shell is prohibited" >&2
  exit 2
fi

exit 0
