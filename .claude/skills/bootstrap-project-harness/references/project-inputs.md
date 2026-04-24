# Project Inputs

Collect these before instantiating a project harness. Use placeholders for unknowns.

## Identity

- Project name: `<project-name>`
- System type: `<web-app | backend-service | infra-repo | monorepo | mobile | other>`
- Primary runtime surfaces: `<surface-list>`

## Task system

- Task source of truth: `<tool-or-system>`
- Read command/API: `<read-interface>`
- Update command/API: `<write-interface>`
- Plan storage location: `<plan-location>`
- Notes storage location: `<notes-location>`
- Completion mechanism: `<completion-location>`

## Risk and review

- High-risk domains: `<risk-domain-list>`
- Review required when: `<review-thresholds>`
- Break-down required when: `<extra-high-thresholds>`

## Testing

- Default targeted test commands: `<targeted-test-commands>`
- Broader suite commands: `<broader-suite-commands>`
- E2E/integration workflow: `<e2e-workflow>`
- Manual verification rules: `<manual-verification-rules>`

## Deployment

- Platform/provider: `<platform>`
- Safe read-only commands: `<safe-commands>`
- Restricted commands: `<restricted-commands>`
- Forbidden commands: `<forbidden-commands>`
- Deploy trigger surfaces: `<deploy-trigger-surfaces>`
- Rollout workflow: `<rollout-workflow>`
- Required deploy identity/profile/project/account/workspace: `<deploy-identity-context>`
- Forbidden environment values: `<forbidden-environment-values>`
- Allowed non-prod environment values: `<allowed-environment-values>`
- Environment-determining variable names or config keys: `<environment-context-keys>`

## Observability

- Logging backend: `<logging-backend>`
- Local log surfaces: `<local-log-files-or-process-logs>`
- Remote log entry-point sources: `<remote-entry-point-sources>`
- Remote branchable sources: `<remote-branchable-sources>`
- Preferred log mode: `<local | remote | both>`
- Diagnostic command/tool: `<diagnostic-command>`
- Targeted query command/tool: `<query-command>`
- Remote adapter command or script: `<remote-adapter-command-or-script>`
- Primary identifiers: `<request-identifiers>`
- Known blind spots: `<observability-gaps>`

## Hooks And Guard Scripts

- Hooked actions to block or validate: `<hooked-actions>`
- Editable guidance paths and approval rules: `<guidance-edit-rules>`
- Deploy-context guard script: `<guard-deploy-context-script>`
- Cloud identity/profile guard script: `<guard-cloud-identity-script>`
- Task-interface guard script: `<guard-task-interface-script>`
- Log remote adapter script: `<log-remote-adapter-script>`
- Hook integration points: `<hook-integration-points>`

## Settings Files

- Shared settings file needed: `<yes|no>`
- Local settings file needed: `<yes|no>`
- Shared settings values: `<shared-settings-values>`
- Local settings values: `<local-settings-values>`
- Values that must never appear in shared settings: `<forbidden-shared-settings-values>`

## Git

- Branching model: `<branching-model>`
- Commit convention: `<commit-convention>`
- Push policy: `<push-policy>`
- PR policy: `<pr-policy>`

## Architecture docs

- Existing architecture docs: `<doc-list>`
- Ontology/system map docs: `<doc-list>`
- Missing docs to create: `<doc-list>`

## Optional project-specific skills

List only recurring workflows that deserve dedicated skills:
- `<skill-candidate-1>`
- `<skill-candidate-2>`
