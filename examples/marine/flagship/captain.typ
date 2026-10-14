#import "../../../packages/domains/marine/lib.typ": flagship, roles, flagship-themes, flagship-artwork, flagship-layouts
#let candidate = json("../../candidates/captain-example.json")
#show: flagship.with(candidate: candidate, role: roles.deck, theme: flagship-themes.golden-blue,
  artwork: flagship-artwork.captain, layout: flagship-layouts.flagship-v11,
  show-vessel-durations: sys.inputs.at("vessel-durations", default: "true") == "true")
