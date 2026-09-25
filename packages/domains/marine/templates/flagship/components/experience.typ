// Service history for Flagship (ADR 0008 shape: ctx, data, props). Geometry from
// ctx.layout.experience; `spacing` is the parent's page variant (experience.opening
// or experience.continuation); ctx.options.show-vessel-durations hides row times.
#import "../../../data.typ": company-months
#import "../../../../../cv-framework/core/primitives.typ": label, duration

#let show-durations(ctx) = ctx.options.at("show-vessel-durations", default: true)

// `data` is (period: display text, months: whole service months); caption from ctx.copy.combined.
#let company-period(ctx, data) = {
  let (theme, geometry, months) = (ctx.theme, ctx.layout.experience, data.months)
  stack(spacing: geometry.period-gap,
    label(ctx, data.period),
    block[
      #set par(leading: theme.leading.duration)
      #text(font: theme.fonts.display, size: theme.sizes.duration, fill: theme.colors.accent)[#if months >= 12 and calc.rem(months, 12) > 0 {
        [#duration(months - calc.rem(months, 12)) \ #duration(calc.rem(months, 12))]
      } else {duration(months)}]
    ],
    text(size: theme.sizes.label, fill: theme.colors.muted)[#ctx.copy.combined])
}

// Returns cells, not a separate grid: all rows share the parent's column tracks.
#let vessel-row(ctx, vessel) = {
  let (theme, geometry) = (ctx.theme, ctx.layout.experience)
  let time = if vessel.at("months", default: none) != none {
    text(size: theme.sizes.rank-row, fill: theme.colors.accent)[#duration(vessel.months)]
  } else {[]}
  let last = if show-durations(ctx) {time} else {context {
    // Preserve the row's geometry without emitting hidden duration text into the PDF.
    let bounds = measure(time, width: geometry.duration-width)
    box(width: bounds.width, height: bounds.height)
  }}
  (text(size: theme.sizes.vessel, weight: "semibold")[#vessel.name],
    text(size: theme.sizes.rank-row, fill: theme.colors.muted)[#vessel.rank], last)
}

#let vessel-type-group(ctx, group, spacing: none) = {
  assert(spacing != none, message: "vessel-type-group needs spacing: (layout.experience.opening or .continuation)")
  let (theme, geometry) = (ctx.theme, ctx.layout.experience)
  [
    #v(geometry.group-gap)
    #label(ctx, group.type, color: theme.colors.accent)
    #v(geometry.group-gap)
    #grid(columns: (1fr, geometry.rank-width, geometry.duration-width), column-gutter: geometry.cell-gap,
      row-gutter: spacing.row-gap, align: (left, left, right),
      ..group.ships.map(s => vessel-row(ctx, s)).flatten())
  ]
}

#let company-experience(ctx, company, spacing: none, continued: false) = {
  assert(spacing != none, message: "company-experience needs spacing: (layout.experience.opening or .continuation)")
  let (theme, geometry) = (ctx.theme, ctx.layout.experience)
  block(breakable: false, above: 0pt, below: spacing.company-gap)[
    #grid(columns: (geometry.date-width, 1fr), column-gutter: geometry.column-gap,
      company-period(ctx, (period: company.period, months: if "display-months" in company {company.display-months} else {company-months(company)})),
      block(stroke: (left: 2pt + theme.colors.accent), inset: geometry.inset)[
        #text(size: theme.sizes.company, weight: "bold")[#company.name#if continued { [ (continued)] }]
        #for group in company.groups {vessel-type-group(ctx, group, spacing: spacing)}
      ])
  ]
}

#let experience-section(ctx, companies, spacing: none) = {
  for company in companies {
    company-experience(ctx, company, spacing: spacing, continued: company.at("continued", default: false))
  }
}
