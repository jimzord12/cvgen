// One-page Flagship for short careers (cadets, junior officers): the v11
// geometry with tighter vertical gaps so hero, experience, synopsis,
// certificates and education share one page. Type sizes stay the theme's;
// overflow still fails loudly. See docs/reference/layout-and-pagination.md.
#import "flagship-v11.typ": layout as v11

#let layout = (..v11,
  // The band and everything placed in it are unchanged; only the flow below starts 5mm higher.
  hero: (..v11.hero, height: 72mm),
  experience: (..v11.experience, opening: (company-gap: 4mm, row-gap: 2.5mm)),
  headings: (..v11.headings, opening: (above: 5mm, below: 3.5mm),
    education: (above: 5mm, below: 3mm)),
  synopsis: (..v11.synopsis, inset: (x: 7mm, y: 3.5mm)),
  certificates: (..v11.certificates, inset: (x: 3mm, y: 1.6mm)),
  education: (..v11.education, language-gap: 2.5mm),
  // Three companies; `one-page` below fits the plan to the candidate's own count.
  pages: ((companies: (0, 1, 2), synopsis: true, certificates: true, education: true),),
  // Free space goes half above certificates, half above education (flagship.typ).
  spread: true,
)

// The whole record on one page, whatever its company count; the per-CV
// entry point calls it with the candidate record it reads.
#let one-page(candidate) = (..layout,
  pages: ((companies: range(candidate.companies.len()), synopsis: true, certificates: true, education: true),))
