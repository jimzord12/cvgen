---
id: TASK-55
title: 'repo-layout: fewer top-level folders and a clean `scripts/`'
status: Active
assignee: []
created_date: '2026-10-14 04:48'
updated_date: '2026-10-14 09:25'
labels:
  - restructure
dependencies:
  - TASK-52
  - TASK-31
ordinal: 55000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Group `brand/`, `design-concepts/` and `archive/` under one folder; move `scripts/design_review/` to `apps/design-review/`; one naming case per file type (`docs/conventions.md`); have `M/lib.typ` re-export themes, artwork and layouts so an example needs one import. Owner decision 2026-10-14: go ahead unattended, report the tree before and after (no per-move approval). Source: archive/work-records/workflow-model/handoff.md, section 4, item 23 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started. The owner answered its open question on 2026-10-14 (docs/proposals/workflow-model.md); the decision overrides this description where they differ.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Suite passes, the Design Review app still starts and lists PDFs; the final report shows the tree before and after
- [ ] #2 Top-level folders grouped and scripts/design_review moved to apps/design-review, history kept, links fixed
- [ ] #3 One naming case per file type, written in docs/conventions.md and applied
- [ ] #4 M/lib.typ re-exports themes, artwork and layouts so an example needs one import; frozen reference stays pixel-identical
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Owner decision 2026-10-14 recorded in docs/proposals/workflow-model.md: go ahead unattended; history kept, links fixed, suite passing; report shows the tree before and after.

From TASK-52 review: regrouping archive/ moves archive/work-records again; repoint the same live files TASK-52 touched (git show --stat of the TASK-52 merge: AGENTS.md, docs/development.md, docs/review.md, glossary, guides, research notes, open proposals, .claude agents and skills, .codex agents, .claude/repo-maintenance.md, docs/workflow stage.yaml 03/05/07, .atlas/src).
<!-- SECTION:NOTES:END -->
