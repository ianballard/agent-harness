---
name: project-workflow-deployment
description: Project-local deployment workflow. Defines the repository's concrete deployment architecture, packaging steps, build artifacts, and apply sequence so the generic deploy step does not assume a specific cloud or runtime layout.
---

# Project Deployment Workflow

Use this skill only after `project-policy-deployment` has established that deployment work is allowed.

## Current State

This repository has deployment-policy constraints, but the concrete artifact build and rollout workflow is still partially undefined.

## Recommended Workflow Baseline

### 1. Prepare Artifacts

- Frontend verification/build command: `UNRESOLVED`
- Backend packaging/build command: `UNRESOLVED`
- Terraform working directory and artifact prerequisites: `UNRESOLVED`

### 2. Pre-Deploy Commit

- Recommendation: do not require a special pre-deploy commit unless the deployment system keys artifacts off commit SHA or tags.
- Current project rule: `UNRESOLVED`

### 3. Preview and Apply

- Required preview step: `terraform plan -var="aws_profile=jg-sandbox"`
- Apply step, when explicitly approved and limited to `dev`: `terraform apply -var="aws_profile=jg-sandbox"`
- Additional rollout/publish commands beyond Terraform: `UNRESOLVED`

### 4. Post-Deploy Checks

- Minimum requirement: run smoke verification for the changed workflow in `dev`
- Exact post-deploy command set: `UNRESOLVED`

## Failure Recovery

- Recommendation: prefer follow-up commits over amend for deploy-fix work unless the human explicitly asks otherwise.
- Whether artifacts must be rebuilt after head changes is `UNRESOLVED`.
