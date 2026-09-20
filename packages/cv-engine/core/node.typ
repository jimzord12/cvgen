// Composition of domain, role and template dictionaries (ADR 0011). Later
// nodes win; nested dictionaries merge; arrays, strings and functions are
// replaced. A `none` node is skipped, so a domain-level template passes
// `role: none`. Order everywhere: domain < role < template < record < call site.
#let merge(base, over) = {
  for (k, v) in over {
    base.insert(k, if type(v) == dictionary and type(base.at(k, default: none)) == dictionary { merge(base.at(k), v) } else { v })
  }
  base
}

#let compose(..nodes) = nodes.pos().filter(n => n != none).fold((:), merge)
