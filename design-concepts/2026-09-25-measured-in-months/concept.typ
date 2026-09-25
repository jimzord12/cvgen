// Measured in Months - design concept, 2026-09-25. Not library code.
// One A4 page. The career is drawn once, to scale: every vessel is a bar
// whose length is its service months, read against a ruler in months.
// Compile from the repository root:
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts
//   --font-path design-concepts/fonts
//   design-concepts/2026-09-25-measured-in-months/concept.typ
//   design-concepts/2026-09-25-measured-in-months/concept.pdf

// ---------- tokens (would become a theme) ----------
#let ink = rgb("141414")
#let ink-2 = rgb("6b6b6b")      // alternate employer, secondary text
#let signal = rgb("d2401e")     // one signal colour: the current employer
#let rule-c = rgb("bdbdbd")
#let face = "Archivo"

#let small-caps-label(body, fill: ink-2) = text(
  size: 6.6pt, weight: 600, tracking: 0.9pt, fill: fill, upper(body))

// ---------- the page, rendered from a field-neutral model ----------
#let render(m) = {
  set page(paper: "a4", margin: (x: 15mm, top: 13mm, bottom: 12mm))
  set text(font: face, size: 8.4pt, fill: ink, features: ("tnum",), lang: "en")
  set par(leading: 0.52em, spacing: 0.9em)

  let W = 180mm
  let entries = m.employers.map(e => e.entries).flatten()
  let total = entries.map(s => s.months).sum()
  let n-units = entries.map(s => s.id).dedup().len()
  let n-emp = m.employers.len()
  let yrs = calc.div-euclid(total, 12)
  let mos = calc.rem(total, 12)

  // running head
  grid(columns: (1fr, auto),
    small-caps-label(m.words.head-left, fill: ink),
    small-caps-label(m.discipline, fill: ink))
  v(1.6mm)
  line(length: 100%, stroke: 0.5pt + ink)
  v(3mm)

  // name, set as one condensed line
  block(text(size: 80pt, weight: 800, stretch: 62%, tracking: -0.5pt,
    top-edge: "cap-height", bottom-edge: "baseline", m.name))
  v(4.2mm)

  // rank, contacts, profile on a 12-column grid
  grid(columns: (92mm, 1fr), column-gutter: 8mm,
    {
      text(size: 17pt, weight: 300, stretch: 125%, m.rank)
      v(2.6mm)
      set text(size: 8.6pt)
      set par(leading: 0.6em)
      m.profile
    },
    {
      v(1.2mm)
      grid(columns: (auto, 1fr), column-gutter: 4mm, row-gutter: 2.1mm,
        ..m.contacts.map(c => (small-caps-label(c.label), text(size: 8.2pt, c.value))).flatten())
    })
  v(6.5mm)

  // the three figures, set like a timetable header
  let figure-cell(n, cap) = stack(dir: ltr, spacing: 2mm,
    text(size: 34pt, weight: 700, stretch: 62%, top-edge: "cap-height", bottom-edge: "baseline", str(n)),
    align(bottom, text(size: 7.4pt, weight: 500, cap)))
  grid(columns: (auto, auto, auto, 1fr), column-gutter: 11mm, align: bottom,
    figure-cell(total, m.words.months-cap),
    figure-cell(n-units, m.words.units-cap),
    figure-cell(n-emp, m.words.employers-cap),
    align(right + bottom, text(size: 7.4pt, fill: ink-2,
      [#m.words.equals #yrs #m.words.years #mos #m.words.months-short])))
  v(3mm)

  // ---------- the strip: every vessel to scale ----------
  // the record is newest first, companies and vessels alike; the strip runs
  // oldest to newest, so both orders are reversed
  let chron = m.employers.rev().map(e => (..e, entries: e.entries.rev()))
  let gv = 0.55mm                                  // gap between vessels
  let gc = 2.4mm                                   // gap between employers
  let n-entries = entries.len()
  let avail = W - (n-entries - n-emp) * gv - (n-emp - 1) * gc
  let unit = avail / total
  let bar-h = 12mm
  let label-h = 9.5mm      // employer names above the ruler
  let ruler-h = 4.2mm
  let top-bar = label-h + ruler-h
  let name-text(s) = text(size: 7pt, weight: 500, (m.words.unit-name)(s))

  context {
  // the fringe of names is as deep as the longest name, never wrapped
  let names-h = calc.max(..entries.map(s => measure(name-text(s)).width)) + 3mm
  block(width: W, height: top-bar + bar-h + names-h, {
    // ruler in months, cumulative, never calendar years
    let tick-every = 6
    let x = 0mm
    // compute each entry's x so the ruler follows the bars, gaps included
    let xs = ()
    for (ei, e) in chron.enumerate() {
      for (si, s) in e.entries.enumerate() {
        xs.push((x: x, w: s.months * unit, e: ei, s: s, first: si == 0))
        x += s.months * unit
        if si < e.entries.len() - 1 { x += gv }
      }
      if ei < chron.len() - 1 { x += gc }
    }
    // ruler: a tick at every 6 months of service, labelled every 12
    place(top + left, dy: label-h + ruler-h - 0.3pt, line(length: W, stroke: 0.4pt + ink))
    let acc = 0
    for item in xs {
      for k in range(1, item.s.months + 1) {
        let m-at = acc + k
        if calc.rem(m-at, tick-every) == 0 {
          let tx = item.x + k * unit
          let major = calc.rem(m-at, 12) == 0
          place(top + left, dx: tx - 0.2pt, dy: label-h + (if major { 0.6mm } else { 2.2mm }),
            line(angle: 90deg, length: if major { ruler-h - 0.6mm } else { ruler-h - 2.2mm }, stroke: 0.4pt + ink))
          if major {
            place(top + left, dx: tx + 0.7mm, dy: label-h - 0.6mm,
              text(size: 5.8pt, fill: ink-2, str(m-at)))
          }
        }
      }
      acc += item.s.months
    }
    // employer labels above, bars, months inside, names below
    for item in xs {
      let e = chron.at(item.e)
      let current = item.e == chron.len() - 1
      let fill = if current { signal } else if calc.rem(chron.len() - 1 - item.e, 2) == 1 { ink } else { ink-2 }
      if item.first {
        let ew = e.entries.map(s => s.months * unit).sum() + (e.entries.len() - 1) * gv
        place(top + left, dx: item.x + 1.5pt, dy: 0mm, box(width: ew - 1mm - 1.5pt, {
          set par(leading: 0.35em)
          text(size: 6.6pt, weight: 700, fill: if current { signal } else { ink }, e.name)
          linebreak()
          text(size: 6.2pt, fill: ink-2, e.period)
        }))
        place(top + left, dx: item.x, dy: 0mm, line(angle: 90deg, length: label-h - 1mm, stroke: 0.4pt + if current { signal } else { ink }))
      }
      place(top + left, dx: item.x, dy: top-bar, rect(width: item.w, height: bar-h, fill: fill, stroke: none))
      place(top + left, dx: item.x + 0.9mm, dy: top-bar + bar-h - 4.1mm,
        text(size: 8pt, weight: 700, fill: white, str(item.s.months)))
      // vessel name hangs from the bar, reading downwards
      place(top + left, dx: item.x + 3.2mm, dy: top-bar + bar-h + 1.2mm,
        rotate(90deg, origin: top + left, reflow: false,
          name-text(item.s)))
    }
  })
  }
  // legend line
  text(size: 6.4pt, fill: ink-2)[#m.words.legend]
  v(4mm)

  // ---------- the ledger ----------
  let hdr(t) = small-caps-label(t)
  let cols = (19mm, 40mm, 1fr, 42mm, 12mm, 12mm)
  let rows = m.employers.map(e => {
    let es = e.entries
    let types = e.groups
    let roles = es.map(s => s.role).dedup()
    let n = es.map(s => s.id).dedup().len()
    let mo = es.map(s => s.months).sum()
    (
      text(fill: ink-2, e.period),
      text(weight: 700, e.name),
      types.join(", "),
      roles.map(r => r.replace(" ", "\u{00A0}")).join(" / "),   // break between roles, never inside one
      align(right, str(n)),
      align(right, text(weight: 700, str(mo))),
    )
  })
  grid(columns: (1fr, auto), align: bottom,
    text(size: 11pt, weight: 700, stretch: 87.5%, m.words.ledger-title),
    small-caps-label(m.words.ledger-note))
  v(2mm)
  table(columns: cols, stroke: none, inset: (x: 0mm, y: 1.5mm), column-gutter: 2.5mm,
    table.hline(stroke: 0.8pt + ink),
    ..m.words.ledger-cols.enumerate().map(((i, c)) => if i >= 4 { align(right, hdr(c)) } else { hdr(c) }),
    table.hline(stroke: 0.4pt + ink),
    ..rows.flatten(),
    table.hline(stroke: 0.8pt + ink),
    [], text(weight: 700, m.words.total-row), [], [],
    align(right, text(weight: 700, str(n-units))),
    align(right, text(weight: 800, fill: signal, str(total))),
  )
  v(6mm)

  // ---------- credentials ----------
  grid(columns: (124mm, 1fr), column-gutter: 8mm,
    {
      text(size: 11pt, weight: 700, stretch: 87.5%, m.words.certs-title)
      v(2mm)
      set text(size: 8pt)
      table(columns: (1fr, 35mm, 27mm), stroke: none, inset: (x: 0mm, y: 1.35mm), column-gutter: 3mm,
        table.hline(stroke: 0.8pt + ink),
        hdr(m.words.cert-cols.at(0)), hdr(m.words.cert-cols.at(1)), align(right, hdr(m.words.cert-cols.at(2))),
        table.hline(stroke: 0.4pt + ink),
        ..m.certificates.map(c => (
          text(weight: 600, c.title), text(fill: ink-2, c.scope), align(right, c.review))).flatten(),
        table.hline(stroke: 0.4pt + ink),
      )
    },
    {
      text(size: 11pt, weight: 700, stretch: 87.5%, m.words.edu-title)
      v(2mm)
      line(length: 100%, stroke: 0.8pt + ink)
      v(1.2mm)
      for e in m.education {
        text(weight: 700, e.qualification); linebreak()
        text(e.institution)
        if e.at("note", default: none) != none { linebreak(); text(size: 7pt, fill: ink-2, e.note) }
        v(2mm)
      }
      v(2.5mm)
      text(size: 11pt, weight: 700, stretch: 87.5%, m.words.lang-title)
      v(2mm)
      line(length: 100%, stroke: 0.8pt + ink)
      v(1.2mm)
      grid(columns: (22mm, 1fr), row-gutter: 2mm,
        ..m.languages.map(l => (text(weight: 700, l.name), text(fill: ink-2, l.level))).flatten())
    })

  // footer
  place(bottom + left, dy: 4mm, block(width: W, {
    line(length: 100%, stroke: 0.4pt + rule-c)
    v(1.4mm)
    grid(columns: (1fr, auto),
      text(size: 6.4pt, fill: ink-2, m.words.footer-left),
      text(size: 6.4pt, fill: ink-2, m.words.footer-right))
  }))
}

// ---------- marine adapter: candidate facts -> page model ----------
#let cert(c) = if type(c) == array {
  (title: c.at(0), scope: c.at(1), issued: c.at(2), review: c.at(3))
} else { c }

#let title-case(s) = s.split(" ").map(w => if w.len() == 0 { w } else {
  upper(w.first()) + lower(w.slice(w.clusters().first().len()))
}).join(" ")

#let marine(d) = (
  name: d.identity.name,
  rank: title-case(d.identity.rank),
  discipline: d.contacts.right.find(c => c.label == "Discipline").value,
  contacts: d.contacts.left.filter(c => c.label != "Nationality")
    + d.contacts.right.filter(c => c.label == "Email"),
  profile: d.at("profile", default: ""),
  employers: d.companies.map(c => (
    name: c.name, period: c.period,
    groups: c.groups.map(g => g.type),
    entries: c.groups.map(g => g.ships.map(s => (id: s.id, name: s.name, role: s.rank, months: s.months, type: g.type))).flatten(),
  )),
  certificates: d.at("certificates", default: ()).map(cert),
  education: d.at("education_entries", default: ()),
  languages: d.at("language_entries", default: ()),
  words: (
    head-left: "Curriculum vitae - sea service record",
    months-cap: [months\ at sea],
    units-cap: [vessels],
    employers-cap: [shipping\ companies],
    equals: [Service months from the record:],
    years: "years", months-short: "months",
    unit-name: s => s.name,
    legend: [Each bar is one vessel, drawn to its months of service; companies run oldest to newest, left to right. Ruler in cumulative service months, not calendar years. Current company in red.],
    ledger-title: "Companies",
    ledger-note: "newest first",
    ledger-cols: ("Period", "Company", "Vessel types", "Rank", "Vessels", "Months"),
    total-row: "Total service",
    certs-title: "Certificates",
    cert-cols: ("Certificate", "Scope / record", "Expires"),
    edu-title: "Education",
    lang-title: "Languages",
    footer-left: [#title-case(d.identity.name) - #title-case(d.identity.rank)],
    footer-right: [Fictional candidate - design concept "Measured in Months", CVgen 2026-09-25],
  ),
)

#render(marine(json("/examples/candidates/chief-officer-example.json")))
