---
name: build
description: Default implementation workflow for rapid development. Favor direct, scoped implementation, the repo's required validation, and explicit reporting of residual risk.
---

# Build

Use this skill as the default workflow for implementation in a lightweight harness.

## Objective

Move the repository forward quickly without adding process the repo does not need.

## Workflow

1. Read only the local context needed for the request.
2. If the repository uses task tracking, use that workflow as documented before and during implementation.
3. Implement the request with the narrowest scope that fully satisfies it.
4. Validate using the required checks from `project_policy_testing`, including e2e when the project rules require it.
5. Update task records with required execution details before PR creation when the repo expects that workflow.
6. Finish the request according to the repo's definition of done.
7. Report:
   - the user-visible outcome
   - the validation performed
   - any review, commit, task, or PR expectations that were skipped or deferred
   - residual risk
   - any signal that the repo is outgrowing the lightweight harness

## Guidelines

- Prefer visible working increments over speculative architecture.
- Add tests when they are cheap and materially reduce ambiguity.
- Capture follow-up work explicitly instead of smuggling it into the current change.
- If a change touches deployment, auth, security, or shared infrastructure, reassess whether the lightweight harness is still appropriate.
