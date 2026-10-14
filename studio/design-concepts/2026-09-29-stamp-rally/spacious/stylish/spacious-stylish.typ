// Stamp Rally, Stylish tier, Spacious density (two pages). Idea run 2026-09-29 (magazine-editor).
// The escort's travel papers, given room. Page 1: a larger boarding pass, the
// profile with the offer stamp, the stamp-rally card with one larger eki stamp
// per Japan trip, and the working record. Page 2: the airline bag tag becomes
// the header and carries the name, then the passenger manifest, and the
// papers (degree, courses, first aid, JLPT) as entry stamps on an open
// passport page, then the know-how and the duties on the road.
// Fictional data: sample.json in the style folder.
//
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path design-concepts/fonts design-concepts/2026-09-29-stamp-rally/spacious/stylish/spacious-stylish.typ design-concepts/2026-09-29-stamp-rally/spacious/stylish/spacious-stylish.pdf

#let d = json("../../sample.json")

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
#set page(paper: "a4", margin: 0mm, fill: col("paper"))
#set text(font: body, size: 8.4pt, fill: col("ink"), lang: "el")
#set par(leading: 0.55em, spacing: 0.8em)
#set text(size: 10pt)
#set par(leading: 0.58em, spacing: 0.85em)

#let head(t, en) = block(above: 0mm, below: 2.6mm, {
  text(font: cond, size: 16pt, weight: 800, tracking: 0.06em, t)
  h(2mm)
  text(font: mono, size: 6.8pt, fill: col("grey"), en)
  v(-1.9mm)
  line(length: 100%, stroke: (paint: col("ink"), thickness: 0.7pt, dash: (3pt, 1.6pt)))
})
#let chev(body) = grid(columns: (3.6mm, 1fr), text(fill: col("crimson"), "›"), body)
#let plane-svg(w) = svg("<line x1='0' y1='4' x2='26' y2='4' stroke='#" + C.grey + "' stroke-width='0.35' stroke-dasharray='1 0.8'/><g transform='translate(13,4) scale(1.4)' fill='#" + C.crimson + "'><path d='M-3.2,0 L3.4,0 Q4.4,0.3 3.4,0.6 L-3.2,0.6 Z M0.6,0.3 L-1.4,-2.6 L-0.5,-2.6 L2.0,0.3 Z M0.6,0.3 L-1.4,3.0 L-0.5,3.0 L2.0,0.4 Z M-3.2,0.3 L-4.0,-1.3 L-3.4,-1.3 L-2.4,0.3 Z'/></g>", "0 0 26 8", w)

// =========================== PAGE 1 ===========================
#let PX = 12mm
#let PY = 10mm
#let PW = 186mm
#let PH = 88mm
#let SX = 142mm

#place(top + left, dx: PX, dy: PY, rect(width: PW, height: PH, radius: 3mm, fill: col("stock"), stroke: 0.6pt + col("ink")))
#place(top + left, dx: PX + 1mm, dy: PY + 12mm, svg(guilloche(139, 75, C.tint, n: 26, amp: 1.8), "0 0 139 75", 139mm))
#place(top + left, dx: PX, dy: PY, rect(width: SX, height: 12mm, radius: (top-left: 3mm), fill: col("ink")))
#place(top + left, dx: PX + SX, dy: PY, rect(width: PW - SX, height: 12mm, radius: (top-right: 3mm), fill: col("crimson")))
#place(top + left, dx: PX + 6mm, dy: PY + 3mm, text(fill: white, {
  text(font: cond, size: 14.5pt, weight: 800, tracking: 0.12em)[ΚΑΡΤΑ ΕΠΙΒΙΒΑΣΗΣ]
  h(3mm)
  text(font: mono, size: 7pt)[BOARDING PASS · GROUP DEPARTURE]
}))
#place(top + left, dx: PX + SX, dy: PY + 3mm, box(width: PW - SX, align(center, text(font: cond, size: 14.5pt, weight: 800, tracking: 0.14em, fill: white)[ΑΡΧΗΓΟΣ])))

