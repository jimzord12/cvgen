# Design review round 1 of the C-detail options (design-reviewer)

Snapshot: branch `brand/logo-c-detail` at b6b7477, 2026-09-28. Owner's
direction: faithful redraw, one custom detail on the C only, tied to the
thread. In all three files the V and both thread groups were
byte-identical to `cvgen-mark.svg` and the C outline untouched; holes
render identically under even-odd and nonzero; all read as "CV" down to
24 px and in greyscale.

## cvgen-mark-c-stitch.svg: FINDINGS

- **D1 Blocking (Craft):** the thread cut the top hole, and the straight
  column drifted off the curved stem's centre (-4 to -20 units). Fix:
  holes along the outer edge, each turned to the curve, starting one gap
  below the thread (the reviewer's trial `trial-stitch-edge.svg`).
- **D2 Note:** white holes, not copper; the link to the `Text Draft`
  stitch is conceptual, and white dashes on a dark shape are a stock
  stitched-patch effect.

## cvgen-mark-c-eye.svg: FINDINGS

- **D3 Blocking (Craft):** the vertical eye cut diagonally across a stem
  that leans about 9.6°. Fix: put it on the stem's axis.
- **D4 Note (owner's call):** the thread passed over the eye, not
  through it. Threading it makes the idea certain: split the first
  thread-over path so the thread leaves the eye and runs under the stem to
  the counter (`trial-eye-aligned-threaded.svg`).

## cvgen-mark-c-point.svg: FINDINGS

- **D5 Blocking (Craft):** the spike looked attached, not grown: a chin at
  the bottom joint, a hairline crack and notch at the top.
- **D6 Blocking (Premium):** a curved thorn, not a needle; it does not
  touch the thread and outweighs it at 32-48 px. Fix: drop the option.

## All three

Note: the winning C must also go into the wordmark and the reversed files.

**Recommendation to the owner:** the eye, fixed (D3) and threaded (D4);
then the stitch once D1 is fixed; drop the point.

Renders and trial files: `builds/design-review-20260928-013633/` (local).

## Verdict: FINDINGS

## Dispositions (lead)

- D1 fixed: the stitch file now uses the reviewer's edge-following holes.
- D3 and D4 fixed: the eye file uses the reviewer's aligned, threaded
  trial. Threading is taken as within the owner's "tied to the thread";
  he still picks between the two options.
- D5, D6: option dropped (file removed).
- D2 and the all-three Note: recorded in `brand/README.md`; the winning C
  goes into every file after the owner's pick.
