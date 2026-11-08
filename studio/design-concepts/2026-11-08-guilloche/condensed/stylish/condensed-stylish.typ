// Guilloche: the CV opens as the data page of a travel document, engraved like
// security print: a woven rosette, a rainbow-tinted card, a ghost portrait and a
// machine-readable zone carrying her name. The body keeps the engraved line as
// its section rule. Condensed density, stylish tier. The monochrome file is
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
#let line-a = if mono { rgb("#111111") } else { rgb("#2C8A70") }
#let line-b = if mono { rgb("#8A8A8A") } else { rgb("#C25E86") }
#let card-fill = if mono { white } else {
  gradient.linear(rgb("#CDEADB"), rgb("#F4E0CA"), rgb("#E0D8F0"), angle: 0deg)
}
#let photo-bg = if mono { rgb("#E6E6E6") } else { rgb("#E8F1EC") }

#let sans = "Fira Sans"
#let mono-font = "IBM Plex Mono"

#set page(paper: "a4", margin: (left: 15mm, right: 15mm, top: 12mm, bottom: 10mm), fill: white)
#set text(font: sans, size: 9.6pt, fill: ink, lang: "en")
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
#let field(k, val, size: 9.8pt) = stack(spacing: 1.1mm, lbl(k), text(weight: 500, size: size, val))

#let mrz-lines = {
  let pad(s) = s + "<" * calc.max(0, 44 - s.len())
  (pad("CV<" + upper(d.family) + "<<" + upper(d.given)),
   pad("TOUR<LEADER<<TRAVEL<CONSULTANT<<GRC<970504"))
}

// ---------- the data page ----------
#let card-w = 180mm
#let card-h = 104mm
#block(width: card-w, height: card-h, radius: 3.5mm, clip: true, fill: card-fill, stroke: 0.6pt + ink, {
  // engraving behind everything: a light underprint of woven waves, then the rosette
  for k in range(7) {
    place(top + left, dy: 15mm + k * 10.5mm, waveband(card-w, 9mm, n: 5, periods: 9 + calc.rem(k, 2),
      col: line-a.transparentize(if mono { 84% } else { 82% }), col2: line-b.transparentize(if mono { 80% } else { 84% }), wt: 0.3pt))
  }
  rosette((card-w - 26mm, 45mm), 22mm, 2.6mm, 14, 18, line-a.transparentize(if mono { 55% } else { 35% }))
  rosette((card-w - 26mm, 45mm), 14mm, 2.2mm, 10, 14, line-b.transparentize(if mono { 45% } else { 30% }))
  place(top + left, dy: 3.4mm, waveband(card-w, 9mm, col: line-a.transparentize(if mono { 70% } else { 72% }), col2: line-b.transparentize(72%), wt: 0.35pt))
  // ghost portrait inside the rosette
  place(top + left, dx: card-w - 26mm - 8mm, dy: 45mm - 10mm,
    box(width: 16mm, height: 20mm, clip: true, radius: 1mm, {
      image(portrait, width: 16mm, height: 20mm, fit: "cover")
      place(top + left, rect(width: 16mm, height: 20mm, fill: white.transparentize(42%), stroke: none))
    }))
  // an engraved globe under the photo: meridians and parallels only
  let gr = 9mm
  let gc = (6mm + 18mm, 74.5mm)
  let gcol = line-a.transparentize(if mono { 20% } else { 10% })
  place(top + left, dx: gc.at(0) - gr, dy: gc.at(1) - gr, circle(radius: gr, stroke: 0.6pt + gcol))
  for lon in (20deg, 45deg, 70deg) {
    let rx = gr * calc.cos(lon)
    place(top + left, dx: gc.at(0) - rx, dy: gc.at(1) - gr, ellipse(width: 2 * rx, height: 2 * gr, stroke: 0.35pt + gcol))
  }
  place(top + left, dx: gc.at(0), dy: gc.at(1) - gr, line(length: 2 * gr, angle: 90deg, stroke: 0.35pt + gcol))
  for lat in (-60deg, -30deg, 0deg, 30deg, 60deg) {
    let y = gc.at(1) + gr * calc.sin(lat)
    let hw = gr * calc.cos(lat)
    place(top + left, line(start: (gc.at(0) - hw, y), end: (gc.at(0) + hw, y), stroke: 0.35pt + gcol))
  }
  // header strip
  place(top + left, dx: 6mm, dy: 4.8mm, text(font: mono-font, weight: 600, size: 8pt, tracking: 2pt, fill: ink)[CURRICULUM VITAE])
  place(top + right, dx: -6mm, dy: 4.8mm, text(font: mono-font, weight: 600, size: 8pt, tracking: 2pt, fill: ink)[TRAVEL · GROUP & PRIVATE])
  // portrait and fields
  place(top + left, dx: 6mm, dy: 15mm, grid(columns: (36mm, 92mm), column-gutter: 6mm,
    box(width: 36mm, height: 48mm, radius: 2mm, clip: true, fill: photo-bg, stroke: 0.5pt + ink,
      image(portrait, width: 36mm, height: 48mm, fit: "cover")),
    {
      lbl("Surname, given name")
      v(0.4mm)
      text(weight: 700, size: 27pt, tracking: 0.3pt, top-edge: "cap-height", bottom-edge: "baseline", upper(d.family) + ", " + d.given)
      v(2.2mm)
      lbl("Position")
      linebreak()
      text(weight: 600, size: 14pt, fill: rose, d.title)
      v(3mm)
      grid(columns: (1.15fr, 1fr), column-gutter: 5mm, row-gutter: 2.5mm,
        field("Specialty", d.specialty),
        field("Based in", d.contacts.based),
        field("Phone", d.contacts.phone),
        field("Date of birth", d.contacts.born),
        field("Email", d.contacts.email),
        field("Nationality", d.contacts.nationality),
        field("Passport", d.contacts.passport),
        field("Available from", d.availability.headline.replace("Available from ", "")),
      )
    }))
  // passport line and signature-like availability, along the photo's foot
  // machine-readable zone
  place(bottom + left, dy: 0mm, rect(width: card-w, height: 17mm, fill: white.transparentize(if mono { 0% } else { 35% }), stroke: (top: 0.5pt + ink)))
  place(bottom + left, dx: 6mm, dy: -3.4mm, {
    set par(leading: 0.55em)
    for l in mrz-lines {
      text(font: mono-font, weight: 500, size: 11.2pt, tracking: 4.06pt, fill: ink, l)
      linebreak()
    }
  })
})

