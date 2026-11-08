# Design review round 1: Hanami `showcase` (travel, Japan tour leader), Template port

Snapshot: Twin `C:\Github\cvgen\.worktrees\travel-domain\builds\tests-20261108-123156-201976\tour-leader\tour-leader.pdf`. Its render check (`check/result.json`) shows it matches the approved `tests/approved/Travel-Tour-Leader-CV-v01.pdf` raster for raster and text for text. Themes and the no-portrait record come from `builds\travel-5\`. The reference is `builds\travel-3\`.

Batch sheets: there is one per page under review. Each holds 10 plain market CVs (single column, grey two-column, teal sidebar, timeline, blue header band, right sidebar with skill bars, pastel creative, serif minimal, green photo header, dark header). Each tile is 150 px wide.
- `C:\Github\cvgen\.worktrees\travel-domain\builds\design-review-20261108-123401\batch-sheet-sakura-p1.png`
- `...\batch-sheet-sakura-p2.png`
- `...\batch-sheet-indigo-p1.png`
- `...\batch-sheet-indigo-p2.png`
- `...\batch-sheet-sky-p1.png`
- `...\batch-sheet-sky-p2.png`
- `...\batch-sheet-noportrait-p1.png`

This is a port of a client one-off, so I read criterion 4 as "faithful to the chosen concept" and did not apply criterion 8. There are no Blocking findings. Several Notes are worth fixing before a second record uses the template.

**Fidelity to the reference:** the Sakura twin matches `travel-3/tour-leader.pdf` pixel for pixel on page 2. On page 1 the only difference is inside the 24/7 box (x 118–186 mm, y 202–223 mm), where the record's text was edited ("moved their farewell dinner booking", "emergency passport appointment"). The line count is the same, so the layout is unchanged. The port is faithful.

## Sakura, page 1: PASS
First impression: a pink band with a torii framing the portrait in a gold ring, cherry canopy, Fuji, a line of travellers led by a red flag, and SKG ····✈ OSA running through a cream name plate. It is the page the eye lands on in the batch.
Three-Second Test:
- **Domain (travel):** the travellers with suitcases, the airport codes and the plane.
- **Specialty (Japan):** the torii, Fuji, the sakura canopy, seigaiha waves and the 日本 seal.
- **Rank (Tour Leader):** the figure with the flag leading the group says it pictorially even at thumbnail size, and the red "TOUR LEADER 添乗員" tab confirms it at arm's length.

Flagship Parity: richer than the Flagship (same house skeleton of band, central emblem and plate, numbered sections) and just as crafted. Works in black and white (`grayscale-check.png`).
- D1 Note (Craft): the availability text breaks a date across two lines: "Passport valid until 2 / May 2033." (right column, about y 108 mm). `availability.text` is the one running text that does not go through `keep-end`. Fix: run it through `keep-end` in `profile()` (sections.typ), or make the rendering keep day-month-year together with non-breaking spaces. Either fix changes the approved PDF, so it means a new approved version.
- D2 Note (Craft, robustness): the email fills its 50 mm contact column almost exactly (measured 49.8 mm). A slightly longer address will wrap silently, splitting the address in the middle, and drop towards the flag-bearer. Fix: in `contact-column`, add `assert(measure(value).width <= 50mm, …)` naming the field, so the failure is loud.
- D3 Note (Craft, robustness): the red rank tab is a fixed 38 mm, and "TOUR LEADER 添乗員" already fills about 32 mm of it. A rank such as "Senior Tour Leader" would wrap and spill out of the 5.6 mm tab with no error. Fix: measure the tab content and assert it is at most 38 mm minus 4 mm of padding, or size the tab to its content with a min/max and assert the max.
- D4 Nit (Craft): the 1fr split leaves about 15 mm between the Travel Consultant job and the Intern job, so the Intern entry floats. The reference does the same and the owner picked it, so it is optional. Fix: cap the job gap, for example `v(1fr)` with a maximum through a measured spacer, or move the extra space below the last job.
- D5 Note (copy, not design): the Milos case uses "moved" twice in one sentence ("He moved them… and moved their farewell dinner booking"). Fix in `examples/candidates/tour-leader-example.json`, line 52.

## Sakura, page 2: PASS
First impression: a shallower band of the same pink with the name, a red credential seal, SKG→OSA and the travellers with torii and Fuji, then two large red eki stamps. It stands out in the batch, which no plain continuation sheet does.
Connection to page 1: the same band colour, seigaiha and line art, the same route codes, the same red seal language, the 02/03/04 numbering carrying on from 01, and the same footer. It is clearly the same CV, and the stamps make it a destination page in its own right.
- D6 Note (Print robustness): on page 2 the SKG/OSA codes start 4.6 mm from the top trim (measured from the 200 dpi render). Many office lasers and inkjets cannot print the top 4–5 mm, so the codes risk being clipped on the HR desk printer. Fix: move `y0` in `band()` from 4.6 mm to at least 7 mm; the band has room. The name, at 8.4 mm, is safe.
- D7 Nit (Craft): the leader's flag touches the left end of the torii's lower beam in the page 2 band (about x 143–148 mm, y 18 mm). The two shapes meet tangentially and the edge looks accidental. Fix: move the group 2–3 mm left (`GX`) or the torii 2 mm right.
- D8 Nit (Craft): `keep-end` breaks "regional rail passes and shinkansen / seat reservations" early, leaving a short ragged first line in Practical Know-How. This is acceptable as it is. Fix only if wanted: apply `keep-end` only when the item is longer than one line.
- D9 Note (copy): "Kanazawa and Shirakawa-go, Nikko, Sapporo" puts "and" in the wrong place, in the Regions box. Fix in the record, line 122.
- D10 Nit (Craft): there is about 25 mm of blank paper beside the Regions box under the October card. It is inherited from the reference and only a balancing nit.

## Indigo, page 1: PASS (stale render, see D12)
First impression: the strongest of the three themes on the batch sheet. A deep navy band with brass torii, travellers and Fuji, and the red seal glowing against it. The Three-Second Test elements are the same as Sakura's and read even faster. Contrast holds: brass labels on navy are about 7:1 and the cream text is high contrast.
- D11 Note (Craft, print): on the navy band the out-of-focus "flying" petals render as blurred pink-grey discs. They are on the torii's left post (about x 67 mm, y 25 mm), beside "Greek" (about x 204 mm, y 28 mm) and at the left of the page 2 band (about x 6 mm, y 14 mm). On a dark ground in print they read as smudges, not bokeh. Fix: for indigo, set `sakura.fly` to sharp petals only (drop the blurred layer from `petals-p*-hero` for this theme), or lower their alpha to about half.

## Indigo, page 2: PASS
The navy band is the same as page 1 and the connection is immediate. D6, D7 and D11 apply.

## Sky, page 1: PASS
First impression: a mizu-iro band with navy line art. It is the calmest theme, but the torii, portrait and red seal still win the batch sheet. The Three-Second Test elements are the same as Sakura's. Navy on light blue is about 6:1.

## Sky, page 2: PASS
This is the weakest Batch Test of the run: a blue header band is the one device the mass-market templates also have. The two red stamps and the band's line art still make it the page you stop on. It passes, but only just. D6 and D7 apply.

## No portrait (Sakura), page 1: PASS
The fallback is "AK" in the display face, set on a cream disc inside the gold ring with the seal still attached. It is honest and tidy, and the page keeps every domain signal, so it still wins the batch sheet.
- D13 Note (Craft, taste): the plain initials disc reads a little like a placeholder next to so much drawn artwork. Fix (optional): give the disc a pale seigaiha or sakura wash in the theme's `plate` tone, or set the initials with a hairline inner ring like the stamps, so the empty disc looks drawn rather than missing.

## No portrait, page 2: PASS
Pixel-identical to Sakura page 2, as it should be.

## Across themes
- D12 Note (Evidence): the travel-5 theme renders were built from an older version of the record (Milos "shifted their Athens dinner booking", Kefalonia "consulate appointment in Athens"), so they do not match the twin's current text. The layout is unaffected, because the line count is the same. Fix: re-render indigo, sky and no-portrait from the current record before the owner sees them.
- Provenance: all fonts are OFL and bundled with their licences in `packages/cv-framework/fonts` and `licenses/`: Source Sans 3, Sofia Sans Extra Condensed, Barlow Condensed, M PLUS 1p and Kaisei Tokumin. All the Japanese is correct: 添乗員, 日本, 長崎, 金沢, and each stop's kanji matches its romaji (大阪, 姫路, 岡山, 直島, 金沢, 白川郷, 名古屋, 日光, 仙台, 函館, 札幌; 福岡, 長崎, 熊本). The data is fictional and the disclosure is in the footer.
- Distinctness: it shares the Flagship's house skeleton (band, central portrait emblem, overlapping name plate, numbered sections), but its own idea is the route through the name plate plus the stamp passport, and it cannot be mistaken for the Flagship. It does not repeat either Anti-example (Stoichedon, Two Inks).
- Loud failure: the visible page is protected by the slot overflow asserts, the name-versus-plate width check, the three-contacts-a-side limit, the page 2 seal-versus-travellers check, the stamp rim-length check and the exact page count. Gaps that would fail silently on the page: D2 (contact width), D3 (rank tab), and the highlights row, where `highlights` has no `len() <= 4` assert and a fifth cell would quietly wrap into a second row. Fix: add `assert(highlights.len() <= 4, …)` in `profile()`.
- Print: there is full bleed on both bands. Office printers will show a white frame around it, the same trade-off as the Flagship and acceptable. The seigaiha at 0.12–0.13 opacity may disappear on a laser printer, which is cosmetic only.

## Renders made
`C:\Github\cvgen\.worktrees\travel-domain\builds\design-review-20261108-123401\` contains:
- page renders at 96 and 200 dpi: `sakura-`, `reference-`, `indigo-`, `sky-` and `noportrait-` `p1/p2-96|200.png`
- detail crops: `crop-sakura-p1-hero.png`, `crop-indigo-p1-hero.png`, `crop-sky-p1-hero.png`, `crop-noportrait-p1-ring.png`, the `crop-*-p2-band.png` files, `crop-sakura-p2-trips.png`, `crop-sakura-p2-bottom.png`, `crop-sakura-p1-profile.png`, and `crop-support-box-compare.png` (twin, reference and indigo stacked)
- `grayscale-check.png`
- the plain CVs: `batch\plain.typ` and `batch\plain-01..10.png`
- the seven batch sheets listed above

pymupdf is not installed, so I rendered with pypdfium2.

## Verdict: PASS
Every page and every theme passes, with Notes. In priority order:
1. D6: page 2 route codes 4.6 mm from the trim.
2. D2, D3 and the highlights assert: silent overflow risks for the next record.
3. D1: a date split across lines.
4. D11: smudge-like blurred petals on indigo.
5. D12: re-render the themes from the current record.

D5 and D9 are copy fixes in the fictional record.
