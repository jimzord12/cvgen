// Guilloche: the CV opens under a band engraved like security print: a woven
// underprint, a rosette with a globe at its heart and a rainbow tint, the cut-out
// portrait standing on the band's engraved foot. The engraved line carries on as
// the body's section rules and the rule between its columns. Condensed density, stylish tier. The monochrome file is
// generated from this one (mono flag and root path switched); see ../../brief.md.
#let mono = true
#let root = ""
#let d = json(root + "sample.json")
#let portrait = root + (if mono { "portrait-mono.png" } else { "portrait.png" })

// palette: deep green-black ink, engraved green, rose, a mint-peach-lilac rainbow tint;
// mono: black hairlines on white, one grey
#let ink = if mono { rgb("#111111") } else { rgb("#17302B") }
#let green = if mono { rgb("#111111") } else { rgb("#1E6B58") }
#let rose = if mono { rgb("#111111") } else { rgb("#A8385F") }
#let soft = if mono { rgb("#5E5E5E") } else { rgb("#4D6560") }
#let line-a = if mono { rgb("#000000") } else { rgb("#2C8A70") }
#let line-b = if mono { rgb("#5A5A5A") } else { rgb("#C25E86") }
#let card-fill = if mono { white } else {
  gradient.linear(rgb("#CDEADB"), rgb("#F4E0CA"), rgb("#E0D8F0"), angle: 0deg)
}

#let arch-fill = if mono { rgb("#B9B9B9") } else { rgb("#8DBBA9") }

#let sans = "Fira Sans"
#let mono-font = "IBM Plex Mono"

#set page(paper: "a4", margin: (left: 15mm, right: 15mm, top: 106mm, bottom: 10mm), fill: white)
#set text(font: sans, size: 9.9pt, fill: ink, lang: "en")
#set par(leading: 0.5em, spacing: 0.6em)

// ---------- engraving ----------
#let poly(pts, stroke, closed: false) = curve(stroke: stroke, curve.move(pts.at(0)),
  ..pts.slice(1).map(p => curve.line(p)), ..if closed { (curve.close(),) } else { () })

// a woven rosette: n phase-shifted copies of a lobed circle
#let rosette(c, r0, amp, k, n, col, w: 0.35pt) = {
  for j in range(n) {
    let pts = range(0, 360, step: 2).map(i => {
      let t = i * 1deg
      let r = r0 + amp * calc.sin(k * t + j * 360deg / n)
      (c.at(0) + r * calc.cos(t), c.at(1) + r * calc.sin(t))
    })
    place(top + left, poly(pts, w + col, closed: true))
  }
}

// an engraved band: modulated sine lines woven across a width
#let waveband(w, h, n: 9, periods: 14, col: line-a, col2: line-b, wt: 0.4pt) = box(width: w, height: h, {
  for j in range(n) {
    let pts = range(0, 241).map(i => {
      let x = i / 240
      (x * w, h / 2 + (h / 2) * calc.sin(x * periods * 360deg + j * 360deg / n) * (0.55 + 0.45 * calc.cos(x * 3 * 360deg)))
    })
    place(top + left, poly(pts, wt + (if calc.rem(j, 2) == 0 { col } else { col2 })))
  }
})

// ---------- parts ----------
#let lbl(t) = text(font: mono-font, size: 6.8pt, weight: 500, fill: soft, tracking: 0.6pt, upper(t))
#let field(k, val, size: 9.6pt) = stack(spacing: 1.1mm, lbl(k), text(weight: 500, size: size, val))
// no runts: the last words of a running line are bound together (three, or four in a long line)
#let tie(s) = {
  let w = s.split(" ")
  let k = if w.len() >= 10 { 4 } else { 3 }
  if w.len() < 5 { s } else { w.slice(0, -k).join(" ") + " " + w.slice(-k).join(str(sym.space.nobreak)) }
}

// an institution "Name, qualifier" breaks at its comma, never mid-phrase
#let at-comma(s) = { let p = s.split(", "); if p.len() < 2 { s } else { [#p.at(0),#linebreak()#p.slice(1).join(", ")] } }

