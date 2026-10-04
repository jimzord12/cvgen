// Concourse, Creative tier, Spacious density (two pages). Idea run 2026-09-29 (magazine-editor).
// Page 1 is the concourse: a hanging sign with a giant arrow to 日本, the name
// board at poster size with the portrait in a station clock, the LED
// departure board, the profile as a station announcement, the contacts on the
// direction strip. Page 2 is the platform: a hanging sign with a giant
// platform number and the name, white information plates under black
// wayfinding headers with yellow arrows, and the yellow meeting-point sign.
// Tactile paving down the left edge of both pages. Fictional data: sample.json.
//
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path design-concepts/fonts design-concepts/2026-09-29-concourse/spacious/creative/spacious-creative.typ design-concepts/2026-09-29-concourse/spacious/creative/spacious-creative.pdf

#let d = json("../../sample.json")

// ---- palette: sign black, sign white, tactile yellow, three line colours, LED -
#let C = (
  sign: "24272b", wall: "1b1d20", white: "ffffff", page: "f3f3f0", grey: "8a8f96", rule: "d5d7da",
  yellow: "f5c400", orange: "ee7219", green: "1f9a58", red: "e0463b",
  led: "0b0b0c", amber: "ffae1a", ledgreen: "3fd67f", ledred: "ff5a48",
)
#let col(k) = rgb(C.at(k))
#let sans = "Fira Sans"
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

