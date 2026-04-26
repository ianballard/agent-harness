---
id: TASK-2.1
title: Wire frontend auth flow to backend API
status: To Do
assignee: []
created_date: '2026-04-26 16:48'
updated_date: '2026-04-26 16:49'
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
- [ ] #1 Frontend signup submits to the real backend API and succeeds when the backend creates the user record.
- [ ] #2 Frontend login uses the implemented backend auth flow and stores the authenticated session or token needed for subsequent requests.
- [ ] #3 The profile view calls the authenticated backend profile endpoint and displays the saved user information returned from SQLite.
- [ ] #4 The integrated browser flow handles invalid login and duplicate signup API responses with user-visible feedback.
- [ ] #5 Integration-level checks relevant to the frontend/backend auth wiring are added or updated for this task as appropriate.
<!-- AC:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 Required automated validation for the integrated auth/profile workflow passes for this task's scope.
- [ ] #2 Implementation notes and verification evidence are recorded on the task.
<!-- DOD:END -->
