# Design review round 1: 2026-09-27 (logo options)

Snapshot: worktree `C:\Users\jimzord12\Documents\GitHub\cvgen-brand-logo`, branch feat/brand-logo-svg @ d7a5d42.

**Verdict: PASS.** No Blocking or Material findings. Three Minor fixes are cheap and worth doing before the owner picks.

## Checked with my own renders and scripts (not the author's previews)
- **SVG source is clean in all six files.** No `<text>`, no raster, no background shape. All four corner pixels are fully transparent.
- **Fonts are genuine.** Typst 0.15.1 set C and V in Cormorant Garamond at weight 700: 0.00 units deviation from the logo paths in all six files. Jost Light "g", "e", "n" at 0.26 scale deviate by at most 0.07 units.
- **Licences and hashes check out.** Both SHA-256 values match the README, in the worktree and in main. Genuine OFL 1.1 texts sit beside both fonts.
- **Colours are accurate.** My v3 medians are `#13120F` and `#B6713E`; the README's `#131210` and `#B7713D` are within one unit. Contrast claims hold: 4.89, 4.32 and 2.98.
- **Thread geometry is sound.**
  - The over/under split points lie exactly on the under-curve.
  - Every join is tangent-continuous (0.00°). The bold ribbon's only angle breaks are its tail tip and its cut ends.
- **Over/under matches v3 at every crossing** (v3 crops): start tucked under the C, over the C's left side, over the V's left stroke, under its right stroke.
- **Small variant at 32 px reads as CV with a clearly visible copper thread**, on white and on #1E1E1E.

## Findings
- **L1 Minor.** Files: mark, wordmark, reversed, bold.
  - Problem: the outlines keep the variable fonts' overlaps. The V is one self-intersecting contour below its apex, g/e/n overlap internally, and the bold ribbon crosses itself in its second loop.
  - They render correctly under SVG's default fill rule. Under even-odd (vinyl cutters, embroidery, some converters) the V shows a white sliver, "gen" breaks up and the ribbon crossing punches a hole.
  - Fix: remove overlap (union) on the letters and the ribbon.
- **L2 Minor.** File: `brand/README.md`, lines 55-56.
  - Problem: "already the Flagship template's display face" is false. Flagship's two themes use Source Sans 3 and Barlow; Cormorant appears only in archived study 03-horizon.
  - Also, "tight viewBox" is untrue for the bold file, which has 18 empty units on the right.
  - Fix: correct the sentence, and trim the bold viewBox or drop "tight".
- **L3 Minor.** Files: `cvgen-mark-small.svg` and `cvgen-mark-small-reversed.svg`.
  - Problem: the README bills this as the chat-avatar file, but the artwork runs edge to edge. In a circular crop the V's top-right serif is shaved and the thread ends touch the rim.
  - Fix: add an avatar cut with about 12% padding (only the viewBox changes). Keep the tight file for favicons.
- **L4 Note.** At 16 px the thread closes the C's mouth, so it reads close to "eV". State 32 px as the minimum, or make a 16 px cut later.
- **L5 Note.** Fidelity: clearly v3 in composition, loop, path, over/under and colours.
  - The letters are about 6% wider than v3's, and the V has cupped Garamond serifs where v3's are flat.
  - They are also untouched stock letters that anyone could retype from Google Fonts. One custom detail would fix that. This is the owner's call by eye.
- **L6 Note.** Bold: the closest fit to the mood words (swelling ribbon, strict alternating weave, hairline tail).
  - Its second loop sits at lowercase size right after the V and can read as a script "e" ("CVe").
  - There is no reversed file, and its ink letters vanish on #1E1E1E.
- **L7 Note.** Wordmark: good placement.
  - The stroke matches the thread (13.5 vs 13), and the tail stops 32 units short of the g's bowl.
  - Below about 48 px wordmark height, the "gen" stroke drops under 1 px.
  - "gen" tracking is opened by 0.05 em but not stated in the README.
  - Missing so far: a reversed wordmark, and a one-colour version of any file (over/under currently depends on colour).

## Per file
| File | Verdict |
|---|---|
| `cvgen-mark.svg` | PASS (L1, L5) |
| `cvgen-wordmark.svg` | PASS (L1, L7) |
| `cvgen-mark-small.svg` | PASS (L3, L4) |
| `cvgen-mark-bold.svg` | PASS (L1, L2, L6) |
| `cvgen-mark-reversed.svg` | PASS (L1) |
| `cvgen-mark-small-reversed.svg` | PASS (L3) |
| `brand/README.md` | PASS (L2) |

## Renders made
All in `C:\Users\jimzord12\Documents\GitHub\cvgen-brand-logo\builds\design-review-20260927-031528\`:
- `<file>-{1024,32,16}px-{white,dark}.png`, plus 8x/16x nearest-neighbour enlargements of the 32 and 16 px renders
- `overlay-v3-vs-mark.png`
- `crop-v3-*.png` and `crop-*.png` (joins and crossings)
- `crop-cvgen-mark-evenodd.png`, `crop-cvgen-mark-bold-evenodd.png`, `crop-wordmark-gen-evenodd.png`
- `avatar-circle-test-256.png`
- Scripts: `render.py`, `checks.py`, `compare2.py`, and the Typst glyph files `glyphs-*.typ` / `glyphs-*.svg`

## Verdict: PASS
