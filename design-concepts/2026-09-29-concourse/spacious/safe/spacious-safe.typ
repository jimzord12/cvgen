// Concourse, Safe tier, Spacious density (two pages). Idea run 2026-09-29 (magazine-editor).
// The calm version given room: the station-name board heads page 1 on a white
// page, over a conventional two-column CV at 10 pt with the Japan record on a
// colour-coded LED indicator. Page 2 opens on a smaller name board with a
// platform-number sign, then the groups, the know-how and the duties on the
// road as pictogram grids, and the meeting-point sign with the offer.
// Tactile paving along the foot of both pages. Fictional data: sample.json.
//
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path design-concepts/fonts design-concepts/2026-09-29-concourse/spacious/safe/spacious-safe.typ design-concepts/2026-09-29-concourse/spacious/safe/spacious-safe.pdf

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
  } else if kind == "count" { let inv = if k == C.white { C.sign } else { C.white }; "<rect x='8' y='7' width='24' height='30' rx='2.2'" + fl + "/><rect x='14' y='3.6' width='12' height='6.4' rx='1.6'" + fl + " stroke='#" + inv + "' stroke-width='1.2'/><path d='M12,17 l2.6,2.6 l4.6,-5 M12,27 l2.6,2.6 l4.6,-5' fill='none' stroke='#" + inv + "' stroke-width='2.2' stroke-linecap='round' stroke-linejoin='round'/><path d='M22,17 L29,17 M22,27 L29,27' stroke='#" + inv + "' stroke-width='2' stroke-linecap='round'/>" } else if kind == "ticket" { let inv = if k == C.white { C.sign } else { C.white }; "<path d='M4,10 L36,10 L36,16.5 Q31.6,20 36,23.5 L36,30 L4,30 L4,23.5 Q8.4,20 4,16.5 Z'" + fl + "/><line x1='26' y1='12.5' x2='26' y2='27.5' stroke='#" + inv + "' stroke-width='1.2' stroke-dasharray='1.6 1.4'/><path d='M9,16 L21,16 M9,20 L19,20 M9,24 L21,24' stroke='#" + inv + "' stroke-width='1.8' stroke-linecap='round'/>" } else if kind == "yen" { let inv = if k == C.white { C.sign } else { C.white }; "<circle cx='20' cy='20' r='15.5'" + fl + "/><path d='M13,10.5 L20,19.5 L27,10.5 M20,19.5 L20,31 M14,21 L26,21 M14,26 L26,26' fill='none' stroke='#" + inv + "' stroke-width='2.6' stroke-linecap='round' stroke-linejoin='round'/>" } else if kind == "bus" { let inv = if k == C.white { C.sign } else { C.white }; "<rect x='6' y='5' width='28' height='27' rx='3.6'" + fl + "/><rect x='9.5' y='9' width='21' height='10' rx='1.4' fill='#" + inv + "'/><circle cx='12.5' cy='26' r='2' fill='#" + inv + "'/><circle cx='27.5' cy='26' r='2' fill='#" + inv + "'/><rect x='9' y='31' width='5' height='5' rx='1'" + fl + "/><rect x='26' y='31' width='5' height='5' rx='1'" + fl + "/>" } else { "" }
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
#set page(paper: "a4", margin: 0mm, fill: white)
#set text(font: sans, size: 10pt, fill: col("sign"), lang: "el")
#set par(leading: 0.56em, spacing: 0.85em)

#let head(kind, t, en, jpn) = block(above: 7mm, below: 3mm, {
  grid(columns: (7.6mm, 1fr), column-gutter: 2.4mm, align: horizon,
    tile(kind, 7.6mm),
    { text(size: 14pt, weight: 800, t); h(1.8mm); text(size: 7.6pt, fill: col("grey"), en); h(1.4mm); text(font: jp, size: 7.6pt, weight: 700, fill: col("grey"), jpn) })
  v(-1.2mm)
  line(length: 100%, stroke: 0.6pt + col("sign"))
})
#let arrow(body) = grid(columns: (3.6mm, 1fr), text(fill: col("orange"), "▸"), body)
#let X = 16mm

