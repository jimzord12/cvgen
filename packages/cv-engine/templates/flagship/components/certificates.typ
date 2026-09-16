#import "sections.typ": section-heading

#let certificate-table(records, headings, theme, geometry) = {
  set table(inset: geometry.inset, stroke: (left: none, right: none, top: none, bottom: 0.4pt + theme.colors.rule))
  text(size: theme.sizes.certificate)[
    #table(columns: geometry.columns,
      fill: (x, y) => if y == 0 {theme.colors.hero} else if calc.odd(y) {theme.colors.surface} else {theme.colors.paper},
      table.header(..headings.map(t => text(fill: theme.colors.on-hero, weight: "bold")[#t])),
      ..records.map(r => (r.title, r.scope, r.issued, r.review)).flatten())
  ]
}

#let certificates-section(records, copy, theme, layout) = {
  section-heading("02", copy.certificates, theme, layout.headings, layout.headings.certificates, subtitle: copy.certificates-subtitle)
  certificate-table(records, copy.certificate-columns, theme, layout.certificates)
}
