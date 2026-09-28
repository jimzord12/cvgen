# Design review round 1: intake-form header (2026-09-28)

Snapshot: brand/forms/intake-header.png (1600 x 400), source brand/forms/intake-header.typ, byte-identical to builds/intake-header-20260928-211651/intake-header.png. A production brand asset, not an idea-run concept.

Rubric scope: 1 (reads as a CV) and 5 (schema, month totals, template path) n/a; 4 in part (original artwork, OFL wordmark outlines documented in brand/README.md, no data); 2 (premium and distinct) and 3 (craft) in full.

## brand/forms/intake-header: PASS
First impression: the black "CV" with its copper thread, centred on warm paper, one short running stitch beneath; quiet and deliberate, the opposite of a rushed job.

- D1 Note (colour): the wordmark's thread and "gen" are #B7713D, the stitch and the Forms theme bar #B0602B (ΔE ≈ 8). Fix: recolour the SVG inside the header only; record the two-copper split as an open brand item.
- D2 Note (weave): 90 vertical 0.25 pt lines read as pinstripe at full size and as banding at phone width; the source comment is wrong (the tag card is plain). Fix: delete the weave.
- D3 Note (fit): the paper #F3EEE3 is yellower than the tint Forms likely derives from #B0602B. Fix: sample the live background after theming, or accept the difference knowingly.
- D4 Nit (balance): content centre ~10 px below the middle. Fix: wordmark dy -9pt, stitch dy -45pt.
- D5 Nit (alignment): stitch 544–1056 px vs wordmark 534–1065 px, a near miss. Fix: match the wordmark (267pt–533pt) or clearly shorter.
- D6 Nit (stitch at phone width): thins to a dotted rule at 1x, reads as stitch at 2–3x; optionally w = 1.6pt.

Checked and fine: wordmark legibility at 360 CSS px (3x), the needle's eye at 3x, distinct from the stock stitched-patch look, no words is right.

Renders: builds/design-review-20260928-2130/ (360, 412, 640 px; 3x zoom; 1080 px at dpr 3; a phone mock under Forms' chrome; weave and stitch crops).

## Verdict: PASS

## Dispositions (lead, 2026-09-28)
- D1 applied: the header recolours #B7713D to #B0602B when it reads the wordmark; the brand files are unchanged (open brand item noted in brand/README.md).
- D2 applied: weave removed.
- D3 applied: the guide's theme step picks the background swatch closest to the header's paper.
- D4 applied: dy -9pt and -45pt.
- D5 applied: stitch 267pt–533pt, matching the wordmark.
- D6 applied in part: w = 1.5pt.
New render: builds/intake-header-20260928-211942/intake-header.png, copied to brand/forms/.
