// Guilloche: the CV opens under a band engraved like security print: a woven
// underprint on a rainbow tint that fades into the page, an engraved travel globe
// with great-circle routes and an airliner, the cut-out portrait in an arch behind
// a tapering guilloche "helix". The engraved line carries on as the body's section
// rules and the rule between its columns. Condensed density, stylish tier. The monochrome file is
// generated from this one (mono flag and root path switched); see ../../brief.md.
#let mono = false
#let root = "../../"
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

// ---------- the travel globe, engraved (round 6, owner) ----------
// orthographic view with the axis tilted; (lon, lat) on the sphere -> a point on the page.
// `lift` raises a point above the surface, so a flight path arcs off the globe.
#let tilt = -18deg
#let on-globe(c, r, lon, lat, lift: 1) = {
  let x = r * lift * calc.cos(lat) * calc.sin(lon)
  let y = -r * lift * calc.sin(lat)
  (c.at(0) + x * calc.cos(tilt) - y * calc.sin(tilt), c.at(1) + x * calc.sin(tilt) + y * calc.cos(tilt))
}

#let globe(c, r, col, fill: none) = {
  // the sphere and its engraved shading: horizontal lines whose weight follows the shadow side,
  // as a banknote engraver models a sphere, light from the upper left
  place(top + left, dx: c.at(0) - r, dy: c.at(1) - r, circle(radius: r, fill: fill, stroke: none))
  let (lx, ly, lz) = (-0.52, -0.56, 0.645)
  let pitch = 0.82mm
  let n = int(2 * r / pitch)
  for k in range(1, n) {
    let yy = -r + k * pitch
    let hw = calc.sqrt(calc.pow(r / 1mm, 2) - calc.pow(yy / 1mm, 2)) * 1mm
    let seg = 0.5mm
    let m = calc.max(1, int(2 * hw / seg))
    for i in range(m) {
      let x0 = -hw + i * 2 * hw / m
      let x1 = -hw + (i + 1) * 2 * hw / m
      let nx = (x0 + x1) / 2 / r
      let ny = yy / r
      let nz = calc.sqrt(calc.max(0, 1 - nx * nx - ny * ny))
      let lit = nx * lx + ny * ly + nz * lz
      let t = calc.min(1, calc.max(0, 1 - lit))
      if t > 0.42 {
        let w = 0.1pt + 0.9pt * calc.pow((t - 0.42) / 0.58, 1.3)
        place(top + left, line(start: (c.at(0) + x0, c.at(1) + yy), end: (c.at(0) + x1, c.at(1) + yy),
          stroke: (paint: col.transparentize(25%), thickness: w)))
      }
    }
  }
  // the graticule, every 15 degrees, front hemisphere only
  for lon in range(-75, 76, step: 15) {
    let pts = range(-90, 91, step: 3).map(lat => on-globe(c, r, lon * 1deg, lat * 1deg))
    place(top + left, poly(pts, 0.3pt + col))
  }
  for lat in range(-75, 76, step: 15) {
    let pts = range(-90, 91, step: 3).map(lon => on-globe(c, r, lon * 1deg, lat * 1deg))
    place(top + left, poly(pts, (if lat == 0 { 0.6pt } else { 0.3pt }) + col))
  }
  // the engraved bezel: a fine guilloche ring between two rims
  place(top + left, dx: c.at(0) - r, dy: c.at(1) - r, circle(radius: r, stroke: 0.8pt + col))
  rosette(c, r + 1.75mm, 0.85mm, 72, 5, col.transparentize(10%), w: 0.22pt)
  place(top + left, dx: c.at(0) - r - 3mm, dy: c.at(1) - r - 3mm, circle(radius: r + 3mm, stroke: 0.4pt + col))
}

