// Rhumb Lines: the CV laid out like a sea chart of the old chart-makers.
// A 32-point wind rose holds the portrait; its rhumb lines run across the page.
// Condensed density, stylish tier. The monochrome file is generated from this
// one (mono flag and root path switched); see ../../brief.md.
#let mono = false
#let root = "../../"
#let d = json(root + "sample.json")
#let portrait = root + (if mono { "portrait-mono.png" } else { "portrait.png" })

// palette: vellum, iron-gall ink, vermilion, verdigris; mono: ink on white, greys and line patterns
#let paper = if mono { white } else { rgb("#F6EFE1") }
#let ink = if mono { rgb("#141414") } else { rgb("#2B2119") }
#let red = if mono { rgb("#141414") } else { rgb("#AE3A24") }
#let green = if mono { rgb("#6A6A6A") } else { rgb("#2E6B57") }
#let soft = if mono { rgb("#7A7A7A") } else { rgb("#8A765C") }
#let pale = if mono { rgb("#EDEDED") } else { rgb("#EADFC8") }

#let serif = "Alegreya"
#let display = "Cormorant Garamond"

#set page(paper: "a4", margin: (left: 16mm, right: 16mm, top: 13mm, bottom: 11mm), fill: paper)
#set text(font: serif, size: 9.9pt, fill: ink, lang: "en", number-type: "lining")
#set par(leading: 0.5em, spacing: 0.6em, justify: false)

// ---------- drawing ----------
#let pol(a, r) = (r * calc.sin(a), -r * calc.cos(a))

// rhumb lines from a centre, 32 directions; principal winds ink, half winds green, quarter winds red
// mono: principal solid, half dashed, quarter dotted
#let rhumbs(cx, cy, alpha: if mono { 38% } else { 52% }, n: 32) = {
  for k in range(n) {
    let a = k * 360deg / n
    let kind = if calc.rem(k, 4) == 0 { 0 } else if calc.rem(k, 2) == 0 { 1 } else { 2 }
    let col = (ink, green, red).at(kind).transparentize(alpha)
    let dash = if mono { ("solid", "dashed", "dotted").at(kind) } else { "solid" }
    let (x, y) = pol(a, 420mm)
    place(top + left, line(start: (cx, cy), end: (cx + x, cy + y), stroke: (paint: col, thickness: 0.45pt, dash: dash)))
  }
}

// one point of the rose: two halves, light and dark
#let spike(c, a, len, w, light, dark) = {
  let tip = pol(a, len)
  let l = pol(a - 90deg, w)
  let r = pol(a + 90deg, w)
  let at(p) = (c.at(0) + p.at(0), c.at(1) + p.at(1))
  place(top + left, polygon(fill: light, stroke: 0.4pt + ink, c, at(tip), at(l)))
  place(top + left, polygon(fill: dark, stroke: 0.4pt + ink, c, at(tip), at(r)))
}

#let rose(R, pr) = box(width: 2 * R, height: 2 * R, {
  let c = (R, R)
  // outer rings with 32 ticks
  place(top + left, dx: R * 0.06, dy: R * 0.06, circle(radius: R * 0.94, stroke: 0.6pt + ink))
  place(top + left, dx: R * 0.1, dy: R * 0.1, circle(radius: R * 0.9, stroke: 0.4pt + ink))
  for k in range(128) {
    let a = k * 360deg / 128
    let (x1, y1) = pol(a, R * 0.9)
    let (x2, y2) = pol(a, if calc.rem(k, 4) == 0 { R * 0.94 } else { R * 0.92 })
    place(top + left, line(start: (R + x1, R + y1), end: (R + x2, R + y2), stroke: 0.4pt + ink))
  }
  for k in range(16) {
    let a = (2 * k + 1) * 360deg / 32
    spike(c, a, R * 0.62, R * 0.06, paper, red)
  }
  for k in range(8) {
    let a = (2 * k + 1) * 360deg / 16
    spike(c, a, R * 0.78, R * 0.085, paper, green)
  }
  for k in range(8) {
    let a = k * 45deg
    let len = if calc.rem(k, 2) == 0 { R * 1.0 } else { R * 0.86 }
    spike(c, a, len, R * 0.11, paper, ink)
  }
  // north mark: a small lozenge above the north point
  place(top + left, dx: R - 3.2pt, dy: -9pt, polygon(fill: red, stroke: 0.4pt + ink, (3.2pt, 0pt), (6.4pt, 4.2pt), (3.2pt, 8.4pt), (0pt, 4.2pt)))
  // portrait medallion
  place(top + left, dx: R - pr - 2.6pt, dy: R - pr - 2.6pt, circle(radius: pr + 2.6pt, fill: paper, stroke: 0.8pt + ink))
  place(top + left, dx: R - pr, dy: R - pr, box(width: 2 * pr, height: 2 * pr, radius: pr, clip: true, stroke: 1.4pt + red, fill: pale,
    image(portrait, width: 2 * pr, height: 2 * pr, fit: "cover")))
})

