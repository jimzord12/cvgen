# Stoichedon — a `Text Draft` direction

**Idea: every letter in its own cell.** Athenian state inscriptions were cut
*stoichedon*, "in rows": each capital in its own square, aligned across and
down, like a grid you can read in both directions. The whole draft sits on
one such grid (24 × 36 cells of 7.5 mm, marked by faint crosses). Display
lines put one letter per cell; running text keeps to the rows. Facts the
`Client` must check are rubricated in red ochre. Three words: **every letter placed**.

Files: `concept.pdf` (two pages), `page-1.png` (the `Check Page`, Greek),
`page-2.png` (the first CV-content page, English), `concept.typ`.
Fictional record: `examples/candidates/chief-officer-example.json`; the
`Check Page` uses the Greek form of the name, ΕΛΕΝΗ ΜΑΡΚΟΥ (invented,
consistent with the record's ELENI MARKOU of Piraeus).

## What to notice first

1. The client's name cut monumentally, one letter per 30 mm cell, filling the
   measure exactly (ΕΛΕΝΗ / ΜΑΡΚΟΥ; ELENI / MARKOU on page 2, in red because
   it is a fact).
2. The instruction as an inscription: ΕΛΕΓΞΤΕ ΜΟΝΟ / ΤΑ ΚΟΚΚΙΝΑ ("check only
   the red"), then four real samples in red, then ΟΛΑ ΣΩΣΤΑ; / ΑΠΑΝΤΗΣΤΕ OK.
   The page is legible at arm's length and on a phone.
3. Greek capitals without accents, as Greek typography requires (Ελέγξτε →
   ΕΛΕΓΞΤΕ, Όλα σωστά → ΟΛΑ ΣΩΣΤΑ), done by a `caps-el` function that also
   keeps a dialytika where a vowel pair splits (Μάιος → ΜΑΪΟΣ).

Signature: the visible letter-cell grid with a faint point in every word
space. Recognisable without the name on it, and rooted in the client's own
alphabet.

## References and the principle taken from each

| Source | Principle taken |
|---|---|
| Stoichedon: <https://en.wikipedia.org/wiki/Stoichedon> (letters "aligned vertically as well as horizontally"; "the preferred style for official state proclamations" in 5th–4th-century Athens); Production Type, "From Stoichedon to programming": <https://productiontype.com/article/from-stoichedon-to-programming-a-concise-history-of-monospaced-typefaces>; CSAD Oxford: <http://archive.csad.ox.ac.uk/CSAD/Stoichoi.html> | One square cell per letter, identical cells across the whole surface; the cell size is the only scale decision. I keep word spaces (as a faint point, like an interpunct) because a client must read it at a glance; the ancient practice ran words together. |
| Wim Crouwel, *Vormgevers* poster, 1968, Rijksmuseum: <https://www.rijksmuseum.nl/en/collection/object/Vormgevers--e6df93cffd693e5940fe55d8b2680b26> (lettering "based on a grid" used for the Stedelijk's house style, with the grid shown) | Make the grid visible and let it be the decoration: the page shows how it was built. Here: crosses at every cell corner, nothing else. |
| Rubrication: <https://en.wikipedia.org/wiki/Rubrication> (in service books the red text told the reader what to *do*, the black text was what to read); etymology from <https://en.wikipedia.org/wiki/Rubric> ("rubrica, meaning red ochre or red chalk") | Red means "act on this". The facts to check are the draft's rubrics; the wording stays black. The ochre red also nods to painted letters on stone. |
| GFS Neohellenic (Greek Font Society, after the 1927 New Hellenic): <https://raw.githubusercontent.com/google/fonts/main/ofl/gfsneohellenic/DESCRIPTION.en_us.html>, <https://raw.githubusercontent.com/google/fonts/main/ofl/gfsneohellenic/METADATA.pb>. The description traces New Hellenic to "a round, and almost monoline type which had first appeared in 1492 in the edition of Macrobius" (Venice), and says GFS digitised it for the Athens Archaeological Society "with the addition of a new set of epigraphical symbols" | A 1492 Venetian book Greek, digitised with epigraphical symbols: round, almost monoline capitals that sit well in square cells, and a strong native Greek. The unusual wavy Ξ and the Latin companion come with it. |

No drawing, photo or copy was taken from any of them.

## Why it differs

- **From the rejected draft:** no navy, no Didone, no dossier furniture. Stone
  paper, black and one earth red, a Greek-born letter and a grid; its
  reference is Greek public lettering, not a law office.
- **From Flagship:** no masthead, portrait or condensed display; the grid is
  the only structure.
- **From the market:** no template sells a draft built on a letter grid; the
  nearest "grid" CVs are twelve-column web layouts with boxes.

## Fonts and licences

One family, OFL 1.1, Greek Font Society, from the Google Fonts repository,
unmodified, in `design-concepts/fonts/gfs-neohellenic/` with `OFL.txt`.

| File | Source | SHA-256 |
|---|---|---|
| `GFSNeohellenic.ttf` | <https://raw.githubusercontent.com/google/fonts/main/ofl/gfsneohellenic/GFSNeohellenic.ttf> | `14d54dd7f36fdd7140d3f6357c99a8ead988a808b298471e02ba2c0992aa110d` |
| `GFSNeohellenicBold.ttf` | <https://raw.githubusercontent.com/google/fonts/main/ofl/gfsneohellenic/GFSNeohellenicBold.ttf> | `b1a3900f5f3327ab79d18c762fca17e46c0db37a32fbf34f7dca41458bd46f53` |
| `GFSNeohellenicItalic.ttf` | <https://raw.githubusercontent.com/google/fonts/main/ofl/gfsneohellenic/GFSNeohellenicItalic.ttf> | `39214ba27aec72823881bdc967b6b8929079609749db1911eda0f7072e461688` |
| `GFSNeohellenicBoldItalic.ttf` | <https://raw.githubusercontent.com/google/fonts/main/ofl/gfsneohellenic/GFSNeohellenicBoldItalic.ttf> | `b486c325aadd1c7dc4f5a87c41ae9c8823ea7285de9d7ad8f8fa6e836d41cad1` |
| `OFL.txt` | <https://raw.githubusercontent.com/google/fonts/main/ofl/gfsneohellenic/OFL.txt> | `bfc205682f5454b42a732ec857b665293ab8bc6f0ee901a0967219ba7ffdb190` |

The bold italic is unused in this mock-up; it is kept so the family is whole.

## Data it needs

- CV content: `identity.rank`, `contacts.left/right`, `profile`,
  `companies[].name/period/groups[].type/ships[].name/rank/months`. "129
  months" is the sum of the record's vessel `months`, never calendar
  arithmetic.
- Per-client words: given and family name in Greek and in the CV's language,
  draft number, date, page count, the four samples, the check wording.
- **Missing:** a fact mark for running text (only "six" in the profile is
  marked, by a one-off rule); proposed glossary term below.

## What it would take to become the house `Text Draft`

A replacement for `scripts/text-draft.typ` (about 130 lines): `stoi` (letters
into cells), `lines` (text on the row baselines), `caps-el`, the grid marks,
and a rule for the name: pick the largest cell (30, 22.5, 15 or 7.5 mm) at
which the longest name word fits the 24-cell measure. Content pages need an
automatic row flow (today rows are counted by hand) and page breaking on the
row grid, which is the real work: roughly a day.

## Known weaknesses

- Rows are placed by hand in the mock-up; the house version needs a row
  allocator and must break pages on whole rows.
- Page 2 fits only two companies at a readable row height; this draft would
  run to four pages for this record.
- Long Greek names (e.g. ΠΑΝΑΓΙΩΤΟΠΟΥΛΟΣ, 15 letters) drop to the 15 mm cell
  and lose some drama.
- In the experience table almost everything is a fact, so most of it is red.
- The wavy Ξ in GFS Neohellenic surprises some Greek readers; it is the
  typeface's own historical form.
- Stoichedon is a scholarly reference; the owner may find it too quiet for
  "unafraid of excess". Its excess is scale and discipline, not colour.
