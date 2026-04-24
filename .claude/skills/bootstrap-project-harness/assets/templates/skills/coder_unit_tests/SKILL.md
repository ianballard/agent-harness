---
name: coder-unit-tests
description: Use for coder, creating or updating tests and running unit validation.
---

**Create/Update Unit Tests and Run All Unit Tests**

Use `harness-testing-policy` as the source of truth for how broad validation should be for this project.

Create or update relevant and useful tests. Run validation proportionate to the task risk and the coordinator plan.

- If tests pass: proceed to step 5.
- If tests fail: diagnose the failure, make the smallest relevant fix, and rerun the same failed validation.
- Allow up to 3 targeted fix attempts for the same validation step when each attempt addresses a concrete diagnosis.
- If tests still fail after 3 fix attempts, or if the next attempt would require changing the validation strategy rather than fixing the implementation, output `CODER_BLOCKED: tests failing after fixes — <error summary>` and stop.
