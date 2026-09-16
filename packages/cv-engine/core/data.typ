// Pure data operations. This module never reads a file or draws content.
#let duration-parts(months) = {
  assert(type(months) == int and months >= 0, message: "Service months must be a non-negative integer")
  (years: calc.quo(months, 12), months: calc.rem(months, 12))
}

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
  for key in ("identity", "companies") { assert(key in raw, message: "Candidate requires " + key) }
  let identity = raw.identity
  let contacts = raw.at("contacts", default: (left: (), right: ()))
  let companies = raw.companies.map(c => (..c, id: c.at("id", default: lower(c.name).replace(" ", "-"))))
  let certificates = raw.at("certificates", default: ()).map(c => if type(c) == array {
    assert.eq(c.len(), 4, message: "Certificate record requires four values")
    (title: c.at(0), scope: c.at(1), issued: c.at(2), review: c.at(3))
  } else { c })
  (identity: identity, contacts: contacts, profile: raw.at("profile", default: ""), companies: companies,
    certificates: certificates, education: raw.at("education_entries", default: ()),
    languages: raw.at("language_entries", default: ()),
    disclosure: raw.at("disclosure", default: "FICTIONAL CANDIDATE & AI PORTRAIT / DESIGN STUDY"),
    // Presentation wording is a template input, not a candidate fact: a
    // template's adapter supplies it (see templates/flagship/adapter).
    copy: raw.at("copy", default: (:)))
}

#let required-text(value, field) = assert(type(value) == str and value.trim() != "", message: "Required text: " + field)

#let validate-candidate(candidate, show-vessel-durations) = {
  required-text(candidate.identity.name, "identity.name")
  required-text(candidate.identity.rank, "identity.rank")
  assert(type(show-vessel-durations) == bool, message: "show-vessel-durations must be boolean")
  assert.eq(candidate.companies.map(c => c.id).dedup().len(), candidate.companies.len(), message: "Company IDs must be unique; use page fragments for continuations")
  for side in ("left", "right") {
    for item in candidate.contacts.at(side, default: ()) {
      required-text(item.label, "contact label")
      required-text(item.value, "contact value")
      if "href" in item { required-text(item.href, "contact href") }
    }
  }
  for company in candidate.companies {
    required-text(company.id, "company.id")
    required-text(company.name, "company.name")
    required-text(company.period, "company.period")
    let _ = company-months(company)
    for group in company.groups {
      required-text(group.type, "vessel type")
      for ship in group.ships {
        for key in ("id", "name", "rank") { required-text(ship.at(key), "vessel." + key) }
        if show-vessel-durations {
          assert(ship.at("months", default: none) != none, message: "Visible vessel durations require months: " + ship.name)
        }
      }
    }
  }
  for cert in candidate.certificates {
    for key in ("title", "scope", "issued", "review") { required-text(cert.at(key), "certificate." + key) }
  }
  for entry in candidate.education {
    required-text(entry.qualification, "education.qualification")
    required-text(entry.institution, "education.institution")
  }
  for entry in candidate.languages {
    required-text(entry.name, "language.name")
    required-text(entry.level, "language.level")
  }
}
