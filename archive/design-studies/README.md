# Design studies

Evaluated, self-contained Typst designs kept as worked examples of the visual
language. They are **not** the active library. Each file is a single
composition that reads its own data and draws its own page. Use them to
understand a direction before building a theme or artwork pack in the library,
or to compare a library render against an approved look.

| Study | Direction | Status | Render |
|---|---|---|---|
| `01-soundings.typ` | Deep petrol sidebar, compass geometry, condensed name | Reviewed one-page study | [PDF](review/01-soundings.pdf) · [PNG](review/01-soundings.png) |
| `02-engine-room.typ` | Graphite masthead, copper accents, shaft-line drawing, numbered sections | Reviewed one-page study | [PDF](review/02-engine-room.pdf) · [PNG](review/02-engine-room.png) |
| `03-horizon.typ` | Editorial serif name, teal detailing, hull-line drawing | Reviewed one-page study | [PDF](review/03-horizon.pdf) · [PNG](review/03-horizon.png) |
| `11-flagship-balance.typ` | Two-page portrait hero, company / vessel-type / vessel experience | **Approved and frozen.** The library reproduces it exactly | [PDF](../reference/Marine-Engineer-CV-v11.pdf) · [p1](review/Marine-Engineer-CV-v11-page-1.png) · [p2](review/Marine-Engineer-CV-v11-page-2.png) |

`review/comparison.png` shows the three one-page studies side by side.

## Rules

- These files are frozen. Do not edit them to experiment; copy the idea into a
  theme, artwork pack or layout under the library instead.
- `11-flagship-balance.typ` is the source of the frozen reference PDF in
  `reference/`. The regression suite proves `examples/engineer.typ` renders
  pixel-identical to that PDF. If you ever recompile this file, the result must
  still match.
- Intermediate flagship iterations 04 to 10 were removed. They live under the
  git tag `archive/pre-restructure` if you need to see how a decision evolved.

## Data and assets

- `content/example.json` feeds the three one-page studies through `shared.typ`.
- `content/extended-company-example.json` feeds `11-flagship-balance.typ`. It
  is the older flat schema; the active library uses the nested schema in
  `../content/`.
- Artwork comes from `../assets/`. The Horizon study is the only user of the
  Cormorant Garamond font.

## Compile one

```powershell
typst compile --root . --font-path fonts designs/03-horizon.typ builds/horizon-local.pdf
```

Always write to a new file under `builds/`. Never overwrite the review renders.
