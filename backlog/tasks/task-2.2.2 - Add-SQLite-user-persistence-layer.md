---
id: TASK-2.2.2
title: Add SQLite user persistence layer
status: To Do
assignee: []
created_date: '2026-04-26 16:58'
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
- [ ] #1 SQLite database configuration is added to the backend service and can be initialized locally.
- [ ] #2 A user persistence model or schema is implemented for storing account data in SQLite.
- [ ] #3 The backend exposes a data access layer or repository for creating and retrieving users from SQLite without relying on in-memory storage.
- [ ] #4 Backend tests cover the persistence-layer create and read behavior for the user path.
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 Backend automated validation relevant to the persistence layer passes.
- [ ] #2 No mock-only persistence remains for the implemented user storage path.
- [ ] #3 Implementation notes and verification evidence are recorded on the task.
<!-- DOD:END -->
