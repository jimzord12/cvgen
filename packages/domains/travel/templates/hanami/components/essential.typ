// The parts of Hanami's `essential` Template Variation: one calm, scan-first page in Hanami's theme,
// type and artwork. The name block in a shallow band with one sakura branch (the page's one motif),
// the profile row, then each role's title, employer and dates where the eye lands, and the facts a
// recruiter checks for a tour leader on a rail beside them. Every text is real text; no ratings. Capitals
// keep their tracking near 0.09 em: wider, and a PDF's text (and an ATS) splits the words into letters.
#import "art.typ": art, at, caps, hex, items, keep-end, label, sakura, tokens
#import "sections.typ": dot

// A section title: Hanami's figure number in metal, the title, a hairline to the column's edge.
#let section(ctx, number, title) = {
  let P = tokens(ctx)
  block(width: 100%, below: 3.4mm, grid(columns: (auto, auto, 1fr), column-gutter: 2.4mm, align: (left + bottom, left + bottom, left + bottom),
    text(font: ctx.theme.fonts.figures, size: 15pt, fill: P.metal, top-edge: "cap-height", bottom-edge: "baseline", number),
    text(size: 12pt, weight: 700, fill: P.ink, top-edge: "cap-height", bottom-edge: "baseline", title),
    pad(bottom: 0.6mm, line(length: 100%, stroke: 0.5pt + P.keyline.transparentize(30%)))))
}
// A rail title: tracked capitals and a hairline.
#let rail-title(ctx, title) = {
  let P = tokens(ctx)
  block(width: 100%, below: 2.4mm, grid(columns: (auto, 1fr), column-gutter: 2mm, align: (left + horizon, left + horizon),
    label(ctx, title, fill: P.label, size: 7.2pt, track: 0.09em), line(length: 100%, stroke: 0.5pt + P.keyline.transparentize(30%))))
}

// "MM/YYYY – MM/YYYY", the end "present" while the role is held.
#let dates(ctx, from, to, size: 12.5pt) = {
  let P = tokens(ctx)
  let fig(s) = text(font: ctx.theme.fonts.figures, size: size, fill: P.date, s)
  [#fig(from)#h(0.9mm)#text(size: size * 0.86, weight: 600, fill: P.date)[–]#h(0.9mm)#if to == none { text(size: size * 0.82, weight: 600, fill: P.date, ctx.copy.present) } else { fig(to) }]
}

// The band: name, rank and specialty, contacts in two rows; the portrait, when the record has one, in
// a metal ring on the right; one sakura branch across the top right corner.
#let band(ctx, d) = {
  let P = tokens(ctx)
  let fonts = ctx.theme.fonts
  let B = ctx.layout.band
  at(0mm, 0mm, rect(width: 210mm, height: B, fill: P.hero))
  place(top + right, art(ctx, "canopy", width: 104mm, swaps: sakura(ctx.theme.sakura.hero, P.hero)))
  let portrait = d.identity.at("portrait", default: none)
  let PD = ctx.layout.portrait
  let PX = 194mm - PD
  let PY = (B - PD) / 2 + 1.5mm
  if portrait != none {
    at(PX - 1.6mm, PY - 1.6mm, circle(radius: PD / 2 + 1.6mm, fill: P.plate, stroke: 1.4pt + P.ring))
    at(PX, PY, box(width: PD, height: PD, radius: 50%, clip: true, stroke: 0.6pt + P.ring,
      image(portrait, width: PD, height: PD, fit: "cover", alt: d.identity.at("portrait-alt", default: d.identity.name))))
  }
  // the name block runs to the portrait's ring, or to the margin without one
  let W = if portrait != none { PX - 1.6mm - 8mm - 16mm } else { 178mm }
  let name = text(font: fonts.display, size: 31pt, weight: 800, tracking: 0.6pt, fill: P.hero-text, top-edge: "cap-height", bottom-edge: "baseline", caps(d.identity.name))
  context assert(measure(name).width <= W, message: "Hanami essential: the name is wider than the band; shorten it (a middle name can go)")
  let specialty = d.identity.at("specialty", default: none)
  let rank = {
    label(ctx, d.identity.rank, fill: P.hero-label, size: 8.4pt, track: 0.09em)
    if ctx.copy.tab-native != "" { h(1.6mm); text(font: fonts.japanese, size: 8pt, fill: P.hero-label, ctx.copy.tab-native) }
    if specialty != none { h(1.6mm); text(size: 8.4pt, weight: 700, fill: P.accent)[·]; h(1.6mm); label(ctx, specialty, fill: P.accent, size: 8.4pt, track: 0.09em) }
  }
  let entry(c) = stack(spacing: 1.5mm, label(ctx, c.label, fill: P.hero-label, size: 6.6pt, track: 0.09em),
    text(size: 9.8pt, fill: P.hero-text, top-edge: "cap-height", bottom-edge: "baseline", if "href" in c { link(c.href, c.value) } else { c.value }))
  let rows = (d.contacts.at("left", default: ()), d.contacts.at("right", default: ())).filter(r => r.len() > 0)
  let columns = calc.max(0, ..rows.map(r => r.len()))
  assert(columns <= 3, message: "Hanami essential: the band holds three contacts a row; move one to the other row or drop it")
  let contacts = if rows.len() > 0 {
    grid(columns: (auto,) * columns, column-gutter: 8mm, row-gutter: 3.4mm, ..rows.map(r => r + ([],) * (columns - r.len())).flatten().map(c => if c == [] { c } else { entry(c) }))
  }
  context assert(contacts == none or measure(contacts).width <= W, message: "Hanami essential: the contacts are wider than the band; shorten one or move it to the other row")
  at(16mm, 11mm, block(width: W, stack(spacing: 3.8mm, name, rank, v(3mm), contacts)))
}

