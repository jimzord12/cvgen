// Hanami essential (TASK-79) on the tour-leader twin and a long career, both travel contract version 2:
// the other two themes, a record without a portrait or without a licence, Greek wording, the earlier roles' summary with its totals, and each loud
// failure (no shrinking and no second page, constitution 4).
#import "../../packages/domains/travel/lib.typ": hanami, hanami-themes, hanami-layouts, hanami-artwork, experience-totals
#let raw = json("../../examples/candidates/tour-leader-example.json")
#let long = json("tour-leader-long-career.json")
#let sparse = json("tour-leader-sparse.json")
#let case = sys.inputs.at("case", default: "indigo")
// The totals rule (constitution 6): the older roles' count and span come from the record.
#assert.eq(experience-totals(long.experience.slice(2)), (roles: 6, from: "06/2005", to: "02/2015"))
#assert.eq(experience-totals(long.experience), (roles: 8, from: "06/2005", to: none))
#let greek = (
  lang: "el", experience: "Εμπειρία", education: "Σπουδές", languages: "Γλώσσες", destinations: "Προορισμοί",
  practical: "Πρακτικές γνώσεις", references: "Συστάσεις", present: "σήμερα", trip: "ταξίδι", trips: "ταξίδια",
  days: "ημέρες", place: "τόπος", places: "τόποι", known: "Γνωρίζει καλά", passed: "Στάση στη διαδρομή",
  earlier: "Παλαιότερες θέσεις", licence: "Άδεια", valid-until: "Ισχύει έως",
  role-led: "Οδήγησε την ομάδα", role-organised: "Οργάνωσε", role-travelled: "Ταξίδεψε",
  months: ("Ιαν", "Φεβ", "Μαρ", "Απρ", "Μαΐ", "Ιουν", "Ιουλ", "Αυγ", "Σεπ", "Οκτ", "Νοε", "Δεκ"),
)
#let job = raw.experience.at(0)
// A Greek record proves Greek capitals (no accents, tracked) fit the band, the tab and the labels:
// the record's own words are data, so the fixture translates them.
#let greek-record = (..raw,
  identity: (..raw.identity, name: "Ανδρέας Καλαμάρης", rank: "Αρχηγός ομάδας", specialty: "Ειδικός στην Ιαπωνία",
    seal: ("Σεμινάριο αρχηγών", "TTI", "2024")),
  contacts: (
    left: (("Έδρα", "Θεσσαλονίκη"), ("Τηλέφωνο", "+30 699 000 0471"), ("Email", "andreas.kalamaris@example.com")).map(((l, v)) => (label: l, value: v)),
    right: (("Ημερομηνία γέννησης", "18 Αυγούστου 1999"), ("Υπηκοότητα", "Ελληνική"), ("Ιαπωνικά", "JLPT N3")).map(((l, v)) => (label: l, value: v)),
  ),
  availability: (headline: "Διαθέσιμος όλο τον χρόνο", text: "Από τον Μάρτιο του 2027, σε κάθε εποχή, με ειδοποίηση δύο εβδομάδων."),
  experience: ((..job, support: (..job.support, lead: "Για παράδειγμα")),) + raw.experience.slice(1),
)
#let candidate = {
  if case in ("indigo", "sky", "showcase-layout") { raw }
  else if case == "greek" { greek-record }
  else if case == "no-portrait" { (..raw, identity: (..raw.identity, portrait: none)) }
  else if case in ("long-career", "long-career-greek") { long }
  else if case == "overflow" { (..raw, experience: ((..job, bullets: job.bullets * 5),) + raw.experience.slice(1)) }
  else if case == "unsorted" { (..long, experience: long.experience.rev()) }
  else if case == "long-name" { (..raw, identity: (..raw.identity, name: "Andreas Konstantinos Kalamaris-Papadopoulos")) }
  else if case == "sparse" { sparse }
  else if case == "no-licence" { let r = raw; let _ = r.remove("licences"); r }
  else { panic("unknown case: " + case) }
}
#let theme = if case == "sky" { hanami-themes.sky } else if case in ("indigo", "long-career") { hanami-themes.indigo } else { hanami-themes.sakura }
#show: hanami.with(candidate: candidate, theme: theme, artwork: hanami-artwork.japan, variation: "essential",
  layout: if case == "showcase-layout" { hanami-layouts.showcase } else { hanami-layouts.essential },
  copy: if case in ("greek", "long-career-greek") { greek } else { (:) })
