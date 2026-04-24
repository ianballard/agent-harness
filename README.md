# Agent Harness

## Purpose

This document captures the agent harness pattern used in this
repository so another LLM or team can use it as a starting point when
initializing a new project. It focuses on the instruction layer rather than
the deterministic Python harness or repo-specific implementation details.

The core idea is simple:

- `CLAUDE.md` is the project operating contract.
- Hooks and deny rules enforce hard boundaries.
- Agents own distinct parts of the SDLC.
- Skills package reusable workflows that agents call into.
- Task state lives outside the model in a backlog system.
- Deployment, testing, and git behavior are explicit, not implied.

This is not meant to be copied verbatim into every project. It is a scaffold
for designing a project-specific harness with clear roles, safe defaults, and
enforceable constraints.

## Mental Model

Treat the harness as layered defense plus structured delegation.

Layer 1 is natural-language policy:

- Tell the model what the project is.
- Tell it which workflows exist.
- Tell it what is forbidden.
- Tell it where state lives.
- Tell it how to ask for or perform work.

Layer 2 is executable enforcement:

- Hooks block forbidden commands or files.
- Sandbox boundaries constrain what can be read or written.
- Required environment variables gate sensitive self-modification.
- Integrity checks detect drift in guidance artifacts.

Layer 3 is SDLC structure:

- A coordinator decides stage order.
- Specialized agents handle intake, planning, coding, review, and closeout.
- Skills provide reusable instructions for recurring tasks.
- Tools provide the actual execution surface.

The goal is not to trust the LLM less. The goal is to make trust unnecessary
for the highest-risk decisions.

## `CLAUDE.md` As The Jumping-Off Point

In this pattern, `CLAUDE.md` is the first project-local file the agent should
read to understand how to operate in the repository. It should answer six
questions quickly:

1. What kind of system is this?
2. What workflows are mandatory here?
3. What agents and skills exist?
4. Where does task state live?
5. What commands and deployment actions are off-limits?
6. What project guidance can and cannot be edited?

Good `CLAUDE.md` content is thin, directive, and index-like. It should point to
skills and agent definitions rather than duplicating their full procedures.

A strong `CLAUDE.md` usually contains:

- A short ontology or architecture orientation section.
- Pointers to memory or prior-session context mechanisms.
- The primary routing skill, such as `coordinate`.
- The main agent roles and what each role owns.
- Backlog/task-management rules.
- Deployment guardrails.
- Git and staging rules.
- Safety constraints and prohibited commands.
- Rules for editing project guidance itself.

The main design rule is that `CLAUDE.md` should define the operating system,
not every task-specific behavior.

## Layered Defense

### 1. Natural-Language Boundaries

The first boundary is explicit instruction:

- never deploy to production without explicit approval
- never push to remote unless asked
- never bypass hooks
- never edit guidance files without approval
- never perform destructive file or git operations
- always use the task system instead of editing task files manually

These rules should be concrete enough to be testable.

### 2. Hooks As Enforcement

Hooks should backstop the natural-language rules. Their job is to prevent,
audit, or require confirmation for high-risk actions.

Examples:

- Block edits to `hooks/`, settings files, or global instruction files.
- Require an approval env var before editing agent or skill definitions.
- Reject dangerous git commands and destructive shell commands.
- Enforce explicit staging instead of broad `git add` patterns.
- Require cloud/account/profile flags for infrastructure commands.
- Run integrity checks after agent or skill changes.

Hooks should assume the model will eventually make a mistake. That is normal.
The harness is stronger when the mistake is harmless.

### 3. Auditing And Traceability

A good harness leaves evidence:

- backlog tasks record plan, status, and completion notes
- implementation notes capture what changed and why
- review stages record blocking issues
- hooks log actions
- closeout writes a final task outcome in a stable format

This matters because the next LLM or human should be able to reconstruct what
happened without relying on chat history alone.

## Agents As SDLC Roles

The most effective pattern is to scope agents by responsibility rather than by
technology stack.

Typical roles:

- `coordinator`: routes the task through the lifecycle
- `task-intake`: checks task clarity, scope, and acceptance criteria
- `code-architect`: optional planning/research role for complex changes
- `coder`: implements the approved task, verifies, and prepares commit output
- `code-reviewer`: optional independent review for risky changes
- `task-closeout`: verifies completion and emits final task status

The coordinator is the conductor, not the main implementer. It should dispatch
other roles in a predictable order and avoid doing deep implementation work
itself.

Each agent should have:

- a narrow mission
- a clear input contract
- a clear output contract
- explicit ownership boundaries
- known escalation paths when blocked

This avoids the common failure mode where one general-purpose agent tries to do
planning, coding, deployment, review, and task management in one loop.

## Skills As Reusable Procedures

Skills are the reusable building blocks under the agents. Agents should point
to skills for repeatable workflows instead of embedding every procedure inline.

Examples from this pattern:

- coordinator dispatch skills for intake, coder, review, and closeout
- coder skills for discovery, implementation, tests, deployment, notes, and
  commit preparation
- task-management skills for interacting with Backlog.md
- domain-specific skills for logs, cloud changes, ontology mapping, or
  outbound identity tooling

A good skill is appropriate when:

- the workflow recurs across tasks
- there is a stable checklist or decision tree
- the project benefits from consistent execution

A bad skill is one that encodes one-off task detail that should have stayed in
the task itself.

## Tool Usage Model

The harness should make tool use explicit. Models perform better when they know
which tool to prefer and when.

Examples of useful tool policy:

- prefer `rg` for search
- use a patch tool for file edits
- use task CLI commands rather than editing task artifacts directly
- use official cloud or vendor docs for sensitive infrastructure work
- request escalation instead of trying to work around sandbox failures
- use parallel reads for exploration when safe

