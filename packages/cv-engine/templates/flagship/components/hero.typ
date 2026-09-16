#import "../../../core/primitives.typ": label, decoration

#let portrait(identity, theme, geometry) = block(width: geometry.portrait-size, height: geometry.portrait-size, radius: 50%, clip: true)[
  #if identity.at("portrait", default: none) != none {
    image(identity.portrait, width: geometry.portrait-size, height: geometry.portrait-size, fit: "cover", alt: identity.at("portrait-alt", default: "Candidate portrait"))
  }
]

#let portrait-frame(asset, theme) = decoration(asset, theme)
#let portrait-backdrop(asset, theme) = decoration(asset, theme)

#let contact-item(item, theme) = [#label(item.label, theme, color: theme.colors.metal) \ #if item.at("href", default: none) != none {link(item.href)[#item.value]} else {item.value}]

#let contact-group(items, alignment, theme, geometry) = block(width: geometry.contacts-width)[
  #set align(alignment)
  #set text(fill: theme.colors.on-hero, size: theme.sizes.contact)
  #stack(spacing: geometry.contacts-gap, ..items.map(item => contact-item(item, theme)))
]

#let identity-plate(identity, theme, geometry) = block(width: geometry.plate-width,
  fill: theme.colors.plate, inset: geometry.plate-inset)[
  #align(center)[#stack(spacing: geometry.plate-gap,
    text(font: theme.fonts.display, weight: "semibold", size: theme.sizes.name)[#identity.name],
    text(size: theme.sizes.rank, tracking: theme.tracking.rank, weight: "bold", fill: theme.colors.accent)[#identity.rank])]
]

#let hero(identity, contacts, theme, artwork, geometry) = context {
  let title = text(font: theme.fonts.display, weight: "semibold", size: theme.sizes.name)[#identity.name]
  assert(measure(title).width <= geometry.plate-width - 2 * geometry.plate-inset.x,
    message: "Name exceeds identity plate: adjust theme.sizes.name or hero.plate-width")
  let rank = text(size: theme.sizes.rank, tracking: theme.tracking.rank, weight: "bold")[#identity.rank]
  assert(measure(rank).width <= geometry.plate-width - 2 * geometry.plate-inset.x,
    message: "Rank exceeds identity plate: adjust theme.sizes.rank or hero.plate-width")
  for side in ("left", "right") {
    let items = contacts.at(side, default: ())
    for item in items {
      assert(measure(text(size: theme.sizes.contact)[#item.value]).width <= geometry.contacts-width,
        message: "Contact exceeds hero column: " + item.label + "; shorten it or adjust contacts-width")
    }
    assert(measure(contact-group(items, left, theme, geometry)).height < geometry.plate-y - geometry.contacts-y,
      message: "Contact group is too tall for the hero")
  }
  block(width: 100%, height: geometry.height)[
  #let backdrop = artwork.at("portrait-backdrop", default: none)
  #let frame = artwork.at("portrait-frame", default: none)
  #if backdrop != none {place(top + center, dx: backdrop.at("x", default: 0mm), dy: backdrop.at("y", default: 0mm), portrait-backdrop(backdrop, theme))}
  #if frame != none {place(top + center, dx: frame.at("x", default: 0mm), dy: frame.at("y", default: 0mm), portrait-frame(frame, theme))}
  #place(top + center, dy: geometry.portrait-y)[#portrait(identity, theme, geometry)]
  #place(top + left, dy: geometry.contacts-y)[#contact-group(contacts.at("left", default: ()), left, theme, geometry)]
  #place(top + right, dy: geometry.contacts-y)[#contact-group(contacts.at("right", default: ()), right, theme, geometry)]
  #for (slot, alignment) in (("hero-left", left), ("hero-right", right)) {
    let asset = artwork.at(slot, default: none)
    if asset != none {place(top + alignment, dx: asset.at("x", default: 0mm), dy: asset.at("y", default: 0mm), decoration(asset, theme))}
  }
  #place(top + center, dy: geometry.plate-y)[#identity-plate(identity, theme, geometry)]
  ]
}
