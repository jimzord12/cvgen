// The Sign-off text draft (scripts/text-draft.typ) with a fictional client:
// a check page in Greek, then the content in English.
#import "/scripts/text-draft.typ": text-draft

#show: text-draft.with(
  title: "Eleni Example - CV text",
  version: "Draft 01, 25 Sep 2026",
  lang: "en",
  check-lang: "el",
  check: [
    Καλημέρα! Αυτό είναι το κείμενο του βιογραφικού σας, χωρίς σχέδιο.

    Ελέγξτε μόνο: ονόματα, ημερομηνίες, αριθμούς και τίτλους. Τη διατύπωση
    την αναλαμβάνουμε εμείς.

    Αν όλα είναι σωστά, απαντήστε «ΟΚ».
  ],
)

= Profile
Licensed tour guide with seven years of walking and cultural tours in Athens
and Kyoto, in English, Greek and Japanese.

= Experience
== Senior Guide, Example Tours, Mar 2021 - Aug 2026
- Led 600 small-group tours; average rating 4.9 of 5 over 2,100 reviews.
- Designed a tea-house route now sold as the company's best-selling day tour.
