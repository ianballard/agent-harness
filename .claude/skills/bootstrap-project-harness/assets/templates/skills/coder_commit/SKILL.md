---
name: coder-commit
description: Use for coder, explicitly staging scoped files and committing.
---

**Commit**

Use `harness-git-policy` as the source of truth for repository-specific commit and branch rules.

If a pre-deploy commit was made for the given task, this step commits only the remaining explicitly staged files required by the project workflow. If no pre-deploy commit was needed, this is the single commit for all changes.

```bash
git add <file1> <file2> ...   # list each changed file explicitly
git commit -m "<type>: <concise description of what was implemented>"
```

Use conventional commit prefixes: `feat:`, `fix:`, `refactor:`, `test:`, `chore:`.