// The lead statement, one line across the page where it fits.
#let lead(ctx, statement) = text(size: 13pt, weight: 600, fill: tokens(ctx).ink, keep-end(statement))

// Availability at the head of the rail, behind an accent rule: its headline, then the details.
#let availability(ctx, a) = {
  let P = tokens(ctx)
  block(width: 100%, stroke: (left: 1.6pt + P.accent), inset: (left: 3mm, y: 0.4mm), {
    set par(leading: 0.44em)
    label(ctx, a.headline, fill: P.accent, size: 7.2pt, track: 0.09em)
    linebreak()
    text(size: 9.4pt, a.text)
  })
}

// The highlight cells as one quiet line of facts, no icons: a title and its few words each.
#let highlights(ctx, cells) = {
  let P = tokens(ctx)
  grid(columns: (1fr,) * cells.len(), column-gutter: 0mm,
    ..cells.enumerate().map(((i, c)) => block(width: 100%, inset: (left: if i == 0 { 0mm } else { 3.6mm }, right: 2mm),
      stroke: (left: if i == 0 { none } else { 0.5pt + P.keyline.transparentize(30%) }), {
        set par(leading: 0.42em)
        text(size: 9.8pt, weight: 700, c.title)
        linebreak()
        text(size: 9.2pt, fill: P.muted, c.text)
      })))
}

// One role in full: title and dates on one line, employer and place under it, the intro, the
// bullets, and the support box with its cases under them.
#let role(ctx, j) = {
  let P = tokens(ctx)
  let fonts = ctx.theme.fonts
  block(width: 100%, breakable: false, {
    set par(leading: 0.5em)
    grid(columns: (1fr, auto), column-gutter: 3mm, align: (left + bottom, right + bottom),
      text(size: 12.5pt, weight: 700, j.role), dates(ctx, j.from, j.at("to", default: none)))
    block(above: 1.4mm, below: 0mm, label(ctx, j.employer + " · " + j.place, fill: P.label, size: 7.6pt, track: 0.09em))
    if "intro" in j { block(above: 1.8mm, below: 0mm, text(size: 9.6pt, fill: P.muted, j.intro)) }
    block(above: 2.4mm, below: 0mm, items(ctx, j.bullets, size: 10pt, gap: 1.5mm))
    let support = j.at("support", default: none)
    if support != none {
      block(above: 2.8mm, below: 0mm, width: 100%, fill: P.wash, inset: (x: 3mm, top: 2.6mm, bottom: 2.8mm), {
        set par(leading: 0.46em)
        grid(columns: (auto, 1fr), column-gutter: 2.6mm, align: (left + horizon, left + horizon),
          text(font: fonts.figures, size: 19pt, fill: P.accent, top-edge: "cap-height", bottom-edge: "baseline", support.figure),
          text(size: 9.8pt, keep-end(support.text)))
        block(above: 2.4mm, below: 0mm, label(ctx, support.lead, fill: P.label, size: 6.8pt, track: 0.09em))
        for case in support.cases {
          block(above: 1.6mm, below: 0mm, text(size: 9.6pt)[#text(weight: 700, fill: P.date, case.place): #keep-end(case.text)])
        }
      })
    }
  })
}

// The older roles in one block: their count and span (the domain's totals over them), then each
// as one line of title, employer and years.
#let earlier(ctx, totals, jobs) = {
  let P = tokens(ctx)
  let n = totals.roles
  block(width: 100%, breakable: false, stroke: (top: 0.5pt + P.keyline.transparentize(30%)), inset: (top: 2.6mm), {
    set par(leading: 0.46em)
    grid(columns: (1fr, auto), column-gutter: 3mm, align: (left + bottom, right + bottom),
      text(size: 11pt, weight: 700)[#ctx.copy.earlier #text(weight: 400, fill: P.muted)[· #n #if n == 1 { ctx.copy.role } else { ctx.copy.roles }]],
      dates(ctx, totals.from, totals.to, size: 11pt))
    for j in jobs {
      block(above: 1.6mm, below: 0mm, grid(columns: (1fr, auto), column-gutter: 3mm,
        text(size: 9.6pt)[#text(weight: 600, j.role) #text(fill: P.muted)[· #j.employer, #j.place]],
        {
          let (a, b) = (j.from.slice(3), if "to" in j { j.to.slice(3) } else { ctx.copy.present })
          text(font: ctx.theme.fonts.figures, size: 10.5pt, fill: P.date, if a == b { a } else { a + "–" + b })
        }))
    }
  })
}

// Education in reading order, one entry a row: the qualification, its note (usually the dates) where
// the roles keep theirs, the institution under it, behind showcase's metal rule.
#let education(ctx, entries) = {
  let P = tokens(ctx)
  for (i, e) in entries.enumerate() {
    block(width: 100%, above: if i == 0 { 0mm } else { 2.6mm }, below: 0mm, stroke: (left: 1.6pt + P.metal), inset: (left: 3mm, y: 0.3mm), {
      set par(leading: 0.42em)
      grid(columns: (1fr, auto), column-gutter: 4mm, align: (left + top, right + top),
        {
          text(size: 10.5pt, weight: 700, e.qualification)
          linebreak()
          text(size: 9.4pt, fill: P.muted, e.institution)
        },
        if e.at("note", default: "") != "" { text(size: 9.4pt, weight: 600, fill: P.date, e.note) })
    })
  }
}

// Each language with its level in words or a named certificate, never a scale.
#let languages(ctx, entries) = {
  let P = tokens(ctx)
  for (i, l) in entries.enumerate() {
    block(width: 100%, above: if i == 0 { 0mm } else { 2mm }, below: 0mm, {
      set par(leading: 0.42em)
      grid(columns: (auto, 1fr), column-gutter: 2mm, text(size: 10pt, weight: 700, l.name), align(right, text(size: 9.4pt, weight: 600, fill: P.date, l.level)))
      if "note" in l { block(above: 1mm, below: 0mm, text(size: 9pt, fill: P.muted, l.note)) }
    })
  }
}

