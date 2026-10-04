# Hanami Line 2

**Idea in one line:** version 2 of Hanami Line, built from the owner's notes on v1 ("a nice blend between the two templates, and I do like the breather room"). It keeps Flagship's skeleton with Stamp Rally's identity. On top of that it adds a soft sakura palette, petals in flight instead of a third branch, a calm layer of pale Japan background pieces, a structured profile, a lifted name plate, and redrawn artwork throughout.
Three words: *travel, Japan, blossom*.

One-design run 2026-10-02 (magazine-editor). `Domain` Travel & Tourism; specialty Japan; role Αρχηγός-Συνοδός Εκδρομών. Spacious `Density`, Stylish `Design Tier`, two A4 pages. Status: chosen by the owner, 2026-10-02 (all three palettes; first client build is a real `Travel & Tourism` client's CV). v1 stays untouched in `../2026-10-02-hanami-line/` for comparison.

| PDF | Palette | Meta File style |
|---|---|---|
| `spacious/stylish/spacious-stylish.pdf` (main) | **Soft**: dusty sakura band, aubergine type and line art, cinnabar seals, rose-gold numbers | Hanami Line 2 |
| `concept-indigo.pdf` | v1's **indigo**, with every v2 change applied: the palettes can be compared with everything else equal | Hanami Line 2 indigo (variant `indigo`, density spacious, tier stylish) |
| `concept-blue.pdf` | **Light blue** (owner's third variation): a mizu-iro sky band, navy type and line art, the same cinnabar and gold | Hanami Line 2 blue (variant `blue`, density spacious, tier stylish) |

All three come from one source, `hanami.typ` (`render("soft")`, `render("indigo")`, `render("blue")`). The entry points are `spacious/stylish/spacious-stylish.typ`, `concept-indigo.typ` and `concept-blue.typ`. The indigo and blue PDFs sit at the concept root because the `Output Contract` accepts only `safe`, `stylish` and `creative` as tier folders, so a `stylish-indigo/` folder would fail `scripts/outputs.py check`.

## What the owner should notice first

The soft palette: a dusty sakura band (`#dea1ae`) with a lighter bloom behind the portrait. The torii, the group and Fuji are drawn in deep aubergine, the seal and the ΑΡΧΗΓΟΣ tab stay cinnabar, and the name plate now floats on a soft shadow. Then the petals: rounded, shaded petals drifting off the canopy, across the top of the band and down both margins of both pages, some soft-focus, some in tiny clusters.

## Changes against v1, per owner note

1. **Nature.**
   - Kept: the band canopy and the page-2 branch. The page-2 branch now has a closed top, sits 2 mm under the band and is 6 mm clear of the table header.
   - Removed: the page-1 branch beside section 01.
   - Added: petals in flight on both pages (51 on page 1, 40 on page 2). They follow wind trails (cubic paths) and vary in size, rotation, foreshortening, skew and opacity. All are crisp: about 14 % are simply fainter, with no blur, so nothing is rasterised. Some ride in tiny clusters. Each page is laid out once and split at the band edge, so trails cross the edge without a petal being sliced. The margins are thinned to irregular drift, and trails cross the open gaps: along the profile rule, between the stamps and section 02, between sections 04 and 05, under the lists, and across both band edges.
   - They avoid every text block by construction: the generator works from keep-out rectangles copied from the page plan. A check (`builds/hanami-scratch/petalcheck.py`) parses every petal and every text span in the PDF and finds 0 collisions on both PDFs.
2. **Depth.** Five pale background pieces, one calm layer, never behind text or the table:
   - seigaiha waves, tone-on-tone, as the sea under the horizon in both lower corners of the page-1 band and along the page-2 band;
   - a Shinkansen beside heading 01;
   - two paper lanterns beside heading 02;
   - an open folding fan beside heading 04;
   - a five-storey pagoda beside heading 05.
   On paper they sit at about 3 % fill and 7 % line tone of the ink.
3. **SVG quality.** Everything was redrawn in one visual language: fixed limb weights, 1.4/0.8 line weights in the stamps, one petal construction everywhere. Pieces were checked in 200 and 300 dpi crops, and the weakest (maple leaf, seasons icon, canopy seed, stamp stars) were redone over several rounds:
   - **Group:** six travellers with varied heights and poses. A woman in a sun hat with a roller case, a man with a backpack, a woman in a dress with a shoulder bag, a tall man in a cap with a roller case, a traveller raising a phone, and the leader mid-stride raising the flag, with a lanyard badge.
   - **Torii:** kasagi with sori and its top board, shimaki, gakuzuka, a nuki running through the posts, tapered inward-leaning posts (uchikorobi), daiwa rings, kusabi wedges, nemaki bands and kamebara feet.
   - **Fuji:** a soft sun, two layered strata, a snow cap with uneven tongues, gully lines.
   - **Plane:** rounded nose, swept wings with two engines, tailplane.
   - **Stamps:** six new drawings (torii with blossom, book with ribbon under the sun over the bay, a seven-lobed maple leaf with veins over the snow-capped Alps, a dendrite snow crystal, the group behind the flag by the lake with Fuji, the national Fuji seal). Each has a double-ring rim and set rim type with small four-point stars as separators.
   - **Sakura:** tapered bark with a light edge, horizontal lenticels and spurs, petals shaded from a deeper base, faint veins, filaments with anthers, two-tone buds with a calyx.
4. **Profile.** The text paragraph is now a designed block built only from the record:
   - the lead statement "Αρχηγός-συνοδός με εξειδίκευση στην Ιαπωνία";
   - the free briefing offer beside it, behind a cinnabar rule;
   - a rose-gold hairline;
   - four aligned cells, each with a drawn icon: **Όλες οι εποχές** (all seasons, Fukuoka study), **Συν-αρχηγία** (group trip to Japan, spring 2026), **Ακρίβεια** (headcounts, vouchers, daily report; calm under pressure), **Διαθεσιμότητα** (10–15-day trips, consecutive departures).
   The cell titles are headings drawn from the profile's own words; nothing new is claimed.
5. **Soft palette.** The main PDF (tokens below). The Batch Test is compensated with a richer dusty rose rather than a pastel, bold aubergine type and art, and the cinnabar seal and stamps. It also survives greyscale.
6. **Name plate.** A soft shadow under the plate, about 2 mm down and roughly 16 % at its core, built from nine stacked translucent layers (vector, so it prints and photocopies cleanly). Page 2 has no plate.

**Leftover reviewer nits, done:**
- the first-aid validity date is now in indigo/aubergine, not cinnabar;
- the metrics strip has four equal columns;
- page-2 Fuji is 40 mm, so its snow cap clears the torii's right post;
- the date column sets "–" in Barlow and "σήμερα" in Source Sans 3 semibold;
- the branch is 6 mm clear of the table header.

**Kept as liked:** the hero composition, the torii around the portrait, the stamp row, the breathing room (no spacing was tightened; every slot still asserts its height and fails loudly), the manifest, the metrics strip, the numbered sections, the date column.

**Round 1 review, done:**
- D4: the page-2 "Ιαπωνία 日本" on the soft band is now in the band's label ink, with only a small cinnabar dot (cinnabar text on the pink measured 2.5:1).
- D3: band labels deepened to `#5a2840` (5.4:1).
- D1: blur dropped.
- D2: petals re-laid out (see note 1).
- D5: the metrics are centred in four equal cells.
- Nits: the nuki is shortened and the page-2 Fuji (38 mm) clears it; en dashes inside Barlow figures (years, date column) are set in Source Sans so they read as dashes; the Fuji sun is a single soft disc with a faint halo; the seasons icon is now one clean mark (a blossom in a ring, four season points); the Fuji body is tinted indigo-grey on indigo (a separate tone token).

**Owner review of v2, done (round 3):**
1. **Portrait ring:** now a gold ring (2.1 pt) with a warm soft glow, built from eleven stacked translucent discs (vector, prints cleanly). The halo is softer on indigo. Both solid seals get a thin cream outline. Gold and cinnabar were compared side by side on the pink band, and **gold was chosen** for all three palettes: a cinnabar ring merges with the cinnabar 日本 seal sitting on it and competes with the ΑΡΧΗΓΟΣ tab, while gold pairs with both and lifts the portrait on pink, blue and indigo alike.
2. **Page-1 seigaiha:** one continuous band, full width, under the bloom, running behind the name plate and its shadow. Its top row is complete arcs (centres one radius below the edge), so the band ends in a clean scalloped line with no cut arcs or vertical cuts.
3. **Route:** on both pages the plane's centre axis and the dotted line sit on the middle of the ATH/TYO cap height, measured in Typst rather than placed by eye. At 300 dpi the plane, dots and TYO centres agree within 1 px (about 0.1 mm).
4. **Distant petals restored:** about a quarter of the petals (23 of 97) are distant ones: 1.45–1.8× larger or 3.4–4.8 mm, rounder, 45–60 % opacity and blurred with a Gaussian blur. The rest are crisp. Their blur keeps a 2.2 mm reach beyond their size, clear of text and small labels; a few drift off the page edge. 0 collisions with text on all three PDFs.
5. **Page-2 seigaiha:** **kept, softened**. It now has complete top scallops and a gradient mask that fades its right half to nothing before the travellers, so there is no hard vertical cut. It reads as a quiet sea under the name, which was worth keeping; removing it would leave the left half of the band flat against the page-1 band.
6. **Third palette, light blue:** tokens below. Band text measures 7.8:1 and band labels 6.0:1.

**Reviewer leftovers, done:**
- Petals no longer bead along the profile rule: three drift across it, off the line.
- The last three words of every bullet hold together, so "ρυοκάν." is never alone.
- Page 1 was lifted 1.2 mm from the profile down and the experience gaps trimmed; the last line now ends about 7 mm above the footer rule.
- The page-2 right-margin run beside section 03 is thinned.
- The escort seal now reads ΣΥΝΟΔΟΣ · 6 ΟΜΑΔΕΣ · 162 ΘΕΣΕΙΣ.
- The indigo sun is warm cream-brass, and the indigo paper labels are `#7a5d29` (5.4:1).

## Palette tokens

| Token | Soft | Indigo | Blue |
|---|---|---|---|
| Band / bloom | `#dea1ae` / `#f3d0d5` (radial, behind the portrait) | `#1e2852` / none | `#9cc2de` / `#d9e9f4` |
| Text and line art on the band | `#2a1f3d` / `#3a2c55` | `#fbf7ee` / `#c4a265` | `#13284a` / `#1f3562` |
| Labels on the band | `#5a2840` (5.4:1) | `#c4a265` | `#1d3a66` (6.0:1) |
| Paper / ink / muted | `#faf6ef` / `#231f38` / `#625d72` | `#f8f4ea` / `#1b2036` / `#5d6377` | `#faf6ee` / `#1b2238` / `#5b6274` |
| Section numbers, hairlines, plate keyline | rose-gold `#b5835e` | brass `#c4a265` | soft gold `#b08a4c` |
| Field labels, icons | `#8a5f3e` (5.2:1) | `#7a5d29` (5.4:1) | `#75582a` (6.1:1) |
| Dates, rules, table header, metrics strip | `#3a2c55`, `#2e2448` | `#28356a`, `#1e2852` | `#1f3562`, `#1c3157` |
| Cinnabar (seals, stamps, plane, tab, day counts, the Japan manifest row; never text on a light band) | `#c23a2b` | `#c23a2b` (lightened on the band) | `#c23a2b` |
| Sakura on the band | white-pink petals, aubergine bark at 42 % | warm pink petals at 100 % (flying) and 82 % (canopy) | white-pink petals, navy bark at 38 % |
| Portrait ring / glow | gold `#a77a2c` / cream `#fff1d6` | gold `#d9b46a` / `#f1d79c` (softer) | gold `#a77a2c` / cream `#fff3d8` |
| Sun behind Fuji | `#fbf3ef` | warm `#e8cf98` | `#fbf0d6` |

## `Three-Second Test` (each page alone)

- **Travel:** ATH → TYO with the plane, the stamp row, the manifest and the metrics strip, the travellers' cases, the Shinkansen.
- **Japan:** the torii, Fuji, the 日本 seal, kanji on every stamp, cherry blossom and petals, seigaiha, lanterns, fan, pagoda.
- **Escort:** the leader's flag over the group (both bands and the 2026 stamp), the ΑΡΧΗΓΟΣ 添乗員 tab, the escort seal on page 2, the manifest.

## Assets (all original, written by `assets/make_assets.py`)

| File | What it is |
|---|---|
| `sakura-canopy.svg`, `sakura-field-2.svg` | The band canopy (80 × 16 mm, seed 1141) and the page-2 branch (90 × 20 mm, seed 4248), each drawn into its exact frame; only the page edge may cut them |
| `petals-p1-hero.svg`, `petals-p1-field.svg`, `petals-p2-hero.svg`, `petals-p2-field.svg` | Petals in flight in page coordinates, laid out against the page plan's keep-outs |
| `torii.svg`, `fuji.svg`, `group.svg`, `plane.svg` | Band line art |
| `stamp-torii`, `-book`, `-maple`, `-snow`, `-flag`, `-fuji.svg` | Single-ink stamp drawings (40 × 40) |
| `icon-seasons`, `-flag`, `-check`, `-calendar.svg` | Profile icons (24 × 24) |
| `bg-seigaiha-band`, `bg-seigaiha-p2`, `bg-shinkansen`, `bg-lanterns`, `bg-fan`, `bg-pagoda.svg` | Pale background pieces: the continuous page-1 sea, the faded page-2 strip, and four paper pieces |

Colours are tokens (listed in the generator's docstring) that `hanami.typ` swaps per palette and per ground.

## References and the principle taken from each

The v1 references stand, with their round-1 wording. Eki stamps (https://www.japanhousela.com/articles/station-to-station-japans-iconic-eki-stamps-train-stamp-book-passport-goshuin-goshuincho/, https://en.wikipedia.org/wiki/Eki_stamp): a stamp per station showing the local landmark. The date order and the round rim form are my design choice and common practice. East Asian seals (https://en.wikipedia.org/wiki/Seal_(East_Asia)): cinnabar seal ink, used like a signature. *Prunus serrulata* (https://en.wikipedia.org/wiki/Prunus_serrulata): five petals, clusters of two to five on short spurs, chestnut-brown bark with horizontal lenticels; v2 now draws the spurs and lenticels. *Persicaria tinctoria* (https://en.wikipedia.org/wiki/Persicaria_tinctoria): Japanese indigo, for the indigo variant; the exact values are my choices. Letterform Archive, *Hotel Retro* (https://letterformarchive.org/news/hotel-retro/): the label as a memento with bold lettering for the place; loudest destination codes is my own reading. Marine Flagship v11, Golden Blue: the skeleton, and pale technical drawings in empty areas as the model for the background layer. The new pieces (seigaiha, Shinkansen, chōchin lanterns, sensu fan, five-storey pagoda) are generic Japanese forms drawn from general knowledge, not traced from any image.

## Fonts (all already in the repo; nothing downloaded)

Source Sans 3 (body) and Barlow Condensed SemiBold (figures, IATA codes) from `packages/cv-framework/fonts/`. Sofia Sans Extra Condensed (`69b42c88…fc45`), M PLUS 1p Regular/Bold (`2f294ad4…1ed1`, `76eb077b…afc1`) and Kaisei Tokumin ExtraBold (`bf44bb3e…bc53`) from `packages/cv-framework/fonts/` too (moved there on 2026-10-02 so `scripts/cv.py` finds them). All are OFL 1.1, with sources as in v1's brief. The embedded fonts in both PDFs were checked: no fallback, and Typst printed no warnings.

## Data

`sample.json` and `portrait.jpg` are byte-identical to v1 and Stamp Rally. All totals are computed and asserted: 5 trips and 103 days; 6 groups, 162 participant places (summed per departure) and 39 escort days. Only the April 2026 Japan group is co-led, and no local-guide licence is claimed.

## What it would take to become a `Template`

The v1 list (hero band with a portrait frame slot, route plate, eki stamp, stamp row, manifest with strip, nature frame), plus:
- a palette as a `Theme` (the token table above);
- a `profile-cells` component (lead line, offer, 3–4 cells with an icon key);
- a `petal-layer` that reads the page plan's keep-outs from the layout rather than a hand-copied list;
- a background-pieces slot in the artwork pack.

## Weakest remaining

- The petal keep-outs are copied by hand from the page plan. Moving a block without regenerating the petals could put petals near text; the collision check catches it.
- A light band stands out less in a batch than the indigo one. The soft version passes through its contrast, artwork and red seal, but the indigo variant is still the louder of the two.
- Page 2's band is calmer than page 1's.
- The PDFs are about 620 KB each (under 1 MB). The 23 distant petals are blurred, and the PDF writer rasterizes each blur locally; everything else is vector apart from the portrait.
- The light-blue band, like the pink, stands out less in a batch than indigo. Navy type, the gold ring and the red seal carry it.
- The background pieces are simple shapes on purpose; at 7 % they give depth but are not meant to be read.
