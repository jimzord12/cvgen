// Words Hanami owns, in English. The field's words come from the travel domain; a record's `copy`
// or the call site's overrides any of them, so a Greek CV passes its words (and lang: "el") there.
#let hanami-copy = (
  lang: "en",
  // the Japanese word beside the rank on the name plate's tab; "" for none
  tab-native: "添乗員",
  // an optional word for the employers before the places in the experience subtitle
  experience-kind: "", and-word: "and",
  destinations-title: auto, by-trip: "trip by trip", stamp-line: "One stamp for each trip",
  education-subtitle: "Studies, training and languages",
  // essential (one page): its section titles, the words of its totals and the earlier roles' summary
  education: "Education", languages: "Languages", destinations: "Destinations", contacts: "Contacts",
  place: "place", places: "places", earlier: "Earlier roles",
  // a licence's month, in the page's words (the record stores "31 Mar 2029")
  months: ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
)
