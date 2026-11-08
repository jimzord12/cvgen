// A Coverage Fixture through Flagship: one Template Variation, one Domain Contract version, every
// Fact Group on one page. tests/coverage.py reads the PDF's text for the markers (ADR 0016).
#import "/packages/domains/marine/lib.typ": flagship, roles, flagship-themes, flagship-artwork, flagship-layouts
#let record = json(sys.inputs.fixture)
#let plan = flagship-layouts.one-page(record)
#show: flagship.with(candidate: record, role: roles.deck, theme: flagship-themes.golden-blue, artwork: flagship-artwork.captain,
  layout: (..plan, pages: plan.pages.map(page => (..page, skills: true))), variation: sys.inputs.variation)
