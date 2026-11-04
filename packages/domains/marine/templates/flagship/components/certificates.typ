// Certificate register for Flagship (ADR 0008 shape: ctx, data, props).
#import "sections.typ": section-heading

// `records` are normalised certificates (title, scope, issued, review). With no `review` on
// any record the table has three columns: the data decides, and the first three headings of
// ctx.copy.certificate-columns and geometry.columns-three apply.
#let certificate-table(ctx, records) = {
  let (theme, geometry) = (ctx.theme, ctx.layout.certificates)
  let reviewed = records.filter(r => "review" in r)
  assert(reviewed.len() in (0, records.len()), message: "Every certificate needs a review date, or none does")
  let fields = if reviewed.len() > 0 {("title", "scope", "issued", "review")} else {("title", "scope", "issued")}
  set table(inset: geometry.inset, stroke: (left: none, right: none, top: none, bottom: 0.4pt + theme.colors.rule))
  text(size: theme.sizes.certificate)[
    #table(columns: if fields.len() == 4 {geometry.columns} else {geometry.columns-three},
      fill: (x, y) => if y == 0 {theme.colors.hero} else if calc.odd(y) {theme.colors.surface} else {theme.colors.paper},
      table.header(..ctx.copy.certificate-columns.slice(0, fields.len()).map(t => text(fill: theme.colors.on-hero, weight: "bold")[#t])),
      ..records.map(r => fields.map(key => r.at(key))).flatten())
  ]
}

#let certificates-section(ctx, records) = {
  let copy = ctx.copy
  section-heading(ctx, copy.certificates, number: "02", spacing: ctx.layout.headings.certificates, subtitle: copy.certificates-subtitle)
  certificate-table(ctx, records)
}
