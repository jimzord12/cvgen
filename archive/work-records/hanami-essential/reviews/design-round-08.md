# Design review round 8: Hanami `essential` at 96742f4, 2026-11-08

Snapshot: `C:\Github\cvgen\.worktrees\hanami-essential\builds\hanami-essential-r8-20261108-174008\` (head 96742f4). Bar: `scan-first`. Showcase-monochrome is judged on the full bar.

Batch sheets: `C:\Github\cvgen\.worktrees\hanami-essential\builds\design-review-20261108-r8\batch-<render>.png`. There are 19, one per page (showcase as `-p1` and `-p2`, plus `three-quarters`), each among the same eight plain Typst CVs as in round 7 (`plain.pdf`). `batch-overview-generic.png` puts eight of them side by side.

**Verdict: PASS.** Every render passes. D30 is fixed. The grown gaps mostly read as design, but the gap between the two roles is at the limit (D32). The trip-date gap fix caused one small regression (D33), and the thin-page warning has a loophole (D34). All three are Notes.

## Round 7 items
- **D30, the generic pages ending short: fixed.** I measured at 200 dpi, against the footer rule at about 284 mm:
  - The main column now ends at 258 mm (231 mm in round 7) and the rail at 273 mm. The twin ends at 274 and 277 mm.
  - The empty block under Education is now about 113 by 26 mm, down from 50 mm.
  - The four highlight cells are honest. Each comes from the record: about 30 trips a year, the single contact seven days a week, 14 countries mostly planned herself, the certificate with the degree and English C2.
  - On the batch sheet and next to the twin, the page reads as a full page with a normal stagger between the columns.
- **The per-column warning: works.** I queried every case with the project fonts:
  - generic, generic-japan, generic-portrait, long-career and the twin return `[]`;
  - three-quarters returns "64% filled";
  - sparse returns "34% filled".
- **D31, the short arc: fixed.**
  - plain-long-name leaves the arc out and warns "33 mm of the 45 mm it needs". The band now reads as a clean typographic band with no stray mark.
  - plain-long-rank leaves it out with a portrait and warns "9 mm".
- **Codex D1, the gap between a trip's date and its day count: fixed.** It reads better on every one-line trip header, but see D33.
- **The long-career heading: fixed.** It now reads "Japan and Korea", which matches the October trip.
- **D16** (the stops listed twice): still open, as agreed.
- **D26** (the ink band for Monochrome): still the owner's call.
- **Portrait:** untouched. The diff with round 7 is empty inside the band, and my round 7 recommendation (colour) stands.

## Do the grown gaps look like design or padding?
Both gaps sit at their new caps: the role gap at 14 mm (`roomy.role`) and the section gap at 16 mm. The leftover, about 22 mm against the main column's floor, stays at the column's foot. Measured text to text, the role gap is 15.5 mm against the twin's 12.3 mm, and the section gap is 18.3 mm against 13.0 mm.
- **The section gap before "02 Education" reads as design.** It is a clear pause before a new numbered section.
- **The role gap is where it starts to read as padding.** It is almost as wide as the section break, so "Reservations Agent" floats loose from "01 Experience". At arm's length the main column shows three white bands of rising size (17, 19 and 26 mm), against a tightly packed rail.

This is acceptable, but any more growth would fail it.

## generic, generic-portrait, generic-portrait-grey, generic-japan, plain-long-rank, plain-long-name: PASS
First impression: the black name and tab on the band (or the sakura pack on generic-japan), the portrait or the arc, then the four-cell highlight row.

Scan Test: name under 1 s; each role's title, employer and dates about 1 s each; Education about 2 s; availability at the top of the rail about 2 s.

- **D32 Note (6, the role gap):** keep the role gap visibly smaller than the section gap. Fix, either one:
  - draw a hairline centred in the role gap whenever it grows past `most.role` (8 mm), so the white reads as a deliberate divider;
  - or cap `roomy.role` at about 11 mm, keeping a step of at least 4 to 5 mm below the section gap.
- **Nit (generic-portrait):** with a portrait the arc keeps its light weight. Unchanged from round 7, and acceptable.
- **Nit (plain-long-rank):** the "arc left out" warning also fires when a portrait already carries the band. The operator may not need it.

## three-quarters: PASS (as a fixture)
The warning fires at 64%, which is correct. The grown gaps cannot hide a 70 mm empty column, and they should not try. It is not a deliverable page.
- **D34 Note (the warning):** `fill` is measured after the gaps grow (`essential.typ:138-148`), so growth can lift a page over 80% while its foot stays large.
  - Growth can add about 19 mm to a two-role column, about 10 points of fill. A page with 70% content could reach 80% and stay silent with a foot of about 38 mm, close to round 7's hole.
  - The generic client page itself has about 79% content at the least gaps and passes only because of growth. Its foot is about 22 mm, so that is fine.
  - Fix: also warn when the gaps hit their roomy caps and the column still ends more than 25 mm short. That is the same threshold the growth uses.

## long-career: PASS
Scan Test: four roles in full with their lead-ins, then "Earlier roles · 4" at about 4 s.
- **D33 Note (6, a regression from Codex D1):** the wider date gap pushes "LED THE GROUP" on the October 2024 trip onto its own line, and that line also justifies wider. The April 2024 trip above it stays on one line, so two trips in one list now have different shapes. Comparison crop: `crop-long-career-trips-r7-vs-r8.png`.
  - Fix: when any trip's role tag would wrap, set every trip's tag on its own line, and do not justify the date line.
  - Or narrow the gap to about 1.8 mm in the rail.

## long-career-greek: PASS
Both "ΟΔΗΓΗΣΕ ΤΗΝ ΟΜΑΔΑ" tags now sit on their own lines, so the list is consistent. The Greek capitals are correct.

## twin, monochrome, no-portrait, indigo, sky, no-licence, greek: PASS
The only change from round 7 is the trip header gap. Every header still fits on one line ("ΟΡΓΑΝΩΣΕ" included; crop `crop-trip-headers.png`). No regressions.

## sparse: PASS (as a fixture)
It warns at 34%. The roomy gaps now apply here too, so the content floats with wide gaps. That is acceptable only because the warning stops the page before the owner sees it.

## showcase-monochrome, pages 1 and 2: PASS
They are pixel-identical to round 7.
- Page 1, Three-Second Test:
  - Domain, travel: the walking group, the plane and SKG → FUK.
  - Specialty, Japan: the torii, Fuji, 添乗員 and the 日本 stamp.
  - Rank, tour leader: the "TOUR LEADER 添乗員" tab and the flag-bearer.
- Page 2 is clearly the same CV: the mini band, the stamps and the line-art sakura.

## Renders made
In `C:\Github\cvgen\.worktrees\hanami-essential\builds\design-review-20261108-r8\`:
- `<render>-96dpi.png` and `<render>-200dpi.png` for all 19 pages
- the batch sheets `batch-*.png` and `batch-overview-generic.png`
- the greyscale checks `{generic,generic-portrait,generic-portrait-grey,monochrome}-grey-96dpi.png`
- the crops `crop-long-career-trips-r7-vs-r8.png` and `crop-trip-headers.png`
- `plain.pdf`, `sheets.py` and `measure.py` (the column ends and gaps)

## Verdict: PASS
No Blocking findings. Three Notes for the author: D32 (the role gap), D33 (the trip tag wrap, a regression from this round) and D34 (the warning loophole). D33 is the one I would fix before the owner sees long-career.

For the owner: D26 (the ink band), D16 (the stops listed twice), and the portrait in colour, recommended.