// an engraved globe: meridians and parallels on a pale sphere, a double rim
#let globe(c, gr, col, fill: none) = {
  place(top + left, dx: c.at(0) - gr, dy: c.at(1) - gr, circle(radius: gr, fill: fill, stroke: 1pt + col))
  place(top + left, dx: c.at(0) - gr - 1.4mm, dy: c.at(1) - gr - 1.4mm, circle(radius: gr + 1.4mm, stroke: 0.4pt + col))
  for lon in (18deg, 38deg, 56deg, 72deg, 84deg) {
    let rx = gr * calc.cos(lon)
    place(top + left, dx: c.at(0) - rx, dy: c.at(1) - gr, ellipse(width: 2 * rx, height: 2 * gr, stroke: 0.35pt + col))
  }
  place(top + left, dx: c.at(0), dy: c.at(1) - gr, line(length: 2 * gr, angle: 90deg, stroke: 0.35pt + col))
  for lat in (-60deg, -40deg, -20deg, 0deg, 20deg, 40deg, 60deg) {
    let y = c.at(1) + gr * calc.sin(lat)
    let hw = gr * calc.cos(lat)
    place(top + left, line(start: (c.at(0) - hw, y), end: (c.at(0) + hw, y), stroke: (if lat == 0deg { 0.6pt } else { 0.35pt }) + col))
  }
}

// an airliner seen from above, drawn as an engraved outline (nose towards -y before rotation)
#let airliner(s, col, fill) = box(width: s, height: s, {
  let u = s / 10
  place(top + left, polygon(fill: fill, stroke: (paint: col, thickness: 0.6pt, join: "round"),
    (5*u, 0*u), (5.6*u, 0.7*u), (5.75*u, 3.4*u), (9.8*u, 5.9*u), (9.8*u, 6.8*u), (5.75*u, 5.7*u), (5.55*u, 8.3*u),
    (6.9*u, 9.3*u), (6.9*u, 9.9*u), (5*u, 9.5*u), (3.1*u, 9.9*u), (3.1*u, 9.3*u), (4.45*u, 8.3*u), (4.25*u, 5.7*u),
    (0.2*u, 6.8*u), (0.2*u, 5.9*u), (4.25*u, 3.4*u), (4.4*u, 0.7*u)))
  // engraved detail: the fuselage line and the engine pods
  place(top + left, line(start: (5*u, 1.2*u), end: (5*u, 8.6*u), stroke: 0.35pt + col))
  for x in (2.7, 7.3) { place(top + left, dx: (x - 0.35)*u, dy: 4.5*u, rect(width: 0.7*u, height: 1.4*u, fill: col, stroke: none)) }
})

// dotted routes from home to destinations over the globe; a plane flies one of them
#let routes(c, home, stops, plane-on, col, dot-fill) = {
  let at(p) = (c.at(0) + p.at(0), c.at(1) + p.at(1))
  let curve-pts(a, b) = {
    let (ax, ay) = at(a)
    let (bx, by) = at(b)
    let mx = (ax + bx) / 2
    let my = (ay + by) / 2
    // control point lifted away from the chord, as a great-circle arc reads on a globe
    let lift = calc.sqrt(calc.pow((bx - ax) / 1mm, 2) + calc.pow((by - ay) / 1mm, 2)) * 0.32mm
    let ctl = (mx, my - lift)
    range(0, 41).map(i => {
      let t = i / 40
      ((1 - t) * (1 - t) * ax + 2 * (1 - t) * t * ctl.at(0) + t * t * bx,
       (1 - t) * (1 - t) * ay + 2 * (1 - t) * t * ctl.at(1) + t * t * by)
    })
  }
  for (k, b) in stops.enumerate() {
    let pts = curve-pts(home, b)
    place(top + left, poly(pts, (paint: col, thickness: 0.9pt, dash: "densely-dotted", cap: "round")))
    place(top + left, dx: at(b).at(0) - 1.5mm, dy: at(b).at(1) - 1.5mm, circle(radius: 1.5mm, fill: dot-fill, stroke: 0.8pt + white))
    if k == plane-on {
      let i = 26
      let (x0, y0) = pts.at(i - 1)
      let (x1, y1) = pts.at(i + 1)
      let ang = calc.atan2((x1 - x0) / 1mm, (y1 - y0) / 1mm) + 90deg
      let (px, py) = pts.at(i)
      place(top + left, dx: px - 5mm, dy: py - 5mm, rotate(ang, airliner(10mm, col, white)))
    }
  }
  place(top + left, dx: at(home).at(0) - 2.2mm, dy: at(home).at(1) - 2.2mm, circle(radius: 2.2mm, fill: white, stroke: 1pt + col))
  place(top + left, dx: at(home).at(0) - 0.9mm, dy: at(home).at(1) - 0.9mm, circle(radius: 0.9mm, fill: col, stroke: none))
}

