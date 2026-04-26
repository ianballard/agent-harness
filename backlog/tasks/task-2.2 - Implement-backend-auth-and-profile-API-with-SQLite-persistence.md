---
id: TASK-2.2
title: Implement backend auth and profile API with SQLite persistence
status: To Do
assignee: []
created_date: '2026-04-26 16:48'
labels:
  - backend
  - fastapi
  - sqlite
  - auth
  - api
dependencies: []
parent_task_id: TASK-2
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
User story:
As a user, I want my account to be created, authenticated, and retrieved from the backend so that my profile data persists across sessions.

Scope:
Initialize the FastAPI backend under backend/, add SQLite-backed user persistence, and implement the signup, login, and authenticated profile endpoints needed by the frontend.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 A FastAPI backend is initialized under backend/ with local run configuration and dependency setup.
- [ ] #2 SQLite-backed persistence is implemented for the user path, and created users are stored in the database rather than in memory.
- [ ] #3 A signup endpoint creates a new user record and rejects duplicate signup attempts with a clear API error response.
- [ ] #4 A login endpoint validates credentials and returns the authenticated session or token material expected by the frontend contract.
- [ ] #5 An authenticated profile endpoint returns the current user's saved information from SQLite.
- [ ] #6 Backend tests cover the signup, login, duplicate signup, and profile retrieval behavior for the implemented API.
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 Backend automated validation for the touched surface passes.
- [ ] #2 No mock-only persistence remains for the implemented backend user path.
- [ ] #3 Implementation notes and verification evidence are recorded on the task.
<!-- DOD:END -->
