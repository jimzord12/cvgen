---
id: TASK-41
title: 'atlas-from-model: the Atlas client journey is built from the model'
status: Active
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 10:45'
labels:
  - workflow-model
dependencies:
  - TASK-39
ordinal: 41000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Port the Atlas build to TypeScript (or feed the existing page format from the model); retire hand-written `client-journey.json` facts. Later pages follow. Source: archive/work-records/workflow-model/handoff.md, section 4, item 9 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 The client-journey page is generated
- [ ] #2 `atlas check` (or its successor) passes
- [ ] #3 the old page data is deleted
<!-- AC:END -->
