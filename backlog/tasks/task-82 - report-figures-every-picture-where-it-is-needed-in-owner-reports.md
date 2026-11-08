---
id: TASK-82
title: 'report-figures: every picture where it is needed in owner reports'
status: Review
assignee: []
created_date: '2026-11-08T14:35:00Z'
updated_date: '2026-11-08T14:35:00Z'
labels: []
milestone: m-8
dependencies: []
ordinal: 82000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner feedback 2026-11-08: a decision card asked him to approve a look whose picture sat far below with nothing pointing to it. Rule: visuals sit in the section that uses them; a visual several sections use gets a short id (Figure A) that each cites.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Work on feat/report-figures (worktree .worktrees/report-figures). Reviews verbatim in archive/work-records/report-figures/reviews/.
- Round 1 (1097d95): code PASS F1-F4 Minor; context FINDINGS (1 Material, 4 Minor); design FINDINGS D1 (link arrow direction), D2 (enlarge not visible, compare, keyboard, phone). All fixed in 39e507d: in-card pictures beside the options with an Enlarge lightbox, arrows by position, back links, placement decided in report.py and tested.
- Round 2 (39e507d): code PASS M1 Minor (placement test covers only the sample); context PASS (2 Minor wording); design FINDINGS D3 (phone overflow from a captioned link). Fixed next: .ask-main minmax column, direct placement() test with uncited and decision-only figures, verification wording, sticky lightbox bar with compare sides, wide lightbox page on phones, half-and-half compare thumbnail, back-link pill colour, one-span Figures heading, padding click keeps the lightbox open.
- Not done (Notes): numbered decision back links (rows carry no number to cite); review file naming kept as round-NN like the other work records of this session.
<!-- SECTION:NOTES:END -->
