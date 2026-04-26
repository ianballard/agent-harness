---
id: TASK-2.2.2
title: Add SQLite user persistence layer
status: In Progress
assignee:
  - '@task-intake'
created_date: '2026-04-26 16:58'
updated_date: '2026-04-26 17:13'
labels:
  - backend
  - sqlite
  - persistence
  - database
dependencies:
  - TASK-2.2.1
parent_task_id: TASK-2.2
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
User story:
As a developer, I want a SQLite-backed user persistence layer so that backend auth and profile features can store and retrieve user records from the database.

Scope:
Add the SQLite database setup, define the user persistence model or schema, and implement the data access layer used by downstream auth and profile endpoints.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 SQLite database configuration is added to the backend service and can be initialized locally.
- [x] #2 A user persistence model or schema is implemented for storing account data in SQLite.
- [x] #3 The backend exposes a data access layer or repository for creating and retrieving users from SQLite without relying on in-memory storage.
- [x] #4 Backend tests cover the persistence-layer create and read behavior for the user path.
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Work in the backend persistence area only: SQLite configuration, user schema/model, and a repository/data-access layer for create/read operations on the user path.
2. Validate with backend automated checks focused on persistence-layer create/read behavior against SQLite, and keep the scope out of auth endpoints, token/session handling, and frontend wiring.
3. Broaden scope only if the persistence contract cannot be exercised or validated without minimal supporting backend bootstrap changes that are directly required by this task's acceptance criteria.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Intake risk classification: Medium. Trigger: backend persistence-layer work that introduces new functionality for the user account path and sits outside the Low-risk bucket because it changes schema/persistence behavior.

Following the task's Implementation Plan as written. Discovery is limited to the backend persistence surface and directly related tests/configuration.

Implemented backend SQLite persistence only. Files: backend/app/config.py (added SQLITE_DB_PATH setting), backend/app/main.py (initialize DB at app startup), backend/app/db.py (SQLite schema/init/connection helpers), backend/app/repositories/__init__.py (repository exports), backend/app/repositories/users.py (user create/read repository), backend/tests/test_user_repository.py (SQLite persistence tests), backend/.env.example (local DB config example). Verification: python3 -m pytest backend/tests -> 5 passed; python3 -m uvicorn app.main:app --host 127.0.0.1 --port 8000 + npx playwright test e2e/backend-scaffold.spec.js -> 1 passed. Non-obvious decision: used stdlib sqlite3 instead of adding an ORM because this task only requires local SQLite config, schema, and create/read repository behavior.
<!-- SECTION:NOTES:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [x] #1 Backend automated validation relevant to the persistence layer passes.
- [x] #2 No mock-only persistence remains for the implemented user storage path.
- [x] #3 Implementation notes and verification evidence are recorded on the task.
<!-- DOD:END -->
