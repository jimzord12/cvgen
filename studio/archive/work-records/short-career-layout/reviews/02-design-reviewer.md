# Design review round 2: short-career-layout

Stored as returned by the `design-reviewer`; the lead's dispositions follow
at the end.

# Design review round 2: 2026-09-28

Snapshot: commit 5470f43, branch feat/short-career-layout. Renders in `builds/tests-20260928-142436-966133/` (deck-cadet, one-page-one, one-page-three). I measured them against the v11 engineer, captain and chief-officer pages from the same run.

## short-career-layout (flagship-one-page.typ): PASS

**First impression:** all three pages now read as calm, deliberate one-page Flagship CVs. The empty space lands at the two section breaks, so it no longer reads as a missing section.

**Rubric**
- (a) Confident one-page CV: passes on all three. The one-company page no longer has the 46 mm hole.
- (b) Premium, not cramped: passes. The hero, stats band, type and artwork are v11's. The 02 heading now has clear air above it on every page (below).
- (c) Craft: passes. The two break gaps are nearly equal (they differ only by their 7 mm and 5 mm minimums), the footer is back at v11's position, and there are no collisions, clipping, widows or orphans.
- (d) Geometry only: passes. `flagship-one-page.typ` changes only heights, gaps, insets, the page plan and `spread: true`. It changes no type sizes.

**Owner's point ("02 feels too dense"): addressed.** The visible gap from the stats band to the "02" numerals, measured at 200 dpi:
- deck-cadet: about 12 mm (v11 page 2: about 4 mm by the same text-box measure)
- one-page-three, at capacity: about 7.5 mm
- one-page-one: about 22 mm

On the cadet page, 02 now has as much air above it as 03 (about 10 mm), so the density is gone.

**Round-1 findings checked**
- D1 fixed. The free space is shared equally above 02 and above 03 on every page.
- D2 fixed. The footer text box runs from 290.8 to 294.3 mm and the rule sits at 286.5 mm, identical to page 1 of the v11 examples.
- D3 fixed. At capacity, "03" sits about 6 mm under the table's last rule (round 1: about 2.5 mm), and 02 about 7.5 mm under the band.

**Findings**

- **D7 Note (c): the one-company page is airy.** On one-page-one each break is about 20 to 22 mm, about three times the gap under the 01 heading. It reads as generous rhythm, not a gap, so it does not block. If the owner finds it loose:
  - cap each break (say about 14 mm) and let the remainder go above the footer; or
  - add a third flexible share between the synopsis and 01.

  Both are geometry only.
- **D8 Note (c): the top is slightly tighter than the middle.** On deck-cadet the 01 block keeps the halved company gap (4 mm, v11 8 mm), while 12 mm opens up below the band. It is barely visible and no longer a problem. A small flexible share between companies would even it out; optional.
- **D4 Minor (carried, deferred to the owner): the wheel's top knob is cut.** On no-portrait deck pages the top of the wheel still touches the page edge. The lead's deferral is reasonable because the chief-officer example does the same. It stays a taste call for the owner, since deck-cadet is the public example.
- **Nit:** the certificate rows are tighter than v11's (5.4 mm vs 6.6 mm pitch, from the smaller inset). They still read cleanly at print size.

## Renders made
`C:\Users\jimzord12\Documents\GitHub\cvgen\builds\design-review-20260928-142546\`
- 200 dpi pages: `deck-cadet-p1-200.png`, `one-page-one-p1-200.png`, `one-page-three-p1-200.png`
- Middle-section crops: `c-deck-cadet-mid.png`, `c-one-page-one-mid.png`, `c-one-page-three-mid.png`

## Verdict: PASS

No Blocking or Material findings. D7 and D8 are optional polish for the owner's eye; D4 stays with the owner as a taste call.

## Dispositions (lead)
- PASS. The owner looked at the round-2 cadet page and said "That feels and looks great" (2026-09-28).
- D7, D8: no change; optional polish, and the owner approved the current spacing.
- D4: stays with the owner as a taste call (existing hero behaviour on every no-portrait deck record).
- Nit: no change.