// a vertical engraved rule (the waveband turned on end)
#let vwaveband(h, w, n: 4, col: line-a, col2: line-b, wt: 0.4pt) = box(width: w, height: h, {
  let periods = calc.floor(h / 6mm)
  for j in range(n) {
    let pts = range(0, 601).map(i => {
      let y = i / 600
      (w / 2 + (w / 2) * calc.sin(y * periods * 360deg + j * 360deg / n) * (0.55 + 0.45 * calc.cos(y * 7 * 360deg)), y * h)
    })
    place(top + left, poly(pts, wt + (if calc.rem(j, 2) == 0 { col } else { col2 })))
  }
})

// ---------- the engraved header band, full width ----------
#let Hb = 97mm
#let band = box(width: 210mm, height: Hb, clip: true, {
  place(top + left, rect(width: 210mm, height: Hb, fill: card-fill, stroke: none))
  // underprint of woven waves across the whole band
  for k in range(10) {
    place(top + left, dy: 2mm + k * 10mm, waveband(210mm, 9mm, n: 5, periods: 10 + calc.rem(k, 2),
      col: line-a.transparentize(if mono { 80% } else { 80% }), col2: line-b.transparentize(if mono { 78% } else { 82% }), wt: if mono { 0.25pt } else { 0.3pt }))
  }
  // the travel globe (round 5, owner): bigger, with dotted routes from home to destinations
  // in Europe and Asia, and a drawn airliner on one of them. Its rim stays 4 mm inside the page edge (D21).
  let gc = (181.5mm, 50mm)
  let gr = 22.5mm
  globe(gc, gr, line-a, fill: if mono { white } else { rgb("#F7F1E8") })
  routes(gc, (-5mm, 0mm),
    ((-15mm, -9mm), (-4mm, -15mm), (15mm, -7mm), (12mm, 8mm)),
    2, if mono { ink } else { rose }, if mono { ink } else { rose })
})

#set page(background: {
  place(top + left, band)
  // the portrait arch (round 5, owner): its own mid-tone ground with a fine engraved halo, so the
  // dark hair and the white shirt both separate from it; it runs down behind the band's foot
  let aw = 60mm
  let ah = 79mm
  let ay = Hb - 76mm
  place(top + left, dx: 12mm, dy: ay, box(width: aw, height: ah, clip: true, radius: (top-left: aw / 2, top-right: aw / 2), {
    place(top + left, rect(width: aw, height: ah, fill: arch-fill, stroke: none))
    rosette((aw / 2, 30mm), 26mm, 2.4mm, 16, 16, white.transparentize(if mono { 45% } else { 50% }), w: 0.3pt)
    rosette((aw / 2, 30mm), 17mm, 2mm, 12, 12, white.transparentize(if mono { 45% } else { 50% }), w: 0.3pt)
    image(portrait, width: aw, height: ah, fit: "cover")
  }))
  place(top + left, dx: 12mm, dy: ay, box(width: aw, height: ah, radius: (top-left: aw / 2, top-right: aw / 2),
    stroke: (top: 0.8pt + line-a, left: 0.8pt + line-a, right: 0.8pt + line-a)))
  // the band's foot, the engraved "helix", runs in front of the arch across the shirt
  place(top + left, dy: Hb - 3.4mm, rect(width: 210mm, height: 6.8mm, fill: white.transparentize(if mono { 30% } else { 45% }), stroke: none))
  place(top + left, dy: Hb - 3.4mm, waveband(210mm, 6.8mm, n: 9, periods: 34, wt: if mono { 0.35pt } else { 0.45pt }))
  // header strip and identity, set on the band
  place(top + left, dx: 15mm, dy: 9mm, text(font: mono-font, weight: 600, size: 8pt, tracking: 2pt, fill: ink)[CURRICULUM VITAE])
  place(top + right, dx: -15mm, dy: 9mm, text(font: mono-font, weight: 600, size: 8pt, tracking: 2pt, fill: ink)[TRAVEL · GROUP & PRIVATE])
  place(top + left, dx: 79mm, dy: 25mm, block(width: 79mm, {
    text(weight: 700, size: 32pt, tracking: 0.2pt, top-edge: "cap-height", bottom-edge: "baseline", d.name)
    v(3.6mm)
    text(weight: 600, size: 14.5pt, fill: rose, d.title)
    v(1.4mm)
    text(weight: 500, size: 11pt, d.specialty + ", Europe and Asia")
    v(4.6mm)
    grid(columns: (1.25fr, 1fr), column-gutter: 4mm, row-gutter: 3mm,
      field("Phone", d.contacts.phone),
      field("Based in", d.contacts.based),
      field("Email", d.contacts.email, size: 9.2pt),
      field("Date of birth", d.contacts.born),
      field("Passport", d.contacts.passport),
      field("Nationality", d.contacts.nationality),
    )
  }))
})

