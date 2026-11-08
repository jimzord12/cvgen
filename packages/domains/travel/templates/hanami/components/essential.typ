// The parts of Hanami's `essential` Template Variation: one calm, scan-first page in Hanami's theme,
// type and artwork. The name block in a shallow band with one sakura branch (the page's one motif),
// the profile row, then each role's title, employer and dates where the eye lands, and the facts a
// recruiter checks for a tour leader on a rail beside them. Every text is real text; no ratings. Capitals
// keep their tracking near 0.09 em: wider, and a PDF's text (and an ATS) splits the words into letters.
#import "art.typ": art, at, caps, diamond, hex, keep-end, label, line-art, sakura, tokens

// A lead-in (essential's display rule, no new field): a bullet written "Lead phrase: the rest" shows its
// lead in bold, so a role's bullets scan at a glance. The lead is what comes before the first ": ", when
// it is at most five words and 40 characters and something follows; anything else is plain text, so a
// sentence that only happens to hold a colon ("Call centre for a regional airline: answering…") is not
// cut in two.
#let lead-in(s, weight: 700) = {
  let i = s.position(": ")
  if i == none { return keep-end(s) }
  let head = s.slice(0, i)
  let rest = s.slice(i + 2).trim()
  if rest == "" or head.split(" ").filter(w => w != "").len() > 5 or head.clusters().len() > 40 { return keep-end(s) }
  [#text(weight: weight, head): #keep-end(rest)]
}
// Bullets with Hanami's metal diamond; each may carry a lead-in.
#let bullets(ctx, list, size: 10pt, gap: 1.5mm) = {
  let P = tokens(ctx)
  for (i, b) in list.enumerate() {
    block(above: if i == 0 { 0mm } else { gap }, below: 0mm, grid(columns: (4mm, 1fr), diamond(P), text(size: size, lead-in(b))))
  }
}

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

// The name block: name, rank and specialty with the seal words, contacts in up to two rows; and the
// width it may take (to the portrait's ring, or the margin without one).
#let name-block(ctx, d) = {
  let P = tokens(ctx)
  let fonts = ctx.theme.fonts
  let PD = ctx.layout.portrait
  let portrait = d.identity.at("portrait", default: none)
  let W = if portrait != none { 194mm - PD - 1.6mm - 8mm - 16mm } else { 178mm }
  let name = text(font: fonts.display, size: 31pt, weight: 800, tracking: 0.6pt, fill: P.hero-text, top-edge: "cap-height", bottom-edge: "baseline", caps(d.identity.name))
  let specialty = d.identity.at("specialty", default: none)
  // the rank on showcase's red tab, white on red; the specialty beside it in the band's own ink
  let rank = {
    box(fill: P.accent, inset: (x: 2.2mm, y: 1.5mm), {
      label(ctx, d.identity.rank, fill: P.plate, size: 8.4pt, track: 0.09em)
      // the rank's word in Japanese, only with an artwork pack that speaks it (the plain pack does not)
      if ctx.copy.tab-native != "" and ctx.artwork.at("native-words", default: true) { h(1.4mm); text(font: fonts.japanese, size: 8pt, fill: P.plate, ctx.copy.tab-native) }
    })
    // the same inset, unpainted, so both sit on one baseline
    if specialty != none { h(0.2mm); box(inset: (x: 2.2mm, y: 1.5mm), label(ctx, specialty, fill: P.hero-text, size: 8.4pt, track: 0.09em)) }
    // the credential behind the rank (its seal words), quieter, after a hairline
    let seal = d.identity.at("seal", default: ())
    if seal.len() > 0 {
      box(height: 3.2mm, baseline: 0.4mm, line(angle: 90deg, length: 3.2mm, stroke: 0.5pt + P.hero-label))
      box(inset: (x: 2.2mm, y: 1.5mm), label(ctx, seal.join(" · "), fill: P.hero-label, size: 7.6pt, track: 0.09em))
    }
  }
  let entry(c) = stack(spacing: 1.5mm, label(ctx, c.label, fill: P.hero-label, size: 6.6pt, track: 0.09em),
    text(size: 9.8pt, fill: P.hero-text, top-edge: "cap-height", bottom-edge: "baseline", if "href" in c { link(c.href, c.value) } else { c.value }))
  let rows = (d.contacts.at("left", default: ()), d.contacts.at("right", default: ())).filter(r => r.len() > 0)
  let columns = calc.max(0, ..rows.map(r => r.len()))
  assert(columns <= 3, message: "Hanami essential: the band holds three contacts a row; move one to the other row or drop it")
  let contacts = if rows.len() > 0 {
    grid(columns: (auto,) * columns, column-gutter: 8mm, row-gutter: 3.4mm, ..rows.map(r => r + ([],) * (columns - r.len())).flatten().map(c => if c == [] { c } else { entry(c) }))
  }
  let checks = context {
    assert(measure(name).width <= W, message: "Hanami essential: the name is wider than the band; shorten it (a middle name can go)")
    assert(measure(rank).width <= W, message: "Hanami essential: the rank, specialty and seal words are wider than the band; shorten identity.seal or the specialty")
    assert(contacts == none or measure(contacts).width <= W, message: "Hanami essential: the contacts are wider than the band; shorten one or move it to the other row")
  }
  (block(width: W, { checks; stack(spacing: 4.4mm, name, rank, v(2.6mm), contacts) }), W)
}

