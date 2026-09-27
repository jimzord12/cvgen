// The Text Draft (scripts/text-draft.typ) with a fictional client:
// the Check Page in Greek, then the content in English with checked facts marked.
#import "/scripts/text-draft.typ": text-draft, fact

#show: text-draft.with(
  title: "Eleni Example - CV text - draft 01",
  client: (name: "Ελένη Παράδειγμα", greeting: "Ελένη", label: "Πελάτισσα"),
  draft: "01",
  date: "27.09.2026",
  samples: (
    ("Ονόματα", "Example Tours"),
    ("Ημερομηνίες", "2021 – 2026"),
    ("Αριθμούς", "600 tours"),
    ("Τίτλους", "Senior Guide"),
  ),
  lang: "en",
  check-lang: "el",
)

= Profile
Licensed tour guide with #fact[seven years] of walking and cultural tours in
#fact[Athens] and #fact[Kyoto], in English, Greek and Japanese. Known for small
groups, quiet routes and tours that end where the guests did not expect.

= Experience
== #fact[Senior Guide], #fact[Example Tours], #fact[Mar 2021 – Aug 2026]
- Led #fact[600] small-group tours; average rating #fact[4.9 of 5] over #fact[2,100] reviews.
- Designed a tea-house route now sold as the company's best-selling day tour.
- Trained #fact[12] new guides in route planning and group safety.

== #fact[Guide], #fact[Kyoto Walks], #fact[Apr 2019 – Feb 2021]
- Ran morning temple walks and evening food tours in English and Greek.
- Wrote the company's first Greek-language tour notes.

= Education
== #fact[Tourist Guide Licence], #fact[School of Tourist Guides, Athens], #fact[2019]
- Two-year state programme: history, archaeology, first aid, group management.

= Languages
Greek (native), English (#fact[C2]), Japanese (#fact[JLPT N2]).

= Certificates
- First aid, #fact[valid until Mar 2027].
- Accessible tourism, #fact[2024].
