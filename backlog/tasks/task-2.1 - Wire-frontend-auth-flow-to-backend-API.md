---
id: TASK-2.1
title: Wire frontend auth flow to backend API
status: In Progress
assignee:
  - '@task-intake'
created_date: '2026-04-26 16:48'
updated_date: '2026-04-26 21:55'
labels:
  - frontend
  - backend
  - integration
  - auth
dependencies:
  - TASK-2.2
  - TASK-2.3
parent_task_id: TASK-2
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
User story:
As a user, I want the frontend auth screens to work against the real backend so that I can sign up, log in, and see my saved profile information end to end.

Scope:
Connect the frontend auth and profile views to the implemented backend API, persist the authenticated client state, and ensure the profile view reflects the saved SQLite data path.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Frontend signup submits to the real backend API and succeeds when the backend creates the user record.
- [x] #2 Frontend login uses the implemented backend auth flow and stores the authenticated session or token needed for subsequent requests.
- [x] #3 The profile view calls the authenticated backend profile endpoint and displays the saved user information returned from SQLite.
- [x] #4 The integrated browser flow handles invalid login and duplicate signup API responses with user-visible feedback.
- [x] #5 Integration-level checks relevant to the frontend/backend auth wiring are added or updated for this task as appropriate.
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Connect the existing frontend auth and profile screens to the live backend API contract for signup, login, and authenticated profile retrieval without expanding backend endpoint scope unless an integration defect blocks completion. 2. Persist authenticated client state needed for follow-on profile requests and user session continuity within the frontend scope defined by the task. 3. Add or update integration-focused validation for the frontend/backend auth wiring, including browser-level coverage for success and error paths called out in the acceptance criteria. 4. Keep out of scope: backend auth model redesign, schema changes, deployment/infrastructure work, or unrelated UI refactors. Broaden scope only if existing backend/frontend contracts are incompatible in a way that prevents satisfying the stated end-to-end auth flow.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Intake risk classification: High. Trigger: auth or identity behavior changes via frontend wiring of signup, login, token/session storage, and authenticated profile access against live backend APIs. Independent review required before closeout.

Following the task implementation plan against the existing frontend auth shell and backend auth/profile API. Discovery limited the scoped implementation surface to frontend/src/App.jsx, frontend/src/services/*, and integration/browser tests; no backend endpoint expansion is planned unless an integration defect blocks completion.

Implemented frontend/backend auth integration validation updates. Modified files: frontend/src/App.test.jsx (added coverage for stored-session profile restore and invalid-login feedback), e2e/frontend-auth.spec.js (extended browser flow to verify session persistence across reload), backlog/tasks/task-2.1 - Wire-frontend-auth-flow-to-backend-API.md (task record updated via CLI). Verification: cd frontend && npm test; cd frontend && npm run build; cd backend && python3 -m pytest; npx playwright test e2e/frontend-auth.spec.js. All passed.
<!-- SECTION:NOTES:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 Required automated validation for the integrated auth/profile workflow passes for this task's scope.
- [x] #2 Implementation notes and verification evidence are recorded on the task.
<!-- DOD:END -->
