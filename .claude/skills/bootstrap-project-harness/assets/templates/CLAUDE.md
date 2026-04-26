# CLAUDE.md

## Main Skill
- `coordinate` - coordinator; task lifecycle, agent dispatch order, and closeout

### Agents

- `agents/coder.md` (or `coder.toml`, if codex) — implementer; reads the approved plan from the task system, writes code, verifies, and commits
- `code-architect` — optional planning/research role; dispatched only when the run requires deeper implementation design
- `code-reviewer` — optional independent review role; dispatched only when requested or when project-local risk policy requires it

Coordinator and coder step bodies are extracted into per-stage skills under **`skills/coordinator_*`** and **`skills/coder_*`**. Keep those stage skills generic. Put project-local behavior in customization skills or project docs that the stage skills link to.

> **Note:** `agents/` YAML (`name: coder`) defines spawnable agents where Claude Code or Codex exposes them. Plugin agents are invoked by name on the Agent tool.

### Project Customization Skills

These skills are the project-local customization layer for the generic harness. In a bootstrap harness, keep these as templates with placeholders until a concrete project fills them in.

- `skills/project_policy_task_system/SKILL.md` — how tasks are selected, read, updated, and completed
- `skills/project_policy_risk/SKILL.md` — task-risk classification, escalation triggers, and review thresholds
- `skills/project_policy_testing/SKILL.md` — default verification strategy and when to broaden validation
- `skills/project_policy_deployment/SKILL.md` — environment rules, deployment gates, and infrastructure safety constraints
- `skills/project_workflow_deployment/SKILL.md` — concrete packaging, build, publish, and rollout workflow
- `skills/project_workflow_observability/SKILL.md` — logging architecture and failure-diagnosis workflow
- `skills/project_policy_git/SKILL.md` — staging, commit, branch, and push behavior

Optional project-local skills may also exist for:
- architecture or ontology context
- harness bootstrap or instantiation workflow
- platform-specific implementation guidance
- task-system integration details
- e2e workflow details
- review policy details

### Task Refinement

Use `skills/task_refinement_interview/SKILL.md` when task-intake determines that the task definition is too vague to implement safely.

### Session Memory

When needed, use `skills/read_session_memories/SKILL.md` to retrieve context from prior sessions. To promote recurring lessons into durable guidance, use `skills/capture_durable_learnings/SKILL.md`.

### Adding Skills And Agents

- Prefer a new skill when a repeatable workflow or decision tree recurs across tasks.
- Prefer a new agent only when a distinct sub-role needs its own tools, model, or loop.
- After adding or substantially changing a skill or agent, update `CLAUDE.md` so it remains discoverable.
- Run `bash scripts/update-integrity-baseline.sh` after any change under `.claude/agents/` or `.claude/skills/`.
- Follow the approved-guidance-edit rule before modifying `CLAUDE.md`, `.claude/agents/`, or `.claude/skills/`.

## Prohibited Commands

- Never run destructive infrastructure or rollout commands unless the project-local deployment policy explicitly allows them.
- Never push to remote unless explicitly asked.
- Never infer provider, environment, profile, workspace, or account defaults; use the configured project policy or stop.

## Safety Constraints

All agents and interactive sessions must follow these rules. They are enforced by hooks and deny lists, but agents must also respect them at the prompt level.

- **No destructive operations:** Never run irreversible shell or git commands unless explicitly approved.
- **No secret exposure:** Never print, commit, or exfiltrate secrets.
- **No data exfiltration:** Never send code or data to external URLs unless the task explicitly requires an approved integration.
- **No scope creep:** Never modify files outside the approved task scope without updating the plan first.
- **Project guidance edits (approved only):** Do not change project-wide AI instructions unless the human explicitly approves the exact change in this conversation. Applies to `CLAUDE.md`, `.claude/agents/*.md`, and `.claude/skills/**/SKILL.md`.
- **No hook circumvention:** If a command is blocked by a hook, do not attempt workarounds.
- **Explicit staging only:** Never use broad staging commands like `git add -A` or `git add .`.
- **No --no-verify:** Never bypass pre-commit hooks with `--no-verify`.

## Claude Code Configuration

Experimental agent teams may be enabled in a concrete harness instance. Plugin availability is also project-local. Keep the generic harness free of provider-specific or architecture-specific assumptions.
