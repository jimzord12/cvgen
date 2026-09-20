// Candidate facts -> Flagship input. Facts carry no presentation text; this is
// the one place Flagship adds its own wording before the core normalises.
#let flagship-copy = (
  experience: "Experience", experience-subtitle: "Company / vessel type / vessel",
  continuation: "Continued / earlier companies", combined: "Combined service", total: "Total experience",
  vessels: "Vessels", companies: "Companies", certificates: "Certificates & endorsements",
  certificates-subtitle: "Illustrative register - dates and credentials are fictional",
  certificate-columns: ("Certificate", "Scope / record", "Issued", "Expires / review"),
  education-languages: "Education & languages", education: "Education", languages: "Languages",
  page-caption: "EXPERIENCE / CREDENTIALS", brand: "FLAGSHIP",
)

// Today the Flagship input is the facts record plus `copy`: the facts contract
// (packages/cv-engine/domains/marine/schema) and the Flagship input contract
// (domains/marine/templates/flagship/schema) differ only by that key. Overrides win in this
// order: template defaults < `copy` inside the record < the `copy` argument.
#let to-flagship-input(facts, copy: (:)) = {
  assert(type(facts) == dictionary, message: "Candidate facts must be a dictionary; load the JSON record first")
  (..facts, copy: flagship-copy + facts.at("copy", default: (:)) + copy)
}
