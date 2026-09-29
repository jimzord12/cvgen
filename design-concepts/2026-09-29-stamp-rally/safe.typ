// Stamp Rally, Safe tier. Idea run 2026-09-29 (magazine-editor).
// The calm version: a boarding pass as the header, a conventional two-column
// CV below, small eki-style stamps as the markers of the Japan trips, and a
// passenger manifest of the groups. Fictional data: sample.json in this folder.
//
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path design-concepts/fonts design-concepts/2026-09-29-stamp-rally/safe.typ design-concepts/2026-09-29-stamp-rally/safe.pdf

#let d = json("sample.json")

// ---- palette: black print, three stamp inks, a mint security tint, manila tag -
#let C = (
  ink: "1d1d1f", paper: "f4f1e8", stock: "fcfaf4", tint: "cfe3d9", tintdk: "8fbfa9",
  crimson: "c42a43", violet: "5a3d8a", green: "1f7a5a", manila: "ecdcb4", kraft: "b9925a",
  grey: "6d6a64", rule: "d8d2c4",
)
#let col(k) = rgb(C.at(k))
#let cond = "Sofia Sans" // Sofia Sans Extra Condensed registers under this family name
#let mono = "DejaVu Sans Mono"
#let jp = "M PLUS 1p"

// Greek all-caps drop the tonos (dialytika stays)
#let caps(s) = {
  let m = ("Ά": "Α", "Έ": "Ε", "Ή": "Η", "Ί": "Ι", "Ό": "Ο", "Ύ": "Υ", "Ώ": "Ω", "ΐ": "Ϊ", "ΰ": "Ϋ")
  upper(s).clusters().map(c => m.at(c, default: c)).join()
}
#let trips = d.japan_trips
#let jdays = trips.map(t => t.days).sum()
#let gpax = d.groups.map(g => g.pax).sum()

#let f(x) = str(calc.round(x, digits: 2))
#let svg(body, vb, w) = image(bytes(
  "<svg xmlns='http://www.w3.org/2000/svg' viewBox='" + vb + "'>" + body + "</svg>"
), format: "svg", width: w)

// deterministic pseudo-random numbers in [0, 1)
#let rnd(seed, n) = {
  let out = ()
  let x = seed
  for i in range(n) {
    x = calc.rem(x * 1103515245 + 12345, 2147483648)
    out.push(x / 2147483648)
  }
  out
}

// ---- ticket furniture ---------------------------------------------------------
#let guilloche(w, h, color, n: 14, amp: 2.2, seed: 3, op: 1) = {
  let s = "<g fill='none' stroke='#" + color + "' stroke-width='0.16' stroke-opacity='" + f(op) + "'>"
  for k in range(n) {
    let y0 = h * (k + 0.5) / n
    let pts = ()
    for i in range(0, 91) {
      let x = w * i / 90
      let y = y0 + amp * calc.sin((x / w * 6 + k * 0.45) * calc.pi) + amp * 0.5 * calc.sin((x / w * 17 + k * 0.9) * calc.pi)
      pts.push(f(x) + "," + f(y))
    }
    s += "<polyline points='" + pts.join(" ") + "'/>"
  }
  s + "</g>"
}

#let barcode(w, h, seed, color: C.ink) = {
  let r = rnd(seed, 90)
  let s = ""
  let x = 0
  let i = 0
  while x < w - 1 {
    let bw = 0.25 + r.at(calc.rem(i, 90)) * 0.9
    if calc.rem(i, 2) == 0 { s += "<rect x='" + f(x) + "' y='0' width='" + f(bw) + "' height='" + f(h) + "' fill='#" + color + "'/>" }
    x += bw + 0.25
    i += 1
  }
  svg(s, "0 0 " + f(w) + " " + f(h), w * 1mm)
}

// worn-ink speckle over a stamp (dots in the paper colour)
#let speckle(size, seed, color, dot: 0.42) = {
  let r = rnd(seed, 180)
  let s = ""
  for i in range(60) {
    s += "<circle cx='" + f(r.at(i) * size) + "' cy='" + f(r.at(i + 60) * size) + "' r='" + f(0.1 + r.at(i + 120) * dot) + "' fill='#" + color + "'/>"
  }
  svg(s, "0 0 " + f(size) + " " + f(size), size * 1mm)
}

