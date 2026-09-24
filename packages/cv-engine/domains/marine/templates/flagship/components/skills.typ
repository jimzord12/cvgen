// Optional skills block for custom compositions (ADR 0008 shape: ctx, data, props).
#import "../../../../../core/primitives.typ": decoration

// Geometry used when the layout profile has no `skills` slice. The parent controls
// placement on the page; groups define explicit column order.
#let skills-layout = (heading-gap: 5mm, rule-weight: 0.7pt, content-gap: 4mm,
  column-gap: 8mm, bullet-size: 3mm, body-indent: 5mm, item-gap: 2.5mm)

#let skills-geometry(ctx) = ctx.layout.at("skills", default: skills-layout)

#let skills-heading(ctx, title) = {
  let geometry = skills-geometry(ctx)
  grid(columns: (auto, 1fr), column-gutter: geometry.heading-gap, align: horizon,
    text(size: ctx.theme.sizes.section-title, weight: "bold", fill: ctx.theme.colors.ink)[#title],
    line(length: 100%, stroke: geometry.rule-weight + ctx.theme.colors.metal))
}

// `bullet` is an artwork asset (e.g. artwork.bullet); none gives a plain dot.
#let skill-list(ctx, items, bullet: none) = {
  let geometry = skills-geometry(ctx)
  set text(size: ctx.theme.sizes.at("skill", default: 10pt))
  set list(marker: if bullet == none {[•]} else {decoration(ctx, bullet, width: geometry.bullet-size)},
    indent: 0pt, body-indent: geometry.body-indent, spacing: geometry.item-gap, tight: false)
  list(..items)
}

// `groups` is one array of skills per column, in column order.
#let skills-section(ctx, groups, title: "Professional Skills", bullet: none) = {
  assert(groups.len() > 0 and groups.all(g => g.len() > 0), message: "Skills require non-empty column groups")
  let geometry = skills-geometry(ctx)
  block(breakable: false, width: 100%)[
    #skills-heading(ctx, title)
    #v(geometry.content-gap)
    #grid(columns: groups.map(_ => 1fr), column-gutter: geometry.column-gap,
      ..groups.map(items => [#skill-list(ctx, items, bullet: bullet)]))
  ]
}
