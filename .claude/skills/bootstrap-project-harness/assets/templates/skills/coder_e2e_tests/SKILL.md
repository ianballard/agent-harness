---
name: coder-e2e-tests
description: Use for coder, running required e2e validation and diagnosing failures.
---

**Run e2e tests**

Use `project-policy-testing` for whether e2e coverage is required.
Use `project-workflow-observability` for how to diagnose workflow failures.
Use any project-local e2e workflow doc or skill for concrete commands, fixtures, budgets, and artifact paths.

Run only the e2e coverage required by the configured project-local testing workflow. Do not invent categories, retry budgets, artifact formats, or runner commands unless the project-local e2e workflow defines them.

**On e2e test failure (assertion or response evaluation):**

1. Follow the configured retry policy from the project-local e2e workflow.
2. Use the observability workflow to gather only the smallest diagnostic evidence needed.
3. Diagnose the root cause and apply the smallest relevant fix.
4. Re-run any required deploy or setup steps from the project-local deployment workflow if the fix changed deployable artifacts.
5. Re-run the required e2e validation once more.
6. If still failing: output `CODER_BLOCKED: e2e tests failing after fix — <error summary>` and stop.

**After passing e2e:** record relevant evidence and artifact paths in implementation notes according to the configured project workflow. Stage only explicit evidence files if the task or workflow requires them.
