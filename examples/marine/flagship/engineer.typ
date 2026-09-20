#import "../../../packages/cv-engine/lib.typ": flagship
#import "../../../packages/cv-engine/domains/marine/roles/engine/role.typ": role
#import "../../../packages/cv-engine/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "../../../packages/cv-engine/domains/marine/templates/flagship/artwork/engineer.typ": artwork
#import "../../../packages/cv-engine/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout
#let candidate = json("../../candidates/engineer-example.json")
#show: flagship.with(candidate: candidate, role: role, theme: theme, artwork: artwork, layout: layout,
  show-vessel-durations: sys.inputs.at("vessel-durations", default: "true") == "true")
