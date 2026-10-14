// Stamp Rally, Creative tier. Idea run 2026-09-29 (magazine-editor).
// The CV as a flat-lay of the escort's papers on a passport cover: the name
// on a giant luggage tag, the photo on a pass stub, the Japan trips on a
// stamp-rally card, the job on a boarding pass, the groups on a thermal
// receipt, the credentials on a rail ticket, and loose stamps over it all.
// Fictional data: sample.json in the style folder.
//
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path design-concepts/fonts design-concepts/2026-09-29-stamp-rally/condensed/creative/condensed-creative.typ design-concepts/2026-09-29-stamp-rally/condensed/creative/condensed-creative.pdf

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
#let C = C + (burg: "4a1624", burglt: "6b2638", ticket: "f6e3cf", ticketdk: "e7b98f")
#set page(paper: "a4", margin: 0mm, fill: rgb(C.burg))
#set text(font: body, size: 8.2pt, fill: col("ink"), lang: "el")
#set par(leading: 0.5em, spacing: 0.7em)

// the passport cover under everything: a faint embossed guilloche
#place(top + left, svg(guilloche(210, 297, C.burglt, n: 60, amp: 3.2, op: 0.9), "0 0 210 297", 210mm))

#let item(x, y, rot, body) = place(top + left, dx: x, dy: y, rotate(rot, reflow: false, body))
#let shadow(w, h, r: 1.5mm) = rect(width: w, height: h, radius: r, fill: rgb(0, 0, 0, 55), stroke: none)

