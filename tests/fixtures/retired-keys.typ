// A layout that still sets a key the page shell's `shell` slice replaced (TASK-45) must fail
// loudly through `flagship`.
#import "../../packages/domains/marine/lib.typ": flagship
#import "../../packages/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/domains/marine/templates/flagship/artwork/engineer.typ": artwork
#import "../../packages/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout as base
#let key = sys.inputs.at("case", default: "margin")
#let layout = if key == "margin" {(..base, opening-margin: base.shell.margin)} else {(..base, hero: (..base.hero, band-height: 83mm))}
#show: flagship.with(candidate: json("../../examples/candidates/engineer-example.json"), theme: theme, artwork: artwork, layout: layout)
Retired layout key: #key
