# Materialization Map

Use this map to render the bundled POC scaffold into a target project.

## Core files

- `assets/templates/CLAUDE.md` -> `CLAUDE.md`

## Agents

- `assets/templates/agents/coder.md` -> `.claude/agents/coder.md`

## Skills

- `assets/templates/skills/build_poc/SKILL.md` -> `.claude/skills/build_poc/SKILL.md`
- `assets/templates/skills/project_policy_git/SKILL.md` -> `.claude/skills/project_policy_git/SKILL.md`
- `assets/templates/skills/project_policy_testing/SKILL.md` -> `.claude/skills/project_policy_testing/SKILL.md`
- `assets/templates/skills/project_policy_deployment/SKILL.md` -> `.claude/skills/project_policy_deployment/SKILL.md`

## Harness docs

- `assets/templates/docs/harness/dev-loop.md` -> `docs/harness/dev-loop.md`

## Notes

- Fill placeholders using interview answers.
- If a target project does not need a file, omit it intentionally and record that decision.
- Do not materialize task-system interfaces, hooks, settings files, or helper scripts unless the human explicitly broadens scope.
