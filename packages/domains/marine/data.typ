// The marine facts: companies, vessel-type groups and ships with rank and
// either whole service months or one contract period per row. Totals are
// computed once from the full candidate; a period is display text and is never
// converted into service time (constitution 6), so a record of periods counts
// contracts and has no month total.
#import "../../cv-framework/core/data.typ": duration-parts, required-text, normalize-common, validate-common

// None for a company recorded as contract periods.
#let company-months(company) = {
  let ships = company.groups.map(g => g.ships).flatten()
  let dated = ships.filter(s => "period" in s)
  if dated.len() > 0 {
    assert.eq(dated.len(), ships.len(), message: "Every vessel needs a contract period, or none does: " + company.name)
    assert("service-months" not in company and ships.all(s => s.at("months", default: none) == none),
      message: "A contract period replaces months; give one or the other: " + company.name)
    return none
  }
  let supplied = company.at("service-months", default: none)
  let known = ships.filter(s => s.at("months", default: none) != none)
  for ship in known { let _ = duration-parts(ship.months) }
  if supplied != none {
    let _ = duration-parts(supplied)
    if known.len() == ships.len() {
      assert.eq(supplied, known.map(s => s.months).sum(default: 0), message: "Company service-months does not match vessel months: " + company.name)
    } else {
      assert(known.map(s => s.months).sum(default: 0) <= supplied, message: "Known vessel months exceed company total: " + company.name)
    }
    supplied
  } else {
    assert(known.len() == ships.len(), message: "Missing months: provide service-months for company " + company.name)
    known.map(s => s.months).sum(default: 0)
  }
}

#let experience-totals(companies) = {
  let months = companies.map(company-months)
  assert(months.all(m => m == none) or months.all(m => m != none),
    message: "A record uses contract periods or service months, not both")
  let ships = companies.map(c => c.groups.map(g => g.ships).flatten()).flatten()
  let dated = months.at(0, default: 0) == none
  (months: if dated {none} else {months.sum(default: 0)},
    contracts: if dated {ships.len()} else {none},
    vessels: ships.map(s => s.id).dedup().len(),
    companies: companies.map(c => c.id).dedup().len())
}

#let normalize-candidate(raw) = {
  assert("companies" in raw, message: "Candidate requires companies")
  let common = normalize-common(raw)
  (..common, skills: raw.at("skill_groups", default: ()),
    companies: raw.companies.map(c => (..c, id: c.at("id", default: lower(c.name).replace(" ", "-")))))
}

// Optional vessel particulars, printed in the documented unit and never
// converted (GT and DWT measure different things).
#let particular-units = (tonnage: ("GT", "DWT"), power: ("kW", "BHP"))

#let validate-particulars(ship) = {
  for (key, units) in particular-units {
    let given = ship.at(key, default: none)
    if given != none {
      assert(type(given) == dictionary and given.keys().sorted() == ("unit", "value"),
        message: "vessel." + key + " needs exactly value and unit: " + ship.name)
      assert(type(given.value) == int and given.value > 0, message: "vessel." + key + ".value must be a positive whole number: " + ship.name)
      assert(given.unit in units, message: "vessel." + key + ".unit must be one of " + units.join(", ") + ": " + ship.name)
    }
  }
  if ship.at("engine", default: none) != none { required-text(ship.engine, "vessel.engine") }
}

// A vessel served on twice (same id) states the same particulars or omits them.
#let validate-repeated-vessels(companies) = {
  let seen = (:)
  for company in companies {
    for group in company.groups {
      for ship in group.ships {
        let known = seen.at(ship.id, default: (:))
        for key in ("tonnage", "engine", "power") {
          let given = ship.at(key, default: none)
          if given == none { continue }
          let earlier = known.at(key, default: none)
          assert(earlier == none or earlier == given,
            message: "Vessel " + ship.id + " repeats with a different " + key + "; give the same value or omit it")
          known.insert(key, given)
        }
        seen.insert(ship.id, known)
      }
    }
  }
}

#let validate-candidate(candidate, show-vessel-durations) = {
  validate-common(candidate)
  required-text(candidate.identity.rank, "identity.rank")
  assert(type(show-vessel-durations) == bool, message: "show-vessel-durations must be boolean")
  assert.eq(candidate.companies.map(c => c.id).dedup().len(), candidate.companies.len(), message: "Company IDs must be unique; use page fragments for continuations")
  for company in candidate.companies {
    required-text(company.id, "company.id")
    required-text(company.name, "company.name")
    required-text(company.period, "company.period")
    let _ = company-months(company)
    for group in company.groups {
      required-text(group.type, "vessel type")
      for ship in group.ships {
        for key in ("id", "name", "rank") { required-text(ship.at(key), "vessel." + key) }
        validate-particulars(ship)
        if "period" in ship { required-text(ship.period, "vessel.period") }
        if show-vessel-durations {
          assert(ship.at("months", default: none) != none or "period" in ship,
            message: "Visible vessel durations require months: " + ship.name)
        }
      }
    }
  }
  validate-repeated-vessels(candidate.companies)
  let _ = experience-totals(candidate.companies)
  for group in candidate.skills {
    for skill in group { required-text(skill, "skill") }
  }
}

// The row model the core's pagination uses: one row per ship, named `vessel`
// in the core's page-plan messages. A fragment keeps the full company's
// months so a continued company never shows the duration of the rows on that
// page alone.
#let vessel-count(company) = company.groups.map(g => g.ships.len()).sum(default: 0)

#let vessel-slice(company, rows) = {
  let cursor = 0
  let groups = ()
  for group in company.groups {
    let ships = ()
    for ship in group.ships {
      if rows.at(0) <= cursor and cursor < rows.at(1) {ships.push(ship)}
      cursor += 1
    }
    if ships.len() > 0 {groups.push((..group, ships: ships))}
  }
  (..company, groups: groups, display-months: company-months(company))
}

#let experience-model = (count: vessel-count, slice: vessel-slice, totals: experience-totals, row: "vessel")
