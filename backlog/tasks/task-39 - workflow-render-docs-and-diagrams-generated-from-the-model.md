---
id: TASK-39
title: 'workflow-render: docs and diagrams generated from the model'
status: Queued
assignee: []
created_date: '2026-10-14 04:47'
labels:
  - workflow-model
dependencies:
  - TASK-38
ordinal: 39000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
`render` writes the generated blocks (between markers) in `docs/workflow/**/README.md` and the Mermaid diagrams. CI fails if regeneration changes anything. Source: docs/work/workflow-model/handoff.md, section 4, item 7 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 The regenerated tree is identical in CI
- [ ] #2 diagrams render on GitHub
<!-- AC:END -->
