---
id: TASK-2.3
title: Bootstrap frontend shell for auth workflow
status: Done
assignee:
  - '@task-intake'
created_date: '2026-04-26 16:48'
updated_date: '2026-04-26 21:49'
labels:
  - frontend
  - react
  - vite
  - auth
dependencies: []
parent_task_id: TASK-2
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
User story:
As a user, I want the frontend app shell and auth views in place so I can complete signup, login, and profile flows in the browser once the backend API is available.

Scope:
Initialize the Vite + React frontend under frontend/, add the application shell, define API integration boundaries, and implement signup, login, and profile views with client-side state and error presentation ready to consume the backend auth/profile API.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 A Vite React application is initialized under frontend/ with scripts and project structure required to run locally.
- [x] #2 The frontend includes signup, login, and profile views with navigation or flow control for moving between them.
- [x] #3 Frontend auth/profile data access is centralized behind a client or service layer that targets the backend API contract rather than mock-only state.
- [x] #4 User-visible error handling is implemented in the frontend for invalid login and duplicate signup responses.
- [x] #5 Local run instructions for the frontend are present or updated as needed for this task's scope.
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Establish the frontend application scaffold under `frontend/`, including the scripts and baseline structure needed for local development.
2. Implement the auth workflow shell with signup, login, and profile views plus the navigation or flow control needed to move between them.
3. Centralize backend communication behind a frontend client/service boundary aligned to the backend auth/profile contract, including handling for invalid login and duplicate signup responses.
4. Update task-scope local run documentation as needed for the new frontend surface.
5. Validate with frontend-relevant checks and the required e2e smoke coverage; broaden coverage if implementation expands beyond the planned frontend workflow surface or reveals contract mismatches.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Implementation contract: Following the task plan as written. Planned file set from discovery: create frontend/ Vite React scaffold and auth/profile app files, add frontend unit tests, add Playwright frontend auth smoke coverage, and update README for frontend setup. No deviation from plan.

Coordinator blocker: coder could not complete frontend validation because npm package install for the new frontend scaffold could not reach registry.npmjs.org in the current environment, and the required React/Vite/Vitest packages were not available in local cache or reusable local node_modules paths. Frontend implementation files were created, but unit and Playwright validation could not run to completion, so the task cannot be closed out yet.

Implemented frontend auth shell scaffold under `frontend/` with Vite config, React app shell, centralized API/auth service layer, styling, and frontend tests.
Files created: `frontend/package.json` (frontend scripts and deps), `frontend/index.html` (Vite entry), `frontend/vite.config.js` (React plugin, dev proxy, Vitest config), `frontend/src/main.jsx` (React bootstrap), `frontend/src/App.jsx` (signup/login/profile workflow UI), `frontend/src/services/apiClient.js` (shared API request helper), `frontend/src/services/authService.js` (auth/profile service boundary + error mapping), `frontend/src/styles.css` (app shell styling), `frontend/src/test/setup.js` (Vitest DOM setup), `frontend/src/App.test.jsx` (app-level auth flow tests), `frontend/src/services/authService.test.js` (service-layer error mapping tests), `e2e/frontend-auth.spec.js` (Playwright frontend smoke coverage).
Files updated: `playwright.config.js` (backend + frontend web servers for e2e), `README.md` (frontend run/test instructions).
Verification: `cd backend && source .venv/bin/activate && pytest` passed (11 tests).
Blocked verification: `cd frontend && npm install --verbose` failed with `ENOTFOUND registry.npmjs.org`; no local npm cache for React/Vite/Vitest packages was present. Because frontend dependencies could not be installed, `npx playwright test e2e/auth-api.spec.js` failed before execution with `vite: command not found`, so frontend unit tests and Playwright frontend smoke coverage remain blocked by environment package access.

Resume note:
- Existing frontend implementation was validated rather than reimplemented.
- Files modified in this resume: `frontend/package-lock.json` (lockfile produced by successful frontend dependency install), `frontend/src/App.test.jsx` (fixed ambiguous Testing Library selectors and added explicit cleanup), `e2e/frontend-auth.spec.js` (fixed ambiguous Playwright selectors by targeting auth nav vs auth form controls).
- Verification: `cd frontend && npm test` passed (6 tests).
- Verification: `cd frontend && npm run build` passed.
- Verification: `cd backend && pytest` passed (11 tests) using the available local Python environment; the checked-in `backend/.venv` path in earlier notes was not a usable activate target in this workspace.
- Verification: `npx playwright test e2e/frontend-auth.spec.js` passed (1 test).
- Local-only generated artifacts remain unstaged: `frontend/dist/` from the build and `backend/myproject.db` updated by local test runs.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Closed after frontend auth shell verification completed on 2026-04-26. Acceptance criteria remain satisfied: Vite React scaffold, signup/login/profile views, centralized API service boundary, user-visible auth error handling, and updated local run instructions. Verification confirmed during resume: frontend unit tests passed, frontend build passed, backend pytest passed, and Playwright frontend auth smoke coverage passed. Merge guard against develop includes only task-scope frontend files plus this task record. Residual local artifacts not part of closeout remain unstaged: frontend/dist/ and backend/myproject.db.
<!-- SECTION:FINAL_SUMMARY:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 Frontend unit or app-level checks relevant to the changed surface pass.
- [x] #2 Any task-local documentation updates needed for the frontend setup are included.
- [x] #3 Implementation notes and verification evidence are recorded on the task.
<!-- DOD:END -->
