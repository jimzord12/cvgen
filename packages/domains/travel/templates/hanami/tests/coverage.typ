// A Coverage Fixture through Hanami: one Template Variation, one Domain Contract version, every
// Fact Group it claims. tests/coverage.py reads the PDF's text for the markers (ADR 0016).
#import "/packages/domains/travel/lib.typ": hanami, hanami-themes, hanami-artwork, hanami-layouts
#let record = json(sys.inputs.fixture)
#show: hanami.with(candidate: record, theme: hanami-themes.sakura, artwork: hanami-artwork.japan,
  layout: hanami-layouts.showcase, variation: sys.inputs.variation)
