// The page shell every template shares (ADR 0008 shape: ctx, data, props, slots).
// Reads ctx.layout's paper, width and height and its own slices (shell, header,
// footer), the artwork slots background-first and background-continuation, and
// ctx.copy.brand; names no field. `ctx.layout.shell` is the template's say in the
// shell: `margin`, the margin the document opens with, and `band`, the height of an
// optional full-width band in the theme's `hero` colour behind the top of page 1.
#import "primitives.typ": label, rule, decoration

// `data` is (name:, headline:); `headline` is whatever the domain puts under the
// name: a rank at sea, a title elsewhere. Geometry from ctx.layout.header.
#let page-header(ctx, data, caption: none) = {
  let (theme, geometry) = (ctx.theme, ctx.layout.header)
  [
    #grid(columns: (1fr, auto), align: horizon,
      stack(spacing: geometry.gap, text(font: theme.fonts.display, size: theme.sizes.page-name)[#data.name], label(ctx, data.headline, color: theme.colors.accent)),
      text(size: theme.sizes.page-caption, fill: theme.colors.muted)[#caption])
    #v(geometry.rule-gap)
    #rule(ctx, weight: 1pt)
  ]
}

// Geometry from ctx.layout.footer.
#let page-footer(ctx, disclosure, brand: none) = {
  let (theme, geometry) = (ctx.theme, ctx.layout.footer)
  context [
    #rule(ctx)
    #v(geometry.gap)#text(size: theme.sizes.footer, fill: theme.colors.muted)[#disclosure #h(1fr) #brand #h(geometry.page-gap) #counter(page).display("01")]
  ]
}

#let page-background(ctx) = context {
  let (theme, artwork, layout) = (ctx.theme, ctx.artwork, ctx.layout)
  let first = counter(page).get().first() == 1
  let band = layout.at("shell", default: (:)).at("band", default: none)
  place(top + left, decoration(ctx, if first {artwork.background-first} else {artwork.background-continuation}, width: layout.width, height: layout.height))
  if first and band != none {place(top, rect(width: 100%, height: band, fill: theme.colors.hero, stroke: none))}
}

// `data` needs `disclosure` (the footer text); the brand comes from ctx.copy.brand.
// PDF metadata comes from the template (title) and the domain (author); the core names no field.
#let document-shell(ctx, data, title: none, author: none, body) = {
  let (theme, layout) = (ctx.theme, ctx.layout)
  assert("margin" in layout.at("shell", default: (:)),
    message: "document-shell needs ctx.layout.shell.margin, the margin the document opens with: add shell: (margin: ..., band: ...) to the layout profile")
  set document(title: title) if title != none
  set document(author: author) if author != none
  set text(font: theme.fonts.body, size: theme.sizes.body, fill: theme.colors.ink, lang: "en")
  set par(leading: theme.leading.initial)
  // Default white is the PDF canvas; an explicit white fill changes edge compositing.
  set page(paper: layout.paper, fill: if theme.colors.paper == white {none} else {theme.colors.paper}, margin: layout.shell.margin,
    footer: page-footer(ctx, data.disclosure, brand: ctx.copy.brand),
    background: page-background(ctx))
  body
}
