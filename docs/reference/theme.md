# Theme

Read this when creating or editing a file under `packages/domains/marine/templates/flagship/themes/`. A theme is visual
tokens only. Geometry belongs to the layout, pictures to the artwork pack.

Copy `golden-blue.typ` in that folder to start. `silver-bridge.typ` shows the
minimal override pattern: spread the base theme, replace what differs.

```typst
#import "golden-blue.typ": theme as base
#let theme = (
  ..base,
  name: "My Theme",
  colors: (ink: rgb("202830"), hero: rgb("202830"), accent: rgb("425565"),
    metal: rgb("b8c2cc"), muted: rgb("596570"), surface: rgb("f0f3f5"),
    paper: white, plate: white, rule: rgb("d6dde2"), on-hero: white),
  fonts: (body: "Source Sans 3", display: "Source Sans 3"),
  sizes: (..base.sizes, name: 28pt),
)
```

## Keys

| Key | Required | Used for |
|---|---|---|
| `name` | no | Display name, useful in reports |
| `colors.ink` | yes | Body text |
| `colors.hero` | yes (Flagship) | Hero band, synopsis background, certificate header |
| `colors.accent` | yes | Rank, company rule, group labels, durations |
| `colors.metal` | yes | Section numbers, contact labels, rules, metric captions |
| `colors.muted` | yes | Secondary text |
| `colors.surface` | yes (Flagship) | Alternate table rows, language cards |
| `colors.paper` | yes | Page fill. `white` means the PDF's unpainted canvas |
| `colors.plate` | yes (Flagship) | Identity plate background |
| `colors.rule` | yes (Flagship) | Table row rules |
| `colors.on-hero` | yes (Flagship) | Text on hero-coloured areas |
| `fonts.body`, `fonts.display` | yes | One of the bundled family strings: `Source Sans 3`, `Barlow`, `Cormorant Garamond`, `Bona Nova` (bundled for the `Text Draft`; a theme may use it), `Sofia Sans` (the Sofia Sans Extra Condensed file), `M PLUS 1p` and `Kaisei Tokumin` (Japanese glyphs; bundled for the Hanami Line travel design). The Barlow Condensed file registers as `Barlow`. Confirm with `typst fonts --ignore-system-fonts --font-path packages/cv-framework/fonts`. An unknown name makes Typst substitute another font with only `warning: unknown font family`; the suite, `scripts/cv.py render` and `scripts/build.ps1` compile with `--ignore-system-fonts` and fail on that warning |
| `sizes.*` | yes | One entry per text role. See `golden-blue.typ` for the full list. `skill` is optional and defaults to 10pt |
| `tracking.label`, `tracking.rank` | yes | Letter spacing for uppercase labels and the rank line |
| `leading.initial`, `leading.body`, `leading.duration` | yes | Line spacing before the body, in the body, and inside the two-line company duration |
| `art-palette` | no | Map of the hex colours baked into the domain's SVGs to the names of the theme colours that replace them. Flagship's themes carry marine's `domain.art-palette` (`golden-blue.typ`); a theme spread from them keeps it |
| `art-colors` | no | Map of hex strings found in legacy SVGs to theme colours |

Two checks run when `flagship` starts, with the same messages (`Missing theme color: <key>`,
`Theme color must be a color: <key>`). `validate-theme` in `packages/cv-framework/core/theme.typ`
checks what every template needs: `ink`, `accent`, `metal`, `muted`, `paper` and the two fonts.
`validate-flagship-theme` in `flagship.typ` adds the colours marked "yes (Flagship)" above, through
the core's `require-colors`; a second template names its own the same way. The core's page shell
paints its optional first-page band (`shell.band`) in `hero`, so a template that asks for a band
must supply `hero` and require it in its own check. Missing sizes fail at
the point of use. Neither check can tell that a font family
exists, since Typst gives a document no way to ask; the compile runners above do that.

## How SVG recolouring works

`decoration` in `packages/cv-framework/core/primitives.typ` reads the SVG
source and replaces, in this order: each hex in the theme's `art-palette`
with the theme colour it names (for marine, the four original art colours
`#102f3a`, `#236a70`, `#c8a579`, `#546870` become `ink`, `accent`, `metal`,
`muted`; the domain owns that list in `domain.typ`, the Framework names no
colour), then every placeholder `{{<colour>}}` with that theme colour
(`{{ink}}`, `{{accent}}`, `{{metal}}`, any key of `colors`), then
`art-colors` for any other hex the SVG uses. New SVGs should use the
placeholders. Old SVGs need their extra colours listed in `art-colors` or
they keep their original hue; a theme built from scratch rather than spread
from a Flagship theme must also set `art-palette`, or the marine art keeps
its original navy, teal and brass.

## Checks

- `python tests/run.py` compiles the silver captain and checks its page text
  equals the classic captain's. A new theme should be added to
  `tests/fixtures/skills.typ` or a similar fixture if it introduces new
  colour keys.
- Paper colours other than white paint the page and change edge compositing.
  This is fine for a new theme but will never match v11.
