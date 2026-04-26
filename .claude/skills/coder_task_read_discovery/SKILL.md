---
name: coder-task-read-discovery
description: >-
  Use when reading task-system records, performing discovery, and validating plans and complexity for a given task before the coder does the implementation. Not used for actual coding.
---

Use `project-policy-task-system` for task reads and writes.
Use `project-policy-risk` to interpret plan depth and complexity expectations.

**Context check (before step 1):** If the full task content — description, acceptance criteria, plan, and notes — was included in your dispatch prompt, skip the read below and proceed to step 2. Only use the configured task-system read operation if the content was not provided, or to verify a write you just made to the task.

**1. Read the task**

Read the full task record via the configured task-system interface.

**2. Think before implementing**

Read the task. If a note labeled `Implementation contract:` exists, that is the authoritative plan — follow it file-by-file. Otherwise, use the `--plan` field and perform proportional discovery (see below) to resolve specifics.

**If the plan lacks specific file paths or code snippets** (i.e., no architect plan), do proportional discovery:
- For Low-risk tasks: read only the task, the smallest set of directly relevant source files, and the nearest test/config files. Do not explore broadly unless a focused pass reveals ambiguity or integration risk.
- For Medium or High risk tasks: identify existing patterns, files to touch, integration points, minimal file set, and which tests cover the affected code.

**Complexity Mismatch Halt:** If proportional discovery reveals the task is significantly more complex than the Coordinator's plan suggested (e.g., the change requires touching many more files, contains undocumented integration points, or requires architectural decisions not in the plan), output `CODER_BLOCKED: complexity mismatch — task complexity exceeds plan scope: <brief explanation>` and stop. Do not attempt a high-risk implementation without updated guidance.

**Always ensure the planned implementation is cohesive, fully testable, and leaves no dead code.**

Do not write a separate execution plan. Append a single note through the configured task interface stating which plan you are following and any deviations forced by discovery.
