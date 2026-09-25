// Section chrome for Flagship (ADR 0008 shape: ctx, data, props, slots).
#import "../../../../../core/primitives.typ": decoration, metric, duration-value

// Pure chrome: the title is the child. Geometry from ctx.layout.headings; `spacing`
// is the parent's choice for this heading (a layout.headings entry such as `opening`).
#let section-heading(ctx, title, number: none, spacing: none, subtitle: none) = {
  // `number: none` leaves the number cell empty, as it always has.
  assert(spacing != none,
    message: "section-heading needs spacing: (a layout.headings entry, e.g. layout.headings.opening)")
  let (theme, geometry) = (ctx.theme, ctx.layout.headings)
  block(above: spacing.above, below: spacing.below)[
    #grid(columns: (geometry.number-width, 1fr), align: horizon,
      text(font: theme.fonts.display, size: theme.sizes.section-number, fill: theme.colors.metal)[#number],
      stack(spacing: geometry.gap, text(size: theme.sizes.section-title, weight: "bold")[#title],
        if subtitle != none {text(size: theme.sizes.subtitle, fill: theme.colors.muted)[#subtitle]}))
  ]
}

// The candidate's profile text beside the artwork pack's profile illustration (if any).
#let profile-summary(ctx, body) = {
  let geometry = ctx.layout.profile
  grid(columns: (1fr, geometry.image-width), column-gutter: geometry.gap, align: horizon,
    [#body], [#decoration(ctx, ctx.artwork.at("profile-illustration", default: none), width: geometry.image-width)])
}

// `totals` is the domain's (months, vessels, companies); captions come from ctx.copy.
#let synopsis(ctx, totals) = {
  let (theme, geometry, copy) = (ctx.theme, ctx.layout.synopsis, ctx.copy)
  block(fill: theme.colors.hero, width: 100%, inset: geometry.inset)[
    #set text(fill: theme.colors.on-hero)
    #grid(columns: geometry.columns, column-gutter: geometry.column-gap,
      metric(ctx, duration-value(ctx, totals.months), caption: copy.total, gap: geometry.gap),
      metric(ctx, totals.vessels, caption: copy.vessels, gap: geometry.gap),
      metric(ctx, totals.companies, caption: copy.companies, gap: geometry.gap))
  ]
}