// The band's height (call in context): the name block 10 mm from the top and 8.5 mm of band under
// it, room for the portrait's ring, at most the layout's band. One contact row makes a shallower band.
#let band-height(ctx, d) = {
  let (content, _) = name-block(ctx, d)
  let fit = 10mm + measure(content).height + 8.5mm
  let ring = if d.identity.at("portrait", default: none) != none { ctx.layout.portrait + 12mm } else { 0mm }
  calc.min(ctx.layout.band, calc.max(fit, ring))
}

// The band, `B` high: the name block; the portrait, when the record has one, in a metal ring on the
// right; the artwork pack's one motif: the Japan pack's sakura branch across the top right corner, or
// the plain pack's route arc above the contacts (`band-motif`).
#let band(ctx, d, B) = {
  let P = tokens(ctx)
  at(0mm, 0mm, rect(width: 210mm, height: B, fill: P.hero))
  let portrait = d.identity.at("portrait", default: none)
  let motif = ctx.artwork.at("band-motif", default: "canopy")
  if motif == "canopy" {
    // without a portrait the branch grows, so its blossoms reach down into the corner the portrait leaves
    place(top + right, art(ctx, "canopy", width: if portrait != none { 104mm } else { ctx.layout.canopy }, swaps: sakura(ctx.theme.sakura.hero, P.hero)))
  } else {
    // a route arc in the band's line colour, right of the name and above the contacts, ending at the
    // portrait's ring or at the margin
    let w = if portrait != none { 58mm } else { 74mm }
    place(top + right, dx: if portrait != none { -(ctx.layout.portrait + 20mm) } else { -16mm }, dy: 6mm,
      art(ctx, motif, width: w, swaps: line-art(P)))
  }
  let PD = ctx.layout.portrait
  let PX = 194mm - PD
  let PY = (B - PD) / 2 + 1.5mm
  if portrait != none {
    at(PX - 1.6mm, PY - 1.6mm, circle(radius: PD / 2 + 1.6mm, fill: P.plate, stroke: 1.4pt + P.ring))
    at(PX, PY, box(width: PD, height: PD, radius: 50%, clip: true, stroke: 0.6pt + P.ring,
      image(portrait, width: PD, height: PD, fit: "cover", alt: d.identity.at("portrait-alt", default: d.identity.name))))
  }
  at(16mm, 10mm, name-block(ctx, d).first())
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

// A licence's day ("31 Mar 2029", as the contract stores it) in the page's words: the month from
// copy.months, so a Greek page reads a Greek month.
#let day(ctx, value) = {
  let (d, m, y) = value.split(" ")
  let english = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
  (d, ctx.copy.months.at(english.position(x => x == m)), y).join(" ")
}

