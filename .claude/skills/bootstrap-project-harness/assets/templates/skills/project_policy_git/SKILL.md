---
name: project-policy-git
description: Project-local git policy. Defines branching, staging, commit, and push behavior so the generic agents can follow the repository's collaboration model.
---

# Project Git Policy

Use this skill whenever coder or closeout needs project-specific git workflow rules.

## Purpose

The generic harness assumes git behavior should be explicit, not inferred. Projects may vary, but the policy must define safe defaults.

## Template Git Policy

- Never discard unrelated user changes.
- Never use destructive reset or clean operations.
- Stage files explicitly.
- Prefer non-interactive git commands.
- Do not amend a commit unless the workflow explicitly requires it.
- Do not push to remote unless the human explicitly asks.

## Commit Expectations

Define:
- `<commit-scope-rule>`
- `<commit-message-convention>`
- `<branching-expectation>`
- `<pre-commit-note-or-evidence-requirement>`

## Customization Checklist

Replace with the repository's actual collaboration model.
