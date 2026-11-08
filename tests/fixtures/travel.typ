// Hanami and the travel domain on the tour-leader example: the other two themes, a record without a
// portrait, the totals over the full record, and each loud failure (no shrinking, constitution 4).
#import "../../packages/domains/travel/lib.typ": hanami, hanami-themes, hanami-artwork, hanami-layouts, destination-totals
#let raw = json("../../examples/candidates/tour-leader-example.json")
#let case = sys.inputs.at("case", default: "indigo")
// The totals rule (constitution 6): two trips, 12 + 18 days, 14 distinct stops (Osaka is on both).
#assert.eq(destination-totals(raw.destinations), (trips: 2, days: 30, stops: 14))
#let job = raw.experience.at(0)
#let candidate = {
  if case in ("indigo", "sky") { raw }
  else if case == "no-portrait" { (..raw, identity: (..raw.identity, portrait: none)) }
  else if case == "no-destinations" { let r = raw; let _ = r.remove("destinations"); r }
  else if case == "bad-month" { (..raw, experience: ((..job, from: "2022-03"),) + raw.experience.slice(1)) }
  else if case == "overflow" { (..raw, experience: ((..job, bullets: job.bullets + job.bullets),) + raw.experience.slice(1)) }
  else if case == "long-name" { (..raw, identity: (..raw.identity, name: "Andreas Konstantinos Kalamaris-Papadopoulos")) }
  else if case == "bad-variation" { raw }
  else { panic("unknown case: " + case) }
}
#let theme = if case == "sky" { hanami-themes.sky } else if case == "indigo" { hanami-themes.indigo } else { hanami-themes.sakura }
#show: hanami.with(candidate: candidate, theme: theme, artwork: hanami-artwork.japan, layout: hanami-layouts.showcase,
  variation: if case == "bad-variation" { "essential" } else { "showcase" })
