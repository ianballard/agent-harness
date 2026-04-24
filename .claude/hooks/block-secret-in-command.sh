#!/usr/bin/env bash
# PreToolUse | Bash matcher
# Blocks commands that contain secrets: AWS key IDs, secret key env vars, private key material, API keys

INPUT=$(cat)
command=$(printf '%s' "${INPUT:-${CLAUDE_TOOL_INPUT:-}}" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")

if [[ -z "$command" ]]; then
  exit 0
fi

# AWS Access Key ID pattern (AKIA...)
if echo "$command" | grep -qE 'AKIA[0-9A-Z]{16}'; then
  echo "BLOCKED: Command contains what appears to be an AWS Access Key ID" >&2
  exit 2
fi

# AWS Secret Access Key env var reference
if echo "$command" | grep -qE 'AWS_SECRET_ACCESS_KEY'; then
  echo "BLOCKED: Command references AWS_SECRET_ACCESS_KEY — do not embed secrets in commands" >&2
  exit 2
fi

# Private key material keyword
if echo "$command" | grep -qE 'PRIVATE_KEY'; then
  echo "BLOCKED: Command references PRIVATE_KEY — do not embed secrets in commands" >&2
  exit 2
fi

# API secret key pattern (sk-...)
if echo "$command" | grep -qE 'sk-[a-zA-Z0-9]{20,}'; then
  echo "BLOCKED: Command contains what appears to be an API secret key (sk-...)" >&2
  exit 2
fi

exit 0
