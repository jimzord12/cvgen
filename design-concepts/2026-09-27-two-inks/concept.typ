// Two Inks: a Text Draft direction for CVgen (idea run 2026-09-27).
// The draft is printed, as it were, in two inks on two drums: black carries our
// wording; a hot copper-orange, laid down first and a hair out of register,
// sits under every fact the Client must check, and prints the giant forms.
// Two pages: the Check Page (Greek) and the first CV-content page (English).
//
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path design-concepts/fonts design-concepts/2026-09-27-two-inks/concept.typ design-concepts/2026-09-27-two-inks/concept.pdf

#let data = json("/examples/candidates/chief-officer-example.json")

// ---- Per-client parameters (words); the design below is fixed ---------------
#let client = (
  first-el: "Ελένη",
  name-en: ("Eleni", "Markou"), // the record says ELENI MARKOU; set here in the CV's own case
  draft: "01", date-el: "27.09.2026", date-en: "27 Sep 2026", pages: 3,
)
#let check = (
  kicker: "Προσχέδιο κειμένου",
  head: ([#client.first-el,], [ελέγξτε], [μόνο το]),
  orange-word: "πορτοκαλί.",
  intro: [Αυτό είναι το κείμενο του βιογραφικού σας, πριν από το σχέδιο. Δικό σας είναι ό,τι έχει πορτοκαλί φόντο:],
  items: (
    ("Ονόματα", "Boreal Gas Carriers"),
    ("Ημερομηνίες", "2023 – 2026"),
    ("Αριθμοί", "6 months"),
    ("Τίτλοι", "Chief Officer"),
  ),
  ours: [Το μαύρο είναι δικό μας: τη διατύπωση την αναλαμβάνουμε εμείς.],
  ok-lead: ([Όλα σωστά;], [Απαντήστε:]),
  fix: [Κάτι λάθος; Γράψτε μας τη σελίδα και το σωστό.],
)

// ---- House design --------------------------------------------------------
#let paper = rgb("#F6F3ED")
#let black = rgb("#1E1D1B")
#let orange = rgb("#FF6A2B")   // the second drum: hot copper
#let quiet = rgb("#66625C")
#let face = "Syne"
// The orange drum is a hair out of register with the black one, the same on the whole page.
#let drift = (x: 0.7mm, y: 0.3mm)

// A fact: black text overprinting an orange slab laid a hair out of register.
#let fact(body, pad: 0.14em) = box(context {
  let m = measure(body)
  // the black letters print over a solid orange slab: a fact is whatever sits on orange
  place(top + left, dx: -pad + drift.x, dy: -0.16em + drift.y,
    rect(width: m.width + 2 * pad, height: m.height + 0.38em, fill: orange))
  body
})
// A giant form printed in orange only.
#let ink2(dx, dy, body) = place(top + left, dx: dx + drift.x, dy: dy + drift.y, text(fill: orange, body))

#let label(s) = text(size: 7.5pt, weight: 600, tracking: 0.14em, fill: quiet, upper(s))

#set document(title: client.name-en.join(" ") + " – CV text – draft " + client.draft)
#set page(paper: "a4", fill: paper, margin: (x: 16mm, top: 16mm, bottom: 14mm))
#set text(font: face, fill: black, size: 11pt, lang: "el", number-type: "lining")
#set par(justify: false)

