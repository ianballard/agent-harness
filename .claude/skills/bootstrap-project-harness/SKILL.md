---
name: bootstrap-project-harness
description: Bootstrap a project-specific agent harness from the generic harness template in this repository. Use when creating or adapting a project's CLAUDE.md, generic SDLC agents, customization skills, and companion docs without leaking project-specific details into the core stage skills.
---

# Bootstrap Project Harness

Use this skill when a repository needs its own harness based on the generic pattern in this repo.

## Goal

Instantiate a project-specific harness while preserving this rule:
- core SDLC agents and stage skills stay generic
- project-specific details live in customization skills or linked docs

Do not turn the base coordinator/coder/task-stage skills into architecture- or provider-specific instructions.

## What to read first

1. Read the target project's current `CLAUDE.md` if it exists.
2. Read the bundled generic templates under `assets/templates/`:
   - `assets/templates/CLAUDE.md`
   - `assets/templates/agents/`
   - `assets/templates/skills/`
   - `assets/templates/scripts/`
   - `assets/templates/docs/harness/`
   - `assets/templates/settings/`
3. Read [project-inputs.md](references/project-inputs.md).
4. Read [question-bank.md](references/question-bank.md).
5. Read [materialization-map.md](references/materialization-map.md).
6. Read [output-map.md](references/output-map.md).

## Workflow

### 1. Run the full human interview first

Treat this skill as a comprehensive interview workflow.

Use the full question bank in `references/question-bank.md`.

Requirements:
- ask every required question category
- do not skip categories because you think you can infer them
- do not instantiate the harness until the human has answered the required questions
- if the human does not know an answer, record an explicit placeholder instead of guessing

The interview must gather enough detail to instantiate:
- task-system policy
- risk policy
- testing policy
- deployment policy
- deployment workflow
- observability workflow
- git policy
- settings templates when the destination project needs shared or local Codex/Claude settings files
- hook/helper scripts
- companion docs
- any recurring project-specific skills

### 2. Normalize the answers into project inputs

Convert the interview output into the structure in `references/project-inputs.md`.

If an answer is missing:
- keep a placeholder
- mark the section as unresolved
- do not silently invent defaults for provider, environment, profile, branching, task system, hooks, or deployment behavior

### 3. Keep the generic layer clean

The following stay generic:
- `CLAUDE.md`
- coordinator/coder/task-stage agents
- `skills/coordinator_*`
- `skills/coder_*`

In the bundled factory, these generic files live under `assets/templates/` and
should be copied or rendered into project runtime paths during bootstrap.

These files may link to project-local skills or docs, but should not embed:
- provider names
- log backends
- task CLI commands
- test runner commands
- environment names
- architecture-specific file paths

### 4. Fill or create the customization layer

Put concrete project detail into:
- `skills/harness_*`
- project-local docs under a harness or operations doc area
- optional platform-specific skills
- generated helper scripts that enforce project-local guardrails

Use placeholders if the project has not yet decided something.

When observability is needed, decide whether to:
- keep using the generic `scripts/query_logs.sh` and `scripts/diagnose_error.sh`
- add a project-local remote adapter script
- add a project-specific observability doc or skill for backend-specific details

When hooks or enforcement scripts are needed, generate them from the interview answers rather than copying example-project values.

Use the bundled templates in `assets/templates/` as the source material for:
- project `CLAUDE.md`
- project `.claude/agents/*`
- project `.claude/skills/*`
- project `.claude/settings*.json` when the destination project needs them
- project `scripts/*`
- project harness docs

### 4b. Materialize the bundled factory into the target project

Create the target project's harness files from the bundled assets listed in
`references/materialization-map.md`.

Requirements:
- create the full base harness from the bundled assets
- replace placeholders using interview answers
- keep unresolved answers as explicit placeholders
- do not depend on the source repository's live files outside this skill bundle

### 5. Create companion docs when detail is too bulky

Prefer docs when the content is:
- long
- operational
- architecture-specific
- likely to change independently of the SDLC role prompts

Typical outputs:
- `docs/harness/task-system.md`
- `docs/harness/testing.md`
- `docs/harness/deployment.md`
- `docs/harness/observability.md`
- `docs/harness/architecture.md`

The generic skills should link to those docs rather than absorbing them.

### 6. Generate helper scripts from interview answers

Generate or update shell helpers when the project needs enforceable guardrails.

Typical generated outputs:
- `scripts/guard_deploy_context.sh`
- `scripts/guard_cloud_identity.sh`
- `scripts/log_remote_adapter.sh`
- `scripts/guard_task_interface.sh`
- `.claude/settings.json` when required
- `.claude/settings.local.json` when required

These scripts should be built from interview answers such as:
- forbidden environments
- allowed environments
- required cloud profile, account, project, or subscription
- required workspace, namespace, or cluster
- remote log backend adapter details
- task interface checks

Never hardcode example-project values like a specific Terraform variable, profile name, or cloud account unless the human supplied them in the interview.

### 7. Create optional project-specific skills only when needed

Create a dedicated project skill when:
- a platform/domain workflow recurs
- the workflow is fragile enough to need guardrails
- the detail would clutter the generic harness

Examples:
- `skills/project-task-system/SKILL.md`
- `skills/project-e2e-workflow/SKILL.md`
- `skills/project-platform-impl/SKILL.md`
- `skills/project-observability/SKILL.md`

### 8. Validate the split

Before finishing, check:
- core stage skills remain generic
- project-specific details exist somewhere discoverable
- placeholders remain where the project has not supplied facts
- no example-project details leaked into the generic layer
- any observability helper scripts are wired without hardcoding a backend into the generic layer
- any generated guard scripts reflect interview answers rather than copied example defaults
- any generated settings files reflect interview answers rather than copied example defaults

### 9. Finish

- Update `CLAUDE.md` so the instantiated skills/docs are discoverable.
- Run `bash scripts/update-integrity-baseline.sh` after skill/agent changes.

## Rules

- The interview is mandatory. Do not bootstrap from partial assumptions.
- Treat `assets/templates/` as the bundled source of truth for the factory.
- Use `references/materialization-map.md` to create the full base harness in the target project.
- Prefer placeholders over guessed project detail.
- Prefer links to docs over stuffing long detail into stage skills.
- Do not duplicate the same concrete policy in multiple files.
- Keep one level of indirection: generic skill -> project-local skill/doc.
- If a project-specific workflow is not actually recurring, keep it in docs, not a new skill.
