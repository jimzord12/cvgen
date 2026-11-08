// Airmail: the CV sent as an airmail letter. The striped border frames the page,
// the portrait is the stamp, the postmark carries the availability date, and
// every label is typed. Condensed density, stylish tier. The monochrome file is
// generated from this one (mono flag and root path switched); see ../../brief.md.
#let mono = false
#let root = "../../"
#let d = json(root + "sample.json")
#let portrait = root + (if mono { "portrait-mono.png" } else { "portrait.png" })

// palette: airmail red and blue on pale blue letter paper; mono: black and grey stripes on white
#let paper = if mono { rgb("#F1F1EF") } else { rgb("#EEF2F6") }
#let sheet = white
#let ink = if mono { rgb("#151515") } else { rgb("#1B2233") }
#let red = if mono { rgb("#151515") } else { rgb("#C42B2B") }
#let blue = if mono { rgb("#5A5A5A") } else { rgb("#1E3E8C") }
#let soft = if mono { rgb("#6E6E6E") } else { rgb("#5B6478") }
#let sky = if mono { rgb("#D9D9D9") } else { rgb("#BFD3EA") }
#let rule = if mono { rgb("#9C9C9C") } else { rgb("#9FB0CC") }

#let typed = "Courier Prime"
#let sans = "Source Sans 3"

#set page(paper: "a4", margin: (left: 17mm, right: 17mm, top: 16mm, bottom: 14mm), fill: paper)
#set text(font: sans, size: 10pt, fill: ink, lang: "en")
#set par(leading: 0.5em, spacing: 0.6em)

// ---------- the airmail border: diagonal bars all round the sheet ----------
#let border-band = 4.4mm
#let bars = {
  let w = 4.6mm
  let H = 297mm
  let cols = if mono { (rgb("#5A5A5A"), sheet, rgb("#5A5A5A"), sheet) } else { (red, sheet, blue, sheet) }
  for i in range(-50, 60) {
    let x = i * w
    place(top + left, polygon(fill: cols.at(calc.rem(i + 200, 4)), stroke: none,
      (x + H * 0.62, 0mm), (x + H * 0.62 + w, 0mm), (x + w, H), (x, H)))
  }
}
#set page(background: {
  bars
  place(top + left, dx: border-band, dy: border-band, rect(width: 210mm - 2 * border-band, height: 297mm - 2 * border-band, fill: paper, stroke: none))
})

// ---------- small parts ----------
// no runts: the last three words of a running line are bound together
#let tie(s) = {
  let w = s.split(" ")
  let k = if w.len() >= 10 { 4 } else { 3 }
  if w.len() < 5 { s } else { w.slice(0, -k).join(" ") + " " + w.slice(-k).join(str(sym.space.nobreak)) }
}
#let lbl(t) = text(font: typed, weight: 700, size: 8.6pt, fill: if mono { ink } else { blue }, tracking: 0.3pt, upper(t))

#let airmail-label = box(fill: blue, radius: 1.6pt, inset: (x: 2.6mm, y: 1.6mm),
  text(font: typed, weight: 700, size: 9pt, fill: white, tracking: 1.2pt)[PAR AVION #h(1.5mm)·#h(1.5mm) BY AIR MAIL])

// characters set along a circle, as on a cancellation stamp
#let arc-text(txt, r, step, bottom: false, size: 6.4pt) = {
  let cs = txt.clusters()
  let n = cs.len()
  for (i, ch) in cs.enumerate() {
    let off = (i - (n - 1) / 2) * step
    let a = if bottom { 180deg - off } else { off }
    place(center + horizon, dx: r * calc.sin(a), dy: -r * calc.cos(a),
      rotate(if bottom { a + 180deg } else { a }, text(font: typed, weight: 700, size: size, fill: ink, ch)))
  }
}

