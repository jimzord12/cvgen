---
id: TASK-60
title: >-
  pdf-font-subset-check: the suite fails a PDF whose fonts are not the bundled
  subsets
status: Queued
assignee: []
created_date: '2026-10-14 08:53'
labels:
  - quality
dependencies: []
ordinal: 60000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Follow-up from the TASK-46 fonts-strict work (2026-10-14): the compile flags forbid system fonts, but no check reads the finished PDF to prove every embedded font is one of the bundled OFL fonts. Add one check in tests/verify.py that lists embedded font names per PDF and fails on any outside packages/cv-framework/fonts. Created by the lead during the unattended run 2026-10-14.
<!-- SECTION:DESCRIPTION:END -->
