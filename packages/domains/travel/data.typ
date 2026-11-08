// The travel facts: roles at travel employers, the destinations a person knows (trips with
// their stops, the areas known well), availability and practical know-how. Totals are computed
// once from the full record (constitution 6): the number of trips, their days and the distinct
// stops; a page prints them and never counts what it shows.
#import "../../cv-framework/core/data.typ": required-text, normalize-common, validate-common

// The closed list of drawings a trip's stamp and a highlight's icon may name; each is an SVG under
// assets/japan/ (stamp-<art>.svg, icon-<icon>.svg). A new drawing is added here and in the schema.
#let stamp-arts = ("fuji", "flag", "torii-maple", "alps-maple", "torii-blossom", "snow", "book")
#let highlight-icons = ("torii", "check", "support", "cap")

// "MM/YYYY": the month and year a role starts or ends. Display text, checked so a typo fails here.
#let month-year(value, field) = {
  required-text(value, field)
  assert(value.match(regex("^(0[1-9]|1[0-2])/[0-9]{4}$")) != none,
    message: field + " must be MM/YYYY, e.g. 03/2022; got " + value)
  value
}

// The destination totals over the full record: trips, their days, and distinct stops by name.
#let destination-totals(destinations) = {
  if destinations == none { return (trips: 0, days: 0, stops: 0) }
  let trips = destinations.trips
  (trips: trips.len(), days: trips.map(t => t.days).sum(default: 0),
    stops: trips.map(t => t.stops.map(s => s.name)).flatten().dedup().len())
}

#let normalize-candidate(raw) = {
  assert("experience" in raw, message: "Candidate requires experience: a list of roles")
  let common = normalize-common(raw)
  (..common, highlights: raw.at("highlights", default: ()), experience: raw.experience,
    destinations: raw.at("destinations", default: none), availability: raw.at("availability", default: none),
    practical: raw.at("practical", default: none), references: raw.at("references", default: none))
}

#let validate-candidate(candidate) = {
  validate-common(candidate)
  required-text(candidate.identity.rank, "identity.rank")
  for word in candidate.identity.at("seal", default: ()) { required-text(word, "identity.seal") }
  for cell in candidate.highlights {
    assert(cell.icon in highlight-icons, message: "highlights.icon must be one of " + highlight-icons.join(", ") + "; got " + cell.icon)
    required-text(cell.title, "highlights.title")
    required-text(cell.text, "highlights.text")
  }
  assert(candidate.experience.len() > 0, message: "Experience needs at least one role")
  for job in candidate.experience {
    for key in ("role", "employer", "place") { required-text(job.at(key), "experience." + key) }
    let _ = month-year(job.from, "experience.from")
    if "to" in job { let _ = month-year(job.to, "experience.to") }
    assert(job.bullets.len() > 0, message: "Each role needs at least one bullet: " + job.role)
    for bullet in job.bullets { required-text(bullet, "experience.bullets") }
    let support = job.at("support", default: none)
    if support != none {
      for key in ("figure", "text", "lead") { required-text(support.at(key), "experience.support." + key) }
      for case in support.cases { required-text(case.place, "support.cases.place"); required-text(case.text, "support.cases.text") }
    }
  }
  let places = candidate.destinations
  if places != none {
    required-text(places.region, "destinations.region")
    assert(places.trips.len() > 0, message: "destinations needs at least one trip")
    for trip in places.trips {
      required-text(trip.period, "trip.period")
      required-text(trip.kind, "trip.kind")
      assert(type(trip.days) == int and trip.days > 0, message: "trip.days must be a positive whole number: " + trip.period)
      assert(trip.stops.len() > 0, message: "A trip needs at least one stop: " + trip.period)
      for stop in trip.stops { required-text(stop.name, "trip.stops.name") }
      let stamp = trip.at("stamp", default: none)
      if stamp != none {
        assert(stamp.art in stamp-arts, message: "stamp.art must be one of " + stamp-arts.join(", ") + "; got " + stamp.art)
        assert(stamp.rim.len() >= 2, message: "A stamp's rim needs at least two words: " + trip.period)
      }
    }
  }
  let practical = candidate.practical
  if practical != none {
    required-text(practical.lead, "practical.lead")
    for item in practical.items { required-text(item, "practical.items") }
  }
  let _ = destination-totals(places)
}
