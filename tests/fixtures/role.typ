#import "../../packages/domains/marine/lib.typ": flagship
#import "../../packages/domains/marine/templates/flagship/themes/silver-bridge.typ": theme
#import "../../packages/domains/marine/templates/flagship/artwork/captain.typ": artwork
#import "../../packages/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout
// A role reaches the page only if `flagship` forwards it to the adapter.
#let role = (id: "test", copy: (experience-subtitle: "ROLE SUBTITLE"))
#let candidate = json("../../examples/candidates/chief-officer-example.json")
#show: flagship.with(candidate: candidate, role: role, theme: theme, artwork: artwork, layout: layout)
