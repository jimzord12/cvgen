// Stamp Rally, Creative tier, Spacious density (two pages). Idea run 2026-09-29 (magazine-editor).
// The escort's papers as a flat-lay on a passport cover, over two spreads.
// Page 1: the name on a giant luggage tag, the photo on a pass stub, the
// Japan trips on the stamp-rally card, the jobs on a boarding pass, the
// escort's own stamp. Page 2: the group-leader badge on its lanyard (the
// name again, 添乗員, the emergency phone), the thermal receipt with the
// manifest and the know-how, the rail ticket with the papers, and the offer as
// a postcard under a drawn postage stamp. Fictional data: sample.json.
//
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path design-concepts/fonts design-concepts/2026-09-29-stamp-rally/spacious/creative/spacious-creative.typ design-concepts/2026-09-29-stamp-rally/spacious/creative/spacious-creative.pdf

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
#set text(size: 10pt)
#set par(leading: 0.55em, spacing: 0.75em)

#let cover = svg(guilloche(210, 297, C.burglt, n: 60, amp: 3.2, op: 0.9), "0 0 210 297", 210mm)
#let item(x, y, rot, body) = place(top + left, dx: x, dy: y, rotate(rot, reflow: false, body))
#let shadow(w, h, r: 1.5mm) = rect(width: w, height: h, radius: r, fill: rgb(0, 0, 0, 55), stroke: none)
#let chev(body) = grid(columns: (3.4mm, 1fr), text(fill: col("crimson"), "›"), body)
#let inks = ("crimson", "violet", "green", "violet", "crimson")
#let kinds = ("torii", "study", "maple", "snow", "flag")

// =========================== PAGE 1 ===========================
#place(top + left, cover)

