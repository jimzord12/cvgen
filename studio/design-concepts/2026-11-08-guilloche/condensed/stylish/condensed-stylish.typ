// Guilloche: the CV opens under a band engraved like security print: a woven
// underprint, a rosette with a globe at its heart and a rainbow tint, the cut-out
// portrait standing on the band's engraved foot. The engraved line carries on as
// the body's section rules and the rule between its columns. Condensed density, stylish tier. The monochrome file is
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

#let sans = "Fira Sans"
#let mono-font = "IBM Plex Mono"

#set page(paper: "a4", margin: (left: 15mm, right: 15mm, top: 90mm, bottom: 10mm), fill: white)
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
#let field(k, val, size: 9.6pt) = stack(spacing: 1.1mm, lbl(k), text(weight: 500, size: size, val))
// no runts: the last words of a running line are bound together (three, or four in a long line)
#let tie(s) = {
  let w = s.split(" ")
  let k = if w.len() >= 10 { 4 } else { 3 }
  if w.len() < 5 { s } else { w.slice(0, -k).join(" ") + " " + w.slice(-k).join(str(sym.space.nobreak)) }
}

// an institution "Name, qualifier" breaks at its comma, never mid-phrase
#let at-comma(s) = { let p = s.split(", "); if p.len() < 2 { s } else { [#p.at(0),#linebreak()#p.slice(1).join(", ")] } }

// an engraved globe: meridians and parallels only
#let globe(c, gr, col) = {
  place(top + left, dx: c.at(0) - gr, dy: c.at(1) - gr, circle(radius: gr, stroke: 0.7pt + col))
  for lon in (22deg, 48deg, 72deg) {
    let rx = gr * calc.cos(lon)
    place(top + left, dx: c.at(0) - rx, dy: c.at(1) - gr, ellipse(width: 2 * rx, height: 2 * gr, stroke: 0.4pt + col))
  }
  place(top + left, dx: c.at(0), dy: c.at(1) - gr, line(length: 2 * gr, angle: 90deg, stroke: 0.4pt + col))
  for lat in (-60deg, -30deg, 0deg, 30deg, 60deg) {
    let y = c.at(1) + gr * calc.sin(lat)
    let hw = gr * calc.cos(lat)
    place(top + left, line(start: (c.at(0) - hw, y), end: (c.at(0) + hw, y), stroke: 0.4pt + col))
  }
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
#let Hb = 82mm
#let band = box(width: 210mm, height: Hb, clip: true, {
  place(top + left, rect(width: 210mm, height: Hb, fill: card-fill, stroke: none))
  // underprint of woven waves across the whole band
  for k in range(8) {
    place(top + left, dy: 2mm + k * 10mm, waveband(210mm, 9mm, n: 5, periods: 10 + calc.rem(k, 2),
      col: line-a.transparentize(if mono { 80% } else { 80% }), col2: line-b.transparentize(if mono { 78% } else { 82% }), wt: if mono { 0.25pt } else { 0.3pt }))
  }
  // the rosette with a globe at its heart
  let rc = (182mm, 42mm)
  rosette(rc, 23mm, 2.7mm, 14, 18, line-a.transparentize(if mono { 10% } else { 30% }), w: if mono { 0.25pt } else { 0.35pt })
  rosette(rc, 14.5mm, 2.2mm, 10, 14, line-b.transparentize(if mono { 10% } else { 25% }), w: if mono { 0.25pt } else { 0.35pt })
  place(top + left, dx: rc.at(0) - 10.5mm, dy: rc.at(1) - 10.5mm, circle(radius: 10.5mm, fill: if mono { white } else { rgb("#F3ECE4") }, stroke: none))
  globe(rc, 9mm, line-a)
})

