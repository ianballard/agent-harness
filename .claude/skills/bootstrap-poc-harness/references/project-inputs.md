# Project Inputs

Collect these before instantiating a POC harness. Use placeholders for unknowns.

## Identity

- Project name: `<project-name>`
- System type: `<web-app | backend-service | infra-repo | monorepo | mobile | other>`
- Primary runtime surfaces: `<surface-list>`
- In-scope repo areas: `<path-list>`

## Task System

- Task management approach: `<tool-or-workflow>`
- No-task fallback: `<ad-hoc-request | create-lightweight-task | stop-and-ask>`

## Dev / Test Loop

- Main run commands: `<run-commands>`
- Main test or smoke commands: `<validation-commands>`
- E2E requirement: `<never | sometimes | always | trigger-based>`
- Definition of done: `<testing | review | commit | PR | other>`

## Safety

- Allowed read-only commands: `<safe-read-only-commands>`
- Forbidden deploy or infra actions: `<forbidden-actions>`
- Approval-required actions: `<approval-boundaries>`
- Safe environments, if any: `<allowed-environments>`
- Forbidden environments, if any: `<forbidden-environments>`

## Git

- Branching model: `<branching-model>`
- Push policy: `<allowed | on-request | forbidden>`
- PR policy: `<required | optional | forbidden>`

## Optional

- Upgrade triggers already known: `<trigger-list>`
- Existing docs to link: `<doc-list>`