// ---------- body ----------
#let section(title, above: 7.6mm) = block(above: above, below: 3.4mm, width: 100%, {
  text(font: mono-font, weight: 600, size: 9pt, tracking: 0.9pt, fill: green, upper(title))
  v(-0.4mm)
  layout(s => waveband(s.width, 3.8mm, n: 5, periods: calc.floor(s.width / 6mm), wt: if mono { 0.5pt } else { 0.6pt }))
})
#let mono-date(t) = text(font: mono-font, weight: 600, size: 9pt, fill: rose, t)

#let main-col = {
    section("Profile", above: 0mm)
    text(size: 10.4pt, weight: 500, tie(d.profile))
    section("Experience")
    for (n, j) in d.experience.enumerate() {
      block(above: if n == 0 { 0mm } else { 3.4mm }, below: 0mm, {
        grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
          text(weight: 700, size: 12pt, j.role),
          mono-date(j.from + " – " + j.to))
        v(0.4mm)
        text(weight: 600, fill: green, j.employer)
        text(fill: soft, [ · #j.place])
        if "intro" in j { linebreak(); text(style: "italic", size: 8.9pt, fill: soft, tie(j.intro)) }
        v(1.6mm)
        for b in j.bullets {
          block(below: 1.9mm, grid(columns: (3.6mm, 1fr),
            pad(top: 2.6pt, box(width: 4pt, height: 4pt, stroke: 0.7pt + rose, radius: 2pt)),
            [*#b.lead:* #tie(b.text)]))
        }
      })
    }
    section("Education")
    for e in d.education {
      block(below: 3mm, grid(columns: (1fr, auto), align: (left, right),
        [*#e.qualification* \ #text(fill: soft, at-comma(e.institution))],
        mono-date(e.years)))
    }
}
#let side-col = {
    section("Languages", above: 0mm)
    for l in d.languages {
      block(below: 2mm, {
        grid(columns: (1fr, auto), text(weight: 600, l.name), mono-date(l.level))
        if "note" in l { text(size: 8.5pt, fill: soft, tie(l.note)) }
      })
    }
    section(d.skills.heading)
    for s in d.skills.items { block(below: 2mm, [*#s.lead:* #tie(s.text + ".")]) }
    section("Availability")
    text(weight: 700, d.availability.headline)
    linebreak()
    text(size: 8.9pt, tie(d.availability.text))
    section("Recent journeys")
    for t in d.journeys.trips {
      block(below: 2.6mm, [#mono-date(upper(t.period)) \ *#t.stops.join(" – ")* \ #text(size: 8.5pt, fill: soft)[#t.days days, #t.role]])
    }
}

// the two columns with the vertical engraved rule between them, ending with the longer column
#context {
  let wl = 180mm - 60mm - 9mm
  let h = calc.max(measure(block(width: wl, main-col)).height, measure(block(width: 60mm, side-col)).height)
  grid(columns: (wl, 9mm, 60mm), main-col, align(center, vwaveband(h, 2.4mm, n: 3, wt: 0.35pt)), side-col)
}

#v(1fr)
// the page closes on the same engraved border as the band's foot
#block(below: 2.4mm, waveband(180mm, 4.4mm, n: 7, periods: 30, wt: if mono { 0.3pt } else { 0.4pt }))
#text(font: mono-font, size: 6.6pt, fill: soft, tracking: 1pt, upper(d.disclosure))
