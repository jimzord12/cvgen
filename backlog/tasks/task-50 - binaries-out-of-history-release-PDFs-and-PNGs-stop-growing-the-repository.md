---
id: TASK-50
title: 'binaries-out-of-history: release PDFs and PNGs stop growing the repository'
status: Queued
assignee: []
created_date: '2026-10-14 04:48'
labels:
  - restructure
  - owner-input
dependencies: []
ordinal: 50000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
The pack is about 52 MiB against a 28 MB tree; each release adds about 11 MB. Publish the `Release` PDFs and `docs/images` PNGs as GitHub Release assets or move them to LFS; dedupe the three fonts in `design-concepts/fonts/` vs `packages/cv-framework/fonts/`. Owner decision (it changes the `Release` location). Source: docs/work/workflow-model/handoff.md, section 4, item 18 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started. Needs an owner interview before work starts (label owner-input).
<!-- SECTION:DESCRIPTION:END -->
