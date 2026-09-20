// Explicit page allocations and company fragments. Never changes candidate
// totals. The row model comes from the domain as `model`: `count(company)`
// gives the number of rows a company has, `slice(company, rows)` returns the
// company reduced to a half-open row range. Functions stored in a
// dictionary are called as `(model.count)(company)`.
#let selection(ref, companies, model) = {
  let index = if type(ref) == int {ref} else {ref.company}
  assert(type(index) == int and index >= 0 and index < companies.len(), message: "Page plan company index out of bounds")
  let company = companies.at(index)
  let count = (model.count)(company)
  let rows = if type(ref) == int {(0, count)} else {ref.at("rows", default: (0, count))}
  assert(rows.len() == 2 and rows.all(x => type(x) == int), message: "Row range must contain two integer indices")
  assert(0 <= rows.at(0) and rows.at(0) < rows.at(1) and rows.at(1) <= count, message: "Page plan vessel row range out of bounds")
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
  assert.eq(actual, expected, message: "Page plan must cover each vessel row once, in candidate order")
  let synopsis-pages = pages.enumerate().filter(((i, p)) => p.at("synopsis", default: false))
  assert.eq(synopsis-pages.len(), 1, message: "Page plan requires exactly one synopsis")
  let final-experience = pages.enumerate().filter(((i, p)) => p.companies.len() > 0)
  assert(final-experience.len() > 0, message: "Experience requires at least one vessel")
  assert.eq(synopsis-pages.first().at(0), final-experience.last().at(0), message: "Synopsis must follow the final Experience page")
  for (key, required) in (("certificates", candidate.certificates.len() > 0), ("education", candidate.education.len() + candidate.languages.len() > 0)) {
    let assigned = pages.enumerate().filter(((i, p)) => p.at(key, default: false))
    assert(assigned.len() <= 1, message: "Section assigned more than once: " + key)
    if required {
      assert.eq(assigned.len(), 1, message: "Missing page assignment: " + key)
      assert(assigned.first().at(0) >= final-experience.last().at(0), message: "Credentials must follow Experience")
    }
  }
}
