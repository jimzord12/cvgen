---
id: TASK-10
title: 'vessel-particulars: optional tonnage, engine maker and power per vessel'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/A3fHVefS'
ordinal: 10000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# vessel-particulars: optional tonnage, engine maker and power per vessel

Owner: Claude Code (Night Shift 2026-09-27-a)
Branch/worktree: feat/vessel-particulars (merged)
Integration target: main
Depends on: proposal https://github.com/jimzord12/cvgen/blob/main/docs/proposals/vessel-particulars.md (approved by the owner 2026-09-25, Day Shift question 08; now `applied`)

## Outcome and boundaries
A marine CV can carry each ship's size (GT or DWT), main engine maker and engine power (kW or BHP), printed as documented, never converted, as a muted suffix after the vessel name on the same row ("MV Meridian · 49,990 GT · MAN B&W · 9,480 kW"). Records without the fields render exactly as today. No new public example (proposal's recommendation).

## Acceptance
- [x] Schemas accept the three optional fields; unknown units refused; a repeated vessel with conflicting values fails loudly.
- [x] A fixture renders the particulars; no row moves (every other word checked in place).
- [x] Engineer example pixel-identical to v11; suite passes (51 cases on main).
- [x] code-reviewer PASS (round 2); merged to main and pushed; CI green.

## Result and evidence
- Merge: https://github.com/jimzord12/cvgen/commit/1cb0c9e ; proposal applied: https://github.com/jimzord12/cvgen/commit/b443433
- Suite on main: PASS 50 cases after the merge (builds/tests-20260927-032545-688515, local), 51 after the certificate merge.
- Fixture: tests/fixtures/particulars.typ; errors for conflict, unknown unit, zero value, extra key, too long.
- New glossary term: `Vessel Particulars`.

## Review
- Round 1 FINDINGS: https://github.com/jimzord12/cvgen/blob/main/docs/work/vessel-particulars/reviews/01.md (M1 row check looped over the wrong list: fixed; m1 fixture dropped Education: fixed; m2 docs: fixed; notes taken or accepted).
- Round 2 PASS: https://github.com/jimzord12/cvgen/blob/main/docs/work/vessel-particulars/reviews/02.md (m3 and N6 applied as docs-only after the PASS).

## Handoff
Done. Open with the owner: the look of the suffix (Night Shift 2026-09-27-a question Q2, render attached there). Proposal's "busy rows" risk is exactly that look decision.
<!-- SECTION:DESCRIPTION:END -->
