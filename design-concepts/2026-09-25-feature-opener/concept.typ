// Feature Opener - design concept, 2026-09-25. Not library code.
// One A4 page set like the opening page of a magazine feature: kicker,
// headline, standfirst, a pull-quote made of the service figures, the
// career as a contents list with leaders, and back-matter credentials.
// Compile from the repository root:
// typst compile --root . --ignore-system-fonts --font-path packages/cv-engine/fonts
//   --font-path design-concepts/fonts
//   design-concepts/2026-09-25-feature-opener/concept.typ
//   design-concepts/2026-09-25-feature-opener/concept.pdf

// ---------- tokens (would become a theme) ----------
#let ink = rgb("1b1916")
#let muted = rgb("6d675f")
#let accent = rgb("8e2a1b")     // oxblood: kicker, pull-quote, rules
#let panel = rgb("f4f0e9")      // fact-file tint, light enough to photocopy as white
#let display = "Instrument Serif"
#let body-face = "Newsreader 16pt"   // the variable Newsreader registers under this name

#let caps(body, size: 6.8pt, fill: ink, tracking: 1.1pt) = text(
  font: body-face, size: size, weight: 600, tracking: tracking, fill: fill, upper(body))
#let leaders = box(width: 1fr, inset: (x: 1.2pt), repeat(gap: 2.2pt, text(fill: muted, size: 7pt)[.]))

#let title-case(s) = s.split(" ").map(w => if w.len() == 0 { w } else {
  upper(w.first()) + lower(w.slice(w.clusters().first().len()))
}).join(" ")

#let number-words = ("zero", "one", "two", "three", "four", "five", "six", "seven",
  "eight", "nine", "ten", "eleven", "twelve")
#let number-words = number-words + ("thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen")
#let tens-words = ("", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety")
// numbers in words, as a magazine sets them in running text; digits from 100
#let say(n) = if n < 20 { number-words.at(n) } else if n < 100 {
  tens-words.at(calc.div-euclid(n, 10)) + if calc.rem(n, 10) > 0 { "-" + number-words.at(calc.rem(n, 10)) } else { "" }
} else { str(n) }