#place(top + left, dx: PX + 6mm, dy: PY + 15mm, label("ΕΠΙΒΑΤΗΣ / PASSENGER"))
#place(top + left, dx: PX + 5.4mm, dy: PY + 18mm, text(font: cond, size: 56pt, weight: 900, tracking: -0.005em, d.name.caps))
#place(top + left, dx: PX + 6mm, dy: PY + 44mm, label("ΑΠΟ / FROM"))
#place(top + left, dx: PX + 56mm, dy: PY + 44mm, label("ΠΡΟΣ / TO"))
#place(top + left, dx: PX + 5.4mm, dy: PY + 46.6mm, text(font: cond, size: 38pt, weight: 900)[ATH])
#place(top + left, dx: PX + 27mm, dy: PY + 51.4mm, plane-svg(26mm))
#place(top + left, dx: PX + 55.4mm, dy: PY + 46.6mm, text(font: cond, size: 38pt, weight: 900, fill: col("crimson"))[TYO])
#place(top + left, dx: PX + 6mm, dy: PY + 62mm, text(font: mono, size: 7pt, fill: col("grey"))[ΑΘΗΝΑ])
#place(top + left, dx: PX + 56mm, dy: PY + 62mm, text(font: mono, size: 7pt, fill: col("grey"))[ΤΟΚΙΟ])
#place(top + left, dx: PX + 84mm, dy: PY + 44mm, block(width: 56mm, {
  field("ΘΕΣΗ / ROLE", text(font: cond, size: 16pt, weight: 800, d.title.caps), font: cond)
  v(1.6mm)
  field("ΕΞΕΙΔΙΚΕΥΣΗ / SPECIALTY", text(font: cond, size: 16pt, weight: 800, fill: col("crimson"))[ΙΑΠΩΝΙΑ #text(font: jp, size: 11.5pt, weight: 700)[日本]], font: cond)
}))
#place(top + left, dx: PX + 6mm, dy: PY + 70mm, grid(columns: (21mm, 37mm, 58mm), column-gutter: 2.4mm,
  field("ΒΑΣΗ", d.contact.city, size: 8.8pt),
  field("ΤΗΛΕΦΩΝΟ", d.contact.phone, size: 8.8pt),
  field("EMAIL", d.contact.email, size: 8.8pt),
))
#place(top + left, dx: PX + 6mm, dy: PY + 80.5mm, text(font: mono, size: 7pt, fill: col("grey"))[WEB #h(1.6mm) #text(fill: col("ink"), weight: 700, d.contact.link)])
#perf-v(PH, PX + SX, PY, paper: C.paper)
#place(top + left, dx: PX + SX + 6mm, dy: PY + 16mm, box(stroke: 0.5pt + col("ink"), inset: 1pt, fill: white, box(clip: true, width: 30mm, height: 36mm, image("../../portrait.jpg", width: 36mm))))
#place(top + left, dx: PX + SX + 4.4mm, dy: PY + 56mm, block(width: 36mm, {
  set text(font: mono, size: 7pt)
  set par(leading: 0.42em)
  [#text(weight: 700)[ΗΛΙΑΔΗΣ/ΜΑΡΚΟΣ] \ ATH → TYO · ΟΜΑΔΑ \ ΑΤΟΜΑ #gpax · ΟΜΑΔΕΣ #d.groups.len()]
}))
#place(top + left, dx: PX + SX + 4.4mm, dy: PY + 72mm, barcode(34, 11, 4))
#place(top + left, dx: PX + 118mm, dy: PY + 57mm, stamp(31, "violet", "ΙΑΠΩΝΙΑ · " + str(trips.len()) + " ΤΑΞΙΔΙΑ · " + str(jdays) + " ΗΜΕΡΕΣ · ", "日本", "fuji", rot: -14deg, seed: 5))

