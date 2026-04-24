---
name: harness-testing-policy
description: Project-local testing and verification policy for the harness. Defines default validation expectations, when to broaden coverage, and how blocked or skipped verification should be reported.
---

# Harness Testing Policy

Use this skill whenever coder, reviewer, or closeout needs project-specific verification rules.

## Purpose

The generic harness assumes:
- verification is part of implementation, not optional polish
- test depth should be proportional to task risk and change surface
- blocked or skipped validation must be reported explicitly

## Template Verification Policy

### Low-risk tasks

Use a ladder like this and replace placeholders:
1. Run `<targeted-test-command>` covering the changed behavior.
2. Run `<relevant-build-lint-or-check-command>` for touched surfaces.
3. Run `<scoped-integration-or-e2e-command>` only when the task requires workflow coverage.
4. Do not broaden to `<full-suite-command>` unless a targeted failure or discovered integration risk justifies it.

### Medium or High-risk tasks

Use broader suites when the change affects:
- `<shared-contract-risk-domain>`
- `<security-risk-domain>`
- `<deployment-risk-domain>`
- `<customer-visible-critical-path>`

### E2E Deployment Matrix

Define when e2e requires a deployed system versus a local test run.

Fill in a matrix like this:
- `<local-change-category>` -> `<deploy-not-required | deploy-required>`
- `<runtime-change-category>` -> `<deploy-not-required | deploy-required>`
- `<infra-or-config-change-category>` -> `<deploy-not-required | deploy-required>`
- `<mocked-or-local-integration-category>` -> `<deploy-not-required | deploy-required>`

Use this section to answer:
- whether e2e is required at all
- whether local execution is sufficient
- whether deployment must happen before e2e
- which categories of changes can skip deployment safely

## Failure Handling

- Diagnose the failing validation before changing code.
- Make the smallest relevant fix.
- Rerun the same failed validation.
- After repeated targeted failures, block with a concrete error summary instead of thrashing.

## Customization Checklist

Fill in:
- default targeted test commands
- broader suite commands
- when e2e or integration testing is mandatory
- when deployment is required before e2e
- when manual verification is acceptable
- how skipped or blocked verification must be reported
