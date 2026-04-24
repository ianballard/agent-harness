#!/usr/bin/env bash
# PreToolUse | Edit AND Write matchers
# Blocks writes that contain secret material: AWS key IDs, private keys, API secret keys

# For Write tool: content field; for Edit tool: new_string field
INPUT=$(cat)
content=$(printf '%s' "${INPUT:-${CLAUDE_TOOL_INPUT:-}}" | jq -r '.tool_input.content // .tool_input.new_string // ""' 2>/dev/null || echo "")

if [[ -z "$content" ]]; then
  exit 0
fi

# AWS Access Key ID pattern (AKIA...)
if echo "$content" | grep -qE 'AKIA[0-9A-Z]{16}'; then
  echo "BLOCKED: File content contains what appears to be an AWS Access Key ID" >&2
  exit 2
fi

# PEM private key header (RSA, EC, DSA, OPENSSH, or generic)
# Use -- to prevent grep from treating the leading dashes as flags
if echo "$content" | grep -qE -- '-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----'; then
  echo "BLOCKED: File content contains a PEM private key — do not write secrets to files" >&2
  exit 2
fi

# API secret key pattern (sk-...)
if echo "$content" | grep -qE 'sk-[a-zA-Z0-9]{20,}'; then
  echo "BLOCKED: File content contains what appears to be an API secret key (sk-...)" >&2
  exit 2
fi

exit 0
