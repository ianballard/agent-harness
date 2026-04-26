---
name: coordinator-dispatch-task-intake
description: Use for coordinator, dispatching task-intake and handling intake results.
---

## Dispatch task-intake

Use `project-policy-task-system` for task writes and `project-policy-risk` for understanding intake outcomes.

```
Agent: task-intake
Prompt: "Run intake for task <id>"
```

If intake returns `INTAKE_BLOCKED: <reason>`:
- output `FACTORY_BLOCKED: intake blocked on task <id> — <reason>`
- stop.

If intake returns `INTAKE_READY: task <id> — <task title> [risk: <level>]`, continue.

## Optional intake refinement gate

Skip this gate by default. Only use it when the human explicitly enables intake
refinement for the run.

If enabled and intake returns `INTAKE_BLOCKED:` because the task definition is
missing requirements, validation details, constraints, or other implementability
context:
- ask the human for the missing information
- update the task through the configured task-system interface
- rerun intake once

If the human does not provide enough information, or the second intake still
blocks, output `FACTORY_BLOCKED: intake blocked on task <id> — <reason>` and
stop.
