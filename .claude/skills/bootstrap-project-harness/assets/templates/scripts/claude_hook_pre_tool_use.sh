#!/usr/bin/env bash
set -euo pipefail

# claude_hook_pre_tool_use.sh
#
# Generic Claude pre-tool hook template.
# Bootstrap should replace placeholders and extend policy checks using the
# project interview answers.

ROOT_DIR="${CLAUDE_PROJECT_ROOT:-<absolute-project-root>}"
AUDIT_LOG="${CLAUDE_HOOK_AUDIT_LOG:-$ROOT_DIR/logs/agent-audit.log}"
GUIDANCE_PATHS_REGEX="${CLAUDE_GUIDANCE_PATHS_REGEX:-(^CLAUDE\\.md$|^\\.claude/agents/|^\\.claude/skills/)}"
APPROVAL_ENV_VAR="${CLAUDE_GUIDANCE_APPROVAL_ENV_VAR:-CLAUDE_APPROVED_PROJECT_GUIDANCE_EDIT}"

mkdir -p "$(dirname "$AUDIT_LOG")"
printf '%s PRE %s\n' "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" "${1:-unknown}" >> "$AUDIT_LOG"

payload="${CLAUDE_HOOK_PAYLOAD:-${1:-}}"

if [[ "$payload" =~ (git[[:space:]]+add[[:space:]]+\.)|(git[[:space:]]+add[[:space:]]+-A)|(git[[:space:]].*--no-verify) ]]; then
  echo "Blocked by Claude hook: broad staging or --no-verify is forbidden" >&2
  exit 2
fi

if [[ "$payload" =~ (aws[[:space:]].*) && ! "$payload" =~ (--profile[[:space:]]+<required-cloud-identity>) ]]; then
  echo "Blocked by Claude hook: AWS commands must include the required profile" >&2
  exit 2
fi

if [[ "$payload" =~ (terraform[[:space:]]+(plan|apply).*) && ! "$payload" =~ aws_profile= ]]; then
  echo "Blocked by Claude hook: terraform plan/apply must include the required profile variable" >&2
  exit 2
fi

if [[ "$payload" =~ (curl|wget).*(https?://) ]]; then
  echo "Blocked by Claude hook: outbound network actions require explicit project approval" >&2
  exit 2
fi

if [[ "$payload" =~ $GUIDANCE_PATHS_REGEX ]] && [[ "${!APPROVAL_ENV_VAR:-}" != "1" ]]; then
  echo "Blocked by Claude hook: guidance edits require explicit approval" >&2
  exit 2
fi

exit 0
