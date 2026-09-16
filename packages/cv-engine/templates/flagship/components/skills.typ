#import "../../../core/primitives.typ": decoration

// The parent controls placement on the page; groups define explicit column order.
#let skills-layout = (heading-gap: 5mm, rule-weight: 0.7pt, content-gap: 4mm,
  column-gap: 8mm, bullet-size: 3mm, body-indent: 5mm, item-gap: 2.5mm)

#let skills-heading(title, theme, geometry: skills-layout) = grid(
  columns: (auto, 1fr), column-gutter: geometry.heading-gap, align: horizon,
  text(size: theme.sizes.section-title, weight: "bold", fill: theme.colors.ink)[#title],
  line(length: 100%, stroke: geometry.rule-weight + theme.colors.metal))

#let skill-list(items, theme, bullet: none, geometry: skills-layout) = {
  set text(size: theme.sizes.at("skill", default: 10pt))
  set list(marker: if bullet == none {[•]} else {decoration(bullet, theme, width: geometry.bullet-size)},
    indent: 0pt, body-indent: geometry.body-indent, spacing: geometry.item-gap, tight: false)
  list(..items)
}

#let skills-section(groups, theme, title: "Professional Skills", bullet: none, geometry: skills-layout) = {
  assert(groups.len() > 0 and groups.all(g => g.len() > 0), message: "Skills require non-empty column groups")
  block(breakable: false, width: 100%)[
    #skills-heading(title, theme, geometry: geometry)
    #v(geometry.content-gap)
    #grid(columns: groups.map(_ => 1fr), column-gutter: geometry.column-gap,
      ..groups.map(items => [#skill-list(items, theme, bullet: bullet, geometry: geometry)]))
  ]
}
