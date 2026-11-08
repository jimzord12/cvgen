// Poster Sun: the top of the CV is a flat-colour travel poster, and the
// portrait is its sun rising over a generic coast. The rest is a calm,
// two-column page set in the poster's geometric type.
// Condensed density, stylish tier. The monochrome file is generated from this
// one (mono flag and root path switched); in it the poster becomes a one-ink
// print with line tints; see ../../brief.md.
#let mono = false
#let root = "../../"
#let d = json(root + "sample.json")
#let portrait = root + (if mono { "portrait-mono.png" } else { "portrait.png" })

#let H = 112mm   // poster height
#let hz = 84mm
#let sun = (146mm, 52mm)
#let R = 27mm

// palette: sunrise bands, coral sun, deep teal coast and sea, ink band
#let ink = if mono { rgb("#111111") } else { rgb("#18303A") }
#let coral = if mono { rgb("#111111") } else { rgb("#E2553A") }
#let hot = if mono { rgb("#111111") } else { rgb("#C2402A") }
#let teal = if mono { rgb("#111111") } else { rgb("#1E5D5C") }
#let soft = if mono { rgb("#5C5C5C") } else { rgb("#4F6670") }
#let cream = if mono { white } else { rgb("#FBF1DE") }
#let paper = white

// one-ink tints for the mono print: hairlines at a given pitch
#let lines-tint(pitch, angle: 0deg, w: 0.5pt) = tiling(size: (pitch, pitch),
  place(top + left, line(start: (0pt, pitch / 2), end: (pitch, pitch / 2), stroke: w + ink)))
#let hatch(pitch, w: 0.5pt) = tiling(size: (pitch, pitch),
  place(top + left, line(start: (0pt, pitch), end: (pitch, 0pt), stroke: w + ink)))

#let sky-fills = if mono {
  (paper, paper, paper, paper, paper)
} else {
  (rgb("#F3B56A"), rgb("#F6C482"), rgb("#F8D39B"), rgb("#FADFB3"), rgb("#FBEACB"))
}
#let far-hill = if mono { lines-tint(1.9pt, w: 0.6pt) } else { rgb("#4E9187") }
#let near-hill = if mono { ink } else { teal }
#let sea-fill = if mono { ink } else { rgb("#1F4E5F") }
#let wave-col = if mono { white } else { rgb("#5E8E97") }
#let glint = if mono { white } else { rgb("#F09A6B") }
#let sun-disc = if mono { rgb("#E4E4E4") } else { rgb("#F9DDB0") }

#let display = "Jost"

#set page(paper: "a4", margin: (left: 15mm, right: 15mm, top: H + 7mm, bottom: 10mm), fill: paper)
#set text(font: display, size: 9.8pt, fill: ink, lang: "en")
#set par(leading: 0.52em, spacing: 0.6em)

// ---------- the poster ----------
#let plane(s, col) = box(width: s, height: s, {
  let u = s / 10
  place(top + left, polygon(fill: col,
    (5*u, 0*u), (5.8*u, 1*u), (5.8*u, 3.6*u), (10*u, 6*u), (10*u, 7*u), (5.8*u, 5.8*u), (5.6*u, 8.4*u),
    (7*u, 9.4*u), (7*u, 10*u), (5*u, 9.5*u), (3*u, 10*u), (3*u, 9.4*u), (4.4*u, 8.4*u), (4.2*u, 5.8*u),
    (0*u, 7*u), (0*u, 6*u), (4.2*u, 3.6*u), (4.2*u, 1*u)))
})

