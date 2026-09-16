#import "../../packages/cv-engine/lib.typ": flagship
#import "../../packages/cv-engine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/cv-engine/templates/flagship/artwork/engineer.typ": artwork
#import "../../packages/cv-engine/templates/flagship/layouts/flagship-v11.typ": layout
#let candidate = json("../candidates/engineer-example.json")
#show: flagship.with(candidate: candidate, theme: theme, artwork: artwork, layout: layout,
  show-vessel-durations: sys.inputs.at("vessel-durations", default: "true") == "true")
