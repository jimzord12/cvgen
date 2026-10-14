// The marine domain (ADR 0011): what every marine template can rely on.
// A role under roles/<role>/role.typ refines this; a template overrides it.
#import "data.typ": experience-model

#let domain = (
  id: "marine",
  meta: (title: "CVgen", author: "CVgen"),
  // Wording that belongs to the field, not to one design.
  copy: (
    experience-subtitle: "Company / vessel type / vessel", continuation: "Continued / earlier companies",
    combined: "Combined service", total: "Total experience", vessels: "Vessels", companies: "Companies",
    vessel: "Vessel", company: "Company",
  ),
  experience: experience-model,
  // The colours baked into the original art under assets/ (the v11 navy, teal, brass
  // and slate), each named by the theme colour that replaces it. A theme carries it
  // as `art-palette`; the core's decoration applies it (docs/reference/theme.md).
  art-palette: ("#102f3a": "ink", "#236a70": "accent", "#c8a579": "metal", "#546870": "muted"),
)
