# Stamp Rally

**Idea in one line:** the CV is built from the escort's own travel papers. A boarding pass carries the identity, a stamp-rally card holds one eki-style stamp per Japan trip, a passenger manifest lists the groups, and a luggage or bag tag carries the duties on the road.
Three words: *tickets, tags, stamps*.

Idea run 2026-09-29 (magazine-editor). `Domain` Travel & Tourism; specialty Japan; role Αρχηγός-Συνοδός Εκδρομών. Status: proposed.

## What the owner should notice first

The five round stamps. Each is in its own ink (crimson, violet, green), rotated, with worn edges and the place names running around the rim. Each has a line drawing (torii, open book, maple over the Alps, snowflake over Hokkaido, the leader's flag with the group) and the place in kanji. Then the name as the PASSENGER on a boarding pass, with the stub reading ΑΡΧΗΓΟΣ and the route ATH → TYO.

## The three `Design Tier`s

- **Safe** (`safe.pdf`): a calm boarding pass as the header (one Fuji stamp overprinted), a conventional two-column CV, small stamps as the row markers of the Japan trips, and the groups as a mono manifest.
- **Stylish** (`stylish.pdf`): a full boarding pass with overprinted stamps (a Japan stamp and a green first-aid "ΕΓΚΥΡΟ" entry stamp), the stamp-rally card across the page, the manifest and the experience, and a long airline-style bag tag (TYO) across the foot for the duties and availability.
- **Creative** (`creative.pdf`): a flat-lay on passport-burgundy. The name is on a giant luggage tag, the photo on a pass stub, the Japan trips on the stamp-rally card, the job on a boarding pass, the groups and know-how on a thermal receipt, and the credentials on a rail ticket (乗車券). Loose stamps lie over everything.

## `Three-Second Test`

- **Travel:** the boarding pass, luggage tag, bag tag, rail ticket, receipt, barcodes and perforations.
- **Japan:** eki-style stamps (a Japanese station tradition) with torii, Fuji and kanji place names, plus スタンプラリー, 日本 and TYO.
- **Escort:** ΑΡΧΗΓΟΣ on the stub, ΑΡΧΗΓΟΣ ΟΜΑΔΑΣ on the tag, the flag-and-group stamp for the co-led trip, a passenger manifest with pax counts, and "ΣΤΗ ΣΥΝΟΔΕΙΑ" (the escort's duties).

## References and the principle taken from each

1. Eki stamps (Japan House Los Angeles: https://www.japanhousela.com/articles/station-to-station-japans-iconic-eki-stamps-train-stamp-book-passport-goshuin-goshuincho/; Hyperallergic: https://hyperallergic.com/the-design-nostalgia-of-japans-train-station-stamps/; https://en.wikipedia.org/wiki/Eki_stamp). **Principle:** a single-ink circular stamp with the place name around the rim and a landmark in the centre, collected one per stop. All stamp art is drawn anew; no real station stamp is copied.
2. Hotel luggage labels, Letterform Archive's *Hotel Retro* (https://letterformarchive.org/news/hotel-retro/). **Principle:** labels as badges of travel, layered and overlapping on a trunk. Taken for the Creative flat-lay and the luggage tag.
3. Boarding-pass redesign studies (Core77 on Peter Smart's redesign: https://www.core77.com/posts/26366/peter-smarts-better-boarding-pass-redesign-26366). **Principle:** the pass as an information hierarchy, with the traveller and the route loudest and every field labelled. Taken for the header: name as PASSENGER, ΘΕΣΗ / ROLE, ΕΞΕΙΔΙΚΕΥΣΗ / SPECIALTY. No airline's pass is imitated, and the codes are generic IATA city codes.
4. Security printing: guilloche tints on tickets and passports (general practice). **Principle:** a fine wave tint that makes paper feel official. Used on the pass, the rail ticket and the burgundy cover.
5. Sofia Sans in use (https://fontsinuse.com/typefaces/241644/sofia-sans). **Principle:** an extra-condensed Greek-capable grotesque that can shout a name at 50 pt in a narrow field, as ticket printing does.

## How it differs

- **From Flagship:** Flagship draws the trade's tools around a portrait. Here the page is the trade's paperwork, so the CV is literally the documents a tour escort carries.
- **From the other two styles:** it is ephemera, ink and paper (condensed sans with mono and M PLUS 1p; crimson, violet, green on cream; burgundy in Creative). Woodblock Road is a painted print. Concourse is architecture-scale signage.
- **From the market:** stamps and tickets are the domain's material, drawn as vector with worn ink. Nothing is a rating, bar or icon row.

## Fonts (OFL 1.1, shipped unmodified with their licence in `design-concepts/fonts/`)

| Family | File | Source | SHA-256 |
|---|---|---|---|
| Sofia Sans Extra Condensed (registers as "Sofia Sans"; Greek covered) | `sofia-sans-extra-condensed/SofiaSansExtraCondensed[wght].ttf` | https://raw.githubusercontent.com/google/fonts/main/ofl/sofiasansextracondensed/SofiaSansExtraCondensed%5Bwght%5D.ttf | `69b42c883ad334def49b044fffa5391358f6b1a668259f18fdcdc0bfe854fc45` |
| M PLUS 1p (body Greek and kanji/kana) | `m-plus-1p/MPLUS1p-Regular.ttf` | https://raw.githubusercontent.com/google/fonts/main/ofl/mplus1p/MPLUS1p-Regular.ttf | `2f294ad496432b1608f070d310e3aa2adcf1de4af429f4901df97ec4bd361ed1` |
| M PLUS 1p | `m-plus-1p/MPLUS1p-Bold.ttf` | https://raw.githubusercontent.com/google/fonts/main/ofl/mplus1p/MPLUS1p-Bold.ttf | `76eb077b0a31ca33ca40238e47da5a17e2786741607cec09678d7d2e5ab1afc1` |

Also DejaVu Sans Mono (embedded in Typst, no download) for the ticket fields and the receipt. Licences: `sofia-sans-extra-condensed/OFL.txt`, `m-plus-1p/OFL.txt`. M PLUS 1p is shared with Concourse. The PDFs are 200 to 250 KB.

## Data

The same fictional `sample.json` as the other two styles. Totals (5 trips, 103 days, 6 groups, 162 pax, 39 days) are computed from the records. The stamps' rim text is built from each trip's places and year, and the kanji from its `kanji` field. `portrait.jpg` is a small copy of the fictional portrait.

## What it would take to become a `Template`

A travel `Domain` schema as in the other styles. Components: `boarding-pass` (fields from identity and contact), `stamp` (size, ink, rim text, art key, label, rotation, seed), `stamp-card` (one stamp per trip), `manifest` (groups table), `bag-tag`, and an entry-stamp for certificates with an expiry date. An artwork pack of stamp drawings keyed by season or kind (torii, study, maple, snow, flag, fuji, train, onsen). Rotations and ink order would be seeded per candidate, so every CV gets a unique but reproducible stamp layout. More than five trips needs a second card row or smaller stamps.

## Open weaknesses

- The stamp rim text is tiny at the Safe tier's 16 mm stamp size. It works as texture; the facts are repeated in the row beside each stamp.
- Worn-ink speckle is deliberately imperfect, and on the green entry stamp it nibbles a letter. The owner may prefer a cleaner ink.
- Creative's items are tilted up to 7°, so the receipt columns look slightly stepped. That reads as real paper but is a little harder to scan.
- ATH → TYO is symbolic (groups fly via hubs, per the research note); it states the destination, not an itinerary.