// ---- stamp artwork: line drawings in one ink, drawn in a 40 x 40 box -----------
#let art(kind, k) = {
  let sw(w) = " fill='none' stroke='#" + k + "' stroke-width='" + str(w) + "' stroke-linecap='round' stroke-linejoin='round'"
  let st = sw(1.5)
  let fl = " fill='#" + k + "'"
  if kind == "fuji" {
    "<circle cx='29' cy='10' r='4.2'" + fl + "/>" + "<path d='M3,31 Q14,27 17.5,11 L22.5,11 Q26,27 37,31'" + st + "/>" + "<path d='M15.2,18 L17.6,21 L19.2,17.6 L20.8,21.4 L22.4,17.6 L24.8,18'" + st + "/>" + "<path d='M3,36 q3.5,-3 7,0 q3.5,-3 7,0 q3.5,-3 7,0 q3.5,-3 7,0 q3.5,-3 5,-1'" + st + "/>"
  } else if kind == "torii" {
    "<path d='M5,9 Q20,12 35,9 L34,13 Q20,15.5 6,13 Z'" + fl + "/>" + "<line x1='9' y1='18' x2='31' y2='18'" + st + "/>" + "<line x1='12' y1='13' x2='12.8' y2='35'" + sw(2.6) + "/>" + "<line x1='28' y1='13' x2='27.2' y2='35'" + sw(2.6) + "/>" + "<line x1='20' y1='13.5' x2='20' y2='18'" + st + "/>" + "<path d='M4,36 q4,-2.5 8,0 q4,-2.5 8,0 q4,-2.5 8,0 q4,-2.5 8,0'" + sw(1.1) + "/>"
  } else if kind == "study" {
    "<path d='M6,30 L20,34 L34,30 L34,14 L20,18 L6,14 Z'" + st + "/><line x1='20' y1='18' x2='20' y2='34'" + st + "/>" + "<path d='M8,22 L17,24.5 M8,26 L17,28.5 M23,24.5 L32,22 M23,28.5 L32,26'" + sw(0.9) + "/>" + "<circle cx='20' cy='8' r='4.4'" + fl + "/>"
  } else if kind == "maple" {
    "<path d='M3,34 L12,22 L18,28 L26,16 L37,34'" + st + "/>" + "<g transform='translate(20,11) scale(1.35)'><path d='M0,-6 L1.4,-2 L5,-3.2 L3,0.4 L5.4,2.6 L1.6,2.4 L0.6,6 L0,3.4 L-0.6,6 L-1.6,2.4 L-5.4,2.6 L-3,0.4 L-5,-3.2 L-1.4,-2 Z'" + fl + "/></g>"
  } else if kind == "snow" {
    let s = "<path d='M3,34 L13,20 L19,26 L27,14 L37,34'" + st + "/><path d='M23.5,19.5 L27,14 L30.5,19.5'" + st + "/>"
    for a in (0, 60, 120) {
      s += "<g transform='translate(12,10) rotate(" + str(a) + ")'><line x1='0' y1='-6' x2='0' y2='6'" + sw(1.1) + "/><path d='M-1.8,-4.4 L0,-3 L1.8,-4.4 M-1.8,4.4 L0,3 L1.8,4.4'" + sw(0.9) + "/></g>"
    }
    s
  } else if kind == "flag" {
    let s = "<line x1='27' y1='6' x2='29' y2='30'" + st + "/><path d='M27,6 L39,10 L27.6,14 Z'" + fl + "/>"
    for (i, x) in (4, 9.5, 15, 20.5).enumerate() {
      s += "<circle cx='" + str(x) + "' cy='25' r='2.2'" + fl + "/><path d='M" + f(x - 2.8) + ",34 Q" + str(x) + ",27 " + f(x + 2.8) + ",34'" + fl + "/>"
    }
    s + "<circle cx='31' cy='22' r='2.5'" + fl + "/><path d='M27.6,34 Q31,25 34.4,34'" + fl + "/>"
  } else if kind == "plane" {
    "<g transform='translate(21,19) rotate(-28) scale(3.6)'><path d='M-3.2,0 L3.4,0 Q4.4,0.3 3.4,0.6 L-3.2,0.6 Z M0.6,0.3 L-1.4,-2.6 L-0.5,-2.6 L2.0,0.3 Z M0.6,0.3 L-1.4,3.0 L-0.5,3.0 L2.0,0.4 Z M-3.2,0.3 L-4.0,-1.3 L-3.4,-1.3 L-2.4,0.3 Z'" + fl + "/></g><path d='M4,34 Q12,30 16,24'" + sw(1.1) + " stroke-dasharray='1.5 1.8'/>"
  } else if kind == "onsen" {
    "<path d='M6,24 Q6,35 20,35 Q34,35 34,24'" + sw(2.2) + "/>" + "<path d='M13,21 q-3,-4 0,-8 q3,-4 0,-8 M20,21 q-3,-4 0,-8 q3,-4 0,-8 M27,21 q-3,-4 0,-8 q3,-4 0,-8'" + sw(2) + "/>"
  } else if kind == "train" {
    "<path d='M2,27 L24,27 Q34,27 38,23 Q31,18 22,17.5 L2,17.5 Z'" + st + "/><line x1='2' y1='23.5' x2='33' y2='23.5'" + sw(1) + "/><path d='M5,20.5 L20,20.5'" + sw(1.6) + " stroke-dasharray='2 1.2'/><line x1='0' y1='31' x2='40' y2='31'" + st + "/><path d='M4,31 L4,36 M14,31 L14,36 M24,31 L24,36 M34,31 L34,36'" + sw(1) + "/>"
  } else { "" }
}

