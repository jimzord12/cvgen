#import "../../../packages/domains/marine/lib.typ": flagship
#import "../../../packages/domains/marine/roles/deck/role.typ": role
#import "../../../packages/domains/marine/templates/flagship/themes/silver-bridge.typ": theme
#import "../../../packages/domains/marine/templates/flagship/artwork/captain.typ": artwork
#import "../../../packages/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout
#let candidate = json("../../candidates/captain-example.json")
#show: flagship.with(candidate: candidate, role: role, theme: theme, artwork: artwork, layout: layout,
  show-vessel-durations: sys.inputs.at("vessel-durations", default: "true") == "true")
