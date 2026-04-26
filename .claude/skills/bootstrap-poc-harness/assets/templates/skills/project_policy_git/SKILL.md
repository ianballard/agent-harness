---
name: project_policy_git
description: Lightweight git policy for rapid development repositories.
---

# Project Policy: Git

Fill this with project-local rules.

Default lightweight policy:

- Never use destructive git commands without explicit human approval.
- Never use broad staging commands like `git add .` or `git add -A`.
- Follow the project's actual branching model if one exists.
- Do not assume commits are required unless the repo's definition of done says so.
- Never push to remote unless the project policy allows it and the human has asked for it.
- If PRs are part of the repo's definition of done, treat them as a separate explicit step rather than assuming they are always in scope.
- If the repo has no formal branch or PR rules yet, say so plainly instead of inventing them.