// profile, as the ticket's printed conditions, with the offer stamped beside it
#place(top + left, dx: 12mm, dy: 104mm, block(width: 136mm, {
  set par(leading: 0.6em)
  text(font: cond, size: 14pt, weight: 800, tracking: 0.08em, fill: col("crimson"))[ΠΡΟΦΙΛ]
  h(2mm)
  text(size: 10.4pt, d.profile)
}))
#place(top + left, dx: 152mm, dy: 104mm, rstamp(38, "crimson", (text(size: 10pt)[ΔΩΡΕΑΝ ΒΡΑΔΙΑ ΕΝΗΜΕΡΩΣΗΣ], text(size: 8.6pt, weight: 600)[για την Ιαπωνία στους πελάτες σας], text(size: 8.6pt, weight: 600)[πριν την αναχώρηση]), rot: -3deg, seed: 41))

// the stamp-rally card
#let inks = ("crimson", "violet", "green", "violet", "crimson")
#let kinds = ("torii", "study", "maple", "snow", "flag")
#let CY = 134mm
#let CH = 81mm
#place(top + left, dx: 12mm, dy: CY, rect(width: 186mm, height: CH, radius: 2mm, fill: col("stock"), stroke: 0.5pt + col("ink")))
#place(top + left, dx: 12mm, dy: CY, rect(width: 186mm, height: 10.5mm, radius: (top: 2mm), fill: col("tint")))
#place(top + left, dx: 17mm, dy: CY + 2.2mm, {
  text(font: cond, size: 15pt, weight: 800, tracking: 0.1em)[ΚΑΡΤΑ ΣΦΡΑΓΙΔΩΝ · ΙΑΠΩΝΙΑ]
  h(3mm)
  text(font: jp, size: 10.5pt, weight: 700)[スタンプラリー]
  h(3mm)
  text(font: mono, size: 7.4pt, fill: col("grey"))[ΜΙΑ ΣΦΡΑΓΙΔΑ ΓΙΑ ΚΑΘΕ ΤΑΞΙΔΙ, #trips.first().year–#trips.last().year]
})
#for (i, t) in trips.enumerate() {
  let x = 15.5mm + i * 36.6mm
  let pro = t.kind == "colead"
  place(top + left, dx: x, dy: CY + 13mm, circle(radius: 17.4mm, fill: none, stroke: (paint: col("rule"), thickness: 0.7pt, dash: (2pt, 2pt))))
  place(top + left, dx: x, dy: CY + 13mm, stamp(34.8, inks.at(i), caps(t.places.join(" · ")) + " · " + str(t.year) + " · ", t.kanji, kinds.at(i), rot: (-9deg, 6deg, -4deg, 11deg, -7deg).at(i), seed: 20 + i))
  place(top + left, dx: x - 0.6mm, dy: CY + 51mm, block(width: 35mm, {
    set par(leading: 0.4em)
    text(font: cond, size: 14pt, weight: 800, t.when)
    linebreak()
    text(font: cond, size: 13pt, weight: 900, fill: col(inks.at(i)), str(t.days) + " ΗΜ.")
    h(1.6mm)
    text(font: cond, size: 10.4pt, weight: 800, tracking: 0.05em, fill: (if pro { col("crimson") } else { col("grey") }), caps(t.kind_el))
    linebreak()
    text(size: 8.8pt, t.places.join(", "))
  }))
}

