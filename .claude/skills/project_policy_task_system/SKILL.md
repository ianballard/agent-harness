---
name: project-policy-task-system
description: Project-local task system policy. Defines how work is selected, read, updated, and completed so the generic SDLC agents can operate against the repository's chosen task system.
---

# Project Task System Policy

Use this skill whenever coordinator, task-intake, coder, or task-closeout needs MyProject task-system behavior.

## Purpose

MyProject uses Backlog.md as the durable source of task state. Agents must route task reads and writes through the Backlog.md CLI and must not edit task artifacts directly.

## Task System Mapping

- Task system: `Backlog.md CLI`
- Task metadata root: `backlog/`
- Read task details: `backlog task <id> --plain`
- List available work: `backlog task list --plain`
- Claim task: `backlog task edit <id> -s "In Progress" -a <assignee>`
- Write plan: `backlog task edit <id> --plan "..."`
- Append notes: `backlog task edit <id> --append-notes "..."`
- Mark acceptance criteria: `backlog task edit <id> --check-ac <index>`
- Final summary: `backlog task edit <id> --final-summary "..."` or `--append-final-summary`
- Mark complete: `backlog task edit <id> -s "Done"`

## Required Invariants

- All code changes must have a task.
- If no relevant task exists, create one before implementation.
- Never edit `backlog/tasks/*` files directly.
- Use the Backlog.md CLI as the only supported write surface for task operations.
- Record plan, implementation notes, verification status, and closeout summary in the task.

## Expected Storage

- Plan location: task `Implementation Plan`
- Notes location: task `Implementation Notes`
- Acceptance criteria tracking: task AC checklist
- Completion mechanism: task status plus final summary

## Coordination Guidance

- Prefer reading task state with `--plain`.
- Persist the chosen risk level and review/decomposition decision in task notes when the workflow requires it.
- If the task system is unavailable, block instead of silently tracking work only in chat.