// ---- A. the luggage tag: who he is ---------------------------------------------------
#let tag = box(width: 168mm, height: 106mm, {
  let shape = "M20,0 L168,0 L168,106 L20,106 L0,78 L0,28 Z"
  place(top + left, dx: 1.8mm, dy: 2.2mm, svg("<path d='" + shape + "' fill='#000' fill-opacity='0.28'/>", "0 0 168 106", 168mm))
  place(top + left, svg("<path d='" + shape + "' fill='#" + C.manila + "' stroke='#" + C.kraft + "' stroke-width='0.6'/><path d='M20,0 L168,0 L168,14 L10,14 Z' fill='#" + C.crimson + "'/><circle cx='12' cy='51' r='5.6' fill='#" + C.burg + "' stroke='#" + C.kraft + "' stroke-width='2.8'/>", "0 0 168 106", 168mm))
  place(top + left, dx: 24mm, dy: 3.2mm, text(fill: white, font: cond, size: 15pt, weight: 800, tracking: 0.14em)[ΑΡΧΗΓΟΣ ΟΜΑΔΑΣ #h(2mm) #text(font: mono, size: 7.4pt, weight: 400, tracking: 0em)[GROUP LEADER · ATH → TYO]])
  place(top + left, dx: 23mm, dy: 17mm, block(width: 142mm, {
    set par(leading: 0.1em)
    text(font: cond, size: 62pt, weight: 900, top-edge: "cap-height", d.name.caps.split(" ").first())
    linebreak()
    text(font: cond, size: 62pt, weight: 900, top-edge: "cap-height", d.name.caps.split(" ").last())
  }))
  place(top + left, dx: 24mm, dy: 59mm, block(width: 116mm, {
    set par(leading: 0.46em)
    text(font: cond, size: 16pt, weight: 800, d.title.caps)
    h(2.4mm)
    text(font: cond, size: 16pt, weight: 800, fill: col("crimson"))[ΙΑΠΩΝΙΑ #text(font: jp, size: 11.5pt, weight: 700)[日本]]
    linebreak()
    text(size: 9.8pt, d.profile)
  }))
  place(top + left, dx: 24mm, dy: 99mm, text(font: mono, size: 7.8pt, weight: 700)[#d.contact.city · #d.contact.phone · #d.contact.email])
})
#place(top + left, svg("<path d='M0,46 C10,32 17,58 27,52' fill='none' stroke='#" + C.manila + "' stroke-width='0.9'/>", "0 0 30 64", 30mm))
#item(5mm, 12mm, -4.5deg, tag)

// ---- B. photo stub -------------------------------------------------------------------
#let stub = box(width: 50mm, height: 76mm, {
  place(top + left, dx: 1.4mm, dy: 1.8mm, shadow(50mm, 76mm))
  place(top + left, rect(width: 50mm, height: 76mm, radius: 1.5mm, fill: col("stock"), stroke: 0.5pt + col("ink")))
  place(top + left, rect(width: 50mm, height: 9mm, radius: (top: 1.5mm), fill: col("ink")))
  place(top + left, dy: 2mm, box(width: 50mm, align(center, text(font: cond, size: 12.5pt, weight: 800, tracking: 0.14em, fill: white)[ΑΡΧΗΓΟΣ])))
  place(top + left, dx: 6mm, dy: 12mm, box(stroke: 0.5pt + col("ink"), inset: 1pt, fill: white, box(clip: true, width: 36mm, height: 44mm, image("../../portrait.jpg", width: 44mm))))
  place(top + left, dx: 5.5mm, dy: 60mm, text(font: mono, size: 6.8pt, weight: 700)[ΗΛΙΑΔΗΣ/ΜΑΡΚΟΣ])
  place(top + left, dx: 5.5mm, dy: 64.5mm, barcode(39, 8, 4))
})
#item(151mm, 5mm, 7deg, stub)

// ---- C. the stamp-rally card ---------------------------------------------------------
#let card = box(width: 194mm, height: 84mm, {
  place(top + left, dx: 1.4mm, dy: 1.8mm, shadow(194mm, 84mm))
  place(top + left, rect(width: 194mm, height: 84mm, radius: 2mm, fill: col("stock"), stroke: 0.5pt + col("ink")))
  place(top + left, rect(width: 194mm, height: 10.5mm, radius: (top: 2mm), fill: col("tint")))
  place(top + left, dx: 5mm, dy: 2.2mm, {
    text(font: cond, size: 15pt, weight: 800, tracking: 0.1em)[ΚΑΡΤΑ ΣΦΡΑΓΙΔΩΝ · ΙΑΠΩΝΙΑ]
    h(3mm)
    text(font: jp, size: 10.5pt, weight: 700)[スタンプラリー]
    h(3mm)
    text(font: mono, size: 7.4pt, fill: col("grey"))[#trips.len() ΤΑΞΙΔΙΑ · #jdays ΗΜΕΡΕΣ · #trips.first().year–#trips.last().year]
  })
  for (i, t) in trips.enumerate() {
    let x = 4mm + i * 37.8mm
    place(top + left, dx: x + 1mm, dy: 13mm, stamp(34, inks.at(i), caps(t.places.join(" · ")) + " · " + str(t.year) + " · ", t.kanji, kinds.at(i), rot: (-9deg, 6deg, -4deg, 11deg, -7deg).at(i), seed: 20 + i))
    place(top + left, dx: x, dy: 50mm, block(width: 36mm, {
      set par(leading: 0.4em)
      text(font: cond, size: 14pt, weight: 800, t.when)
      linebreak()
      text(font: cond, size: 13pt, weight: 900, fill: col(inks.at(i)), str(t.days) + " ΗΜ.")
      h(1.4mm)
      text(font: cond, size: 10.2pt, weight: 800, tracking: 0.04em, fill: (if t.kind == "colead" { col("crimson") } else { col("grey") }), caps(t.kind_el))
      linebreak()
      text(size: 8.8pt, t.places.join(", "))
    }))
  }
})
#item(8mm, 124mm, 1.4deg, card)

