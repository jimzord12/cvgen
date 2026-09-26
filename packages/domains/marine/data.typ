// The marine facts: companies, vessel-type groups and ships with rank and
// whole service months. Totals are computed once from the full candidate;
// calendar periods are never converted into service time (constitution 6).
#import "../../cv-framework/core/data.typ": duration-parts, required-text, normalize-common, validate-common

#let company-months(company) = {
  let ships = company.groups.map(g => g.ships).flatten()
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

#let experience-totals(companies) = (
  months: companies.map(company-months).sum(default: 0),
  vessels: companies.map(c => c.groups.map(g => g.ships.map(s => s.id)).flatten()).flatten().dedup().len(),
  companies: companies.map(c => c.id).dedup().len(),
)

#let normalize-candidate(raw) = {
  assert("companies" in raw, message: "Candidate requires companies")
  let common = normalize-common(raw)
  (..common, companies: raw.companies.map(c => (..c, id: c.at("id", default: lower(c.name).replace(" ", "-")))))
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
        if show-vessel-durations {
          assert(ship.at("months", default: none) != none, message: "Visible vessel durations require months: " + ship.name)
        }
      }
    }
  }
  validate-repeated-vessels(candidate.companies)
}

// The row model the core's pagination uses: one row per ship. A fragment
// keeps the full company's months so a continued company never shows the
// duration of the rows on that page alone.
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

#let experience-model = (count: vessel-count, slice: vessel-slice, totals: experience-totals)
