# CLAUDE.md

## Project

- `MyProject` is a React + FastAPI + SQLite web app with auth and user profile flows.
- Runtime surfaces:
  - `frontend/` - Vite + React SPA
  - `backend/` - FastAPI service
  - `backlog/` - Backlog.md task system metadata
- Harness scope: whole repository.

## Main Skill

- `coordinate` - coordinator; task lifecycle, agent dispatch order, and closeout

## Agents

- `.claude/agents/coder.md` - implementer; reads the approved plan from the task system, writes code, verifies, and prepares commit output
- `code-architect` - optional planning/research role for high-risk or extra-high-risk work
- `code-reviewer` - optional independent review role for changes that hit project-local review thresholds

Keep generic stage logic in:
- `.claude/skills/coordinator_*`
- `.claude/skills/coder_*`

Keep project-local rules in:
- `.claude/skills/project_policy_*`
- `.claude/skills/project_workflow_*`
- `docs/harness/*.md`

## Project Customization Skills

- `.claude/skills/project_policy_task_system/SKILL.md`
- `.claude/skills/project_policy_risk/SKILL.md`
- `.claude/skills/project_policy_testing/SKILL.md`
- `.claude/skills/project_policy_deployment/SKILL.md`
- `.claude/skills/project_workflow_deployment/SKILL.md`
- `.claude/skills/project_workflow_observability/SKILL.md`
- `.claude/skills/project_policy_git/SKILL.md`
- `.claude/skills/manage_backlog_tasks/SKILL.md`

## Task System

- All code changes must have a task.
- The task system is Backlog.md initialized under `backlog/`.
- Use the Backlog.md CLI and the `manage_backlog_tasks` skill as the task interface.
- If no relevant task exists, create one before making code changes.
- Do not edit task artifacts directly.

See:
- [task-system.md](/Users/iballard/Documents/workspace/account/personal/agent-harness/docs/harness/task-system.md)
- `.claude/skills/project_policy_task_system/SKILL.md`

## Testing

- E2E is always required, at minimum smoke coverage.
- New functionality requires new Playwright coverage.
- E2E serves as the integration-test layer for this project.

See:
- [testing.md](/Users/iballard/Documents/workspace/account/personal/agent-harness/docs/harness/testing.md)
- `.claude/skills/project_policy_testing/SKILL.md`

## Deployment

- Platform: AWS with Terraform-managed infrastructure.
- Never run destructive AWS or Terraform commands.
- Non-destructive AWS commands must use `--profile jg-sandbox`.
- `terraform plan` and `terraform apply` must include `-var="aws_profile=jg-sandbox"`.
- Agent-driven deploys are limited to `dev`.
- All other environments are forbidden unless the human explicitly updates project policy.

See:
- [deployment.md](/Users/iballard/Documents/workspace/account/personal/agent-harness/docs/harness/deployment.md)
- `.claude/skills/project_policy_deployment/SKILL.md`
- `.claude/skills/project_workflow_deployment/SKILL.md`

## Git Workflow

- Git model: `feature|bug|other branch -> develop -> staging -> main`.
- For harness work, create task branches from `develop`.
- Agents may push only task branches that branch from `develop`.
- PRs target `develop`.

See:
- `.claude/skills/project_policy_git/SKILL.md`

## Safety Constraints

- No destructive operations without explicit human approval.
- No secret exposure in terminal output, files, commits, or pull requests.
- No data exfiltration to unapproved external endpoints.
- No hook circumvention.
- No broad staging commands such as `git add -A` or `git add .`.
- No `--no-verify`.
- Project-wide AI guidance edits require explicit approval in this conversation.
  - Applies to `CLAUDE.md`
  - Applies to `.claude/agents/*.md`
  - Applies to `.claude/skills/**/SKILL.md`

## Harness Gaps

- Observability backend and remote query workflow remain `UNRESOLVED`.
- Exact deployment build and rollout commands remain `UNRESOLVED`.
- Hook integration points for command/tool-call audit logging remain `UNRESOLVED`.

