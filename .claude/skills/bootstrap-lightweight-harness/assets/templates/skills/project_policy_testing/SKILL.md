---
name: project_policy_testing
description: Lightweight validation policy for rapid development repositories.
---

# Project Policy: Testing

Fill this with project-local rules.

Default lightweight policy:

- Run the cheapest meaningful validation for the touched area.
- Prefer targeted tests over full-suite runs unless broader coverage is cheap.
- Run e2e only when the repo's rules or change type require it.
- If no tests exist, use a smoke check or direct run path when possible.
- If validation is skipped, blocked, or partial, report that explicitly.
- Do not add heavy test ceremony unless the failure risk justifies it.
