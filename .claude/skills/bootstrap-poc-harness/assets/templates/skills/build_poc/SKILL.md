---
name: build_poc
description: Default implementation workflow for rapid development. Favor the smallest useful change, the cheapest meaningful validation, the repo's actual definition of done, and explicit reporting of shortcuts and residual risk.
---

# Build POC

Use this skill as the default workflow for implementation in a lightweight harness.

## Objective

Move the repository forward quickly without pretending it already needs full SDLC ceremony.

## Workflow

1. Read only the local context needed for the request.
2. Choose the smallest change that proves progress.
3. Implement without broadening scope unless the current approach fails.
4. Validate using the cheapest meaningful check from `project_policy_testing`, including e2e when required.
5. Finish the request according to the repo's definition of done.
6. Report:
   - the user-visible outcome
   - the validation performed
   - any review, commit, or PR expectations that were skipped or deferred
   - shortcuts taken
   - residual risk
   - any signal that the repo is outgrowing the POC harness

## Guidelines

- Prefer visible working increments over speculative architecture.
- Add tests when they are cheap and materially reduce ambiguity.
- Capture debt explicitly instead of silently hardening the POC into production structure.
- If a change touches deployment, auth, security, or shared infrastructure, reassess whether the lightweight harness is still appropriate.
