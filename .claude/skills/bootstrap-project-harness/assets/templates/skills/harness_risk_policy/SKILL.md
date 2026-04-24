---
name: harness-risk-policy
description: Project-local risk policy for the harness. Defines how intake classifies task risk, when work must be broken down, and when architecture or independent review becomes mandatory.
---

# Harness Risk Policy

Use this skill when task-intake, coordinator, or review routing needs project-specific risk classification.

## Purpose

The core harness only assumes that:
- tasks should be classified by delivery risk before implementation
- some risk levels should trigger extra planning, review, or blocking
- projects define their own hotspots and thresholds

## Template Risk Model

Apply project-local rules in order. First match wins.

### Extra High

- `<broad-cross-system-change-threshold>`
- `<shared-contract-or-schema-threshold>`
- `<new-platform-or-runtime-threshold>`

Result:
- block implementation
- require task breakdown before coding

### High

- `<security-or-policy-risk-domains>`
- `<sensitive-operations-risk-domains>`
- `<cross-system-integration-threshold>`

Result:
- planner should consider architecture help
- coordinator should consider independent review

### Medium

- `<moderate-scope-threshold>`
- `<new-surface-area-threshold>`
- `<public-behavior-change-threshold>`

### Low

- `<small-scope-threshold>`
- `<non-sensitive-change-threshold>`

## Recording Requirement

Persist the chosen risk level and the trigger that matched in the task system.

## Customization Checklist

Replace the placeholders with the project's actual hotspots and thresholds.
