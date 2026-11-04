// A deck career recorded as contract periods (ADR 0007, TASK-3): one row per contract, a
// synopsis counting contracts, a three-column certificate table and a skills block placed
// through the page plan. Every other case breaks one rule and must fail on its message.
#import "../../packages/domains/marine/lib.typ": flagship
#import "../../packages/domains/marine/roles/deck/role.typ": role
#import "../../packages/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/domains/marine/templates/flagship/artwork/captain.typ": artwork
#import "../../packages/domains/marine/templates/flagship/layouts/flagship-one-page.typ": one-page
#import "../../packages/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout as v11
#let raw = json("../../examples/candidates/deck-cadet-example.json")
#let contract(id, name, period) = (id: id, name: name, rank: "Second Officer", period: period)
#let ships = (contract("mv-orion", "MV Orion Trader", "03/2021 - 11/2021"),
  contract("mv-orion", "MV Orion Trader", "02/2022 - 09/2022"),
  contract("mv-vega", "MV Vega Star", "01/2023 - 08/2023"))
#let company(rows, ..extra) = (id: "harbour-line", name: "Harbour Line", period: "2021 - 2023",
  groups: ((type: "Bulk carriers", ships: rows),), ..extra.named())
#let certificates = (
  (title: "STCW II/1 Officer of the watch", scope: "Example Maritime Authority", issued: "2021"),
  (title: "GMDSS General Operator", scope: "Example Radio Board", issued: "2022"))
#let case = sys.inputs.at("case", default: "good")
#let companies = if case == "one-vessel-undated" {
  (company((ships.at(0), (id: "mv-rigel", name: "MV Rigel", rank: "Second Officer"))),)
} else if case == "period-and-months" {
  (company(((..ships.at(0), months: 8),)),)
} else if case == "mixed-record" {
  (company(ships), (id: "old-line", name: "Old Line", period: "2019",
    groups: ((type: "Tankers", ships: ((id: "mt-a", name: "MT A", rank: "Third Officer", months: 6),)),)))
} else {(company(ships),)}
#let companies = if case == "continued" {
  let row(n) = contract("mv-" + str(n), "MV Long Haul " + str(n), "01/" + str(2000 + n) + " - 12/" + str(2000 + n))
  (company(range(1, 13).map(row)),)
} else if case == "skills-first" {
  (company(ships), (..company(((..ships.at(0), id: "mv-rigel", name: "MV Rigel"),)), id: "second-line", name: "Second Line"))
} else if case == "promotion" {
  // Promoted within one coarse period: two ranks, so two contracts.
  (company(((..ships.at(0), period: "2021", rank: "Third Officer"), (..ships.at(0), period: "2021"))),)
} else if case == "repeated-contract" {
  (company((ships.at(0), ships.at(0))),)
} else {companies}
#let candidate = (..raw, companies: companies,
  certificates: if case == "mixed-certificates" {certificates + ((title: "A", scope: "B", issued: "C", review: "D"),)} else {certificates},
  skill_groups: (("Passage planning", "Cargo watch"), ("ECDIS", "Bridge team work")),
  copy: (certificate-columns: if case == "too-few-headings" {("Certificate", "Provider")} else {("Certificate", "Provider", "Issued")}))
#let plan = one-page(candidate)
#let layout = if case == "skills-unplaced" {plan} else if case == "continued" {
  // Two pages: the company runs on, and the skills sit on the second page.
  (..v11, pages: ((companies: ((company: 0, rows: (0, 6)),)),
    (companies: ((company: 0, rows: (6, 12)),), synopsis: true, certificates: true, education: true, skills: true)))
} else if case == "skills-first" {
  // The gap's real case: skills at the foot of page 1, so they read before certificates.
  (..v11, pages: ((companies: (0,), skills: true), (companies: (1,), synopsis: true, certificates: true, education: true)))
} else {
  (..plan, pages: plan.pages.map(p => (..p, skills: true)))
}
#show: flagship.with(candidate: candidate, role: role, theme: theme, artwork: artwork, layout: layout,
  show-vessel-durations: case != "durations-off")
