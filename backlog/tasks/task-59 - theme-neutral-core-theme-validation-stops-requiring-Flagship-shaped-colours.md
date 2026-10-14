---
id: TASK-59
title: 'theme-neutral: core theme validation stops requiring Flagship-shaped colours'
status: Active
assignee: []
created_date: '2026-10-14 06:23'
updated_date: '2026-10-14 06:46'
labels:
  - restructure
dependencies: []
priority: low
ordinal: 59000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Follow-up from TASK-45 review round 1 note N1 (2026-10-14). packages/cv-framework/core/theme.typ still requires the Flagship colour keys hero, plate, on-hero, surface and rule, so a second template with its own palette would fail the core check. Move those required keys into Flagship (its own check) and leave the core checking only what every template needs. Only flagship.typ calls the check today.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 core/theme.typ names no Flagship colour key
- [ ] #2 Flagship checks its own required colours with the same messages
- [ ] #3 the suite passes; the frozen reference stays pixel-identical
<!-- AC:END -->
