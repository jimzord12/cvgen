#import "../../../../../core/data.typ": company-months
#import "../../../../../core/primitives.typ": label, duration

#let company-period(period, months, caption, theme, geometry) = stack(spacing: geometry.period-gap,
  label(period, theme),
  block[
    #set par(leading: theme.leading.duration)
    #text(font: theme.fonts.display, size: theme.sizes.duration, fill: theme.colors.accent)[#if months >= 12 and calc.rem(months, 12) > 0 {
      [#duration(months - calc.rem(months, 12)) \ #duration(calc.rem(months, 12))]
    } else {duration(months)}]
  ],
  text(size: theme.sizes.label, fill: theme.colors.muted)[#caption])

// Returns cells, not a separate grid: all rows share the parent's column tracks.
#let vessel-row(vessel, show-durations, theme, geometry) = {
  let time = if vessel.at("months", default: none) != none {
    text(size: theme.sizes.rank-row, fill: theme.colors.accent)[#duration(vessel.months)]
  } else {[]}
  let last = if show-durations {time} else {context {
    // Preserve the row's geometry without emitting hidden duration text into the PDF.
    let bounds = measure(time, width: geometry.duration-width)
    box(width: bounds.width, height: bounds.height)
  }}
  (text(size: theme.sizes.vessel, weight: "semibold")[#vessel.name],
    text(size: theme.sizes.rank-row, fill: theme.colors.muted)[#vessel.rank], last)
}

#let vessel-type-group(group, show-durations, theme, geometry, spacing) = [
  #v(geometry.group-gap)
  #label(group.type, theme, color: theme.colors.accent)
  #v(geometry.group-gap)
  #grid(columns: (1fr, geometry.rank-width, geometry.duration-width), column-gutter: geometry.cell-gap,
    row-gutter: spacing.row-gap, align: (left, left, right),
    ..group.ships.map(s => vessel-row(s, show-durations, theme, geometry)).flatten())
]

#let company-experience(company, theme, geometry, spacing, show-durations, caption, continued: false) = block(breakable: false, above: 0pt, below: spacing.company-gap)[
  #grid(columns: (geometry.date-width, 1fr), column-gutter: geometry.column-gap,
    company-period(company.period, if "display-months" in company {company.display-months} else {company-months(company)}, caption, theme, geometry),
    block(stroke: (left: 2pt + theme.colors.accent), inset: geometry.inset)[
      #text(size: theme.sizes.company, weight: "bold")[#company.name#if continued { [ (continued)] }]
      #for group in company.groups {vessel-type-group(group, show-durations, theme, geometry, spacing)}
    ])
]

#let experience-section(companies, theme, geometry, spacing, show-durations, caption) = {
  for company in companies {
    company-experience(company, theme, geometry, spacing, show-durations, caption,
      continued: company.at("continued", default: false))
  }
}
