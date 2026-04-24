---
name: coordinator-dispatch-coder
description: Use for coordinator, dispatching coder and handling coder blocked results.
---

## Dispatch coder

Use `harness-task-system-policy` for task-note writes.

The coordinator already has the task content in context. Forward it in the prompt so the coder does not re-read it:

```
Agent: coder
Prompt: "Implement task <id>. \n\n <paste the current task record here> \n\n DO NOT STOP AT UNIT TESTS. DO NOT SKIP ANY STEPS."
```

If Coder returns `CODER_BLOCKED: <reason>`:
- append the blocked reason through the configured task-system interface
- output `FACTORY_BLOCKED: coder blocked on task <id> — <reason>`
- stop.
