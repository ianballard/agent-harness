# Output Map

Use this map to decide where information should live when instantiating a lightweight harness.

## Keep generic

These should stay project-agnostic:
- `CLAUDE.md`
- `.claude/agents/coder.md`
- `.claude/skills/build/SKILL.md`

## Fill with project-local policy

Populate these with concise project rules:
- `.claude/skills/project_policy_git/SKILL.md`
- `.claude/skills/project_policy_testing/SKILL.md`
- `.claude/skills/project_policy_deployment/SKILL.md`

## Prefer one short doc for bulky detail

If the developer loop needs extra explanation, keep it in:
- `docs/harness/dev-loop.md`

Then link to that doc from `CLAUDE.md` or the implementation skill.

## Do not generate by default

These belong to the full harness, not the lightweight scaffold:
- coordinator or intake skills
- task-system policy
- risk-classification policy
- closeout flow
- deploy workflow docs
- observability workflow docs
- hooks, settings files, or guard scripts

## Upgrade path

Every generated lightweight harness should state when to migrate to the full harness, such as:
- parallel contributors become common
- deploy or infra risk becomes meaningful
- regressions start recurring
- durable task tracking becomes necessary
- independent review or auditability starts to matter
