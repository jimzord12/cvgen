# Skills component

Read this when adding a professional skills block to a custom composition.
It lives in the Flagship template's `components/skills.typ` and is not part
of the locked `flagship` template. Like every component it takes `ctx`
first (ADR 0008).

```typst
// Root-absolute paths work from any entry point compiled with --root .
#import "/packages/cv-engine/core/component.typ": make-ctx
#import "/packages/cv-engine/domains/marine/templates/flagship/components/skills.typ": skills-section, skills-layout
#import "/packages/cv-engine/domains/marine/templates/flagship/themes/golden-blue.typ": theme

#let ctx = make-ctx(theme: theme, layout: (skills: (..skills-layout, column-gap: 8mm)))
#skills-section(ctx,
  (("Navigation", "GMDSS"), ("Cargo handling", "Safety")),
  title: "Professional Skills",
  bullet: (source: "/packages/cv-engine/domains/marine/assets/captain/compass-bullet.svg"),
)
```

- Each inner array is one column, read top to bottom, then the next column.
  One, two or more columns. Items are plain text or Typst content. Groups
  must be non-empty.
- `bullet` takes any artwork descriptor. Omit it for a plain bullet. SVG
  bullets are PDF artifacts; the text is a normal list.
- The title uses `theme.sizes.section-title`. Body text uses
  `theme.sizes.skill` with a default of 10pt.
- The section is unbreakable. The parent owns placement and outer spacing.
  For long lists, split into several sections.
- Geometry comes from `ctx.layout.skills`, or `skills-layout` when the layout
  has no `skills` slice. `skills-layout` exposes `heading-gap`,
  `rule-weight`, `content-gap`, `column-gap`, `bullet-size`, `body-indent`,
  `item-gap`.
- Older compositions call `lib.typ`'s `skills-section(groups, theme, title:,
  bullet:, geometry:)`; that deprecated wrapper draws the same pixels.

`tests/fixtures/skills.typ` covers titles, one to three columns, wrapping,
both themes and both bullet kinds through the `lib.typ` wrapper;
`tests/fixtures/contract.typ` renders the ctx-first component alone.
