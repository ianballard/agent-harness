# Question Bank

Use this as a required interview checklist. Ask every section. Do not skip sections because the repository "looks obvious."

If the human does not know an answer, record:
- `UNRESOLVED`
- a placeholder value
- whether bootstrapping should stop or continue with placeholders

## 1. Project Identity

1. What is the project name?
2. What kind of system is this?
3. What are the main runtime surfaces or components?
4. Is this a single service, monorepo, multi-service system, or something else?
5. Which parts of the repository are in scope for the harness?

## 2. Task System

1. What is the source of truth for tasks?
2. How should an agent read a task?
3. How should an agent claim or assign a task?
4. Where should plans be stored?
5. Where should implementation notes be stored?
6. How are acceptance criteria tracked?
7. How is a task marked complete?
8. Are agents allowed to edit task artifacts directly, or only through a tool/API?
9. What should happen if there is no task record yet?

## 3. Risk And Review

1. Which domains are high risk in this project?
2. Which changes must be broken down before implementation?
3. Which changes require architecture help?
4. Which changes require independent review?
5. Which changes can be treated as low risk?
6. Are there any absolute risk stop-conditions?

## 4. Testing

1. What are the default targeted test commands?
2. What broader test suites exist?
3. When is e2e required?
4. When is integration testing required?
5. When is manual verification acceptable?
6. How should blocked or skipped verification be reported?
7. Are there any expensive tests with budgets or retry rules?

## 5. E2E Deployment Matrix

1. Which categories of changes can run e2e locally with no deploy?
2. Which categories require deployment before e2e?
3. Which categories can use mocks or local integrations instead of deployment?
4. Are there environments reserved for e2e?
5. Are deploy-before-e2e actions always allowed, conditionally allowed, or forbidden?

## 6. Deployment Policy

1. What deployment platform or provider is used?
2. Which deployment or infrastructure commands are always safe?
3. Which commands are conditionally allowed?
4. Which commands are never allowed?
5. Which environments are allowed for agent-driven deployment?
6. Which environments are forbidden?
7. What approvals are required before rollout actions?
8. What scope-limiting rules apply to deploy actions?
9. Are there required identities, profiles, projects, subscriptions, accounts, or workspaces?

## 7. Deployment Workflow

1. What artifacts must be built or packaged?
2. What commands build those artifacts?
3. Does the workflow depend on commit SHA, tag, or version naming?
4. Is a pre-deploy commit required?
5. What rollout steps happen after artifact creation?
6. What smoke tests or post-deploy checks are required?
7. How should failed deploy attempts interact with commits or versioned artifacts?

## 8. Observability

1. Does the project rely on local logs, remote logs, or both?
2. What are the local log paths or process log surfaces?
3. What is the remote logging backend?
4. What are the narrow remote entry-point sources?
5. What downstream sources may be queried after fanout?
6. What identifiers are available for request tracing?
7. What time scoping is usually required?
8. What command or adapter should remote log queries use?
9. What observability blind spots or missing coverage exist?

## 9. Git Workflow

1. What branching model does the team use?
2. What commit message convention is required?
3. Are agents allowed to amend commits?
4. Are agents allowed to push?
5. Are PRs required, optional, or forbidden for this harness flow?
6. Are there merge-guard or branch-base rules for closeout?
7. Are signed commits or other git constraints required?

## 10. Hooks And Guard Scripts

1. Which actions must be blocked by hooks or helper scripts?
2. Which project-wide AI guidance files are editable, and under what approval rules?
3. Which infrastructure environments must always be blocked?
4. Which identities, profiles, projects, accounts, subscriptions, or workspaces are required?
5. Which variable names or config keys determine environment or deployment context?
6. What values indicate production or otherwise forbidden targets?
7. What values indicate safe sandbox/dev/test targets?
8. Which commands need context validation before they can run?
9. Should the harness generate helper scripts for deployment-context checks, cloud-identity checks, task-interface checks, or remote-log adapters?
10. Which Claude hook events and matchers should be wired in local settings?
11. Which git hooks should be generated as versioned repo files?
12. Where should those scripts and hooks live, and how should Claude hooks and git hooks call them?
13. Where should audit logs for hook activity be written?

## 11. Settings Files

1. Does the destination project need `.claude/settings.json`, `.claude/settings.local.json`, both, or neither?
2. Which values should live in shared settings versus local-only settings?
3. Should settings include task-system identifiers, logging mode, remote adapter wiring, deploy-context keys, or cloud identity defaults?
4. Should Claude hooks live in shared settings or local settings? If local, confirm that hook commands should use absolute script paths rooted at the project.
5. Which values must never be materialized into shared settings?
6. Should bootstrap create settings files immediately or leave template placeholders?

## 12. Architecture And Docs

1. What architecture docs already exist?
2. What ontology/system-map docs already exist?
3. Which docs should the harness link to?
4. Which docs are missing and should be created as part of bootstrap?

## 13. Platform-Specific Skills

1. Which recurring workflows deserve dedicated project-specific skills?
2. Which domains are too bulky for the generic harness and should live in docs instead?
3. Which platform-specific skills already exist and should be referenced?

## 14. Output Preferences

1. Should bootstrap stop when required answers are unresolved, or continue with placeholders?
2. Which sections must never contain placeholders?
3. Should helper scripts be generated immediately or only scaffolded with placeholders?
4. Should project-local docs be created immediately or only referenced for later completion?