// =========================== PAGE 1: CHECK PAGE ===========================
#page(background: {
  // orange drum: the draft number, cropped by the sheet, and the reply disc
  ink2(96mm, 2mm, text(size: 230pt, weight: 800, tracking: -0.05em, client.draft))
  place(top + left, dx: -38mm + drift.x, dy: 214mm + drift.y, circle(radius: 58mm, fill: orange))
})[
  #text(size: 12pt, weight: 800)[CVgen] #h(4mm) #text(size: 10pt, weight: 500, fill: quiet)[#check.kicker #client.draft · #client.date-el]

  #v(20mm)
  #block(text(size: 52pt, weight: 800, tracking: -0.02em, {
    set par(leading: 0.2em)
    let h = check.head
    h.at(0); linebreak(); h.at(1); linebreak(); h.at(2); linebreak()
    fact(check.orange-word)
  }))

  #v(6mm)
  #block(width: 178mm, text(size: 17pt, weight: 500, check.intro))

  #v(5mm)
  #for (kind, sample) in check.items {
    block(above: 0mm, below: 0mm, height: 12mm, grid(columns: (66mm, 1fr), align: (left + bottom, left + bottom),
      text(size: 20pt, weight: 700, kind),
      text(size: 20pt, weight: 600, lang: "en", fact(sample)),
    ))
  }
  #v(5mm)
  #text(size: 14pt, weight: 500, fill: quiet, check.ours)

  #place(bottom + left, dy: -52mm, text(size: 26pt, weight: 800, check.ok-lead.join(" ")))
  #place(bottom + left, dx: -1mm, dy: 4mm, text(size: 140pt, weight: 800, tracking: -0.04em)[OK])
  #place(bottom + right, dy: -3mm, block(width: 54mm, text(size: 15pt, weight: 600, check.fix)))
]

// ====================== PAGE 2: FIRST CV-CONTENT PAGE ======================
#let months-total = data.companies.map(c => c.groups.map(g => g.ships.map(s => s.months).sum()).sum()).sum()
#let vessels-total = data.companies.map(c => c.groups.map(g => g.ships.len()).sum()).sum()
#let title-case(s) = s.split(" ").map(w => upper(w.first()) + lower(w.slice(1))).join(" ")

#page[
  #set text(lang: "en")
  #label("CV text · draft " + client.draft + " · " + client.date-en) #h(1fr) #label("Page 2 / " + str(client.pages))

  #v(10mm)
  #block(text(size: 84pt, weight: 800, tracking: -0.03em, {
    set par(leading: 0.42em)
    fact(client.name-en.at(0)); linebreak(); fact(client.name-en.at(1))
  }))
  #v(4mm)
  #text(size: 24pt, weight: 700, fact(title-case(data.identity.rank)))

  #v(8mm)
  #let contacts = data.contacts.left + data.contacts.right
  #grid(columns: (1fr, 1fr, 1fr), column-gutter: 5mm, row-gutter: 6.5mm,
    ..contacts.map(c => block({ label(c.label); v(1.6mm); text(size: 10.5pt, weight: 500, fact(c.value)) })))

  #v(6mm)
  #block(width: 160mm, {
    set par(leading: 0.75em)
    show "six": fact
    text(size: 12pt, data.profile)
  })

  #v(8mm)
  #text(size: 22pt, weight: 800)[Sea service] #h(4mm)
  #text(size: 12pt, weight: 600)[#fact(str(months-total) + " months") · #fact(str(vessels-total) + " vessels") · #fact(str(data.companies.len()) + " companies")]
  #v(0.5mm)
  #text(size: 9pt, fill: quiet)[Months as recorded, vessel by vessel.]

  #let row(a, b, c, d) = grid(columns: (40mm, 1fr, 40mm, 20mm), align: (left, left, left, right), a, b, c, d)
  #for co in data.companies.slice(0, 2) {
    block(above: 6.5mm, below: 0mm, breakable: false, {
      grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
        text(size: 13pt, weight: 700, fact(co.name)), text(size: 11pt, weight: 600, fact(co.period)))
      for g in co.groups {
        for (k, s) in g.ships.enumerate() {
          block(above: 3.6mm, below: 0mm, text(size: 10.5pt, weight: 500, row(
            if k == 0 { text(size: 8pt, weight: 600, tracking: 0.08em, fill: quiet, upper(g.type)) },
            fact(s.name), fact(s.rank), fact(str(s.months) + " months"))))
        }
      }
    })
  }
  #place(bottom + right, text(size: 9pt, weight: 600, fill: quiet)[Sea service continues on page 3 →])
]
