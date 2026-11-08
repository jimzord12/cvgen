// Hanami showcase: two A4 pages, the geometry of Hanami Line 2 (owner's pick, 2026-10-02).
// Page 1: an 86 mm band, the paper field below it; page 2: a 40 mm band, the destination page.
#let layout = (
  paper: "a4",
  band: 86mm, band-2: 40mm,
  portrait: 42mm,
  plate: (width: 108mm, height: 27mm),
  // The fixed fields every section must fit (no shrinking, constitution 4).
  field-1: (x: 16mm, y: 95.6mm, width: 178mm, height: 185.6mm),
  field-2: (x: 16mm, gap: 7mm, bottom: 281.6mm, width: 178mm),
  pages: 2,
)
