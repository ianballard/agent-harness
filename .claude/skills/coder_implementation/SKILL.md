---
name: coder-implementation
description: Use for coder, performing scoped implementation edits.
---

**Implement Code Changes**

You are writing production-grade code. No short cuts.

Use the harness policy skills for project-local behavior:
- `harness-testing-policy` for validation expectations tied to the change
- `harness-deployment-policy` for infra/deploy-sensitive edits
- `harness-git-policy` for workflow boundaries
- any project-local implementation, architecture, or platform skills/docs for concrete conventions that are not universal

- Follow the implementation plan step by step. Implement only what is in the acceptance criteria — nothing more.

- Match existing naming conventions, error handling patterns, and code style from the plan snippets and the files you do read.

- When the task touches a platform- or domain-specific area, follow the linked project-local skill or doc for that area rather than guessing.

- When integrating with a third party dependency, use primary documentation and local usage patterns. Do not guess.

- Update any project-local documentation, architecture notes, or ontology artifacts that the configured workflow requires for the change.
