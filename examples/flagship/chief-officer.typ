#import "../../packages/cv-engine/lib.typ": flagship
#import "../../packages/cv-engine/templates/flagship/themes/silver-bridge.typ": theme
#import "../../packages/cv-engine/templates/flagship/artwork/captain.typ": artwork
#import "../../packages/cv-engine/templates/flagship/layouts/flagship-v11.typ": layout
#let candidate = json("../candidates/chief-officer-example.json")
// `copy` overrides Flagship wording without touching the candidate record.
#show: flagship.with(candidate: candidate, theme: theme, artwork: artwork, layout: layout,
  show-vessel-durations: sys.inputs.at("vessel-durations", default: "true") == "true",
  copy: if "brand" in sys.inputs { (brand: sys.inputs.brand) } else { (:) })