// ---- a round eki-style stamp -------------------------------------------------
// size in mm; ring: text around the rim; label: big centre word (kanji); ink key
#let stamp(size, ink, ring, label, kind, rot: 0deg, seed: 7, op: 0.9, label-font: jp, label-size: auto) = {
  let S = size * 1mm
  let inkc = rgb(C.at(ink))
  let k = C.at(ink)
  let rim = "<circle cx='" + f(size / 2) + "' cy='" + f(size / 2) + "' r='" + f(size / 2 - 0.5) + "' fill='none' stroke='#" + k + "' stroke-width='" + f(size * 0.03) + "'/>" + "<circle cx='" + f(size / 2) + "' cy='" + f(size / 2) + "' r='" + f(size / 2 - size * 0.155) + "' fill='none' stroke='#" + k + "' stroke-width='" + f(size * 0.014) + "'/>"
  let inner = size * 0.69
  let cs = ring.clusters()
  let n = cs.len()
  let rr = size / 2 - size * 0.083
  rotate(rot, reflow: false, box(width: S, height: S, {
    set text(fill: inkc)
    place(top + left, svg(rim, "0 0 " + f(size) + " " + f(size), S))
    for (i, c) in cs.enumerate() {
      let a = i / n * 360deg
      place(center + horizon, dx: rr * calc.sin(a) * 1mm, dy: -rr * calc.cos(a) * 1mm,
        rotate(a, text(font: (cond, jp), size: size * 0.21 * 1pt * 1.0, weight: 800, c)))
    }
    place(center + horizon, dy: -inner * 0.13 * 1mm, svg(art(kind, k), "0 0 40 40", inner * 0.62 * 1mm))
    place(center + horizon, dy: inner * 0.32 * 1mm, text(font: label-font, size: (if label-size == auto { size * 0.3 * 1pt } else { label-size }), weight: 800, label))
    place(top + left, speckle(size, seed, C.stock, dot: size * 0.013))
  }))
}

