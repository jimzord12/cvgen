#import "../../../packages/domains/marine/lib.typ": flagship
#import "../../../packages/domains/marine/roles/deck/role.typ": role
#import "../../../packages/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "../../../packages/domains/marine/templates/flagship/artwork/captain.typ": artwork
#import "../../../packages/domains/marine/templates/flagship/layouts/flagship-one-page.typ": one-page
#let candidate = json("../../candidates/deck-cadet-example.json")
// A short career on one page: the plan covers this record's companies.
#show: flagship.with(candidate: candidate, role: role, theme: theme, artwork: artwork, layout: one-page(candidate),
  show-vessel-durations: sys.inputs.at("vessel-durations", default: "true") == "true")
