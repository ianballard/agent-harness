---
name: project-policy-risk
description: Project-local risk policy. Defines how intake classifies task risk, when work must be broken down, and when architecture or independent review becomes mandatory.
---

# Project Risk Policy

Use this skill when intake or coordinator needs MyProject risk classification.

## Classification Order

Apply the first matching rule.

### Extra High

- Irreversible data migrations
- Large refactors that touch login, profile, and shared persistence behavior in the same task

Result:
- require task breakdown before coding
- require architecture help
- require independent review

### High

- Auth or identity behavior changes
- Changes to core endpoints for `login` or `profile`
- Access-control logic changes
- Token/session handling changes

Result:
- architecture help is recommended by default
- independent review is required before closeout

### Medium

- Changes that span frontend and backend but do not alter auth or schema behavior
- User-visible API or workflow changes outside the high-risk domains
- New functionality that introduces a new user-facing surface area

Result:
- targeted planning required
- broader verification required
- coordinator may request architecture help if acceptance criteria are underspecified

### Low

- Docs-only changes
- Test-only changes
- Isolated UI presentation changes that do not affect auth/profile flows
- Small backend changes outside auth, identity, schema, and core endpoints

## Stop Conditions

- Any request that requires destructive infrastructure actions is blocked.
- Any task without a backing Backlog.md task is blocked until a task exists.
- Any task with unresolved acceptance criteria in a high-risk area should stop for clarification instead of proceeding on assumption.

## Recording Requirement

Persist the chosen risk level and the trigger that matched in the task system.
