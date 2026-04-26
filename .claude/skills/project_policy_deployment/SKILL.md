---
name: project-policy-deployment
description: Project-local deployment and environment policy. Defines what deploy actions are allowed, what is forbidden, and which safeguards are required before environment changes.
---

# Project Deployment Policy

Use this skill whenever coder, intake, or coordinator needs MyProject deployment or infrastructure rules.

## Platform

- Cloud/provider: `AWS`
- IaC: `Terraform`
- Allowed agent-driven environment: `dev`
- Forbidden environments: every environment except `sandbox` and `default` contexts tied to the `jg-sandbox` profile, plus any non-dev rollout target

## Always Allowed

- Non-destructive AWS read commands that include `--profile jg-sandbox`
- `terraform plan -var="aws_profile=jg-sandbox"`

## Allowed With Conditions

- `terraform apply -var="aws_profile=jg-sandbox"` only when:
  - the target is `dev`
  - the task explicitly requires deployment-oriented work
  - the human has approved rollout actions for the task
  - scope is limited to the smallest relevant Terraform target set

## Never Allowed

- Destructive AWS commands
- Destructive Terraform commands
- Any AWS command that omits `--profile jg-sandbox`
- Any `terraform plan` or `terraform apply` that omits `-var="aws_profile=jg-sandbox"`
- Any rollout targeting non-dev environments

## Deploy Triggers

Run deploy-oriented steps only when the change affects:
- infrastructure under Terraform management
- deployment configuration for the backend or frontend runtime
- environment-specific runtime configuration

## Open Gaps

- Exact environment context keys are `UNRESOLVED`
- Exact dev rollout command sequence is `UNRESOLVED`
- Exact destructive-command deny list should be enforced by hooks and remains `UNRESOLVED` at the hook-config level