#let poster = box(width: 210mm, height: H, clip: true, {
  // sky in stepped bands, lightest at the horizon
  let bh = hz / 5
  for (i, f) in sky-fills.enumerate() {
    place(top + left, dy: i * bh, rect(width: 210mm, height: bh + 0.3pt, fill: f, stroke: none))
  }
  // sun rays
  for k in range(36) {
    let a = k * 10deg
    let r1 = R * 1.22
    let r2 = if calc.rem(k, 2) == 0 { R * 2.05 } else { R * 1.6 }
    place(top + left, line(
      start: (sun.at(0) + r1 * calc.sin(a), sun.at(1) - r1 * calc.cos(a)),
      end: (sun.at(0) + r2 * calc.sin(a), sun.at(1) - r2 * calc.cos(a)),
      stroke: (paint: if mono { ink } else { rgb("#E9874F") }, thickness: if calc.rem(k, 2) == 0 { 1.1pt } else { 0.6pt }, cap: "round")))
  }
  // the plane and its contrail
  let trail = range(0, 21).map(i => {
    let t = i / 20
    (186mm + t * 30mm, 14mm - 6mm * calc.sin(t * 90deg))
  })
  place(top + left, rect(width: 210mm, height: 0mm, stroke: none))
  place(top + left, curve(stroke: (paint: if mono { ink } else { cream }, thickness: 1.1pt, dash: (4pt, 3pt)),
    curve.move(trail.at(0)), ..trail.slice(1).map(p => curve.line(p))))
  place(top + left, dx: 177mm, dy: 10.5mm, rotate(-84deg, plane(8mm, ink)))
  // far coast and near headland
  place(top + left, polygon(fill: far-hill, stroke: none,
    (0mm, 62mm), (14mm, 58mm), (30mm, 61mm), (48mm, 67mm), (66mm, 74mm), (86mm, 80mm), (104mm, hz), (0mm, hz)))
  place(top + left, polygon(fill: far-hill, stroke: none,
    (168mm, hz), (176mm, 79mm), (186mm, 76.5mm), (196mm, 78mm), (210mm, 75mm), (210mm, hz)))
  place(top + left, polygon(fill: near-hill, stroke: none,
    (0mm, 70mm), (10mm, 68mm), (22mm, 71mm), (34mm, 77mm), (44mm, hz), (0mm, hz)))
  // the sea
  place(top + left, dy: hz, rect(width: 210mm, height: H - hz, fill: sea-fill, stroke: none))
  // glints under the sun
  for (i, w) in (40mm, 30mm, 22mm, 15mm, 9mm, 5mm).enumerate() {
    place(top + left, dx: sun.at(0) - w / 2 + (if calc.rem(i, 2) == 0 { 0mm } else { 2mm }), dy: hz + 2mm + i * 3.3mm,
      rect(width: w, height: 1.3mm, radius: 0.65mm, fill: glint, stroke: none))
  }
  // waves: rows of shallow arcs
  for row in range(4) {
    let y = hz + 5mm + row * 5.5mm
    let off = if calc.rem(row, 2) == 0 { 0mm } else { 9mm }
    for k in range(12) {
      let x = off + k * 18mm
      if calc.abs(x + 4mm - sun.at(0)) > 26mm - row * 2mm {
        place(top + left, curve(stroke: (paint: wave-col, thickness: 0.9pt, cap: "round"),
          curve.move((x, y)), curve.quad((x + 4mm, y - 2.2mm), (x + 8mm, y))))
      }
    }
  }
  // a ferry on the sea
  let fx = 42mm
  let fy = hz + 9mm
  let fc = if mono { white } else { cream }
  place(top + left, polygon(fill: fc, stroke: none, (fx, fy), (fx + 22mm, fy), (fx + 19mm, fy + 3.6mm), (fx + 2mm, fy + 3.6mm)))
  place(top + left, dx: fx + 4mm, dy: fy - 3mm, rect(width: 12mm, height: 3mm, fill: fc, stroke: none))
  place(top + left, dx: fx + 7mm, dy: fy - 5.6mm, rect(width: 3mm, height: 2.6mm, fill: coral, stroke: none))
  for k in range(4) { place(top + left, dx: fx + 5.4mm + k * 2.6mm, dy: fy - 2.1mm, rect(width: 1.3mm, height: 1.1mm, fill: sea-fill, stroke: none)) }
  // the sun: a coral ring holding the portrait
  place(top + left, dx: sun.at(0) - R - 2.4mm, dy: sun.at(1) - R - 2.4mm, circle(radius: R + 2.4mm, fill: coral, stroke: none))
  place(top + left, dx: sun.at(0) - R, dy: sun.at(1) - R,
    box(width: 2 * R, height: 2 * R, radius: R, clip: true, fill: sun-disc, image(portrait, width: 2 * R, height: 2 * R, fit: "cover")))
  // the poster's foot: an ink band with the contacts
  place(top + left, dy: H - 10mm, rect(width: 210mm, height: 10mm, fill: ink, stroke: none))
})

#let contact-line = {
  set text(fill: cream, size: 9.8pt, weight: 500, tracking: 0.3pt)
  let sep = h(3.2mm) + text(fill: if mono { white } else { coral }, "●") + h(3.2mm)
  [#d.contacts.based #sep #d.contacts.phone #sep #d.contacts.email]
}

