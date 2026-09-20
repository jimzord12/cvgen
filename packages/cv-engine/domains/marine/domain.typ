// The marine domain (ADR 0011): what every marine template can rely on.
// A role under roles/<role>/role.typ refines this; a template overrides it.
#import "data.typ": experience-model

#let domain = (
  id: "marine",
  meta: (title: "Marine CV", author: "Marine CV Studio"),
  // Wording that belongs to the field, not to one design.
  copy: (
    experience-subtitle: "Company / vessel type / vessel", continuation: "Continued / earlier companies",
    combined: "Combined service", total: "Total experience", vessels: "Vessels", companies: "Companies",
  ),
  experience: experience-model,
)
