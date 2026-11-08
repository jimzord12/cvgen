// Timetable: the CV set as one table of a printed travel timetable.
// Dates are the departure times, every bullet is a row with its lead phrase as
// the station column, the availability is the table's "valid from" line, and a
// key of symbols names what she books.
// Condensed density, stylish tier. The monochrome file is generated from this
// one (mono flag and root path switched); see ../../brief.md.
#let mono = true
#let root = ""
#let d = json(root + "sample.json")
#let portrait = root + (if mono { "portrait-mono.png" } else { "portrait.png" })

// palette: black on white, one signal yellow, a table tint; mono: the yellow becomes reversed black bands
#let ink = rgb("#121212")
#let paper = white
#let signal = if mono { rgb("#121212") } else { rgb("#F5C400") }
#let on-signal = if mono { white } else { ink }
#let accent = if mono { white } else { rgb("#F5C400") }
#let tint = if mono { rgb("#EDEDED") } else { rgb("#F4F1E6") }
#let grey = rgb("#5F5F5F")
#let hair = rgb("#BDBDBD")
#let photo-bg = if mono { rgb("#CFCFCF") } else { rgb("#F5C400") }

#let cond = "IBM Plex Sans"
#let tall = "Sofia Sans"

#set page(paper: "a4", margin: (left: 14mm, right: 14mm, top: 0mm, bottom: 9mm), fill: paper)
#set text(font: cond, size: 9.6pt, fill: ink, lang: "en")
#set par(leading: 0.46em, spacing: 0.5em)

// ---------- pictograms on a 10-unit square ----------
#let pict(kind, s: 4.2mm, col: ink, bg: paper) = box(width: s, height: s, baseline: 15%, {
  let u = s / 10
  if kind == "plane" {
    place(top + left, polygon(fill: col,
      (5*u, 0*u), (5.8*u, 1*u), (5.8*u, 3.6*u), (10*u, 6*u), (10*u, 7*u), (5.8*u, 5.8*u), (5.6*u, 8.4*u),
      (7*u, 9.4*u), (7*u, 10*u), (5*u, 9.5*u), (3*u, 10*u), (3*u, 9.4*u), (4.4*u, 8.4*u), (4.2*u, 5.8*u),
      (0*u, 7*u), (0*u, 6*u), (4.2*u, 3.6*u), (4.2*u, 1*u)))
  } else if kind == "ferry" {
    place(top + left, polygon(fill: col, (0*u, 6*u), (10*u, 6*u), (8.6*u, 8.8*u), (1.2*u, 8.8*u)))
    place(top + left, dx: 2*u, dy: 3.6*u, rect(width: 5.6*u, height: 2*u, fill: col))
    place(top + left, dx: 3.2*u, dy: 1.4*u, rect(width: 1.6*u, height: 2*u, fill: col))
    place(top + left, dx: 0*u, dy: 9.3*u, rect(width: 10*u, height: 0.7*u, fill: col))
  } else if kind == "coach" {
    place(top + left, dy: 1.2*u, rect(width: 10*u, height: 6.6*u, radius: 1*u, fill: col))
    place(top + left, dx: 0.9*u, dy: 2.2*u, rect(width: 8.2*u, height: 2.2*u, fill: bg))
    for x in (2.4, 7.6) { place(top + left, dx: (x - 1.3)*u, dy: 6.8*u, circle(radius: 1.3*u, fill: col, stroke: 0.6*u + bg)) }
  } else if kind == "bed" {
    place(top + left, dy: 2*u, rect(width: 1.2*u, height: 7.4*u, fill: col))
    place(top + left, dy: 6*u, rect(width: 10*u, height: 1.8*u, fill: col))
    place(top + left, dx: 8.8*u, dy: 6*u, rect(width: 1.2*u, height: 3.4*u, fill: col))
    place(top + left, dx: 1.8*u, dy: 4.1*u, rect(width: 2.6*u, height: 1.6*u, radius: 0.6*u, fill: col))
    place(top + left, dx: 4.8*u, dy: 3.9*u, rect(width: 5.2*u, height: 1.8*u, radius: 0.4*u, fill: col))
  } else if kind == "guide" {
    place(top + left, dx: 1.8*u, dy: 0.2*u, circle(radius: 1.3*u, fill: col))
    place(top + left, dx: 1.4*u, dy: 3*u, rect(width: 3.4*u, height: 4*u, radius: 0.8*u, fill: col))
    place(top + left, dx: 1.6*u, dy: 6.6*u, rect(width: 1.2*u, height: 3.4*u, fill: col))
    place(top + left, dx: 3.4*u, dy: 6.6*u, rect(width: 1.2*u, height: 3.4*u, fill: col))
    place(top + left, dx: 6.6*u, dy: 0*u, rect(width: 0.7*u, height: 10*u, fill: col))
    place(top + left, polygon(fill: col, (7.3*u, 0*u), (10*u, 1.5*u), (7.3*u, 3*u)))
    place(top + left, polygon(fill: col, (4.4*u, 3.2*u), (6.7*u, 2.2*u), (6.7*u, 3.4*u), (4.4*u, 4.6*u)))
  }
})
#let services = (("plane", "flights"), ("ferry", "ferries"), ("coach", "coaches"), ("bed", "hotels"), ("guide", "guides"))

