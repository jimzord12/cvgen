# Design review round 5: short-career-layout

Stored as returned by the `design-reviewer`; the lead's dispositions follow
at the end.

# Design review round 5: 2026-09-28

Snapshot: commit fb32960, branch feat/short-career-layout. Judged `C:\Users\jimzord12\Documents\GitHub\cvgen\builds\tests-20260928-144538-716844\` by eye. Pixel-diffed it against round 4 (`builds\tests-20260928-143946-383342\`) and measured text positions from the PDFs with pymupdf, in memory only.

## short-career-layout (flagship-one-page.typ): PASS
First impression: both stacked pages now breathe. The order is hero, synopsis, 01, stats band, then the remaining section. The band sits as a clear divider, and the page ends in a calm block of white that the corner artwork anchors.

**Unchanged pages.** `deck-cadet.png`, `one-page-one.png` and `one-page-three.png` are pixel-identical to round 4 (empty difference image).

**Changed pages.** On both, the difference starts at y≈135 mm and ends at ≈225 mm. So the hero, synopsis, 01 block and footer did not move. The change sits above the band and above the remaining section, as described. (The round-4 disposition says "above the synopsis", which is a wording slip. The renders show no change there.)

| Ink gap | no-education | no-certificates |
|---|---|---|
| Last 01 row to the band | ≈16 mm | ≈16 mm |
| Band to the next section heading | ≈18 mm (to 02) | ≈17 mm (to 03) |
| Content ends | ≈223 mm | ≈223 mm |
| White above footer | ≈67 mm | ≈67 mm |

- **Nothing is broken.** Nothing collides or clips. The last content line (≈225 mm) is clear of the chart and lifeboat artwork, which starts at ≈240 mm. There are no widows or orphans. Each page is one page long, and the footer stays at v11's position. No type size changed.
- **The rhythm is even.** The two stack gaps are nearly equal, so the band reads as a deliberate divider rather than a stray block. The spacing inside each section (heading to content, table rows) is untouched Flagship.

**Findings**
- **D11 Note (craft, taste):** at 16 mm, the band is no longer tight to the 01 block. At 4 mm (v11 and round 4) it read as that block's summary; now it reads as a separator between sections. That is a valid reading, and the owner approved it. Record it as intended so a later round does not "fix" it back.
- **D12 Nit (craft):** the top of the page is now denser than the bottom. The synopsis-to-01 gap (≈4 mm, v11's value) sits beside two 16-18 mm gaps below. It is not visible as an error, and it keeps the hero, synopsis and 01 block together, which is correct. No fix needed.
- **D10 Nit (carried):** the gap before 03 is ≈1 mm shorter than before 02, because 03 has no subtitle. This is existing Flagship behaviour. No change.
- **D4 Minor (carried, owner's call):** on deck pages without a portrait, the wheel's top knob still touches the page edge. No change.

## Renders made
None. I used the suite PNGs, a pixel diff against round 4, and pymupdf text positions, all in memory. Nothing was written under `builds/`.

## Verdict: PASS
There are no Blocking findings. The 12 mm `stack-gap` does what the owner asked, and it did not regress the three pages that have both sections, the footer or the artwork.

## Dispositions (lead)
- PASS.
- D11: intended; the owner approved the 12mm stacked gaps ("Much better now"). The "synopsis" in the code and docs is the stats band itself, so "above the synopsis" and "above the band" are the same place; no wording change.
- D12, D10: no change. D4: stays with the owner.
