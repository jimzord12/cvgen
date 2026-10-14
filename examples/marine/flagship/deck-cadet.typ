#import "../../../packages/domains/marine/lib.typ": flagship, roles, flagship-themes, flagship-artwork, flagship-layouts
#let candidate = json("../../candidates/deck-cadet-example.json")
// A short career on one page: the plan covers this record's companies.
#show: flagship.with(candidate: candidate, role: roles.deck, theme: flagship-themes.golden-blue,
  artwork: flagship-artwork.captain, layout: flagship-layouts.one-page(candidate),
  show-vessel-durations: sys.inputs.at("vessel-durations", default: "true") == "true")
