#import "../../packages/domains/marine/lib.typ": flagship, normalize-candidate, validate-candidate
#import "../../packages/domains/marine/roles/engine/role.typ": role
#import "../../packages/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/domains/marine/templates/flagship/artwork/engineer.typ": artwork
#import "../../packages/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout
// Optional vessel particulars (docs/proposals/vessel-particulars.md): the raw
// engineer record, exactly as examples/marine/flagship/engineer.typ renders it,
// with fictional tonnage, engine maker and power added to some ships.
#let raw = json("../../examples/candidates/engineer-example.json")
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
#let render(companies) = flagship.with(candidate: (..raw, companies: companies), role: role,
  theme: theme, artwork: artwork, layout: layout)
#if mode == "conflict" {
  // The same vessel twice with a different power fails, whatever the page.
  let d = normalize-candidate((..raw, companies: with-particulars(raw.companies)))
  let again = with-particulars((raw.companies.first(),), extra: (meridian: (power: (value: 9500, unit: "kW")))).first()
  validate-candidate((..d, companies: (d.companies.first(), (..again, id: "again"))), true)
} else if mode == "bad-unit" {
  show: render(with-particulars(raw.companies, extra: (atlas: (tonnage: (value: 51200, unit: "tons")))))
} else if mode == "bad-value" {
  show: render(with-particulars(raw.companies, extra: (atlas: (tonnage: (value: 0, unit: "GT")))))
} else if mode == "bad-keys" {
  show: render(with-particulars(raw.companies, extra: (atlas: (tonnage: (value: 51200, unit: "GT", note: "x")))))
} else if mode == "too-long" {
  let long = (name: "MV Meridian International Voyager", tonnage: (value: 149990, unit: "DWT"), engine: "Hyundai-Wärtsilä", power: (value: 19480, unit: "BHP"))
  show: render(with-particulars(raw.companies, extra: (meridian: long)))
} else {
  // The same vessel twice with the same particulars, or with them omitted, is accepted.
  let d = normalize-candidate((..raw, companies: with-particulars(raw.companies)))
  let first = d.companies.first()
  validate-candidate((..d, companies: (first, (..first, id: "same"), (..normalize-candidate(raw).companies.first(), id: "bare"))), true)
  show: render(with-particulars(raw.companies))
}
