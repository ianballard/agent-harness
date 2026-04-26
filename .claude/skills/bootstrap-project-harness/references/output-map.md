# Output Map

Use this map to decide where information should live when instantiating a project harness.

## Bundled factory assets

The bootstrap skill may bundle reusable templates under:
- `.claude/skills/bootstrap-project-harness/assets/templates/CLAUDE.md`
- `.claude/skills/bootstrap-project-harness/assets/templates/agents/`
- `.claude/skills/bootstrap-project-harness/assets/templates/skills/`
- `.claude/skills/bootstrap-project-harness/assets/templates/scripts/`

Those are source templates, not the final runtime locations.

Use `references/materialization-map.md` to create the target project's runtime
files from those bundled assets.

## Keep generic

These should stay project-agnostic:
- `CLAUDE.md`
- `.claude/agents/coder.md`
- `.claude/agents/task-intake.md`
- `.claude/agents/task-closeout.md`
- `.claude/skills/coordinator_*`
- `.claude/skills/coder_*`

## Fill with project-local policy and workflow

Populate these with concrete project rules:
- `.claude/skills/project_policy_task_system/SKILL.md`
- `.claude/skills/project_policy_risk/SKILL.md`
- `.claude/skills/project_policy_testing/SKILL.md`
- `.claude/skills/project_policy_deployment/SKILL.md`
- `.claude/skills/project_workflow_deployment/SKILL.md`
- `.claude/skills/project_workflow_observability/SKILL.md`
- `.claude/skills/project_policy_git/SKILL.md`

## Generate project-local helper scripts when required

These should be built from interview answers, not copied from example values:
- `scripts/guard_deploy_context.sh`
- `scripts/guard_cloud_identity.sh`
- `scripts/guard_task_interface.sh`
- `scripts/log_remote_adapter.sh`

Only generate the scripts the project actually needs.

If generic templates already exist, instantiate them by replacing placeholders
with interview answers rather than rewriting the logic from scratch.

## Prefer docs for bulky details

When detail is long, operational, or architecture-heavy, create docs such as:
- `docs/harness/task-system.md`
- `docs/harness/testing.md`
- `docs/harness/deployment.md`
- `docs/harness/observability.md`
- `docs/harness/architecture.md`

Then link from the relevant harness skill.

## Create optional project-specific skills only for recurring workflows

Good candidates:
- project task-system integration
- project e2e workflow
- platform-specific implementation guidance
- project observability querying

## Optional helper scripts

If the project adopts the generic log helpers, it may also need:
- `scripts/log_remote_adapter.sh` or equivalent
- local log directory conventions or config
- project docs describing source aliases and entry-point queries

Bad candidates:
- one task's temporary notes
- one-off commands
- implementation detail that belongs in a task plan