// ---- A. the luggage tag: who he is --------------------------------------------
#let tag = box(width: 158mm, height: 88mm, {
  place(top + left, dx: 1.6mm, dy: 2mm, svg("<path d='M18,0 L158,0 L158,88 L18,88 L0,62 L0,26 Z' fill='#000' fill-opacity='0.28'/>", "0 0 158 88", 158mm))
  place(top + left, svg("<path d='M18,0 L158,0 L158,88 L18,88 L0,62 L0,26 Z' fill='#" + C.manila + "' stroke='#" + C.kraft + "' stroke-width='0.6'/><path d='M18,0 L158,0 L158,12 L8.2,12 Z' fill='#" + C.crimson + "'/><circle cx='11' cy='44' r='5' fill='#" + C.burg + "' stroke='#" + C.kraft + "' stroke-width='2.6'/>", "0 0 158 88", 158mm))
  place(top + left, dx: 22mm, dy: 2.6mm, text(fill: white, font: cond, size: 13pt, weight: 800, tracking: 0.14em)[ΑΡΧΗΓΟΣ ΟΜΑΔΑΣ #h(2mm) #text(font: mono, size: 6.4pt, weight: 400, tracking: 0em)[GROUP LEADER · ATH → TYO]])
  place(top + left, dx: 21mm, dy: 14mm, block(width: 134mm, {
    set par(leading: 0.1em)
    text(font: cond, size: 58pt, weight: 900, top-edge: "cap-height", d.name.caps.split(" ").first())
    linebreak()
    text(font: cond, size: 58pt, weight: 900, top-edge: "cap-height", d.name.caps.split(" ").last())
  }))
  place(top + left, dx: 22mm, dy: 55mm, block(width: 116mm, {
    set par(leading: 0.42em)
    text(font: cond, size: 14pt, weight: 800, d.title.caps)
    h(2mm)
    text(font: cond, size: 14pt, weight: 800, fill: col("crimson"))[ΙΑΠΩΝΙΑ #text(font: jp, size: 10pt, weight: 700)[日本]]
    linebreak()
    text(size: 7.8pt, d.profile)
  }))
  place(top + left, dx: 22mm, dy: 81mm, text(font: mono, size: 7pt, weight: 700)[#d.contact.city · #d.contact.phone · #d.contact.email])
})
// the string runs off the page
#place(top + left, svg("<path d='M0,40 C10,28 16,52 25,46' fill='none' stroke='#" + C.manila + "' stroke-width='0.9'/>", "0 0 30 60", 30mm))
#item(6mm, 12mm, -5deg, tag)

// ---- B. photo stub ---------------------------------------------------------------
#let stub = box(width: 46mm, height: 70mm, {
  place(top + left, dx: 1.4mm, dy: 1.8mm, shadow(46mm, 70mm))
  place(top + left, rect(width: 46mm, height: 70mm, radius: 1.5mm, fill: col("stock"), stroke: 0.5pt + col("ink")))
  place(top + left, rect(width: 46mm, height: 8mm, radius: (top: 1.5mm), fill: col("ink")))
  place(top + left, dx: 0mm, dy: 1.8mm, box(width: 46mm, align(center, text(font: cond, size: 11pt, weight: 800, tracking: 0.14em, fill: white)[ΑΡΧΗΓΟΣ])))
  place(top + left, dx: 5.5mm, dy: 11mm, box(stroke: 0.5pt + col("ink"), inset: 1pt, fill: white, box(clip: true, width: 33mm, height: 40mm, image("../../portrait.jpg", width: 40mm))))
  place(top + left, dx: 5mm, dy: 55mm, text(font: mono, size: 6pt, weight: 700)[ΗΛΙΑΔΗΣ/ΜΑΡΚΟΣ])
  place(top + left, dx: 5mm, dy: 59mm, barcode(36, 8, 4))
})
#item(152mm, 6mm, 7deg, stub)

// ---- C. the stamp-rally card ---------------------------------------------------
#let inks = ("crimson", "violet", "green", "violet", "crimson")
#let kinds = ("torii", "study", "maple", "snow", "flag")
#let card = box(width: 192mm, height: 66mm, {
  place(top + left, dx: 1.4mm, dy: 1.8mm, shadow(192mm, 66mm))
  place(top + left, rect(width: 192mm, height: 66mm, radius: 2mm, fill: col("stock"), stroke: 0.5pt + col("ink")))
  place(top + left, rect(width: 192mm, height: 9mm, radius: (top: 2mm), fill: col("tint")))
  place(top + left, dx: 5mm, dy: 1.8mm, {
    text(font: cond, size: 13pt, weight: 800, tracking: 0.1em)[ΚΑΡΤΑ ΣΦΡΑΓΙΔΩΝ · ΙΑΠΩΝΙΑ]
    h(3mm)
    text(font: jp, size: 9pt, weight: 700)[スタンプラリー]
    h(3mm)
    text(font: mono, size: 6.4pt, fill: col("grey"))[#trips.len() ΤΑΞΙΔΙΑ · #jdays ΗΜΕΡΕΣ · #trips.first().year–#trips.last().year]
  })
  for (i, t) in trips.enumerate() {
    let x = 4mm + i * 37.6mm
    place(top + left, dx: x + 2mm, dy: 11mm, stamp(31, inks.at(i), caps(t.places.join(" · ")) + " · " + str(t.year) + " · ", t.kanji, kinds.at(i), rot: (-9deg, 6deg, -4deg, 11deg, -7deg).at(i), seed: 20 + i))
    place(top + left, dx: x, dy: 43.5mm, block(width: 35mm, {
      set par(leading: 0.34em)
      text(font: cond, size: 11.5pt, weight: 800, t.when)
      h(1fr)
      text(font: cond, size: 11.5pt, weight: 900, fill: col(inks.at(i)), str(t.days) + " ΗΜ.")
      linebreak()
      text(size: 6.8pt, t.places.join(", "))
      linebreak()
      text(font: cond, size: 8.6pt, weight: 800, tracking: 0.05em, fill: (if t.kind == "colead" { col("crimson") } else { col("grey") }), caps(t.kind_el))
    }))
  }
})
#item(9mm, 104mm, 1.6deg, card)

