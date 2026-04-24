---
name: harness-observability-workflow
description: Project-local observability and log-diagnosis workflow for the harness. Defines the repository's logging architecture, diagnostic scripts, identifiers, and query patterns so failure analysis does not assume a specific platform.
---

# Harness Observability Workflow

Use this skill whenever coder, debugger, or another workflow needs the repository's concrete logging and diagnostics procedure.

## Purpose

The generic harness should not assume:
- a cloud logging backend
- any particular service or runtime topology
- log-group names or aliases
- request identifiers
- provider-specific query tools

This skill is where those repository-specific details belong.

## Template Mapping

- Logging backend: `<logging-backend>`
- Local log surfaces: `<local-log-files-or-process-logs>`
- Remote log surfaces: `<remote-log-sources>`
- Preferred diagnostic command: `<diagnostic-command>`
- Preferred targeted query command: `<targeted-query-command>`
- Primary request identifiers: `<request-identifiers>`
- Key log surfaces: `<log-surface-list>`

## Template Diagnostic Workflow

1. Start from a request identifier when available.
2. Decide whether the first pass should inspect local logs, remote logs, or both.
3. For remote logs, start from a narrow entry-point query scoped by time range and request identifier.
4. Run the configured diagnostic command into a temp file or structured artifact instead of streaming raw logs into context.
5. Triage results before reading large log windows.
6. Branch only to the failing component or downstream source indicated by the first pass.
7. Use deeper single-source queries or provider-native analytics when needed.

## Local vs Remote Guidance

Define what is needed for each path:

### Local logs

Typical needs:
- local file paths or log directories
- process or container log locations
- dev server or test runner logs
- whether file modification time is useful for narrowing

### Remote logs

Typical needs:
- entry-point sources for the first pass
- request/time filters to keep the first pass narrow
- downstream branch rules for fanout
- credentials, profile, or environment selectors
- targeted source aliases for the second pass

## Customization Checklist

Define:
- logging architecture summary
- which workflows use local logs, remote logs, or both
- entry-point sources for narrow first-pass remote queries
- downstream fanout rules for remote diagnosis
- preferred scripts or tools
- request identifiers and correlation strategy
- escalation path from broad sweep to targeted query
- provider-specific requirements and known gaps
