# Design review round 2 of the C-detail options (design-reviewer)

Snapshot: branch `brand/logo-c-detail` at a92cd96, 2026-09-28 (round 1:
b6b7477, report 02).

## Checks

- Both files match the reviewer's round 1 trials apart from title and
  desc. Against `cvgen-mark.svg`, the V, the thread-under group and the
  V-side thread path are byte-identical; the C outline is unchanged, with
  the detail as even-odd subpaths; even-odd and nonzero render with 0
  differing pixels.
- Eye file: only the first thread-over path is split at the eye; both
  pieces lie on the original curve within 0.05 units.

## cvgen-mark-c-eye.svg: PASS

Threading correct at 6x and 24x (over the outer stem, visible in the eye,
under the inner stem, out in the counter); D3 and D4 resolved.
- D7 Note: from 64 px down the eye can pass for a gloss highlight.
- D8 Nit: a 0.04-unit step at the split point, visible only above 20x.

## cvgen-mark-c-stitch.svg: PASS

Five holes at even pitch, turned to the curve, the top one about 15 units
below the thread; D1 resolved. D2 (white, not copper; stock patch look)
stands as a Note.

## brand/README.md

- D9 Note: the chosen C cannot go into the small mark and avatar as
  drawn: their emboldening and thick thread close the eye and the holes.
- D10 Note: the stitch was described as the `Text Draft`'s running
  stitch as fact, and D2 was not recorded.
- D11 Nit: "only the C changed" is not exact for the eye file (thread
  layering); the open pick (eye or stitch) was not stated; the dropped
  knot has no render in the repo.

Recommendation unchanged: the eye.

## Verdict: PASS

## Dispositions (lead)

- D9, D10, D11 fixed in `brand/README.md`: small mark and avatar keep the
  plain C unless a detail is redrawn for them; the stitch's link to the
  `Text Draft` house design (built the same night, branch
  `feat/text-draft-first-fitting`) is stated with the D2 caveat; the open
  pick is named; the eye's layering change and the unkept knot render are
  stated.
- D7, D8: no action (the owner judges by eye; the step is invisible).
