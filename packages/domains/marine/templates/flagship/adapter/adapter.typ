// Candidate facts -> Flagship input. Facts carry no presentation text; the
// domain supplies the field's words, this adapter supplies Flagship's, and
// the core normalises the result.
#import "../../../../../cv-framework/core/node.typ": merge, compose
#import "../../../domain.typ": domain

// Words Flagship owns. The field's words (experience-subtitle, continuation,
// combined, total, vessels, companies) come from the marine domain.
#let flagship-copy = (
  experience: "Experience", certificates: "Certificates & endorsements",
  certificates-subtitle: "Illustrative register - dates and credentials are fictional",
  certificate-columns: ("Certificate", "Scope / record", "Issued", "Expires / review"),
  education-languages: "Education & languages", education: "Education", languages: "Languages",
  page-caption: "EXPERIENCE / CREDENTIALS", brand: "FLAGSHIP",
)

// The Flagship input is the facts record plus `copy`: the facts contract
// (domains/marine/schema) and the Flagship input contract (schema/) differ
// only by that key. Overrides win in this order (ADR 0011):
// domain < role < template < `copy` inside the record < the `copy` argument.
#let to-flagship-input(facts, role: none, copy: (:)) = {
  assert(type(facts) == dictionary, message: "Candidate facts must be a dictionary; load the JSON record first")
  assert(role == none or type(role) == dictionary, message: "role must be a role node (roles/<role>/role.typ) or none")
  let words = compose(domain, role, (copy: flagship-copy)).copy
  (..facts, copy: merge(merge(words, facts.at("copy", default: (:))), copy))
}
