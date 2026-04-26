---
id: TASK-2.2.4
title: Implement authenticated profile endpoint and backend auth coverage
status: To Do
assignee: []
created_date: '2026-04-26 16:58'
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

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 Backend automated validation relevant to the profile endpoint passes.
- [ ] #2 Implementation notes and verification evidence are recorded on the task.
<!-- DOD:END -->