// The destinations a person knows: the region, the domain's totals over every trip, each trip's
// period, length, kind and stops (known well filled, passed through open). The areas known well say
// again what the filled dots say, so this page leaves them out.
#let destinations(ctx, places, totals) = {
  let P = tokens(ctx)
  let fonts = ctx.theme.fonts
  let plural(n, one, many) = str(n) + " " + if n == 1 { one } else { many }
  set par(leading: 0.44em)
  block(below: 2.2mm, {
    text(size: 10.5pt, weight: 700, places.region)
    if "native" in places { h(1.4mm); text(font: fonts.japanese, size: 9pt, fill: P.muted, places.native) }
    linebreak()
    text(size: 9pt, fill: P.muted, (plural(totals.trips, ctx.copy.trip, ctx.copy.trips), str(totals.days) + " " + ctx.copy.days,
      plural(totals.stops, ctx.copy.place, ctx.copy.places)).join(" · "))
  })
  for trip in places.trips {
    block(above: 0mm, below: 2.4mm, {
      text(size: 9.6pt, weight: 700, trip.period)
      h(1.4mm)
      text(font: fonts.figures, size: 11pt, fill: P.accent, str(trip.days))
      h(0.6mm)
      text(size: 8.6pt, weight: 600, fill: P.accent, ctx.copy.days)
      linebreak()
      text(size: 9pt, fill: P.muted, trip.kind)
      block(above: 1.2mm, below: 0mm, text(size: 9.2pt, trip.stops.map(stop => {
        let known = stop.at("known", default: false)
        box[#dot(P, known)#h(0.9mm)#text(weight: if known { 600 } else { 400 }, stop.name)]
      }).join([#h(1.4mm) ])))
    })
  }
  block(above: 0mm, below: 0mm, text(size: 8.4pt, fill: P.muted)[#dot(P, true)#h(1mm)#ctx.copy.known #h(2mm) #dot(P, false)#h(1mm)#ctx.copy.passed])
}

// Practical know-how run in: the lead, the items between dots, then the basics.
#let practical(ctx, know-how) = {
  let P = tokens(ctx)
  set par(leading: 0.46em)
  text(size: 9.2pt)[#text(weight: 700, know-how.lead): #know-how.items.join([ #text(fill: P.metal, weight: 700)[·] ]).]
  if "basics" in know-how {
    block(above: 1.8mm, below: 0mm, text(size: 9.2pt)[#text(weight: 700, know-how.basics.label): #know-how.basics.text.])
  }
}
