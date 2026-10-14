---
id: TASK-43
title: 'workflow-consolidate: one source for the client workflow'
status: Queued
assignee: []
created_date: '2026-10-14 04:47'
labels:
  - workflow-model
dependencies:
  - TASK-40
  - TASK-41
  - TASK-42
ordinal: 43000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Replace `client-workflow.md`, `build-a-cv.md` and the lifecycle half of `pdf-workflow.md` with the model; reduce `new-client`/`new-cv` to step-ID pointers; fix the naming-drift items (inventory README: 34 drift items and 53 conflicts, "Fixed without asking"); update `AGENTS.md`; delete `docs/workflow/inventory/`. Source: docs/work/workflow-model/handoff.md, section 4, item 11 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 No second description of any step remains (grep checks)
- [ ] #2 the skills still run a fictional client end to end
<!-- AC:END -->
