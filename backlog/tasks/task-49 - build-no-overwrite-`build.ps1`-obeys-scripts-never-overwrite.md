---
id: TASK-49
title: 'build-no-overwrite: `build.ps1` obeys "scripts never overwrite"'
status: Queued
assignee: []
created_date: '2026-10-14 04:48'
labels:
  - restructure
dependencies: []
ordinal: 49000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
`Copy-Item -Force` at `scripts/build.ps1:39` contradicts constitution rule 2; one shared example list instead of two (`build.ps1` and `run.py`). Consider porting to the TypeScript tooling. Source: docs/work/workflow-model/handoff.md, section 4, item 17 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->
