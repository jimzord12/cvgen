# brand

CVgen's own brand assets, not client or template material.

## logos/

**The working logo (owner's pick, 2026-09-28): the needle's eye.** Use
these files:

| File | Use |
|---|---|
| `cvgen-mark-c-eye.svg` | The mark: "CV" with the copper thread through a needle's eye in the C |
| `cvgen-wordmark.svg` | The mark plus "gen" at the thread's tail (now with the eye) |
| `cvgen-mark-c-eye-reversed.svg` | The mark on dark backgrounds |
| `cvgen-mark-small.svg`, `cvgen-avatar.svg` (and their `-reversed`) | Favicon and chat avatar: plain C, because the eye closes up at small sizes |

Everything else in this folder is history: the options that were not
picked, kept as they are.

- `CVgen_Logo.v3.jpg`: the earlier working mark, kept by the owner on
  2026-09-25. A big black serif "CV" on white, flat, with one thin copper
  thread that wraps the C and curves through the V, ending in a loose tail
  on the right. Image-model render, 2048x2048 JPEG: the source of the
  vector redraw.

Owner's direction (2026-09-28): keep the faithful redraw and give the C
alone one custom detail, tied to the thread, so the letters are not stock
type. Two options were drafted the same night, and the owner picked the
eye. Each is `cvgen-mark.svg` with the C changed and the V untouched:

- `cvgen-mark-c-eye.svg` (the design reviewer's recommendation): a
  needle's eye cut along the axis of the C's stem, and the copper thread
  passes through it (out of the eye, under the stem to the counter), so
  the C becomes the needle. The thread keeps its path; only its layering
  at the eye changes.
- `cvgen-mark-c-stitch.svg`: five stitch holes along the outer edge of the
  C's stem, each turned to the curve, starting below the thread. It echoes
  the copper running stitch of the `Text Draft` house design (First
  Fitting, 2026-09-28), but the holes are white, not copper, and white
  dashes on a dark shape are also a stock stitched-patch look. Thread
  unchanged.

The holes are real holes (even-odd subpaths of the C), so they stay
transparent on any background and render the same under both fill rules.
From 64 px down both details fade (the eye can pass for a highlight). The
chosen eye went into the wordmark and a new reversed mark,
`cvgen-mark-c-eye-reversed.svg` (`cvgen-mark-reversed.svg` keeps the plain
C as history), on 2026-09-28; the small mark and
the avatar keep the plain C, because their emboldened letters and thick
thread close the eye and the holes (tried by the reviewer), unless a
detail is redrawn for them. Tried and dropped during the drafting (renders
not kept): a knot on the lower terminal (read as a full stop, "C.V"); and,
reviewed, a needle point drawn out of the lower terminal (read as a thorn
attached to the letter, heavier than the thread). Review reports:
`docs/work/brand-logo/reviews/02-design-reviewer.md` onwards.

Vector options drafted 2026-09-27 (then options for the owner to pick, not a
final logo). Hand-authored SVG: letters are outline paths, no `<text>`, no
embedded raster, transparent background, tight `viewBox` (except the
avatar cuts, which are padded on purpose):

- `cvgen-mark.svg`: faithful flat redraw of v3. The thread keeps v3's own
  over/under: over the C stem and the V's left stroke, under the V's right
  stroke, its start tucked into the C's bowl.
- `cvgen-wordmark.svg` (eye C since 2026-09-28): the mark plus "gen" in Jost Light, set small in the
  thread's copper at the thread's right-hand tail (the thread "writes" gen;
  gen's stroke weight matches the thread).
- `cvgen-mark-small.svg`: favicon variant, tight square canvas. Thread
  about five times thicker, letters emboldened with an ink outline so the
  hairlines survive, the left loop dropped (the thread enters from the
  left), shorter tail. 32 px is the practical minimum: at 16 px the thread
  closes the C's mouth and the mark only just reads.
- `cvgen-avatar.svg`: the small variant with about 12% padding on every
  side (only the `viewBox` differs), for chat avatars and other circular
  crops; the serifs and thread ends stay clear of the rim.
- `cvgen-mark-bold.svg`: alternative, "unafraid of excess". The thread
  becomes a swelling broad-nib ribbon that weaves strictly over and under
  (under the C bowl, over the C stem, under the V's left stroke, over its
  right stroke) and ends in a second loop and a hairline tail.
- `cvgen-mark-reversed.svg`: `cvgen-mark.svg` for dark backgrounds (chat
  avatars, dark-mode tabs): same geometry, reversed ink and copper.
- `cvgen-mark-small-reversed.svg`, `cvgen-avatar-reversed.svg`,
  `cvgen-mark-bold-reversed.svg`: the small variant, the avatar cut and the
  bold alternative for dark backgrounds, same treatment.

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
  height). It ships with the Framework's bundled fonts, but no current
  template uses it (Flagship's themes use Source Sans 3 and Barlow); it
  appears only in the archived design study `03-horizon`.
- "gen": Jost Light (weight 300), `design-concepts/fonts/jost/Jost[wght].ttf`,
  SHA-256 `6343b70971000b04c5d401c96ae08ce371086135e999d5e1e1413039c0213076`,
  licence `design-concepts/fonts/jost/OFL.txt`. Tracked +0.05 em (50 font
  units added between letters).

Outlines are overlap-free. The variable fonts' overlapping contours (the V
below its apex, the g's bowl and stem, the e's bar) and the bold ribbon's
self-crossing second loop were merged into single non-overlapping contours,
so every filled path renders the same under even-odd and nonzero (checked by
rendering each file both ways: zero differing pixels). Filled groups also
carry `fill-rule="nonzero"` explicitly. Two things are intentionally still
layered: the over/under weave is built from separate paths stacked on top of
each other (thread under, letters, thread over), and the threads of the
mark, wordmark and small variant are strokes, not filled outlines. A vinyl
cutter or embroidery file needs those flattened (stroke to outline, then
union of the layers) in a vector editor first.

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

Status (2026-09-28, task `brand-logo`, now in `backlog/tasks/`):

1. Vector redraw: settled. The owner kept the faithful redraw with a custom
   C and picked the needle's eye (`cvgen-mark-c-eye.svg`); the bold
   alternative was not picked.
2. Wordmark, small variant, avatar and colours: in use as drafted on
   2026-09-27 (`cvgen-wordmark.svg`, now with the eye; `cvgen-mark-small.svg`;
   `cvgen-avatar.svg`; the reversed files, where the eye shape is settled
   and the reversed colours are as drafted; the colour table above). The
   owner has not reviewed them one by one; he picked only the mark.
3. Still open, for when the logo is used widely: a dark-background
   wordmark; a one-colour version; threads flattened to outlines for
   cutting or embroidery; a dedicated 16 px cut.

## forms/

`intake-header.png` (1600 x 400 px, Google Forms' header size): the
`Intake Form` header, house design First Fitting (warm paper, the
wordmark, one copper running stitch). No words beyond the wordmark,
because Forms shows the header at phone width. Source
`intake-header.typ`; the command is in its first lines. The theme steps
that go with it are in `docs/guides/client-workflow.md`, section 2.

Open brand item (design review, 2026-09-28): the logo files use copper
`#B7713D`, the house design First Fitting and the form theme `#B0602B`.
The header recolours the wordmark to `#B0602B` when it reads it; the logo
files are unchanged until the owner picks one copper.
