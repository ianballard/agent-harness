---
name: capture-durable-learnings
description: >-
  When and how to promote material lessons into CLAUDE.md, skills, agents, or
  product docs — including user corrections of assistant mistakes. Requires
  explicit human approval and hook rules for .claude/agents and .claude/skills.
---

# Capture durable project learnings

Read **`CLAUDE.md`** (Safety Constraints → **Project guidance edits**) before editing any guidance file. This skill does not override those rules.

## When to suggest a new skill or agent (not only corrections)

**Proactively suggest** creating or extending project guidance when:

- The same **multi-step procedure** has been explained or executed more than once and will likely recur (document as a skill; avoid pasting the same wall of steps into every thread).
- A **stable policy or checklist** applies to a whole class of work (e.g. a subsystem, integration, or compliance step) and does not belong only in one backlog task.
- A **dedicated agent role** would reduce confusion (clear tools, clear handoff) compared to overloaded instructions in `coordinator.md` or the main session.

**If the human agrees**, create or edit **`.claude/skills/<name>/SKILL.md`** or **`.claude/agents/<role>.md`**, then:

1. **Update `CLAUDE.md`** — add a one-line reference in the right section (Agents, Implementation routing, or “New skills, agents, and CLAUDE.md references”) so the artifact is indexed.
2. Run **`bash scripts/update-integrity-baseline.sh`** after agent or skill file changes.

Still require **explicit approval** for the exact content and paths before applying, per `CLAUDE.md` (Project guidance edits). Prefer the **`skill-creator`** plugin when authoring skills.

## When to offer capture

**Proactively offer** to record a lesson when:

- The human **explicitly says the assistant was wrong** (incorrect assumption, bad edit, missed constraint, wrong file, unsafe suggestion, or misread requirements). Treat this as **high priority**: acknowledge, correct behavior in the thread, then **offer** a durable fix (usually **`CLAUDE.md`** or a **skill**) so the same mistake is less likely next time.
- Something **material** went wrong and was fixed (root cause understood).
- The human agrees a **lasting rule** for this repo (“always do it this way here”).
- A **rejected approach** should not be repeated.

Hooks append episodic context to **`.claude/memories.md`**. Use the layers below when the lesson should **outlive** one thread and stay **easy to find**.

## Target paths (only after explicit approval)

- **`CLAUDE.md`** — project-wide instructions and pointers.
- **`.claude/skills/<skill-name>/SKILL.md`** — procedural “how we do X” content (this file is an example).
- **`.claude/agents/<role>.md`** — coordinator/coder (or other) persona and loop rules.
- **`README.md`** or **`2026-03-21-ai-platform-v5-design.md`** — durable product/architecture facts that belong in human-facing docs, not only in agent instructions.

**Never** as part of “learning” edits: **`.claude/settings*`**, **`.claude/hooks/`**, **`.pre-commit-config.yaml`** (see `CLAUDE.md`).
                                                                                                                                                                             
## Post-task reflection mode (proactive, lower urgency)
                                                                                                                                          
This mode is triggered by the **coordinator** at Step 10.5 after a task completes — not by a human correction. The bar is higher than     
reactive mode because there is no explicit user signal.                                                                                   
                                                                                                                                          
### Signals that warrant reflection
- Coder was blocked or required a second dispatch
- Plan scope broadened after implementation started (wrong file, stale ontology, missing integration)
- A tool call was denied or blocked by a hook during the run                                                                              
- An assumption stated in the plan proved incorrect
                                                                                                                                          
### Hard filter — both conditions must be true
1. **High confidence**: the pattern is clear and unambiguous, not a one-off                                                               
2. **Recurring or safety-adjacent**: the same class of mistake could recur across future tasks, OR it touches IAM, secrets, scope         
guardrails, or hook behavior                                                                                                              
                                                                                                                                          
If either condition is not met, do not surface a proposal. Log `REFLECTION: no high-confidence learnings to surface` and move on.         
                          
### Proposal format                                                                                                                       
When the filter passes, output exactly one proposal per run:
                                                                                                                                          
LEARNING PROPOSAL:
Signal:                                                                                                                                   
Rule: <one sentence — what to do instead>
Target:
Proposed text:

Do not apply. Wait for explicit human approval before touching any file.
                                                                                                                                          
### Distinction from reactive mode                                                                                                        
| Mode | Trigger | Urgency | Bar |                                                                                                        
|------|---------|---------|-----|                                                                                                        
| Reactive | Human correction | High — acknowledge immediately | Lower: human signal is explicit |
| Proactive | Factory reflection | Low — proposal only | Higher: must pass both filter conditions |                                       
                                          

## Kinds of learning → typical destination

| Kind | Typical destination |
|------|---------------------|
| **User correction** (“you shouldn’t have…”, “wrong because…”) | **`CLAUDE.md`** (short invariant or pointer) or **existing/new skill** if the fix is a repeatable procedure |
| **Invariant or policy** (safety, terraform scope, “never do X here”) | **`CLAUDE.md`** — short bullet or pointer to README/spec |
| **Repeatable workflow** (commands, checklist, backlog/terraform/MCP usage) | **`.claude/skills/<name>/SKILL.md`** |
| **Factory / agent behavior** (coordinator vs coder boundaries, loop etiquette) | **`.claude/agents/<role>.md`** |
| **Stable system fact** (where a component lives, env vars, ownership) | **README** or **design doc** if product-facing; else **one-line pointer in `CLAUDE.md`** |

## Usually do not promote

Keep in chat or rely on hooks for: one-off task details, raw debugging transcripts, secrets, or text already duplicated verbatim in README/design docs (unless correcting accuracy).

## Workflow

1. State the learning in **one sentence** (for user corrections, include **what was wrong** and **what to do instead**).
2. Name the **target file** and show the **exact** text or diff you would apply.
3. Wait for **explicit human approval** for that file.
4. Apply per **`CLAUDE.md`**: for **`.claude/agents/`** and **`.claude/skills/`**, the session needs **`CLAUDE_APPROVED_PROJECT_GUIDANCE_EDIT=1`** in the environment (self-modify hook).

Prefer **propose → review → apply**. Do not silently weaken safety rules or remove invariant constraints.
