---
name: coder-deploy-changes
description: Use for coder, deciding whether deploy-oriented workflow steps are required and then following the configured deployment workflow.
---

**Run deploy-oriented workflow steps**

Use `harness-deployment-policy` as the source of truth for whether deploy steps are allowed in this repository.

Use `harness-deployment-workflow` as the source of truth for the repository's concrete deployment architecture and execution steps.

Do not assume any delivery mechanism unless the project-local deployment workflow says it applies.
