# First Fitting — a `Text Draft` direction

**Idea: the draft is the first fitting.** A bespoke suit is first shown to its
client "basted": held together with long, loose temporary stitches so the
client can try it on before the tailor sews it for good. The `Text Draft` is
exactly that moment for a CV, so it is drawn as one: a copper thread runs
through the document, and every fact the `Client` must check is tacked with a
copper running stitch. Our wording is left plain. Three words: **tacked, not sewn**.

Files: `concept.pdf` (two pages), `page-1.png` (the `Check Page`, Greek),
`page-2.png` (the first CV-content page, English), `concept.typ`.
Fictional record: `examples/candidates/chief-officer-example.json`; the
`Check Page` addresses the same person by the Greek form of her name,
Ελένη Μάρκου (invented, consistent with the record's ELENI MARKOU of Piraeus).

## What to notice first

1. The headline "Πρώτη πρόβα." (First fitting) in a very large calligraphic
   italic, with the thread tied to a tailor's ticket, crossing in front of
   the letters and wrapping the π, as the brand mark's thread wraps the C.
2. The `Check Page` teaches one visual rule: *check only what has the copper
   stitch under it*, shown on four real samples (a name, a date, a number, a
   title). Page 2 then keeps that promise on every fact.
3. The seam: a basting line down the left edge of every page, with pattern
   notches pointing at the two things the `Client` does (check, reply OK).

Signature: the copper running stitch (dashed underline plus the looping
thread). Recognisable without the name on it.

## References and the principle taken from each

| Source | Principle taken |
|---|---|
| Savile Row Bespoke Association, tailoring terms: <https://www.savilerowbespoke.com/about-us/tailoring-terms/> ("Baste: garment roughly assembled for first fitting"; "Basting: tacking with long stitches") | The client is shown the work deliberately unfinished, held by visible temporary stitches, and judges the fit, not the finish. Maps one to one onto "check the facts; the wording is ours". |
| Needlework samplers: <https://en.wikipedia.org/wiki/Sampler_(needlework)> ("specimen of achievement": alphabets, numerals, the maker's name and date); Cooper Hewitt sampler, England, red thread on natural linen: <https://collection.cooperhewitt.org/objects/18474165/> | Thread as a writing instrument: one thread colour on a natural ground, and the maker's name and date carried on the piece (the ticket). |
| Sewing-pattern markings: <https://en.wikipedia.org/wiki/Pattern_(sewing)> (notches and match points "to help align adjoining pattern pieces"; lines that tell you where a piece may be lengthened or shortened "for a different fit") | A small, consistent grammar of marks, where the line style itself is the instruction: the dashed stitch = check this; the notch = a step to act on. |
| Bona Nova (Capitalics, after Andrzej Heidrich's 1971 Bona): <https://fonts.google.com/specimen/Bona+Nova>, <https://fontsinuse.com/typefaces/83442/bona-nova> | A cursive-rooted text face by a banknote designer: hand-made warmth with engraved precision, and a real Greek. |

No drawing, photo or copy was taken from any of them.

## Why it differs

- **From the rejected draft** (navy + brass, Didot, dossier): no navy, no
  Didone, no running-head formality; warm natural paper, a calligraphic
  italic, one copper thread. It says "made by hand for you", not "legal file".
- **From Flagship:** Flagship is a dark masthead, portrait and condensed
  grotesque. This has no portrait, no bars, no boxes; one serif family.
- **From the market:** CV builders never show a draft at all, and their
  templates mark nothing. Here the draft's function (which words the client
  owns) *is* the ornament.

## Fonts and licences

One family, OFL 1.1, from the Google Fonts repository, unmodified, in
`design-concepts/fonts/bona-nova/` with `OFL.txt`.

| File | Source | SHA-256 |
|---|---|---|
| `BonaNova-Regular.ttf` | <https://raw.githubusercontent.com/google/fonts/main/ofl/bonanova/BonaNova-Regular.ttf> | `d72f7715b6b66096e0cc2971e4954f8be33bdced1f143f9c5739a03cdb60bede` |
| `BonaNova-Italic.ttf` | <https://raw.githubusercontent.com/google/fonts/main/ofl/bonanova/BonaNova-Italic.ttf> | `0d61c160a521b072d1af19e9683754f3f5761bbce35f73fdf091ecdf495bc6c2` |
| `BonaNova-Bold.ttf` | <https://raw.githubusercontent.com/google/fonts/main/ofl/bonanova/BonaNova-Bold.ttf> | `c59ccb3ba8f0151236b1b427b58bee0c90607c82ef747cc6e19d5e20138385dd` |
| `OFL.txt` | <https://raw.githubusercontent.com/google/fonts/main/ofl/bonanova/OFL.txt> | `38f7dca74a98bbcc13858c9f56e9c7d86e12b4242f2a5ccbecf6e9277c9fd363` |

Greek: full monotonic Greek, checked in the render (tonos, dialytika, «»).

## Data it needs

- CV content: `identity.rank`, `contacts.left/right`, `profile`,
  `companies[].name/period/groups[].type/ships[].name/rank/months`. The sea
  service totals (129 months, 22 vessels) are sums of the record's `months`,
  never calendar arithmetic.
- Per-client words (parameters, not design): Greek first name and full name,
  the gendered ticket label (Πελάτισσα / Πελάτης), draft number, date, page
  count, the four sample facts, and the check wording. The CV name is set in
  the CV's own case ("Eleni Markou"); the record stores it in capitals.
- **Missing:** a way to mark a fact inside running text. In the profile only
  "six" is tacked, by a one-off rule. A real draft needs the drafter to wrap
  facts in prose (`#fact[...]`); proposed glossary term below.

## What it would take to become the house `Text Draft`

A replacement for `scripts/text-draft.typ` (about 150 lines): the `fact`
mark, the seam and notch, the ticket, `caps-el` for Greek capitals, and a
`check:` block with the fields above. Page 1's thread is drawn in page
coordinates for this headline; the house version would fix the headline
words ("Πρώτη πρόβα.") as brand copy so the thread never has to move, and
keep the name on the ticket (any length up to about 24 characters). No
artwork pack; no template changes.

## Known weaknesses

- The thread's path is tuned to this headline; a different headline wording
  needs the curve redrawn (fine if the headline is fixed house copy).
- Nearly every line of an experience table is a fact, so page 2 carries many
  stitches; it reads as texture, but it is busy at 96 dpi.
- The dashed stitch is thin (0.7 pt) at body size; on a small phone screen it
  reads as a dotted underline, not as thread, until zoomed.
- Labels are spaced capitals; true small caps live in a separate family
  (Bona Nova SC) that I did not bring, to keep to one download.
- The Cooper Hewitt sampler page redirected when fetched; its description
  above comes from the collection's search listing, not a page I opened.