// ---------- body ----------
#let section(title, above: 5.6mm) = block(above: above, below: 2.8mm, width: 100%, {
  text(font: mono-font, weight: 600, size: 9.4pt, tracking: 1.8pt, fill: green, upper(title))
  v(-0.6mm)
  layout(s => waveband(s.width, 3.2mm, n: 4, periods: calc.floor(s.width / 6mm), wt: 0.45pt))
})
#let mono-date(t) = text(font: mono-font, weight: 600, size: 9pt, fill: rose, t)

#v(3mm)
#grid(columns: (1fr, 56mm), column-gutter: 8mm,
  {
    section("Profile", above: 0mm)
    text(size: 10.4pt, weight: 500, d.profile)
    section("Experience")
    for (n, j) in d.experience.enumerate() {
      block(above: if n == 0 { 0mm } else { 3.4mm }, below: 0mm, {
        grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
          text(weight: 700, size: 12pt, j.role),
          mono-date(j.from + " – " + j.to))
        v(0.4mm)
        text(weight: 600, fill: green, j.employer)
        text(fill: soft, [ · #j.place])
        if "intro" in j { linebreak(); text(style: "italic", size: 8.9pt, fill: soft, j.intro) }
        v(1.2mm)
        for b in j.bullets {
          block(below: 1.4mm, grid(columns: (3.6mm, 1fr),
            pad(top: 2.6pt, box(width: 4pt, height: 4pt, stroke: 0.7pt + rose, radius: 2pt)),
            [*#b.lead:* #b.text]))
        }
      })
    }
    section("Education")
    for e in d.education {
      block(below: 2.2mm, grid(columns: (1fr, auto), align: (left, right),
        [*#e.qualification* \ #text(fill: soft, e.institution)],
        mono-date(e.years)))
    }
  },
  {
    section("Languages", above: 0mm)
    for l in d.languages {
      block(below: 2mm, {
        grid(columns: (1fr, auto), text(weight: 600, l.name), mono-date(l.level))
        if "note" in l { text(size: 8.5pt, fill: soft, l.note) }
      })
    }
    section(d.skills.heading)
    for s in d.skills.items { block(below: 2mm, [*#s.lead:* #s.text.]) }
    section("Availability")
    text(weight: 700, d.availability.headline)
    linebreak()
    text(size: 8.9pt, d.availability.text)
    section("Recent journeys")
    for t in d.journeys.trips {
      block(below: 2mm, [#mono-date(upper(t.period)) \ *#t.stops.join(" – ")* \ #text(size: 8.5pt, fill: soft)[#t.days days, #t.role]])
    }
  },
)

// ---------- microprint foot ----------
#v(1fr)
#block(width: 100%, clip: true, height: 2.2mm,
  box(width: 400mm, text(font: mono-font, size: 4.2pt, fill: soft, tracking: 0.6pt, ("DAPHNE KONTOU · TOUR LEADER · TRAVEL CONSULTANT · " * 6))))
#text(font: mono-font, size: 6.6pt, fill: soft, tracking: 1pt, upper(d.disclosure))
