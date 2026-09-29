// Two Inks: a Text Draft direction for CVgen (idea run 2026-09-27).
// The draft is printed, as it were, in two inks on two drums: black carries our
// wording; a hot copper-orange, laid down first and a hair out of register,
// sits under every fact the Client must check, and prints the giant forms.
// Two pages: the Check Page (Greek) and the first CV-content page (English).
//
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path archive/anti-examples/fonts archive/anti-examples/2026-09-27-two-inks/concept.typ archive/anti-examples/2026-09-27-two-inks/concept.pdf
// Long-name case (the typical Greek client; same record, another fictional name):
// typst compile ... --input client=long archive/anti-examples/2026-09-27-two-inks/concept.typ archive/anti-examples/2026-09-27-two-inks/concept-long.pdf

#let data = json("/examples/candidates/chief-officer-example.json")

// ---- Per-client parameters (words); the design below is fixed ---------------
// Sizes are per-client values set by hand. A line wider than the measure stops the
// compile with a message (no automatic shrinking, constitution section 4).
#let clients = (
  eleni: (
    greeting-el: "Ελένη", // vocative
    name-en: ("Eleni", "Markou"), // the record says ELENI MARKOU; set here in the CV's own case
    head-size: 52pt, name-size: 84pt,
  ),
  long: (
    greeting-el: "Κωνσταντίνε", // vocative of Κωνσταντίνος
    name-en: ("Konstantinos", "Papadopoulos"),
    head-size: 44pt, name-size: 42pt,
  ),
)
#let client = clients.at(sys.inputs.at("client", default: "eleni")) + (
  draft: "01", date-el: "27.09.2026", date-en: "27 Sep 2026", pages: 4,
)
#let check = (
  kicker: "Προσχέδιο κειμένου",
  head: (client.greeting-el + ",", "ελέγξτε", "μόνο το"),
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
  fix: [Κάτι λάθος; \ Γράψτε μας \ τη σελίδα \ και το σωστό.],
)

// ---- House design --------------------------------------------------------
#let paper = rgb("#F6F3ED")
#let black = rgb("#1E1D1B")
#let orange = rgb("#FF6A2B")   // the second drum: hot copper
#let quiet = rgb("#66625C")
#let face = "Syne"
// The orange drum is a hair out of register with the black one, the same on the whole page.
#let drift = (x: 0.9mm, y: 0.5mm)

// A fact: black text overprinting an orange slab laid a hair out of register.
#let fact(body) = box(context {
  let m = measure(body)
  // Padding is at least twice the drift, so at text sizes the offset reads as a
  // shifted drum, never as letters touching the slab's edge.
  let px = calc.max(0.3em.to-absolute(), 2 * drift.x)
  let pt = calc.max(0.18em.to-absolute(), 2 * drift.y)
  let pb = calc.max(0.24em.to-absolute(), 2 * drift.y)
  // the black letters print over a solid orange slab: a fact is whatever sits on orange
  place(top + left, dx: -px + drift.x, dy: -pt + drift.y,
    rect(width: m.width + 2 * px, height: m.height + pt + pb, fill: orange))
  body
})
// In running text a fact gets extra space each side, sized to its slab's overhang
// plus a thin space, so the slab clears the neighbouring words.
#let fact-inline(body) = context {
  let px = calc.max(0.3em.to-absolute(), 2 * drift.x)
  h(px - drift.x + 0.08em) + fact(body) + h(px + drift.x + 0.08em)
}
// Registration target, printed by both drums: the orange copy sits off the black one
// by exactly the page's drift, so the offset reads as print, not as sloppy padding.
#let target(r: 3.2mm) = {
  let t(c) = {
    place(circle(radius: r, stroke: 0.5pt + c))
    place(dx: r, dy: -0.8mm, line(length: 2 * r + 1.6mm, angle: 90deg, stroke: 0.5pt + c))
    place(dx: -0.8mm, dy: r, line(length: 2 * r + 1.6mm, stroke: 0.5pt + c))
  }
  place(dx: drift.x, dy: drift.y, t(orange))
  t(black)
}
// A display line must fit the measure; if not, stop and say which size to change.
#let measure-w = 210mm - 2 * 16mm
#let must-fit(what, body) = context {
  let w = measure(body).width
  assert(w <= measure-w, message: what + " is " + repr(w) + " wide but the measure is " + repr(measure-w) + "; set its size by hand in `clients`")
  body
}
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
  place(top + left, dx: -38mm + drift.x, dy: 236mm + drift.y, circle(radius: 58mm, fill: orange))
  place(top + left, dx: 190mm, dy: 286mm, target())
})[
  #text(size: 12pt, weight: 800)[CVgen] #h(4mm) #text(size: 10pt, weight: 500, fill: quiet)[#check.kicker #client.draft · #client.date-el]

  #v(20mm)
  #block({
    set text(size: client.head-size, weight: 800, tracking: -0.02em)
    set par(leading: 0.3em)
    for line in check.head { must-fit("Check Page headline line \"" + line + "\"", line); linebreak() }
    must-fit("Check Page headline line \"" + check.orange-word + "\"", fact(check.orange-word))
  })

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

  #place(bottom + left, dy: -55mm, text(size: 26pt, weight: 800, check.ok-lead.join(" ")))
  #place(bottom + left, dx: -1mm, dy: 4mm, text(size: 140pt, weight: 800, tracking: -0.04em)[OK])
  #place(bottom + right, dy: -1mm, block(width: 52mm, text(size: 18pt, weight: 600, check.fix)))
]

