# Design review round 2: premium-text-draft (design-reviewer)

Lead's summary of the returned report (the original text was not kept).

Snapshot: 8a7ddfb, 2026-09-28. Base, `case=long` and `case=english`
rendered at 96, 150 and 200 dpi, greyscale, 390 and 1170 px phone widths,
with variant probes (7 to 10 rows, long tag names, line breaking).

## Round 1 fixes

- D19 holds: the long legal name wraps inside its row; the reply sits at
  the foot (about 55 mm of air in the base case, 20 mm in the long case);
  eight rows fail the compile with a clear message.
- D20 holds: at 390 px the ask, samples, OK line, fix line and page
  number read without zooming; body text needs a zoom, as any A4 PDF.
- D24 holds; D25 holds for `check-lang: "en"`; D21 only partly (D26).

## Findings

- **D26 Minor:** the knot stopped about 1.2 mm short of the card's top
  edge and read as a loose hair. Fix: end the curve at (170.4mm, 36.2mm).
- **D27 Minor:** 13 pt body left two one-word last lines on page 2
  ("tour.", "management."). Fix: reword the two fixture bullets.
- **D28 Minor:** a wrapped sample's two lines sat 8.2 mm apart against
  9.25 mm between rows, so its second line read as a new row. Fix:
  `par(leading: 0.55em)` in the value cells.
- **D29 Note:** the tag is outside the flow; a five-line name on the tag
  would print over the intro.

Rubric: reads as a CV, premium and distinct, craft, provenance, buildable:
all pass.

## Verdict: PASS

## Dispositions (lead)

- D26 fixed (the reviewer's curve). D27 fixed (both bullets reworded).
  D28 fixed (leading 0.55em inside the samples block only).
- D29 deferred: a four-line name already leaves 1.5 mm; five lines need a
  name of more than about 60 characters on a 48 mm card, and the drafter
  looks at every page.
