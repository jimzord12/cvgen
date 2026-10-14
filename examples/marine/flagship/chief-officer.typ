#import "../../../packages/domains/marine/lib.typ": flagship, roles, flagship-themes, flagship-artwork, flagship-layouts
#let candidate = json("../../candidates/chief-officer-example.json")
// `copy` overrides Flagship wording without touching the candidate record.
#show: flagship.with(candidate: candidate, role: roles.deck, theme: flagship-themes.silver-bridge,
  artwork: flagship-artwork.captain, layout: flagship-layouts.flagship-v11,
  show-vessel-durations: sys.inputs.at("vessel-durations", default: "true") == "true",
  copy: if "brand" in sys.inputs { (brand: sys.inputs.brand) } else { (:) })
