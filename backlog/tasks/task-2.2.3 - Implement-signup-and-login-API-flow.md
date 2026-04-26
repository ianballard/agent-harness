---
id: TASK-2.2.3
title: Implement signup and login API flow
status: Done
assignee:
  - '@task-intake'
created_date: '2026-04-26 16:58'
updated_date: '2026-04-26 17:28'
labels:
  - backend
  - auth
  - api
dependencies:
  - TASK-2.2.1
  - TASK-2.2.2
parent_task_id: TASK-2.2
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
User story:
As a user, I want backend signup and login endpoints so that I can create an account and authenticate with valid credentials.

Scope:
Implement the signup and login API behavior on top of the backend scaffold and persistence layer, including duplicate-signup rejection and the authenticated token or session response expected by the frontend contract.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 A signup endpoint creates a new user record through the persistence layer.
- [x] #2 Duplicate signup attempts are rejected with a clear API error response.
- [x] #3 A login endpoint validates credentials against persisted user data.
- [x] #4 Successful login returns the authenticated token or session material expected by the frontend contract.
- [x] #5 Backend tests cover signup, duplicate signup, successful login, and invalid login behavior.
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
Implementation area: backend auth API on top of the existing FastAPI scaffold and SQLite user persistence layer. Validation scope: backend automated coverage for signup success, duplicate signup rejection, successful login, and invalid login behavior; verify the returned auth response matches the task contract for frontend consumption. Out of scope: profile endpoint behavior, frontend integration, deployment work, and schema redesign beyond what the existing persistence layer already supports. Broaden scope only if the current persistence layer or auth response contract is insufficient to satisfy the acceptance criteria without coordinated changes to dependent backend auth tasks.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Intake risk classification: High. Trigger: Auth or identity behavior changes; changes to core endpoint for login. Decision: proceed without breakdown. Coordinator guidance: architecture help is recommended by default; independent review is required before closeout.

Coder plan note: following the task Implementation Plan as written. Discovery scope is limited to backend auth API files, existing SQLite user persistence, backend tests, and any directly required FastAPI routing/config needed to satisfy signup/login AC without touching profile or frontend surfaces.

## Implementation Notes
Files changed: backend/app/auth.py (added password hashing, password verification, and signed bearer-token helpers); backend/app/config.py (added SECRET_KEY setting for auth token signing); backend/app/api/router.py (registered auth routes); backend/app/api/routes/auth.py (implemented /api/auth/signup and /api/auth/login with duplicate-signup and invalid-login handling); backend/tests/test_auth_api.py (added backend coverage for signup success, duplicate signup rejection, successful login, and invalid login); backend/.env.example (documented local SECRET_KEY setting); e2e/auth-api.spec.js (added Playwright API smoke for signup, duplicate rejection, and login). Runtime artifact touched during local validation: backend/myproject.db (local SQLite data file updated by uvicorn/Playwright run and intentionally left unstaged).
Decisions: used stdlib scrypt + HMAC-signed bearer tokens to avoid adding auth dependencies while still persisting hashed passwords and returning frontend-consumable token material.
Verification: python3 -m pytest backend/tests -> 9 passed; python3 -m uvicorn app.main:app --host 127.0.0.1 --port 8000 + npx playwright test e2e/backend-scaffold.spec.js e2e/auth-api.spec.js -> 2 passed.
Deploy workflow: no deploy step required for backend auth changes under project testing/deployment policy.

Closeout merge-guard base: develop. Working tree contains unrelated local changes outside task scope: .claude/skills/bootstrap-project-harness/SKILL.md; .claude/skills/bootstrap-project-harness/assets/templates/settings/settings.local.template.json; .claude/skills/bootstrap-project-harness/assets/templates/settings/settings.template.json; .claude/skills/bootstrap-project-harness/references/materialization-map.md; .claude/skills/bootstrap-project-harness/references/output-map.md; .claude/skills/bootstrap-project-harness/references/project-inputs.md; .claude/skills/bootstrap-project-harness/references/question-bank.md; .claude/skills/bootstrap-project-harness/assets/templates/docs/harness/hooks.md; .claude/skills/bootstrap-project-harness/assets/templates/githooks/; .claude/skills/bootstrap-project-harness/assets/templates/scripts/claude_hook_post_tool_use.sh; .claude/skills/bootstrap-project-harness/assets/templates/scripts/claude_hook_pre_tool_use.sh; .claude/skills/bootstrap-project-harness/assets/templates/scripts/install_githooks.sh; backlog/tasks/task-3 - Add-hook-generation-to-bootstrap-skill.md; backend/myproject.db.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Completed backend signup/login API flow on top of the FastAPI scaffold and SQLite persistence layer. Delivered duplicate-signup rejection, persisted credential validation, signed bearer-token response, backend auth coverage, and Playwright API smoke coverage. Verification evidence: python3 -m pytest backend/tests -> 9 passed; npx playwright test e2e/backend-scaffold.spec.js e2e/auth-api.spec.js -> 2 passed with local backend running. Independent review completed with REVIEW_OK and no blocking findings.
<!-- SECTION:FINAL_SUMMARY:END -->

## Definition of Done
<!-- DOD:BEGIN -->
- [ ] #1 Backend automated validation relevant to the auth endpoints passes.
- [ ] #2 Implementation notes and verification evidence are recorded on the task.
<!-- DOD:END -->