// an airliner seen from above: long fuselage, swept wings and tailplane, engines under the wings;
// filled with an engraved hatch and set on a white knockout. Nose towards -y before rotation.
#let airliner(s, col) = box(width: s, height: s, {
  let u = s / 10
  let rhs = ((5.0, 0.0), (5.3, 0.45), (5.45, 1.3), (5.45, 3.5), (9.7, 6.15), (9.75, 6.75), (5.45, 5.55),
               (5.4, 8.25), (7.1, 9.35), (7.1, 9.8), (5.25, 9.55), (5.0, 10.0))
  let lhs = rhs.rev().slice(1, -1).map(p => (10 - p.at(0), p.at(1)))
  let pts = (rhs + lhs).map(p => (p.at(0) * u, p.at(1) * u))
  let hatch = tiling(size: (1.1pt, 1.1pt), place(top + left, line(start: (0pt, 0.55pt), end: (1.1pt, 0.55pt), stroke: 0.32pt + col)))
  place(top + left, polygon(fill: white, stroke: (paint: white, thickness: 2.6pt, join: "round"), ..pts))
  place(top + left, polygon(fill: hatch, stroke: (paint: col, thickness: 0.6pt, join: "round"), ..pts))
  // engine pods ahead of the wing's trailing edge, and the cockpit glazing
  for x in (2.55, 7.45) {
    place(top + left, dx: (x - 0.3) * u, dy: 4.4 * u, rect(width: 0.6 * u, height: 1.5 * u, radius: 0.3 * u, fill: col, stroke: 0.4pt + white))
  }
  place(top + left, dx: 4.72 * u, dy: 0.9 * u, rect(width: 0.56 * u, height: 0.35 * u, radius: 0.15 * u, fill: white, stroke: none))
})

// flight paths: great-circle arcs from home to each destination, lifted off the surface,
// dotted, ending in small destination dots; the airliner flies one of them
#let routes(c, r, home, stops, plane-on, col, dot-fill) = {
  let vec(lon, lat) = (calc.cos(lat) * calc.sin(lon), calc.sin(lat), calc.cos(lat) * calc.cos(lon))
  let arc(a, b) = {
    let va = vec(a.at(0), a.at(1))
    let vb = vec(b.at(0), b.at(1))
    let dot = va.at(0) * vb.at(0) + va.at(1) * vb.at(1) + va.at(2) * vb.at(2)
    let om = calc.acos(calc.min(1, dot))
    range(0, 49).map(i => {
      let t = i / 48
      let ka = calc.sin((1 - t) * om) / calc.sin(om)
      let kb = calc.sin(t * om) / calc.sin(om)
      let (px, py, pz) = (ka * va.at(0) + kb * vb.at(0), ka * va.at(1) + kb * vb.at(1), ka * va.at(2) + kb * vb.at(2))
      let lon = calc.atan2(pz, px)
      let lat = calc.asin(calc.min(1, calc.max(-1, py)))
      on-globe(c, r, lon, lat, lift: 1 + 0.17 * calc.sin(t * 180deg))
    })
  }
  for (k, b) in stops.enumerate() {
    let pts = arc(home, b)
    place(top + left, poly(pts, (paint: col, thickness: 0.95pt, dash: (0pt, 2.1pt), cap: "round")))
    let (bx, by) = on-globe(c, r, b.at(0), b.at(1))
    place(top + left, dx: bx - 1.1mm, dy: by - 1.1mm, circle(radius: 1.1mm, fill: dot-fill, stroke: 0.8pt + white))
    place(top + left, dx: bx - 1.85mm, dy: by - 1.85mm, circle(radius: 1.85mm, stroke: 0.3pt + col))
    if k == plane-on {
      // mid-route, so dotted trail shows behind the tail and ahead of the nose (D25, Codex D1)
      let i = 24
      let (x0, y0) = pts.at(i - 2)
      let (x1, y1) = pts.at(i + 2)
      let ang = calc.atan2((x1 - x0) / 1mm, (y1 - y0) / 1mm) + 90deg
      let (px, py) = pts.at(i)
      place(top + left, dx: px - 5.25mm, dy: py - 5.25mm, rotate(ang, airliner(10.5mm, col)))
    }
  }
  let (hx, hy) = on-globe(c, r, home.at(0), home.at(1))
  place(top + left, dx: hx - 2.3mm, dy: hy - 2.3mm, circle(radius: 2.3mm, fill: white, stroke: 1pt + col))
  place(top + left, dx: hx - 0.95mm, dy: hy - 0.95mm, circle(radius: 0.95mm, fill: col, stroke: none))
}

