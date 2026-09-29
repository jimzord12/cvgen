# Woodblock Road

**Idea in one line:** the CV opens as a Japanese travel print, a woodblock landscape in which a modern tour group crosses a bridge behind its leader's flag, and the career below is told as a numbered series of small views.
Three words: *woodblock travel print*.

Idea run 2026-09-29 (magazine-editor). `Domain` Travel & Tourism; specialty Japan; role Αρχηγός-Συνοδός Εκδρομών (tour leader / escort, never "guide"). Status: proposed.

## What the owner should notice first

The print. Flat Prussian-blue and vermilion colour, a bokashi sky, Fuji, kasumi mist bands, a shinkansen on a viaduct, a plane arriving from the west, and on the bridge eight travellers with suitcases and backpacks behind one figure raising a vermilion pennant. Then the name in a heavy calligraphic serif with a red 旅 seal, as an artist seals a print.

## The three `Design Tier`s

- **Safe** (`safe.pdf`): the print is a mounted strip across the top; below it is a conventional two-column CV, with each Japan trip marked by its season kanji (春 夏 秋 冬) and a rectangular framed portrait.
- **Stylish** (`stylish.pdf`): a full-bleed print over the top 37% of the page, the portrait in a round inset (koma-e) and a title cartouche (日本の旅 plus the name in katakana). The five Japan trips appear as five miniature prints numbered 一 to 五, followed by two mist bands (know-how in Japan, duties on the road) and three columns.
- **Creative** (`creative.pdf`): the whole page is one tall pillar print. The name runs down a vertical title cartouche in stacked Greek capitals, the portrait sits in a folding fan, and the CV is written into kasumi mist bands over the lake. Fourteen travellers cross the bridge along the foot of the page behind the leader's flag.

## `Three-Second Test`

- **Travel:** the plane and its dotted flight path, the shinkansen, suitcases and backpacks on the travellers, the travel-print genre itself.
- **Japan:** Fuji, the rising sun, seigaiha waves, a pine, kasumi bands, the cartouche, kanji (日本の旅, 旅, place names), the name in katakana.
- **Escort:** the group in single file behind one figure with a raised vermilion pennant, the only flag on the page. In Creative it runs full width at the foot.

## References and the principle taken from each

1. Hiroshige, *Fifty-three Stations of the Tōkaidō* (The Met: https://www.metmuseum.org/art/collection/search/57652; Dallas Museum of Art: https://dma.org/art/exhibitions/fifty-three-stations-tokaido). **Principle:** a journey told as a numbered series of views, with small travellers giving scale and story, and a title cartouche in the corner. Taken for the five numbered views and the procession. Nothing is traced; the landscape is drawn from scratch.
2. Kasumi mist bands in yamato-e and emaki (https://en.wikipedia.org/wiki/Kasumi). **Principle:** horizontal cloud bands separate scenes and hold time. Here they carry the text (Stylish bands, Creative's whole CV).
3. 1930s Japanese tourism posters (Museum für Gestaltung poster collection: https://museum-gestaltung.ch/en/poster; survey: https://gizmodo.com/13-gorgeous-travel-posters-from-1930s-japan-1533432495). **Principle:** a flat-colour destination poster where the picture sells the place before any word. Taken for the scale of the header print.
4. Koma-e and fan-shaped insets on ukiyo-e sheets (general practice). **Principle:** an inset picture inside the main picture. Used for the round and fan-shaped portrait frames.
5. Alegreya's specimen and Fonts In Use (https://fontsinuse.com/typefaces/32485/alegreya-sans, family context). **Principle:** a calligraphic book face with a heavy Black weight, strong enough to carry a poster name in Greek.

## How it differs

- **From Flagship:** Flagship is a dark hero band with tools framing a round portrait over a technical grid. Here the header is a painted scene rather than a band, and the page has a narrative (a journey, a group) instead of an inventory.
- **From the other two styles:** it is pictorial and printmaking-based (serif, Prussian blue, vermilion, washi paper). Stamp Rally is ephemera and ink (condensed sans, mono, stamps on cream or burgundy). Concourse is hard signage (Fira, charcoal, yellow, LED).
- **From the market:** no skill bars, icons or sidebar. The domain imagery is drawn as original vector art, not clip-art.

## Fonts (OFL 1.1, shipped unmodified with their licence in `design-concepts/fonts/`)

| Family | File | Source | SHA-256 |
|---|---|---|---|
| Alegreya (Greek covered) | `alegreya/Alegreya[wght].ttf` | https://raw.githubusercontent.com/google/fonts/main/ofl/alegreya/Alegreya%5Bwght%5D.ttf | `ba5564634b93a8f8ba57b48cd4f1ae7417d2b4656fbac779028679b00de3cf12` |
| Kaisei Tokumin (Japanese, used only for kanji and kana) | `kaisei-tokumin/KaiseiTokumin-ExtraBold.ttf` | https://raw.githubusercontent.com/google/fonts/main/ofl/kaiseitokumin/KaiseiTokumin-ExtraBold.ttf | `bf44bb3e23cc703bfb19111833f78e651998d0a2b1863eff9e88cecb38a8bc53` |

Licences: `alegreya/OFL.txt`, `kaisei-tokumin/OFL.txt`. The Kaisei file is 4.5 MB, but Typst embeds only the subset used, so PDFs stay between 100 and 135 KB. All Greek text is set in Alegreya; Kaisei lacks accented Greek and is never used for it.

## Data

The fictional `sample.json` in this folder (identical in all three style folders), invented for the run: name (Greek, Latin, katakana), title, contact, profile, two jobs, six escorted groups (date, place, pax, days, role), five Japan trips (dates, days, season, kind `travel`/`study`/`colead`, places, kanji), know-how, operations, languages, education, a first-aid certificate, availability and an offer. The totals (5 trips, 103 days, 6 groups, 162 travellers, 39 days) are computed from the records, never from calendar arithmetic. `portrait.jpg` is a 627 px copy of `examples/candidates/fictional-engineer.png`, made to keep the PDFs small.

## What it would take to become a `Template`

A travel `Domain` with a facts schema for trips (season, kind, places) and groups (pax, days, role). A `Theme` with the palette and fonts. An artwork pack of parametrised SVG slots: header print (Safe strip, Stylish full-bleed, Creative page), season tiles, fan and round portrait frames, cartouche. The procession is generated from data, so the number of walkers could echo group size. The three layouts are fixed page plans, and the Stylish five-views row needs a rule for more than five trips (six or seven narrower tiles, or the most recent five).

## Open weaknesses

- The sun beside Fuji is the most familiar Japan image. It is drawn with care but it is a cliché, and the owner may prefer a sunless sky or the sun behind the cartouche.
- Creative's stacked Greek capitals read vertically, which is slower than a horizontal name. The name is repeated horizontally in the first mist band for findability.
- On a black-and-white photocopy the blue print turns into a mid-grey mass. The text sits on paper or paper-coloured bands, so it survives; the picture loses its colour story.
- The Safe tier leaves a little empty space near the foot.