// the working record
#place(top + left, dx: 12mm, dy: 225mm, block(width: 186mm, {
  head("ΕΜΠΕΙΡΙΑ", "EXPERIENCE")
  grid(columns: (112mm, 1fr), column-gutter: 8mm, {
    let e = d.experience.first()
    set par(leading: 0.5em)
    text(size: 11pt, weight: 700, e.role)
    linebreak()
    text(font: cond, size: 12.5pt, weight: 700, fill: col("violet"), e.company + " · " + caps(e.city))
    h(1fr)
    text(font: mono, size: 8.2pt, weight: 700, fill: col("crimson"), e.from + "–" + e.to)
    linebreak()
    for p in e.points { block(below: 1.5mm, chev(p)) }
  }, {
    let e = d.experience.at(1)
    set par(leading: 0.5em)
    text(size: 11pt, weight: 700, e.role)
    linebreak()
    text(font: cond, size: 12.5pt, weight: 700, fill: col("violet"), e.company + " · " + caps(e.city))
    linebreak()
    text(font: mono, size: 8.2pt, weight: 700, fill: col("crimson"), e.from + "–" + e.to)
    linebreak()
    for p in e.points { block(below: 1.5mm, chev(p)) }
  })
}))
#place(bottom + right, dx: -3mm, dy: -2.4mm, text(font: mono, size: 5.4pt, fill: col("grey"))[ΦΑΝΤΑΣΤΙΚΟ ΠΡΟΣΩΠΟ · ΣΧΕΔΙΟ CVGEN · 1/2])

#pagebreak()