// the signature divider (round 6, owner): a twisted guilloche that tapers to nothing at both
// ends, so it emerges from the fading header and the white body instead of sitting as a strip.
// `bulge` is where along the width the band is fullest (over the shirt, D23).
#let helix(w, h, n: 9, periods: 34, wt: 0.4pt, bulge: 0.2) = box(width: w, height: h, {
  for j in range(n) {
    let pts = range(0, 601).map(i => {
      let x = i / 600
      // full strength in the middle, tapering smoothly to nothing over the last 9 % at each end
      let e = calc.min(1, calc.min(x, 1 - x) / 0.09)
      let win = e * e * (3 - 2 * e)
      let env = win * (0.62 + 0.38 * calc.cos((x - bulge) * 3 * 360deg))
      (x * w, h / 2 + (h / 2) * calc.sin(x * periods * 360deg + j * 360deg / n) * env)
    })
    place(top + left, poly(pts, wt + (if calc.rem(j, 2) == 0 { line-a } else { line-b }).transparentize(if mono { 0% } else { 10% })))
  }
})

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
  // the header's tint fades into the white page, so there is no edge where it stops (round 6)
  place(top + left, dy: Hb - 18mm, rect(width: 210mm, height: 18mm, stroke: none,
    fill: gradient.linear(white.transparentize(100%), white, angle: 90deg)))
  // the engraved travel globe (round 6, owner): its outer rim stays about 5 mm inside the page edge (D21)
  let gc = (180mm, 50mm)
  let gr = 21.5mm
  globe(gc, gr, line-a, fill: if mono { white } else { rgb("#F8F3EA") })
  routes(gc, gr, (-12deg, 14deg),
    ((-54deg, 34deg), (-24deg, 56deg), (40deg, 40deg), (62deg, 6deg)),
    3, if mono { ink } else { rose }, if mono { ink } else { rose })
})

#set page(background: {
  place(top + left, band)
  // the portrait arch: a plain mid-tone ground (round 6: no halo behind the head), so the dark
  // hair and the white shirt both separate from it. Its foot fades into the page under the helix.
  let aw = 60mm
  let ah = 80mm
  let ay = Hb - 76mm
  let fade = 15mm
  place(top + left, dx: 12mm, dy: ay, box(width: aw, height: ah, clip: true, radius: (top-left: aw / 2, top-right: aw / 2), {
    place(top + left, rect(width: aw, height: ah, fill: arch-fill, stroke: none))
    image(portrait, width: aw, height: ah, fit: "cover")
    place(top + left, dy: ah - fade, rect(width: aw, height: fade, stroke: none,
      fill: gradient.linear(white.transparentize(100%), white.transparentize(15%), white, angle: 90deg)))
  }))
  // the arch's engraved outline fades out with it
  place(top + left, dx: 12mm, dy: ay, box(width: aw, height: ah, radius: (top-left: aw / 2, top-right: aw / 2),
    stroke: (paint: gradient.linear((line-a, 0%), (line-a, 76%), (line-a.transparentize(100%), 94%), (line-a.transparentize(100%), 100%), angle: 90deg), thickness: 0.8pt)))
  // the helix: the single signature divider, crossing in front of the shirt, tapering into the page at both ends
  place(top + left, dx: 3mm, dy: Hb - 4.2mm, helix(204mm, 8.4mm, n: 9, periods: 36, wt: if mono { 0.35pt } else { 0.42pt }, bulge: (42mm - 3mm) / 204mm))
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
