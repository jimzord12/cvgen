# brand

CVgen's own brand assets, not client or template material.

## logos/

- `CVgen_Logo.v3.jpg`: the working mark, kept by the owner on 2026-09-25.
  A big black serif "CV" on white, flat, with one thin copper thread that
  wraps the C and curves through the V, ending in a loose tail on the right.
  Image-model render, 2048x2048 JPEG: a draft, not a production file.

Vector options drafted 2026-09-27 (options for the owner to pick, not a
final logo). Hand-authored SVG: letters are outline paths, no `<text>`, no
embedded raster, transparent background, tight `viewBox`:

- `cvgen-mark.svg`: faithful flat redraw of v3. The thread keeps v3's own
  over/under: over the C stem and the V's left stroke, under the V's right
  stroke, its start tucked into the C's bowl.
- `cvgen-wordmark.svg`: the mark plus "gen" in Jost Light, set small in the
  thread's copper at the thread's right-hand tail (the thread "writes" gen;
  gen's stroke weight matches the thread).
- `cvgen-mark-small.svg`: favicon and chat-avatar variant, square canvas.
  Thread about five times thicker, letters emboldened with an ink outline so
  the hairlines survive, the left loop dropped (the thread enters from the
  left), shorter tail.
- `cvgen-mark-bold.svg`: alternative, "unafraid of excess". The thread
  becomes a swelling broad-nib ribbon that weaves strictly over and under
  (under the C bowl, over the C stem, under the V's left stroke, over its
  right stroke) and ends in a second loop and a hairline tail.
- `cvgen-mark-reversed.svg`: `cvgen-mark.svg` for dark backgrounds (chat
  avatars, dark-mode tabs): same geometry, reversed ink and copper.
- `cvgen-mark-small-reversed.svg`: `cvgen-mark-small.svg` for dark
  backgrounds, same treatment.

Colours (ink and copper sampled from v3 as the median of solid-area pixels):

| Role | Hex | RGB |
|---|---|---|
| Ink (letters) | `#131210` | 19, 18, 16 |
| Copper (thread, "gen") | `#B7713D` | 183, 113, 61 |
| Reversed ink (letters on dark) | `#F4EFE6` | 244, 239, 230 |
| Reversed copper (thread on dark) | `#C07B45` | 192, 123, 69 |

The reversed copper is lifted slightly so a thin thread holds on a dark
background (about 4.9:1 on `#1E1E1E`, against 4.3:1 for the standard
copper) while keeping about 3:1 against the off-white letters it crosses.

Fonts (both SIL Open Font License 1.1, outlines converted to paths):

- C and V: Cormorant Garamond Bold (weight 700 of the variable font),
  `packages/cv-framework/fonts/CormorantGaramond[wght].ttf`,
  SHA-256 `b20b7d9626dd956b2c5e558692ad328b1f19e3275e2782db4fa07670d83f35e0`,
  licence `packages/cv-framework/licenses/cormorantgaramond-OFL.txt`.
  Chosen over Newsreader and Instrument Serif because its stroke contrast
  matches v3 most closely (stems about 0.2 and hairlines 0.05 of the cap
  height), and it is already the Flagship template's display face.
- "gen": Jost Light (weight 300), `design-concepts/fonts/jost/Jost[wght].ttf`,
  SHA-256 `6343b70971000b04c5d401c96ae08ce371086135e999d5e1e1413039c0213076`,
  licence `design-concepts/fonts/jost/OFL.txt`.

How they were made: Typst 0.15.1 compiled the letters to SVG; the glyph
outlines were lifted from that SVG, flattened to absolute coordinates and
kept as TrueType quadratic curves. The threads are hand-set cubic Béziers
(the bold ribbon is refitted from its offset curves). Previews were
rasterised from the SVG files with PyMuPDF at each target pixel width (not
downscaled from a large render) and assembled with Pillow; the reversed
files were previewed on `#1E1E1E`.

History: v1 (commit 473c83f) was a 3D mock-up with brushed metal and a
"gen" at the end of the wire; v2 (never committed) used a thick straight
bar that read as a crossed-out CV and was dropped.

Still needed before wide use (card `brand-logo` on the Trello board):

1. A flat vector redraw (SVG), transparent background. Drafted as options
   2026-09-27, owner to pick (`cvgen-mark.svg`, `cvgen-mark-bold.svg`).
2. The full wordmark: "gen" set small at the thread's right-hand tail, as in v1.
   Drafted as options 2026-09-27, owner to pick (`cvgen-wordmark.svg`).
3. A small-size variant (favicon, chat avatar) with a thicker thread; at
   32 px the current thread disappears. Drafted as options 2026-09-27, owner
   to pick (`cvgen-mark-small.svg`).
4. Colour values for the ink and the copper thread, recorded here. Drafted as
   options 2026-09-27, owner to pick (table above).
