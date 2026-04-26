---
name: project-workflow-observability
description: Project-local observability and log-diagnosis workflow. Defines the repository's logging architecture, diagnostic scripts, identifiers, and query patterns so failure analysis does not assume a specific platform.
---

# Project Observability Workflow

Use this skill whenever debugging or diagnostics needs project-local logging guidance.

## Current State

- Local development log surfaces exist via frontend and backend dev/test processes.
- Remote observability is expected to exist in AWS-backed environments, but the exact backend and source names are `UNRESOLVED`.

## Mapping

- Logging backend: `UNRESOLVED`
- Preferred mode: `both`
- Local log surfaces:
  - frontend dev server stdout/stderr
  - backend FastAPI/uvicorn stdout/stderr
  - Playwright output
- Remote log surfaces: `UNRESOLVED`
- Preferred diagnostic command: `scripts/diagnose_error.sh`
- Preferred targeted query command: `scripts/query_logs.sh`
- Primary request identifiers: `UNRESOLVED`

## Diagnostic Workflow

1. Start local for local dev and e2e failures.
2. Use `scripts/query_logs.sh` or `scripts/diagnose_error.sh` to avoid dumping broad logs into context.
3. For deployed `dev` issues, branch to remote logging only after the backend, source aliases, and identifiers are configured.
4. Keep remote queries time-bounded and request-scoped once those inputs are known.

## Known Gaps

- Remote logging backend name is `UNRESOLVED`
- Remote source aliases are `UNRESOLVED`
- Trace/correlation identifiers are `UNRESOLVED`
- Hook wiring for command/tool-call audit logging is `UNRESOLVED`
