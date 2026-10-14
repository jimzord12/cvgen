// Explicit page allocations and company fragments. Never changes candidate
// totals. The row model comes from the domain as `model`: `count(company)`
// gives the number of rows a company has, `slice(company, rows)` returns the
// company reduced to a half-open row range, and the optional `row` names one
// row in error messages (marine says "vessel"). The core uses `count`, `slice`
// and `row` only; a template may add more (marine adds `totals`). Functions
// stored in a dictionary are called as `(model.count)(company)`.
//
// The core checks only the grammar every template shares: a non-empty plan
// whose `companies` cover every row once, in candidate order. Which page
// carries the closing sections, and in what order, is the template's rule
// (Flagship's is `validate-plan` in its flagship.typ).
#let row-noun(model) = model.at("row", default: "row")

#let selection(ref, companies, model) = {
  let index = if type(ref) == int {ref} else {ref.company}
  assert(type(index) == int and index >= 0 and index < companies.len(), message: "Page plan company index out of bounds")
  let company = companies.at(index)
  let count = (model.count)(company)
  let rows = if type(ref) == int {(0, count)} else {ref.at("rows", default: (0, count))}
  assert(rows.len() == 2 and rows.all(x => type(x) == int), message: "Row range must contain two integer indices")
  assert(0 <= rows.at(0) and rows.at(0) < rows.at(1) and rows.at(1) <= count, message: "Page plan " + row-noun(model) + " row range out of bounds")
  (company: index, rows: rows)
}

#let company-fragment(ref, companies, model) = {
  if type(ref) == int {return companies.at(ref)}
  let selected = selection(ref, companies, model)
  (..(model.slice)(companies.at(selected.company), selected.rows), continued: selected.rows.at(0) > 0)
}

#let validate-pages(pages, candidate, model) = {
  assert(pages.len() > 0, message: "Page plan cannot be empty")
  let companies = candidate.companies
  let expected = ()
  for (i, company) in companies.enumerate() {
    for row in range((model.count)(company)) {expected.push(str(i) + ":" + str(row))}
  }
  let actual = ()
  for page in pages {
    for ref in page.companies {
      let selected = selection(ref, companies, model)
      for row in range(..selected.rows) {actual.push(str(selected.company) + ":" + str(row))}
    }
  }
  assert.eq(actual, expected, message: "Page plan must cover each " + row-noun(model) + " row once, in candidate order")
}
