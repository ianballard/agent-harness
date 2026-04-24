# Materialization Map

Use this map to render the bundled factory into a target project. Treat the bundled assets as canonical source templates.

## Core files

- `assets/templates/CLAUDE.md` -> `CLAUDE.md`

## Agents

- `assets/templates/agents/coder.md` -> `.claude/agents/coder.md`
- `assets/templates/agents/task-intake.md` -> `.claude/agents/task-intake.md`
- `assets/templates/agents/task-closeout.md` -> `.claude/agents/task-closeout.md`

## Generic stage skills

- `assets/templates/skills/coordinate/SKILL.md` -> `.claude/skills/coordinate/SKILL.md`
- `assets/templates/skills/coordinator_check_for_work/SKILL.md` -> `.claude/skills/coordinator_check_for_work/SKILL.md`
- `assets/templates/skills/coordinator_dispatch_task_intake/SKILL.md` -> `.claude/skills/coordinator_dispatch_task_intake/SKILL.md`
- `assets/templates/skills/coordinator_dispatch_code_architect/SKILL.md` -> `.claude/skills/coordinator_dispatch_code_architect/SKILL.md`
- `assets/templates/skills/coordinator_dispatch_coder/SKILL.md` -> `.claude/skills/coordinator_dispatch_coder/SKILL.md`
- `assets/templates/skills/coordinator_audit_coder_followed_steps/SKILL.md` -> `.claude/skills/coordinator_audit_coder_followed_steps/SKILL.md`
- `assets/templates/skills/coordinator_dispatch_code_reviewer/SKILL.md` -> `.claude/skills/coordinator_dispatch_code_reviewer/SKILL.md`
- `assets/templates/skills/coordinator_dispatch_task_closeout/SKILL.md` -> `.claude/skills/coordinator_dispatch_task_closeout/SKILL.md`
- `assets/templates/skills/coder_task_read_discovery/SKILL.md` -> `.claude/skills/coder_task_read_discovery/SKILL.md`
- `assets/templates/skills/coder_implementation/SKILL.md` -> `.claude/skills/coder_implementation/SKILL.md`
- `assets/templates/skills/coder_unit_tests/SKILL.md` -> `.claude/skills/coder_unit_tests/SKILL.md`
- `assets/templates/skills/coder_deploy_changes/SKILL.md` -> `.claude/skills/coder_deploy_changes/SKILL.md`
- `assets/templates/skills/coder_e2e_tests/SKILL.md` -> `.claude/skills/coder_e2e_tests/SKILL.md`
- `assets/templates/skills/coder_implementation_notes/SKILL.md` -> `.claude/skills/coder_implementation_notes/SKILL.md`
- `assets/templates/skills/coder_commit/SKILL.md` -> `.claude/skills/coder_commit/SKILL.md`
- `assets/templates/skills/coder_output_result/SKILL.md` -> `.claude/skills/coder_output_result/SKILL.md`

## Harness customization skills

- `assets/templates/skills/harness_task_system_policy/SKILL.md` -> `.claude/skills/harness_task_system_policy/SKILL.md`
- `assets/templates/skills/harness_risk_policy/SKILL.md` -> `.claude/skills/harness_risk_policy/SKILL.md`
- `assets/templates/skills/harness_testing_policy/SKILL.md` -> `.claude/skills/harness_testing_policy/SKILL.md`
- `assets/templates/skills/harness_deployment_policy/SKILL.md` -> `.claude/skills/harness_deployment_policy/SKILL.md`
- `assets/templates/skills/harness_deployment_workflow/SKILL.md` -> `.claude/skills/harness_deployment_workflow/SKILL.md`
- `assets/templates/skills/harness_observability_workflow/SKILL.md` -> `.claude/skills/harness_observability_workflow/SKILL.md`
- `assets/templates/skills/harness_git_policy/SKILL.md` -> `.claude/skills/harness_git_policy/SKILL.md`

## Helper scripts

- `assets/templates/scripts/query_logs.sh` -> `scripts/query_logs.sh`
- `assets/templates/scripts/diagnose_error.sh` -> `scripts/diagnose_error.sh`
- `assets/templates/scripts/guard_deploy_context.sh` -> `scripts/guard_deploy_context.sh`
- `assets/templates/scripts/guard_cloud_identity.sh` -> `scripts/guard_cloud_identity.sh`
- `assets/templates/scripts/guard_task_interface.sh` -> `scripts/guard_task_interface.sh`
- `assets/templates/scripts/log_remote_adapter.sh` -> `scripts/log_remote_adapter.sh`

## Settings templates

- `assets/templates/settings/settings.template.json` -> `.claude/settings.json` when the interview says a shared settings file is required
- `assets/templates/settings/settings.local.template.json` -> `.claude/settings.local.json` when the interview says a local settings file is required

## Harness docs

- `assets/templates/docs/harness/task-system.md` -> `docs/harness/task-system.md`
- `assets/templates/docs/harness/testing.md` -> `docs/harness/testing.md`
- `assets/templates/docs/harness/deployment.md` -> `docs/harness/deployment.md`
- `assets/templates/docs/harness/observability.md` -> `docs/harness/observability.md`
- `assets/templates/docs/harness/architecture.md` -> `docs/harness/architecture.md`

## Notes

- Fill placeholders using interview answers.
- If a target project does not need a file, omit it intentionally and record that decision.
- Project-specific extra skills may be created in addition to this base set.
