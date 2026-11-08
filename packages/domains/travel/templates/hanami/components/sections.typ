// Hanami's sections on the paper: numbered headings, the profile block, experience, the
// destination page (trip stamps, areas, practical know-how, a trip in detail) and studies.
#import "art.typ": art, caps, hex, items, keep-end, label, paper-art, tokens, two-columns
#import "stamp.typ": stamp

#let heading(ctx, number, title, subtitle, art-piece: none) = {
  let P = tokens(ctx)
  let fonts = ctx.theme.fonts
  block(width: 100%, {
    if art-piece != none { art-piece }
    grid(columns: (13mm, 1fr), align: (left + top, left + top),
      text(font: fonts.figures, size: 28pt, fill: P.metal, number),
      pad(top: 1.4mm, stack(spacing: 0.9mm,
        text(font: fonts.body, size: 15pt, weight: 700, fill: P.ink, top-edge: "cap-height", bottom-edge: "descender", title),
        text(font: fonts.body, size: 9pt, fill: P.muted, top-edge: "cap-height", bottom-edge: "baseline", subtitle),
      )),
    )
  })
}
// A pale paper piece beside a heading, by artwork key, offset from the heading's top left.
#let paper-piece(ctx, key, dx, dy, width: auto, height: auto) = place(top + left, dx: dx, dy: dy, art(ctx, key, width: width, height: height, swaps: paper-art(tokens(ctx))))

// The profile block: the lead statement, availability beside it behind an accent rule, a
// hairline and up to four highlight cells with drawn icons.
#let profile(ctx, lead, availability, highlights) = {
  let P = tokens(ctx)
  grid(columns: (1fr, 76mm), column-gutter: 6mm,
    pad(top: 2.2mm, text(size: 15pt, weight: 600, fill: P.ink, lead)),
    if availability != none {
      block(stroke: (left: 1.6pt + P.accent), inset: (left: 3mm, y: 0.4mm), {
        set par(leading: 0.42em)
        label(ctx, availability.headline, fill: P.accent, size: 6.8pt, track: 1.1pt)
        linebreak()
        text(size: 8.8pt, availability.text)
      })
    },
  )
  if highlights.len() > 0 {
    v(3.2mm)
    line(length: 100%, stroke: 0.5pt + P.keyline.transparentize(30%))
    v(2.8mm)
    let cell(c) = grid(columns: (7.4mm, 1fr), column-gutter: 1.8mm,
      pad(top: 0.2mm, art(ctx, "icon-" + c.icon, width: 7.4mm, swaps: ("#7a5a3a": hex(P.icon), "#fefefe": hex(P.paper)))),
      {
        set par(leading: 0.42em)
        text(size: 10pt, weight: 700, c.title)
        linebreak()
        text(size: 9.2pt, fill: P.muted, c.text)
      })
    grid(columns: (1fr,) * 4, column-gutter: 3.6mm, ..highlights.map(cell))
  }
}

// The experience subtitle from the record: an optional kind of employer, the places, the years.
#let experience-subtitle(ctx, jobs) = {
  let places = jobs.map(j => j.place).dedup()
  let years = jobs.map(j => int(j.from.slice(3)))
  let current = jobs.any(j => "to" not in j)
  let last = if current { ctx.copy.present } else { str(calc.max(..jobs.map(j => int(j.to.slice(3))))) }
  let place-text = if places.len() == 1 { places.first() } else { places.slice(0, -1).join(", ") + " " + ctx.copy.and-word + " " + places.last() }
  let parts = if ctx.copy.experience-kind != "" { (ctx.copy.experience-kind,) } else { () }
  (..parts, place-text, str(calc.min(..years)) + " – " + last).join(" · ")
}

#let job(ctx, j) = {
  let P = tokens(ctx)
  let fonts = ctx.theme.fonts
  block(width: 100%, stroke: (left: 1.6pt + P.date), inset: (left: 5mm, top: 0.4mm, bottom: 1mm), {
    set par(leading: 0.5em)
    grid(columns: (1fr, auto), column-gutter: 4mm, align: (left + top, right + top),
      {
        text(size: 13pt, weight: 700, j.role)
        linebreak()
        label(ctx, j.employer + " · " + j.place, fill: P.label, size: 7.6pt, track: 1.4pt)
      },
      {
        text(font: fonts.figures, size: 15pt, fill: P.date, j.from)
        h(1.2mm)
        text(font: fonts.body, size: 13pt, weight: 600, fill: P.date)[–]
        h(1.2mm)
        if "to" not in j { text(size: 12.5pt, weight: 600, fill: P.date, ctx.copy.present) } else { text(font: fonts.figures, size: 15pt, fill: P.date, j.to) }
      },
    )
    if "intro" in j { block(above: 1.6mm, below: 0mm, text(size: 9.6pt, fill: P.muted, j.intro)) }
    v(2.6mm)
    let support = j.at("support", default: none)
    if support == none {
      items(ctx, j.bullets)
    } else {
      grid(columns: (1fr, 78.6mm), column-gutter: 5.4mm,
        items(ctx, j.bullets),
        block(width: 100%, fill: P.wash, inset: (x: 3mm, top: 3mm, bottom: 3.2mm), {
          set par(leading: 0.46em)
          grid(columns: (auto, 1fr), column-gutter: 2.6mm, align: (left + top, left + top),
            text(font: fonts.figures, size: 22pt, fill: P.accent, top-edge: "cap-height", bottom-edge: "baseline", support.figure),
            text(size: 10pt, keep-end(support.text)))
          block(above: 3mm, below: 0mm, label(ctx, support.lead, fill: P.label, size: 6.8pt, track: 1.1pt))
          for (i, case) in support.cases.enumerate() {
            block(above: if i == 0 { 1.6mm } else { 2.6mm }, below: 0mm, text(size: 10pt)[#text(weight: 700, fill: P.date, case.place): #keep-end(case.text)])
          }
        }),
      )
    }
  })
}

// Every role, with the free space shared between them.
#let experience(ctx, jobs) = {
  for (i, j) in jobs.enumerate() {
    if i > 0 { v(1fr) }
    job(ctx, j)
    if i == 0 { v(4.4mm) }
  }
}

