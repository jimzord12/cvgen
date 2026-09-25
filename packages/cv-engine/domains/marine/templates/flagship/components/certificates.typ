// Certificate register for Flagship (ADR 0008 shape: ctx, data, props).
#import "sections.typ": section-heading

// `records` are normalised certificates (title, scope, issued, review); column
// headings from ctx.copy.certificate-columns, geometry from ctx.layout.certificates.
#let certificate-table(ctx, records) = {
  let (theme, geometry) = (ctx.theme, ctx.layout.certificates)
  set table(inset: geometry.inset, stroke: (left: none, right: none, top: none, bottom: 0.4pt + theme.colors.rule))
  text(size: theme.sizes.certificate)[
    #table(columns: geometry.columns,
      fill: (x, y) => if y == 0 {theme.colors.hero} else if calc.odd(y) {theme.colors.surface} else {theme.colors.paper},
      table.header(..ctx.copy.certificate-columns.map(t => text(fill: theme.colors.on-hero, weight: "bold")[#t])),
      ..records.map(r => (r.title, r.scope, r.issued, r.review)).flatten())
  ]
}

#let certificates-section(ctx, records) = {
  let copy = ctx.copy
  section-heading(ctx, copy.certificates, number: "02", spacing: ctx.layout.headings.certificates, subtitle: copy.certificates-subtitle)
  certificate-table(ctx, records)
}