// ---- pictograms: one ink, drawn in a 40 x 40 box ----------------------------
#let person(x, y, k, s: 1, arm: "down") = {
  let st(w) = " stroke='#" + k + "' stroke-width='" + f(w) + "' stroke-linecap='round' fill='none'"
  let o = "<g transform='translate(" + f(x) + "," + f(y) + ") scale(" + f(s) + ")'>"
  o += "<circle cx='0' cy='-25.5' r='3.4' fill='#" + k + "'/>"
  o += "<line x1='0' y1='-19.5' x2='0' y2='-9'" + st(6) + "/>"
  o += "<line x1='-1' y1='-8' x2='-3.4' y2='3.2'" + st(4.4) + "/><line x1='1' y1='-8' x2='3.4' y2='3.2'" + st(4.4) + "/>"
  if arm == "flag" {
    o += "<line x1='-1.5' y1='-17.5' x2='-5.5' y2='-9.5'" + st(3.2) + "/><line x1='1.5' y1='-18' x2='6' y2='-24'" + st(3.2) + "/>"
    o += "<line x1='6.4' y1='-17' x2='6.4' y2='-38'" + st(1.6) + "/><path d='M6.4,-38 L17,-34.4 L6.4,-30.8 Z' fill='#" + k + "'/>"
  } else {
    o += "<line x1='-1.5' y1='-17.5' x2='-5' y2='-9'" + st(3.2) + "/><line x1='1.5' y1='-17.5' x2='5' y2='-9'" + st(3.2) + "/>"
  }
  o + "</g>"
}
#let picto(kind, k) = {
  let st(w) = " stroke='#" + k + "' stroke-width='" + f(w) + "' stroke-linecap='round' stroke-linejoin='round' fill='none'"
  let fl = " fill='#" + k + "'"
  if kind == "escort" {
    person(12, 35, k, s: 0.78) + person(20.5, 35, k, s: 0.78) + person(29, 36.5, k, s: 0.9, arm: "flag")
  } else if kind == "leader" {
    person(18, 37, k, s: 0.92, arm: "flag")
  } else if kind == "train" {
    "<path d='M9,7 Q9,4 13,4 L27,4 Q31,4 31,7 L31,27 Q31,30 27,30 L13,30 Q9,30 9,27 Z'" + fl + "/><rect x='12' y='8' width='16' height='9' rx='1.5' fill='#" + (if k == C.white { C.sign } else { C.white }) + "'/><circle cx='14' cy='24' r='1.8' fill='#" + (if k == C.white { C.sign } else { C.white }) + "'/><circle cx='26' cy='24' r='1.8' fill='#" + (if k == C.white { C.sign } else { C.white }) + "'/><path d='M13,30 L9,37 M27,30 L31,37'" + st(2.4) + "/><line x1='6' y1='37' x2='34' y2='37'" + st(2) + "/>"
  } else if kind == "plane" {
    "<g transform='translate(20,20) rotate(-45) scale(4.4)'><path d='M-3.2,0 L3.4,0 Q4.4,0.3 3.4,0.6 L-3.2,0.6 Z M0.6,0.3 L-1.4,-2.6 L-0.5,-2.6 L2.0,0.3 Z M0.6,0.3 L-1.4,3.0 L-0.5,3.0 L2.0,0.4 Z M-3.2,0.3 L-4.0,-1.3 L-3.4,-1.3 L-2.4,0.3 Z'" + fl + "/></g>"
  } else if kind == "luggage" {
    "<rect x='9' y='12' width='22' height='21' rx='3'" + fl + "/><path d='M15,12 L15,6 L25,6 L25,12'" + st(2.6) + "/><circle cx='13' cy='35.5' r='2'" + fl + "/><circle cx='27' cy='35.5' r='2'" + fl + "/><line x1='16' y1='16' x2='16' y2='29' stroke='#" + (if k == C.white { C.sign } else { C.white }) + "' stroke-width='1.6'/><line x1='24' y1='16' x2='24' y2='29' stroke='#" + (if k == C.white { C.sign } else { C.white }) + "' stroke-width='1.6'/>"
  } else if kind == "onsen" {
    "<path d='M6,22 Q6,35 20,35 Q34,35 34,22'" + st(4) + "/><path d='M13,20 q-3.4,-4 0,-7.5 q3.4,-4 0,-8 M20,20 q-3.4,-4 0,-7.5 q3.4,-4 0,-8 M27,20 q-3.4,-4 0,-7.5 q3.4,-4 0,-8'" + st(3.2) + "/>"
  } else if kind == "card" {
    "<rect x='5' y='10' width='30' height='20' rx='2.6'" + fl + "/><path d='M22,16 q3,4 0,8 M26,14 q4.6,6 0,12 M30,12.5 q5.6,7.5 0,15' fill='none' stroke='#" + (if k == C.white { C.sign } else { C.white }) + "' stroke-width='1.6' stroke-linecap='round'/>"
  } else if kind == "blossom" {
    let s = ""
    for a in (0, 72, 144, 216, 288) {
      s += "<g transform='translate(20,20) rotate(" + str(a) + ")'><path d='M0,-2 C-6,-6 -6,-13 -2.2,-15 L0,-12.6 L2.2,-15 C6,-13 6,-6 0,-2 Z'" + fl + "/></g>"
    }
    s + "<circle cx='20' cy='20' r='2.4' fill='#" + (if k == C.white { C.sign } else { C.white }) + "'/>"
  } else if kind == "crowd" {
    person(10, 36, k, s: 0.7) + person(20, 36, k, s: 0.84) + person(30, 36, k, s: 0.7)
  } else if kind == "aid" {
    "<path d='M15,6 L25,6 L25,15 L34,15 L34,25 L25,25 L25,34 L15,34 L15,25 L6,25 L6,15 L15,15 Z'" + fl + "/>"
  } else if kind == "lang" {
    "<path d='M4,6 L22,6 Q24,6 24,8 L24,19 Q24,21 22,21 L11,21 L6,26 L7,21 L6,21 Q4,21 4,19 Z'" + fl + "/><path d='M18,17 L34,17 Q36,17 36,19 L36,30 Q36,32 34,32 L33,32 L34,37 L28,32 L18,32 Q16,32 16,30 L16,19 Q16,17 18,17 Z' fill='none' stroke='#" + k + "' stroke-width='2'/>"
  } else if kind == "book" {
    "<path d='M5,10 L19,13 L19,34 L5,31 Z M35,10 L21,13 L21,34 L35,31 Z'" + fl + "/>"
  } else if kind == "clock" {
    "<circle cx='20' cy='20' r='14'" + st(3.4) + "/><path d='M20,11 L20,20 L27,24'" + st(3.2) + "/>"
  } else if kind == "count" { let inv = if k == C.white { C.sign } else { C.white }; "<rect x='8' y='7' width='24' height='30' rx='2.2'" + fl + "/><rect x='14' y='3.6' width='12' height='6.4' rx='1.6'" + fl + " stroke='#" + inv + "' stroke-width='1.2'/><path d='M12,17 l2.6,2.6 l4.6,-5 M12,27 l2.6,2.6 l4.6,-5' fill='none' stroke='#" + inv + "' stroke-width='2.2' stroke-linecap='round' stroke-linejoin='round'/><path d='M22,17 L29,17 M22,27 L29,27' stroke='#" + inv + "' stroke-width='2' stroke-linecap='round'/>" } else if kind == "ticket" { let inv = if k == C.white { C.sign } else { C.white }; "<path d='M4,10 L36,10 L36,16.5 Q31.6,20 36,23.5 L36,30 L4,30 L4,23.5 Q8.4,20 4,16.5 Z'" + fl + "/><line x1='26' y1='12.5' x2='26' y2='27.5' stroke='#" + inv + "' stroke-width='1.2' stroke-dasharray='1.6 1.4'/><path d='M9,16 L21,16 M9,20 L19,20 M9,24 L21,24' stroke='#" + inv + "' stroke-width='1.8' stroke-linecap='round'/>" } else if kind == "yen" { let inv = if k == C.white { C.sign } else { C.white }; "<circle cx='20' cy='20' r='15.5'" + fl + "/><path d='M13,10.5 L20,19.5 L27,10.5 M20,19.5 L20,31 M14,21 L26,21 M14,26 L26,26' fill='none' stroke='#" + inv + "' stroke-width='2.6' stroke-linecap='round' stroke-linejoin='round'/>" } else if kind == "bus" { let inv = if k == C.white { C.sign } else { C.white }; "<rect x='6' y='5' width='28' height='27' rx='3.6'" + fl + "/><rect x='9.5' y='9' width='21' height='10' rx='1.4' fill='#" + inv + "'/><circle cx='12.5' cy='26' r='2' fill='#" + inv + "'/><circle cx='27.5' cy='26' r='2' fill='#" + inv + "'/><rect x='9' y='31' width='5' height='5' rx='1'" + fl + "/><rect x='26' y='31' width='5' height='5' rx='1'" + fl + "/>" } else if kind == "speaker" { "<path d='M5,15 L12,15 L21,7 L21,33 L12,25 L5,25 Z'" + fl + "/><path d='M26,14 Q30,20 26,26 M30,10 Q37,20 30,30' fill='none' stroke='#" + k + "' stroke-width='2.6' stroke-linecap='round'/>" } else { "" }
}
// a pictogram tile: ink on a ground, square, small radius
#let tile(kind, size, ground: C.sign, ink: C.white, r: 1.2mm) = box(width: size, height: size, fill: rgb(ground), radius: r, inset: size * 0.1,
  svg(picto(kind, ink), "0 0 40 40", size * 0.8))