// ---------- parts ----------
// no runts: the last words of a running line are bound together (three, or four in a long line)
#let tie(s) = {
  let w = s.split(" ")
  let k = if w.len() >= 10 { 4 } else { 3 }
  if w.len() < 5 { s } else { w.slice(0, -k).join(" ") + " " + w.slice(-k).join(str(sym.space.nobreak)) }
}
#let cap(s) = upper(s.first()) + s.slice(1)
#let colhead(t) = text(size: 7pt, weight: 600, fill: grey, tracking: 0.9pt, upper(t))
#let big(t, size: 22pt) = text(font: tall, weight: 800, size: size, top-edge: "cap-height", t)
#let band(title, note: none) = block(above: 4.4mm, below: 0mm, width: 100%, fill: signal, inset: (x: 2.4mm, y: 1.8mm),
  grid(columns: (1fr, auto), align: (left + horizon, right + horizon),
    text(font: tall, weight: 800, size: 14pt, fill: on-signal, tracking: 1.2pt, top-edge: "cap-height", upper(title)),
    if note != none { text(size: 7.2pt, weight: 600, fill: on-signal, tracking: 0.8pt, upper(note)) }))

// one table row: the station column and the rest, a hairline under it, optional tint
#let trow(left, right, shade: false, lw: 40mm, pad-y: 1.4mm) = block(above: 0mm, below: 0mm, width: 100%,
  fill: if shade { tint } else { none }, inset: (x: 2.4mm, y: pad-y),
  stroke: (bottom: 0.5pt + hair),
  grid(columns: (lw, 1fr), column-gutter: 4mm, left, right))

// ---------- the table's head: a black strip across the sheet ----------
#place(top + left, dx: -14mm, block(width: 210mm, height: 11mm, fill: ink, inset: (x: 14mm), {
  set text(fill: white)
  set align(horizon)
  grid(columns: (auto, 1fr, auto), align: (left + horizon, center + horizon, right + horizon), column-gutter: 4mm,
    text(font: tall, weight: 800, size: 13pt, tracking: 1.6pt)[TABLE 1 #h(1.6mm) #text(weight: 500)[· CURRICULUM VITAE]],
    stack(dir: ltr, spacing: 3.4mm, ..services.map(s => pict(s.at(0), s: 4.4mm, col: white, bg: ink))),
    text(font: tall, weight: 800, size: 13pt, tracking: 1.4pt, fill: accent)[VALID FROM APRIL 2027#super[a]],
  )
}))
#v(11mm)

// ---------- header ----------
#let photo = box(width: 40mm, height: 48mm, fill: photo-bg, clip: true, stroke: (bottom: 1.6pt + ink),
  image(portrait, width: 40mm, height: 48mm, fit: "cover"))

#grid(columns: (1fr, 40mm), column-gutter: 6mm,
  {
    v(5.5mm)
    text(font: tall, weight: 900, size: 64pt, tracking: 0.4pt, top-edge: "cap-height", bottom-edge: "baseline", upper(d.name))
    v(-2.6mm)
    text(font: tall, weight: 800, size: 22pt, tracking: 0.8pt, top-edge: "cap-height", upper(d.title))
    v(1.4mm)
    text(size: 11pt, weight: 600, d.specialty + ", Europe and Asia")
    v(1.6mm)
    block(width: 118mm, text(size: 9.8pt, fill: grey, tie(d.profile)))
  },
  pad(top: 4mm, photo),
)

