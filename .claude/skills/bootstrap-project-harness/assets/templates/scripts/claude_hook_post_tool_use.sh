#!/usr/bin/env bash
set -euo pipefail

# claude_hook_post_tool_use.sh
#
# Generic Claude post-tool hook template.
# Bootstrap should replace placeholders and extend the audit payload according
# to the project's hook policy.

ROOT_DIR="${CLAUDE_PROJECT_ROOT:-<absolute-project-root>}"
AUDIT_LOG="${CLAUDE_HOOK_AUDIT_LOG:-$ROOT_DIR/logs/agent-audit.log}"

mkdir -p "$(dirname "$AUDIT_LOG")"
printf '%s POST %s\n' "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" "${1:-unknown}" >> "$AUDIT_LOG"
