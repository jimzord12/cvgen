---
id: TASK-36
title: 'workflow-schema: typed entity definitions for the workflow model'
status: Queued
assignee: []
created_date: '2026-10-14 04:47'
labels:
  - workflow-model
  - owner-input
dependencies:
  - TASK-35
ordinal: 36000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Bun project (suggested `tools/workflow/`), Zod types for Stage, Step, Artifact, Action (`cmd`/`skill`/`agent`/`manual`/`lead`), Actor, Gate and Loop, with external artifacts; exported JSON Schema; the YAML language-server hint. **Show the types to the owner before the engine.** Source: docs/work/workflow-model/handoff.md, section 4, item 4 (A. Workflow model). Created 2026-10-14 at the owner's request; not started. Needs an owner interview before work starts (label owner-input).
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `bun test` passes
- [ ] #2 the JSON Schema is generated
- [ ] #3 one sample `stage.yaml` validates in VS Code and through the engine
<!-- AC:END -->