// ---------- contacts as the table's column heads ----------
#v(2.6mm)
#block(width: 100%, stroke: (top: 1.6pt + ink, bottom: 0.5pt + hair), inset: (x: 2.4mm, y: 1.8mm),
  grid(columns: (auto,) * 6, column-gutter: 1fr, row-gutter: 1.1mm,
    colhead("Based in"), colhead("Phone"), colhead("Email"), colhead("Born"), colhead("Nationality"), colhead("Passport"),
    ..(d.contacts.based, d.contacts.phone, d.contacts.email, d.contacts.born, d.contacts.nationality, d.contacts.passport)
      .map(v => text(size: 9.2pt, weight: 600, v)),
  ))

// ---------- experience ----------
#band("Experience", note: "from · until · position · employer")

#let job(j) = {
  trow(lw: 40mm, pad-y: 2.2mm,
    {
      big(j.from)
      linebreak()
      text(font: tall, weight: 700, size: 13pt, fill: grey)[until #j.to]
    },
    {
      text(weight: 700, size: 13.4pt, j.role)
      linebreak()
      text(weight: 600, size: 10pt, j.employer)
      text(fill: grey, [ · #j.place])
      if "intro" in j { linebreak(); text(style: "italic", fill: grey, size: 9.2pt, tie(j.intro)) }
    })
  for (i, b) in j.bullets.enumerate() {
    trow(shade: calc.rem(i, 2) == 0, align(right, text(weight: 700, b.lead)), tie(cap(b.text)))
  }
}
#job(d.experience.at(0))
#job(d.experience.at(1))

// ---------- education ----------
#band("Education", note: "years · qualification · school")
#for (i, e) in d.education.enumerate() {
  trow(shade: calc.rem(i, 2) == 1, pad-y: 1.9mm, big(e.years, size: 17pt), [*#e.qualification* \ #text(fill: grey, e.institution)])
}

// ---------- languages and skills, side by side ----------
#grid(columns: (0.8fr, 1.2fr), column-gutter: 5mm,
  {
    band("Languages")
    for (i, l) in d.languages.enumerate() {
      trow(lw: 17mm, shade: calc.rem(i, 2) == 1, text(weight: 700, l.name),
        [#text(font: tall, weight: 800, size: 12pt, l.level) #if "note" in l [#h(1mm) #text(size: 8.8pt, fill: grey, tie(l.note))]])
    }
  },
  {
    band(d.skills.heading)
    for (i, s) in d.skills.items.enumerate() {
      trow(lw: 27.5mm, shade: calc.rem(i, 2) == 1, align(right, text(weight: 700, s.lead)), tie(cap(s.text) + "."))
    }
  },
)

// ---------- recent journeys ----------
#band("Recent journeys", note: d.journeys.region)
#grid(columns: (1fr, 1fr, 1fr), column-gutter: 0mm,
  ..d.journeys.trips.enumerate().map(((i, t)) => block(width: 100%, inset: (x: 2.4mm, y: 2mm), fill: if calc.rem(i, 2) == 0 { tint } else { none },
    stroke: (bottom: 0.5pt + hair), {
      text(font: tall, weight: 800, size: 13pt, t.period)
      h(1.5mm)
      text(size: 8.6pt, fill: grey)[#t.days days, #t.role]
      linebreak()
      text(weight: 600, t.stops.join(" – "))
    })))

// ---------- notes and key, as at the foot of a timetable ----------
#v(1fr)
#block(width: 100%, stroke: (top: 1.6pt + ink), inset: (x: 2.4mm, top: 2.2mm), {
  grid(columns: (1fr, 1fr), column-gutter: 7mm,
    [#text(weight: 700)[#super[a] #d.availability.headline.] #tie(d.availability.text)],
    {
      text(size: 7pt, weight: 600, fill: grey, tracking: 0.9pt)[KEY · SERVICES SHE BOOKS AND RECONFIRMS]
      linebreak()
      v(0.6mm)
      for s in services { box[#pict(s.at(0), s: 3.6mm) #h(0.8mm) #text(size: 8.6pt, s.at(1))] + h(3mm) }
    })
  v(1.6mm)
  text(size: 6.8pt, fill: grey, tracking: 0.8pt, upper(d.disclosure))
})