// =========================== PAGE 1 ===========================
#let BX = X
#let BY = 14mm
#let BW = 142mm
#place(top + left, dx: BX, dy: BY, rect(width: BW, height: 7mm, fill: col("sign"), radius: (top: 1mm)))
#place(top + left, dx: BX + 3.4mm, dy: BY + 1.5mm, text(size: 7.8pt, weight: 700, fill: white, tracking: 0.1em)[ΒΙΟΓΡΑΦΙΚΟ · #text(font: jp)[履歴書] · CURRICULUM VITAE])
#place(top + left, dx: BX, dy: BY + 7mm, rect(width: BW, height: 53mm, fill: white, stroke: 0.9pt + col("sign")))
#place(top + left, dx: BX + 5mm, dy: BY + 13mm, badge("JP", "05", "orange", size: 16mm))
#place(top + left, dx: BX + 5.6mm, dy: BY + 30.5mm, box(width: 14.8mm, align(center, text(size: 7pt, weight: 700, fill: col("grey"))[ταξίδια\ Ιαπωνία])))
#place(top + left, dx: BX + 26mm, dy: BY + 11mm, text(font: jp, size: 11.5pt, weight: 700, tracking: 0.08em, d.name.kana))
#place(top + left, dx: BX + 25mm, dy: BY + 16.4mm, text(size: 39pt, weight: 900, d.name.el))
#place(top + left, dx: BX + 26mm, dy: BY + 34mm, text(size: 12pt, weight: 500, fill: col("grey"), tracking: 0.04em, d.name.latin))
#place(top + left, dx: BX, dy: BY + 42.5mm, rect(width: BW, height: 6.4mm, fill: col("orange")))
#place(top + left, dx: BX + 4mm, dy: BY + 43.8mm, text(size: 9.6pt, weight: 700, fill: white, tracking: 0.08em)[ΑΡΧΗΓΟΣ-ΣΥΝΟΔΟΣ ΕΚΔΡΟΜΩΝ])
#place(top + right, dx: -(210mm - BX - BW) - 4mm, dy: BY + 43.8mm, text(size: 9.6pt, weight: 700, fill: white, tracking: 0.08em)[ΕΞΕΙΔΙΚΕΥΣΗ ΙΑΠΩΝΙΑ #text(font: jp, size: 9pt)[日本]])
#place(top + left, dx: BX + 4mm, dy: BY + 52.6mm, text(size: 9.2pt)[#text(weight: 700)[#d.contact.city] #h(3.4mm) #d.contact.phone #h(3.4mm) #d.contact.email #h(3.4mm) #text(fill: col("orange"), d.contact.link)])
#place(top + left, dx: 162mm, dy: BY, box(clip: true, radius: 1mm, stroke: 0.9pt + col("sign"), width: 32mm, height: 44mm, image("../../portrait.jpg", height: 44mm)))
#place(top + left, dx: 162mm, dy: BY + 46mm, box(width: 32mm, height: 14mm, fill: col("yellow"), radius: 1mm, inset: 1.4mm,
  grid(columns: (10mm, 1fr), column-gutter: 1mm, align: horizon,
    svg(picto("leader", C.sign), "0 0 40 40", 10mm),
    text(size: 8pt, weight: 800)[ΑΡΧΗΓΟΣ\ ΟΜΑΔΑΣ])))

// main column
#place(top + left, dx: X, dy: 82mm, block(width: 114mm, {
  block(above: 0mm, text(size: 10.5pt, d.profile))
  head("escort", "Εμπειρία", "EXPERIENCE", "職歴")
  for e in d.experience {
    block(below: 3.4mm, {
      set par(leading: 0.5em)
      text(size: 11pt, weight: 700, e.role)
      linebreak()
      text(weight: 600, fill: col("grey"), e.company + " · " + e.city)
      h(1fr)
      text(size: 9pt, weight: 700, fill: col("orange"), e.from + "–" + e.to)
      linebreak()
      for p in e.points { block(below: 1.4mm, arrow(p)) }
    })
  }
  head("plane", "Ιαπωνία, ταξίδι προς ταξίδι", "JAPAN RECORD", "渡航歴")
  let rowh = 11.4mm
  led({
    for (i, t) in trips.enumerate() {
      place(top + left, dx: 2.4mm, dy: 1.4mm + i * rowh, block(width: 110mm, height: rowh - 1mm, grid(columns: (22mm, 25mm, 1fr, 15mm), rows: (rowh - 1mm,), column-gutter: 1.8mm, align: horizon,
        kind-label(t, w: 22mm),
        text(size: 9.6pt, weight: 700, fill: col("amber"), str(t.year) + " " + caps(t.when.split(" ").first())),
        { set par(leading: 0.4em); text(size: 9.6pt, weight: 700, fill: white, caps(t.places.join(" · "))) },
        align(right, text(size: 10.4pt, weight: 800, fill: col(kind-col.at(t.kind)), str(t.days) + " ΗΜ.")),
      )))
    }
  }, 114mm, 5 * rowh + 1.6mm)
  v(1.4mm)
  text(size: 8.4pt, fill: col("grey"))[#box(width: 2.6mm, height: 2.6mm, fill: col("green"), radius: 0.4mm) ταξίδι #h(3mm) #box(width: 2.6mm, height: 2.6mm, fill: col("orange"), radius: 0.4mm) σπουδές #h(3mm) #box(width: 2.6mm, height: 2.6mm, fill: col("red"), radius: 0.4mm) συν-αρχηγία ομάδας]
}))

