// Hanami and the travel domain on the tour-leader example: the other two themes, a record without a
// portrait, the same twin on travel contract version 1, the totals over the full record, and each
// loud failure (no shrinking, constitution 4): the page slots, and every field Hanami places outside
// them (rank tab, contacts, route labels, the page-2 band block), the highlights row, a second story,
// a record without destinations, and a version 2 field on a version 1 record.
#import "../../packages/domains/travel/lib.typ": hanami, hanami-themes, hanami-artwork, hanami-layouts, destination-totals
#let raw = json("../../examples/candidates/tour-leader-example.json")
#let case = sys.inputs.at("case", default: "indigo")
// The totals rule (constitution 6): two trips, 12 + 18 days, 14 distinct stops (Fukuoka is on both).
#assert.eq(destination-totals(raw.destinations), (trips: 2, days: 30, stops: 14))
#let job = raw.experience.at(0)
// The twin follows version 2; without its trips' roles and its licence it is a version 1 record.
#let unroled = raw.destinations.trips.map(t => { let c = t; let _ = c.remove("role"); c })
#let v1 = { let r = raw; let _ = r.remove("domainContract"); let _ = r.remove("licences"); (..r, destinations: (..raw.destinations, trips: unroled)) }
#let first-trip = raw.destinations.trips.at(0)
#let with-trip(r, trip) = (..r, destinations: (..r.destinations, trips: (trip,) + r.destinations.trips.slice(1)))
#let left = raw.contacts.left
#let places = raw.destinations
#let candidate = {
  if case in ("indigo", "sky", "monochrome") { raw }
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
  else if case == "long-native" { (..raw, destinations: (..places, native: "日本・韓国・台湾")) }
  else if case == "long-stamp-kanji" {
    let (first, second) = places.trips
    (..raw, destinations: (..places, trips: ((..first, stamp: (..first.stamp, kanji: "福岡・長崎・熊本")), second)))
  }
  else if case == "long-region" { (..raw, destinations: (..places, region: "Japan and the Korean Peninsula")) }
  else if case == "bad-variation" { raw }
  else if case == "v1" { v1 }
  else if case == "v1-role" { with-trip(v1, first-trip) }
  else if case == "v1-licence" { (..v1, licences: raw.licences) }
  else if case == "no-role" { let t = first-trip; let _ = t.remove("role"); with-trip(raw, t) }
  else if case == "bad-role" { with-trip(raw, (..first-trip, role: "guided")) }
  else if case == "bad-licence-date" { (..raw, licences: ((..raw.licences.at(0), until: "03/2029"),)) }
  else if case == "no-such-day" { (..raw, licences: ((..raw.licences.at(0), until: "31 Feb 2029"),)) }
  else if case == "leap-day" { (..raw, licences: ((..raw.licences.at(0), until: "29 Feb 2028"),)) }
  // A led trip with a long period: the role sits under the stamp, so it never wraps under the period.
  else if case == "led-long-period" { with-trip(raw, (..first-trip, role: "led", period: "September 2024")) }
  else if case == "long-role" { raw }
  // A licence too long for one line, so the issuer, region and date take a second line (the story makes room).
  else if case == "two-line-licence" {
    let (first, second) = places.trips
    let _ = second.remove("story")
    (..raw, destinations: (..places, trips: (first, second)),
      licences: ((title: "Tour Leader Licence", issuer: "Regional Tourism Directorate", region: "Greece and the EU", until: "31 Mar 2029"),))
  }
  else if case == "long-licence" { (..raw, licences: ((..raw.licences.at(0), title: "Licensed Tour Leader and Escort for Group Travel in Greece, Cyprus and the European Union"),)) }
  else if case == "unknown-version" { (..raw, domainContract: 3) }
  else { panic("unknown case: " + case) }
}
#let theme = if case == "sky" { hanami-themes.sky } else if case == "indigo" { hanami-themes.indigo } else if case == "monochrome" { hanami-themes.monochrome } else { hanami-themes.sakura }
#show: hanami.with(candidate: candidate, theme: theme, artwork: hanami-artwork.japan, layout: hanami-layouts.showcase,
  copy: if case == "long-role" { (role-organised: "Organised it for the whole group") } else { (:) },
  variation: if case == "bad-variation" { "calm" } else { "showcase" })
