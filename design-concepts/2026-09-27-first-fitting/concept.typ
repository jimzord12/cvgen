// First Fitting: a Text Draft direction for CVgen (idea run 2026-09-27).
// The draft is the CV's baste fitting: loosely tacked with one copper thread.
// Every fact the Client must check is tacked with a copper running stitch;
// the wording (ours) is left plain. Two pages: the Check Page (Greek) and the
// first CV-content page (English), from a fictional record.
//
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path design-concepts/fonts design-concepts/2026-09-27-first-fitting/concept.typ design-concepts/2026-09-27-first-fitting/concept.pdf

#let data = json("/examples/candidates/chief-officer-example.json")

// ---- Per-client parameters (words); the design below is fixed ---------------
#let client = (
  name-el: "Ελένη Μάρκου",
  first-el: "Ελένη", // the greeting, in the vocative ("Κωνσταντίνε" for Κωνσταντίνος)
  client-el: "Πελάτισσα", // gendered: "Πελάτης" for a man
  name-en: "Eleni Markou", // the record says ELENI MARKOU; set here in the CV's own case
  draft: "01",
  date-el: "27.09.2026",
  date-en: "27 Sep 2026",
  pages: 3,
)
#let check = (
  kicker: "Προσχέδιο κειμένου",
  // Fixed house copy with no ordinal ("Time for a fitting."), so draft 02 and 03 use it
  // unchanged and the thread never moves; the draft number lives on the ticket.
  headline: ("Ώρα για", "πρόβα."),
  standfirst: [#client.first-el, αυτό είναι το κείμενο του βιογραφικού σας, πρόχειρα τρυπωμένο, για να το δοκιμάσετε πριν το ράψουμε.],
  ask: [Ελέγξτε μόνο ό,τι έχει \ χάλκινη βελονιά από κάτω:],
  items: (
    ("Ονόματα", "Boreal Gas Carriers"),
    ("Ημερομηνίες", "2023 – 2026"),
    ("Αριθμούς", "6 months"),
    ("Τίτλους", "Chief Officer"),
  ),
  ours: [Τη διατύπωση την αναλαμβάνουμε εμείς.],
  ok: [Όλα σωστά; Απαντήστε «OK».],
  fix: [Κάτι λάθος; Γράψτε μας τη σελίδα και το σωστό.],
)

// ---- House design --------------------------------------------------------
#let paper = rgb("#F3EEE3")
#let ink = rgb("#1C1814")
#let copper = rgb("#B0602B")
#let quiet = rgb("#6E655A")
#let serif = "Bona Nova"

// A running (basting) stitch: long copper dashes with short gaps.
#let stitch(w) = (paint: copper, thickness: w, dash: (w * 5.5, w * 3.2), cap: "round")
// Tack a fact: the one mark the Client learns to look for.
#let fact(body, w: 0.9pt, off: 3.2pt) = underline(stroke: stitch(w), offset: off, evade: false, extent: 1pt, body)

// Greek capitals drop their accents (tonos); a vowel pair keeps its split with a dialytika.
#let caps-el(s) = {
  let plain = ("ά": "α", "έ": "ε", "ή": "η", "ί": "ι", "ό": "ο", "ύ": "υ", "ώ": "ω", "ΐ": "ϊ", "ΰ": "ϋ",
    "Ά": "Α", "Έ": "Ε", "Ή": "Η", "Ί": "Ι", "Ό": "Ο", "Ύ": "Υ", "Ώ": "Ω")
  let cs = s.clusters()
  let out = ()
  for (i, c) in cs.enumerate() {
    let prev = if i > 0 { cs.at(i - 1) } else { "" }
    if prev in ("ά", "έ", "ό", "ύ") and c == "ι" { out.push("ϊ") }
    else if prev in ("ά", "έ", "ό") and c == "υ" { out.push("ϋ") }
    else { out.push(plain.at(c, default: c)) }
  }
  upper(out.join())
}
#let label-el(s) = text(size: 8.5pt, tracking: 0.16em, fill: quiet, caps-el(s))
#let label-en(s) = text(size: 7.5pt, tracking: 0.16em, fill: quiet, upper(s))

