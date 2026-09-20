# Theme

Read this when creating or editing a file under `packages/cv-engine/domains/marine/templates/flagship/themes/`. A theme is visual
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
| `colors.hero` | yes | Hero band, synopsis background, certificate header |
| `colors.accent` | yes | Rank, company rule, group labels, durations |
| `colors.metal` | yes | Section numbers, contact labels, rules, metric captions |
| `colors.muted` | yes | Secondary text |
| `colors.surface` | yes | Alternate table rows, language cards |
| `colors.paper` | yes | Page fill. `white` means the PDF's unpainted canvas |
| `colors.plate` | yes | Identity plate background |
| `colors.rule` | yes | Table row rules |
| `colors.on-hero` | yes | Text on hero-coloured areas |
| `fonts.body`, `fonts.display` | yes | One of the three bundled family strings: `Source Sans 3`, `Barlow`, `Cormorant Garamond`. The Barlow Condensed file registers as `Barlow`. Confirm with `typst fonts --font-path packages/cv-engine/fonts`; an unknown name prints `warning: unknown font family` and substitutes |
| `sizes.*` | yes | One entry per text role. See `golden-blue.typ` for the full list. `skill` is optional and defaults to 10pt |
| `tracking.label`, `tracking.rank` | yes | Letter spacing for uppercase labels and the rank line |
| `leading.initial`, `leading.body`, `leading.duration` | yes | Line spacing before the body, in the body, and inside the two-line company duration |
| `art-colors` | no | Map of hex strings found in legacy SVGs to theme colours |

`validate-theme` in `packages/cv-engine/core/theme.typ` checks the colour and font keys exist and
have the right type. Missing sizes fail at the point of use.

## How SVG recolouring works

`decoration` in `packages/cv-engine/core/primitives.typ` reads the SVG source and replaces the
four Golden Blue hex values (`#102f3a`, `#236a70`, `#c8a579`, `#546870`) and
the placeholders `{{ink}}`, `{{accent}}`, `{{metal}}` with the theme's
colours, then applies `art-colors` for any other hex the SVG uses. New SVGs
should use the placeholders. Old SVGs need their extra colours listed in
`art-colors` or they keep their original hue.

## Checks

- `python tests/run.py` compiles the silver captain and checks its page text
  equals the classic captain's. A new theme should be added to
  `tests/fixtures/skills.typ` or a similar fixture if it introduces new
  colour keys.
- Paper colours other than white paint the page and change edge compositing.
  This is fine for a new theme but will never match v11.
