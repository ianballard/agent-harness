---
name: harness-deployment-workflow
description: Project-local deployment workflow for the harness. Defines the repository's concrete deployment architecture, packaging steps, build artifacts, and apply sequence so the generic deploy step does not assume a specific cloud or runtime layout.
---

# Harness Deployment Workflow

Use this skill whenever coder needs the repository's concrete deployment procedure after `harness-deployment-policy` has already established that deployment work is allowed.

## Purpose

The generic harness should not assume:
- a cloud provider
- a runtime architecture
- a packaging layout
- an image build process
- an infrastructure apply mechanism

This skill is where those repository-specific details belong.

## Template Deployment Workflow

Run deployment-oriented steps whenever the change affects the trigger surfaces defined in `harness-deployment-policy`.

### 1. Prepare Artifacts

Define:
- `<package-or-build-command>`
- `<artifact-output-location>`
- `<artifact-prerequisites>`

### 2. Create Pre-Deploy Commit If Required

If the workflow depends on a commit SHA, tag, or versioned artifact name, define:
- `<pre-deploy-commit-required-or-not>`
- `<files-to-exclude-from-pre-deploy-commit>`
- `<commit-message-pattern>`

### 3. Build or Publish Runtime Artifacts

Define:
- `<image-build-command-or-equivalent>`
- `<publish-command-or-equivalent>`
- `<artifact-versioning-rule>`

### 4. Run Rollout Step

Define:
- `<plan-preview-or-dry-run-step>`
- `<scope-confirmation-step>`
- `<apply-or-release-step>`

## Commit Recovery Strategy

Define how deploy failures interact with commits and versioned artifacts:
- `<amend-last-commit-or-create-follow-up-commit>`
- `<when-artifacts-must-be-rebuilt-after-head-changes>`

## Customization Checklist

Replace placeholders with the repository's actual deployment workflow.
