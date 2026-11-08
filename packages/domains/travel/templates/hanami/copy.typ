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
)
