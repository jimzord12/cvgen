# Research review round 3: magazine-editor, Text Draft directions (2026-09-27-editor)

Snapshot: worktree C:\Users\jimzord12\Documents\GitHub\cvgen-idea-editor, commit 96ac749f0397da315275c8d6950f4bfb99077872

Claims checked: 12 load-bearing, 11 confirmed, 1 partly wrong (a year, R13), 0 unreachable.

I had no shell, so there is no `git diff`. I read all three briefs and compared them with rounds 1 and 2 and with design review 1, which caused the rewrites.

**Round 2 Notes, checked at the source:**
- R8: "detailed instructions to her printer" appears word for word on the Hammer page.
- R9: "a single [or up to 2] ink at a given time" appears word for word, brackets included.
- R10: METADATA lists one upright file, `Syne[wght].ttf`, weight 400–800, with Greek. The year is wrong (R13).
- R11: "funded by the Athens Archeological Society" appears word for word.
- R12: both market lines are now labelled "(my observation, not a survey)".

**New claims from the design rewrites:**
- "The same on the whole page, as a real second drum would" (Two Inks): true in substance. Split Arrow says misregistration happens "per ink layer", when the machine grabs the paper, so it is one shift per layer.
- "Bona Nova SC" (First Fitting): the family exists. It is OFL, has Greek and was added on 2024-05-27.
- Greek capitals without accents, with Μάιος → ΜΑΪΟΣ (Stoichedon): the ICU Greek uppercasing note gives exactly this example.
- Typst selects Syne's weights: true (R14).

**No regressions.** The unchanged quotes still match what rounds 1–2 confirmed: Savile Row, Pattern (sewing), Stoichedon, Rubric, Rijksmuseum, the 1492 Macrobius, Synesthésie/Bonjour Monde and the 2022 Greek.

## Findings
### R13 Note: "the 2017 release had one" (Two Inks)
Source: https://fontsinuse.com/typefaces/81101/syne - Says:
- "Originally designed in 2017 for the art center Synesthésie"
- "Released under an open-source license in June 2018, initially in five styles; … Italic (see Syne Tactile)…"

The wrong year comes from my own round-2 wording. Syne Tactile's METADATA lists only latin, latin-ext and menu, so no Greek.

Fix: "(the original 2018 release had one, now Syne Tactile, Latin only)". The weakness still holds.

### R14 Note: "Typst selects weights 500, 600, 700 and 800" (Two Inks)
Source: https://typst.app/docs/changelog/0.15.0/ - Says:
- "Typst now supports variable fonts."
- `wght` is "automatically set based on text `weight`".
- Released 2026-06-15.

The claim is true for the pinned Typst 0.15.1, and the design review found the right fonts embedded. But the brief gives no source, and the direction's extended black depends on a feature about three months old.

Fix: add the changelog link and "Typst 0.15+".

## Coverage check
- "Typst variable fonts support": led to the 0.15.0 changelog. It confirms the claim; I only added R14.
- "Greek all caps dialytika": led to the ICU note, which confirms the Stoichedon claim.

Neither search changes a conclusion.

## Verdict: PASS
- First Fitting: PASS
- Stoichedon: PASS
- Two Inks: PASS (R13, R14)
- Overall: PASS, Notes only

Sources: [Hammer, Corita Kent process](https://hammer.ucla.edu/collections/grunwald-center-collection/corita-kent/process) · [Split Arrow](https://splitarrowprints.com/learn/risograph-printing-quirks-an-intro-into-risograph-imperfections-and-their-causes/) · [Fonts In Use, Syne](https://fontsinuse.com/typefaces/81101/syne) · [Syne METADATA](https://raw.githubusercontent.com/google/fonts/main/ofl/syne/METADATA.pb) · [Syne Tactile METADATA](https://raw.githubusercontent.com/google/fonts/main/ofl/synetactile/METADATA.pb) · [GFS Neohellenic DESCRIPTION](https://raw.githubusercontent.com/google/fonts/main/ofl/gfsneohellenic/DESCRIPTION.en_us.html) · [Bona Nova SC METADATA](https://raw.githubusercontent.com/google/fonts/main/ofl/bonanovasc/METADATA.pb) · [Typst 0.15.0 changelog](https://typst.app/docs/changelog/0.15.0/) · [ICU Greek uppercasing](https://icu.unicode.org/design/case/greek-upper) · [Wikipedia Sampler](https://en.wikipedia.org/wiki/Sampler_(needlework))

Files read:
- C:\Users\jimzord12\Documents\GitHub\cvgen-idea-editor\design-concepts\2026-09-27-first-fitting\brief.md
- C:\Users\jimzord12\Documents\GitHub\cvgen-idea-editor\design-concepts\2026-09-27-stoichedon\brief.md
- C:\Users\jimzord12\Documents\GitHub\cvgen-idea-editor\design-concepts\2026-09-27-two-inks\brief.md
