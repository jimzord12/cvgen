# Hanami Line

**Idea in one line:** the Marine Flagship's professional skeleton (dark hero band, ringed portrait, name plate, numbered sections on a calm field) carrying Stamp Rally's travel identity (ATH → TYO, one eki stamp per Japan trip, the escort's flag and group, the passenger manifest), with a real cherry branch drawn into each page.
Three words: *travel, Japan, blossom*.

One-design run 2026-10-02 (magazine-editor), answering the owner's recalibration brief: professional, clean, well organised and premium, with controlled creativity. Slightly more creative than Flagship, more professional than Stamp Rally. `Domain` Travel & Tourism; specialty Japan; role Αρχηγός-Συνοδός Εκδρομών. One `Density` and `Design Tier` only: **Spacious, Stylish, two A4 pages** (`spacious/stylish/spacious-stylish.pdf`). Status: proposed.

## What the owner should notice first

The portrait seen through a brass torii, the way Flagship frames the engineer with his tools, with one cinnabar 日本 seal struck on the ring (5 trips, 103 days). The tour group with roller cases walks along the horizon towards the gate behind the leader's cinnabar flag, and Fuji stands on the right. The route runs through the name plate: **ATH** ······ [ ΜΑΡΚΟΣ ΗΛΙΑΔΗΣ ] ······ ✈ **TYO**, with an ΑΡΧΗΓΟΣ 添乗員 tab on the plate. Below, five upright cinnabar eki stamps sit in a row on a dotted line, one per Japan trip. A pale cherry branch reaches in from the right edge on both pages, never behind text.

## Page plan (explicit; overflow fails loudly, nothing shrinks)

- **Page 1.** Hero band (86 mm, indigo): contacts in brass spaced caps on both sides, the torii and portrait, the seal, the group and Fuji on a horizon line, a cherry canopy along the top edge, the ATH/TYO route and the name plate across the band's lower edge. On washi paper: the profile, and the free briefing offer as a quiet cinnabar-ruled note. **01 Η Ιαπωνία, ταξίδι προς ταξίδι**: five 25 mm stamps with date, days in cinnabar, kind, places and kanji places. **02 Επαγγελματική εμπειρία**: Flagship's date column and indigo rule, both jobs with every bullet.
- **Page 2.** A shorter band (46 mm) with the name, the title, the contacts, a small solid escort seal (ΑΡΧΗΓΟΣ · 6 ΟΜΑΔΕΣ · 162 ΘΕΣΕΙΣ, flag and group, 添乗員) beside the name like a hanko beside a signature, and the group, torii and Fuji drawn at full size. **03 Ομάδες που συνόδευσε**: the manifest as a Flagship table, with the Japan co-lead row in cinnabar, closed by Flagship's dark metrics strip (6 groups, 162 participant places, 39 escort days, 103 days in Japan) and an honesty note. **04 Σπουδές, γλώσσες, διαθεσιμότητα**: education and first aid (issuer, 12 hours, valid until 03/2028) with brass rules; languages in wash boxes (JLPT N4 12/2024, target N3 12/2026); availability. **05 Στην Ιαπωνία · Στη συνοδεία**: know-how and duties.
- Every text block sits in a `slot` that asserts its height: an overflow stops the compile with the slot's name ("change the page plan by hand").

## `Three-Second Test` (each page alone)

- **Travel:** ATH → TYO with the plane (both pages), the stamp row, the manifest and its pax strip, the group's roller cases.
- **Japan:** the torii, Fuji, the cinnabar 日本 seal, kanji on every stamp, the cherry branch, indigo and cinnabar.
- **Escort:** the leader's flag with the group (both pages, and the 2026 stamp), the ΑΡΧΗΓΟΣ 添乗員 tab, the escort seal, the manifest.
- **`Batch Test`:** at thumbnail the page reads as a dark band with a ringed portrait and a red seal over a row of red stamps. Checked on a contact sheet beside Flagship v11, Stamp Rally Spacious Stylish and Japan Passage (`builds/hanami-scratch/contact.png`); it also survives greyscale photocopying.

## Retain / Simplify / Remove

Read from the Spacious PDFs of all three 2026-09-29 styles across their tiers, and from Flagship with its Golden Blue `Theme`.

| Source | Retain | Simplify | Remove |
|---|---|---|---|
| **Stamp Rally** (closest; most attention) | The escort's travel papers as the identity: ATH → TYO set big, ΑΡΧΗΓΟΣ as a coloured tab, the round eki stamp with rim text, landmark and kanji, one per Japan trip, with the same five subjects (torii, book, maple over the Alps, snow, flag and group), the passenger manifest with pax and days, 日本 beside the specialty | Three stamp inks become **one cinnabar**; rotated, worn stamps become upright and clean; the 38 pt route keeps its scale but moves onto the band; the stamp-rally card becomes a numbered section; the passport page of entry stamps becomes a plain education list | Barcodes, guilloche tints, perforations, rotated paper, the bag-tag header, the baggage-claim stub, mono "ticket" type, violet and green inks, the offer as a slanted stamp |
| **Woodblock Road** | The leader with a flag walking ahead of the group as the escort motif; Fuji; an indigo-and-vermilion palette idea | The full-bleed painted landscape becomes fine brass line art on the band | The painted hero, the vertical tanzaku labels, the five painted view tiles, the kasumi mist bands |
| **Concourse** | Clear hierarchy and big numerals (the metrics strip echoes its departure board), three scripts used with restraint | Station wayfinding becomes section numbering | LED board, yellow signage, pictogram tiles, tactile paving |
| **Flagship, Golden Blue** | The 80 %: dark hero band, ringed portrait framed by trade artwork, light name plate, brass spaced-cap contact labels on both sides, 16 mm margins, brass numbered section headings in a condensed face, the date column with a vertical rule, the dark metrics strip, the dark-headed zebra table, Source Sans 3 body at 10.5 pt, a quiet footer | Navy-teal becomes a bluer **kon/ai indigo** (`#1e2852`); teal accents become cinnabar | Faint outline tools in the margins (here a real cherry branch takes that role, in colour and placed in a frame) |

## Palette and type

Three inks on paper: indigo `#1e2852`, cinnabar `#c23a2b` (stamps, route plane, role tab, day counts, the Japan manifest row; a lighter tint on the dark band for contrast), brass `#c4a265` (hairlines, section numbers, labels, line art), and washi paper `#f8f4ea`. Sakura pink appears only in the nature artwork, faded into its ground: on paper the bark at 20 % and the blossoms at 50 % of a pale pink, which comes to roughly a 10 to 14 % tone difference; on the band 28 % and 52 %.

| Use | Family | File (already in the repo, nothing downloaded) | Source | SHA-256 | Licence |
|---|---|---|---|---|---|
| Body, labels, tables (Greek) | Source Sans 3 | `packages/cv-framework/fonts/SourceSans3[wght].ttf` | Framework font | (Framework) | OFL 1.1, `packages/cv-framework/licenses/` |
| Figures, IATA codes, section numbers | Barlow Condensed SemiBold (Latin and figures only; never Greek) | `packages/cv-framework/fonts/BarlowCondensed-SemiBold.ttf` | Framework font | (Framework) | OFL 1.1 |
| Name in Greek capitals | Sofia Sans Extra Condensed (registers as "Sofia Sans") | `design-concepts/fonts/sofia-sans-extra-condensed/SofiaSansExtraCondensed[wght].ttf` | https://raw.githubusercontent.com/google/fonts/main/ofl/sofiasansextracondensed/SofiaSansExtraCondensed%5Bwght%5D.ttf | `69b42c883ad334def49b044fffa5391358f6b1a668259f18fdcdc0bfe854fc45` | OFL 1.1, `OFL.txt` beside it |
| Kanji and kana, stamp rim fallback | M PLUS 1p Regular, Bold | `design-concepts/fonts/m-plus-1p/MPLUS1p-Regular.ttf`, `MPLUS1p-Bold.ttf` | https://raw.githubusercontent.com/google/fonts/main/ofl/mplus1p/MPLUS1p-Regular.ttf, …/MPLUS1p-Bold.ttf | `2f294ad496432b1608f070d310e3aa2adcf1de4af429f4901df97ec4bd361ed1`, `76eb077b0a31ca33ca40238e47da5a17e2786741607cec09678d7d2e5ab1afc1` | OFL 1.1 |
| 日本 on the hero seal | Kaisei Tokumin ExtraBold (never Greek) | `design-concepts/fonts/kaisei-tokumin/KaiseiTokumin-ExtraBold.ttf` | https://raw.githubusercontent.com/google/fonts/main/ofl/kaiseitokumin/KaiseiTokumin-ExtraBold.ttf | `bf44bb3e23cc703bfb19111833f78e651998d0a2b1863eff9e88cecb38a8bc53` | OFL 1.1 |

The embedded fonts were checked in the PDF: only these faces, no fallback, and no Typst warnings. The PDF is about 200 KB.

## References and the principle taken from each

1. **Eki stamps**: Japan House Los Angeles, https://www.japanhousela.com/articles/station-to-station-japans-iconic-eki-stamps-train-stamp-book-passport-goshuin-goshuincho/ and https://en.wikipedia.org/wiki/Eki_stamp. **Principle:** one stamp per place, showing the local landmark, collected in order in one book. Taken as one stamp per Japan trip, landmark drawn in the centre, places on the rim, collected along a dotted line. All six stamp drawings are new; no real station stamp is copied.
2. **East Asian seals (hanko)**: https://en.wikipedia.org/wiki/Seal_(East_Asia). **Principle:** a red cinnabar seal works like a signature beside a name. Taken for the single solid 日本 seal on the portrait ring, the escort seal beside the name on page 2, and the rule of one cinnabar ink.
3. **Cherry botany**: *Prunus serrulata*, https://en.wikipedia.org/wiki/Prunus_serrulata. **Principle:** five petals, flowers in clusters of two to five at the nodes on short spurs, dark bark. The procedural branches follow this: zigzag growth with knuckles at the nodes, tapering bark, notched five-petal blossoms clustered at the nodes on short stalks, buds at the twig tips, and drifting single petals.
4. **Japanese indigo**: *Persicaria tinctoria* ("Japanese indigo"), https://en.wikipedia.org/wiki/Persicaria_tinctoria. **Principle:** indigo (ai) is the historic blue of East Asian dyeing. Taken for the hero band: a bluer kon indigo instead of Flagship's navy-teal, so the page is not a recolour of Flagship.
5. **Travel graphics**: Letterform Archive, *Hotel Retro*, https://letterformarchive.org/news/hotel-retro/. **Principle:** the destination code and the badge of travel are the loudest things on a label. Taken for ATH and TYO at 30 pt and the route running through the name. The labels themselves are not used: no layered ephemera.
6. **Marine Flagship v11, Golden Blue** (`examples/marine/flagship/engineer.pdf`, `packages/domains/marine/templates/flagship/`): **principle**, the trade's own artwork frames the portrait in a dark band, and below it a disciplined, numbered and quiet record. The torii plays the role of the engineer's tools.

## Data

`sample.json` and `portrait.jpg` are byte-identical copies from `2026-09-29-stamp-rally/` (SHA-256 `ae4f7537…3b4746` and `4cde1730…19f20e`). Every total is computed from the arrays and asserted in the source: 5 Japan stays and 103 days (`japan_trips`); 6 groups, 162 participant places and 39 escort days (`groups`). The page says the places are summed per departure and are not unique people. Only the April 2026 Japan group is co-led; the five Europe groups are led. No local-guide licence is claimed. The stamp rims use each trip's first three places and the year; all places appear in full beneath the stamps. ATH → TYO is symbolic (groups fly via hubs).

## Artwork (all original)

`assets/make_assets.py` writes every SVG: three cherry branches (`sakura-canopy.svg`, `sakura-field.svg`, `sakura-field-2.svg`) and margin petals (`petals-drift.svg`); `torii.svg`, `group.svg` (five travellers with roller cases or a backpack, and the leader raising a flag), `fuji.svg`, `plane.svg`; and six 40 × 40 stamp drawings (`stamp-torii`, `-book`, `-maple`, `-snow`, `-flag`, `-fuji`). Each branch is generated into the exact frame it occupies on the page. Only the page-edge sides of the frame may clip it: a seed whose wood crosses an inner edge is rejected, and a blossom that an inner edge would cut is left out. The seeds were then picked by eye from contact sheets. The Typst file recolours the SVGs by string replacement (cinnabar on paper, ivory on the solid seals, pale on indigo).

## Why it differs

- **From Flagship:** a different `Domain` vocabulary (torii, seal, stamps, route, group), an indigo-and-cinnabar palette instead of navy, teal and brass, a name plate that the route passes through, and colour nature artwork instead of faint outline tools.
- **From Stamp Rally:** the same identity, now set in a CV's grid. One ink, upright stamps, no ticket furniture, no rotated or layered paper.
- **From Japan Passage** (the rejected over-correction): a real portrait in a real frame, a seal, stamps you can see from a metre away, a hero drawing at full size, a cherry tree you can see, and indigo rather than a Flagship-clone navy and gold.
- **From the market:** no skill bars, rating dots or icon rows; the imagery is the domain's own and drawn for this page.

## What it would take to become a `Template`

A travel `Domain` schema (trips, groups, know-how, operations, availability, offer) as in the earlier runs. Components on the Framework: `hero-band` with a portrait-frame slot (torii here, like Flagship's tools), `route-plate` (name plate with IATA codes and a role tab), `eki-stamp` (size, ink, rim, art key, kanji, solid or line), `stamp-row` (one per trip, 5 at most per row), `manifest` with the metrics strip, and `nature-frame` (a frame anchored to a page edge with an artwork key). The cherry branches would become an artwork pack keyed by season (sakura, momiji, snow pine) with frames declared in the layout. More than five trips needs a second stamp row or a 20 mm size, and a page-plan rule for one to three pages.

## Open weaknesses

- Page 2's band is calmer than page 1's (no portrait); it relies on the escort seal, the panorama, the route and the branch below it. It passes on its own, but less loudly.
- The hero canopy on page 1 is small and faint in the top-right corner, deliberately clear of the contacts; the owner may want more blossom in the band.
- Stamp rim text is about 5.6 pt (texture more than text); every fact on a rim is repeated in full beneath its stamp. The 添乗員 on the page-2 seal is 4.6 pt.
- On the dark band the cinnabar is lightened for contrast (the plane, the flag, "· Ιαπωνία" on page 2): a tint of the one ink, not a fourth colour, but close to one.
- Only the Spacious Stylish design exists (one-design run); there is no Condensed or other tier.
