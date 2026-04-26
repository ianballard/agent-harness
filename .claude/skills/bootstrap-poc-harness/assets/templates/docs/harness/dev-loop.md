# POC Dev Loop

This harness is optimized for rapid development and learning.

## Principles

- Prefer short iteration loops over process ceremony.
- Make the smallest change that proves progress.
- Keep validation proportional to the risk and maturity of the repository.
- Surface shortcuts and debt explicitly.

## Default Implementation Loop

1. Read the local context needed for the request.
2. Implement the smallest useful change.
3. Run the cheapest meaningful validation.
4. Report what changed, what was validated, and what remains risky.

## When To Upgrade

Consider moving to the full harness when:

- multiple contributors or agents work in parallel
- deployment or infrastructure changes become common
- regressions recur often enough that stronger guardrails save time
- the team needs durable task tracking, review gates, or auditability
