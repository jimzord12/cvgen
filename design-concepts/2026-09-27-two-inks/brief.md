# Two Inks — a `Text Draft` direction

**Idea: black is ours, orange is yours.** The draft looks printed in two inks
on two drums, like a small-press poster: black carries our wording; a hot
copper-orange, laid down first and a hair out of register, sits under every
fact the `Client` must check and prints the giant forms (the draft number,
the reply disc). The rule on the `Check Page` is one sentence: check only
the orange. Three words: **black over orange**.

Files: `concept.pdf` (two pages), `page-1.png` (the `Check Page`, Greek),
`page-2.png` (the first CV-content page, English), `concept.typ`.
Fictional record: `examples/candidates/chief-officer-example.json`; the
`Check Page` addresses the same person as Ελένη (invented Greek form of the
record's ELENI MARKOU of Piraeus).

## What to notice first

1. The giant orange "01" (the draft number) cropped by the sheet, with the
   black headline "Ελένη, ελέγξτε μόνο το πορτοκαλί." printing over it.
2. The reply as a poster: a huge black "OK" over an orange disc bleeding off
   the corner. The one thing the client must send is the biggest thing on the
   page.
3. On page 2 the name, rank and every fact print over orange slabs that sit
   0.7 mm right and 0.3 mm low of the black, the same on the whole page, as
   a real second drum would.

Signature: black type overprinting slightly misregistered orange slabs, plus
one giant orange numeral. Recognisable without the name on it.

## References and the principle taken from each

| Source | Principle taken |
|---|---|
| Corita Kent's process, Hammer Museum (Grunwald Center): <https://hammer.ucla.edu/collections/grunwald-center-collection/corita-kent/process> (a single letter "enlarged ... to overlay the entire image"; "detailed instructions to the printers", a fixed colour palette across works) | Blow one glyph up until it becomes the ground (the "01", the "OK"), and hold the palette fixed so the house is recognisable across every draft. |
| Risograph misregistration, Split Arrow Print House (print shop blog, practitioner source): <https://splitarrowprints.com/learn/risograph-printing-quirks-an-intro-into-risograph-imperfections-and-their-causes/> (one ink per pass; the machine "grab[s] the paper a little different each time"); <https://en.wikipedia.org/wiki/Risograph> | Two inks, each a layer; the small, consistent offset between them is the proof it was printed, not generated. Here the offset is a fixed design constant. |
| Syne, designed for the Synesthésie art centre by Bonjour Monde, Greek by George Triantafyllakos: <https://fontsinuse.com/typefaces/81101/syne> ("Extra (black and extended)"; five weights with Greek since 2022) | An art-centre voice with a conventional regular for reading and an outlandish extended black for shouting; the art-world tone the owner asked for, with a real Greek. |

No artwork, photo or copy was taken from any of them.

## Why it differs

- **From the rejected draft:** the opposite pole. No navy, no serif display,
  no dossier; a loud poster voice, uncoated paper, one hot ink.
- **From Flagship:** no portrait, masthead or copper-on-graphite restraint;
  it shouts and it is typographic only.
- **From the market:** template sites use colour for decoration (sidebars,
  bars, icons). Here the second colour has one job, "yours to check", and the
  decoration comes from that job.

## Fonts and licences

One family, OFL 1.1, from the Google Fonts repository, unmodified, in
`design-concepts/fonts/syne/` with `OFL.txt`. Variable weight axis (400–800);
Typst selects weights 500, 600, 700 and 800 from it.

| File | Source | SHA-256 |
|---|---|---|
| `Syne[wght].ttf` | <https://raw.githubusercontent.com/google/fonts/main/ofl/syne/Syne%5Bwght%5D.ttf> | `ce5ac77142a65cab2248a1a2ebb740b1d4d9c20b52488877d3ff664d1356104a` |
| `OFL.txt` | <https://raw.githubusercontent.com/google/fonts/main/ofl/syne/OFL.txt> | `cc43cdce6f91c57989af8459341c276655e34224e954fa69c2ad700831a742d8` |

## Data it needs

- CV content: `identity.rank`, `contacts.left/right`, `profile`,
  `companies[].name/period/groups[].type/ships[].name/rank/months`. Totals
  (129 months, 22 vessels, 6 companies) are counts and sums of the record,
  never calendar arithmetic.
- Per-client words: Greek first name, CV-language name split in two lines,
  draft number, dates, page count, the four samples, the check wording.
- **Missing:** a fact mark for running text (only "six" in the profile is
  marked, by a one-off rule); proposed glossary term below.

## What it would take to become the house `Text Draft`

A replacement for `scripts/text-draft.typ` (about 120 lines): the `fact`
slab with the fixed drift, two page backgrounds (giant draft number, reply
disc), and a flowing content body; unlike Stoichedon it needs no grid
allocator, so it is the cheapest of the three to build (half a day).
The draft number is data, so "02", "03" print themselves.

## Known weaknesses

- Syne's extended black is very wide: Greek headlines longer than about ten
  letters per line must break by hand (the headline is fixed house copy, so
  this is solved once).
- Syne has no italic; type labels use spaced capitals.
- Orange-on-orange: a fact inside a giant orange form would vanish, so
  content pages carry no giant forms. That rule must be kept.
- In greyscale the orange slabs become light grey; still distinct, but the
  poster loses its punch (acceptable for a phone-first draft).
- The slabs make the experience table dense; it reads like a marked-up
  proof, which is the intent, but it is the loudest table of the three.
