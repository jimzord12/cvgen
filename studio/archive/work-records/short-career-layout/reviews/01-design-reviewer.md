# Design review round 1: short-career-layout

Stored as returned by the `design-reviewer`; the lead's dispositions follow
at the end.

# Design review round 1: 2026-09-28

Snapshot: commit e1188d4, branch feat/short-career-layout; renders in `builds/tests-20260928-141357-063126/` (deck-cadet, one-page-three, one-page-one), compared against the v11 pages and the captain example (v11, same deck artwork).

## short-career-layout (flagship-one-page.typ): FINDINGS

**First impression:** the ship's-wheel hero and the dark stats band read as full Flagship. deck-cadet and one-page-three look like deliberate one-page CVs. one-page-one does not: it has a hole in the middle.

**Rubric**
- (a) Reads as a confident one-page CV: passes for the cadet and three-company records. Fails for one company (D1).
- (b) Keeps the premium look: passes. The hero band, type sizes, sections and artwork are the same as v11. Nothing feels cramped except at capacity (D3).
- (c) Craft: fails on how free space is spread (D1) and on the footer position (D2).
- (d) Buildable: passes. The profile changes only margins, gaps, insets and the page plan. Type sizes are untouched and overflow still fails loudly.

**Findings**

- **D1 Material (a, c): anchoring education puts all the spare space in one gap.**
  - one-page-one: about 46 mm of empty page sits between the certificate table (ends about 200 mm) and "03" (239 mm). That reads as a missing section, which is exactly the "thin CV" signal the proposal exists to prevent.
  - deck-cadet: about 20 mm above 03, against about 4.5 mm above 02. Meanwhile the experience block uses gaps half of v11's (company gap 8 to 4 mm). The top feels compressed and the lower middle loose.
  - My answer to your question: anchoring is not acceptable on this profile. Simply turning it off (`anchor-education: false`) is also not the fix, because the hole just moves above the footer.
  - Fix (geometry only): add a profile switch so `flagship.typ` places `v(1fr)` at each section boundary (before 02 and before 03, optionally also between companies) instead of the single anchor. Each boundary keeps its fixed `above` as a minimum.
  - Alternative: let short records fall back to v11's larger opening gaps (8 / 3.5 / 7 / 5 mm, synopsis inset 5 mm, certificate inset 2.2 mm).
  - Re-render one-page-one. No heading gap should be more than about twice its neighbour.

- **D2 Material (c, print safety): the footer is too close to the bottom edge.**
  - The bottom margin went from 15 to 12 mm, which moved the footer down. The footer text box now ends at 296.4 mm on a 297 mm page, so the text sits about 1.5 mm from the edge. On v11 it is about 3.5 mm.
  - Most office printers cannot print within 3 to 5 mm of the edge, so a recruiter's printout will clip the footer.
  - Fix: keep the footer where v11 puts it (bottom 15 mm, or an equivalent footer offset). Win the 3 mm back elsewhere, then re-measure capacity.

- **D3 Minor (c): at capacity, 03 crowds the certificate table.**
  - On one-page-three, "03" sits about 2.5 mm under the table's last rule, tighter than 02's gap. The 5 mm `education.above` looks swallowed next to `v(1fr)`.
  - Fix: guarantee the minimum gap before the flexible space, then state capacity with that gap included.

- **D4 Minor (existing hero behaviour, not this profile): the wheel's top knob is cut by the page edge.**
  - Without a portrait, the wheel's top handle is cut by the page's top edge (clear at 200 dpi). In the captain example the wheel sits fully inside the page.
  - It could pass as a deliberate bleed, but this is the public example the owner sees first.
  - Fix: nudge the no-portrait wheel down a few mm in the artwork offsets, or accept it as a taste call.

- **D5 Note (d): state capacity as rows, not companies and vessels.**
  - "Up to about three companies and four vessels with a short certificate list" is vague. Real cadets often carry 6 to 8 certificate rows; the STCW basic-safety modules alone are four.
  - Suggest stating a row budget (vessel rows plus certificate rows) so the profile can be chosen before rendering.

- **D6 Nit:** the gap from the hero band to the summary is about 5 mm (v11 about 9 mm). It still reads fine.

## Renders made

`C:\Users\jimzord12\Documents\GitHub\cvgen\builds\design-review-20260928-141537\`
- 200 dpi pages: `deck-cadet-p1-200.png`, `one-page-three-p1-200.png`, `one-page-one-p1-200.png`
- captain page 1: `captain-p1-200.png`, `captain-p1-96.png`
- detail crops: `c-three-cert-edu.png`, `c-cadet-bottom.png`, `c-captain-bottom.png`, `c-cadet-top.png`

## Verdict: FINDINGS

D1 and D2 are Material; D3 and D4 are Minor. Fix D1 and D2, then re-render all three cases for round 2.

## Dispositions (lead)
- D1 fixed: a `spread` switch (default off, so v11 is unchanged) makes the page loop share the free space equally above certificates and above education. The owner raised the same point mid-round ("increase the top margin of 02 section, it feels too dense"), so the certificates heading also returns to v11's 7mm minimum.
- D2 fixed: the one-page profile keeps v11's margins (bottom 15mm); the footer sits where v11 puts it.
- D3 fixed: a heading's block gap collapses next to flexible space, so the loop restates both heading gaps as minimums when `spread` is on.
- D4 deferred: existing hero behaviour of every no-portrait deck record (the chief-officer example too), not this profile; a taste call for the owner, raised in the report.
- D5 fixed: the layout guide states a measured capacity rule (3 per company, 1 per vessel row, 1 per certificate row; 14 or less fits).
- D6: no change; the 5mm band-to-summary gap reads fine, as the report says.
