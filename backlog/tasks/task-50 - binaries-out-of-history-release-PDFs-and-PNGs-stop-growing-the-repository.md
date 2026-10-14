---
id: TASK-50
title: 'fonts-dedupe: the three fonts stored twice are kept once'
status: Queued
assignee: []
created_date: '2026-10-14 04:48'
updated_date: '2026-10-14 05:18'
labels:
  - restructure
dependencies: []
ordinal: 50000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
The pack is about 52 MiB against a 28 MB tree; each release adds about 11 MB. Publish the `Release` PDFs and `docs/images` PNGs as GitHub Release assets or move them to LFS; dedupe the three fonts in `design-concepts/fonts/` vs `packages/cv-framework/fonts/`. Owner decision (it changes the `Release` location). Source: docs/work/workflow-model/handoff.md, section 4, item 18 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started. The owner answered its open question on 2026-10-14 (docs/proposals/workflow-model.md); the decision overrides this description where they differ.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Release PDFs and docs/images stay in the repo (owner decision 2026-10-14: no LFS, no history rewrite)
- [ ] #2 Each font family exists once; design-concepts compile and the suite passes with the single copy
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Owner decision 2026-10-14 recorded in docs/proposals/workflow-model.md: keep release PDFs and README images in the repo (no LFS, no history rewrite); only deduplicate the fonts stored twice (design-concepts/fonts vs packages/cv-framework/fonts).
<!-- SECTION:NOTES:END -->
