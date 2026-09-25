// The Text Draft house design (scripts/text-draft.typ) with a fictional client: a check page
// in Greek, then the content in English. Also the model the new-client skill copies.
#import "/scripts/text-draft.typ": text-draft

#show: text-draft.with(
  name: "Eleni Example",
  role: "Licensed tour guide · Athens and Kyoto",
  version: "Draft 01 · 25 Sep 2026",
  lang: "en",
  check-lang: "el",
  labels: (
    kicker: "Το κείμενο του βιογραφικού σας, για έλεγχο",
    reply: "Αν όλα είναι σωστά, απαντήστε «ΟΚ».",
    confidential: "Εμπιστευτικό",
    prepared: "Για την",
  ),
  check: [
    Στις επόμενες σελίδες είναι το κείμενο του βιογραφικού σας, πριν πάρει
    την τελική του μορφή. Η διατύπωση είναι δική μας δουλειά· από εσάς
    χρειαζόμαστε μόνο τρεις ελέγχους:

    + *Ονόματα:* το δικό σας, των εταιρειών, των σχολών και των πιστοποιήσεων.
    + *Ημερομηνίες:* μήνας και έτος για κάθε θέση και κάθε πτυχίο.
    + *Αριθμοί και τίτλοι:* ό,τι μετριέται, και ο τίτλος κάθε θέσης σας.
  ],
)

= Profile
Licensed tour guide with seven years of walking and cultural tours in Athens
and Kyoto, in English, Greek and Japanese.

= Experience
== Senior Guide · Example Tours, Athens · Mar 2021 – Aug 2026
- Led 600 small-group tours; average rating 4.9 of 5 across 2,100 reviews.
- Designed a tea-house route in Kyoto, now the company's best-selling day tour.

= Languages
Greek (native) · English (C2) · Japanese (JLPT N2)