// a rectangular entry stamp (double border, three lines)
#let rstamp(w, ink, lines, rot: 0deg, seed: 11) = {
  let inkc = rgb(C.at(ink))
  rotate(rot, reflow: false, box({
    box(stroke: 1.3pt + inkc, radius: 2pt, inset: 1.2pt, box(stroke: 0.5pt + inkc, radius: 1.2pt, inset: (x: 2.4mm, y: 1.6mm), width: w * 1mm, {
      set align(center)
      set par(leading: 0.3em)
      set text(fill: inkc, font: cond, weight: 800)
      lines.join(linebreak())
    }))
    place(top + left, speckle(w * 0.6, seed, C.stock, dot: 0.2))
  }))
}

// perforation: a dashed tear line with half-moon notches at the ends
#let perf-v(h, x, y, notch: 2.2, paper: C.paper) = {
  place(top + left, dx: x, dy: y, line(start: (0mm, 1.5mm), end: (0mm, h - 1.5mm), stroke: (paint: rgb(C.grey), thickness: 0.6pt, dash: (2pt, 2pt))))
  place(top + left, dx: x - notch * 1mm, dy: y - notch * 1mm, circle(radius: notch * 1mm, fill: rgb(paper)))
  place(top + left, dx: x - notch * 1mm, dy: y + h - notch * 1mm, circle(radius: notch * 1mm, fill: rgb(paper)))
}

#let label(s) = text(font: mono, size: 5.6pt, fill: col("grey"), tracking: 0.02em, s)
#let field(l, val, size: 9pt, font: mono, weight: 700) = block(below: 0mm, {
  label(l)
  v(-1.2mm)
  text(font: font, size: size, weight: weight, val)
})

#let body = "M PLUS 1p"
#set page(paper: "a4", margin: 0mm, fill: rgb("f7f5ef"))
#set text(font: body, size: 8.6pt, fill: col("ink"), lang: "el")
#set par(leading: 0.55em, spacing: 0.8em)

// ---- a calm boarding pass as the header -------------------------------------
#let PX = 14mm
#let PY = 12mm
#let PW = 182mm
#let PH = 60mm
#let SX = 144mm

#place(top + left, dx: PX, dy: PY, rect(width: PW, height: PH, radius: 2.5mm, fill: col("stock"), stroke: 0.6pt + col("ink")))
#place(top + left, dx: PX + 1mm, dy: PY + 10mm, svg(guilloche(142, 49, C.tint, n: 16, amp: 1.6, op: 0.8), "0 0 142 49", 142mm))
#place(top + left, dx: PX, dy: PY, rect(width: SX, height: 9mm, radius: (top-left: 2.5mm), fill: col("ink")))
#place(top + left, dx: PX + SX, dy: PY, rect(width: PW - SX, height: 9mm, radius: (top-right: 2.5mm), fill: col("crimson")))
#place(top + left, dx: PX + 6mm, dy: PY + 2.1mm, text(fill: white, {
  text(font: cond, size: 11.5pt, weight: 800, tracking: 0.12em)[ΚΑΡΤΑ ΕΠΙΒΙΒΑΣΗΣ]
  h(3mm)
  text(font: mono, size: 6pt)[BOARDING PASS · ATH → TYO]
}))
#place(top + left, dx: PX + SX, dy: PY + 2.1mm, box(width: PW - SX, align(center, text(font: cond, size: 11.5pt, weight: 800, tracking: 0.14em, fill: white)[ΑΡΧΗΓΟΣ])))

