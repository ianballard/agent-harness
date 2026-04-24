#!/usr/bin/env bash
# PreToolUse | Edit AND Write matchers
# Blocks edits to .claude/settings, hooks, and settings JSON always.
# Allows .claude/agents/ and .claude/skills/ only when CLAUDE_APPROVED_PROJECT_GUIDANCE_EDIT=1
# (set by a human after explicit in-chat approval for that session).

INPUT=$(cat)
file_path=$(printf '%s' "${INPUT:-${CLAUDE_TOOL_INPUT:-}}" | jq -r '.tool_input.file_path // ""' 2>/dev/null || echo "")

if [[ -z "$file_path" ]]; then
  exit 0
fi

# Block writes to .claude/settings*.json at any path depth (always)
if echo "$file_path" | grep -qE '\.claude/settings.*\.json'; then
  echo "BLOCKED: Modifying .claude/settings*.json is prohibited" >&2
  exit 2
fi

# Block writes under .claude/settings/ or .claude/hooks/ (always)
if echo "$file_path" | grep -qE '\.claude/(settings|hooks)/'; then
  echo "BLOCKED: Modifying .claude/settings/ or .claude/hooks/ is prohibited" >&2
  exit 2
fi

# Agents and skills: require explicit session approval flag
if echo "$file_path" | grep -qE '\.claude/(agents|skills)/'; then
  if [[ "${CLAUDE_APPROVED_PROJECT_GUIDANCE_EDIT:-}" == "1" ]]; then
    exit 0
  fi
  echo "BLOCKED: Editing .claude/agents/ or .claude/skills/ requires explicit human approval and CLAUDE_APPROVED_PROJECT_GUIDANCE_EDIT=1 in the environment for this session" >&2
  exit 2
fi

exit 0