// ---- tactile paving: guiding bars and warning dots ------------------------------
#let paving(w, h, kind: "bars", unit: 7, ink: C.yellow) = {
  let s = "<rect width='" + f(w) + "' height='" + f(h) + "' fill='#" + ink + "'/>"
  let shade = "d9ab00"
  if kind == "bars" {
    let n = calc.floor(w / unit)
    for i in range(n) {
      for j in range(calc.max(1, calc.floor(h / unit))) {
        let x0 = i * unit
        let y0 = j * unit
        for b in (0.2, 0.47, 0.74) {
          s += "<rect x='" + f(x0 + unit * 0.12) + "' y='" + f(y0 + unit * b) + "' width='" + f(unit * 0.76) + "' height='" + f(unit * 0.12) + "' rx='" + f(unit * 0.06) + "' fill='#" + shade + "'/>"
        }
      }
    }
  } else {
    let n = calc.floor(w / (unit / 4))
    let m = calc.floor(h / (unit / 4))
    for i in range(n) { for j in range(m) {
      s += "<circle cx='" + f((i + 0.5) * unit / 4) + "' cy='" + f((j + 0.5) * unit / 4) + "' r='" + f(unit * 0.075) + "' fill='#" + shade + "'/>"
    } }
  }
  svg(s, "0 0 " + f(w) + " " + f(h), w * 1mm)
}

