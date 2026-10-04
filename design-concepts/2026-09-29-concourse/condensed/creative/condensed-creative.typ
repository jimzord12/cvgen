// Concourse, Creative tier. Idea run 2026-09-29 (magazine-editor).
// The page is the concourse wall: a hanging sign with a giant arrow to 日本,
// the name board at poster size with the portrait in a station clock, the
// LED departure board, a big yellow meeting-point sign for the escort pitch,
// white information plates, tactile paving down the edge.
// Fictional data: sample.json in the style folder.
//
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path design-concepts/fonts design-concepts/2026-09-29-concourse/condensed/creative/condensed-creative.typ design-concepts/2026-09-29-concourse/condensed/creative/condensed-creative.pdf

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
  } else { "" }
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

// tactile paving down the left edge: warning dots at the top, guiding bars below
#place(top + left, paving(9, 34, kind: "dots", unit: 9))
#place(top + left, dy: 34mm, {
  let s = "<rect width='9' height='263' fill='#" + C.yellow + "'/>"
  for j in range(0, 29) { for b in (0.2, 0.47, 0.74) {
    s += "<rect x='" + f(9 * b) + "' y='" + f(j * 9 + 1.1) + "' width='1.1' height='6.8' rx='0.55' fill='#d9ab00'/>"
  } }
  svg(s, "0 0 9 263", 9mm)
})
#place(top + left, dx: 9mm, rect(width: 0.8mm, height: 297mm, fill: rgb("111214")))

// ---- the hanging sign: where this person goes ----------------------------------
#place(top + left, dx: 16mm, dy: 9mm, box(width: 184mm, height: 46mm, fill: rgb("0f1012"), radius: 1.5mm, stroke: 1pt + rgb("3a3e44"), inset: (x: 6mm), {
  place(left + horizon, text(font: jp, size: 70pt, weight: 700, fill: white)[日本])
  place(left + horizon, dx: 66mm, dy: -4mm, block({
    set par(leading: 0.3em)
    text(size: 38pt, weight: 900, fill: white)[ΙΑΠΩΝΙΑ]
    linebreak()
    text(size: 10pt, weight: 600, fill: col("grey"), tracking: 0.1em)[JAPAN · ΟΜΑΔΙΚΕΣ ΑΝΑΧΩΡΗΣΕΙΣ]
  }))
  place(right + horizon, svg("<path d='M0,14 L34,14 L34,2 L52,20 L34,38 L34,26 L0,26 Z' fill='#" + C.yellow + "'/>", "0 0 52 40", 40mm))
}))

// ---- the name board at poster size, with the portrait in a station clock ------------
#let BX = 16mm
#let BY = 62mm
#place(top + left, dx: BX - 1.4mm, dy: BY - 1.4mm, rect(width: 186.8mm, height: 76.8mm, radius: 1.6mm, fill: rgb("9aa0a6")))
#place(top + left, dx: BX, dy: BY, rect(width: 184mm, height: 74mm, radius: 1mm, fill: white))
#place(top + left, dx: BX + 6mm, dy: BY + 5mm, text(font: jp, size: 13pt, weight: 700, tracking: 0.1em, d.name.kana))
#place(top + left, dx: BX + 5mm, dy: BY + 13.5mm, block({
  set par(leading: 0.22em)
  text(size: 54pt, weight: 900, tracking: -0.015em, d.name.first)
  linebreak()
  text(size: 54pt, weight: 900, tracking: -0.015em, d.name.last)
}))
#place(top + left, dx: BX + 6mm, dy: BY + 56mm, text(size: 11pt, weight: 500, fill: col("grey"), tracking: 0.05em, d.name.latin))
#place(top + left, dx: BX, dy: BY + 62mm, rect(width: 184mm, height: 7mm, fill: col("orange")))
#place(top + left, dx: BX + 5mm, dy: BY + 63.4mm, text(size: 10pt, weight: 800, fill: white, tracking: 0.08em)[ΑΡΧΗΓΟΣ-ΣΥΝΟΔΟΣ ΕΚΔΡΟΜΩΝ])
#place(top + right, dx: -14mm - 5mm, dy: BY + 63.4mm, text(size: 10pt, weight: 800, fill: white, tracking: 0.08em)[ΕΞΕΙΔΙΚΕΥΣΗ ΙΑΠΩΝΙΑ #text(font: jp, size: 9pt)[日本]])
// station clock
#let clock = {
  let s = "<circle cx='30' cy='30' r='29' fill='#ffffff' stroke='#" + C.sign + "' stroke-width='2.4'/>"
  for i in range(60) {
    let a = i * 6
    let r1 = if calc.rem(i, 5) == 0 { 23.4 } else { 25.6 }
    let w = if calc.rem(i, 5) == 0 { 1.4 } else { 0.5 }
    s += "<line x1='" + f(30 + r1 * calc.sin(a * 1deg)) + "' y1='" + f(30 - r1 * calc.cos(a * 1deg)) + "' x2='" + f(30 + 27 * calc.sin(a * 1deg)) + "' y2='" + f(30 - 27 * calc.cos(a * 1deg)) + "' stroke='#" + C.sign + "' stroke-width='" + f(w) + "'/>"
  }
  svg(s, "0 0 60 60", 60mm)
}
#place(top + left, dx: 134mm, dy: BY + 2mm, clock)
#place(top + left, dx: 141.5mm, dy: BY + 9.5mm, box(width: 45mm, height: 45mm, radius: 22.5mm, clip: true, image("../../portrait.jpg", width: 45mm)))
#place(top + left, dx: 134mm + 43mm, dy: BY + 1mm, box(fill: col("yellow"), radius: 1mm, inset: (x: 2mm, y: 1.2mm), text(size: 7pt, weight: 800)[ΑΡΧΗΓΟΣ ΟΜΑΔΑΣ]))

