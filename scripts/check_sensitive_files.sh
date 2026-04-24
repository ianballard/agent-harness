#!/usr/bin/env bash
# Pre-commit hook: block files matching secret file patterns
set -e

# Allowlist: files that match the pattern but are intentionally committed
ALLOWLIST=(
  ".secrets.baseline"
  ".claude/hooks/block-secret-in-command.sh"
  ".claude/hooks/block-secret-in-write.sh"
)

is_allowed() {
  local file="$1"
  for allowed in "${ALLOWLIST[@]}"; do
    if [[ "$file" == "$allowed" ]]; then
      return 0
    fi
  done
  return 1
}

for f in "$@"; do
  if echo "$f" | grep -qEi '\.(env|pem|key|pfx|p12)$|credentials\.|secret'; then
    if is_allowed "$f"; then
      continue
    fi
    echo "BLOCKED: secret file pattern detected: $f" >&2
    exit 1
  fi
done
