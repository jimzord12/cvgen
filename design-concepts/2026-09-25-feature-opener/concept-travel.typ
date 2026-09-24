// Feature Opener - the same page on a travel and tourism record.
// Same render function as concept.typ; only the adapter and the words differ.
// The data is a fictional sketch in this folder, not a schema.
#import "concept.typ": render, title-case, say

#let travel(d) = (
  name: d.identity.name,
  rank: d.identity.role,
  rank-line: title-case(d.identity.role),
  contacts: d.contacts,
  profile: d.profile,
  employers: d.employers.map(e => (
    name: e.name, period: e.period,
    groups: ((type: e.types.join(", "),
      entries: e.placements.map(p => (id: p.id, name: p.name, role: p.role, months: p.months))),),
  )),
  certificates: d.certificates,
  education: d.education,
  languages: d.languages,
  words: (
    department: [Curriculum vitae · #d.discipline],
    running-right: title-case(d.identity.name),
    contents-title: "Career",
    contents-unit: "season or contract · months",
    pull-unit: "months in post",
    pull-line: (y, mo, v, c) => [#title-case(say(y)) years and #say(mo) months, #say(v) seasons and contracts, #say(c) employers.],
    edu-title: "Education",
    lang-title: "Languages",
    certs-title: "Certificates & licences",
    certs-unit: "certificate · valid to",
    issued: "issued",
    footer-right: [Fictional candidate · "Feature Opener", travel · 2026-09-25],
  ),
)

#render(travel(json("travel-sample.json")))
