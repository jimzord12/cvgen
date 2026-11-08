// Hanami and the travel domain on the tour-leader example: the other two themes, a record without a
// portrait, the totals over the full record, and each loud failure (no shrinking, constitution 4):
// the page slots, and every field Hanami places outside them (rank tab, contacts, route labels, the
// page-2 band block), the highlights row, a second story, a record without destinations.
#import "../../packages/domains/travel/lib.typ": hanami, hanami-themes, hanami-artwork, hanami-layouts, destination-totals
#let raw = json("../../examples/candidates/tour-leader-example.json")
#let case = sys.inputs.at("case", default: "indigo")
// The totals rule (constitution 6): two trips, 12 + 18 days, 14 distinct stops (Fukuoka is on both).
#assert.eq(destination-totals(raw.destinations), (trips: 2, days: 30, stops: 14))
#let job = raw.experience.at(0)
#let left = raw.contacts.left
#let places = raw.destinations
#let candidate = {
  if case in ("indigo", "sky") { raw }
  else if case == "no-portrait" { (..raw, identity: (..raw.identity, portrait: none)) }
  else if case == "no-destinations" { let r = raw; let _ = r.remove("destinations"); r }
  else if case == "bad-month" { (..raw, experience: ((..job, from: "2022-03"),) + raw.experience.slice(1)) }
  else if case == "overflow" { (..raw, experience: ((..job, bullets: job.bullets + job.bullets),) + raw.experience.slice(1)) }
  else if case == "long-name" { (..raw, identity: (..raw.identity, name: "Andreas Konstantinos Kalamaris-Papadopoulos")) }
  else if case == "long-rank" { (..raw, identity: (..raw.identity, rank: "Senior Tour Leader and Escort")) }
  else if case == "long-contact" {
    (..raw, contacts: (..raw.contacts, right: raw.contacts.right.slice(0, 1) + ((label: "Nationality", value: "Greek and Cypriot, dual citizenship since 2015"),) + raw.contacts.right.slice(2)))
  }
  else if case == "long-city" { (..raw, destinations: (..places, route: (..places.route, from: (code: "SKG", city: "Thessaloniki Makedonia Airport")))) }
  else if case == "many-links" {
    (..raw, contacts: (..raw.contacts, right: raw.contacts.right.slice(0, 2) + ((label: "Website", value: "kalamaris-travel.example", href: "https://kalamaris-travel.example"),)))
  }
  else if case == "five-cells" { (..raw, highlights: raw.highlights + (raw.highlights.at(0),)) }
  else if case == "two-stories" {
    let (first, second) = places.trips
    (..raw, destinations: (..places, trips: ((..first, story: second.story), second)))
  }
  else if case == "bad-variation" { raw }
  else { panic("unknown case: " + case) }
}
#let theme = if case == "sky" { hanami-themes.sky } else if case == "indigo" { hanami-themes.indigo } else { hanami-themes.sakura }
#show: hanami.with(candidate: candidate, theme: theme, artwork: hanami-artwork.japan, layout: hanami-layouts.showcase,
  variation: if case == "bad-variation" { "essential" } else { "showcase" })