// ---- LED text: amber light with a dot-matrix mask over it --------------------
#let ledmask = tiling(size: (0.62mm, 0.62mm), {
  place(top + left, rect(width: 0.62mm, height: 0.13mm, fill: rgb(C.led)))
  place(top + left, rect(width: 0.13mm, height: 0.62mm, fill: rgb(C.led)))
})
#let led(body, w, h) = box(width: w, height: h, fill: rgb(C.led), {
  body
  place(top + left, rect(width: w, height: h, fill: ledmask))
})

// train-type style label (colour-coded kind of trip)
#let kind-col = (travel: "ledgreen", study: "amber", colead: "ledred")
#let kind-label(t, w: 22mm) = box(width: w, height: 5.2mm, stroke: 0.8pt + col(kind-col.at(t.kind)), radius: 0.8mm, fill: col(kind-col.at(t.kind)).transparentize(80%),
  align(center + horizon, text(font: sans, size: 7.4pt, weight: 700, fill: col(kind-col.at(t.kind)), caps(t.kind_el.split(" ").first()))))

// station-number badge: line code and number in a rounded square
#let badge(code, num, color, size: 13mm) = box(width: size, height: size, radius: size * 0.22, stroke: (size * 0.12) + col(color), fill: white,
  align(center + horizon, stack(spacing: 0.4mm,
    text(font: sans, size: size * 0.26, weight: 700, fill: col("sign"), code),
    text(font: sans, size: size * 0.4, weight: 900, fill: col("sign"), num))))
#set page(paper: "a4", margin: 0mm, fill: col("wall"))
#set text(font: sans, size: 8.4pt, fill: col("sign"), lang: "el")
#set par(leading: 0.5em, spacing: 0.7em)
#set text(size: 10pt)
#set par(leading: 0.55em, spacing: 0.8em)

// tactile paving down the left edge: warning dots at the top, guiding bars below
#let edge-paving = {
  place(top + left, paving(9, 34, kind: "dots", unit: 9))
  place(top + left, dy: 34mm, {
    let s = "<rect width='9' height='263' fill='#" + C.yellow + "'/>"
    for j in range(0, 29) { for b in (0.2, 0.47, 0.74) {
      s += "<rect x='" + f(9 * b) + "' y='" + f(j * 9 + 1.1) + "' width='1.1' height='6.8' rx='0.55' fill='#d9ab00'/>"
    } }
    svg(s, "0 0 9 263", 9mm)
  })
  place(top + left, dx: 9mm, rect(width: 0.8mm, height: 297mm, fill: rgb("111214")))
}
#let arrow-svg(w, fill: C.yellow, dir: "right") = {
  let p = "M0,14 L34,14 L34,2 L52,20 L34,38 L34,26 L0,26 Z"
  let t = if dir == "left" { "translate(52,0) scale(-1,1)" } else if dir == "up" { "rotate(-90 26 20) translate(6,6)" } else if dir == "down" { "rotate(90 26 20) translate(6,-6)" } else { "" }
  svg("<g transform='" + t + "'><path d='" + p + "' fill='#" + fill + "'/></g>", "0 0 52 40", w)
}
#let rods(xs) = for x in xs { place(top + left, dx: x, dy: 0mm, rect(width: 1.6mm, height: 8mm, fill: rgb("6b7078"))) }

// =========================== PAGE 1 ===========================
#edge-paving
#rods((40mm, 176mm))

