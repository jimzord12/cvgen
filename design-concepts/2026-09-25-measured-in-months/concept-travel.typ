// Measured in Months - the same page on a travel and tourism record.
// Same render function as concept.typ; only the adapter and the words differ.
// The data is a fictional sketch in this folder, not a schema.
#import "concept.typ": render, title-case

#let travel(d) = (
  name: d.identity.name,
  rank: title-case(d.identity.role),
  discipline: d.discipline,
  contacts: d.contacts,
  profile: d.profile,
  employers: d.employers.map(e => (
    name: e.name, period: e.period, groups: e.types,
    entries: e.placements.map(p => (id: p.id, name: p.name, role: p.role, months: p.months)),
  )),
  certificates: d.certificates,
  education: d.education,
  languages: d.languages,
  words: (
    head-left: "Curriculum vitae - hospitality record",
    months-cap: [months\ in post],
    units-cap: [seasons &\ contracts],
    employers-cap: [employers],
    equals: [Months in post from the record:],
    years: "years", months-short: "months",
    unit-name: s => s.name,
    legend: [Each bar is one season, voyage or contract, drawn to its months; employers run oldest to newest, left to right. Ruler in cumulative months in post, not years. Current employer in red.],
    ledger-title: "Employers",
    ledger-note: "newest first",
    ledger-cols: ("Period", "Employer", "Property type", "Role", "Posts", "Months"),
    total-row: "Total in post",
    certs-title: "Certificates & licences",
    cert-cols: ("Certificate", "Scope / record", "Valid to"),
    edu-title: "Education",
    lang-title: "Languages",
    footer-left: [#title-case(d.identity.name) - #title-case(d.identity.role)],
    footer-right: [Fictional candidate - design concept "Measured in Months", travel variant, CVgen 2026-09-25],
  ),
)

#render(travel(json("travel-sample.json")))
