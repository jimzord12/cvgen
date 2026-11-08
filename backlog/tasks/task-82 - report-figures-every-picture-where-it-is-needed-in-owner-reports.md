---
id: TASK-82
title: 'report-figures: every picture where it is needed in owner reports'
status: Review
assignee: []
created_date: '2026-11-08T14:35:00Z'
updated_date: '2026-11-08T14:43:00Z'
labels: []
milestone: m-8
dependencies: []
ordinal: 82000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner: Claude Code session (lead)
Branch/worktree: feat/report-figures in .worktrees/report-figures
Integration target: main
Depends on: none

## Outcome and boundaries
Owner feedback 2026-11-08: a decision card asked him to approve a look whose picture sat far below with nothing pointing to it. Every picture in an owner report now sits where it is needed: a picture one card alone asks about sits inside that card with an Enlarge view; any other has a short id (Figure A) that each citing card or decision links to, and links back. Changes scripts/report.py, the Report Template page, its README and sample, tests/report.py, docs/preferences.md ("Reports") and docs/engine/verification.md item 19. Excludes the chat Recap format and any report other than the Report Template.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Pictures are placed by citation: one card alone keeps its picture; every other picture sits under Figures with links both ways (tests/report.py placement checks)
- [x] #2 Each in-card or shared picture opens full size in a lightbox, including a comparison with its slider, by mouse and keyboard, and the page fits a 390 px phone (design-reviewer round 3 PASS)
- [x] #3 A missing, malformed, duplicate or unknown figure id, or one item citing an id twice, is refused with its message (tests/report.py refusals)
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Result and evidence
At eea6751: `python tests/run.py` exit 0, PASS 220 compilation cases and 25 workflow checks, evidence `builds/tests-20261108-164241-061442` (the `report: figures placed` check and each figure refusal); `ruff check` clean. The owner's approval batch (private, local only) was rebuilt with the page: Figures A-C sit in cards 1 and 2, Figure D is shared by cards 3 and 4.

## Review
Reports verbatim in `archive/work-records/report-figures/reviews/`.
- Round 1 (1097d95): code PASS, F1-F4 Minor; context FINDINGS, 1 Material and 4 Minor; design FINDINGS, D1 (link arrow direction) and D2 (enlarge not visible; compare, keyboard, phone). All fixed in 39e507d.
- Round 2 (39e507d): code PASS, M1 Minor; context PASS, 2 Minor wording; design FINDINGS, D3 (phone overflow from a captioned link). All fixed in ff82d46.
- Round 3 (ff82d46): code PASS, N1 (Close wraps on phones); design PASS, one Note and two Nits; context FINDINGS, this record's shape (Material), "Fixed next" wording and a short line (Minor). Fixed in eea6751 and in this record: Close stays on one line, the lightbox bar names the open figure, shared figures can be enlarged, item 19 reflowed.
- Left as Notes: a comparison in the phone lightbox stays near card width, because the slider must keep its drag; decision back links carry no number, because the rows have none; review files keep the round-NN naming of the other recent work records.
<!-- SECTION:NOTES:END -->