The important design choice is that tools are part of the contract. They are
not just capabilities floating in the environment.

## Task State With Backlog.md

A strong harness keeps work state outside the model context window.

In this repository, the rule is:

- use the `backlog` CLI
- never hand-edit task files

That pattern generalizes well. Whatever task system you use, the harness should
specify:

- how tasks are claimed
- how acceptance criteria are read
- where plans and implementation notes live
- how blocked states are recorded
- how completion is marked

This is critical because multi-agent work falls apart when state lives only in
conversation.

A generic stage model looks like this:

1. Intake validates the task definition.
2. Planning decides the approach and whether architecture help is needed.
3. Implementation executes scoped changes.
4. Verification runs the expected tests.
5. Review checks for regressions or policy issues when required.
6. Closeout records the final outcome back into the task system.

## Deployment And Off-Limits Actions

Deployment rules must be explicit and project-local. They are one of the worst
things to leave implicit.

This harness pattern uses three categories:

- always allowed
- allowed only with conditions
- never allowed

Examples:

- `terraform validate` or `plan` may be generally allowed
- non-prod apply may require explicit request plus scope-limited targeting
- prod apply or destroy may be completely forbidden
- push to remote may require explicit user request

The same structure works whether the project uses AWS, GCP, Azure, Kubernetes,
Vercel, or something else. What changes is the policy detail:

- account/project selection
- environment names
- deployment tooling
- rollout and rollback rules
- approval paths

Do not bury this in a deployment doc alone. Put the top-level constraints in
`CLAUDE.md`, then point to deeper runbooks as needed.

## Git Strategy

Git behavior should also be codified as harness policy.

Useful rules include:

- never discard unrelated user changes
- never use destructive reset or clean operations
- stage files explicitly
- do not amend commits unless asked
- do not push unless asked
- prefer non-interactive git commands

These sound basic, but they materially reduce damage in collaborative sessions.

This part is highly customizable. Different projects may prefer:

- direct commits on a feature branch
- stacked branches
- worktrees per task
- mandatory draft PRs
- squash-only histories

The harness should reflect the real team workflow rather than generic git
advice.

## Testing Strategy

Testing should be stage-aware, not left to agent improvisation.

For example:

- unit tests are expected for scoped logic changes
- e2e tests run only for workflows that cross system boundaries
- frontend changes may require visual or browser verification
- infrastructure changes may require deployment before testing

The harness should tell the agent:

- which tests are expected by default
- when it is acceptable not to run them
- how to report unrun or blocked verification

A reusable harness is stronger when it treats verification as part of the SDLC
contract, not as optional polish.

## Guidance Artifacts Should Be Self-Protecting

One of the strongest patterns in this repository is treating guidance files as
high-risk configuration.

That means:

- changing `CLAUDE.md`, agents, or skills requires explicit human approval
- some guidance paths are always off-limits
- integrity baseline updates happen after approved guidance edits

This matters because once an agent can freely rewrite its own operating rules,
the rest of the harness becomes much weaker.

For a new project, decide early:

- which guidance artifacts are editable
- who can approve those edits
- what automated checks should run afterward

## What To Customize Per Project

The pattern is portable, but the details are not. A new project should
customize at least these areas:

- task system: Backlog.md, Jira, Linear, GitHub Issues, or something internal
- git workflow: branching, worktrees, commit style, PR rules
- cloud provider: AWS, GCP, Azure, on-prem, or hybrid
- deployment policy: dev/staging/prod rules, approvals, rollout shape
- architecture map: services, repos, runtime boundaries, ownership
- testing strategy: unit/integration/e2e/manual acceptance expectations
- risk hotspots: auth, payments, infra, migrations, secrets, data deletion
- tool preferences: search, edit, test, build, and documentation tools
- review policy: when independent review is mandatory vs optional
- memory strategy: what session memory exists and how durable learnings are
  promoted

Do not copy another project's constraints blindly. Use the same categories, but
replace the policy contents.

## A Minimal Bootstrap Recipe

If another LLM were setting up a similar harness from scratch, a practical
starting sequence would be:

1. Write a thin `CLAUDE.md` that defines project identity, task system,
   deployment constraints, git constraints, and available agents/skills.
2. Define the main SDLC agents with narrow roles and stable output contracts.
3. Extract repeatable procedures into skills instead of duplicating them across
   agents.
4. Add hooks for the highest-risk actions first: destructive shell commands,
   dangerous git actions, sensitive guidance edits, and production deploys.
5. Choose a task system and require all task state transitions to go through
   that system.
6. Document test expectations and deployment boundaries in the harness, not
   only in team lore.
7. Add auditing artifacts so plans, blocked states, and closeout outcomes are
   reconstructible later.
8. Iterate only after observing real failure modes from actual tasks.

## Anti-Patterns

Avoid these common mistakes:

- one giant agent prompt that mixes coordination, coding, review, and deploy
- purely advisory safety rules with no hook enforcement
- storing all task state in chat instead of a task system
- making the model guess whether deploys are allowed
- letting the model rewrite its own guardrails without approval
- adding many skills before the workflows are actually recurring
- documenting tool availability without documenting tool preference

## Bottom Line

The gist is not "add agents." The gist is to give the model a project-local
operating system:

- `CLAUDE.md` explains how the project works.
- hooks enforce what must not happen.
- agents split the SDLC into scoped roles.
- skills capture repeatable procedures.
- tools are used according to policy.
- the task system holds durable state.
- deploy and git behavior are explicit.

If you preserve those ideas and customize the project-specific seams, another
project can adopt this pattern without inheriting this repository's exact
stack, workflow, or constraints.
