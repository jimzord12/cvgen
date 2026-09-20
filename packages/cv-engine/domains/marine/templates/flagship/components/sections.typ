#import "../../../../../core/primitives.typ": decoration, metric, duration-value

#let section-heading(number, title, theme, geometry, spacing, subtitle: none) = block(above: spacing.above, below: spacing.below)[
  #grid(columns: (geometry.number-width, 1fr), align: horizon,
    text(font: theme.fonts.display, size: theme.sizes.section-number, fill: theme.colors.metal)[#number],
    stack(spacing: geometry.gap, text(size: theme.sizes.section-title, weight: "bold")[#title],
      if subtitle != none {text(size: theme.sizes.subtitle, fill: theme.colors.muted)[#subtitle]}))
]

#let profile-summary(body, illustration, theme, geometry) = grid(columns: (1fr, geometry.image-width), column-gutter: geometry.gap, align: horizon,
  [#body], [#decoration(illustration, theme, width: geometry.image-width)])

#let synopsis(totals, captions, theme, geometry) = block(fill: theme.colors.hero, width: 100%, inset: geometry.inset)[
  #set text(fill: theme.colors.on-hero)
  #grid(columns: geometry.columns, column-gutter: geometry.column-gap,
    metric(duration-value(totals.months, theme), captions.total, theme, gap: geometry.gap),
    metric(totals.vessels, captions.vessels, theme, gap: geometry.gap),
    metric(totals.companies, captions.companies, theme, gap: geometry.gap))
]
