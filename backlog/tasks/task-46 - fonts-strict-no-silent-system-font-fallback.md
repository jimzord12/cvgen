---
id: TASK-46
title: 'fonts-strict: no silent system-font fallback'
status: Queued
assignee: []
created_date: '2026-10-14 04:47'
labels:
  - restructure
dependencies: []
ordinal: 46000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Add `--ignore-system-fonts` to `tests/run.py` and `cv_workflow/render.py` compiles (only `design_review/server.py` has it); make `validate-theme` check that fonts exist. Source: docs/work/workflow-model/handoff.md, section 4, item 14 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->
