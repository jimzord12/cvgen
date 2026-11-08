# Design review round 7: Hanami `essential` at 5adde85, 2026-11-08

Snapshot: `C:\Github\cvgen\.worktrees\hanami-essential\builds\hanami-essential-r7-20261108-172627\` (head 5adde85). Bar: `scan-first`, except showcase-monochrome, which I judged on the full bar.

Batch sheets: `C:\Github\cvgen\.worktrees\hanami-essential\builds\design-review-20261108-r7\batch-<render>.png`, one per page (18 sheets, showcase as `-p1` and `-p2`). Each page sits among the same eight plain Typst CVs as in round 6 (`plain.pdf`, copied into that folder).

**Verdict: FINDINGS.** Eleven renders pass. The six renders built on the generic record fail on one shared Blocking finding, D30: at the client's real length the main column still stops about 50 mm above the footer. The portrait treatment itself passes.

## Round 6 items
- **D23** (the generic page stopped at two thirds): partly fixed. The record is longer, and the column now ends at 231 mm instead of 200 mm. The page is still visibly short. It continues as D30.
- **The 80% thin-page warning:** it exists but does not fire for generic. I queried it with the project fonts: generic and generic-japan return `[]`, and sparse returns 36%. The check averages the two columns (`essential.typ:141`), so the long rail (about 89% full) hides the short main column (about 76%). Folded into D30.
- **D24** (the "Basic knowledge" line): fixed. It is now its own line under the list on every render.
- **D25** (no lead-ins on the long career): fixed. Long-career and long-career-greek show the bold lead-in column on all four full roles, then "Earlier roles · 4". Sparse uses no lead-ins at all, which is consistent with the "all or none" rule.
- **D26** (ink band for Monochrome): open, and the owner's call. Skipping it is right, because it needs a new theme key.
- **D28** (no-portrait arc invisible): fixed on generic. The heavier dots and the ink destination ring now read at thumbnail size, and the band's right side no longer looks empty. One new catch: D31.
- **D29** (blurred petals look like toner spots): fixed. At 200 dpi only crisp outlined petals remain, on both showcase pages (`crop-showmono-petals-left.png`, `crop-showmono-p2-petals.png`).
- **"In short":** removed.
- **D16** (the stops listed twice): still open, as agreed.

## Portrait proofs (round 6, question 4 (a) to (d)): PASS
- **(a) Generic in Monochrome with a cut-out portrait, in colour and in grey:** both render well.
  - The `d9d9d6` plate is a touch darker than the band. The white shirt holds against it, and so does the double ring (a grey outer ring, a gap the colour of the plate, then a hairline).
  - The face sits about 45% down the disc, as the cut-out record (`fictional-cutout.json`) says.
- **(b) The longest rank line** ("SENIOR TOUR LEADER | GROUP TRAVEL | TOUR LEADER COURSE · TTI · 2024"): the arc steps aside cleanly, and the band reads well without it. In generic-portrait the arc starts about 10 mm after the rank row and ends before the ring, so it clears the tab line.
- **(c) The edge, checked by me at 600 dpi** (`crop-hair-*.png`, `crop-shoulder-*.png`):
  - The hair edge is clean, with no halo.
  - Along the top of the white shirt there is a hairline darker contour from the matting, about 0.1 mm wide. In print it reads as a crisp outline, not a fringe, and it helps separate the shirt from the plate. Nit only.
- **(d) The greyscale print check:** the face, the shirt, the ring and the plate all stay distinct, and nothing merges.

**Colour or grey: I recommend colour.**
- On a Monochrome page the colour face is the only warm point, so the eye lands on the person first. That gives back some of the presence D26 says Monochrome lacks.
- It reads as a deliberate editorial choice. The grey version makes the whole page one tone, and the photo starts to look like a photocopy or an ID card.
- An employer who prints in black and white turns the colour version into the grey one anyway, so colour costs nothing.
- The cut-out has no background, so there is no colour cast at the edge to fight the grey band.
- Choose grey only if the client's own photo has a poor colour cast that cannot be corrected.

Nit for the owner: the proof puts a man's portrait on "Daphne Kontou". It is fine as a proof, but say so when you show it to him, so it is not mistaken for an error.

## generic, generic-portrait, generic-portrait-grey, plain-long-rank, plain-long-name, generic-japan: FINDINGS
First impression: the heavy black name and the black tab on the pale band, the portrait or the arc, then an empty lower-left quarter.

Scan Test: the name in under 1 s. Each role's title, employer and dates in about 1 s each. Education in about 2 s. Availability at the top of the rail in about 2 s.

- **D30 Blocking (3, 6):** this is the client's real length, and the page still ends short. Measured at 200 dpi, with the footer rule at about 284 mm:
  - the main column's last line is at 231 mm, which leaves a block about 50 by 113 mm empty under Education;
  - the rail ends at 257 mm and its wash at 265 mm;
  - the twin, for comparison, fills to 274/277 mm.

  On the batch sheet the page no longer looks unfinished. Next to the twin and the Flagship, though, a designer sees the hole at once. The real client page will look exactly like this.

  Smallest fix, in this order:
  1. Give generic the four-highlight row under the profile, drawn from the profile so nothing new is claimed. That is the band the twin has and generic lacks; it takes about 20 mm and moves both columns down.
  2. If the main column still ends more than about 25 mm short, let the role and section gaps grow past their caps.
  3. Make the warning check each column on its own (the smaller of the two, not the average), so a short main column is flagged.
- **D31 Note (1, plain-long-name):** with no portrait and a long name, only about 32 mm of room is left. The arc then shrinks into a thin, faint mark at the top right that reads like a stray. Fix: keep the no-portrait weight at every length, or raise the threshold for leaving the arc out from 30 mm to about 45 mm.
- **Nit (generic-portrait):** with a portrait the arc keeps its light weight, so between the name and the photo it reads faintly. It is acceptable, because the portrait carries the band.
- **Generic-japan:** the same as generic, with the Japan pack, and it looks right. D30 applies.
- D16 still applies ("Knows well" repeats the stops).

## twin: PASS
First impression: the pink band, the black name and the portrait, then the column of bold lead-ins.
Scan Test: the same as round 6, about 1 to 3 s per field. D24 is fixed. D16 is open.

## monochrome: PASS
First impression: the black name and black tab, then the colour portrait. The band is still faint at thumbnail size (D26 is the owner's call).

## no-portrait, indigo, sky, no-licence, greek: PASS
No regressions. The Greek capitals are correct ("ΑΡΧΗΓΟΣ ΟΜΑΔΑΣ", "ΑΔΕΙΑ · ΙΣΧΥΕΙ ΕΩΣ 31 ΜΑΡ 2029", "ΔΙΑΘΕΣΙΜΟΣ ΟΛΟ ΤΟΝ ΧΡΟΝΟ").

## long-career, long-career-greek: PASS
Scan Test: four roles in full, each with its lead-in column, then "Earlier roles · 4" at about 4 s.
- Nit (8): Destinations is headed "Japan · 2 trips · 9 places", but the October trip is "Japan and Korea" and counts Seoul and Busan. Fix: head it "Japan and Korea".
- Nit (6, Greek): "ΟΔΗΓΗΣΕ ΤΗΝ ΟΜΑΔΑ" wraps onto its own line under the day count. This is acceptable.

## sparse: PASS (as a fixture)
The warning fires at 36%, which is correct. It is still not a deliverable page.

## showcase-monochrome, page 1: PASS
First impression: the grey torii around the portrait, the black stamp, SKG → FUK.

Three-Second Test:
- Domain, travel: the walking group, the plane and SKG → FUK.
- Specialty, Japan: the torii, Fuji, 添乗員 and the 日本 stamp.
- Rank, tour leader: the "TOUR LEADER 添乗員" tab and the flag-bearer leading the group.

D29 is fixed.

## showcase-monochrome, page 2: PASS
It is clearly the same CV as page 1: the mini band with the group, the torii and SKG → FUK, the black stamps and the line-art sakura. D29 is fixed.

## Renders made
In `C:\Github\cvgen\.worktrees\hanami-essential\builds\design-review-20261108-r7\`:
- `<render>-96dpi.png` and `<render>-200dpi.png` for all 18 pages
- the batch sheets `batch-*.png`
- the black-and-white checks `{generic,generic-portrait,generic-portrait-grey,monochrome}-grey-96dpi.png`
- the band crops `crop-band-*.png` and `crop-bands.png` (the arc in four cases)
- the portrait edge checks `crop-portrait-600dpi-*.png`, `crop-shoulder-*.png` and `crop-hair-*.png`
- the petal checks `crop-showmono-petals-left.png` and `crop-showmono-p2-petals.png`
- `plain.pdf` and `sheets.py`

## Verdict: FINDINGS
Fix D30 before round 8. It is one fix for all six generic-based renders: the highlight row, then wider gaps if still needed, then a per-column warning. Notes to bring to the owner:
- D26, the ink band, his call;
- D31, the short arc;
- D16, the stops listed twice;
- the portrait choice: colour recommended, with the reasons above.
