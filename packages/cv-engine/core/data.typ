// Pure data operations shared by every domain. This module never reads a
// file or draws content, and knows nothing about any one field's facts: the
// experience model (companies, vessels, projects, ...) belongs to the domain.
#let duration-parts(months) = {
  assert(type(months) == int and months >= 0, message: "Service months must be a non-negative integer")
  (years: calc.quo(months, 12), months: calc.rem(months, 12))
}

#let required-text(value, field) = assert(type(value) == str and value.trim() != "", message: "Required text: " + field)

// The common facts: identity, contacts, profile, certificates, education,
// languages, disclosure and the record's own `copy`. A domain adds its own
// sections on top (`normalize-candidate` in domains/<domain>/data.typ).
#let normalize-common(raw) = {
  assert("identity" in raw, message: "Candidate requires identity")
  let certificates = raw.at("certificates", default: ()).map(c => if type(c) == array {
    assert.eq(c.len(), 4, message: "Certificate record requires four values")
    (title: c.at(0), scope: c.at(1), issued: c.at(2), review: c.at(3))
  } else { c })
  (identity: raw.identity, contacts: raw.at("contacts", default: (left: (), right: ())),
    profile: raw.at("profile", default: ""), certificates: certificates,
    education: raw.at("education_entries", default: ()), languages: raw.at("language_entries", default: ()),
    disclosure: raw.at("disclosure", default: "FICTIONAL CANDIDATE & AI PORTRAIT / DESIGN STUDY"),
    // Presentation wording is a template input, not a candidate fact: the
    // domain and the template's adapter supply it.
    copy: raw.at("copy", default: (:)))
}

#let validate-common(candidate) = {
  required-text(candidate.identity.name, "identity.name")
  for side in ("left", "right") {
    for item in candidate.contacts.at(side, default: ()) {
      required-text(item.label, "contact label")
      required-text(item.value, "contact value")
      if "href" in item { required-text(item.href, "contact href") }
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
