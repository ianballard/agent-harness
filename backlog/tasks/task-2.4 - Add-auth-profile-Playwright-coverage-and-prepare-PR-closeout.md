---
id: TASK-2.4
title: Add auth/profile Playwright coverage and prepare PR closeout
status: Done
assignee:
  - '@task-intake'
created_date: '2026-04-26 16:48'
updated_date: '2026-04-26 22:02'
labels:
  - e2e
  - playwright
  - docs
  - git
  - auth
dependencies:
  - TASK-2.1
  - TASK-2.2
  - TASK-2.3
parent_task_id: TASK-2
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
User story:
As the team, we want end-to-end verification and closeout artifacts for the auth workflow so that the integrated app is validated and ready for review.

Scope:
Add or update Playwright smoke coverage for signup, login, and profile retrieval against the running app, ensure run instructions cover the full stack needed for verification, and prepare the branch and PR summary required by the parent story.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Playwright end-to-end coverage verifies the smoke path for signup, login, and profile retrieval against the running app.
- [x] #2 Repository instructions needed to run the full local auth/profile workflow and e2e validation are present or updated.
- [x] #3 Task notes capture verification evidence for the relevant frontend, backend, and Playwright checks.
- [x] #4 The task includes the PR-ready summary information covering scope, risks, and test evidence required for final review.
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Implementation area: focus on Playwright auth/profile smoke coverage, any minimal supporting test-fixture updates, repository run/verification instructions, and PR-ready closeout notes for the integrated app.
2. Validation scope: run the required Playwright auth/profile smoke path against the running app and record supporting frontend/backend verification evidence already required by the story in task notes.
3. Out of scope: changes to backend auth semantics, profile contract behavior, database schema, or unrelated frontend UX beyond what is strictly needed to keep the e2e flow reliable and documented.
4. Broaden scope only if the current integrated auth/profile flow cannot be validated end to end without a narrowly scoped fix to test wiring or run instructions; any product-behavior change should stop and be redirected to the appropriate implementation task.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Intake risk classification: Low. Trigger matched: test-only changes and documentation/closeout updates for existing auth/profile flows, with no intended changes to auth, identity, schema, or core endpoint behavior.

Implementation note: following the existing task plan. Discovery confirmed this stays low-risk and scoped to Playwright auth/profile smoke coverage, repository run instructions, and PR-ready closeout notes only; no backend auth semantics or schema changes are needed.

Implemented closeout-scoped updates for TASK-2.4.\n- README.md: documented the full local auth/profile workflow and updated the Playwright smoke command to run auth API plus frontend auth/profile coverage.\n- e2e/frontend-auth.spec.js: strengthened the browser smoke test to assert the rendered authenticated profile fields after login and after reload, proving profile retrieval is surfaced in the UI.\nVerification:\n- cd frontend && npm test -> passed\n- cd frontend && npm run build -> passed\n- cd backend && python3 -m pytest -> passed\n- npx playwright test e2e/auth-api.spec.js e2e/frontend-auth.spec.js -> passed\nPR-ready scope: auth/profile smoke validation and runbook updates only; no backend auth, schema, or contract changes.\nRisk note: low residual risk, limited to smoke-test/documentation drift because product behavior was unchanged.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Scope:\n- tightened the frontend Playwright auth/profile smoke path to assert rendered profile metadata after login and reload\n- updated README local-run and e2e instructions for the integrated FastAPI + Vite auth workflow\n\nRisks:\n- residual risk is limited to future test-fixture or documentation drift; no auth semantics, persistence logic, or API contracts changed in this task\n\nTest Evidence:\n- cd frontend && npm test\n- cd frontend && npm run build\n- cd backend && python3 -m pytest\n- npx playwright test e2e/auth-api.spec.js e2e/frontend-auth.spec.js\n\nPR Target:\n- develop
<!-- SECTION:FINAL_SUMMARY:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 Required Playwright e2e validation passes for the auth/profile workflow.
- [x] #2 Implementation notes and verification evidence are recorded on the task.
- [x] #3 Closeout artifacts needed for a PR targeting develop are prepared.
<!-- DOD:END -->