// ---- D. boarding pass: the job ---------------------------------------------------
#let pass = box(width: 124mm, height: 60mm, {
  place(top + left, dx: 1.4mm, dy: 1.8mm, shadow(124mm, 60mm))
  place(top + left, rect(width: 124mm, height: 60mm, radius: 2mm, fill: col("stock"), stroke: 0.5pt + col("ink")))
  place(top + left, dx: 1mm, dy: 9mm, svg(guilloche(122, 50, C.tint, n: 16, amp: 1.5, op: 0.8), "0 0 122 50", 122mm))
  place(top + left, rect(width: 124mm, height: 8mm, radius: (top: 2mm), fill: col("ink")))
  place(top + left, dx: 4mm, dy: 1.7mm, text(fill: white, font: cond, size: 11pt, weight: 800, tracking: 0.12em)[ΕΜΠΕΙΡΙΑ #h(2mm) #text(font: mono, size: 6pt, weight: 400, tracking: 0em)[EXPERIENCE · ΤΩΡΑ ΚΑΙ ΠΡΙΝ]])
  place(top + left, dx: 5mm, dy: 11mm, block(width: 114mm, {
    set par(leading: 0.42em)
    for (j, e) in d.experience.enumerate() {
      block(below: 1.8mm, {
        grid(columns: (1fr, auto), text(size: 8.8pt, weight: 700, e.role), text(font: mono, size: 6.8pt, weight: 700, fill: col("crimson"), e.from + "–" + e.to))
        text(font: cond, size: 10pt, weight: 700, fill: col("violet"), e.company + " · " + caps(e.city))
        linebreak()
        set text(size: 7.6pt)
        for p in e.points.slice(0, calc.min(3, e.points.len())) [#grid(columns: (3mm, 1fr), text(fill: col("crimson"), "›"), p)]
      })
    }
  }))
})
#item(6mm, 176mm, -2.4deg, pass)

// ---- E. thermal receipt: the manifest and the know-how ---------------------------
#let receipt = box(width: 64mm, height: 116mm, {
  place(top + left, dx: 1.4mm, dy: 1.8mm, shadow(64mm, 116mm, r: 0mm))
  place(top + left, svg({
    let s = "<path d='M0,0 "
    for i in range(0, 17) { s += "L" + f(i * 4 + 2) + ",2 L" + f(i * 4 + 4) + ",0 " }
    s += "L64,116 "
    for i in range(0, 16) { s += "L" + f(64 - i * 4 - 2) + ",114 L" + f(64 - i * 4 - 4) + ",116 " }
    s + "Z' fill='#ffffff'/>"
  }, "0 0 64 116", 64mm))
  place(top + left, dx: 4mm, dy: 5mm, block(width: 56mm, {
    set text(font: mono, size: 6.6pt)
    set par(leading: 0.46em)
    align(center, text(size: 7.4pt, weight: 700)[ΛΙΣΤΑ ΕΠΙΒΑΤΩΝ \ MANIFEST])
    v(-1mm)
    line(length: 100%, stroke: (paint: col("ink"), thickness: 0.5pt, dash: (1.5pt, 1.2pt)))
    for g in d.groups {
      grid(columns: (13mm, 30mm, 8mm), g.date, (if g.japan { text(weight: 700)[ΙΑΠΩΝΙΑ\*] } else { caps(g.short) }), align(right, str(g.pax)))
    }
    line(length: 100%, stroke: (paint: col("ink"), thickness: 0.5pt, dash: (1.5pt, 1.2pt)))
    grid(columns: (1fr, auto), text(weight: 700)[#d.groups.len() ΟΜΑΔΕΣ · #d.groups.map(g => g.days).sum() ΗΜ.], text(weight: 700)[#gpax PAX])
    text(size: 5.8pt)[\* συν-αρχηγός · οι υπόλοιπες ως αρχηγός]
    v(1mm)
    align(center, text(size: 7.4pt, weight: 700)[ΣΤΗΝ ΙΑΠΩΝΙΑ])
    v(-1mm)
    line(length: 100%, stroke: (paint: col("ink"), thickness: 0.5pt, dash: (1.5pt, 1.2pt)))
    for k in d.knowhow [› #k \ ]
    v(0.6mm)
    align(center, text(size: 7.4pt, weight: 700)[ΣΤΗ ΣΥΝΟΔΕΙΑ])
    v(-1mm)
    line(length: 100%, stroke: (paint: col("ink"), thickness: 0.5pt, dash: (1.5pt, 1.2pt)))
    for k in d.operations [› #k \ ]
    v(0.6mm)
    align(center, barcode(40, 6, 12))
  }))
})
#item(138mm, 170mm, 1.6deg, receipt)

// ---- F. rail ticket: languages, papers, availability -------------------------------
#let rail = box(width: 126mm, height: 50mm, {
  place(top + left, dx: 1.4mm, dy: 1.8mm, shadow(126mm, 50mm))
  place(top + left, rect(width: 126mm, height: 50mm, radius: 1mm, fill: rgb(C.ticket), stroke: 0.5pt + rgb(C.ticketdk)))
  place(top + left, svg(guilloche(126, 50, C.ticketdk, n: 22, amp: 1.2, op: 0.55), "0 0 126 50", 126mm))
  place(top + left, dx: 4mm, dy: 3mm, text(font: cond, size: 12pt, weight: 800, tracking: 0.1em)[ΓΛΩΣΣΕΣ · ΧΑΡΤΙΑ · ΔΙΑΘΕΣΙΜΟΤΗΤΑ])
  place(top + right, dx: -4mm, dy: 3mm, text(font: jp, size: 9pt, weight: 700)[乗車券])
  place(top + left, dx: 4mm, dy: 10.5mm, grid(columns: (64mm, 1fr), column-gutter: 4mm, {
    set par(leading: 0.44em)
    for l in d.languages { grid(columns: (15mm, 1fr), text(weight: 700, l.name), l.level) }
    v(1mm)
    for e in d.education.slice(0, 2) [#text(weight: 700, e.title) #text(font: mono, size: 6.8pt, fill: col("crimson"), e.years) \ ]
    [#text(weight: 700)[Πρώτες Βοήθειες & ΚΑΡΠΑ] #text(font: mono, size: 6.8pt, fill: col("crimson"))[έως 03/2028]]
  }, {
    set par(leading: 0.44em)
    set text(size: 7.8pt)
    for k in d.availability [› #k \ ]
  }))
})
#item(8mm, 238mm, 2deg, rail)

// ---- G. loose stamps over everything ---------------------------------------------
#place(top + left, dx: 104mm, dy: 30mm, stamp(34, "violet", "ΙΑΠΩΝΙΑ · " + str(trips.len()) + " ΤΑΞΙΔΙΑ · " + str(jdays) + " ΗΜΕΡΕΣ · ", "日本", "fuji", rot: -16deg, seed: 5, op: 0.85))
#place(top + left, dx: 96mm, dy: 229mm, rstamp(32, "green", (text(size: 7pt)[ΠΡΩΤΕΣ ΒΟΗΘΕΙΕΣ · ΚΑΡΠΑ], text(size: 12pt)[ΕΓΚΥΡΟ], text(size: 7pt)[ΕΩΣ 03/2028]), rot: -9deg))
#place(top + left, dx: 66mm, dy: 275.5mm, rstamp(56, "crimson", (text(size: 9.6pt)[ΔΩΡΕΑΝ ΒΡΑΔΙΑ ΕΝΗΜΕΡΩΣΗΣ], text(size: 7.6pt, weight: 600)[για την Ιαπωνία στους πελάτες σας]), rot: -4deg, seed: 41))
#place(top + left, dx: 176mm, dy: 60mm, stamp(26, "crimson", "JLPT · N4 · 12/2024 · ", "日本語", "study", rot: 14deg, seed: 61, label-size: 6pt))
#place(bottom + right, dx: -3mm, dy: -1.6mm, text(font: mono, size: 4.8pt, fill: rgb(C.manila))[ΦΑΝΤΑΣΤΙΚΟ ΠΡΟΣΩΠΟ · ΣΧΕΔΙΟ CVGEN])
