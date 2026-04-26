---
name: project-policy-testing
description: Project-local testing and verification policy. Defines default validation expectations, when to broaden coverage, and how blocked or skipped verification should be reported.
---

# Project Testing Policy

Use this skill whenever coder, reviewer, or closeout needs MyProject verification rules.

## Default Verification Ladder

1. Run targeted tests for the touched surface:
   - `cd frontend && npm test`
   - `cd backend && source .venv/bin/activate && pytest`
2. Run any relevant build or local check needed for the touched surface.
3. Run Playwright e2e coverage for the affected workflow.
4. For new functionality, add or update Playwright coverage before closeout.

## Mandatory E2E Rule

- E2E is always required.
- At minimum, run smoke coverage for the changed workflow.
- Treat Playwright e2e as the integration-test layer for this repository.

## Broader Verification Triggers

Broaden verification when the change affects:
- auth or identity
- login or profile endpoints
- database schema or persistence logic
- any workflow that spans frontend and backend

In those cases, run both frontend and backend targeted suites plus relevant Playwright flows.

## E2E Deployment Matrix

- frontend-only changes -> deploy not required
- backend application changes -> deploy not required
- auth/profile workflow changes -> deploy not required
- infrastructure or Terraform changes -> deploy not required for app e2e, but infra verification workflow is `UNRESOLVED`
- mocked or local-integration alternatives -> not used for e2e

## Manual Verification

- Manual verification may supplement automated checks but does not replace required e2e.
- If a required automated check is blocked or skipped, record the exact blocker and missing coverage in task notes and closeout summary.

## Failure Handling

- Diagnose failing validation before changing code again.
- Make the smallest relevant fix.
- Rerun the failing validation.
- After repeated failures, stop with a concrete error summary.
