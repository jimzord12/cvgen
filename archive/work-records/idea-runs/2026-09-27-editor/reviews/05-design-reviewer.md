# Design review round 2: 2026-09-27

Snapshot: worktree C:\Users\jimzord12\Documents\GitHub\cvgen-idea-editor, commit 96ac749f0397da315275c8d6950f4bfb99077872

**What I checked:**
- Fresh compiles match the committed PNGs pixel for pixel. The PDFs differ only in creation date, and there are no font warnings.
- The totals (129 months, 22 vessels, 6 companies) match the record.
- Every page at 96 and 200 dpi, at 390 px phone width, in greyscale, and in deutan and protan simulations.
- Long-name stress copies of all three concepts.

**Round 1 fixes:**
- D5 holds: facts now stand out by weight in greyscale and in both colour-blindness simulations.
- D9 holds: the size checks stop the compile loudly. "Κωνσταντίνε," at 52 pt measures 530 pt against 505; "Panagiotopoulos" at 42 pt measures 553 pt. The 44/42 pt and 34 pt renders fit.
- D6 and D7 hold: span 4 fails with "needs 48 cells", and the greeting is now a separate vocative.
- D11 holds.
- D1 is applied, but the new wording caused D13.

## 2026-09-27-first-fitting: FINDINGS
First impression: the huge italic "Ώρα για πρόβα." caught in the copper thread from the ticket.
- **D13 Blocking (3, Craft): the new headline collides with itself at 0.08em leading.**
  - The ό's tonos (accent) lands on line 1's baseline right after "Ώρα", so the headline reads "Ώρα, για / προβα.": a false comma, and the ό looks unaccented.
  - The γ's descender runs into the β.
  - It shows at 96 dpi and on a phone. It is a regression from the D1 change: the old words never stacked these letters.
  - Fix: set the leading to about 0.3em and pull line 1 up (v(10mm) to about v(2mm)), so line 2 and the thread stay where they are. I tried this in a copy: both collisions clear and the thread is unchanged (`stress\ff-fix-lead-head200.png`).
- **D14 Nit (5):** a typical long name ("Konstantinos Papadopoulos", 54 pt) wraps to two lines on page 2. That is fine, but it silently pushes the third company onto an unplanned page. Say in the brief that the house version flows.

## 2026-09-27-stoichedon: PASS
First impression: ΕΛΕΝΗ ΜΑΡΚΟΥ cut one letter per 30 mm cell, then the bold red rubric (the facts, in red ochre).
- **D15 Note (1/5; applies to Two Inks too):** vessel types (`groups[].type`) are facts from the record, but they print as unmarked grey labels. Page 1 says to check only the marked words, so a wrong vessel type would go unchecked. First Fitting marks them. Fix: mark the type, or name in the brief which fields count as facts.
- **D16 Note (5):** any name word of 13 or more letters needs span 1 (one letter per 7.5 mm cell), and many Greek surnames (-όπουλος, -ίδης) run 13–15 letters. At span 1 the name prints smaller than ΕΛΕΓΞΤΕ ΜΟΝΟ, above seven empty grid rows (stress render). The brief discloses this, but the owner judges by eye. Fix: add a span-1 render, like Two Inks' long case.
- **D17 Nit (3):** "ΤΑ ΚΟΚΚΙΝΑ" is set bold but is not a fact, which contradicts the brief's "Bold for facts only". The gloss that tells colour-blind readers to look for bold is the faintest line on the page (16 pt grey, about 10 px on a phone). Fix: one sentence in the brief, and set the gloss in the main ink.

## 2026-09-27-two-inks: PASS
First impression: the cropped orange "01" and the giant OK; still the clearest `Check Page` on a phone. The long-name case holds.
- D15 applies here too.
- **D18 Note (3):**
  - In running text, the slab reaches about 2.2 mm past the fact at 12 pt (padding plus the 0.9 mm drift) and covers the "o" of "operators" ("six o|perators").
  - At text sizes the drift nearly equals the padding, so letters still touch the slab's left and top edges. D10 is only half fixed; the registration target helps.
  - Fix: at text sizes, make the padding at least twice the drift, and add a thin space after a fact in running text.

## Renders made
C:\Users\jimzord12\Documents\GitHub\cvgen-idea-editor\builds\design-review-r2-20260927-035128\
- Recompiled PDFs. For every page: 96 and 200 dpi, phone 390 and 1170 px, greyscale, deutan and protan.
- Close-ups: `zoom-*.png`, `crop-*.png`. D13 is shown in `zoom-ff-p1-tonos.png`, `zoom-ff-p1-gamma-beta.png` and `zoom-ff-p1-head-96.png`.
- `stress\`: long-name copies, never the concept files.
  - `ff-long`, `stoi-long-span2`, `stoi-longer-span1` and `ti-longer-34` render.
  - `stoi-long-span4`, `ti-longer-42` and `ti-long-84` fail to compile, as designed.
  - `ff-fix-lead` is the D13 fix trial.
- Helper scripts (`*.py`, `compile.sh`).

Two process slips, neither of which changed anything:
- My first shell command included `git rev-parse` and `git status` by mistake. It exited with no output.
- One compile ran with an empty output path; Windows refused the write, so nothing was written.

## Verdict: FINDINGS
Stoichedon and Two Inks pass with Notes only. First Fitting has one Blocking finding (D13), which the leading and spacing change above fixes.
