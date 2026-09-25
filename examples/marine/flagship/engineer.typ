#import "../../../packages/domains/marine/lib.typ": flagship
#import "../../../packages/domains/marine/roles/engine/role.typ": role
#import "../../../packages/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "../../../packages/domains/marine/templates/flagship/artwork/engineer.typ": artwork
#import "../../../packages/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout
#let candidate = json("../../candidates/engineer-example.json")
#show: flagship.with(candidate: candidate, role: role, theme: theme, artwork: artwork, layout: layout,
  show-vessel-durations: sys.inputs.at("vessel-durations", default: "true") == "true")