// small 8-point star for headings
#let star(s) = box(width: s, height: s, baseline: 18%, {
  let c = (s / 2, s / 2)
  for k in range(4) { spike(c, k * 90deg + 45deg, s * 0.32, s * 0.08, paper, green) }
  for k in range(4) { spike(c, k * 90deg, s * 0.5, s * 0.11, paper, red) }
})

// the chart-maker's distance scale as a section rule
#let scalebar(w) = box(width: w, height: 6pt, {
  let n = calc.max(4, calc.floor(w / 9mm))
  let seg = w / n
  place(top + left, dy: 1.6pt, rect(width: w, height: 2.8pt, stroke: 0.45pt + ink))
  for i in range(n) {
    if calc.rem(i, 2) == 0 { place(top + left, dx: seg * i, dy: 1.6pt, rect(width: seg, height: 2.8pt, fill: ink, stroke: none)) }
    place(top + left, dx: seg * i - 0.9pt, dy: -1.4pt, circle(radius: 0.9pt, fill: ink))
  }
  place(top + left, dx: w - 0.9pt, dy: -1.4pt, circle(radius: 0.9pt, fill: ink))
})

#let section(title) = block(above: 5.8mm, below: 3mm, grid(
  columns: (auto, auto, 1fr), column-gutter: 2.2mm, align: horizon,
  star(10pt),
  text(font: display, weight: 700, size: 14.5pt, fill: red, tracking: 0.6pt, smallcaps(title)),
  layout(s => scalebar(s.width)),
))

#let label(t) = text(size: 7pt, fill: red, weight: 700, tracking: 1.1pt, upper(t))

// no runts: the last three words of a running line are bound together
#let tie(s) = {
  let w = s.split(" ")
  if w.len() < 5 { s } else { w.slice(0, -3).join(" ") + " " + w.slice(-3).join(str(sym.space.nobreak)) }
}
// an institution "Name, qualifier" breaks at its comma, never mid-phrase
#let at-comma(s) = { let p = s.split(", "); if p.len() < 2 { s } else { [#p.at(0),#linebreak()#p.slice(1).join(", ")] } }

#let lozenge = box(baseline: -0.5pt, polygon(fill: red, stroke: none, (2pt, 0pt), (4pt, 2.4pt), (2pt, 4.8pt), (0pt, 2.4pt)))

// ---------- page art ----------
#set page(background: {
  rhumbs(165mm, 54mm)
  rhumbs(22mm, 262mm, alpha: if mono { 45% } else { 62% }, n: 16)
})

// ---------- header ----------
#place(top + left, dx: 165mm - 16mm - 47mm, dy: 54mm - 13mm - 47mm, rose(47mm, 19.5mm))

#block(width: 100mm, fill: paper, outset: (x: 2.5mm, top: 2mm, bottom: 3.2mm), {
  v(3mm)
  text(font: display, weight: 700, size: 50pt, fill: ink, tracking: -0.5pt, top-edge: "cap-height", bottom-edge: "baseline", d.given)
  v(-1mm)
  text(font: display, weight: 700, size: 50pt, fill: ink, tracking: -0.5pt, top-edge: "cap-height", bottom-edge: "baseline", d.family)
  v(4.2mm)
  text(weight: 800, size: 11.5pt, fill: red, tracking: 1.6pt, upper(d.title))
  v(1.2mm)
  text(font: display, style: "italic", weight: 600, size: 14pt, fill: green, d.specialty + ", Europe and Asia")
  v(4mm)
  set text(size: 8.8pt)
  grid(columns: (auto, 1fr), column-gutter: 3mm, row-gutter: 1.7mm,
    label("Based in"), d.contacts.based,
    label("Phone"), d.contacts.phone,
    label("Email"), d.contacts.email,
    label("Born"), d.contacts.born + h(2mm) + text(fill: soft, "·") + h(2mm) + label("Nationality") + h(1.5mm) + d.contacts.nationality,
    label("Passport"), d.contacts.passport,
  )
})

// the body is a paper panel laid on the chart: rhumb lines show only in the margins and the header
#block(width: 100%, height: 1fr, above: 5mm, below: 0mm, fill: paper, outset: (x: 3.5mm, top: 2.5mm, bottom: 1mm), [
#{
  set par(leading: 0.45em)
  text(font: display, style: "italic", weight: 500, size: 14pt, fill: ink, tie(d.profile))
}

