# Research review round 2: magazine-editor, Text Draft directions (2026-09-27-editor)

Snapshot: worktree C:\Users\jimzord12\Documents\GitHub\cvgen-idea-editor, commit c66ebee95afebf6ee0d8aab2cd7564e33c3bf175

Claims checked: 13 load-bearing, 13 confirmed (one only in substance, because the quote is worded wrongly), 0 unreachable.

I had no shell, so I did not run `git diff`. I read the three briefs in full instead.

Round 1 fixes, all confirmed at the source:
- R1: the Pattern (sewing) quotes are now word for word: "provide 'match points' for adjoining pattern pieces" and "for a different fit".
- R3: the FAQ says "Once you receive the first draft, please review it and send feedback to the writer". The claim is now labelled as the author's observation.
- R4: the Wikipedia "Rubric" page says "rubrica, meaning red ochre or red chalk", word for word.
- R5: the DESCRIPTION file confirms:
  - the 1492 Macrobius edition, from Giovanni Rosso's shop "in Venice";
  - the epigraphical symbols;
  - the 1927 origin;
  - the Latin version added in 2000.
- R7: the Split Arrow source is now labelled a print shop blog, and the quote is exact.
- Raw font files: the links open and support the claims, and no specimen links remain.
  - Bona Nova: 1971; Heidrich is "the creator of Polish banknotes"; designer "Capitalics, …"; Greek subset.
  - GFS Neohellenic: all four cited files are listed; Greek and extended Greek subsets.

## Findings
### R8 Note: Corita Kent quote (Two Inks)
Source: https://hammer.ucla.edu/collections/grunwald-center-collection/corita-kent/process - Says: "detailed instructions to her printer". The words "to the printers" do not appear on the page. - Fix: quote the page's own words.

### R9 Note: "one ink per pass" (Two Inks)
Source: the Split Arrow page - Says: "a single [or up to 2] ink at a given time". The brief's own Wikipedia Risograph source says two-drum MZ models print two colours in one pass. - Fix: "one or two inks per pass".

### R10 Note: "Syne has no italic" (Two Inks)
Source: https://fontsinuse.com/typefaces/81101/syne - Says: the 2017 release had an Italic. The Google Fonts build (METADATA lists one upright file, weights 400–800) has none. - Fix:
- Write "the Google Fonts Syne has no italic".
- Cite the raw Syne METADATA.pb for "400–800". The Syne specimen link was dropped rather than replaced.
- The weakness stands in practice: the related OFL family Syne Tactile covers only Latin, with no Greek.

### R11 Note: "digitised it for the Athens Archaeological Society" (Stoichedon)
Source: the GFS Neohellenic DESCRIPTION file - Says: "funded by the Athens Archeological Society". - Fix: "funded by".

### R12 Note: unlabelled market lines (Stoichedon, Two Inks)
Two claims have no source:
- "no template sells a draft built on a letter grid"
- "template sites use colour for decoration"

Fix: label both as the author's observation, as First Fitting now does.

## Coverage check
- Syne italic and licence: this search is where R10 came from. The GitLab README did not render and npm returned 403, so the licence of the original italic is unconfirmed.
- Paid writers marking facts in drafts: the search found only bold dates and titles used as résumé styling. Nothing contradicts First Fitting's observation.

Neither search reverses a conclusion.

## Verdict: PASS
- First Fitting: PASS
- Stoichedon: PASS (R11, R12)
- Two Inks: PASS (R8–R10, R12)
- Overall: PASS, Notes only

Sources: [Fonts In Use, Syne](https://fontsinuse.com/typefaces/81101/syne) · [Syne on GitLab](https://gitlab.com/bonjour-monde/fonderie/syne-typeface) · [@fontsource/syne-italic](https://www.npmjs.com/package/@fontsource/syne-italic) · [Syne Tactile METADATA](https://raw.githubusercontent.com/google/fonts/main/ofl/synetactile/METADATA.pb)