// ---- D. boarding pass: the jobs ------------------------------------------------------
#let pass = box(width: 142mm, height: 76mm, {
  place(top + left, dx: 1.4mm, dy: 1.8mm, shadow(142mm, 76mm))
  place(top + left, rect(width: 142mm, height: 76mm, radius: 2mm, fill: col("stock"), stroke: 0.5pt + col("ink")))
  place(top + left, dx: 1mm, dy: 10mm, svg(guilloche(140, 64, C.tint, n: 18, amp: 1.5, op: 0.8), "0 0 140 64", 140mm))
  place(top + left, rect(width: 142mm, height: 9.4mm, radius: (top: 2mm), fill: col("ink")))
  place(top + left, dx: 5mm, dy: 2.2mm, text(fill: white, font: cond, size: 13pt, weight: 800, tracking: 0.12em)[ΕΜΠΕΙΡΙΑ #h(2mm) #text(font: mono, size: 7pt, weight: 400, tracking: 0em)[EXPERIENCE · ΤΩΡΑ ΚΑΙ ΠΡΙΝ]])
  place(top + left, dx: 5.5mm, dy: 12.4mm, block(width: 131mm, {
    set par(leading: 0.46em)
    for e in d.experience {
      block(below: 2.4mm, {
        text(size: 10.4pt, weight: 700, e.role)
        linebreak()
        text(font: cond, size: 12pt, weight: 700, fill: col("violet"), e.company + " · " + caps(e.city))
        h(1fr)
        text(font: mono, size: 7.8pt, weight: 700, fill: col("crimson"), e.from + "–" + e.to)
        linebreak()
        set text(size: 9.4pt)
        for p in e.points { block(below: 1mm, chev(p)) }
      })
    }
  }))
})
#item(6mm, 214.5mm, -2.2deg, pass)

// ---- E. loose stamps -------------------------------------------------------------------
#place(top + left, dx: 106mm, dy: 25mm, stamp(40, "violet", "ΙΑΠΩΝΙΑ · " + str(trips.len()) + " ΤΑΞΙΔΙΑ · " + str(jdays) + " ΗΜΕΡΕΣ · ", "日本", "fuji", rot: -16deg, seed: 5, op: 0.85))
#place(top + left, dx: 154mm, dy: 214mm, stamp(46, "crimson", "ΑΡΧΗΓΟΣ ΟΜΑΔΑΣ · " + str(d.groups.len()) + " ΟΜΑΔΕΣ · " + str(gpax) + " ΤΑΞΙΔΙΩΤΕΣ · ", "添乗員", "flag", rot: 12deg, seed: 71, label-size: 9pt))
#place(top + left, dx: 158mm, dy: 262mm, rstamp(36, "green", (text(size: 8pt)[ΠΡΩΤΕΣ ΒΟΗΘΕΙΕΣ · ΚΑΡΠΑ], text(size: 13pt)[ΕΓΚΥΡΟ], text(size: 8pt)[ΕΩΣ 03/2028]), rot: -8deg, seed: 13))
#place(bottom + left, dx: 4mm, dy: -1.6mm, text(font: mono, size: 5.4pt, fill: rgb(C.manila))[ΦΑΝΤΑΣΤΙΚΟ ΠΡΟΣΩΠΟ · ΣΧΕΔΙΟ CVGEN · 1/2])

#pagebreak()

// =========================== PAGE 2 ===========================
#place(top + left, cover)

