---
name: coordinator-check-for-work
description: Use for coordinator, checking task-system work for a specific task id or selecting the next available task.
---

## Check for work

Use `project-policy-task-system` for the repository's task selection rules.

If a task id was presented, read its details through the configured task interface.

If no task id was presented, use the configured task interface to list the next available work item.

If no tasks are listed, output `FACTORY_IDLE` and stop.

Pick the selected task and note the task ID.
