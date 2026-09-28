# Design review round 3: short-career-layout

Stored as returned by the `design-reviewer`; the lead's dispositions follow
at the end.

# Design review round 3: 2026-09-28

Snapshot: commit d3d98e9, branch feat/short-career-layout. Judged from `C:\Users\jimzord12\Documents\GitHub\cvgen\builds\tests-20260928-143300-346332\`, with gaps measured from the PDFs using pymupdf.

## short-career-layout (flagship-one-page.typ): PASS

**First impression:** the three pages with both sections are unchanged and still calm. The two thin fixtures are tidy, but the stats band now floats in the middle of the white space.

**Unchanged pages confirmed.** `deck-cadet.png`, `one-page-one.png` and `one-page-three.png` are pixel-identical to the round-2 renders in `builds/tests-20260928-142436-966133/` (the difference image is empty for all three). The round-2 PASS and the owner-approved cadet spacing stand.

**The fix works as described.** With one closing section missing, the free space is now split into two near-equal gaps: one above the stats band and one above the remaining section. The single hole under the band from before is gone. The footer stays at v11's position (text 290.8-294.3 mm). Both pages have no collisions, clipping, widows or orphans. No type sizes changed.

**Findings**

- **D9 Note (craft, rhythm): on the thinnest records the two gaps are very large.** Measured:
  - one-page-no-education: 01's last row ends at 131.6 mm, the band runs 174.5-192.5 mm, and "02" starts at 240.0 mm. That makes gaps of about 43 mm and 47.5 mm.
  - one-page-no-certificates: gaps of about 42 mm and 44.5 mm.

  Each gap is about twice the round-2 one-company breaks (about 20 mm, D7). The band then sits alone mid-page, cut off from the 01 block it summarises. A designer's eye may read that as missing blocks, not as a deliberate rhythm.

  This does not block, for three reasons:
  - One company, one vessel and a missing section is an extreme fixture, not a public example.
  - The result is no worse than round 2's single 90 mm hole, and arguably better balanced.
  - Any placement leaves about 90 mm of white on this record.

  Fix, if the owner dislikes it: cap each flexible break at about 20 mm and let the rest fall above the footer. This is D7's first option; it is geometry only and leaves every page with both sections unchanged. With the cap, the content reads as one coherent block and the page reads as an honest short document.
- **D4 Minor (carried, owner's taste call):** the wheel's top knob still touches the page edge on no-portrait deck pages. No change.
- **Nit:** on no-certificates the "03" heading has no subtitle line while "02" has one, so the heading block is about 4 mm shorter than on the other pages. This is existing Flagship behaviour and is invisible in isolation.

## Renders made
None. I used the suite PNGs, the PDF text and drawing positions (pymupdf), and a pixel diff against round 2's PNGs.

## Verdict: PASS
There are no Blocking findings. D9 is the one thing worth showing the owner: open `one-page-no-education.png` next to `one-page-one.png`. If he finds the thin page loose, capping the breaks is the smallest fix.

## Dispositions (lead)
- PASS.
- D9: no change now; shown to the owner as a taste call (cap each break at about 20mm if he finds the thinnest pages loose).
- D4: stays with the owner. Nit: no change.
- Superseded after the owner looked at `one-page-no-education.png` (2026-09-28): the space-between look is not wanted; with a closing section missing, the blocks stack from the top ("the 02 section should go after the Summary Component, and the summary component should be after the 01"). Implemented after round 3.
