# Observability

- Logging backend: `UNRESOLVED`
- Preferred mode: `both`
- Local surfaces:
  - frontend dev server stdout/stderr
  - backend FastAPI/uvicorn stdout/stderr
  - Playwright output
- Remote entry points: `UNRESOLVED`
- Remote fanout sources: `UNRESOLVED`
- Identifiers: `UNRESOLVED`
- Adapter: `scripts/log_remote_adapter.sh`
- Known gaps:
  - remote backend and source naming are unresolved
  - trace identifiers are unresolved
  - command/tool-call audit log hook integration is unresolved
