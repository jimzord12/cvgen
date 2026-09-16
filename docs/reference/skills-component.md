# Skills component

Read this when adding a professional skills block to a custom composition.
It is exported from `packages/cv-engine/lib.typ` and is not part of the locked `flagship`
template.

```typst
// From examples/flagship/ or private/<folder>/ (both two levels below the root).
#import "../../packages/cv-engine/lib.typ": skills-section, skills-layout
#import "../../packages/cv-engine/templates/flagship/themes/golden-blue.typ": theme

#skills-section(
  (("Navigation", "GMDSS"), ("Cargo handling", "Safety")),
  theme,
  title: "Professional Skills",
  bullet: (source: "/packages/cv-engine/templates/flagship/assets/captain/compass-bullet.svg"),
  geometry: (..skills-layout, column-gap: 8mm),
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
- `skills-layout` exposes `heading-gap`, `rule-weight`, `content-gap`,
  `column-gap`, `bullet-size`, `body-indent`, `item-gap`.

`tests/fixtures/skills.typ` covers titles, one to three columns, wrapping,
both themes and both bullet kinds.