#place(top + left, dx: PX + 6mm, dy: PY + 11.5mm, label("ΕΠΙΒΑΤΗΣ / PASSENGER"))
#place(top + left, dx: PX + 5.4mm, dy: PY + 14mm, text(font: cond, size: 40pt, weight: 900, d.name.caps))
#place(top + left, dx: PX + 6mm, dy: PY + 32mm, grid(columns: (74mm, 56mm), column-gutter: 3mm,
  field("ΘΕΣΗ / ROLE", text(font: cond, size: 14pt, weight: 800, d.title.caps), font: cond),
  field("ΕΞΕΙΔΙΚΕΥΣΗ / SPECIALTY", text(font: cond, size: 14pt, weight: 800, fill: col("crimson"))[ΙΑΠΩΝΙΑ #text(font: jp, size: 10pt, weight: 700)[日本]], font: cond),
))
#place(top + left, dx: PX + 6mm, dy: PY + 47mm, grid(columns: (24mm, 36mm, 60mm), column-gutter: 3mm,
  field("ΒΑΣΗ", d.contact.city, size: 7.8pt),
  field("ΤΗΛΕΦΩΝΟ", d.contact.phone, size: 7.8pt),
  field("EMAIL", d.contact.email, size: 7.8pt),
))
#perf-v(PH, PX + SX, PY, paper: "f7f5ef")
#place(top + left, dx: PX + 112mm, dy: PY + 9.4mm, stamp(25, "violet", "ΙΑΠΩΝΙΑ · " + str(trips.len()) + " ΤΑΞΙΔΙΑ · " + str(jdays) + " ΗΜΕΡΕΣ · ", "日本", "fuji", rot: -12deg, seed: 5))
#place(top + left, dx: PX + SX + 6.5mm, dy: PY + 12mm, box(stroke: 0.5pt + col("ink"), inset: 1pt, fill: white, box(clip: true, width: 25mm, height: 30mm, image("portrait.jpg", width: 30mm))))
#place(top + left, dx: PX + SX + 4.5mm, dy: PY + 46mm, barcode(29, 8, 4))
#place(top + left, dx: PX + SX + 4.5mm, dy: PY + 55mm, text(font: mono, size: 5.4pt)[ΗΛΙΑΔΗΣ/ΜΑΡΚΟΣ])

// ---- body --------------------------------------------------------------------
#let head(t, en) = block(above: 3.6mm, below: 1.8mm, {
  text(font: cond, size: 14pt, weight: 800, tracking: 0.06em, t)
  h(2mm)
  text(font: mono, size: 6pt, fill: col("grey"), en)
  v(-1.7mm)
  line(length: 100%, stroke: (paint: col("ink"), thickness: 0.7pt, dash: (3pt, 1.6pt)))
})
#let inks = ("crimson", "violet", "green", "violet", "crimson")
#let kinds = ("torii", "study", "maple", "snow", "flag")