// =========================== PAGE 2 ===========================
// ---- the bag tag as the header: it carries the name ---------------------------------
#place(top + left, dx: 10mm, dy: 11mm, rotate(-0.8deg, reflow: false, box(width: 190mm, height: 34mm, {
  place(top + left, rect(width: 190mm, height: 34mm, radius: 1.8mm, fill: col("stock"), stroke: 0.5pt + col("ink")))
  place(top + left, svg(guilloche(190, 34, C.tint, n: 14, amp: 1.2, op: 0.7), "0 0 190 34", 190mm))
  place(top + left, rect(width: 44mm, height: 34mm, radius: (left: 1.8mm), fill: col("crimson")))
  place(top + left, dx: 6mm, dy: 12.6mm, circle(radius: 2.8mm, fill: col("paper"), stroke: 1.4pt + col("manila")))
  place(top + left, dx: 15mm, dy: 2.6mm, text(font: cond, size: 40pt, weight: 900, fill: white)[TYO])
  place(top + left, dx: 15mm, dy: 22.4mm, text(font: mono, size: 6.6pt, fill: white)[ΑΡΧΗΓΟΣ ΟΜΑΔΑΣ])
  place(top + left, dx: 15mm, dy: 26.6mm, text(font: mono, size: 6.6pt, fill: white)[ATH → TYO · 2/2])
  place(top + left, dx: 50mm, dy: 3.4mm, label("ΕΠΙΒΑΤΗΣ / PASSENGER"))
  place(top + left, dx: 49.6mm, dy: 6mm, text(font: cond, size: 32pt, weight: 900, d.name.caps))
  place(top + left, dx: 50mm, dy: 21.6mm, text(font: cond, size: 13pt, weight: 800)[#d.title.caps #h(2mm) #text(fill: col("crimson"))[ΙΑΠΩΝΙΑ #text(font: jp, size: 9.6pt, weight: 700)[日本]]])
  place(top + left, dx: 50mm, dy: 28mm, text(font: mono, size: 6.8pt, fill: col("grey"))[#d.contact.phone · #d.contact.email])
  place(top + left, dx: 160mm, dy: 4mm, barcode(24, 16, 9))
  place(top + left, dx: 160mm, dy: 22mm, text(font: mono, size: 6.4pt)[JPN 0426 \ #gpax PAX])
})))

// ---- manifest (left), languages and availability (right) ----------------------------
#place(top + left, dx: 12mm, dy: 55mm, block(width: 112mm, {
  head("ΛΙΣΤΑ ΕΠΙΒΑΤΩΝ", "MANIFEST · ΟΜΑΔΕΣ ΠΟΥ ΣΥΝΟΔΕΥΣΕ")
  set text(font: mono, size: 8.4pt)
  table(
    columns: (17mm, 1fr, 15mm, 11mm), stroke: none, inset: (x: 1.2mm, y: 1.4mm),
    fill: (_, y) => if calc.odd(y) and y <= d.groups.len() { col("stock") } else { none },
    ..("ΠΟΤΕ", "ΠΡΟΟΡΙΣΜΟΣ · ΡΟΛΟΣ", "ΑΤΟΜΑ", "ΗΜ.").map(h => text(size: 6.8pt, fill: col("grey"), h)),
    table.hline(stroke: 0.5pt + col("ink")),
    ..d.groups.map(g => (g.date, (if g.japan { text(weight: 700, fill: col("crimson"))[ΙΑΠΩΝΙΑ · #caps(g.role)] } else { [#caps(g.where) · #text(fill: col("grey"), caps(g.role))] }), str(g.pax), str(g.days))).flatten(),
    table.hline(stroke: 0.5pt + col("ink")),
    [], text(weight: 700)[#d.groups.len() ΟΜΑΔΕΣ], text(weight: 700, str(gpax)), text(weight: 700, str(d.groups.map(g => g.days).sum())),
  )
}))
#place(top + left, dx: 132mm, dy: 55mm, block(width: 66mm, {
  head("ΓΛΩΣΣΕΣ", "LANGUAGES")
  for l in d.languages { block(below: 1.8mm, grid(columns: (20mm, 1fr), text(weight: 700, l.name), [#l.level#if "note" in l [ \ #text(size: 8.4pt, fill: col("grey"), l.note)]])) }
  v(3mm)
  head("ΔΙΑΘΕΣΙΜΟΣ", "AVAILABILITY")
  for k in d.availability { block(below: 1.4mm, chev(k)) }
}))

// ---- the papers as entry stamps on an open passport page ---------------------------
#let VY = 122mm
#let VH = 94mm
#place(top + left, dx: 12mm, dy: VY, rect(width: 186mm, height: VH, radius: 2mm, fill: rgb("eef5f0"), stroke: 0.5pt + col("ink")))
#place(top + left, dx: 12mm, dy: VY, svg(guilloche(186, 94, C.tint, n: 34, amp: 2.4, op: 0.9), "0 0 186 94", 186mm))
#place(top + left, dx: 105mm, dy: VY + 2mm, line(start: (0mm, 0mm), end: (0mm, VH - 4mm), stroke: (paint: col("tintdk"), thickness: 0.6pt, dash: (1pt, 1.4pt))))
#place(top + left, dx: 17mm, dy: VY + 3.4mm, {
  text(font: cond, size: 15pt, weight: 800, tracking: 0.1em)[ΧΑΡΤΙΑ · ΘΕΩΡΗΣΕΙΣ]
  h(3mm)
  text(font: mono, size: 7pt, fill: col("grey"))[PASSPORT · VISAS · ΣΠΟΥΔΕΣ ΚΑΙ ΠΙΣΤΟΠΟΙΗΣΕΙΣ]
})
#place(top + right, dx: -17mm, dy: VY + 3.4mm, text(font: mono, size: 8pt, fill: col("grey"))[14 #h(4mm) 15])
#let visa(x, y, w, ink, l1, big, l3, rot, seed) = place(top + left, dx: x, dy: VY + y, rstamp(w, ink, (text(size: 9.4pt, l1), text(size: 14pt, big), text(size: 8.6pt, weight: 600, l3)), rot: rot, seed: seed))
#visa(18mm, 18mm, 56, "violet", [ΠΑΝΕΠΙΣΤΗΜΙΟ ΔΥΤΙΚΗΣ ΑΤΤΙΚΗΣ], [ΠΤΥΧΙΟ ΔΙΟΙΚΗΣΗΣ ΤΟΥΡΙΣΜΟΥ], [2015–2019], -3deg, 11)
#visa(24mm, 56mm, 50, "crimson", [ΤΟΥΡΙΣΤΙΚΟΣ ΣΥΝΟΔΟΣ], [TOUR LEADER], [E-LEARNING · 115 ΩΡΕΣ · 2025], 4deg, 12)
#visa(112mm, 17mm, 52, "green", [ΠΡΩΤΕΣ ΒΟΗΘΕΙΕΣ & ΚΑΡΠΑ/AED], [ΕΓΚΥΡΟ ΕΩΣ 03/2028], [ΕΛΛΗΝΙΚΟΣ ΕΡΥΘΡΟΣ ΣΤΑΥΡΟΣ · 12 ΩΡΕΣ], 3deg, 13)
#visa(110mm, 58mm, 50, "violet", [ΙΑΠΩΝΙΚΗ ΓΛΩΣΣΑ · ΕΝΤΑΤΙΚΟ], [ΦΟΥΚΟΥΟΚΑ 2019], [ΓΛΩΣΣΙΚΟ ΣΧΟΛΕΙΟ · 6 ΕΒΔΟΜΑΔΕΣ], -4deg, 14)
#place(top + left, dx: 76mm, dy: VY + 42mm, stamp(32, "crimson", "JLPT · N4 · 12/2024 · ΣΤΟΧΟΣ N3 · ", "日本語", "study", rot: 10deg, seed: 61, label-size: 7pt))
#place(top + left, dx: 165mm, dy: VY + 50mm, stamp(30, "green", "ENGLISH · C2 · PROFICIENCY · ", "EN", "plane", rot: -12deg, seed: 62, label-font: cond, label-size: 8pt))

// ---- in Japan, on the road ---------------------------------------------------------
#place(top + left, dx: 12mm, dy: 224mm, grid(columns: (90mm, 90mm), column-gutter: 6mm, {
  head("ΣΤΗΝ ΙΑΠΩΝΙΑ", "KNOW-HOW")
  for k in d.knowhow { block(below: 1.4mm, chev(k)) }
}, {
  head("ΣΤΗ ΣΥΝΟΔΕΙΑ", "ON THE ROAD")
  for k in d.operations { block(below: 1.4mm, chev(k)) }
}))

// ---- a baggage-claim stub closes the page: the name and how to reach him ------------
#place(top + left, dx: 60mm, dy: 270mm, rotate(1deg, reflow: false, box(width: 138mm, height: 18mm, {
  place(top + left, rect(width: 138mm, height: 18mm, radius: 1.2mm, fill: col("manila"), stroke: 0.5pt + col("kraft")))
  place(top + left, rect(width: 22mm, height: 18mm, radius: (left: 1.2mm), fill: col("ink")))
  place(top + left, dx: 0mm, dy: 2.4mm, box(width: 22mm, align(center, text(font: cond, size: 20pt, weight: 900, fill: white)[TYO])))
  place(top + left, dx: 0mm, dy: 11.6mm, box(width: 22mm, align(center, text(font: mono, size: 5.2pt, fill: white)[CLAIM 0426])))
  perf-v(18mm, 22mm, 0mm, notch: 1.4, paper: C.paper)
  place(top + left, dx: 26mm, dy: 2.2mm, label("ΑΠΟΔΕΙΞΗ ΑΠΟΣΚΕΥΗΣ / BAGGAGE CLAIM"))
  place(top + left, dx: 26mm, dy: 5.4mm, text(font: cond, size: 15pt, weight: 900)[ΗΛΙΑΔΗΣ / ΜΑΡΚΟΣ])
  place(top + left, dx: 26mm, dy: 12.4mm, text(font: mono, size: 7.4pt)[#d.contact.phone · #d.contact.email])
  place(top + left, dx: 110mm, dy: 3mm, barcode(24, 12, 17))
})))
#place(bottom + right, dx: -3mm, dy: -2.4mm, text(font: mono, size: 5.4pt, fill: col("grey"))[ΦΑΝΤΑΣΤΙΚΟ ΠΡΟΣΩΠΟ · ΣΧΕΔΙΟ CVGEN · 2/2])
