#import "primitives.typ": label, rule, decoration

#let page-header(identity, caption, theme, geometry) = [
  #grid(columns: (1fr, auto), align: horizon,
    stack(spacing: geometry.gap, text(font: theme.fonts.display, size: theme.sizes.page-name)[#identity.name], label(identity.rank, theme, color: theme.colors.accent)),
    text(size: theme.sizes.page-caption, fill: theme.colors.muted)[#caption])
  #v(geometry.rule-gap)
  #rule(theme, weight: 1pt)
]

#let page-footer(disclosure, brand, theme, geometry) = context [
  #rule(theme)
  #v(geometry.gap)#text(size: theme.sizes.footer, fill: theme.colors.muted)[#disclosure #h(1fr) #brand #h(geometry.page-gap) #counter(page).display("01")]
]

#let page-background(theme, artwork, layout) = context {
  let first = counter(page).get().first() == 1
  place(top + left, decoration(if first {artwork.background-first} else {artwork.background-continuation}, theme, width: layout.width, height: layout.height))
  if first {place(top, rect(width: 100%, height: layout.hero.band-height, fill: theme.colors.hero, stroke: none))}
}

#let document-shell(candidate, theme, artwork, layout, body) = {
  set document(title: candidate.identity.name + " | " + candidate.identity.rank + " | Marine CV", author: "Marine CV Studio")
  set text(font: theme.fonts.body, size: theme.sizes.body, fill: theme.colors.ink, lang: "en")
  set par(leading: theme.leading.initial)
  // Default white is the PDF canvas; an explicit white fill changes edge compositing.
  set page(paper: layout.paper, fill: if theme.colors.paper == white {none} else {theme.colors.paper}, margin: layout.opening-margin,
    footer: page-footer(candidate.disclosure, candidate.copy.brand, theme, layout.footer),
    background: page-background(theme, artwork, layout))
  body
}
