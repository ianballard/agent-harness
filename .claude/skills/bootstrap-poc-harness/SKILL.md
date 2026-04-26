---
name: bootstrap-poc-harness
description: Scaffold a lightweight project harness for rapid POCs and early-stage repositories using one main implementation path, minimal policy surface, and explicit safety rails.
---

# Bootstrap POC Harness

Use this skill when a repository needs a thin harness for rapid development rather than the full coordinator-driven factory pattern.

## Goal

Instantiate a project-specific POC harness with these defaults:
- one main implementation path
- minimal ceremony
- lightweight task handling when tasks exist
- explicit git, testing, and deployment safety rules
- a documented upgrade path to the full harness

Do not turn the POC scaffold into a disguised copy of the full factory harness.

## Required Workflow

Follow this sequence.

1. Inspect the target repository's existing context:
   - read `README.md` if present
   - read `CLAUDE.md` if present
   - inspect obvious run/test docs that materially affect the developer loop
2. Run a short human interview using `references/question-bank.md`.
3. Normalize the answers into the structure in `references/project-inputs.md`.
4. Identify unresolved items:
   - mark them as `UNRESOLVED`
   - decide whether bootstrap can continue safely with placeholders
   - stop if deployment or environment mutation boundaries are unclear
5. Materialize the target project files using:
   - `references/materialization-map.md`
   - `references/output-map.md`
   - bundled templates under `assets/templates/`
6. Summarize what was generated, what was intentionally omitted, and which signals should trigger migration to the full harness.

## Hard Rules

- Keep the scaffold intentionally small.
- Do not generate coordinator, intake, closeout, hook, settings, or integrity machinery unless the human explicitly asks for it.
- If the repo has a lightweight task workflow, capture it tersely without forcing the full task-system policy surface.
- Do not infer deployment permissions, cloud identities, or environment mutation rules.
- Do not generate bulky workflow docs unless they are directly needed for the fast dev loop.
- Prefer one implementation skill or agent over multi-agent decomposition.
- Keep repo-specific detail in the project policy skills or the short harness doc, not in generic instructions.

## What To Read First

1. Read the target project's current `README.md` if it exists.
2. Read the target project's current `CLAUDE.md` if it exists.
3. Read the bundled templates under `assets/templates/`.
4. Read [project-inputs.md](references/project-inputs.md).
5. Read [question-bank.md](references/question-bank.md).
6. Read [materialization-map.md](references/materialization-map.md).
7. Read [output-map.md](references/output-map.md).

## Interview Execution

Use `references/question-bank.md` as a concise checklist.

- Keep the interview short.
- Confirm repo evidence when it is obvious instead of re-asking from scratch.
- Record unresolved items explicitly.
- Stop and ask the human if a missing answer would weaken deployment or git safety beyond a reasonable assumption.

## Materialization Standard

When generating the target harness:

- Use the bundled templates as source material, not final output verbatim.
- Replace placeholders with interview answers where known.
- Omit files intentionally when they are unnecessary.
- Keep `CLAUDE.md` short and directive.
- Generate only the lightweight runtime files from the materialization map.
- Reflect the repository's real definition of done, including whether review, commit, or PR steps are expected.
- Include a clear upgrade path to the full harness.
