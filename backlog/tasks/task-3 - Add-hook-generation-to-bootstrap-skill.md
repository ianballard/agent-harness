---
id: TASK-3
title: Add hook generation to bootstrap skill
status: Done
assignee: []
created_date: '2026-04-26 17:18'
updated_date: '2026-04-26 17:22'
labels: []
dependencies: []
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Update the bootstrap-project-harness skill so it generates both Claude hook wiring and versioned git hooks as first-class bootstrap outputs, including settings.local absolute hook paths and hook documentation.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Add hook templates and installation assets to the bootstrap bundle
- [x] #2 Update bootstrap references and workflow docs so hooks are mandatory materialized outputs
- [x] #3 Use absolute paths for Claude hook commands in settings.local templates
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Inspect bootstrap skill gaps around hook generation\n2. Add hook templates and installer assets to the bundle\n3. Update materialization docs and settings templates to require Claude and git hook outputs\n4. Validate template scripts and JSON
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Updated bootstrap-project-harness so hooks are first-class outputs. Added versioned .githooks templates, Claude hook template scripts, an install_githooks helper, a hooks harness doc template, and settings.local absolute-path hook wiring guidance.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Bootstrap skill now materializes both Claude hook wiring and repo-versioned git hooks, with Claude hook commands rendered in settings.local.json using absolute repository-rooted paths. Updated the workflow docs, materialization map, output map, project inputs, and question bank so future bootstrap runs treat hooks as required outputs instead of implied follow-up work.
<!-- SECTION:FINAL_SUMMARY:END -->
