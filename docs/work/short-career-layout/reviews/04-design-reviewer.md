# Design review round 4: short-career-layout

Stored as returned by the `design-reviewer`; the lead's dispositions follow
at the end.

# Design review round 4: 2026-09-28

Snapshot: commit 1887470, branch feat/short-career-layout. I judged the pages in `C:\Users\jimzord12\Documents\GitHub\cvgen\builds\tests-20260928-143946-383342\` by eye. I measured gaps from the PDFs with pymupdf (text positions plus ink rows at 96 dpi) and compared them with v11's `engineer.pdf` from the same build.

## short-career-layout (flagship-one-page.typ): PASS

**First impression:** both thin pages now read as one short, complete document. The order is hero, synopsis, 01, stats band, then the remaining section, with white space below. The band is back with the 01 block it summarises, which is what the owner asked for.

**Pages that should be unchanged.** `deck-cadet.png`, `one-page-one.png` and `one-page-three.png` are pixel-identical to round 3 in `builds\tests-20260928-143300-346332\` (the difference image is empty for all three). The even split the owner approved for pages with both sections still holds.

**How the two stacked pages are spaced.** I measured the white space between inked blocks (ink to ink) and compared it with v11 page 2, which also has an experience row, then the band, then a section.

| Gap | no-education | no-certificates | v11 engineer p2 |
|---|---|---|---|
| Last 01 row to the band | 4.0 mm | 4.0 mm | 4.0 mm |
| Band to the next section heading | 6.4 mm (to 02) | 5.8 mm (to 03) | 6.6 mm (to 02) |
| Heading to its content | 4.2 mm | 4.2 mm | 4.2 mm |

- **The rhythm matches Flagship.** The gaps are within 0.8 mm of the frozen reference. There are no flexible gaps left on these pages.
- **Nothing is broken.** Nothing collides or clips, and there are no widows or orphans. Each page is one page long. The footer stays at v11's position (text 290.8 to 294.3 mm). No type size changed.
- **The white space reads as intended.** Content ends at about 198 to 199 mm, which leaves about 92 mm of white above the footer. The faint chart and lifeboat artwork in the bottom corners anchor that space, so the page looks deliberately short rather than unfinished. D9 from round 3 (gaps of about 43 mm each) is resolved by the owner's choice.

**Findings**
- **D10 Nit (craft):** the band-to-heading gap is 0.6 mm shorter before "03" than before "02". This is existing Flagship behaviour: the 03 heading has no subtitle, so its heading block sits differently. The eye cannot see it. No fix needed.
- **D4 Minor (carried, owner's taste call):** on deck pages without a portrait, the wheel's top knob still touches the page edge. No change.

## Renders made
None. I used the suite PNGs, a pixel diff against round 3, and pymupdf measurements taken in memory. The helper scripts are in the session scratchpad only; nothing was written under `builds/`.

## Verdict: PASS
There are no Blocking findings. The stacked layout does what the owner described. Its spacing is taken from Flagship's own rhythm, and the three pages with both sections have not moved.

## Dispositions (lead)
- PASS, on 1887470. Superseded in part: while this round ran, the owner found the stacked pages too tight ("give some more gap, we have the space"); fa61596 adds a 12mm `stack-gap` above the synopsis and the remaining section, which the owner then approved ("Much better now"). Round 5 reviews that.
- D10: no change. D4: stays with the owner.