// ---------- the page ----------
#let render(m) = {
  set page(paper: "a4", margin: (x: 16mm, top: 12mm, bottom: 15mm))
  set text(font: body-face, size: 8.8pt, fill: ink, lang: "en", number-type: "lining")
  set par(leading: 0.55em, spacing: 0.8em)

  let entries = m.employers.map(e => e.groups.map(g => g.entries).flatten()).flatten()
  let total = entries.map(s => s.months).sum()
  let n-units = entries.map(s => s.id).dedup().len()
  let n-emp = m.employers.len()
  let yrs = calc.div-euclid(total, 12)
  let mos = calc.rem(total, 12)

  // running head, like a magazine's department line
  grid(columns: (1fr, auto),
    caps(m.words.department, fill: accent),
    caps(m.words.running-right, fill: muted))
  v(1.8mm)
  line(length: 100%, stroke: 0.4pt + ink)
  v(9mm)

  // kicker and headline
  caps(m.rank, size: 10.5pt, fill: accent, tracking: 2.4pt)
  v(1mm)
  block(text(font: display, size: 112pt, tracking: -2.5pt, top-edge: "cap-height", bottom-edge: "baseline",
    title-case(m.name)))
  v(6mm)

  // standfirst + byline-style contacts
  grid(columns: (1fr, 52mm), column-gutter: 9mm,
    text(font: body-face, style: "italic", size: 14.5pt, weight: 350, m.profile),
    {
      set par(leading: 0.45em, spacing: 1.1em)
      for c in m.contacts {
        caps(c.label, size: 6pt, fill: muted, tracking: 0.9pt)
        linebreak()
        text(size: 8.6pt, c.value)
        parbreak()
      }
    })
  v(6mm)
  line(length: 100%, stroke: 0.9pt + ink)
  v(0.7mm)
  line(length: 100%, stroke: 0.3pt + ink)
  v(4.5mm)

  // ---------- body: contents list (2 cols) + pull-quote and fact file (1 col) ----------
  let company(e) = block(breakable: false, below: 4.2mm, {
    // name and period share a line when they fit; otherwise the period drops below
    layout(size => {
      let nm = text(font: display, size: 14pt, e.name)
      let pd = text(size: 7.8pt, fill: muted, e.period)
      if measure(nm).width + measure(pd).width + 3mm <= size.width {
        grid(columns: (1fr, auto), align: bottom, column-gutter: 2mm, nm, pd)
      } else {
        block(above: 0pt, below: 1.6mm, par(leading: 0.18em, nm))
        pd
      }
    })
    v(-1.2mm)
    line(length: 100%, stroke: 0.4pt + ink)
    v(0.3mm)
    let last-role = none
    for (gi, g) in e.groups.enumerate() {
      if gi > 0 { v(1.1mm) }
      // role written once, then again only when it changes
      let roles = g.entries.map(s => s.role).dedup()
      text(style: "italic", size: 8.4pt, fill: accent, g.type + " · " + roles.join(", "))
      linebreak()
      for s in g.entries {
        box(width: 100%, {
          text(size: 8.8pt, s.name)
          leaders
          text(size: 8.8pt, weight: 500, str(s.months))
        })
        linebreak()
      }
    }
  })

  grid(columns: (1fr, 52mm), column-gutter: 9mm,
    {
      grid(columns: (1fr, auto), align: bottom,
        caps(m.words.contents-title, fill: accent, tracking: 1.6pt),
        caps(m.words.contents-unit, fill: muted, size: 6pt))
      v(2.2mm)
      // split the companies into two columns of near-equal depth, never inside a company
      let weight(e) = e.groups.len() + e.groups.map(g => g.entries.len()).sum() + 2
      let ws = m.employers.map(weight)
      let all = ws.sum()
      let best = 1
      for k in range(1, m.employers.len()) {
        let a = ws.slice(0, k).sum()
        let b = ws.slice(0, best).sum()
        if calc.max(a, all - a) < calc.max(b, all - b) { best = k }
      }
      grid(columns: (1fr, 1fr), column-gutter: 7mm,
        { for e in m.employers.slice(0, best) { company(e) } },
        { for e in m.employers.slice(best) { company(e) } })
    },
    {
      // the pull-quote is the career in three figures
      line(length: 100%, stroke: 0.9pt + accent)
      v(2.5mm)
      block(above: 0pt, below: 3.2mm, text(font: display, size: 80pt, fill: accent, tracking: -1pt,
        top-edge: "cap-height", bottom-edge: "baseline", str(total)))
      block(above: 0pt, below: 3mm, text(font: display, style: "italic", size: 20pt, m.words.pull-unit))
      block(above: 0pt, below: 3mm, par(leading: 0.42em, text(font: display, size: 13.5pt, (m.words.pull-line)(yrs, mos, n-units, n-emp))))
      line(length: 100%, stroke: 0.3pt + accent)
      v(5mm)

      // fact file panel: education and languages
      block(width: 100%, fill: panel, inset: (x: 4mm, y: 4mm), {
        caps(m.words.edu-title, fill: accent, tracking: 1.4pt)
        v(1.2mm)
        for ed in m.education {
          text(weight: 600, ed.qualification); linebreak()
          text(style: "italic", ed.institution)
          if ed.at("note", default: none) != none { linebreak(); text(size: 7pt, fill: muted, ed.note) }
          parbreak()
        }
        v(3.5mm)
        caps(m.words.lang-title, fill: accent, tracking: 1.4pt)
        v(1.2mm)
        for l in m.languages {
          block(above: 0pt, below: 1.6mm, { text(weight: 600, l.name); linebreak(); text(style: "italic", fill: muted, l.level) })
        }
      })
    })

  // ---------- back matter: certificates as a two-column register ----------
  v(1fr)
  line(length: 100%, stroke: 0.9pt + ink)
  v(0.7mm)
  line(length: 100%, stroke: 0.3pt + ink)
  v(2.6mm)
  grid(columns: (1fr, auto), align: bottom,
    caps(m.words.certs-title, fill: accent, tracking: 1.6pt),
    caps(m.words.certs-unit, fill: muted, size: 6pt))
  v(2.4mm)
  let half = calc.ceil(m.certificates.len() / 2)
  let cert-line(c) = block(below: 2.1mm, {
    box(width: 100%, {
      text(weight: 600, c.title)
      leaders
      text(c.review)
    })
    linebreak()
    text(size: 7.6pt, style: "italic", fill: muted, c.scope + " · " + m.words.issued + " " + c.issued)
  })
  grid(columns: (1fr, 1fr), column-gutter: 9mm,
    { for c in m.certificates.slice(0, half) { cert-line(c) } },
    { for c in m.certificates.slice(half) { cert-line(c) } })

  // folio
  place(bottom + left, dy: 8mm, grid(columns: (1fr, auto, 1fr), align: (left, center, right),
    text(size: 7pt, fill: muted, [#title-case(m.name) · #m.rank-line]),
    text(font: display, size: 11pt, "1"),
    text(size: 7pt, fill: muted, m.words.footer-right)))
}

// ---------- marine adapter: candidate facts -> page model ----------
#let cert(c) = if type(c) == array {
  (title: c.at(0), scope: c.at(1), issued: c.at(2), review: c.at(3))
} else { c }

#let marine(d) = (
  name: d.identity.name,
  rank: d.identity.rank,
  rank-line: title-case(d.identity.rank),
  contacts: d.contacts.left + d.contacts.right.filter(c => c.label == "Email"),
  profile: d.at("profile", default: ""),
  employers: d.companies.map(c => (
    name: c.name, period: c.period,
    groups: c.groups.map(g => (type: g.type,
      entries: g.ships.map(s => (id: s.id, name: s.name, role: s.rank, months: s.months)))),
  )),
  certificates: d.at("certificates", default: ()).map(cert),
  education: d.at("education_entries", default: ()),
  languages: d.at("language_entries", default: ()),
  words: (
    department: [Curriculum vitae · #d.contacts.right.find(c => c.label == "Discipline").value],
    running-right: title-case(d.identity.name),
    contents-title: "Sea service",
    contents-unit: "vessel · months",
    pull-unit: "months at sea",
    pull-line: (y, mo, v, c) => [#title-case(say(y)) years and #say(mo) months, #say(v) vessels, #say(c) shipping companies.],
    edu-title: "Education",
    lang-title: "Languages",
    certs-title: "Certificates & endorsements",
    certs-unit: "certificate · expires or review",
    issued: "issued",
    footer-right: [Fictional candidate · concept "Feature Opener" · 2026-09-25],
  ),
)

#render(marine(json("/examples/candidates/captain-example.json")))