#set page(background: {
  place(top + left, poster)
  place(top + left, dx: 15mm, dy: H - 10mm, box(width: 180mm, height: 10mm, align(horizon, contact-line)))
  // the poster title, top left in the sky
  place(top + left, dx: 15mm, dy: 13mm, {
    set par(leading: 0.1em)
    text(font: display, weight: 700, size: 46pt, fill: ink, tracking: 2.5pt, top-edge: "cap-height", bottom-edge: "baseline", upper(d.given))
    linebreak()
    v(1mm)
    text(font: display, weight: 700, size: 46pt, fill: ink, tracking: 2.5pt, top-edge: "cap-height", bottom-edge: "baseline", upper(d.family))
    linebreak()
    v(3mm)
    box(fill: ink, inset: (x: 2.4mm, y: 1.6mm), text(font: display, weight: 600, size: 11.5pt, fill: cream, tracking: 1.8pt, upper(d.title)))
    linebreak()
    v(1.2mm)
    text(font: display, weight: 500, size: 11pt, fill: ink, tracking: 0.4pt, d.specialty + ", Europe and Asia")
  })
})

// ---------- body ----------
#let sunmark = box(width: 9pt, height: 5pt, baseline: 0pt, {
  place(bottom + left, dy: 0pt, box(width: 9pt, height: 4.5pt, clip: true, circle(radius: 4.5pt, fill: coral)))
  place(bottom + left, dy: 1pt, line(length: 9pt, stroke: 0.8pt + ink))
})
#let section(title, above: 5.4mm) = block(above: above, below: 2.6mm, width: 100%, {
  grid(columns: (auto, 1fr), column-gutter: 2mm, align: top,
    pad(top: 2.6pt, sunmark),
    text(font: display, weight: 600, size: 10.5pt, tracking: 1.8pt, upper(title)))
  v(-1.2mm)
  line(length: 100%, stroke: 0.7pt + ink)
})
#let dot = box(width: 4pt, baseline: -1.6pt, circle(radius: 1.7pt, fill: coral))

#grid(columns: (56mm, 1fr), column-gutter: 8mm,
  // left: profile, languages, skills, availability
  {
    section("Profile", above: 0mm)
    text(size: 10.5pt, weight: 500, d.profile)
    section("Personal")
    let pd(k, v) = block(below: 1.6mm, [#text(size: 8pt, weight: 600, fill: soft, tracking: 1pt, upper(k)) \ #text(weight: 500, v)])
    pd("Born", d.contacts.born)
    pd("Nationality", d.contacts.nationality)
    pd("Passport", d.contacts.passport)
    section("Languages")
    for l in d.languages {
      block(below: 2mm, {
        grid(columns: (1fr, auto), text(weight: 600, l.name), text(weight: 600, fill: hot, l.level))
        if "note" in l { text(size: 8.6pt, fill: soft, l.note) }
      })
    }
    section(d.skills.heading)
    for s in d.skills.items { block(below: 2mm, [*#s.lead:* #s.text.]) }
    section("Availability")
    text(weight: 700, size: 10.5pt, d.availability.headline)
    linebreak()
    text(size: 9pt, d.availability.text)
  },
  // right: experience and education
  {
    section("Experience", above: 0mm)
    for (n, j) in d.experience.enumerate() {
      block(above: if n == 0 { 0mm } else { 3.6mm }, below: 0mm, {
        grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
          text(weight: 700, size: 12.5pt, j.role),
          text(weight: 600, size: 10pt, fill: hot, tracking: 0.4pt, j.from + " – " + j.to))
        v(0.6mm)
        text(weight: 600, fill: teal, j.employer)
        text(fill: soft, [, #j.place])
        if "intro" in j { linebreak(); text(style: "italic", size: 9pt, fill: soft, j.intro) }
        v(1.2mm)
        for b in j.bullets {
          block(below: 1.5mm, grid(columns: (4mm, 1fr), dot, [*#b.lead:* #b.text]))
        }
      })
    }
    section("Education")
    for e in d.education {
      block(below: 2.4mm, grid(columns: (1fr, auto), align: (left, right),
        [*#e.qualification* \ #text(fill: soft, e.institution)],
        text(weight: 600, fill: hot, tracking: 0.4pt, e.years)))
    }
    section("Recent journeys")
    grid(columns: (1fr, 1fr, 1fr), column-gutter: 4mm,
      ..d.journeys.trips.map(t => [
        #text(weight: 600, size: 8.8pt, fill: hot, upper(t.period)) \
        #text(weight: 600, t.stops.join(" · ")) \
        #text(size: 8.6pt, fill: soft)[#t.days days, #t.role]
      ]))
  },
)

#v(1fr)
#text(size: 6.8pt, fill: soft, tracking: 1pt, upper(d.disclosure))
