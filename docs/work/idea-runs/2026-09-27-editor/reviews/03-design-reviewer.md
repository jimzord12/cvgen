# Design review round 1: 2026-09-27

Snapshot: worktree C:\Users\jimzord12\Documents\GitHub\cvgen-idea-editor, commit c66ebee95afebf6ee0d8aab2cd7564e33c3bf175

What I verified:
- The committed PNGs match fresh renders exactly.
- Recompiling gives pixel-identical PDFs with no font warnings, and the embedded fonts are the ones the briefs name.
- The totals (129 months, 22 vessels, 6 companies) match the record.
- Greek capitals are set without accents.
- At a 390 px phone width, all three `Check Page`s show what to check and how to reply without zooming.

## 2026-09-27-first-fitting: PASS
First impression: the 124 pt italic "Πρώτη πρόβα." caught in the brand mark's copper thread.
- D1 Minor (5): the fixed headline says "first fitting", but a draft 02 is normal in the workflow, and the thread is drawn around these exact words. Fix: a headline without the ordinal ("Πρόβα."), or a thread drawn for each ordinal; say which in the brief.
- D2 Note (2): the safest of the three and the closest in feel to the rejected attempt (warm metal on cream, classical serif). Its daring is the headline and the thread, so push those rather than the restraint.
- D3 Nit (3): the bold instruction sits tighter above "Ονόματα" than the row spacing below it. Stitches end in clipped half-dashes. "PAGE 2 OF 3" is about 5 px on a phone, yet the reply asks for the page number.
- D4 Nit (5): the ticket holds about 15 characters, not the 24 the brief claims. A long name wraps cleanly onto two lines (stress render).

## 2026-09-27-stoichedon: FINDINGS
First impression: ΕΛΕΝΗ ΜΑΡΚΟΥ cut one letter per 30 mm cell on a visible grid.
- D5 Blocking (1, black and white): colour is the only thing that marks a fact.
  - In greyscale the ochre facts print the same grey as the quiet wording (luma 87 vs 101; "MV Arctic Flame" vs "LNG carriers").
  - In the colour-blindness simulation the ochre becomes dark olive, so a red-green colour-blind client (roughly 1 in 12 men, and the clientele is mostly male) cannot follow "τα κόκκινα" (check the red).
  - Fix: add one cue that does not depend on colour and suits the idea (the Bold cut, or a solid point in the cell before each fact), then check a greyscale render.
- D6 Minor (5): the brief's long-name fallback is wrong. ΠΑΝΑΓΙΩΤΟΠΟΥΛΟΣ needs 30 cells at 15 mm, more than the 24 available, so it falls to 7.5 mm, not 15. Also, "pick the largest cell that fits" is automatic shrinking, which constitution §4 forbids. Fix: correct the sentence, and make the cell size a per-client value set by hand that fails loudly on overflow. A 12-letter name at 15 mm still holds up (stress render).
- D7 Minor (5, Greek): `given-el` supplies both the name (nominative) and the greeting. Male clients need the vocative in the greeting ("Κωνσταντίνε,", not "Κωνσταντίνος,"). Fix: a separate greeting parameter, as First Fitting has.
- D8 Nit (3): the page says "PAGE 2/3", but the brief expects four pages. The Regular "1" reads as Ι on a phone. The wavy Ξ falls in the key verb (ΕΛΕΓΞΤΕ).

## 2026-09-27-two-inks: FINDINGS
First impression: a cropped orange "01" and a giant OK; the clearest `Check Page` of the three on a phone.
- D9 Blocking (5): the page-2 name at 84 pt fits only name words of about six letters.
  - "Konstantinos Papadopoulos" runs off the sheet with no error, and "Κωνσταντίνε," on page 1 reaches 9 mm into the margin (stress renders).
  - The brief calls the width problem "solved once" because the headline is fixed house copy, but the name changes with every client.
  - Fix: a name size set by hand that fails loudly on overflow, a line about it under weaknesses, and one long-name render so the owner sees the typical case.
- D10 Note (3): the 0.7 mm misregistration reads as uneven highlighter padding (letters sit flush to the slab's left and top edges), not as a second ink drum.
- D11 Note (1): the disc edge puts half of "Όλα σωστά;" on orange, and the page defines orange as "yours to check". The line below it ("Κάτι λάθος…", the reply if something is wrong) is 15 pt, about 10 px on a phone, and leaves "σωστό." alone on its last line. Fix: move "Όλα σωστά;" off the disc and set that reply line at 18 pt.
- D12 Nit (3): the page-2 table is 10.5 pt, smaller than the 13 pt of the current `Text Draft`.

For the lead (not a finding): the briefs' sourced wording changed after the research PASS (R1, R3–R5, R7 were applied). SKILL step 6 routes such edits back through the research gate, or you record why not.

## Renders made
C:\Users\jimzord12\Documents\GitHub\cvgen-idea-editor\builds\design-review-20260927-033014\ contains:
- recompiled PDFs;
- for each page: 96 and 200 dpi, phone 390 and 1170 px, greyscale, and a red-green colour-blindness simulation;
- close-ups: `crop-*.png`;
- `stress\*-long.*`: copies of the concepts with long Greek names, not the concepts themselves.

## Verdict: FINDINGS
First Fitting passes. Stoichedon (D5) and Two Inks (D9) each have one Blocking finding, and both fixes are small.
