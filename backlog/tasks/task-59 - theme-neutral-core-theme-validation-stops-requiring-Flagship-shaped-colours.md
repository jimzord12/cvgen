---
id: TASK-59
title: 'theme-neutral: core theme validation stops requiring Flagship-shaped colours'
status: Done
assignee: []
created_date: '2026-10-14 06:23'
updated_date: '2026-10-14 12:37'
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
- [x] #1 core/theme.typ names no Flagship colour key
- [x] #2 Flagship checks its own required colours with the same messages
- [x] #3 the suite passes; the frozen reference stays pixel-identical
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Criteria ticked at the session close (2026-10-14) from the merged, reviewed work: core/theme.typ requires only the colours core primitives use (ink, accent, metal, muted, paper); Flagship checks the rest of its palette.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Core validate-theme now requires only the colours the core reads (ink, accent, metal, muted, paper) and the two fonts, with a require-colors helper; Flagship's validate-flagship-theme adds hero, surface, plate, rule, on-hero with identical messages; the boundary check refuses Flagship colour names in core. Fixtures theme-core, theme-core-missing-{five}, theme-flagship-missing-{five}, theme-flagship-not-color. Code review round 1 PASS (minor fixed), context review rounds 1 (FINDINGS, fixed) and 2 (PASS). Suite PASS 116 (builds/tests-20261014-095533-905508 in the worktree), engineer frozen reference pixel-identical.
<!-- SECTION:FINAL_SUMMARY:END -->