#set page(background: {
  place(top + left, band)
  // the band's foot: an engraved border
  place(top + left, dy: Hb - 2.6mm, waveband(210mm, 5.2mm, n: 9, periods: 34, wt: if mono { 0.3pt } else { 0.4pt }))
  // the portrait stands on the band's foot; the band itself shows behind the cut-out
  place(top + left, dx: 13mm, dy: Hb - 62mm, box(width: 52mm, height: 62mm, clip: true, radius: (top-left: 26mm, top-right: 26mm),
    image(portrait, width: 52mm, height: 62mm, fit: "cover")))
  place(top + left, dx: 13mm, dy: Hb - 62mm, box(width: 52mm, height: 62mm, radius: (top-left: 26mm, top-right: 26mm),
    stroke: (top: 0.7pt + line-a, left: 0.7pt + line-a, right: 0.7pt + line-a)))
  // the vertical engraved rule between the body's columns
  place(top + left, dx: 210mm - 15mm - 60mm - 4mm - 1.6mm, dy: Hb + 10mm, vwaveband(297mm - Hb - 36mm, 2.4mm, n: 3, wt: 0.3pt))
  // header strip and identity, set on the band
  place(top + left, dx: 15mm, dy: 8mm, text(font: mono-font, weight: 600, size: 8pt, tracking: 2pt, fill: ink)[CURRICULUM VITAE])
  place(top + right, dx: -15mm, dy: 8mm, text(font: mono-font, weight: 600, size: 8pt, tracking: 2pt, fill: ink)[TRAVEL · GROUP & PRIVATE])
  place(top + left, dx: 74mm, dy: 18mm, block(width: 86mm, {
    text(weight: 700, size: 30pt, tracking: 0.2pt, top-edge: "cap-height", bottom-edge: "baseline", d.name)
    v(3mm)
    text(weight: 600, size: 14pt, fill: rose, d.title)
    v(3.4mm)
    grid(columns: (1.2fr, 1fr), column-gutter: 4mm, row-gutter: 2.4mm,
      field("Specialty", d.specialty),
      field("Based in", d.contacts.based),
      field("Phone", d.contacts.phone),
      field("Date of birth", d.contacts.born),
      field("Email", d.contacts.email, size: 9.2pt),
      field("Nationality", d.contacts.nationality),
      field("Passport", d.contacts.passport),
      field("Available from", d.availability.headline.replace("Available from ", "")),
    )
  }))
})

// ---------- body ----------
#let section(title, above: 5.6mm) = block(above: above, below: 2.8mm, width: 100%, {
  text(font: mono-font, weight: 600, size: 9pt, tracking: 0.9pt, fill: green, upper(title))
  v(-0.6mm)
  layout(s => waveband(s.width, 3.2mm, n: 4, periods: calc.floor(s.width / 6mm), wt: 0.45pt))
})
#let mono-date(t) = text(font: mono-font, weight: 600, size: 9pt, fill: rose, t)

#grid(columns: (1fr, 60mm), column-gutter: 8mm,
  {
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
        v(1.2mm)
        for b in j.bullets {
          block(below: 1.4mm, grid(columns: (3.6mm, 1fr),
            pad(top: 2.6pt, box(width: 4pt, height: 4pt, stroke: 0.7pt + rose, radius: 2pt)),
            [*#b.lead:* #tie(b.text)]))
        }
      })
    }
    section("Education")
    for e in d.education {
      block(below: 2.2mm, grid(columns: (1fr, auto), align: (left, right),
        [*#e.qualification* \ #text(fill: soft, at-comma(e.institution))],
        mono-date(e.years)))
    }
  },
  {
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
      block(below: 2mm, [#mono-date(upper(t.period)) \ *#t.stops.join(" – ")* \ #text(size: 8.5pt, fill: soft)[#t.days days, #t.role]])
    }
  },
)

// ---------- microprint foot ----------
#v(1fr)
#block(width: 100%, clip: true, height: 2.2mm,
  box(width: 400mm, text(font: mono-font, size: 4.2pt, fill: soft, tracking: 0.6pt, ("DAPHNE KONTOU · TOUR LEADER · TRAVEL CONSULTANT · " * 6))))
#text(font: mono-font, size: 6.6pt, fill: soft, tracking: 1pt, upper(d.disclosure))