#let postmark(R) = box(width: 2 * R, height: 2 * R, {
  let ink-col = if mono { rgb("#151515") } else { rgb("#1B2233") }
  place(center + horizon, circle(radius: R, stroke: 1.1pt + ink-col.transparentize(15%)))
  place(center + horizon, circle(radius: R * 0.64, stroke: 0.9pt + ink-col.transparentize(15%)))
  arc-text("AVAILABLE FROM", R * 0.8, 11.5deg)
  arc-text("TWO WEEKS' NOTICE", R * 0.83, 9.4deg, bottom: true, size: 5.8pt)
  place(center + horizon, dy: -0.6pt, align(center, text(font: typed, weight: 700, size: 10pt, fill: ink-col, tracking: 0.5pt)[APR\ 2027]))
})

// wavy cancellation lines
#let waves(w, n) = box(width: w, height: n * 3.2mm, {
  for k in range(n) {
    let y0 = k * 3.2mm + 1.6mm
    let pts = range(0, 41).map(i => (i * w / 40, y0 + 1.1mm * calc.sin(i * 36deg)))
    place(top + left, curve(stroke: 0.9pt + ink.transparentize(25%), curve.move(pts.at(0)), ..pts.slice(1).map(p => curve.line(p))))
  }
})

// the portrait as a stamp: perforated white paper, printed frame, a caption band
#let stamp(w, h) = box(width: w, height: h, {
  place(top + left, dx: 0.9mm, dy: 1.1mm, rect(width: w, height: h, fill: if mono { rgb("#C8C8C8") } else { rgb("#C9D3E0") }, stroke: none))
  place(top + left, rect(width: w, height: h, fill: sheet, stroke: none))
  let hole = 1.25mm
  let step = 3.2mm
  let nx = calc.floor(w / step)
  let ny = calc.floor(h / step)
  for i in range(nx + 1) {
    let x = i * w / nx
    place(top + left, dx: x - hole, dy: -hole, circle(radius: hole, fill: paper))
    place(top + left, dx: x - hole, dy: h - hole, circle(radius: hole, fill: paper))
  }
  for j in range(ny + 1) {
    let y = j * h / ny
    place(top + left, dx: -hole, dy: y - hole, circle(radius: hole, fill: paper))
    place(top + left, dx: w - hole, dy: y - hole, circle(radius: hole, fill: paper))
  }
  let m = 3.4mm
  place(top + left, dx: m, dy: m, rect(width: w - 2 * m, height: h - 2 * m, fill: blue, stroke: none))
  place(top + left, dx: m + 1.2mm, dy: m + 1.2mm,
    box(width: w - 2 * m - 2.4mm, height: h - 2 * m - 9.4mm, clip: true, fill: sky,
      image(portrait, width: w - 2 * m - 2.4mm, height: h - 2 * m - 9.4mm, fit: "cover")))
  place(bottom + center, dy: -m - 1.6mm, text(font: typed, weight: 700, size: 7.6pt, fill: white, tracking: 1.2pt)[TOUR LEADER])
})

// ---------- header ----------
#place(top + right, dx: 1mm, dy: -2mm, stamp(42mm, 52mm))
#place(top + left, dx: 143mm - 17mm - 13.5mm, dy: 49mm - 16mm - 13.5mm, postmark(13.5mm))
#place(top + left, dx: 150mm - 17mm, dy: 43mm - 16mm, waves(47mm, 4))

#block(width: 118mm, {
  airmail-label
  v(5.5mm)
  text(font: typed, weight: 700, size: 35pt, fill: ink, tracking: -0.8pt, upper(d.name))
  v(2.2mm)
  text(font: typed, weight: 700, size: 13pt, fill: red, tracking: 0.2pt, underline(offset: 2.6pt, stroke: 1pt + red, upper(d.title)))
  v(1.2mm)
  text(size: 11.5pt, fill: blue, weight: 600, d.specialty + ", Europe and Asia")
})

#v(3mm)
// the address block: contacts, typed
#let addr(k, v) = (text(font: typed, size: 8.2pt, fill: soft, upper(k)), text(font: typed, weight: 700, size: 9.4pt, v))
#grid(columns: (auto, 1fr, auto, 1fr), column-gutter: 3mm, row-gutter: 1.5mm,
  ..addr("Based in", d.contacts.based), ..addr("Born", d.contacts.born),
  ..addr("Phone", d.contacts.phone), ..addr("Nationality", d.contacts.nationality),
  ..addr("Email", d.contacts.email), ..addr("Passport", d.contacts.passport),
)

