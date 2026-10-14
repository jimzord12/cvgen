---
id: TASK-38
title: 'workflow-check: the workflow tool verifies the model (levels 1 and 2)'
status: Queued
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 06:52'
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