// ---- the hanging sign: where this person goes -------------------------------------------
#place(top + left, dx: 16mm, dy: 8mm, box(width: 184mm, height: 52mm, fill: rgb("0f1012"), radius: 1.6mm, stroke: 1pt + rgb("3a3e44"), inset: (x: 6mm), {
  place(left + horizon, text(font: jp, size: 72pt, weight: 700, fill: white)[日本])
  place(left + horizon, dx: 62mm, dy: -4.2mm, block({
    set par(leading: 0.3em)
    text(size: 40pt, weight: 900, fill: white)[ΙΑΠΩΝΙΑ]
    linebreak()
    text(size: 9.6pt, weight: 600, fill: col("grey"), tracking: 0.08em)[JAPAN · ΟΜΑΔΙΚΕΣ ΑΝΑΧΩΡΗΣΕΙΣ]
  }))
  place(right + horizon, arrow-svg(38mm))
}))

// ---- the name board at poster size, the portrait in a station clock --------------------
#let BX = 16mm
#let BY = 67mm
#let BW = 184mm
#let BH = 92mm
#place(top + left, dx: BX - 1.6mm, dy: BY - 1.6mm, rect(width: BW + 3.2mm, height: BH + 3.2mm, radius: 1.8mm, fill: rgb("9aa0a6")))
#place(top + left, dx: BX, dy: BY, rect(width: BW, height: BH, radius: 1mm, fill: white))
#place(top + left, dx: BX + 6mm, dy: BY + 5mm, text(font: jp, size: 14pt, weight: 700, tracking: 0.1em, d.name.kana))
#place(top + left, dx: BX + 5mm, dy: BY + 15mm, block({
  set par(leading: 0.2em)
  text(size: 62pt, weight: 900, tracking: -0.015em, d.name.first)
  linebreak()
  text(size: 62pt, weight: 900, tracking: -0.015em, d.name.last)
}))
#place(top + left, dx: BX + 6mm, dy: BY + 65mm, text(size: 13pt, weight: 500, fill: col("grey"), tracking: 0.05em, d.name.latin))
#place(top + left, dx: BX, dy: BY + 74mm, rect(width: BW, height: 9mm, fill: col("orange")))
#place(top + left, dx: BX + 5mm, dy: BY + 75.8mm, text(size: 11.5pt, weight: 800, fill: white, tracking: 0.08em)[ΑΡΧΗΓΟΣ-ΣΥΝΟΔΟΣ ΕΚΔΡΟΜΩΝ])
#place(top + right, dx: -(210mm - BX - BW) - 5mm, dy: BY + 75.8mm, text(size: 11.5pt, weight: 800, fill: white, tracking: 0.08em)[ΕΞΕΙΔΙΚΕΥΣΗ ΙΑΠΩΝΙΑ #text(font: jp, size: 10.4pt)[日本]])
#place(top + left, dx: BX + 5mm, dy: BY + 85mm, text(size: 8.6pt, fill: col("grey"))[τώρα: #text(weight: 700, fill: col("sign"))[#d.experience.first().role, #d.experience.first().company] #h(1mm) · #d.experience.first().from–])
#let clock = {
  let s = "<circle cx='30' cy='30' r='29' fill='#ffffff' stroke='#" + C.sign + "' stroke-width='2.4'/>"
  for i in range(60) {
    let a = i * 6
    let r1 = if calc.rem(i, 5) == 0 { 23.4 } else { 25.6 }
    let w = if calc.rem(i, 5) == 0 { 1.4 } else { 0.5 }
    s += "<line x1='" + f(30 + r1 * calc.sin(a * 1deg)) + "' y1='" + f(30 - r1 * calc.cos(a * 1deg)) + "' x2='" + f(30 + 27 * calc.sin(a * 1deg)) + "' y2='" + f(30 - 27 * calc.cos(a * 1deg)) + "' stroke='#" + C.sign + "' stroke-width='" + f(w) + "'/>"
  }
  svg(s, "0 0 60 60", 68mm)
}
#place(top + left, dx: 128mm, dy: BY + 2.4mm, clock)
#place(top + left, dx: 136.6mm, dy: BY + 11mm, box(width: 50.8mm, height: 50.8mm, radius: 25.4mm, clip: true, image("../../portrait.jpg", width: 50.8mm)))
#place(top + left, dx: 172mm, dy: BY + 1.6mm, box(fill: col("yellow"), radius: 1mm, inset: (x: 2.2mm, y: 1.4mm), text(size: 8pt, weight: 800)[ΑΡΧΗΓΟΣ ΟΜΑΔΑΣ]))