// ---------- experience ----------
#section("Experience")

#let job(j) = grid(
  columns: (27mm, 1fr), column-gutter: 4mm,
  {
    set text(style: "italic", fill: red, size: 9.6pt, weight: 700)
    j.from + " –"
    linebreak()
    if j.to == "present" { "present" } else { j.to }
  },
  {
    text(font: display, weight: 700, size: 15pt, fill: ink, j.role)
    h(2.5mm)
    text(weight: 700, size: 9.6pt, fill: green, tracking: 0.4pt, smallcaps(j.employer))
    text(fill: soft, size: 9pt, [ · #j.place])
    if "intro" in j {
      v(0.4mm)
      block(below: 1.4mm, text(style: "italic", fill: soft, size: 9pt, tie(j.intro)))
    } else { v(0.8mm) }
    for b in j.bullets {
      block(below: 1.9mm, grid(columns: (3.4mm, 1fr), pad(top: 1.6pt, lozenge), [*#b.lead:* #tie(b.text)]))
    }
  },
)

#job(d.experience.at(0))
#v(2.4mm)
#job(d.experience.at(1))

// ---------- particulars ----------
#section("Education, languages & skills")

#grid(columns: (1.22fr, 0.76fr, 1.02fr), column-gutter: 6mm,
  {
    label("Education")
    v(1mm)
    for e in d.education {
      block(below: 2.4mm, {
        text(weight: 700, size: 9.6pt, e.qualification)
        linebreak()
        text(size: 8.8pt, at-comma(e.institution))
        linebreak()
        text(style: "italic", size: 8.8pt, fill: red, weight: 700, e.years)
      })
    }
  },
  {
    label("Languages")
    v(1mm)
    for l in d.languages {
      block(below: 1.9mm, {
        text(weight: 700, l.name)
        h(1.5mm)
        text(style: "italic", fill: red, weight: 700, l.level)
        if "note" in l { linebreak(); text(size: 8.6pt, fill: soft, tie(l.note)) }
      })
    }
  },
  {
    label(d.skills.heading)
    v(1mm)
    for s in d.skills.items {
      block(below: 2.2mm, [*#s.lead:* #tie(s.text + ".")])
    }
  },
)

// ---------- journeys and availability: the chart's cartouche ----------
#v(1fr)
#let trip(t) = {
  set text(size: 8.6pt)
  text(style: "italic", fill: red, weight: 700, t.period)
  linebreak()
  text(fill: soft, [#t.days days, #t.role])
  linebreak()
  // the route drawn as a sailing line with stops
  box(width: 100%, height: 9pt, {
    place(left + horizon, dy: 0pt, line(length: 100%, stroke: (paint: ink, thickness: 0.6pt, dash: "dashed")))
    let n = t.stops.len()
    for (i, s) in t.stops.enumerate() {
      let x = if n == 1 { 0% } else { i * 100% / (n - 1) }
      place(left + horizon, dx: x - 2.3pt, circle(radius: 2.3pt, fill: if i == 0 or i == n - 1 { red } else { paper }, stroke: 0.6pt + ink))
    }
  })
  v(-0.6mm)
  grid(columns: (1fr, 1fr, 1fr), align: (left, center, right), ..t.stops.map(s => text(weight: 700, size: 8.6pt, s)))
}

#block(width: 100%, stroke: (paint: ink, thickness: 0.8pt), inset: 1.2mm, fill: paper,
  block(width: 100%, stroke: (paint: ink, thickness: 0.4pt), inset: (x: 4mm, y: 3mm), {
    grid(columns: (1.05fr, 1fr, 1fr, 1fr), column-gutter: 5.5mm,
      {
        label("Availability")
        v(0.6mm)
        text(font: display, weight: 700, size: 13.5pt, d.availability.headline)
        v(0.4mm)
        text(size: 8.4pt, tie(d.availability.text))
      },
      grid.cell(colspan: 3, {
        label("Recent journeys, planned or travelled")
        v(1.4mm)
        grid(columns: (1fr, 1fr, 1fr), column-gutter: 5.5mm, ..d.journeys.trips.map(trip))
        v(2.2mm)
        line(length: 100%, stroke: (paint: soft, thickness: 0.4pt, dash: "dotted"))
        v(1.2mm)
        text(size: 8.6pt)[#text(weight: 700)[Knows well:] #d.journeys.knows_well. #text(fill: soft)[#d.journeys.region.]]
      }),
    )
  })
)
#v(1.4mm)
#text(size: 6.8pt, fill: soft, tracking: 0.8pt, upper(d.disclosure))
])
