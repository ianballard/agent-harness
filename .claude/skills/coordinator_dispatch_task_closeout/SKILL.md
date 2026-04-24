---
name: coordinator-dispatch-task-closeout
description: Use for coordinator, dispatching task-closeout and propagating completion or blocked output.
---

## Dispatch task-closeout

Use `harness-task-system-policy` for completion writes and `harness-git-policy` for understanding closeout merge-guard behavior.

On `CODER_DONE`:

```
Agent: task-closeout
Prompt: "Close out task <id>"
```

If closeout returns `CLOSEOUT_BLOCKED: <reason>`:
- output `FACTORY_BLOCKED: closeout blocked on task <id> — <reason>`
- stop.

If closeout returns `TASK_COMPLETE: <task id> — <task title>`, propagate it as the final output.
