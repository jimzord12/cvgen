// Hanami essential: one A4 page, scan-first (P-0019 section 9). A shallow band with the name block,
// the profile row, then the career column on the left (experience, education at its foot) and the
// facts rail on the right (availability, languages, destinations, practical know-how, references).
#let layout = (
  name: "essential",
  paper: "a4",
  band: 50mm,
  portrait: 35mm,
  // the sakura branch's width when the record has no portrait (104 mm beside one)
  canopy: 150mm,
  // The fixed fields every part must fit (no shrinking, constitution 4); x and width in mm from the
  // page's left edge, y from its top.
  // the profile row starts this far under the band, which fits its name block (at most `band`)
  profile: (gap: 8mm),
  // the fields start 8 mm under the profile row, at most at `latest`; `y` is where they start on the twin
  main: (x: 16mm, y: 85mm, latest: 98mm, width: 113mm, bottom: 279mm),
  rail: (x: 141mm, y: 85mm, width: 53mm, bottom: 281mm, panel: 135mm),
  pages: 1,
)