// ---- departure indicator ------------------------------------------------------------
#let DY = 146mm
#let rowh = 7.4mm
#place(top + left, dx: 16mm, dy: DY, box(width: 184mm, height: 7.6mm, fill: col("sign"), radius: (top: 1mm), inset: (x: 3mm), align(horizon, {
  set text(fill: white)
  text(size: 10.5pt, weight: 800, tracking: 0.06em)[ΑΝΑΧΩΡΗΣΕΙΣ]
  h(2mm)
  text(font: jp, size: 9pt, weight: 700)[発車案内]
  h(2mm)
  text(size: 7pt, fill: col("grey"))[ΟΛΑ ΤΑ ΤΑΞΙΔΙΑ ΤΟΥ ΣΤΗΝ ΙΑΠΩΝΙΑ]
})))
#place(top + left, dx: 16mm, dy: DY + 7.6mm, led({
  for (i, t) in trips.enumerate() {
    let c = col(kind-col.at(t.kind))
    place(top + left, dx: 3mm, dy: 1.4mm + i * rowh, block(width: 178mm, grid(columns: (23mm, 27mm, 1fr, 34mm, 15mm), column-gutter: 2mm, align: horizon,
      kind-label(t, w: 23mm),
      text(size: 9.4pt, weight: 700, fill: col("amber"), str(t.year) + " " + caps(t.when.split(" ").first())),
      text(size: 9.4pt, weight: 700, fill: white, caps(t.places.slice(0, calc.min(3, t.places.len())).join(" · "))),
      text(font: jp, size: 9pt, weight: 700, fill: col("amber"), t.kanji_places.join(" ")),
      align(right, text(size: 10.4pt, weight: 800, fill: c, str(t.days) + " ΗΜ.")),
    )))
  }
  place(top + left, dx: 3mm, dy: 2mm + 5 * rowh, text(size: 9pt, weight: 700, fill: col("amber"))[ΣΥΝΟΛΟ #h(2mm) #trips.len() ΤΑΞΙΔΙΑ · #jdays ΗΜΕΡΕΣ · JLPT N4 · #d.groups.len() ΟΜΑΔΕΣ, #gpax ΤΑΞΙΔΙΩΤΕΣ ◀])
}, 184mm, 5 * rowh + 8mm))

// ---- the meeting point (left) and the white information plates (right) ------------------
#let MY = 208mm
#place(top + left, dx: 16mm, dy: MY, box(width: 82mm, height: 80mm, fill: col("yellow"), radius: 1.5mm, inset: 4mm, {
  grid(columns: (30mm, 1fr), column-gutter: 2mm, align: horizon,
    svg(picto("escort", C.sign), "0 0 40 40", 30mm),
    {
      set par(leading: 0.28em)
      text(font: jp, size: 12pt, weight: 700)[集合場所]
      linebreak()
      text(size: 15pt, weight: 900)[ΣΗΜΕΙΟ ΣΥΝΑΝΤΗΣΗΣ]
      linebreak()
      text(size: 7.4pt, weight: 600)[MEETING POINT]
    })
  v(0.6mm)
  line(length: 100%, stroke: 0.8pt + col("sign"))
  set text(size: 8.4pt, weight: 500)
  text(size: 8.8pt, weight: 700, d.profile.split(". ").first() + ".")
  v(-0.4mm)
  for a in d.availability [#grid(columns: (3mm, 1fr), text(weight: 800, "▸"), a)]
  v(-0.2mm)
  text(weight: 800, d.offer)
}))

#let plate(kind, t, body) = block(width: 100%, fill: white, radius: 1mm, inset: (x: 3mm, y: 2.4mm), below: 2.2mm, {
  grid(columns: (6.4mm, 1fr), column-gutter: 2mm, align: horizon, tile(kind, 6.4mm), text(size: 10.5pt, weight: 800, t))
  v(-0.6mm)
  body
})
#place(top + left, dx: 102mm, dy: MY, block(width: 98mm, {
  set par(leading: 0.42em)
  plate("escort", "Εμπειρία", {
    for e in d.experience [#text(weight: 700, e.role) #h(1fr) #text(size: 7.6pt, weight: 700, fill: col("orange"), e.from + "–" + e.to) \ #text(size: 7.8pt, fill: col("grey"), e.company + " · " + e.city) \ ]
    text(size: 7.8pt)[Συν-αρχηγός στην Ιαπωνία 04/2026 (26 άτομα) · αρχηγός σε 5 ομάδες Ευρώπης]
  })
  plate("lang", "Γλώσσες και πιστοποιήσεις", {
    [#d.languages.map(l => [*#l.name* #l.level]).join([ · ])]
    linebreak()
    [*Πρώτες Βοήθειες & ΚΑΡΠΑ*, έως 03/2028 · *Tour Leader* 115 ώρες, 2025 · *Πτυχίο Διοίκησης Τουρισμού*, 2019]
  })
  plate("train", "Στην Ιαπωνία", text(size: 7.8pt, d.knowhow.join(" · ")))
}))

// contacts on the bottom direction strip
#place(bottom + left, dx: 16mm, dy: -2.4mm, box(width: 184mm, height: 6.4mm, fill: rgb("2f3338"), radius: 0.8mm, inset: (x: 3mm), align(horizon, {
  set text(fill: white, size: 8pt)
  text(weight: 700)[#d.contact.city]
  h(1fr); d.contact.phone; h(1fr); d.contact.email; h(1fr); text(fill: col("amber"), d.contact.link)
  h(1fr); text(size: 5pt, fill: col("grey"))[Φανταστικό πρόσωπο · σχέδιο CVgen]
})))