// ====================== PAGE 2: FIRST CV-CONTENT PAGE ======================
#let months-total = data.companies.map(c => c.groups.map(g => g.ships.map(s => s.months).sum()).sum()).sum()
#let vessels-total = data.companies.map(c => c.groups.map(g => g.ships.len()).sum()).sum()
#let title-case(s) = s.split(" ").map(w => upper(w.first()) + lower(w.slice(1))).join(" ")

#page(background: place(top + left, dx: 190mm, dy: 286mm, target()))[
  #set text(lang: "en")
  #label("CV text · draft " + client.draft + " · " + client.date-en) #h(1fr) #label("Page 2 / " + str(client.pages))

  #v(10mm)
  #block({
    set text(size: client.name-size, weight: 800, tracking: -0.03em)
    set par(leading: 0.62em)
    for (i, n) in client.name-en.enumerate() {
      if i > 0 { linebreak() }
      must-fit("Page-2 name line \"" + n + "\"", fact(n))
    }
  })
  #v(4mm)
  #text(size: 24pt, weight: 700, fact(title-case(data.identity.rank)))

  #v(6mm)
  #let contacts = data.contacts.left + data.contacts.right
  #grid(columns: (1fr, 1fr, 1fr), column-gutter: 5mm, row-gutter: 6.5mm,
    ..contacts.map(c => block({ label(c.label); v(1.6mm); text(size: 11.5pt, weight: 500, fact(c.value)) })))

  #v(6mm)
  #block(width: 160mm, {
    set par(leading: 0.75em)
    show "six": fact-inline
    text(size: 12pt, data.profile)
  })

  #v(5mm)
  #text(size: 22pt, weight: 800)[Sea service] #h(4mm)
  #text(size: 12pt, weight: 600)[#fact-inline(str(months-total) + " months")·#fact-inline(str(vessels-total) + " vessels")·#fact-inline(str(data.companies.len()) + " companies")]
  #v(0.5mm)
  #text(size: 9pt, fill: quiet)[Months as recorded, vessel by vessel.]

  #let row(a, b, c, d) = grid(columns: (46mm, 1fr, 44mm, 25mm), align: (left, left, left, right), a, b, c, d)
  #for co in data.companies.slice(0, 2) {
    block(above: 6.5mm, below: 0mm, breakable: false, {
      grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
        text(size: 13pt, weight: 700, fact(co.name)), text(size: 11pt, weight: 600, fact(co.period)))
      for g in co.groups {
        for (k, s) in g.ships.enumerate() {
          block(above: 3.1mm, below: 0mm, text(size: 12pt, weight: 500, row(
            if k == 0 { text(size: 8pt, weight: 600, tracking: 0.08em, fact(upper(g.type))) },
            fact(s.name), fact(s.rank), fact(str(s.months) + " months"))))
        }
      }
    })
  }
  #place(bottom + right, text(size: 9pt, weight: 600, fill: quiet)[Sea service continues on page 3 →])
]
