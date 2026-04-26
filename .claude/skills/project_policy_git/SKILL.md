---
name: project-policy-git
description: Project-local git policy. Defines branching, staging, commit, and push behavior so the generic agents can follow the repository's collaboration model.
---

# Project Git Policy

Use this skill whenever coder or closeout needs MyProject git workflow rules.

## Core Rules

- Never discard unrelated user changes.
- Never use destructive reset or clean operations.
- Stage files explicitly.
- Prefer non-interactive git commands.
- Do not amend commits unless the human explicitly requests it.

## Branching Model

- Repository model: `feature|bug|other branch -> develop -> staging -> main`
- For harness task work, branch from `develop`
- Pushes are allowed only to the task branch created from `develop`
- PRs are required and should target `develop`

## Commit Expectations

- Commit scope rule: keep commits scoped to the active task
- Commit message convention: `UNRESOLVED`
- Pre-commit evidence requirement: record verification and implementation notes in the task before final closeout

## Closeout Guidance

- If work was completed without a task, stop and create or link the task before closeout.
- If the current branch is not based on `develop`, stop and ask for guidance before pushing or opening a PR.
