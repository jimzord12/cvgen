---
id: TASK-36
title: 'workflow-schema: typed entity definitions for the workflow model'
status: Queued
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 05:18'
labels:
  - workflow-model
dependencies:
  - TASK-35
ordinal: 36000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Bun project (suggested `tools/workflow/`), Zod types for Stage, Step, Artifact, Action (`cmd`/`skill`/`agent`/`manual`/`lead`), Actor, Gate and Loop, with external artifacts; exported JSON Schema; the YAML language-server hint. **Show the types to the owner before the engine.** Source: docs/work/workflow-model/handoff.md, section 4, item 4 (A. Workflow model). Created 2026-10-14 at the owner's request; not started. The owner answered its open question on 2026-10-14 (docs/proposals/workflow-model.md): proceed unattended and show the types at the end; the decision overrides this description where they differ.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `bun test` passes
- [ ] #2 the JSON Schema is generated
- [ ] #3 one sample `stage.yaml` validates in VS Code and through the engine
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Owner decision 2026-10-14 recorded in docs/proposals/workflow-model.md: proceed unattended; explain the types with an example in the final report.
<!-- SECTION:NOTES:END -->
