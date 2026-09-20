#import "../../packages/cv-engine/core/pagination.typ": validate-pages, company-fragment
#import "../../packages/cv-engine/core/node.typ": merge, compose
// The core's page plan must work for a domain that has no ships: rows come
// from the model, never from `groups` or `ships`.
#let model = (
  count: c => c.items.len(),
  slice: (c, rows) => (..c, items: c.items.slice(..rows), display-months: 0),
  totals: cs => (:),
)
#let companies = ((id: "a", name: "A", period: "2020", items: (1, 2, 3)),)
#let candidate = (identity: (name: "Test"), companies: companies, certificates: (), education: (), languages: ())
#let fragment = company-fragment((company: 0, rows: (1, 3)), companies, model)
#assert.eq(fragment.items, (2, 3))
#assert.eq(fragment.continued, true)
#assert.eq(company-fragment(0, companies, model).items, (1, 2, 3))
#validate-pages(((companies: ((company: 0, rows: (0, 2)),)), (companies: ((company: 0, rows: (2, 3)),), synopsis: true)), candidate, model)
// Composition: later wins, nested dictionaries merge, arrays are replaced, none is skipped.
#assert.eq(compose((a: 1, copy: (x: "d", list: (1, 2))), none, (copy: (x: "r")), (copy: (list: (3,)), b: 2)),
  (a: 1, copy: (x: "r", list: (3,)), b: 2))
#assert.eq(merge((k: (n: 1)), (k: 5)), (k: 5))
