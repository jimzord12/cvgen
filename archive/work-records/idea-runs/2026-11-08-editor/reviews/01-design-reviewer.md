# Design review round 1: idea run 2026-11-08 (editor), five one-page travel styles

Snapshot: e3be504
Bar: `scan-first`. The `Scan Test` replaces the `Three-Second Test`. The `Batch Test` and `Flagship Parity` judge craft and order.
Batch sheets (each design shown once among 8 plain market CVs, about 150 px per page):
C:\Github\cvgen\.worktrees\idea-run-2026-11-08-editor\builds\design-review-20261108-173937\batch\sheet-{rhumb-lines,airmail,timetable,poster-sun,guilloche}-{colour,mono}.png

**Run-level findings:**
- **The five are truly distinct.** Each has its own organising idea, type voice and palette: a serif sea chart, a typed airmail letter, a condensed ruled table, a flat screenprint poster and an engraved document card. None is a variation of another.
- **No Anti-example repeated.** Nothing uses Stoichedon's letter-cell grid or Two Inks' misregistered orange slabs and giant numerals.
- **Earlier concepts:** Timetable is not Concourse (printed table, not LED signage). Airmail is not Stamp Rally (postal, not boarding pass and rubber stamps). Two kinships go in the Notes below: Poster Sun and Hanami, Guilloche and Stamp Rally.
- **Guilloche does risk reading as an imitation of an official ID.** Blocking, D9, with a narrow fix.

## Rhumb Lines, colour: PASS
First impression: the 32-point wind rose with the portrait at its centre, on vellum; the large two-line Garamond name.
Scan Test: name at once; current job (title, employer, dates in the margin column) in about 2 s; education in about 4 s, in the first column of the lower band, with years in small vermilion under each entry. All found.
- D1 Note (6): the rhumb lines cross the body text everywhere, including the date column and the bullets. They are faint in colour but compete with 9 pt type. Fix: knock the lines out behind the text blocks (a paper-coloured fill under each block), or stop them at the body's edge.
- D2 Note (4): a compass rose and a portolan chart lean nautical, and CVgen's Marine Flagship lives next door. It is fine for "travel", but the owner should know it reads as sea first.
- D3 Nit (6): the availability cartouche has about 15 mm of dead space under the journeys strip. Runt line "education" in the Education column.

## Rhumb Lines, mono: PASS
First impression: the black rose holds the page; a real one-ink line code (solid, dashed, dotted), not a greyscale.
Scan Test: as in colour; dates are bold black and still quick.
- D4 Note (6): this is D1, stronger. The solid grey rhumb verticals at about 26 mm and about 196 mm run straight through "04/2022", "05/2020", the education years and the skills column. On a photocopier they will darken. Fix: as D1, or make every line dotted in mono.

## Airmail, colour: PASS
First impression: the red and blue airmail border round the whole sheet; the perforated stamp portrait with its postmark.
Scan Test: name in about 1 s; each job has its title, employer and dates flush right on one line (about 2 s); education is a labelled row with typed years (about 3 s). This is the second-fastest scan of the five.
- D5 Note (4): the body is a plain hanging-label single column; the border and the stamp carry the whole design. That is acceptable under `scan-first`, but it is the most template-like body of the five.
- D6 Nit (6): runt lines "40." (Skills) and "herself." Fix: rewrap or set the column a touch narrower.

## Airmail, mono: PASS
First impression: the striped frame, then the stamp. It stands out on the sheet.
Scan Test: as in colour.
- D7 Note (3), flagged for the owner: at full size, the three-tone border (charcoal, mid-grey, white) reads more as barrier or hazard tape than airmail. The brief admits the risk. With the red and blue gone, only the "PAR AVION" label and the stamp still say "post". Fix: one ink only, a single dark grey alternating with white (drop the mid-grey bar), about 30 % thinner. Or invert it as hairline-outlined bars, as one-colour airmail stationery was printed.

## Timetable, colour: PASS
First impression: the black head strip, the very tall condensed name and the signal-yellow bands. Pure order.
Scan Test: the fastest of the five. Name in under 1 s; job start dates in 22 pt numerals with role and employer beside them (about 1 to 2 s); the education band has years in 17 pt numerals (about 2 s).
- D8 Note (6): the portrait's white shirt runs into the white page at the foot of the yellow cell, so the cell loses its bottom edge and the hard-edged "table cell" idea goes soft there. Fix: end the cell with a 0.6 pt rule at its foot, or crop so yellow shows under the shoulders. Nit: runt line "40." in Skills. The domain is said only through five small pictograms, which is right for this bar.

## Timetable, mono: PASS
First impression: reversed black bands. Strong, and the most natural one-ink page of the five.
Scan Test: as in colour.
- Same as D8: the shirt meets white under a grey cell.