#let dot(P, known) = box(baseline: 0.05em, circle(radius: 1.05mm, fill: if known { P.accent } else { P.paper }, stroke: 0.8pt + P.accent))

// One trip: its stamp, period and length, who travelled, the stops (known well or passed) and the
// stops in the destination's own script.
#let trip-card(ctx, trip) = {
  let P = tokens(ctx)
  let fonts = ctx.theme.fonts
  let s = trip.at("stamp", default: none)
  grid(columns: (26mm, 1fr), column-gutter: 4.4mm,
    if s != none { stamp(ctx, s.rim, s.art, kanji: s.at("kanji", default: ""), size: 26, ink: P.accent, ground: P.paper) },
    {
      set par(leading: 0.46em)
      text(size: 11pt, weight: 700, trip.period)
      h(2.4mm)
      text(font: fonts.figures, size: 15pt, fill: P.accent, str(trip.days))
      h(0.8mm)
      text(size: 9pt, weight: 600, fill: P.accent, ctx.copy.days)
      linebreak()
      text(size: 9.2pt, fill: P.muted, trip.kind)
      v(1.6mm)
      text(size: 9.6pt, trip.stops.map(stop => {
        let known = stop.at("known", default: false)
        box[#dot(P, known)#h(1.1mm)#text(weight: if known { 600 } else { 400 }, stop.name)]
      }).join([#h(1.6mm) ]))
      if s != none and s.at("script", default: ()).len() > 0 {
        v(1mm)
        let script = s.script
        text(font: fonts.japanese, size: 8pt, fill: P.muted, script.enumerate().map(((i, p)) => box(if i < script.len() - 1 [#p ·] else [#p])).join(" "))
      }
    },
  )
}

// The areas known well, with the legend of the stop dots.
#let areas(ctx, entries) = {
  let P = tokens(ctx)
  block(width: 100%, fill: P.wash, inset: (x: 3.6mm, y: 2.8mm), {
    set par(leading: 0.46em)
    label(ctx, ctx.copy.areas, fill: P.label, size: 6.8pt)
    h(1fr)
    text(size: 8.4pt, fill: P.muted)[#dot(P, true)#h(1.2mm)#ctx.copy.known #h(2.4mm) #dot(P, false)#h(1.2mm)#ctx.copy.passed]
    v(1.4mm)
    for entry in entries {
      block(above: 1.4mm, below: 0mm, text(size: 9.6pt)[#text(weight: 700, entry.label): #entry.places.])
    }
  })
}

// The trips in two columns: the even ones and the areas on the left, the odd ones on the right
// (the first trip is the shorter card in the approved design, so the areas sit under it).
#let trips(ctx, places) = {
  let left = places.trips.enumerate().filter(((i, t)) => calc.even(i)).map(((i, t)) => t)
  let right = places.trips.enumerate().filter(((i, t)) => calc.odd(i)).map(((i, t)) => t)
  grid(columns: (1fr, 1fr), column-gutter: 7mm,
    {
      for (i, t) in left.enumerate() { if i > 0 { v(3.6mm) }; trip-card(ctx, t) }
      if places.at("areas", default: ()).len() > 0 { v(3.6mm); areas(ctx, places.areas) }
    },
    { for (i, t) in right.enumerate() { if i > 0 { v(3.6mm) }; trip-card(ctx, t) } },
  )
}

#let practical(ctx, know-how) = {
  let P = tokens(ctx)
  label(ctx, ctx.copy.practical + " · " + know-how.lead, fill: P.label)
  v(2.2mm)
  two-columns(ctx, know-how.items)
  if "basics" in know-how {
    block(above: 3.6mm, below: 0mm, text(size: 10.5pt)[#text(weight: 700, know-how.basics.label): #know-how.basics.text.])
  }
}

// Education beside the languages and references.
#let studies(ctx, education, languages, references) = {
  let P = tokens(ctx)
  grid(columns: (1fr, 61mm), column-gutter: 6mm,
    grid(columns: (1fr, 1fr), column-gutter: 5mm, row-gutter: 2.8mm,
      ..education.map(e => block(width: 100%, stroke: (left: 1.6pt + P.metal), inset: (left: 3.4mm, y: 0.4mm), {
        set par(leading: 0.42em)
        text(size: 10pt, weight: 700, e.qualification)
        linebreak()
        text(size: 9.2pt, fill: P.muted, e.institution)
        if e.at("note", default: "") != "" { linebreak(); text(size: 9.2pt, weight: 600, fill: P.date, e.note) }
      }))),
    {
      for l in languages {
        block(width: 100%, fill: P.wash, inset: (x: 3.2mm, y: 1.8mm), above: 0mm, below: 1.4mm, {
          set par(leading: 0.4em)
          text(size: 10pt, weight: 700, l.name)
          h(1fr)
          text(size: 9.2pt, l.level)
          if "note" in l { linebreak(); text(size: 8.6pt, fill: P.muted, l.note) }
        })
      }
      if references != none {
        v(1.6mm)
        text(size: 9.2pt)[#text(weight: 700, ctx.copy.references): #references]
      }
    },
  )
}