#let main = block(width: 118mm, {
  block(above: 0mm, text(size: 9pt, d.profile))
  head("ΕΜΠΕΙΡΙΑ", "EXPERIENCE")
  for e in d.experience {
    block(below: 2.2mm, {
      set par(leading: 0.45em)
      grid(columns: (1fr, auto), text(size: 9.4pt, weight: 700, e.role), text(font: mono, size: 7.2pt, weight: 700, fill: col("crimson"), e.from + "–" + e.to))
      text(font: cond, size: 10.5pt, weight: 700, fill: col("violet"), e.company + " · " + caps(e.city))
      linebreak()
      for p in e.points.slice(0, calc.min(3, e.points.len())) [#grid(columns: (3mm, 1fr), text(fill: col("crimson"), "›"), p)]
    })
  }
  head("ΙΑΠΩΝΙΑ", "ONE STAMP PER TRIP")
  for (i, t) in trips.enumerate() {
    block(below: 0.6mm, grid(columns: (17mm, 30mm, 1fr, 14mm), column-gutter: 2mm, align: horizon,
      stamp(16.5, inks.at(i), str(t.year) + " · " + caps(t.places.first()) + " · ", t.kanji, kinds.at(i), rot: (-8deg, 5deg, -3deg, 9deg, -6deg).at(i), seed: 30 + i, label-size: 5.2pt),
      [#text(font: cond, size: 11pt, weight: 800, t.when) \ #text(font: cond, size: 9pt, weight: 700, tracking: 0.04em, fill: (if t.kind == "colead" { col("crimson") } else { col("grey") }), caps(t.kind_el))],
      text(size: 8.4pt, t.places.join(", ")),
      align(right, text(font: cond, size: 13pt, weight: 900, fill: col(inks.at(i)), str(t.days) + " ΗΜ.")),
    ))
  }
  head("ΛΙΣΤΑ ΕΠΙΒΑΤΩΝ", "MANIFEST · ΟΜΑΔΕΣ ΠΟΥ ΣΥΝΟΔΕΥΣΕ")
  set text(font: mono, size: 7.2pt)
  table(
    columns: (15mm, 1fr, 14mm, 11mm), stroke: none, inset: (x: 1mm, y: 0.95mm),
    fill: (_, y) => if calc.odd(y) and y <= d.groups.len() { col("stock") } else { none },
    ..("ΠΟΤΕ", "ΠΡΟΟΡΙΣΜΟΣ · ΡΟΛΟΣ", "ΑΤΟΜΑ", "ΗΜ.").map(h => text(size: 6pt, fill: col("grey"), h)),
    table.hline(stroke: 0.5pt + col("ink")),
    ..d.groups.map(g => (g.date, (if g.japan { text(weight: 700, fill: col("crimson"))[ΙΑΠΩΝΙΑ · #caps(g.role)] } else { [#caps(g.where) · #text(fill: col("grey"), caps(g.role))] }), str(g.pax), str(g.days))).flatten(),
    table.hline(stroke: 0.5pt + col("ink")),
    [], text(weight: 700)[#d.groups.len() ΟΜΑΔΕΣ], text(weight: 700, str(gpax)), text(weight: 700, str(d.groups.map(g => g.days).sum())),
  )
})

#let side = block(width: 56mm, {
  block(above: 0mm, width: 100%, fill: col("stock"), stroke: 0.5pt + col("ink"), radius: 1.5mm, inset: (x: 3mm, y: 2.6mm), {
    set par(leading: 0.3em)
    for (n, l) in ((str(trips.len()), "ΤΑΞΙΔΙΑ ΣΤΗΝ ΙΑΠΩΝΙΑ"), (str(jdays), "ΗΜΕΡΕΣ ΣΤΗ ΧΩΡΑ"), ("N4", "JLPT · 12/2024")) {
      grid(columns: (19mm, 1fr), align: horizon, text(font: cond, size: 24pt, weight: 900, fill: col("crimson"), n), text(font: cond, size: 10pt, weight: 800, l))
    }
  })
  head("ΓΛΩΣΣΕΣ", "LANGUAGES")
  for l in d.languages { grid(columns: (18mm, 1fr), text(weight: 700, l.name), l.level) }
  head("ΧΑΡΤΙΑ", "PAPERS")
  set par(leading: 0.42em)
  for c in d.certificates { block(below: 1.3mm)[#text(weight: 700, c.title) \ #text(size: 7.4pt, fill: col("grey"), c.issuer + ", " + c.valid)] }
  for e in d.education.slice(0, 2) { block(below: 1.3mm)[#grid(columns: (1fr, auto), column-gutter: 1mm, text(weight: 700, e.title), text(font: mono, size: 7pt, fill: col("crimson"), e.years)) #v(-1.4mm) #text(size: 7.4pt, fill: col("grey"), e.school)] }
  head("ΣΤΗΝ ΙΑΠΩΝΙΑ", "KNOW-HOW")
  for k in d.knowhow [#grid(columns: (3mm, 1fr), text(fill: col("crimson"), "›"), k)]
  head("ΔΙΑΘΕΣΙΜΟΤΗΤΑ", "AVAILABILITY")
  for k in d.availability [#grid(columns: (3mm, 1fr), text(fill: col("crimson"), "›"), k)]
})

#place(top + left, dx: 14mm, dy: 78mm, main)
#place(top + left, dx: 140mm, dy: 78mm, side)

// the offer, a single stamp at the foot
#place(top + left, dx: 138mm, dy: 268mm, rstamp(50, "crimson", (text(size: 9.4pt)[ΔΩΡΕΑΝ ΒΡΑΔΙΑ ΕΝΗΜΕΡΩΣΗΣ], text(size: 7.8pt, weight: 600)[για την Ιαπωνία στους πελάτες σας]), rot: -2deg, seed: 41))
#place(bottom + left, dx: 14mm, dy: -5mm, text(font: mono, size: 5pt, fill: col("grey"))[ΦΑΝΤΑΣΤΙΚΟ ΠΡΟΣΩΠΟ · ΣΧΕΔΙΟ CVGEN])
