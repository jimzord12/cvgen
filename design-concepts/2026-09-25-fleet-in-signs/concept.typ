// Fleet in Signs - design concept, 2026-09-25. Not library code.
// One A4 page. The sea career is counted, not described: one equal-sized
// sign per vessel, its silhouette giving the vessel class and its colour
// the rank held. Rows are companies, newest at the top.
// Compile from the repository root:
// typst compile --root . --ignore-system-fonts --font-path packages/cv-engine/fonts
//   --font-path design-concepts/fonts
//   design-concepts/2026-09-25-fleet-in-signs/concept.typ
//   design-concepts/2026-09-25-fleet-in-signs/concept.pdf

// ---------- tokens (would become a theme) ----------
#let paper = rgb("fcfaf5")
#let ink = rgb("1c1c1a")
#let muted = rgb("6a6861")
#let hair = rgb("c9c5bb")
// rank colours, in order of seniority held (newest first); chosen to stay
// four distinct greys on a photocopier: dark, mid, light, pale
#let rank-colours = (rgb("1c1c1a"), rgb("c8402a"), rgb("8aa3b0"), rgb("cdb68a"))
#let face = "Jost"

// ---------- signs (would become an artwork pack) ----------
#let sign-dir = "signs/"
#let sign-of(type) = {
  let t = lower(type)
  if t.contains("lng") or t.contains("lpg") or t.contains("gas") { "gas" }
  else if t.contains("tanker") { "tanker" }
  else if t.contains("bulk") { "bulk" }
  else if t.contains("container") { "container" }
  else if t.contains("ferr") or t.contains("ro-pax") or t.contains("passenger") or t.contains("cruise") { "ferry" }
  else if t.contains("cargo") { "cargo" }
  else { "generic" }
}
#let sign(kind, fill, width) = image(
  bytes(read(sign-dir + kind + ".svg").replace("{{fill}}", fill.to-hex())),
  format: "svg", width: width)

#let caps(body, size: 6.8pt, fill: ink, tracking: 1.2pt, weight: 500) = text(
  font: face, size: size, weight: weight, tracking: tracking, fill: fill, upper(body))

#let title-case(s) = s.split(" ").map(w => if w.len() == 0 { w } else {
  upper(w.first()) + lower(w.slice(w.clusters().first().len()))
}).join(" ")

