# Research review round 1: magazine-editor, Text Draft directions (2026-09-27-editor)

Snapshot: worktree C:\Users\jimzord12\Documents\GitHub\cvgen-idea-editor, commit 54ae030305c846d4ff8e7229912b361eef245ad3

Claims checked: 18 load-bearing, 16 confirmed (2 of them only in substance, because the wording is off), 2 unreachable.

SHA-256 is not verified: my tools cannot hash files. The file names and OFL texts do match upstream.

## First Fitting
Sources checked:
- Savile Row terms: confirmed word for word ("Baste: garment roughly assembled for first fitting"; "tacking with long stitches to hold garment parts together").
- Wikipedia Sampler: confirmed ("specimen of achievement"; alphabet, maker's name and date).
- Pattern (sewing): confirmed in substance.
- Cooper Hewitt: unreachable.
- Bona Nova:
  - Fonts In Use: "a cursive text typeface originally designed in 1971 by Andrzej Heidrich", foundry Capitalics.
  - Google Fonts description: Heidrich is "the creator of Polish banknotes".
  - METADATA subsets include Greek.

### R1 Note: quote "to help align adjoining pattern pieces"
Source: https://en.wikipedia.org/wiki/Pattern_(sewing) - Says: that phrase is not in the page or its wikitext. The page says symbols "provide 'match points' for adjoining pattern pieces". The quote "for a different fit" is exact. - Fix: quote the page's own words.

### R2 Note: Cooper Hewitt sampler (the author flagged this)
Source: https://collection.cooperhewitt.org/objects/18474165/ - Says: the page redirects (301) to si.edu, the SI collection search returns 403, and archive.org is blocked for me. The search listing matches the brief ("red embroidery on a natural linen ground… rows of alphabets"). Not confirmed, not false, and already disclosed in the brief. - Fix: none required.

### R3 Note (coverage): "CV builders never show a draft at all"
Source: https://www.resumeprofessionalwriters.com/faq/ - Says: "Once you receive the first draft, please review it and send feedback to the writer". Paid CV writers, the premium comparison set, do send drafts. - Fix: reword along the lines of "paid writers send plain drafts; none marks which words the client owns", and label it as the author's observation.

Verdict: PASS

## Stoichedon
Sources checked:
- Wikipedia Stoichedon: all three quotes confirmed, plus "no spaces between words".
- Production Type (Alice Savoie, 2025-04-10): confirmed.
- CSAD Oxford: unreachable.
- Rijksmuseum: confirmed ("gebaseerd op een grid dat werd gebruikt voor de huisstijl", i.e. based on a grid used for the house style). The grid is visible in the image; The Graphic Design School's page corroborates.
- GFS Neohellenic history, from the repository description: confirmed (1927; "GFS digitized the typeface (1993-1994) funded by the Athens Archeological Society with the addition of a new set of epigraphical symbols").

### R4 Note: "from rubrica, red ochre" is credited to Rubrication
Source: https://en.wikipedia.org/wiki/Rubrication - Says: "from the Latin rubrīcāre, 'to color red'… ruber". There is no mention of ochre. The principle (red for "the actions to be performed", texts to read in black) is confirmed. The "Rubric" page has "rubrica, meaning red ochre or red chalk". - Fix: add https://en.wikipedia.org/wiki/Rubric for the etymology.

### R5 Note: "epigraphic pedigree"
Source: https://raw.githubusercontent.com/google/fonts/main/ofl/gfsneohellenic/DESCRIPTION.en_us.html - Says: the letterform comes from "a round, and almost monoline type which had first appeared in 1492 in the edition of Macrobius" (Venice). Only the added symbols are epigraphic. - Fix: "a 1492 Venetian book Greek, digitised with epigraphical symbols".

### R6 Note: CSAD page (the author flagged this)
Source: http://archive.csad.ox.ac.uk/CSAD/Stoichoi.html - Says: the connection is refused over HTTPS. The page is indexed as "Stoichedon Style" with a matching snippet. Two confirmed sources already carry the principle. - Fix: none needed.

Verdict: PASS

## Two Inks
Sources checked:
- Hammer Museum on Corita Kent: confirmed ("enlarged in the finished print to overlay the entire image"; "detailed instructions to her printer"). On the palette, the page says she reused another work's palette "for continuity", which is a fair basis for the claim.
- Split Arrow: confirmed word for word.
- Wikipedia Risograph (opened): covers swappable ink drums and use by artists and zines. It says nothing about misregistration.
- Syne: confirmed.
  - Fonts In Use: "Extra (black and extended)"; "five upright weights with support for Greek (by George Triantafyllakos) in March 2022".
  - Repository description: "When getting bolder, the typeface also gets wider".
  - METADATA: wght axis 400–800, one upright file, no italic.

### R7 Note: misregistration rests on an unlabelled print-shop blog
Source: https://splitarrowprints.com/learn/risograph-printing-quirks-an-intro-into-risograph-imperfections-and-their-causes/ - Says: what the brief quotes. It is a vendor's own blog, and it is the only source for misregistration. - Fix: label it "print shop blog (practitioner)".

Verdict: PASS

## Fonts
- All three families are OFL 1.1 in google/fonts `main`, and METADATA lists every cited file.
- The local OFL.txt headers match upstream. GFS Neohellenic carries a Reserved Font Name, which is fine for unmodified use.
- Greek subsets: Bona Nova (greek), GFS Neohellenic (greek, greek-ext), Syne (greek).
- All three Greek `Check Page` renders show no missing glyphs.
- Note: Google Fonts specimen pages return no text to a fetcher. Cite the raw METADATA.pb and DESCRIPTION files instead.

## Coverage check
- "Cooper Hewitt sampler 18474165" and "CSAD stoichedon": both only reproduced the author's descriptions.
- "Wim Crouwel Vormgevers grid visible": confirms the grid is shown.
- "professional resume writing service first draft": this search is the source of R3.

None of these reverses a conclusion.

## Verdict: PASS
All three directions pass with Notes only.