// ---- the departure board ----------------------------------------------------------------
#let DY = 167mm
#let rowh = 9.6mm
#place(top + left, dx: 16mm, dy: DY, box(width: 184mm, height: 8.8mm, fill: col("sign"), radius: (top: 1mm), inset: (x: 3.4mm), align(horizon, {
  set text(fill: white)
  text(size: 12pt, weight: 800, tracking: 0.06em)[ΑΝΑΧΩΡΗΣΕΙΣ]
  h(2.4mm)
  text(font: jp, size: 10pt, weight: 700)[発車案内]
  h(2.4mm)
  text(size: 7.8pt, fill: col("grey"))[ΟΛΑ ΤΑ ΤΑΞΙΔΙΑ ΤΟΥ ΣΤΗΝ ΙΑΠΩΝΙΑ]
  h(1fr)
  for (k, l) in (("ledgreen", "ΤΑΞΙΔΙ"), ("amber", "ΣΠΟΥΔΕΣ"), ("ledred", "ΣΥΝ-ΑΡΧΗΓΙΑ")) {
    box(width: 2.6mm, height: 2.6mm, fill: col(k), radius: 0.4mm)
    h(0.8mm)
    text(size: 7.2pt, fill: col("grey"), l)
    h(2mm)
  }
})))
#place(top + left, dx: 16mm, dy: DY + 8.8mm, led({
  for (i, t) in trips.enumerate() {
    let c = col(kind-col.at(t.kind))
    place(top + left, dx: 3.4mm, dy: 1.4mm + i * rowh, block(width: 177mm, height: rowh - 1mm, grid(columns: (24mm, 28mm, 1fr, 37mm, 16mm), rows: (rowh - 1mm,), column-gutter: 2mm, align: horizon,
      kind-label(t, w: 24mm),
      text(size: 10.2pt, weight: 700, fill: col("amber"), str(t.year) + " " + caps(t.when.split(" ").first())),
      { set par(leading: 0.4em); text(size: 10.2pt, weight: 700, fill: white, caps(t.places.join(" · "))) },
      text(font: jp, size: 10pt, weight: 700, fill: col("amber"), t.kanji_places.join(" ")),
      align(right, text(size: 11.4pt, weight: 800, fill: c, str(t.days) + " ΗΜ.")),
    )))
  }
  place(top + left, dx: 3.4mm, dy: 2.2mm + 5 * rowh, text(size: 10pt, weight: 700, fill: col("amber"))[ΣΥΝΟΛΟ #h(2mm) #trips.len() ΤΑΞΙΔΙΑ · #jdays ΗΜΕΡΕΣ · JLPT N4 · #d.groups.len() ΟΜΑΔΕΣ, #gpax ΤΑΞΙΔΙΩΤΕΣ ◀])
}, 184mm, 5 * rowh + 9mm))

// ---- the announcement: the profile -------------------------------------------------------
#place(top + left, dx: 16mm, dy: 243mm, block(width: 184mm, fill: white, radius: 1mm, inset: (x: 4mm, y: 3.4mm), {
  grid(columns: (11mm, 1fr), column-gutter: 3.4mm, align: horizon,
    tile("speaker", 11mm, ground: C.yellow, ink: C.sign),
    text(size: 10.4pt, d.profile))
}))