// Pattern notch (match point) sitting on the seam, pointing at a step.
#let notch = place(left, dx: -15mm, dy: 1.2mm, polygon(fill: copper, (0mm, 0mm), (4mm, 2mm), (0mm, 4mm)))
#let section(title) = block(above: 7mm, below: 3.5mm, { notch; text(size: 19pt, style: "italic", title) })
// The seam: a long basting line down the left margin of every page.
#let seam = place(top + left, line(start: (13mm, 0mm), end: (13mm, 297mm), stroke: stitch(1.2pt)))

// A tailor's ticket: card with a punched eyelet; the thread ends tied through it.
#let ticket(lines) = rotate(5deg, reflow: false, box(
  width: 46mm, fill: rgb("#FBF8F1"), stroke: 0.5pt + rgb("#CFC4B2"), inset: (x: 5mm, top: 11mm, bottom: 5mm),
  {
    place(top + center, dy: -7mm, circle(radius: 1.7mm, fill: paper, stroke: 0.6pt + rgb("#B9AC98")))
    set par(leading: 0.45em, spacing: 0.9em)
    lines
  }))

#set document(title: client.name-en + " – CV text – draft " + client.draft)
#set page(paper: "a4", fill: paper, margin: (left: 26mm, right: 20mm, top: 20mm, bottom: 18mm), background: seam)
#set text(font: serif, fill: ink, size: 11pt, lang: "el", number-type: "lining")
#set par(justify: false)

// =========================== PAGE 1: CHECK PAGE ===========================
// The thread, in page coordinates: tied at the ticket's eyelet, it crosses the
// headline in front of the letters (as the brand mark's thread crosses the V),
// wraps round the first letter of the second line and ends in a loose tail.
#let thread = place(top + left, dx: -26mm, dy: -20mm, {
  place(top + left, curve(stroke: stitch(1.5pt),
    curve.move((172.7mm, 37.8mm)),
    curve.cubic((164mm, 24mm), (149mm, 32mm), (144mm, 48mm)),
    curve.cubic((139mm, 60mm), (128mm, 70mm), (112mm, 72mm)),
    curve.cubic((90mm, 75mm), (66mm, 66mm), (46mm, 68.5mm)),
    curve.cubic((30mm, 70.5mm), (26mm, 85mm), (36mm, 92mm)),
    curve.cubic((46mm, 100mm), (70mm, 98mm), (84mm, 92mm)),
  ))
  place(top + left, curve(stroke: (paint: copper, thickness: 1.5pt, cap: "round"),
    curve.move((84mm, 92mm)),
    curve.cubic((94mm, 87mm), (102mm, 91mm), (108mm, 98mm)),
  ))
})

#[
  #place(top + left, dy: -4mm, label-el(check.kicker))
  #place(top + right, dx: 4.5mm, dy: 12mm, ticket[
    #text(size: 7pt, tracking: 0.14em, fill: quiet, caps-el(client.client-el)) \
    #text(size: 13pt, client.name-el) \
    #v(1mm)
    #text(size: 7pt, tracking: 0.14em, fill: quiet, caps-el("Πρόβα")) #h(1fr) #text(size: 7pt, tracking: 0.14em, fill: quiet, caps-el("Ημερομηνία")) \
    #text(size: 13pt)[#client.draft] #h(1fr) #text(size: 11pt)[#client.date-el] \
    #v(1mm)
    #text(size: 8pt, style: "italic", fill: quiet)[CVgen · κομμένο στα μέτρα σας]
  ])

  #v(2mm)
  #block(text(size: 106pt, style: "italic", tracking: -0.02em, {
    set par(leading: 0.3em)
    check.headline.at(0); linebreak(); h(18mm); check.headline.at(1)
  }))

  #v(24mm)
  #block(width: 150mm, text(size: 21pt, check.standfirst, hyphenate: false))

  #v(9mm)
  #block(width: 150mm, { notch; text(size: 24pt, weight: "bold", check.ask) })
  #v(7mm)
  #for (kind, sample) in check.items {
    block(above: 0mm, below: 0mm, height: 13mm, grid(columns: (58mm, 1fr), align: (left + bottom, left + bottom),
      text(size: 21pt, kind),
      text(size: 21pt, lang: "en", fact(sample, w: 1.3pt, off: 4.5pt)),
    ))
  }
  #v(6mm)
  #text(size: 16pt, style: "italic", fill: quiet, check.ours)

  #place(bottom + left, block(width: 165mm, {
    notch
    text(size: 30pt, weight: "bold", check.ok)
    v(0mm)
    text(size: 18pt, check.fix)
  }))
  #thread
]

