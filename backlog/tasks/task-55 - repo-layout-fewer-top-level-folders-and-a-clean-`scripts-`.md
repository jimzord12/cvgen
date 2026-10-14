---
id: TASK-55
title: 'repo-layout: fewer top-level folders and a clean `scripts/`'
status: Queued
assignee: []
created_date: '2026-10-14 04:48'
updated_date: '2026-10-14 05:18'
labels:
  - restructure
dependencies: []
ordinal: 55000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Group `brand/`, `design-concepts/` and `archive/` under one folder; move `scripts/design_review/` to `apps/design-review/`; one naming case per file type (`docs/conventions.md`); have `M/lib.typ` re-export themes, artwork and layouts so an example needs one import. Owner approves moves (`repo-maintenance apply`). Source: docs/work/workflow-model/handoff.md, section 4, item 23 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started. The owner answered its open question on 2026-10-14 (docs/proposals/workflow-model.md); the decision overrides this description where they differ.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Top-level folders grouped and scripts/design_review moved to apps/design-review (or a documented better fit), history kept, links fixed
- [ ] #2 Suite passes, the Design Review app still starts and lists PDFs; the final report shows the tree before and after
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Owner decision 2026-10-14 recorded in docs/proposals/workflow-model.md: go ahead unattended; history kept, links fixed, suite passing; report shows the tree before and after.
<!-- SECTION:NOTES:END -->
