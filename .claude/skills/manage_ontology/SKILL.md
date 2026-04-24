---
name: manage-ontology
description: >- 
  Ontology is a structured map of components and how they connect (Cloud resources, permissions). Use this before multi-file or wiring-heavy implementation work
---

The [`ontology/`](ontology/) directory is a structured map of components and how they connect (Cloud resources, permissions). Read it **before** multi-file or wiring-heavy implementation work:

- [`ontology/components.yaml`](ontology/components.yaml) — what exists, file paths, Terraform resources, tests, packaging
- [`ontology/connections.yaml`](ontology/connections.yaml) — contracts between components (env vars, HTTP, SQS, imports)
- [`ontology/checklists.yaml`](ontology/checklists.yaml) — impact chains (“when you change X, also update Y”) and dead-code avoidance

When adding, removing, or rewiring a component, **update the ontology** so it stays the source of truth for repo architecture. See [`ontology/README.md`](ontology/README.md).