## Poster Sun, colour: PASS
First impression: the sunrise poster header, with the portrait as the sun over a coast, a ferry and a plane. The loudest page on its sheet.
Scan Test: name in under 1 s; the experience column on the right gives title, employer and coral dates flush right (about 2 s); education under it (about 3 s).
- D10 Note (4), flagged for the owner: this repeats Hanami's organising idea (an illustrated landscape header with the portrait in a circle as its focal point) in a generic country. No one would mistake one for the other, and it may be exactly what the client wants ("Hanami, not Japan"). But the owner should see it as kin, not a new idea.
- D11 Note (4): the plane with a dashed trail is the stock travel-template motif and the one clip-art note in a well-drawn scene. Fix: drop it, or draw it as a contrail in the sky bands.
- D12 Nit (6): the contact separators "●" fall back to Libertinus Serif because Jost lacks U+25CF. Draw a circle instead. "Vienna · Salzburg · Munich" wraps where the other two journeys do not. "Skills & travel experience" wraps to two lines.
- Composition note: Rhumb Lines and Poster Sun share the same head layout, a big two-line name at top left and a portrait in a ray-burst circle at top right. Different enough in voice, but if the owner picks both for comparison, move one of them, for example Poster Sun's sun centred on the horizon.

## Poster Sun, mono: PASS
First impression: a convincing one-ink linocut, with black sea and headland and white glints cut out. It is a real mono design, not a greyscale.
Scan Test: as in colour.
- Nit (6): the hairline tint on the far hills shows faint vertical tile seams at 300 dpi and may moiré on a copier. Fix: draw the hatching as one set of lines clipped to the shape, not tiles.

## Guilloche, colour: FINDINGS
First impression: a rainbow-tinted data card with a rosette and an MRZ. It stands out on its sheet.
Scan Test: name in about 1 s, slowed slightly by the surname-first form "KONTOU, Daphne"; jobs show title, green employer and mono dates flush right (about 2 s); education is bottom left (about 3 s).
- D9 Blocking (7, borrowed look), the lead's question answered: yes, it reads as an imitation of an official ID. Three passport data-page features together make it so:
  - the ghost portrait, a document security feature with no CV purpose;
  - a machine-readable zone in true ICAO TD3 grammar, carrying a nationality code (GRC) and a date of birth in YYMMDD (970504);
  - the "SURNAME, GIVEN NAME" field label with the name printed surname-first.

  At arm's length the page says "passport", not "CV styled as engraving". A real client may be uneasy carrying it, and an HR reader may read it as a gimmick.

  The engraving itself (rosette, wave bands, rainbow tint) is original, crafted and passes. Fix, keeping the idea:
  - remove the ghost portrait; put the globe or her monogram in the rosette's centre;
  - drop GRC and 970504 from the second line, so it stops being decodable ID data (for example `TOUR<LEADER<<TRAVEL<CONSULTANT<<<<<<<`);
  - set the name in reading order, "Daphne Kontou", which also helps the Scan Test.
- D13 Note (4): the card-header-with-fields structure is close to Stamp Rally's boarding-pass head. Acceptable once D9 is fixed, because the object and the craft differ.

## Guilloche, mono: FINDINGS
First impression: a white card with grey engraving. It is the quietest page in the run on its sheet, but the card outline and the MRZ still catch the eye.
Scan Test: as in colour.
- D9 Blocking: as in colour.
- D14 Note (1): below the card the page is plain, so the card must carry everything in mono. Fix: engrave the rosette and the wave bands about one step darker (black at 0.25 pt rather than grey hairlines), so the card holds at thumbnail size.

## Renders made
- At 96 and 200 dpi: C:\Github\cvgen\.worktrees\idea-run-2026-11-08-editor\builds\design-review-20261108-173937\{style}-{colour,mono}-{96,200}.png
- Detail crops: C:\Github\cvgen\.worktrees\idea-run-2026-11-08-editor\builds\design-review-20261108-173937\zoom-*.png
- The plain batch set: C:\Github\cvgen\.worktrees\idea-run-2026-11-08-editor\builds\design-review-20261108-173937\batch\plain.typ, its plain.pdf (10 market-style CVs), and plain-1.png to plain-10.png
- The ten batch sheets, listed at the top.

## Verdict: FINDINGS
Eight designs pass: Rhumb Lines, Airmail, Timetable and Poster Sun, in colour and in mono. Guilloche fails in both versions on one Blocking finding (D9, it reads as an imitation ID). The fix is narrow and keeps the engraving idea; after it, Guilloche returns to both design gates. The run's five styles are distinct and repeat no Anti-example. Notes for the owner's eye: D2 (Rhumb Lines leans nautical), D7 (the Airmail mono border reads as hazard tape) and D10 (Poster Sun is Hanami's organising idea without Japan).
