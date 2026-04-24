---
name: harness-task-system-policy
description: Project-local task system policy for the harness. Defines how work is selected, read, updated, and completed so the generic SDLC agents can operate against the repository's chosen task system.
---

# Harness Task System Policy

Use this skill whenever coordinator, task-intake, coder, or task-closeout needs task-system behavior that should remain customizable across projects.

## Purpose

The core harness assumes:
- implementation work should have durable task state outside chat
- agents should use the repository's task system instead of editing task artifacts directly
- task transitions, plans, notes, and closeout should be recorded through the supported interface

## Template Mapping

- Task system: `<task-system-name>`
- Read task details: `<task-read-command-or-api>`
- List available work: `<task-list-command-or-api>`
- Claim task: `<task-claim-command-or-api>`
- Write plan: `<task-plan-write-command-or-api>`
- Append notes: `<task-note-write-command-or-api>`
- Mark acceptance criteria: `<task-ac-update-command-or-api>`
- Final summary: `<task-summary-write-command-or-api>`
- Mark complete: `<task-complete-command-or-api>`

## Required Invariants

- Never edit task artifacts directly unless the project explicitly defines that as the supported interface.
- Use the configured task interface as the only write surface for task changes.
- Keep plans, notes, and final outcomes in the task system so later humans or agents can reconstruct the run.

## Customization Checklist

Define:
- how work is selected
- how a task is read
- how a task is claimed or assigned
- how a plan or implementation contract is recorded
- how implementation notes are appended
- how validation and completion are recorded
