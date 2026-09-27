// Stoichedon: a Text Draft direction for CVgen (idea run 2026-09-27).
// The whole draft sits on one square letter grid, as Attic inscriptions were
// cut "in rows": display lines put every letter in its own cell; running text
// keeps to the rows. Facts the Client must check are rubricated in red ochre.
// Two pages: the Check Page (Greek) and the first CV-content page (English).
//
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path design-concepts/fonts design-concepts/2026-09-27-stoichedon/concept.typ design-concepts/2026-09-27-stoichedon/concept.pdf

#let data = json("/examples/candidates/chief-officer-example.json")

// ---- Per-client parameters (words); the design below is fixed ---------------
#let client = (
  given-el: "Ελένη", family-el: "Μάρκου",
  given-en: "Eleni", family-en: "Markou",
  draft: "01", date: "27.09.2026", pages: 3,
)
#let check = (
  intro: [#client.given-el, αυτό είναι το κείμενο του βιογραφικού σας, πριν αρχίσει το σχέδιο.],
  ask: ("Ελέγξτε μόνο", "τα κόκκινα"), // second line is set in the fact colour
  items: (
    ("Ονόματα", "Boreal Gas Carriers"),
    ("Ημερομηνίες", "2023 – 2026"),
    ("Αριθμούς", "6 months"),
    ("Τίτλους", "Chief Officer"),
  ),
  ours: [Τη διατύπωση την αναλαμβάνουμε εμείς.],
  ok: ("Όλα σωστά;", "Απαντήστε OK"),
  fix: [Κάτι λάθος; Γράψτε μας τη σελίδα και το σωστό.],
  page: "Σελίδα",
  draft: "Προσχέδιο",
)

// ---- House design --------------------------------------------------------
#let C = 7.5mm                  // the cell; the page is 24 x 36 cells
#let stone = rgb("#EDE9E0")
#let ink = rgb("#1A1917")
#let ochre = rgb("#A33B22")     // rubric: the facts
#let rule = rgb("#C9C1B1")
#let quiet = rgb("#6A645A")
#let face = "GFS Neohellenic"

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

#let at(col, row, body) = place(top + left, dx: col * C, dy: row * C, body)

// One letter per cell. `span` = cell size in grid cells. A space keeps its cell,
// marked with a faint point, as a word divider.
#let stoi(col, row, segs, span: 1, fill: ink, weight: "regular", align-right: false) = {
  let segs = if type(segs) == str { ((segs, fill),) } else { segs }
  let cells = ()
  for (s, f) in segs { for ch in caps-el(s).clusters() { cells.push((ch, f)) } }
  let start = if align-right { col - cells.len() * span } else { col }
  for (i, (ch, f)) in cells.enumerate() {
    let body = if ch == " " {
      circle(radius: 0.5mm * calc.sqrt(span), fill: rule)
    } else {
      text(font: face, size: span * C * (if span > 2 { 1.08 } else { 1.0 }), weight: weight, fill: f, top-edge: "cap-height", bottom-edge: "baseline", ch)
    }
    at(start + i * span, row, box(width: span * C, height: span * C, align(center + horizon, body)))
  }
}

// Running text on the rows: baselines fall on the same place in every cell row.
#let lines(col, row, cols, body, size: 17pt, fill: ink) = place(top + left, dx: col * C, dy: row * C + 0.7 * C,
  block(width: cols * C, {
    set text(font: face, size: size, fill: fill, top-edge: "baseline", bottom-edge: "baseline")
    set par(leading: C, spacing: C, justify: false)
    body
  }))
#let fact(body) = text(fill: ochre, body)

// The cell marks: a small cross at every corner of the grid.
#let grid-marks = {
  for i in range(25) { for j in range(37) {
    let x = 15mm + i * C
    let y = 13.5mm + j * C
    place(top + left, line(start: (x - 0.8mm, y), end: (x + 0.8mm, y), stroke: 0.35pt + rule))
    place(top + left, line(start: (x, y - 0.8mm), end: (x, y + 0.8mm), stroke: 0.35pt + rule))
  } }
}