// ---- F. the group-leader badge on its lanyard -------------------------------------------
#let badge = box(width: 76mm, height: 142mm, {
  // strap and clip
  place(top + left, dx: 31mm, rect(width: 14mm, height: 34mm, fill: col("crimson")))
  place(top + left, dx: 36.4mm, dy: 7mm, rotate(90deg, reflow: false, origin: top + left, box(width: 24mm, text(font: cond, size: 8pt, weight: 800, tracking: 0.12em, fill: white)[ΑΡΧΗΓΟΣ · 添乗員])))
  place(top + left, dx: 33.5mm, dy: 31mm, rect(width: 9mm, height: 6mm, radius: 1.2mm, fill: rgb("a7a39b"), stroke: 0.5pt + rgb("6f6b64")))
  place(top + left, dx: 36mm, dy: 35mm, rect(width: 4mm, height: 5mm, radius: 1mm, fill: none, stroke: 1.1pt + rgb("6f6b64")))
  // the card in its sleeve
  place(top + left, dx: 1.6mm, dy: 41.6mm, shadow(74mm, 100mm, r: 3mm))
  place(top + left, dy: 39.4mm, rect(width: 76mm, height: 102mm, radius: 3.4mm, fill: rgb(255, 255, 255, 60), stroke: 0.6pt + rgb("d9d4c8")))
  place(top + left, dx: 2.4mm, dy: 44mm, box(width: 71.2mm, height: 95mm, radius: 2.4mm, clip: true, fill: col("stock"), {
    place(top + left, rect(width: 71.2mm, height: 26mm, fill: col("crimson")))
    place(top + left, dx: 4mm, dy: 3.4mm, block(width: 44mm, {
      set par(leading: 0.34em)
      text(font: cond, size: 17pt, weight: 900, fill: white, tracking: 0.04em)[ΑΡΧΗΓΟΣ ΟΜΑΔΑΣ]
      linebreak()
      text(font: mono, size: 6.6pt, fill: white)[GROUP LEADER]
      linebreak()
      text(font: jp, size: 13pt, weight: 700, fill: white)[添乗員]
    }))
    place(top + left, dx: 47mm, dy: 1.6mm, svg(art("flag", "ffffff"), "0 0 40 40", 22mm))
    place(top + left, dx: 4.4mm, dy: 30mm, block(width: 64mm, {
      set par(leading: 0.1em)
      text(font: cond, size: 34pt, weight: 900, top-edge: "cap-height", d.name.caps.split(" ").first())
      linebreak()
      text(font: cond, size: 34pt, weight: 900, top-edge: "cap-height", d.name.caps.split(" ").last())
    }))
    place(top + left, dx: 4.4mm, dy: 55mm, block(width: 64mm, {
      set par(leading: 0.4em)
      text(font: cond, size: 12pt, weight: 800, d.title.caps)
      linebreak()
      text(font: cond, size: 12pt, weight: 800, fill: col("crimson"))[ΙΑΠΩΝΙΑ #text(font: jp, size: 9pt, weight: 700)[日本]]
    }))
    place(top + left, dx: 4.4mm, dy: 70mm, line(length: 62mm, stroke: (paint: col("ink"), thickness: 0.5pt, dash: (1.5pt, 1.2pt))))
    place(top + left, dx: 4.4mm, dy: 72.5mm, block(width: 64mm, {
      set par(leading: 0.42em)
      label("ΣΕ ΕΚΤΑΚΤΗ ΑΝΑΓΚΗ / EMERGENCY")
      linebreak()
      text(font: mono, size: 10.4pt, weight: 700, d.contact.phone)
      linebreak()
      text(font: mono, size: 7.6pt, d.contact.email)
    }))
    place(top + left, dx: 4.4mm, dy: 88mm, text(font: mono, size: 6.4pt, fill: col("grey"))[JPN 0426 · #gpax PAX · #d.groups.len() ΟΜΑΔΕΣ · 2/2])
  }))
})
#item(10mm, -2mm, -3deg, badge)

// ---- G. thermal receipt: the manifest, the know-how, the duties ---------------------------
#let RW = 76
#let RH = 176
#let receipt = box(width: RW * 1mm, height: RH * 1mm, {
  place(top + left, dx: 1.4mm, dy: 1.8mm, shadow(RW * 1mm, RH * 1mm, r: 0mm))
  place(top + left, svg({
    let s = "<path d='M0,0 "
    for i in range(0, 19) { s += "L" + f(i * 4 + 2) + ",2 L" + f(i * 4 + 4) + ",0 " }
    s += "L" + str(RW) + "," + str(RH) + " "
    for i in range(0, 19) { s += "L" + f(RW - i * 4 - 2) + "," + str(RH - 2) + " L" + f(RW - i * 4 - 4) + "," + str(RH) + " " }
    s + "Z' fill='#ffffff'/>"
  }, "0 0 " + str(RW) + " " + str(RH), RW * 1mm))
  place(top + left, dx: 4.5mm, dy: 6mm, block(width: (RW - 9) * 1mm, {
    set text(font: mono, size: 8.4pt)
    set par(leading: 0.5em)
    let rule = line(length: 100%, stroke: (paint: col("ink"), thickness: 0.5pt, dash: (1.5pt, 1.2pt)))
    align(center, text(size: 9.4pt, weight: 700)[ΛΙΣΤΑ ΕΠΙΒΑΤΩΝ \ MANIFEST])
    v(-1mm)
    rule
    for g in d.groups {
      grid(columns: (15mm, 1fr, 10mm), g.date, (if g.japan { text(weight: 700)[ΙΑΠΩΝΙΑ\*] } else { caps(g.short) }), align(right, str(g.pax)))
    }
    rule
    grid(columns: (1fr, auto), text(weight: 700)[#d.groups.len() ΟΜΑΔΕΣ · #d.groups.map(g => g.days).sum() ΗΜ.], text(weight: 700)[#gpax PAX])
    text(size: 7.2pt)[\* συν-αρχηγός · οι υπόλοιπες ως αρχηγός]
    v(1.6mm)
    align(center, text(size: 9.4pt, weight: 700)[ΣΤΗΝ ΙΑΠΩΝΙΑ])
    v(-1mm)
    rule
    for k in d.knowhow { block(below: 1.2mm, [› #k]) }
    v(1.6mm)
    align(center, text(size: 9.4pt, weight: 700)[ΣΤΗ ΣΥΝΟΔΕΙΑ])
    v(-1mm)
    rule
    for k in d.operations { block(below: 1.2mm, [› #k]) }
    v(2mm)
    align(center, barcode(50, 8, 12))
    align(center, text(size: 7pt)[ΕΥΧΑΡΙΣΤΟΥΜΕ · ありがとう])
  }))
})
#item(122mm, 12mm, 1.8deg, receipt)

// ---- H. rail ticket: languages, papers, availability --------------------------------------
#let rail = box(width: 108mm, height: 72mm, {
  place(top + left, dx: 1.4mm, dy: 1.8mm, shadow(108mm, 72mm))
  place(top + left, rect(width: 108mm, height: 72mm, radius: 1mm, fill: rgb(C.ticket), stroke: 0.5pt + rgb(C.ticketdk)))
  place(top + left, svg(guilloche(108, 72, C.ticketdk, n: 28, amp: 1.2, op: 0.55), "0 0 108 72", 108mm))
  place(top + left, dx: 4.5mm, dy: 3.4mm, text(font: cond, size: 13.5pt, weight: 800, tracking: 0.1em)[ΓΛΩΣΣΕΣ · ΧΑΡΤΙΑ])
  place(top + right, dx: -4.5mm, dy: 3.2mm, text(font: jp, size: 10.5pt, weight: 700)[乗車券])
  place(top + left, dx: 4.5mm, dy: 12mm, block(width: 99mm, {
    set par(leading: 0.46em)
    for l in d.languages { grid(columns: (19mm, 1fr), text(weight: 700, l.name), l.level) }
    v(1.4mm)
    set text(size: 9.4pt)
    for e in d.education [#text(weight: 700, e.title) #h(1fr) #text(font: mono, size: 7.6pt, fill: col("crimson"), e.years) \ ]
    [#text(weight: 700)[Πρώτες Βοήθειες & ΚΑΡΠΑ/AED] #h(1fr) #text(font: mono, size: 7.6pt, fill: col("crimson"))[έως 03/2028] \ ]
    v(1mm)
    text(font: cond, size: 11pt, weight: 800, fill: col("crimson"))[ΔΙΑΘΕΣΙΜΟΣ]
    h(1.4mm)
    d.availability.join(" · ")
  }))
})
#item(8mm, 147mm, 2deg, rail)

// ---- I. the offer as a postcard under a drawn postage stamp --------------------------------
#let postage = {
  let s = "<rect width='30' height='36' fill='#ffffff'/>"
  for i in range(0, 16) { s += "<circle cx='" + f(i * 2) + "' cy='0' r='0.75' fill='#" + C.burg + "'/><circle cx='" + f(i * 2) + "' cy='36' r='0.75' fill='#" + C.burg + "'/>" }
  for j in range(0, 19) { s += "<circle cx='0' cy='" + f(j * 2) + "' r='0.75' fill='#" + C.burg + "'/><circle cx='30' cy='" + f(j * 2) + "' r='0.75' fill='#" + C.burg + "'/>" }
  s += "<rect x='2.6' y='2.6' width='24.8' height='30.8' fill='#" + C.tint + "'/>"
  s += "<circle cx='20' cy='11' r='4.4' fill='#" + C.crimson + "'/>"
  s += "<path d='M2.6,30 Q10,26 13,15 L17,15 Q20,26 27.4,30 L27.4,33.4 L2.6,33.4 Z' fill='#" + C.violet + "'/><path d='M12.2,18 L13,15 L17,15 L17.8,18 L16.4,17.2 L15,19 L13.8,17.2 Z' fill='#ffffff'/>"
  s += "<path d='M2.6,31 q2,-1.4 4,0 q2,-1.4 4,0 q2,-1.4 4,0 q2,-1.4 4,0 q2,-1.4 4,0 q2,-1.4 4,0' fill='none' stroke='#ffffff' stroke-width='0.5'/>"
  svg(s, "0 0 30 36", 26mm)
}
#let postcard = box(width: 128mm, height: 74mm, {
  place(top + left, dx: 1.6mm, dy: 2mm, shadow(128mm, 74mm, r: 1mm))
  place(top + left, rect(width: 128mm, height: 74mm, radius: 1mm, fill: col("stock"), stroke: 0.5pt + col("kraft")))
  place(top + left, dx: 76mm, dy: 22mm, line(start: (0mm, 0mm), end: (0mm, 46mm), stroke: 0.5pt + col("rule")))
  place(top + left, dx: 5mm, dy: 4.6mm, label("ΠΡΟΣΚΛΗΣΗ / INVITATION · ΤΑΧΥΔΡΟΜΙΚΟ ΔΕΛΤΑΡΙΟ"))
  place(top + left, dx: 5mm, dy: 11mm, block(width: 68mm, {
    set par(leading: 0.42em)
    text(font: cond, size: 25pt, weight: 900, fill: col("crimson"))[ΔΩΡΕΑΝ ΒΡΑΔΙΑ ΕΝΗΜΕΡΩΣΗΣ]
    v(1.4mm)
    text(size: 10.6pt)[για την Ιαπωνία, στους πελάτες σας, πριν την αναχώρηση.]
    v(1.4mm)
    text(size: 9.4pt, style: "italic")[Ώρα, χώρος και ερωτήσεις: όπως τα θέλει το γραφείο σας.]
  }))
  place(top + left, dx: 5mm, dy: 63mm, text(font: mono, size: 7.4pt, weight: 700)[— Μ. ΗΛΙΑΔΗΣ, ΑΡΧΗΓΟΣ-ΣΥΝΟΔΟΣ])
  place(top + left, dx: 96mm, dy: 5mm, postage)
  place(top + left, dx: 81mm, dy: 41mm, block(width: 42mm, {
    set text(font: mono, size: 8pt)
    set par(leading: 0.9em)
    [ΠΡΟΣ: #h(1mm) το γραφείο σας \ #line(length: 100%, stroke: 0.4pt + col("rule")) \ #line(length: 100%, stroke: 0.4pt + col("rule")) \ ΑΘΗΝΑ → ΤΟΚΙΟ]
  }))
  // postmark: rings and wavy cancellation lines over the stamp's corner
  place(top + left, dx: 78mm, dy: 4mm, stamp(22, "ink", "ΑΘΗΝΑ · 2026 · ", "郵便", "plane", rot: -10deg, seed: 81, label-size: 5.4pt))
  place(top + left, dx: 96mm, dy: 12mm, svg("<g fill='none' stroke='#" + C.ink + "' stroke-width='0.5' stroke-opacity='0.85'><path d='M0,2 q4,-2 8,0 q4,2 8,0 q4,-2 8,0 q4,2 8,0'/><path d='M0,6 q4,-2 8,0 q4,2 8,0 q4,-2 8,0 q4,2 8,0'/><path d='M0,10 q4,-2 8,0 q4,2 8,0 q4,-2 8,0 q4,2 8,0'/></g>", "0 0 32 12", 30mm))
})
#item(62mm, 210mm, -3deg, postcard)

// ---- J. loose stamps ----------------------------------------------------------------------
#place(top + left, dx: 12mm, dy: 232mm, stamp(40, "violet", "ΑΘΗΝΑ · ΤΟΚΙΟ · ΟΜΑΔΙΚΕΣ ΑΝΑΧΩΡΗΣΕΙΣ · ", "出発", "plane", rot: 14deg, seed: 91, label-size: 9pt))
#place(top + left, dx: 89mm, dy: 98mm, stamp(30, "green", "JLPT · N4 · 12/2024 · ", "日本語", "study", rot: -12deg, seed: 61, label-size: 7pt))
#place(bottom + left, dx: 4mm, dy: -1.6mm, text(font: mono, size: 5.4pt, fill: rgb(C.manila))[ΦΑΝΤΑΣΤΙΚΟ ΠΡΟΣΩΠΟ · ΣΧΕΔΙΟ CVGEN · 2/2])
