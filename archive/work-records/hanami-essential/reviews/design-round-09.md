# Design review round 9 (confirmation): Hanami `essential` at 1d9c75a, 2026-11-08

Snapshot: `C:\Github\cvgen\.worktrees\hanami-essential\builds\hanami-essential-r9-20261108-175209\` (head 1d9c75a). Bar: `scan-first`. Showcase-monochrome is judged on the full bar.

Batch sheets: `C:\Github\cvgen\.worktrees\hanami-essential\builds\design-review-20261108-r9\batch-<render>.png`. There are 19, one per page: showcase as `-p1` and `-p2`, plus `three-quarters` and `sparse`. Each sits among the same eight plain Typst CVs as in rounds 7 and 8 (`plain.pdf`).

**Verdict: PASS.** Every render passes, and D32 and D33 are fixed. D34 is fixed as designed, with one small leftover (a Nit, below).

## What changed since round 8
I compared every r9 page with r8 pixel by pixel (difference above 30 grey levels, 200 dpi). The changes are all where the brief says:
- **The generic family** (generic, -japan, -portrait, -portrait-grey, plain-long-name, plain-long-rank): changes only in the main column, from the highlight row to the education.
- **The twin family** (twin, greek, indigo, sky, monochrome, no-portrait, no-licence): only the second highlight cell changed.
- **long-career**: only the rail's trip list changed.
- **three-quarters and sparse**: only the main column changed.
- **long-career-greek and both showcase pages**: identical to r8.
- **The portrait**: untouched. My colour recommendation stands.

## Round 8 items
- **D32, the role gap: fixed.** I measured text to text at 200 dpi.
  - The generic role gap is now 12.6 mm (15.5 in r8), and the section gap before "02 Education" stays 18.2 mm. That is a clear step of 5.6 mm.
  - Side by side with r8 (`crop-generic-columns-r8-vs-r9.png`), "Reservations Agent" now reads as the next role in Experience and no longer floats free. The break before Education is clearly the larger pause.
  - The price: the main column now ends at 255 mm (258 in r8), so the block under Education is about 113 by 29 mm (26 in r8). The rail still runs to 273 mm, and on the batch sheet the page still reads as full. Acceptable.
- **D33, the trip tag wrap: fixed.** Crop: `crop-long-career-trips-r8-vs-r9.png`.
  - Both long-career trips now set "LED THE GROUP" on its own line, so the two entries have the same shape.
  - The date line is no longer justified: "October 2024  14 days" has the same gap as April.
  - The rail grows by about 4 mm and ends at 274 mm, with no collision with References.
  - Pages whose tags fit on one line (twin, greek "ΟΡΓΑΝΩΣΕ", generic) keep the tag inline, as they should.
- **D34, the warning: fixed.** `essential.typ:135-141` measures fill at the ordinary caps, before any roomy growth, and lets the gaps grow only when both columns are at least 80% filled. I queried every case with the project fonts:
  - generic, -japan, -portrait, -portrait-grey, long-career, long-career-greek, monochrome, no-portrait, indigo, sky, no-licence and greek return `[]`.
  - three-quarters returns "the career column is 60% filled…" (the 64% in r8 was measured after growth).
  - sparse returns "the rail is 34% filled…". The thinner column is named correctly.
  - plain-long-name and plain-long-rank return only the arc warnings (33 mm and 9 mm), unchanged.
- **three-quarters and sparse are no longer stretched.**
  - three-quarters: role gap 12.3 mm, the ordinary gap; the column ends at 205 mm.
  - sparse: role gap 9.5 mm; the column ends at 144 mm, where r8 stretched it to 156 mm.
  - Both read as honest short records, held back by the warning.
- **The highlight cells, reworded.** Crop: `crop-highlight-rows.png`.
  - Generic: "On the road / Reachable seven days a week" (the bullet says "by phone and messaging, seven days a week").
  - Twin family: "25 to 40 trips a year / Private itineraries as a travel consultant" (the bullet says "25 to 40 itineraries a year").
  - Both are true to the record, and both fit their cells on two lines in every theme and in Greek.

## generic, generic-japan, generic-portrait, generic-portrait-grey, plain-long-name, plain-long-rank: PASS
First impression: the black name and tab on the band (the sakura pack on generic-japan, the portrait or the arc on the others), then the four-cell highlight row.
Scan Test: name under 1 s; each role's title, employer and dates about 1 s each; Education about 2 s, now clearly after a bigger break.
- **Nit (6):** "Reachable seven days a | week" leaves a single-word second line in the generic highlight cell. Fix: "Reachable every day", or accept it.
- **Nit (D34, the leftover):** a page that just clears 80% at the ordinary caps can still end about 30 mm short after roomy growth. The generic page is that case (29 mm). It is accepted as the stated policy. If the owner finds that foot loose, the lever is the growth trigger (25 mm), not the warning.

## twin, greek, indigo, sky, monochrome, no-portrait, no-licence: PASS
The only change is the second highlight cell, and it is clean in every theme.
- Nit: "trips" now appears in two neighbouring cells ("Two trips", "25 to 40 trips a year"). This is taste only.

## long-career: PASS
Scan Test: four roles in full with their lead-ins, then "Earlier roles · 4" at about 4 s. D33 is fixed, and the trip list is consistent.

## long-career-greek: PASS
Identical to r8. The Greek capitals are correct (no accents).

## three-quarters: PASS (as a fixture)
It warns at 60%, it is not stretched, and it is not a deliverable page.

## sparse: PASS (as a fixture)
It warns on the rail at 34%. The content sits at the ordinary gaps, with no padded look.

## showcase-monochrome, pages 1 and 2: PASS
Pixel-identical to r8. The page 1 Three-Second Test is unchanged:
- **Domain, travel:** the walking group, the plane and SKG → FUK.
- **Specialty, Japan:** the torii, Fuji, 添乗員 and the 日本 stamp.
- **Rank, tour leader:** the "TOUR LEADER 添乗員" tab and the flag-bearer.

Page 2 is clearly the same CV: the mini band, the stamps and the line-art sakura.

## Renders made
In `C:\Github\cvgen\.worktrees\hanami-essential\builds\design-review-20261108-r9\`:
- `<render>-96dpi.png` and `<render>-200dpi.png` for all 19 pages
- the batch sheets `batch-*.png`
- the greyscale checks `{generic,generic-portrait,generic-portrait-grey,monochrome}-grey-96dpi.png`
- the crops `crop-generic-columns-r8-vs-r9.png`, `crop-long-career-trips-r8-vs-r9.png`, `crop-highlight-rows.png`, `crop-trips-{twin,greek,monochrome,generic}.png` and `crop-long-career-greek-trips.png`
- the scripts `sheets.py` and `measure.py`, and `plain.pdf` (copied from r8)

## Verdict: PASS
No Blocking findings. D32, D33 and D34 are closed. What remains are Nits: a one-word line in a generic highlight cell, the roughly 30 mm foot a page can keep at the 80% line, and "trips" in two twin cells.

Still for the owner, unchanged: D26 (the ink band for Monochrome), D16 (the stops listed twice), and the portrait in colour (recommended).
