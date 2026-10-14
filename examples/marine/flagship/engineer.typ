#import "../../../packages/domains/marine/lib.typ": flagship, roles, flagship-themes, flagship-artwork, flagship-layouts
#let candidate = json("../../candidates/engineer-example.json")
#show: flagship.with(candidate: candidate, role: roles.engine, theme: flagship-themes.golden-blue,
  artwork: flagship-artwork.engineer, layout: flagship-layouts.flagship-v11,
  show-vessel-durations: sys.inputs.at("vessel-durations", default: "true") == "true")
