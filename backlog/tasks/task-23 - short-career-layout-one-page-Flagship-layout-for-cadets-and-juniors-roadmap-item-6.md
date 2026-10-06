---
id: TASK-23
title: >-
  short-career-layout: one-page Flagship layout for cadets and juniors (roadmap
  item 6)
status: Done
assignee: []
created_date: '2026-10-06 07:25'
updated_date: '2026-10-06 07:49'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/EKr30oER'
ordinal: 23000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# short-career-layout: one-page Flagship layout for cadets and juniors

Owner: Claude Code session 2026-09-28
Branch/worktree: feat/short-career-layout (merged, deleted)
Integration target: main
Depends on: none

## Outcome and boundaries
A one-page `Layout` for Flagship so a short career fills a confident page. Geometry and page plan only, no type-size changes; overflow fails loudly. Proposal (applied): https://github.com/jimzord12/cvgen/blob/main/docs/proposals/short-career-layout.md

## Acceptance
- [x] `flagship-one-page.typ` + `one-page(candidate)` serve 1-3 company records on one page
- [x] Fictional deck cadet example (`examples/marine/flagship/deck-cadet.typ`) and suite cases with one-page checks
- [x] `docs/reference/layout-and-pagination.md` says when to choose which profile (`Capacity Rule`)
- [x] v11 engineer example pixel-identical to its frozen reference

## Result and evidence
Merged to main at 35c3557 (CI run 36418142693: success); proposal marked applied in f7a6996. Suite PASS, 61 cases (builds/tests-20260928-145029-224214, local). Also: singular "1 VESSEL" / "1 COMPANY" in the synopsis; `spread` and `stack-gap` layout keys in the page loop (v11 unaffected). Owner shaped the look in session: more air above 02, even gaps on thin records, top-stacked page with 12mm `stack-gap` when certificates or education is missing.

## Review
Five rounds, `code-reviewer` + `design-reviewer`, reports and dispositions in docs/work/short-career-layout/reviews/ (01-05). Round 1 design FINDINGS (D1 spacing, D2 footer) fixed; rounds 2-5 PASS from both. Last Minor (M1) fixed in docs.

## Handoff
Done. Open owner taste calls, not blocking: the wheel's top knob touches the page edge on no-portrait deck pages (existing); education stays numbered "03" when certificates are missing (existing). Whether the cadet becomes a `Release` example with its own `Frozen Reference` is the owner's call.
<!-- SECTION:DESCRIPTION:END -->

## Comments

<!-- COMMENTS:BEGIN -->
author: Trello
created: 2026-10-06 07:49
---
Trello comment, 2026-09-28 08:01 UTC (migrated):

Owner approved revision 1 on 2026-09-28. Ready to be built when he opens it (roadmap item 6).
---
<!-- COMMENTS:END -->
