#import "../../packages/cv-engine/core/data.typ": duration-parts
#import "../../packages/cv-engine/domains/marine/data.typ": normalize-candidate, validate-candidate, experience-totals
#import "../../packages/cv-engine/domains/marine/templates/flagship/adapter/adapter.typ": to-flagship-input, flagship-copy
// The core carries no wording; the domain and the adapter add it, and overrides
// win in the order domain < role < template < record < call site (ADR 0011).
#let facts = json("../../examples/candidates/engineer-example.json")
#let expected = (
  experience: "Experience", experience-subtitle: "Company / vessel type / vessel",
  continuation: "Continued / earlier companies", combined: "Combined service", total: "Total experience",
  vessels: "Vessels", companies: "Companies", certificates: "Certificates & endorsements",
  certificates-subtitle: "Illustrative register - dates and credentials are fictional",
  certificate-columns: ("Certificate", "Scope / record", "Issued", "Expires / review"),
  education-languages: "Education & languages", education: "Education", languages: "Languages",
  page-caption: "EXPERIENCE / CREDENTIALS", brand: "FLAGSHIP",
)
#assert.eq(normalize-candidate(facts).copy, (:))
#assert.eq(normalize-candidate(to-flagship-input(facts)).copy, expected)
#assert.eq(to-flagship-input((..facts, copy: (brand: "RECORD", experience: "Record heading")), copy: (experience: "Sea service")).copy,
  (..expected, brand: "RECORD", experience: "Sea service"))
// A role refines only what its domain offers; template words stay the template's.
#let role = (id: "test", copy: (experience-subtitle: "X", continuation: "Y", brand: "ROLE"))
#assert.eq(to-flagship-input(facts, role: role).copy, (..expected, experience-subtitle: "X", continuation: "Y"))
// Arrays are replaced, never concatenated.
#assert.eq(to-flagship-input((..facts, copy: (certificate-columns: ("A", "B")))).copy.certificate-columns, ("A", "B"))
#for months in (0, 1, 11, 12, 13, 138) {
  let parts = duration-parts(months)
  assert.eq(parts.years * 12 + parts.months, months)
}
#assert.eq(duration-parts(13), (years: 1, months: 1))
#assert.eq(duration-parts(138), (years: 11, months: 6))
#let candidate = normalize-candidate(json("../../examples/candidates/engineer-example.json"))
#validate-candidate(candidate, true)
#assert.eq(experience-totals(candidate.companies), (months: 138, vessels: 23, companies: 6))
#let company = candidate.companies.first()
#let repeated = (..company, id: "another-company")
#assert.eq(experience-totals((company, repeated)).vessels, 6)
#assert.eq(experience-totals((company, repeated)).months, 72)
#let missing = (..company, service-months: 36, groups: company.groups.map(g => (..g, ships: g.ships.map(s => (..s, months: none)))))
#let mode = sys.inputs.at("case", default: "valid")
#if mode == "missing-visible" {
  validate-candidate((..candidate, companies: (missing,)), true)
} else if mode == "mismatch" {
  validate-candidate((..candidate, companies: ((..company, service-months: 37),)), false)
} else if mode == "negative" {
  duration-parts(-1)
} else if mode == "missing-name" {
  validate-candidate((..candidate, identity: (..candidate.identity, name: " ")), true)
} else {
  validate-candidate((..candidate, companies: (missing,)), false)
  assert.eq(experience-totals((missing,)).months, 36)
}
