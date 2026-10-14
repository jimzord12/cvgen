# Research review round 4: magazine-editor, Text Draft directions (2026-09-27-editor)

Snapshot: worktree C:\Users\jimzord12\Documents\GitHub\cvgen-idea-editor, commit 13938f24ceba57a8489117425d10b3fd47baa727

Claims checked: 5 new or changed, 5 confirmed (one incomplete, R15), 0 unreachable. I also re-fetched one older quote to check for regressions, and it still holds.

I had no shell, so there is no git diff. I read all three briefs and compared them with the wording confirmed in rounds 1–3 and with design review 2 (D13–D18).

- **R13 (Syne italic):** confirmed.
  - Fonts In Use: "Released under an open-source license in June 2018, initially in five styles; … Italic (see Syne Tactile)".
  - The Syne Tactile METADATA lists only the subsets latin, latin-ext and menu.
- **R14 (Typst weights):** confirmed. The 0.15.0 changelog (June 15, 2026) says "Typst now supports variable fonts", and `wght` is "automatically set based on text weight".
- **"The current Text Draft uses 13 pt":** confirmed. `scripts/text-draft.typ` line 18 sets 13pt.
- **Design rewrites D13–D18** are mock-up facts, not research claims. The span arithmetic is right: 12 letters × 4 = 48 cells, and 15 letters × 2 = 30 cells, more than 24.
- **No regressions.** Every quote still matches rounds 1–3. The re-fetched Hammer page still reads: "the single letter "W," which she enlarged … to overlay the entire image".

## Findings
### R15 Note: "selects weights 500, 600, 700 and 800" (Two Inks)
Source: `design-concepts/2026-09-27-two-inks/concept.typ` lines 168 and 175. The profile and the footnote use the default weight, 400. Fix: "weights 400–800".

### R16 Note: "The bold italic is unused" (Stoichedon), a regression from the D15 fix
Source: `design-concepts/2026-09-27-stoichedon/concept.typ` line 199, `text(style: "italic", fact(g.type))`. `fact` sets Bold, so vessel types now use the Bold Italic, and the regular Italic looks unused. Fix: swap the sentence. This is an inventory slip, not a research error.

## Coverage check
- The Typst 0.15.1 changelog (July 17, 2026) has one font entry, about New Computer Modern. Nothing in it touches variable weights, so R14 holds for the pinned 0.15.1.
- The Syne Tactile DESCRIPTION calls the face "trackpad-calligraphy" after Renaissance handwriting. It never says "italic", but nothing in it contradicts Fonts In Use.

Neither check changes a conclusion.

## Verdict: PASS
- First Fitting: PASS
- Stoichedon: PASS (R16)
- Two Inks: PASS (R15)
- Overall: PASS, Notes only

Sources:
- https://fontsinuse.com/typefaces/81101/syne
- https://raw.githubusercontent.com/google/fonts/main/ofl/synetactile/METADATA.pb
- https://raw.githubusercontent.com/google/fonts/main/ofl/synetactile/DESCRIPTION.en_us.html
- https://typst.app/docs/changelog/0.15.0/
- https://typst.app/docs/changelog/0.15.1/
- https://hammer.ucla.edu/collections/grunwald-center-collection/corita-kent/process

Files read, all under C:\Users\jimzord12\Documents\GitHub\cvgen-idea-editor\:
- design-concepts\2026-09-27-first-fitting\brief.md
- design-concepts\2026-09-27-stoichedon\brief.md
- design-concepts\2026-09-27-two-inks\brief.md
- the two concept.typ files named above
- scripts\text-draft.typ
