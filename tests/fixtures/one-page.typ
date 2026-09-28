// The one-page profile's plan helper on a record of one company with one
// vessel and one of three companies (the deck cadet example has two), and
// on one record too long for a page, which must fail loudly, never shrink.
// `no-education` and `no-certificates` drop one closing section: the blocks
// then stack from the top.
#import "../../packages/domains/marine/lib.typ": flagship
#import "../../packages/domains/marine/roles/deck/role.typ": role
#import "../../packages/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/domains/marine/templates/flagship/artwork/captain.typ": artwork
#import "../../packages/domains/marine/templates/flagship/layouts/flagship-one-page.typ": one-page
#let raw = json("../../examples/candidates/deck-cadet-example.json")
#let vessel(n) = (id: "test-vessel-" + str(n), name: "MV Test Vessel " + str(n), rank: "Deck Cadet", months: 3)
#let extra(n, ships) = (name: "Coastal Line " + str(n), period: "2023", id: "coastal-line-" + str(n),
  groups: ((type: "General cargo", ships: ships),))
#let case = sys.inputs.at("case", default: "three")
// Three companies with three vessels and three certificate rows sit at the measured
// edge (docs/reference/layout-and-pagination.md); one vessel more must overflow.
#let three = (raw.companies.at(1), extra(1, (vessel(1),)), extra(2, (vessel(2),)))
#let (companies, certificates) = {
  if case == "one" {(raw.companies.slice(1, 2), raw.certificates)}
  else if case == "three" {(three, raw.certificates.slice(0, 3))}
  else if case == "overflow" {(three.slice(0, 2) + (extra(2, (vessel(2), vessel(3))),), raw.certificates.slice(0, 3))}
  else if case in ("no-education", "no-certificates") {(raw.companies.slice(1, 2), if case == "no-certificates" {()} else {raw.certificates})}
  else {panic("unknown case: " + case)}
}
#let candidate = (..raw, companies: companies, certificates: certificates,
  ..if case == "no-education" {(education_entries: (), language_entries: ())})
#show: flagship.with(candidate: candidate, role: role, theme: theme, artwork: artwork, layout: one-page(candidate))