// contacts on the direction strip
#place(bottom + left, dx: 16mm, dy: -3mm, box(width: 184mm, height: 8mm, fill: rgb("2f3338"), radius: 0.8mm, inset: (x: 3.4mm), align(horizon, {
  set text(fill: white, size: 9.6pt)
  text(weight: 700)[#d.contact.city]
  h(1fr); d.contact.phone; h(1fr); d.contact.email; h(1fr); text(fill: col("amber"), d.contact.link)
  h(1fr); text(size: 5.4pt, fill: col("grey"))[Φανταστικό πρόσωπο · σχέδιο CVgen · 1/2]
})))

#pagebreak()

// =========================== PAGE 2 ===========================
#edge-paving
#rods((40mm, 176mm))

// ---- the hanging platform sign: the number of the page and the name ------------------------
#place(top + left, dx: 16mm, dy: 8mm, box(width: 184mm, height: 44mm, fill: rgb("0f1012"), radius: 1.6mm, stroke: 1pt + rgb("3a3e44"), {
  place(top + left, dx: 5mm, dy: 5mm, box(width: 34mm, height: 34mm, fill: col("yellow"), radius: 1.4mm, {
    place(top + left, dy: 2.4mm, box(width: 34mm, align(center, text(font: jp, size: 10pt, weight: 700, fill: col("sign"))[のりば])))
    place(top + left, dy: 8mm, box(width: 34mm, align(center, text(size: 62pt, weight: 900, fill: col("sign"), top-edge: "cap-height", bottom-edge: "baseline")[2])))
  }))
  place(top + left, dx: 46mm, dy: 5mm, text(font: jp, size: 11pt, weight: 700, fill: col("grey"), tracking: 0.08em, d.name.kana))
  place(top + left, dx: 45mm, dy: 10.6mm, text(size: 38pt, weight: 900, fill: white, d.name.el))
  place(top + left, dx: 46mm, dy: 31.6mm, text(size: 10.6pt, weight: 700, fill: col("orange"), tracking: 0.08em)[ΑΡΧΗΓΟΣ-ΣΥΝΟΔΟΣ ΕΚΔΡΟΜΩΝ #h(1mm) #text(fill: col("grey"))[·] #h(1mm) ΕΞΕΙΔΙΚΕΥΣΗ ΙΑΠΩΝΙΑ #text(font: jp, size: 9.6pt)[日本]])
}))

// a white information plate under a black wayfinding header with a yellow arrow
#let plate(title, en, dir, body, w: 100%) = block(width: w, below: 5mm, {
  block(width: 100%, height: 9.4mm, fill: col("sign"), radius: (top: 1mm), inset: (x: 2.6mm), below: 0mm, align(horizon, {
    box(baseline: 0.6mm, arrow-svg(9mm, dir: dir))
    h(2.4mm)
    text(size: 12.5pt, weight: 800, fill: white, title)
    h(2mm)
    text(size: 7.4pt, fill: col("grey"), en)
  }))
  block(width: 100%, fill: white, radius: (bottom: 1mm), inset: (x: 3.6mm, y: 3.2mm), above: 0mm, body)
})
#let arrow-b(body) = grid(columns: (3.6mm, 1fr), text(fill: col("orange"), "▸"), body)