#set document(title: client.given-en + " " + client.family-en + " – CV text – draft " + client.draft)
#set page(paper: "a4", fill: stone, margin: (x: 15mm, y: 13.5mm), background: grid-marks)
#set text(font: face, fill: ink, lang: "el", number-type: "lining")

// =========================== PAGE 1: CHECK PAGE ===========================
#[
  #stoi(0, 0, "CVgen", weight: "bold")
  #stoi(24, 0, check.draft + " " + client.draft, weight: "bold", align-right: true)

  #stoi(0, 2, client.given-el, span: 4)
  #stoi(0, 6, client.family-el, span: 4)

  #lines(0, 11, 22, check.intro, size: 18pt)

  #stoi(0, 14, check.ask.at(0), span: 2, weight: "bold")
  #stoi(0, 16, check.ask.at(1), span: 2, weight: "bold", fill: ochre)

  #for (i, (kind, sample)) in check.items.enumerate() {
    stoi(0, 19 + i, kind)
    lines(12, 19 + i, 12, text(lang: "en", fact(sample)), size: 20pt)
  }
  #lines(0, 24, 24, text(fill: quiet, check.ours), size: 18pt)

  #stoi(0, 26, check.ok.at(0), span: 2, weight: "bold")
  #stoi(0, 28, check.ok.at(1), span: 2, weight: "bold")
  #lines(0, 31, 24, check.fix, size: 18pt)

  #stoi(0, 35, client.date)
  #stoi(24, 35, check.page + " 1/" + str(client.pages), align-right: true)
]

#pagebreak()

// ====================== PAGE 2: FIRST CV-CONTENT PAGE ======================
#let months-total = data.companies.map(c => c.groups.map(g => g.ships.map(s => s.months).sum()).sum()).sum()
#let vessels-total = data.companies.map(c => c.groups.map(g => g.ships.len()).sum()).sum()
#let label(s) = text(size: 7.5pt, tracking: 0.16em, fill: quiet, upper(s))

#[
  #set text(lang: "en")
  #stoi(0, 0, "Draft " + client.draft, weight: "bold")
  #stoi(24, 0, "Page 2/" + str(client.pages), weight: "bold", align-right: true)

  #stoi(0, 2, client.given-en, span: 4, fill: ochre)
  #stoi(0, 6, client.family-en, span: 4, fill: ochre)
  #stoi(0, 10, data.identity.rank, fill: ochre, weight: "bold")

  #let contacts = data.contacts.left + data.contacts.right
  #for (i, c) in contacts.enumerate() {
    let col = if i < 3 { 0 } else { 12 }
    let row = 12 + calc.rem(i, 3)
    lines(col, row, 3, label(c.label), size: 13pt)
    lines(col + 3, row, 9, fact(c.value), size: 13pt)
  }

  #lines(0, 16, 24, {
    show "six": fact
    data.profile
  }, size: 14pt)

  #stoi(0, 20, "Sea service", weight: "bold")
  #stoi(24, 20, ((str(months-total), ochre), (" months", ink)), weight: "bold", align-right: true)

  #let r = 22
  #for co in data.companies.slice(0, 2) {
    lines(0, r, 17, text(weight: "bold", fact(co.name)), size: 15pt)
    lines(17, r, 7, align(right, fact(co.period)), size: 15pt)
    r += 1
    for g in co.groups {
      for (k, s) in g.ships.enumerate() {
        if k == 0 { lines(0, r, 7, text(style: "italic", fill: quiet, g.type), size: 12pt) }
        lines(7, r, 8, fact(s.name), size: 13pt)
        lines(15, r, 6, fact(s.rank), size: 13pt)
        lines(21, r, 3, align(right, fact(str(s.months) + " months")), size: 13pt)
        r += 1
      }
    }
    r += 1
  }
  #stoi(24, 35, "Continues on page 3", align-right: true)
]
