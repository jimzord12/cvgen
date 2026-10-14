---
id: TASK-44
title: 'workflow-guards: scripts enforce the workflow''s state order'
status: Queued
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 05:21'
labels:
  - workflow-model
dependencies:
  - TASK-34
ordinal: 44000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Per decisions #2 and #8: a `ready` status for the `Text Draft`; `outputs.py stamp` refuses `approved` without a receipt, `delivered` without an `Export`, and `signed-off` without the screenshot; rename Meta File kind `text-draft` (the concept) so it no longer collides with the client's `Text Draft`. Code change: `code-reviewer` round. Depends on TASK-34 only; the decisions are in docs/proposals/workflow-model.md (#2, #8). Source: docs/work/workflow-model/handoff.md, section 4, item 12 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Tests for each refusal
- [ ] #2 schema updated
- [ ] #3 the suite passes
<!-- AC:END -->
