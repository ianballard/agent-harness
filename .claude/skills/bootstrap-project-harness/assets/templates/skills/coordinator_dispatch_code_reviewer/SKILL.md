---
name: coordinator-dispatch-code-reviewer
description: Use for coordinator, code-reviewer dispatch and review feedback handling.
---

## Dispatch code-reviewer

```
Agent: code-reviewer
Prompt: "Review the recent changes for this task. Task being implemented: <task title>. Acceptance criteria: <AC list>."
```

If the reviewer flags blocking issues:
  - Dispatch coder once more with the reviewer's feedback: `Agent: coder, Prompt: "Fix review issues on task <id>: <reviewer feedback>. Then output CODER_DONE."`                                          
  - If Coder is blocked again:
    - append the blocked reason through the configured task-system interface                                                                                                                   
    - output `FACTORY_BLOCKED: coder blocked after review fix on task <id> — <reason>`
    - stop.
