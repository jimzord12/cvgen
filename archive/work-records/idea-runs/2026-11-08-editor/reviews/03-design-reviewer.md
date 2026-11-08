# Design review round 3: idea run 2026-11-08 (editor), five one-page travel styles

Snapshot: f1bc2bd (branch docs/idea-run-2026-11-08-editor)
Bar: `scan-first`. The `Scan Test` replaces the `Three-Second Test`. The `Batch Test` and `Flagship Parity` judge craft and order. Each mono page is judged as a design in its own right.
Batch sheets: each page placed once among eight plain market CVs, about 150 px wide, reusing the round-1 plain set:
C:\Github\cvgen\.worktrees\idea-run-2026-11-08-editor\builds\design-review-20261108-180335\batch\sheet-{rhumb-lines,airmail,timetable,poster-sun,guilloche}-{colour,mono}.png
All ten PDFs are one A4 page (595 × 842 pt). None of the ten PDFs' text still contains "Daphne", "Kontou", "herself" or "she".

**Round-2 items checked against the render:**
- **D19 (Guilloche ran short, Blocking): fixed, in colour and in mono.**
  - **The page is full.** The body now ends at about 269 mm. The engraved border sits at about 280 mm and the disclosure at about 290 mm, so the 43 mm hole is gone and the page has a clear finish.
  - **The centre rule** ends level with "9 days, organised", the end of the longer right column. The left column ends about 2 mm above it, so the rule bounds both columns.
  - **The header band** is deeper, with a larger arch portrait and name. The arch's foot sits cleanly on the wave band.
  - **The body is open.** Bullets and Education rows have air, and the section rules are heavier.
  - **The microprint line is gone.**
  - **No regressions found:** no collisions, clipping, widows or orphans, and the mono engraving holds at thumbnail size.
- **D15 (Rhumb Lines line stubs): fixed.** At 300 dpi the rays stop cleanly at the top edge of the profile panel, and no stub shows under "Valid, exp. October 2035", in colour or in mono.
- **D17 (Timetable lead-in): fixed.** Education to Languages and Skills now has about 4.4 mm, the same as Experience to Education. This holds in both versions.
- **D18 (Poster Sun journeys): fixed.** The Recent Journeys entries have clear gaps. Availability now sits in the main column under Skills, with about 5 mm left above the footer line. The left column now ends about 25 mm higher than the right. That is normal for a sidebar and is not a finding.
- **D16 (Airmail mono): closed.** The section-head dashes are hairline outlines now, so the hazard-tape echo at the heads is gone. The border stays a mid-grey stripe and now reads as post. Colour is unchanged, as claimed.
- **Run-level Note (the portrait did not match the record): closed.** The candidate is "Nikos Kontos", and "himself" and "he" are used throughout, which matches the male fictional portrait on all ten pages.
- **Notes still standing for the owner (taste, not Blocking):**
  - D2: Rhumb Lines reads as sea first.
  - D5: the Airmail body is the most template-like of the five.
  - D10: Poster Sun shares Hanami's organising idea, without Japan.
  - D20: the Guilloche field grid is the last document cue left; keep it at this strength.

## Rhumb Lines, colour: PASS
First impression: the wind rose with the portrait at its centre and the big two-line Garamond name. The eye lands on it first on its sheet.
Scan Test: name at once; current job title, employer and margin dates in about 2 s; education in about 4 s.
- No new findings.

## Rhumb Lines, mono: PASS
First impression: the black rose holds the page; the line code sits in the margins.
Scan Test: as in colour.
- No new findings.

## Airmail, colour: PASS
First impression: the red and blue border, then the stamp portrait with its postmark.
Scan Test: name in about 1 s; each job's title, employer and right-aligned dates on one line (about 2 s); education in about 3 s.
- No new findings. D5 stands as a Note.

## Airmail, mono: PASS
First impression: a grey striped envelope frame, the stamp and the PAR AVION label.
Scan Test: as in colour.
- No new findings. D16 is closed.

## Timetable, colour: PASS
First impression: the black head strip, the very tall name and the yellow bands. Still the fastest scan of the five.
Scan Test: name in under 1 s; jobs in 1 to 2 s; education years in about 2 s.
- No new findings.

## Timetable, mono: PASS
First impression: reversed black bands, strong in one ink.
Scan Test: as in colour.
- No new findings.

## Poster Sun, colour: PASS
First impression: the sunrise poster header, with the portrait as the sun over a coast and a ferry. The loudest page on its sheet.
Scan Test: name in under 1 s; jobs with coral dates flush right in about 2 s; education in about 3 s.
- No new findings. D10 stands as a Note.

## Poster Sun, mono: PASS
First impression: a one-ink linocut with clean hatched hills.
Scan Test: as in colour.
- No new findings.

## Guilloche, colour: PASS
First impression: a deep, rainbow-tinted engraved header with a large arched portrait, a bold name and a globe rosette. Below it, an engraved body that now fills and finishes the page. It is clearly the page the eye lands on.
Scan Test: name in under 1 s; jobs with mono dates flush right in about 2 s; education in about 3 s.
- D21 Nit (6): the outer ring of the rosette comes within about 0.4 mm of the right edge of the page. It sits outside the text margin and close enough to the trim to look accidental, and a printer could clip it. This was already close in round 2, so it is not a regression. Fix: either let the rosette bleed off the edge on purpose, or pull it in to about 4 mm from the edge.
- Nit (5): "Available from April 2027" appears twice, in the header field grid and again in the Availability section. Fix, if wanted: drop the AVAILABLE FROM field from the header, or shorten the section to the contract terms.
- D20 stands as a Note.

## Guilloche, mono: PASS
First impression: crisp black engraving; the rosette, the wave band and the footer border all hold at thumbnail size.
Scan Test: as in colour.
- Same as D21 and the duplication Nit.

The five are still very distinct organising ideas: a compass chart, an airmail envelope, a timetable, a travel poster and an engraved certificate. None repeats an Anti-example.

## Renders made
- At 96, 200 and 300 dpi: C:\Github\cvgen\.worktrees\idea-run-2026-11-08-editor\builds\design-review-20261108-180335\{rhumb-lines,airmail,timetable,poster-sun,guilloche}-{colour,mono}-{96,200,300}.png
- Detail crops:
  - C:\Github\cvgen\.worktrees\idea-run-2026-11-08-editor\builds\design-review-20261108-180335\zoom-guilloche-{colour,mono}-{rosette,archfoot,foot}.png
  - C:\Github\cvgen\.worktrees\idea-run-2026-11-08-editor\builds\design-review-20261108-180335\zoom-rhumb-{colour,mono}-seam.png
- The ten batch sheets listed at the top.
- A viewing strip of the four colour sheets: C:\Github\cvgen\.worktrees\idea-run-2026-11-08-editor\builds\design-review-20261108-180335\review-colour-sheets-strip.png

## Verdict: PASS
All ten pages pass. Every round-2 item is fixed: D19 (Blocking), the D15, D17 and D18 Nits, the optional D16 and the portrait mismatch. The one regression I looked hardest for was in Guilloche, since the whole page moved, and there is none. What is left is two minor Guilloche Nits (the rosette near the right edge; the availability date shown twice) and the standing taste Notes D2, D5, D10 and D20 for the owner's pick.

**Next:** the lead merges this with the Codex round-3 report. If both pass, the five styles go to the owner, who picks one as the base for the client's one-page CV.
