---
id: TASK-38
title: 'workflow-check: the workflow tool verifies the model (levels 1 and 2)'
status: Queued
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 08:18'
labels:
  - workflow-model
dependencies:
  - TASK-37
ordinal: 38000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
`check` command: shape, references, existence of files, commands (`cv.py`/`outputs.py` via `--help`) and skills; flow rules with declared loops. A negative-fixture suite of broken models. Wired into `tests/run.py` and `.github/workflows/verify.yml`. Source: docs/work/workflow-model/handoff.md, section 4, item 6 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Every rule has a failing fixture
- [ ] #2 CI runs it
- [ ] #3 the real model passes
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
2026-10-14, from TASK-36 context review round 2 (m1): the handoff's flow rule 'produced by an earlier step or marked external' (docs/work/workflow-model/handoff.md:216) means the Artifact flag given: true in the types (tools/workflow/src/model.ts); there is no external flag, and the inventory's 'external' is visibility third-party (tools/workflow/README.md, Reading the inventory).
<!-- SECTION:NOTES:END -->