#pagebreak()

// ====================== PAGE 2: FIRST CV-CONTENT PAGE ======================
#let months-total = data.companies.map(c => c.groups.map(g => g.ships.map(s => s.months).sum()).sum()).sum()
#let vessels-total = data.companies.map(c => c.groups.map(g => g.ships.len()).sum()).sum()
#let words = ("zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten")
#let title-case(s) = s.split(" ").map(w => upper(w.first()) + lower(w.slice(1))).join(" ")

#[
  #set text(lang: "en", size: 11.5pt)
  #place(top + left, dy: -4mm, label-en("CV text · draft " + client.draft + " · " + client.date-en))
  #place(top + right, dy: -5.5mm, text(size: 12pt, tracking: 0.06em, fill: ink)[Page 2 of #client.pages])

  #v(6mm)
  #block(below: 7mm, { notch; text(size: 54pt, fact(client.name-en, w: 1.5pt, off: 7pt)) })
  #text(size: 21pt, style: "italic", fact(title-case(data.identity.rank), w: 1.1pt, off: 4pt))

  #v(6mm)
  #let contacts = data.contacts.left + data.contacts.right
  #grid(columns: (1fr, 1fr, 1fr), column-gutter: 6mm, row-gutter: 3.2mm,
    ..contacts.map(c => block({ label-en(c.label); linebreak(); fact(c.value, w: 0.7pt, off: 2.6pt) })))

  #v(3mm)
  #block(width: 150mm, {
    set par(leading: 0.62em)
    show "six": it => fact(it, w: 0.7pt, off: 2.6pt)
    text(size: 13pt, data.profile)
  })

  #section[Sea service]
  #text(size: 12pt)[#fact(str(months-total) + " months") at sea, on #fact(str(vessels-total) + " vessels"), with #fact(words.at(data.companies.len()) + " companies") (months as recorded, per vessel).]
  #v(2mm)

  #let row(a, b, c) = grid(columns: (1fr, 44mm, 24mm), align: (left, left, right), a, b, c)
  #for co in data.companies.slice(0, 3) {
    block(above: 6mm, below: 2mm, breakable: false, {
      grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
        text(size: 14.5pt, weight: "bold", fact(co.name, w: 0.9pt, off: 3pt)),
        text(size: 12pt, fact(co.period, w: 0.8pt, off: 3pt)))
      v(1.2mm)
      for g in co.groups {
        block(above: 3.6mm, below: 1.4mm, text(size: 10.5pt, style: "italic", fill: quiet, fact(g.type, w: 0.6pt, off: 2.2pt)))
        for s in g.ships {
          block(above: 3.4mm, below: 0mm, text(size: 11.5pt, row(fact(s.name, w: 0.7pt, off: 2.6pt), fact(s.rank, w: 0.7pt, off: 2.6pt), fact(str(s.months) + " months", w: 0.7pt, off: 2.6pt))))
        }
      }
    })
  }
  #place(bottom + right, text(size: 10pt, style: "italic", fill: quiet)[Sea service continues on page 3 →])
]
