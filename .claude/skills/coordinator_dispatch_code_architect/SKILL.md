---
name: coordinator-dispatch-code-architect
description: Use for coordinator, code-architect dispatch and implementation contract recording.
---

## Dispatch code-architect

Use the configured task-system interface to persist architect output.
Use project-local architecture docs, ontology files, or system maps only if they exist; do not assume any particular file layout.

```
Agent: code-architect
Prompt: "Explore the codebase and design the implementation for this task. Task: <task title>. Description: <description>. Acceptance criteria: <AC list>.

First, explore the codebase: identify existing patterns relevant to this change, files likely to be touched, integration points, the minimal file set, dependencies, and relevant tests. Produce a change map.

Read project-local architecture or ontology docs only if they are present and relevant. If such docs are missing or stale, fall back to targeted source reads and note the gap in the plan.

Then read source files only for the specific change sites needed to produce an implementation-ready plan.

For each file to be touched, the plan must include: (1) exact file path, (2) specific function, module, resource, or section to modify, (3) enough surrounding context to make the change site unambiguous, and (4) any relevant configuration or integration contract needed to implement safely. Order steps by dependency.

Produce a step-by-step implementation plan."
```

Append the architect's plan as a note labeled `Implementation contract:`. The coder will treat this as authoritative for file paths, code locations, and step ordering. The Coordinator's `--plan` remains the AC-verification reference.
Persist it through the configured task-system interface and append a short note that coder dispatch is starting.
