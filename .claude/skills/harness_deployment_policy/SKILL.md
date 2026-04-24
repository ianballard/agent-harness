---
name: harness-deployment-policy
description: Project-local deployment and environment policy for the harness. Defines what deploy actions are allowed, what is forbidden, and which safeguards are required before environment changes.
---

# Harness Deployment Policy

Use this skill whenever coder, intake, or coordinator needs project-specific deployment and infrastructure rules.

## Purpose

The generic harness assumes deploy behavior must be explicit and local to the project. The base agents should not hardcode a cloud provider, environment naming scheme, or rollout process.

## Template Deployment Policy

### Always allowed

- `<safe-read-only-or-dry-run-commands>`

### Allowed with conditions

- `<conditionally-allowed-deploy-actions>`

Conditions to define:
- `<environment-check-requirement>`
- `<scope-limiting-requirement>`
- `<approval-gate-requirement>`
- `<identity-or-profile-requirement>`

### Never allowed

- `<forbidden-deploy-actions>`

## Template Deploy Triggers

Run deploy-oriented steps only when the change affects:
- `<deploy-trigger-surface-1>`
- `<deploy-trigger-surface-2>`
- `<deploy-trigger-surface-3>`

## Customization Checklist

Replace these sections with the repository's actual deployment policy.