#place(top + left, dx: 16mm, dy: 60mm, block(width: 102mm, {
  plate("Εμπειρία", "EXPERIENCE · 職歴", "left", {
    set par(leading: 0.48em)
    for e in d.experience {
      block(below: 3mm, {
        text(size: 10.6pt, weight: 700, e.role)
        linebreak()
        text(weight: 600, fill: col("grey"), e.company + " · " + e.city)
        h(1fr)
        text(size: 9pt, weight: 700, fill: col("orange"), e.from + "–" + e.to)
        linebreak()
        set text(size: 9.6pt)
        for p in e.points { block(below: 1.2mm, arrow-b(p)) }
      })
    }
  })
  plate("Ομάδες που συνόδευσε", "GROUPS · 団体", "left", {
    set text(size: 9.6pt)
    table(
      columns: (15mm, 1fr, 11mm, 9mm), stroke: none, inset: (x: 0.8mm, y: 1.2mm),
      ..("Πότε", "Προορισμός · ρόλος", "Άτ.", "Ημ.").map(h => text(size: 8pt, weight: 700, fill: col("grey"), h)),
      table.hline(stroke: 0.5pt + col("sign")),
      ..d.groups.map(g => (g.date, (if g.japan { text(weight: 700, fill: col("red"))[Ιαπωνία · συν-αρχηγός] } else { [#g.where · #text(fill: col("grey"))[αρχηγός]] }), str(g.pax), str(g.days))).flatten(),
      table.hline(stroke: 0.5pt + col("sign")),
      [], text(weight: 700)[#d.groups.len() ομάδες], text(weight: 700, str(gpax)), text(weight: 700, str(d.groups.map(g => g.days).sum())),
    )
  })
}))

#place(top + left, dx: 124mm, dy: 60mm, block(width: 76mm, {
  plate("Γλώσσες, χαρτιά", "PAPERS · 資格", "right", {
    set par(leading: 0.46em)
    for l in d.languages { block(below: 1.4mm, grid(columns: (18mm, 1fr), text(weight: 700, l.name), l.level)) }
    v(1.4mm)
    set text(size: 9.4pt)
    block(below: 1.8mm)[#text(weight: 700)[Πρώτες Βοήθειες & ΚΑΡΠΑ/AED] \ #text(fill: col("grey"))[έως 03/2028 · Ερυθρός Σταυρός]]
    for e in d.education { block(below: 1.8mm)[#text(weight: 700, e.title) \ #text(fill: col("grey"))[#e.years · #e.school]] }
  })
  plate("Στη συνοδεία", "ON THE ROAD · 添乗", "right", {
    for (k, t) in ("count", "ticket", "yen", "aid", "bus").zip(d.operations) {
      block(below: 1.8mm, grid(columns: (7.6mm, 1fr), column-gutter: 2.4mm, align: horizon, tile(k, 7.6mm, r: 0.8mm), text(size: 9.6pt, t)))
    }
  })
}))

// the know-how as a pictogram plate across the width
#place(top + left, dx: 16mm, dy: 206mm, block(width: 184mm, {
  plate("Στην Ιαπωνία", "JAPAN KNOW-HOW · 旅の実務", "up", {
    grid(columns: (1fr, 1fr, 1fr), column-gutter: 4mm, row-gutter: 3mm,
      ..("train", "card", "luggage", "onsen", "blossom", "crowd").zip(d.knowhow).map(((k, t)) => grid(columns: (11mm, 1fr), column-gutter: 2.4mm, align: horizon, tile(k, 11mm), text(size: 9.6pt, weight: 500, t))))
  })
}))

// ---- the meeting point: when, and the offer ----------------------------------------------
#place(top + left, dx: 16mm, dy: 257mm, block(width: 184mm, height: 32mm, fill: col("yellow"), radius: 1.6mm, inset: (x: 5mm, y: 3mm), align(horizon, {
  grid(columns: (22mm, 56mm, 1fr), column-gutter: 4mm, align: horizon,
    svg(picto("escort", C.sign), "0 0 40 40", 22mm),
    {
      set par(leading: 0.28em)
      text(font: jp, size: 11pt, weight: 700)[集合場所]
      linebreak()
      text(size: 15pt, weight: 900)[ΣΗΜΕΙΟ ΣΥΝΑΝΤΗΣΗΣ]
      linebreak()
      text(size: 7.6pt, weight: 600)[MEETING POINT]
    },
    {
      set par(leading: 0.42em)
      text(size: 10.6pt, weight: 800, d.offer)
      linebreak()
      text(size: 9.4pt, weight: 500, d.availability.join(" · "))
      linebreak()
      text(size: 9.4pt, weight: 800)[#d.contact.phone · #d.contact.email]
    })
})))
#place(bottom + right, dx: -3mm, dy: -1.8mm, text(size: 5.4pt, fill: col("grey"))[Φανταστικό πρόσωπο · σχέδιο CVgen · 2/2])
