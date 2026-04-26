---
id: TASK-2
title: 'Initialize MyProject app with auth, profile, persistence, and e2e coverage'
status: Done
assignee:
  - '@task-intake'
created_date: '2026-04-26 16:41'
updated_date: '2026-04-26 22:07'
labels:
  - frontend
  - backend
  - auth
  - api
  - sqlite
  - e2e
dependencies: []
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
User story:
As a new or returning user, I want to sign up, log in, and view my profile in MyProject so that I can access a working end-to-end app experience with my account data persisted in the database.

Scope:
Bootstrap the initial product application across the React + Vite frontend and FastAPI + SQLite backend, wire the auth and profile flows through the UI, and persist user information in SQLite.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 A Vite React frontend is initialized under frontend/ and can run locally against the backend.
- [ ] #2 A FastAPI backend is initialized under backend/ and exposes the application API backed by SQLite persistence.
- [ ] #3 A user can sign up from the frontend, and the backend persists the created user record in SQLite.
- [ ] #4 A user can log in from the frontend using the implemented auth flow and successfully establish an authenticated session or token flow used by the frontend.
- [ ] #5 An authenticated profile endpoint returns the current user's saved information from the database.
- [ ] #6 The frontend includes signup, login, and profile views wired to the backend so the user can complete the full flow in the browser.
- [ ] #7 User information displayed on the profile view reflects data stored in SQLite rather than mock or in-memory state.
- [ ] #8 Error handling is implemented for at least invalid login and duplicate signup cases with user-visible feedback.
- [ ] #9 Playwright end-to-end coverage verifies the smoke path for signup, login, and profile retrieval against the running app.
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
2026-04-26 Intake: risk classification = Extra High. Trigger matched project risk policy: task includes auth/session/identity work across frontend and backend, touches login and profile flows, introduces shared SQLite persistence/schema work, and therefore requires breakdown before implementation.

2026-04-26 Breakdown approved by user. Parent task split into child tasks to reduce scope below the Extra High threshold:
- TASK-2.1 Wire frontend auth flow to backend API
- TASK-2.2 Implement backend auth and profile API with SQLite persistence
- TASK-2.3 Bootstrap frontend shell for auth workflow
- TASK-2.4 Add auth/profile Playwright coverage and prepare PR closeout
Suggested execution order: TASK-2.2 and TASK-2.3 first, then TASK-2.1, then TASK-2.4.

2026-04-26 Task closeout attempted. Closeout blocked because child task TASK-2.2 remains In Progress in Backlog and the parent DoD item requiring a PR targeting develop is not satisfied from local evidence. Current branch feature/task-2.4-playwright-closeout has no upstream tracking branch, and gh pr status could not verify a PR in the current network-restricted environment. Develop comparison for the current branch remains task-scoped: README.md and TASK-2.4 artifacts only.
<!-- SECTION:NOTES:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 Frontend and backend setup, configuration, and local run instructions needed for this story are present in the repository.
- [ ] #2 Required automated validation passes, including unit or app-level checks as applicable and Playwright e2e coverage for the core auth/profile flow.
- [ ] #3 No mock-only persistence remains for the implemented user path; user data is stored and read from SQLite.
- [ ] #4 Implementation notes and verification evidence are recorded on the task before closeout.
- [ ] #5 A branch for the task is prepared and a pull request targeting develop is created with a summary of scope, risks, and test evidence.
<!-- DOD:END -->
