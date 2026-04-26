# Hooks

- Claude hook wiring lives in `.claude/settings.local.json`
- Claude hook commands must use absolute script paths rooted at the repository
- Versioned git hooks live in `.githooks/`
- Install git hooks with `scripts/install_githooks.sh`
- Hook audit log location: `<hook-audit-log-location>`

## Claude Hooks

- Pre-tool hook: `<absolute-project-root>/scripts/claude_hook_pre_tool_use.sh`
- Post-tool hook: `<absolute-project-root>/scripts/claude_hook_post_tool_use.sh`
- Events/matchers: `<claude-hook-events-and-matchers>`

## Git Hooks

- Pre-commit: `.githooks/pre-commit`
- Commit-msg: `.githooks/commit-msg`
- Pre-push: `.githooks/pre-push`

## Expected Enforcement

- Block or validate: `<hooked-actions>`
- Guidance edit rules: `<guidance-edit-rules>`
- Hook integration points: `<hook-integration-points>`

## Notes

- Do not write bootstrap-managed hooks directly to `.git/hooks/`
- Keep repo-versioned hooks in `.githooks/`
- Use placeholders where the project has not finalized an enforcement rule yet