// ---------- body: hanging labels, like a typed letter ----------
// each row opens with a short length of the border's bars, then a typed dashed rule
#let bar-seg(w, h) = box(width: w, height: h, clip: true, {
  let cols = if mono { (none, paper, none, paper) } else { (red, paper, blue, paper) }
  let s = 2.2mm
  for i in range(-2, int(w / s) + 3) {
    let c = calc.rem(i + 200, 4)
    if mono and calc.rem(c, 2) == 0 {
      place(top + left, polygon(fill: none, stroke: 0.5pt + rgb("#3A3A3A"),
        (i * s + h, 0mm), (i * s + h + s, 0mm), (i * s + s, h), (i * s, h)))
    } else {
      place(top + left, polygon(fill: cols.at(c), stroke: none,
        (i * s + h, 0mm), (i * s + h + s, 0mm), (i * s + s, h), (i * s, h)))
    }
  }
})
#let sep = grid(columns: (33mm, 1fr), column-gutter: 3mm, align: horizon,
  bar-seg(33mm, 1.8mm),
  line(length: 100%, stroke: (paint: rule, thickness: 0.7pt, dash: (3pt, 2.2pt))))
#let row(label, body, above: 4.4mm) = {
  block(above: above, below: 0mm, sep)
  block(above: 3.4mm, below: 0mm, grid(columns: (33mm, 1fr), column-gutter: 3mm, lbl(label), body))
}

#v(1mm)
#row("Profile", text(font: typed, size: 9.6pt, tie(d.profile)))

#let job(j) = {
  grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
    {
      text(weight: 700, size: 12.6pt, j.role)
      h(2mm)
      text(weight: 600, size: 10pt, fill: blue, j.employer)
      text(fill: soft, [, #j.place])
    },
    text(font: typed, weight: 700, size: 9.6pt, fill: red, j.from + " – " + j.to),
  )
  if "intro" in j { block(above: 1.4mm, below: 1.8mm, text(style: "italic", fill: soft, tie(j.intro))) } else { v(1.6mm) }
  for b in j.bullets {
    block(above: 0mm, below: 1.7mm, grid(columns: (4mm, 1fr), text(font: typed, weight: 700, fill: red, "–"), [*#b.lead:* #tie(b.text)]))
  }
}

#row("Experience", {
  job(d.experience.at(0))
  v(2.6mm)
  job(d.experience.at(1))
})

#row("Education", {
  for e in d.education {
    block(below: 2.6mm, grid(columns: (1fr, auto), align: (left, right),
      [*#e.qualification* \ #text(fill: soft, e.institution)],
      text(font: typed, weight: 700, size: 9.6pt, fill: red, e.years)))
  }
})

#row("Languages", grid(columns: (1fr, 1fr, 1.25fr), column-gutter: 4mm,
  ..d.languages.map(l => [*#l.name* #h(1mm) #text(font: typed, weight: 700, fill: red, l.level) #if "note" in l [\ #text(size: 8.8pt, fill: soft, tie(l.note))]])))

#row([Skills & travel\ experience], {
  grid(columns: (1.22fr, 0.78fr), column-gutter: 5mm, ..d.skills.items.map(s => [*#s.lead:* #tie(s.text + ".")]))
})

#row("Recent trips", grid(columns: (1fr, 1fr, 1fr), column-gutter: 4mm,
  ..d.journeys.trips.map(t => [
    #text(font: typed, weight: 700, size: 9pt, fill: red, t.period) \
    *#t.stops.join(" – ")* \
    #text(size: 8.8pt, fill: soft)[#t.days days, #t.role]
  ])))

#row("Availability", [*#d.availability.headline.* #tie(d.availability.text)])

#v(1fr)
#text(font: typed, size: 7pt, fill: soft, upper(d.disclosure))
