#import "../../packages/cv-engine/lib.typ": flagship, normalize-candidate
#import "../../packages/cv-engine/core/data.typ": company-months
#import "../../packages/cv-engine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/cv-engine/templates/flagship/artwork/engineer.typ": artwork as original-art
#import "../../packages/cv-engine/templates/flagship/layouts/flagship-v11.typ": layout
#let d = normalize-candidate(json("../../examples/candidates/engineer-example.json"))
#let mode = sys.inputs.at("case", default: "missing-months")
#let candidate = if mode == "missing-months" {
  (..d, companies: d.companies.map(c => (..c, service-months: company-months(c),
    groups: c.groups.map(g => (..g, ships: g.ships.map(s => (..s, months: none)))))))
} else if mode == "optional" {
  (..d, identity: (..d.identity, portrait: none), contacts: (left: (), right: ()), education: (), languages: ())
} else {
  let companies = d.companies
  let groups = companies.first().groups
  let ships = groups.first().ships
  ships.at(0) = (..ships.first(), name: "MV Meridian International Voyager", months: 131)
  groups.at(0) = (..groups.first(), ships: ships)
  companies.at(0) = (..companies.first(), groups: groups)
  (..d, companies: companies)
}
#let artwork = (..original-art, background-first: (..original-art.background-first, opacity: 0.7))
#show: flagship.with(candidate: candidate, theme: theme, artwork: artwork, layout: layout,
  show-vessel-durations: mode != "missing-months" and sys.inputs.at("times", default: "true") == "true")
