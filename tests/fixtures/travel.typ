// Hanami and the travel domain on the tour-leader example: the other two themes, a record without a
// portrait, the same twin on travel contract version 1, the totals over the full record, and each
// loud failure (no shrinking, constitution 4; a version 2 field on a version 1 record).
#import "../../packages/domains/travel/lib.typ": hanami, hanami-themes, hanami-artwork, hanami-layouts, destination-totals
#let raw = json("../../examples/candidates/tour-leader-example.json")
#let case = sys.inputs.at("case", default: "indigo")
// The totals rule (constitution 6): two trips, 12 + 18 days, 14 distinct stops (Osaka is on both).
#assert.eq(destination-totals(raw.destinations), (trips: 2, days: 30, stops: 14))
#let job = raw.experience.at(0)
// The twin follows version 2; without its trips' roles and its licence it is a version 1 record.
#let unroled = raw.destinations.trips.map(t => { let c = t; let _ = c.remove("role"); c })
#let v1 = { let r = raw; let _ = r.remove("domainContract"); let _ = r.remove("licences"); (..r, destinations: (..raw.destinations, trips: unroled)) }
#let first-trip = raw.destinations.trips.at(0)
#let with-trip(r, trip) = (..r, destinations: (..r.destinations, trips: (trip,) + r.destinations.trips.slice(1)))
#let candidate = {
  if case in ("indigo", "sky") { raw }
  else if case == "no-portrait" { (..raw, identity: (..raw.identity, portrait: none)) }
  else if case == "no-destinations" { let r = raw; let _ = r.remove("destinations"); r }
  else if case == "bad-month" { (..raw, experience: ((..job, from: "2022-03"),) + raw.experience.slice(1)) }
  else if case == "overflow" { (..raw, experience: ((..job, bullets: job.bullets + job.bullets),) + raw.experience.slice(1)) }
  else if case == "long-name" { (..raw, identity: (..raw.identity, name: "Andreas Konstantinos Kalamaris-Papadopoulos")) }
  else if case == "bad-variation" { raw }
  else if case == "v1" { v1 }
  else if case == "v1-role" { with-trip(v1, first-trip) }
  else if case == "v1-licence" { (..v1, licences: raw.licences) }
  else if case == "no-role" { let t = first-trip; let _ = t.remove("role"); with-trip(raw, t) }
  else if case == "bad-role" { with-trip(raw, (..first-trip, role: "guided")) }
  else if case == "bad-licence-date" { (..raw, licences: ((..raw.licences.at(0), until: "03/2029"),)) }
  else if case == "unknown-version" { (..raw, domainContract: 3) }
  else { panic("unknown case: " + case) }
}
#let theme = if case == "sky" { hanami-themes.sky } else if case == "indigo" { hanami-themes.indigo } else { hanami-themes.sakura }
#show: hanami.with(candidate: candidate, theme: theme, artwork: hanami-artwork.japan, layout: hanami-layouts.showcase,
  variation: if case == "bad-variation" { "essential" } else { "showcase" })
