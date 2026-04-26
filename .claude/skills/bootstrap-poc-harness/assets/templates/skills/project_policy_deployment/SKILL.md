---
name: project_policy_deployment
description: Lightweight deployment safety policy for rapid development repositories.
---

# Project Policy: Deployment

Fill this with project-local rules.

Default lightweight policy:

- Never deploy to production or mutate shared infrastructure without explicit human approval.
- Never guess environment, account, profile, subscription, or workspace context.
- Treat read-only inspection as distinct from mutation.
- If deployment boundaries are unclear, stop and ask rather than assuming.
- If the project has no deployment workflow yet, record that explicitly.
