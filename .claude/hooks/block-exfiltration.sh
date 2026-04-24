#!/usr/bin/env bash
# PreToolUse | Bash matcher
# Blocks curl POST/PUT and wget --post to non-localhost URLs (data exfiltration guard)

INPUT=$(cat)
command=$(printf '%s' "${INPUT:-${CLAUDE_TOOL_INPUT:-}}" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")

if [[ -z "$command" ]]; then
  exit 0
fi

# Check for curl -X POST or curl -X PUT
if echo "$command" | grep -qE 'curl\s+.*-X\s+(POST|PUT)'; then
  # Allow if URL is localhost or 127.0.0.1
  if ! echo "$command" | grep -qE '(localhost|127\.0\.0\.1)'; then
    echo "BLOCKED: curl POST/PUT to non-localhost URL is prohibited (potential data exfiltration)" >&2
    exit 2
  fi
fi

# Also catch curl --request POST/PUT
if echo "$command" | grep -qE 'curl\s+.*--request\s+(POST|PUT)'; then
  if ! echo "$command" | grep -qE '(localhost|127\.0\.0\.1)'; then
    echo "BLOCKED: curl POST/PUT to non-localhost URL is prohibited (potential data exfiltration)" >&2
    exit 2
  fi
fi

# Check for wget --post-data or --post-file
if echo "$command" | grep -qE 'wget\s+.*--post'; then
  if ! echo "$command" | grep -qE '(localhost|127\.0\.0\.1)'; then
    echo "BLOCKED: wget --post to non-localhost URL is prohibited (potential data exfiltration)" >&2
    exit 2
  fi
fi

exit 0