// side column
#place(top + left, dx: 138mm, dy: 82mm, block(width: 56mm, {
  block(above: 0mm, width: 100%, fill: col("sign"), radius: 1mm, inset: 3.4mm, {
    set text(fill: white)
    for (n, l) in ((str(trips.len()), "ταξίδια στην Ιαπωνία"), (str(jdays), "ημέρες στη χώρα"), ("N4", "JLPT, 12/2024")) {
      block(below: 1.2mm, grid(columns: (20mm, 1fr), align: horizon, text(size: 24pt, weight: 900, fill: col("yellow"), n), text(size: 9pt, weight: 600, l)))
    }
  })
  head("lang", "Γλώσσες", "LANGUAGES", "言語")
  for l in d.languages { block(below: 1.6mm, grid(columns: (19mm, 1fr), text(weight: 700, l.name), [#l.level#if "note" in l [ \ #text(size: 8.6pt, fill: col("grey"), l.note)]])) }
  head("aid", "Πιστοποιήσεις", "PAPERS", "資格")
  set par(leading: 0.46em)
  for c in d.certificates { block(below: 2.2mm)[#text(weight: 700, c.title) \ #text(size: 8.8pt, fill: col("grey"), c.issuer + " · " + c.valid)] }
  for e in d.education { block(below: 2.2mm)[#text(weight: 700, e.title) \ #text(size: 8.8pt, fill: col("grey"), e.school + " · " + e.years)] }
  head("clock", "Διαθεσιμότητα", "AVAILABILITY", "")
  for a in d.availability { block(below: 1.4mm, arrow(a)) }
}))

#place(bottom + left, paving(210, 6, kind: "bars", unit: 6))
#place(bottom + left, dy: -6mm, box(width: 210mm, height: 0.5mm, fill: col("sign")))
#place(bottom + right, dx: -3mm, dy: -7.6mm, text(size: 5.4pt, fill: col("grey"))[Φανταστικό πρόσωπο · σχέδιο CVgen · 1/2])

#pagebreak()

// =========================== PAGE 2 ===========================
// a smaller name board and a platform-number sign: this is page 2
#let B2Y = 14mm
#let B2W = 150mm
#place(top + left, dx: X, dy: B2Y, rect(width: B2W, height: 33mm, fill: white, stroke: 0.9pt + col("sign")))
#place(top + left, dx: X + 4mm, dy: B2Y + 4.4mm, badge("JP", "05", "orange", size: 13mm))
#place(top + left, dx: X + 21mm, dy: B2Y + 2.4mm, text(font: jp, size: 9pt, weight: 700, tracking: 0.08em, d.name.kana))
#place(top + left, dx: X + 20.4mm, dy: B2Y + 8.2mm, text(size: 25pt, weight: 900, d.name.el))
#place(top + right, dx: -(210mm - X - B2W) - 4mm, dy: B2Y + 11.4mm, text(size: 10.4pt, weight: 500, fill: col("grey"), tracking: 0.04em, d.name.latin))
#place(top + left, dx: X, dy: B2Y + 22mm, rect(width: B2W, height: 5.6mm, fill: col("orange")))
#place(top + left, dx: X + 4mm, dy: B2Y + 23mm, text(size: 8.8pt, weight: 700, fill: white, tracking: 0.08em)[ΑΡΧΗΓΟΣ-ΣΥΝΟΔΟΣ ΕΚΔΡΟΜΩΝ])
#place(top + right, dx: -(210mm - X - B2W) - 4mm, dy: B2Y + 23mm, text(size: 8.8pt, weight: 700, fill: white, tracking: 0.08em)[ΕΞΕΙΔΙΚΕΥΣΗ ΙΑΠΩΝΙΑ #text(font: jp, size: 8.4pt)[日本]])
#let tri-l = svg("<path d='M0,3 L5,0 L5,6 Z' fill='#" + C.sign + "'/>", "0 0 5 6", 2.4mm)
#let tri-r = svg("<path d='M5,3 L0,0 L0,6 Z' fill='#" + C.sign + "'/>", "0 0 5 6", 2.4mm)
#place(top + left, dx: X + 4mm, dy: B2Y + 28.6mm, text(size: 7.8pt, fill: col("grey"))[#box(tri-l) #h(1mm) σελίδα 1 · ταυτότητα, εμπειρία, Ιαπωνία])
#place(top + right, dx: -(210mm - X - B2W) - 4mm, dy: B2Y + 28.6mm, text(size: 7.8pt, fill: col("grey"))[ομάδες, πρακτικά, πρόταση #h(1mm) #box(tri-r)])
#place(top + left, dx: X + B2W + 4mm, dy: B2Y, box(width: 24mm, height: 33mm, fill: col("sign"), radius: 1mm, {
  place(top + left, dx: 0mm, dy: 2.2mm, box(width: 24mm, align(center, text(font: jp, size: 8pt, weight: 700, fill: white)[のりば])))
  place(top + left, dx: 0mm, dy: 5.4mm, box(width: 24mm, align(center, text(size: 44pt, weight: 900, fill: col("yellow"), top-edge: "cap-height", bottom-edge: "baseline")[2])))
  place(bottom + left, dx: 0mm, dy: -2mm, box(width: 24mm, align(center, text(size: 6.6pt, weight: 700, fill: white, tracking: 0.08em)[ΣΕΛΙΔΑ · PAGE])))
}))

// groups
#place(top + left, dx: X, dy: 55mm, block(width: 178mm, {
  head("crowd", "Ομάδες που συνόδευσε", "GROUPS", "団体")
  table(
    columns: (20mm, 1fr, 18mm, 16mm, 30mm), stroke: none, inset: (x: 1.4mm, y: 1.6mm),
    fill: (_, y) => if calc.odd(y) and y <= d.groups.len() { col("page") } else { none },
    ..("Πότε", "Προορισμός", "Άτομα", "Ημέρες", "Ρόλος").map(h => text(size: 8.6pt, weight: 700, fill: col("grey"), h)),
    table.hline(stroke: 0.5pt + col("sign")),
    ..d.groups.map(g => (g.date, (if g.japan { text(weight: 700, fill: col("red"), g.where) } else { g.where }), str(g.pax), str(g.days), g.role)).flatten(),
    table.hline(stroke: 0.5pt + col("sign")),
    [], text(weight: 700)[#d.groups.len() ομάδες], text(weight: 700, str(gpax)), text(weight: 700, str(d.groups.map(g => g.days).sum())), [],
  )
}))

