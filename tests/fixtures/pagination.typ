#import "../../packages/cv-engine/lib.typ": flagship
#import "../../packages/cv-engine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/cv-engine/templates/flagship/artwork/engineer.typ": artwork
#import "../../packages/cv-engine/templates/flagship/layouts/flagship-v11.typ": layout as base
#let raw = json("../../examples/candidates/engineer-example.json")
#let companies = raw.companies
#let first = companies.first()
#let extra = (type: "Additional tanker fleet", ships: range(8).map(i => (id: "extra-" + str(i), name: "MV Test Vessel " + str(i+1), rank: "Second Engineer", months: 3)))
#let first = (..first, groups: (..first.groups, extra))
#let candidate = (..raw, companies: (first, ..companies.slice(1)),
  certificates: (..raw.certificates, ("Additional training A", "Illustrative record", "2024", "2029"), ("Additional training B", "Illustrative record", "2024", "2029")),
  education_entries: (..raw.education_entries, (qualification: "Additional training award", institution: "Example Training Institute", note: "Illustrative second education entry")),
  language_entries: (..raw.language_entries, (name: "Spanish", level: "Illustrative additional language")))
#let mode = sys.inputs.at("case", default: "three-pages")
#let pages = if mode == "overflow" {
  ((companies: (0, 1, 2, 3, 4, 5), synopsis: true, certificates: true, education: true),)
} else if mode == "duplicate" {
  ((companies: (0,)), (companies: (0, 1, 2, 3, 4, 5), synopsis: true, certificates: true, education: true))
} else {
  ((companies: ((company: 0, rows: (0, 6)),)),
   (companies: ((company: 0, rows: (6, 14)), 1, 2, 3)),
   (companies: (4, 5), synopsis: true, certificates: true, education: true))
}
#let layout = (..base, pages: pages)
#show: flagship.with(candidate: candidate, theme: theme, artwork: artwork, layout: layout)
