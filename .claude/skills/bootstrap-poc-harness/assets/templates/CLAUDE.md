# CLAUDE.md

## Main Skill

- `build_poc` - default implementation workflow for rapid development and early-stage changes

## Main Agent

- `agents/coder.md` — the primary implementer; reads local context, makes the change, runs the cheapest meaningful validation, and reports residual risk

## Project Policy Skills

- `skills/project_policy_git/SKILL.md` — git safety and commit expectations
- `skills/project_policy_testing/SKILL.md` — lightweight validation expectations
- `skills/project_policy_deployment/SKILL.md` — deployment and environment safety rails

## Working Style

- Optimize for visible progress and short iteration loops.
- Prefer the smallest change that proves or disproves the POC.
- Do not add process machinery unless the repo has clearly outgrown the lightweight harness.

## Completion Rules

- Follow the repo's actual definition of done for a task, whether that means validation only, review, a local commit, or PR preparation.
- If the repo uses lightweight task tracking, follow it without introducing the full factory task lifecycle.

## Safety Constraints

- Never run destructive git or shell operations without explicit approval.
- Never push to remote unless explicitly asked.
- Never deploy or mutate infrastructure unless the deployment policy explicitly allows it.
- Never guess environment, account, subscription, profile, or workspace defaults.
- Report skipped validation and residual risk explicitly.

## Upgrade Triggers

When these become common, consider migrating to the full harness:
- multiple contributors or agents work in parallel
- deployment or infrastructure risk becomes real
- regressions start costing more than process overhead
- task tracking, review, or auditability needs become durable

See `docs/harness/dev-loop.md` for local fast-loop guidance.
