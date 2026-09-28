// The one-page profile's plan helper on records of one and three companies
// (the deck cadet example has two), and on one record too long for a page,
// which must fail loudly rather than shrink.
#import "../../packages/domains/marine/lib.typ": flagship
#import "../../packages/domains/marine/roles/deck/role.typ": role
#import "../../packages/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/domains/marine/templates/flagship/artwork/captain.typ": artwork
#import "../../packages/domains/marine/templates/flagship/layouts/flagship-one-page.typ": one-page
#let raw = json("../../examples/candidates/deck-cadet-example.json")
#let vessel(n) = (id: "test-vessel-" + str(n), name: "MV Test Vessel " + str(n), rank: "Deck Cadet", months: 3)
#let extra(ships) = (name: "Ionian Coastal Lines", period: "2023", id: "ionian-coastal-lines",
  groups: ((type: "General cargo", ships: ships),))
#let case = sys.inputs.at("case", default: "three")
#let companies = {
  if case == "one" {raw.companies.slice(0, 1)}
  else if case == "three" {(..raw.companies, extra((vessel(1),)))}
  else if case == "overflow" {(..raw.companies, extra((vessel(1), vessel(2))))}
  else {panic("unknown case: " + case)}
}
#let candidate = (..raw, companies: companies)
#show: flagship.with(candidate: candidate, role: role, theme: theme, artwork: artwork, layout: one-page(candidate))
