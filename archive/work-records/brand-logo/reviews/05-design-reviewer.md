# Design review round 2: applying the needle's eye (design-reviewer)

Stored as returned, abridged to findings; dispositions at the end.
Snapshot: main at a22663f (round 1: f91987f, report 04), 2026-09-28.

## Checks
- The reversed eye changed only in its desc (0 px against f91987f and
  against the recoloured eye mark; even-odd and nonzero 0).
- The new desc parses; its colours are the only ones in the file and
  match the README; font and OFL credit follow cvgen-mark-reversed.svg.
- Wordmark blob unchanged since round 1.
- README against the files: every file named exists and every file is
  named; the plain-C files are as the README says; item 3 is true.
- D12, D13 resolved; D14 recorded; D15 resolved.

## brand/README.md: PASS
- D16 Nit: item 2 does not cover the reversed files.
- D17 Nit: "he picked only the C" says less than item 1 (he also chose the
  faithful redraw over the bold).
- D18 Nit: "(options for the owner to pick, not a final logo)" reads as
  current.

## cvgen-mark-c-eye-reversed.svg: PASS
- D19 Nit: cvgen-mark-c-eye.svg, now the working mark, keeps its draft
  title and no font credit.

## Verdict: PASS

## Dispositions (lead)
D16, D17, D18 fixed in the README; D19 fixed (title "CVgen mark", credit
added).