// The licences (travel contract version 2) at the head of the rail, or beside the lead when the rail is
// full: a headline with the day each is valid until, its title, its issuer and region, behind the
// accent rule.
#let licences(ctx, list) = {
  let P = tokens(ctx)
  block(width: 100%, stroke: (left: 1.6pt + P.accent), inset: (left: 3mm, y: 0.4mm), {
    set par(leading: 0.44em)
    for (i, l) in list.enumerate() {
      if i > 0 { v(1.6mm) }
      // the headline says what it is and how long it holds, as availability's does
      label(ctx, (ctx.copy.licence, ..if "until" in l { (ctx.copy.valid-until + " " + day(ctx, l.until),) }).join(" · "), fill: P.accent, size: 7.2pt, track: 0.09em)
      linebreak()
      text(size: 10pt, weight: 700, l.title)
      linebreak()
      text(size: 9pt, fill: P.muted, (l.issuer, ..if "region" in l { (l.region,) }).join(" · "))
    }
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
    block(above: 1.4mm, below: 0mm, label(ctx, j.employer + " · " + j.place, fill: P.label, size: 8pt, track: 0.09em))
    if "intro" in j { block(above: 1.8mm, below: 0mm, text(size: 9.6pt, fill: P.muted, j.intro)) }
    block(above: 2.4mm, below: 0mm, bullets(ctx, j.bullets, size: 10pt, gap: 1.5mm))
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
// as one line of title, employer and its years, quieter than the span.
#let earlier(ctx, totals, jobs) = {
  let P = tokens(ctx)
  let n = totals.roles
  block(width: 100%, breakable: false, stroke: (top: 0.5pt + P.keyline.transparentize(30%)), inset: (top: 2.6mm), {
    set par(leading: 0.46em)
    grid(columns: (1fr, auto), column-gutter: 3mm, align: (left + bottom, right + bottom),
      text(size: 11pt, weight: 700)[#ctx.copy.earlier #text(weight: 400, fill: P.muted)[· #n]],
      dates(ctx, totals.from, totals.to, size: 11pt))
    for j in jobs {
      block(above: 1.6mm, below: 0mm, grid(columns: (1fr, auto), column-gutter: 3mm,
        text(size: 9.6pt)[#text(weight: 600, j.role) #text(fill: P.muted)[· #j.employer, #j.place]],
        {
          let (a, b) = (j.from.slice(3), if "to" in j { j.to.slice(3) } else { ctx.copy.present })
          text(font: ctx.theme.fonts.figures, size: 9.6pt, fill: P.muted, if a == b { a } else { a + "–" + b })
        }))
    }
  })
}

// Education in reading order, one entry a row behind showcase's metal rule: the qualification, the
// institution under it, and its note (usually the dates) in the roles' figures where the roles keep
// their dates; on the rail (`narrow`) the note goes under the institution.
#let education(ctx, entries, narrow: false) = {
  let P = tokens(ctx)
  let note(e) = if e.at("note", default: "") != "" { text(font: ctx.theme.fonts.figures, size: 10.5pt, fill: P.date, e.note) }
  for (i, e) in entries.enumerate() {
    block(width: 100%, above: if i == 0 { 0mm } else { 2.6mm }, below: 0mm, stroke: (left: 1.6pt + P.metal), inset: (left: 3mm, y: 0.3mm), {
      set par(leading: 0.42em)
      let what = {
        text(size: if narrow { 10pt } else { 10.5pt }, weight: 700, e.qualification)
        linebreak()
        text(size: if narrow { 9pt } else { 9.4pt }, fill: P.muted, e.institution)
      }
      if narrow { what; if note(e) != none { linebreak(); note(e) } }
      else { grid(columns: (1fr, auto), column-gutter: 4mm, align: (left + top, right + top), what, note(e)) }
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
// period, length and role (contract version 2: a led group in the accent, never confused with a trip
// the person organised or travelled on), its kind and stops, then the areas known. The region's own
// script, the route, the stamps and the story are travel-story, which this page leaves out.
#let destinations(ctx, places, totals) = {
  let P = tokens(ctx)
  let fonts = ctx.theme.fonts
  let plural(n, one, many) = str(n) + " " + if n == 1 { one } else { many }
  set par(leading: 0.44em)
  block(below: 2.2mm, {
    text(size: 10.5pt, weight: 700, places.region)
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
      if "role" in trip {
        h(1.8mm)
        // one box, so the label moves to the next line whole
        box(label(ctx, ctx.copy.at("role-" + trip.role), fill: if trip.role == "led" { P.accent } else { P.label }, size: 7pt, track: 0.09em))
      }
      linebreak()
      text(size: 9pt, fill: P.muted, trip.kind)
      // the stops, those known well in bold, as the areas below name them
      // each dot travels with the stop after it, so no line ends on a dot
      block(above: 1.2mm, below: 0mm, text(size: 9.2pt, trip.stops.enumerate().map(((i, stop)) => {
        let name = text(weight: if stop.at("known", default: false) { 700 } else { 400 }, stop.name)
        if i == 0 { box(name) } else { box[#text(fill: P.metal)[·] #name] }
      }).join(" ")))
    })
  }
  for (i, entry) in places.at("areas", default: ()).enumerate() {
    block(above: if i == 0 { 0.4mm } else { 1.4mm }, below: 0mm, text(size: 9pt)[#text(weight: 700, entry.label): #entry.places.])
  }
}

// Practical know-how as a short list: the lead, then one item a line, each with its bold label when it
// is written "Label: what" (the lead-in rule), and the basics last with theirs; the eye runs down the
// labels as it runs down the roles' titles.
#let practical(ctx, know-how) = {
  let P = tokens(ctx)
  set par(leading: 0.44em)
  block(below: 1.6mm, text(size: 9pt, fill: P.muted, know-how.lead))
  let list = know-how.items + if "basics" in know-how { (know-how.basics.label + ": " + know-how.basics.text,) } else { () }
  for (i, item) in list.enumerate() {
    block(above: if i == 0 { 0mm } else { 1.3mm }, below: 0mm, grid(columns: (3.2mm, 1fr), diamond(P), text(size: 9.2pt, lead-in(item))))
  }
}
