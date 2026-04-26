---
id: TASK-2.2.4
title: Implement authenticated profile endpoint and backend auth coverage
status: In Progress
assignee:
  - '@task-intake'
created_date: '2026-04-26 16:58'
updated_date: '2026-04-26 17:34'
labels:
  - backend
  - auth
  - api
  - testing
dependencies:
  - TASK-2.2.1
  - TASK-2.2.2
  - TASK-2.2.3
parent_task_id: TASK-2.2
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
User story:
As a user, I want an authenticated profile endpoint so that I can retrieve my saved account information after logging in.

Scope:
Implement the authenticated profile endpoint on top of the backend scaffold, persistence layer, and auth flow, and complete backend test coverage for profile retrieval using authenticated requests.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 An authenticated profile endpoint returns the current user's saved information from SQLite-backed persistence.
- [ ] #2 The endpoint enforces the implemented authentication mechanism before returning profile data.
- [ ] #3 Backend tests cover authenticated profile retrieval and unauthorized access behavior.
- [ ] #4 Backend auth/profile test coverage is sufficient for downstream frontend integration work.
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
Risk classification: High (trigger: changes to core endpoint for `profile` and auth enforcement behavior).

Implementation area:
- Backend profile endpoint and request authentication integration on top of the existing backend scaffold, persistence layer, and login token flow.

Validation categories:
- Backend automated tests for authenticated profile retrieval.
- Backend automated tests for unauthorized profile access.
- Smoke integration coverage needed to keep downstream frontend integration unblocked.

Out of scope:
- Frontend UI wiring.
- Signup/login endpoint redesign.
- Persistence model changes beyond what is required to read the current user profile.

Broaden scope only if:
- The existing auth token or persistence contracts cannot support resolving the current user for the profile endpoint without changing previously completed task behavior.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
- Intake assessment: task definition is sufficient for implementation without refinement.
- Risk: High. Trigger: changes to core endpoint for `profile` and auth enforcement behavior.

Implementation contract: following the task Implementation Plan as provided; no deviations identified during initial discovery.

## Implementation Notes
- backend/app/auth.py: added access-token decoding and signature validation for authenticated requests.
- backend/app/api/dependencies.py: added shared user-repository and current-user dependencies for bearer auth enforcement.
- backend/app/api/routes/auth.py: switched repository dependency import to shared API dependencies.
- backend/app/api/routes/profile.py: added authenticated GET /api/profile endpoint returning the current user payload.
- backend/app/api/router.py: registered the profile route.
- backend/tests/test_auth_api.py: added authenticated profile retrieval and unauthorized profile access coverage.
- e2e/auth-api.spec.js: extended auth smoke coverage to verify unauthorized and authorized profile reads.
- Verification: cd backend && pytest -> passed (11 tests).
- Verification: npx playwright test e2e/auth-api.spec.js -> passed.
- Note: local Playwright smoke passed against the backend available on http://127.0.0.1:8000; a separate uvicorn start attempt encountered a bind error because that port was already in use.

Closeout merge guard: compared branch diff against develop. Unexpected files outside TASK-2.2.4 scope remain in the diff: backend/.env.example, backend/app/config.py, backlog/tasks/task-2.2.3 - Implement-signup-and-login-API-flow.md. Closeout blocked until the branch scope is isolated or guidance updates the comparison rule.
<!-- SECTION:NOTES:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 Backend automated validation relevant to the profile endpoint passes.
- [ ] #2 Implementation notes and verification evidence are recorded on the task.
<!-- DOD:END -->
