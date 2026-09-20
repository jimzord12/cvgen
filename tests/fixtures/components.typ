#import "../../packages/cv-engine/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/cv-engine/domains/marine/templates/flagship/artwork/engineer.typ": artwork
#import "../../packages/cv-engine/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout
#import "../../packages/cv-engine/core/data.typ": normalize-candidate
#import "../../packages/cv-engine/domains/marine/templates/flagship/components/hero.typ": hero
#import "../../packages/cv-engine/core/primitives.typ": decoration
#let d = normalize-candidate(json("../../examples/candidates/engineer-example.json"))
#set text(font: theme.fonts.body, size: theme.sizes.body, fill: theme.colors.ink, lang: "en")
#set par(leading: theme.leading.initial)
#set page(paper: "a4", margin: layout.opening-margin, background: {
  place(top + left, decoration(artwork.background-first, theme, width: layout.width, height: layout.height))
  place(top, rect(width: 100%, height: layout.hero.band-height, fill: theme.colors.hero, stroke: none))
})
#let mode = sys.inputs.at("case", default: "normal")
#let identity = if mode == "long-name" {(..d.identity, name: "A VERY LONG NAME THAT CANNOT FIT THIS PLATE")} else if mode == "no-portrait" {(..d.identity, portrait: none)} else {d.identity}
#let contacts = if mode == "long-email" {(..d.contacts, right: ((label: "Email", value: "a-very-long-address-that-does-not-fit@example.com"),))} else if mode == "no-contact" {(..d.contacts, right: ())} else {d.contacts}
#hero(identity, contacts, theme, artwork, layout.hero)