// know-how and duties as pictogram grids
#let pgrid(kinds, items) = grid(columns: (1fr, 1fr, 1fr), column-gutter: 5mm, row-gutter: 5mm,
  ..kinds.zip(items).map(((k, t)) => grid(columns: (14mm, 1fr), column-gutter: 2.6mm, align: horizon, tile(k, 14mm), text(size: 10pt, weight: 500, t))))
#place(top + left, dx: X, dy: 122mm, block(width: 178mm, {
  head("train", "Στην Ιαπωνία", "JAPAN KNOW-HOW", "旅の実務")
  pgrid(("train", "card", "luggage", "onsen", "blossom", "crowd"), d.knowhow)
  head("escort", "Στη συνοδεία", "ON THE ROAD", "添乗業務")
  pgrid(("count", "ticket", "yen", "aid", "bus"), d.operations)
}))

// the meeting-point sign: the offer
#place(top + left, dx: X, dy: 238mm, block(width: 178mm, fill: col("yellow"), radius: 1.6mm, inset: (x: 5mm, y: 4mm), {
  grid(columns: (24mm, 1fr, 58mm), column-gutter: 5mm, align: horizon,
    svg(picto("escort", C.sign), "0 0 40 40", 24mm),
    {
      set par(leading: 0.3em)
      text(font: jp, size: 10pt, weight: 700)[集合場所]
      linebreak()
      text(size: 17pt, weight: 900)[ΣΗΜΕΙΟ ΣΥΝΑΝΤΗΣΗΣ]
      linebreak()
      text(size: 8pt, weight: 600)[MEETING POINT · ο αρχηγός της ομάδας]
    },
    {
      set par(leading: 0.45em)
      text(size: 11pt, weight: 800, d.offer)
    })
}))

#place(bottom + left, paving(210, 6, kind: "bars", unit: 6))
#place(bottom + left, dy: -6mm, box(width: 210mm, height: 0.5mm, fill: col("sign")))
#place(bottom + left, dx: X, dy: -8.4mm, text(size: 8.6pt)[#text(weight: 700)[#d.name.el] #h(3mm) #d.contact.phone #h(3mm) #d.contact.email #h(3mm) #text(fill: col("orange"), d.contact.link)])
#place(bottom + right, dx: -3mm, dy: -7.6mm, text(size: 5.4pt, fill: col("grey"))[Φανταστικό πρόσωπο · σχέδιο CVgen · 2/2])