// ---------- the page ----------
#let render(m) = {
  set page(paper: "a4", margin: (x: 15mm, top: 13mm, bottom: 13mm), fill: paper)
  set text(font: face, size: 8.6pt, fill: ink, lang: "en")
  set par(leading: 0.5em, spacing: 0.8em)

  let entries = m.employers.map(e => e.groups.map(g => g.entries).flatten()).flatten()
  let total = entries.map(s => s.months).sum()
  let n-units = entries.map(s => s.id).dedup().len()
  let ranks = entries.map(s => s.role).dedup()        // newest first, as the record is
  let colour-of(role) = rank-colours.at(calc.min(ranks.position(r => r == role), rank-colours.len() - 1))
  let kinds = m.employers.map(e => e.groups.map(g => sign-of(g.type))).flatten().dedup()
  let yrs = calc.div-euclid(total, 12)
  let mos = calc.rem(total, 12)

  // ---------- head ----------
  grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
    {
      block(above: 0pt, below: 4.2mm, text(size: 36pt, weight: 600, tracking: 0.6pt, top-edge: "cap-height", bottom-edge: "baseline", m.name))
      block(above: 0pt, below: 0pt, {
        text(size: 15pt, weight: 400, fill: rank-colours.at(0), m.rank)
        h(4mm)
        text(size: 9pt, fill: muted, m.discipline)
      })
    },
    {
      set par(leading: 0.55em)
      set align(right)
      for c in m.contacts { text(size: 8pt, c.value); linebreak() }
    })
  v(3.5mm)
  line(length: 100%, stroke: 1.4pt + ink)
  v(3mm)

  // profile + the chart's title and key, Isotype-fashion
  grid(columns: (1fr, 84mm), column-gutter: 10mm,
    {
      text(size: 9.2pt, m.profile)
      v(3.5mm)
      grid(columns: (auto, auto, auto), column-gutter: 7mm,
        ..((str(n-units), m.words.units), (str(total), m.words.months), (str(m.employers.len()), m.words.employers)).map(((n, l)) =>
          stack(dir: ttb, spacing: 1.6mm,
            text(size: 26pt, weight: 600, top-edge: "cap-height", bottom-edge: "baseline", n),
            caps(l, size: 6.4pt, fill: muted))))
      v(1.5mm)
      text(size: 7.4pt, fill: muted, [#m.words.equals #yrs #m.words.years #mos #m.words.months-short])
    },
    {
      caps(m.words.key-title, size: 6.6pt, tracking: 1.4pt, weight: 600)
      v(1.2mm)
      line(length: 100%, stroke: 0.5pt + ink)
      v(1.6mm)
      text(size: 7.4pt, fill: muted, m.words.key-sign)
      v(1.4mm)
      grid(columns: (1fr, 1fr), column-gutter: 5mm, row-gutter: 1.6mm,
        ..kinds.map(k => grid(columns: (13mm, 1fr), column-gutter: 2mm, align: horizon,
          sign(k, ink, 12mm), text(size: 7.4pt, m.words.kind-names.at(k)))))
      v(2mm)
      text(size: 7.4pt, fill: muted, m.words.key-colour)
      v(1.2mm)
      grid(columns: (1fr, 1fr), column-gutter: 5mm, row-gutter: 1.6mm,
        ..ranks.map(r => grid(columns: (13mm, 1fr), column-gutter: 2mm, align: horizon,
          sign("generic", colour-of(r), 12mm),
          text(size: 7.4pt, [#r #text(fill: muted)[#entries.filter(s => s.role == r).len()]]))))
    })
  v(3mm)

  // ---------- the chart: one row per company, one sign per vessel ----------
  let sw = 19mm        // sign width, identical for every vessel
  let cell = 21.2mm      // sign plus gutter
  let left-w = 40mm
  caps(m.words.chart-title, size: 6.6pt, tracking: 1.4pt, weight: 600)
  v(1.2mm)
  line(length: 100%, stroke: 0.5pt + ink)
  for (ei, e) in m.employers.enumerate() {
    let es = e.groups.map(g => g.entries).flatten()
    let mo = es.map(s => s.months).sum()
    block(breakable: false, above: 0mm, below: 0mm, inset: (y: 1.35mm), {
      grid(columns: (left-w, 1fr), column-gutter: 3mm,
        {
          text(size: 7.4pt, fill: muted, e.period)
          linebreak()
          text(size: 10pt, weight: 600, e.name)
          v(1.2mm)
          text(size: 16pt, weight: 500, top-edge: "cap-height", bottom-edge: "baseline", str(mo))
          h(1.2mm)
          text(size: 7.4pt, fill: muted, m.words.months-short)
        },
        {
          // groups side by side, a label over each group's signs
          stack(dir: ltr, spacing: 3mm, ..e.groups.map(g => {
            let n = g.entries.len()
            box(width: n * cell - (cell - sw), {
              // the rank is also written, so the row survives a black-and-white copy
              box(height: 5.8mm, width: 100%, {
                set par(leading: 0.3em)
                caps(g.type, size: 5.8pt, fill: muted, tracking: 0.8pt)
                linebreak()
                text(size: 7.5pt, weight: 500, g.entries.map(s => s.role).dedup().join(" / "))
              })
              v(-1.2mm)
              line(length: 100%, stroke: 0.4pt + hair)
              v(-1.6mm)
              stack(dir: ltr, spacing: cell - sw, ..g.entries.map(s => box(width: sw, {
                sign(sign-of(g.type), colour-of(s.role), sw)
                v(-1.2mm)
                text(size: 9pt, weight: 600, str(s.months))
                v(-1.5mm)
                par(leading: 0.28em, text(size: 6.3pt, fill: ink, s.name))
              })))
            })
          }))
        })
    })
    line(length: 100%, stroke: 0.4pt + hair)
  }
  v(1fr)

  // ---------- credentials ----------
  line(length: 100%, stroke: 1.4pt + ink)
  v(2mm)
  grid(columns: (1fr, 48mm), column-gutter: 10mm,
    {
      caps(m.words.certs-title, size: 6.6pt, tracking: 1.4pt, weight: 600)
      v(1.4mm)
      let cert-cell(c) = block(above: 0pt, below: 0pt, {
        text(size: 8.2pt, weight: 500, c.title); linebreak()
        text(size: 7pt, fill: muted, c.scope + " · "); text(size: 7pt, weight: 500, c.review)
      })
      let half = calc.ceil(m.certificates.len() / 2)
      grid(columns: (1fr, 1fr), column-gutter: 7mm, row-gutter: 2.4mm,
        ..range(half).map(i => (
          cert-cell(m.certificates.at(i)),
          if i + half < m.certificates.len() { cert-cell(m.certificates.at(i + half)) } else { [] })).flatten())
    },
    {
      caps(m.words.edu-title, size: 6.6pt, tracking: 1.4pt, weight: 600)
      v(1.4mm)
      for ed in m.education {
        text(weight: 500, ed.qualification); linebreak()
        text(size: 7.8pt, ed.institution)
        v(3.6mm)
      }
      caps(m.words.lang-title, size: 6.6pt, tracking: 1.4pt, weight: 600)
      v(3.8mm)
      for l in m.languages {
        block(above: 0pt, below: 1.6mm, { text(weight: 500, l.name); linebreak(); text(size: 7.4pt, fill: muted, l.level) })
      }
    })
  v(2mm)
  grid(columns: (1fr, auto),
    text(size: 6.4pt, fill: muted, [#title-case(m.name) · #m.rank]),
    text(size: 6.4pt, fill: muted, m.words.footer-right))
}

// ---------- marine adapter: candidate facts -> page model ----------
#let cert(c) = if type(c) == array {
  (title: c.at(0), scope: c.at(1), issued: c.at(2), review: c.at(3))
} else { c }

#let marine(d) = (
  name: d.identity.name,
  rank: title-case(d.identity.rank),
  discipline: d.contacts.right.find(c => c.label == "Discipline").value,
  contacts: d.contacts.left.filter(c => c.label != "Nationality") + d.contacts.right.filter(c => c.label == "Email"),
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
    units: "vessels", months: "months at sea", employers: "companies",
    years: "years", months-short: "months", equals: "Service months from the record:",
    key-title: "How to read the fleet",
    key-sign: [Each sign is one vessel. The outline gives the class:],
    key-colour: [The colour gives the rank held aboard, with vessels served:],
    kind-names: (tanker: "Tanker", gas: "Gas carrier", bulk: "Bulk carrier", container: "Container ship",
      ferry: "Ferry / Ro-Pax", cargo: "General cargo", generic: "Other"),
    chart-title: "Sea service · companies newest first · months under each vessel",
    certs-title: "Certificates & endorsements · expires or review",
    edu-title: "Education",
    lang-title: "Languages",
    footer-right: [Fictional candidate · design concept "Fleet in Signs" · CVgen 2026-09-25],
  ),
)

#render(marine(json("/examples/candidates/engineer-example.json")))
