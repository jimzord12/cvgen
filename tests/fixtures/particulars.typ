#import "../../packages/domains/marine/lib.typ": flagship, normalize-candidate, validate-candidate
#import "../../packages/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/domains/marine/templates/flagship/artwork/engineer.typ": artwork
#import "../../packages/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout
// Optional vessel particulars (docs/proposals/vessel-particulars.md): the
// engineer record with fictional tonnage, engine maker and power on some ships.
#let d = normalize-candidate(json("../../examples/candidates/engineer-example.json"))
#let given = (
  meridian: (tonnage: (value: 49990, unit: "GT"), engine: "MAN B&W", power: (value: 9480, unit: "kW")),
  aurora: (engine: "MAN B&W", power: (value: 9480, unit: "kW")),
  atlas: (tonnage: (value: 51200, unit: "DWT")),
  north-passage: (engine: "Wärtsilä", power: (value: 12900, unit: "BHP")),
  solstice: (power: (value: 850, unit: "kW")),
)
#let add(s, extra) = s + given.at(s.id, default: (:)) + extra.at(s.id, default: (:))
#let with-particulars(companies, extra: (:)) = companies.map(c => (..c,
  groups: c.groups.map(g => (..g, ships: g.ships.map(s => add(s, extra))))))
#let mode = sys.inputs.at("case", default: "shown")
#let companies = with-particulars(d.companies)
#let first = companies.first()
#if mode == "conflict" {
  // The same vessel twice with a different power fails, whatever the page.
  let again = with-particulars((d.companies.first(),), extra: (meridian: (power: (value: 9500, unit: "kW")))).first()
  validate-candidate((..d, companies: (first, (..again, id: "again"))), true)
} else if mode == "bad-unit" {
  validate-candidate((..d, companies: with-particulars(d.companies, extra: (atlas: (tonnage: (value: 51200, unit: "tons"))))), true)
} else if mode == "too-long" {
  let long = (name: "MV Meridian International Voyager", tonnage: (value: 149990, unit: "DWT"), engine: "Hyundai-Wärtsilä", power: (value: 19480, unit: "BHP"))
  let candidate = (..d, companies: with-particulars(d.companies, extra: (meridian: long)))
  show: flagship.with(candidate: candidate, theme: theme, artwork: artwork, layout: layout)
} else {
  // The same vessel twice with the same particulars, or with them omitted, is accepted.
  let bare = (..d.companies.first(), id: "bare")
  validate-candidate((..d, companies: (first, (..first, id: "same"), bare)), true)
  show: flagship.with(candidate: (..d, companies: companies), theme: theme, artwork: artwork, layout: layout)
}
