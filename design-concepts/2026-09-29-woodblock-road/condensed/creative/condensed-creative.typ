// Woodblock Road, Creative tier. Idea run 2026-09-29 (magazine-editor).
// The whole page is one tall pillar print: the name runs down a title
// cartouche, the portrait sits in a folding fan, the CV is written into the
// kasumi mist bands over the lake, and the group crosses the bridge at the foot
// behind its leader's flag. Fictional data: sample.json in the style folder.
//
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path design-concepts/fonts design-concepts/2026-09-29-woodblock-road/condensed/creative/condensed-creative.typ design-concepts/2026-09-29-woodblock-road/condensed/creative/condensed-creative.pdf

#let d = json("../../sample.json")

// ---- palette ---------------------------------------------------------------
#let hx(c) = c // hex strings are reused inside SVG
#let C = (
  night: "13244a", prussian: "1c3563", blue: "3f63a0", pale: "9db3d4",
  paper: "f3ead7", paperhi: "f8f2e4", sumi: "231f1c", ver: "cf3f27",
  ochre: "e3c27d", pine: "2c4536", pinehi: "4f6e53", hill: "7d93b8",
  green: "5f7d5a", wood: "3b2a20", skin: "e9c9a6", sakura: "eebfbd",
)
#let col(k) = rgb(C.at(k))

#let serif = "Alegreya"
#let kanji = "Kaisei Tokumin"

#set page(paper: "a4", margin: 0mm, fill: col("paper"))
#set text(font: serif, size: 9pt, fill: col("sumi"), lang: "el")
#set par(leading: 0.52em, spacing: 0.7em)

// ---- small svg helpers -----------------------------------------------------
#let f(x) = str(calc.round(x, digits: 2))
#let svg(body, vb, w) = image(bytes(
  "<svg xmlns='http://www.w3.org/2000/svg' viewBox='" + vb + "'>" + body + "</svg>"
), format: "svg", width: w)

// a walker, feet at (x, y); faces right. coat colour, accessory, hat style
#let walker(x, y, coat, acc: none, hat: "kasa", s: 1) = {
  let o = "<g transform='translate(" + f(x) + "," + f(y) + ") scale(" + f(s) + ")'>"
  if acc == "case" {
    o += "<line x1='-1.3' y1='-4.3' x2='-2.6' y2='-2.6' stroke='#" + C.sumi + "' stroke-width='0.3'/>"
    o += "<rect x='-4.6' y='-2.9' width='2.3' height='2.6' rx='0.3' fill='#" + C.ver + "' stroke='#" + C.sumi + "' stroke-width='0.2'/>"
    o += "<circle cx='-4.1' cy='-0.15' r='0.28' fill='#" + C.sumi + "'/><circle cx='-2.8' cy='-0.15' r='0.28' fill='#" + C.sumi + "'/>"
  }
  if acc == "pack" {
    o += "<rect x='-2.5' y='-6.6' width='1.3' height='2.9' rx='0.35' fill='#" + C.ochre + "' stroke='#" + C.sumi + "' stroke-width='0.2'/>"
  }
  o += "<line x1='-0.5' y1='-3.2' x2='-1.2' y2='0' stroke='#" + C.sumi + "' stroke-width='0.5' stroke-linecap='round'/>"
  o += "<line x1='0.5' y1='-3.2' x2='1.2' y2='0' stroke='#" + C.sumi + "' stroke-width='0.5' stroke-linecap='round'/>"
  o += "<path d='M-1.25,-6.9 L1.25,-6.9 L1.95,-3.0 L-1.95,-3.0 Z' fill='#" + coat + "' stroke='#" + C.sumi + "' stroke-width='0.22'/>"
  o += "<circle cx='0.1' cy='-7.75' r='0.95' fill='#" + C.skin + "' stroke='#" + C.sumi + "' stroke-width='0.2'/>"
  if hat == "kasa" {
    o += "<path d='M-2.5,-8.1 L0.1,-9.9 L2.7,-8.1 Z' fill='#" + C.ochre + "' stroke='#" + C.sumi + "' stroke-width='0.22'/>"
  } else if hat == "brim" {
    o += "<ellipse cx='0.1' cy='-8.35' rx='1.9' ry='0.42' fill='#" + C.paperhi + "' stroke='#" + C.sumi + "' stroke-width='0.2'/><path d='M-0.8,-8.4 Q0.1,-9.8 1.0,-8.4 Z' fill='#" + C.paperhi + "' stroke='#" + C.sumi + "' stroke-width='0.2'/>"
  }
  if acc == "flag" {
    o += "<line x1='1.0' y1='-5.4' x2='2.9' y2='-18.5' stroke='#" + C.sumi + "' stroke-width='0.45' stroke-linecap='round'/>"
    o += "<path d='M2.9,-18.5 L10.4,-16.4 L2.6,-14.3 Z' fill='#" + C.ver + "' stroke='#" + C.sumi + "' stroke-width='0.25'/>"
    o += "<line x1='0.9' y1='-5.3' x2='1.6' y2='-6.6' stroke='#" + C.sumi + "' stroke-width='0.45'/>"
  }
  o + "</g>"
}

// seigaiha wave pattern
#let seigaiha(id, R, fill, ring) = {
  let c = "<g id='" + id + "c'>"
  for k in (1.0, 0.74, 0.5, 0.26) {
    c += "<circle r='" + f(R * k) + "' fill='" + (if k == 1.0 { "#" + fill } else { "none" }) + "' stroke='#" + ring + "' stroke-width='" + f(R * 0.07) + "'/>"
  }
  c += "</g>"
  "<pattern id='" + id + "' width='" + f(2 * R) + "' height='" + f(R) + "' patternUnits='userSpaceOnUse'>" + "<defs>" + c + "</defs>" + "<use href='#" + id + "c' x='0' y='0'/><use href='#" + id + "c' x='" + f(2 * R) + "' y='0'/><use href='#" + id + "c' x='" + f(R) + "' y='" + f(R / 2) + "'/><use href='#" + id + "c' x='0' y='" + f(R) + "'/><use href='#" + id + "c' x='" + f(2 * R) + "' y='" + f(R) + "'/></pattern>"
}

// kasumi mist band: stepped rounded bars
#let kasumi(x, y, w, h, fill: C.paperhi, op: 0.96) = {
  "<g fill='#" + fill + "' fill-opacity='" + f(op) + "'>" + "<rect x='" + f(x) + "' y='" + f(y) + "' width='" + f(w) + "' height='" + f(h) + "' rx='" + f(h / 2) + "'/>" + "<rect x='" + f(x + w * 0.18) + "' y='" + f(y - h * 0.55) + "' width='" + f(w * 0.46) + "' height='" + f(h) + "' rx='" + f(h / 2) + "'/>" + "<rect x='" + f(x + w * 0.5) + "' y='" + f(y + h * 0.5) + "' width='" + f(w * 0.42) + "' height='" + f(h) + "' rx='" + f(h / 2) + "'/></g>"
}


#let vtext(s, size, fill, font: kanji, gap: 0.6pt) = stack(
  dir: ttb, spacing: gap,
  ..s.clusters().map(c => box(width: size * 1.05, align(center, text(font: font, size: size, fill: fill, weight: 800, c)))),
)


// Greek all-caps drop the tonos (dialytika stays)
#let caps(s) = {
  let m = ("Ά": "Α", "Έ": "Ε", "Ή": "Η", "Ί": "Ι", "Ό": "Ο", "Ύ": "Υ", "Ώ": "Ω", "ΐ": "Ϊ", "ΰ": "Ϋ")
  upper(s).clusters().map(c => m.at(c, default: c)).join()
}
#let trips = d.japan_trips
#let jdays = trips.map(t => t.days).sum()
#let gpax = d.groups.map(g => g.pax).sum()

// ---- one print for the whole page (viewBox in mm) ---------------------------
#let sky-defs = "<linearGradient id='sky' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#" + C.night + "'/><stop offset='0.1' stop-color='#" + C.prussian + "'/><stop offset='0.3' stop-color='#6f8cc0'/><stop offset='0.48' stop-color='#efe3c8'/><stop offset='1' stop-color='#" + C.paper + "'/></linearGradient>"
#let sky-rect = "<rect x='0' y='0' width='210' height='160' fill='url(#sky)'/>"

// fan (ogi) geometry: pivot, radii, opening
#let fan = (cx: 42, cy: 80, r1: 23, r2: 61, a1: 124, a2: 56)
#let fp(r, a) = (fan.cx + r * calc.cos(a * 1deg), fan.cy - r * calc.sin(a * 1deg))
#let fan-path = {
  let (x1, y1) = fp(fan.r2, fan.a1)
  let (x2, y2) = fp(fan.r2, fan.a2)
  let (x3, y3) = fp(fan.r1, fan.a2)
  let (x4, y4) = fp(fan.r1, fan.a1)
  "M" + f(x1) + "," + f(y1) + " A" + str(fan.r2) + "," + str(fan.r2) + " 0 0 1 " + f(x2) + "," + f(y2) + " L" + f(x3) + "," + f(y3) + " A" + str(fan.r1) + "," + str(fan.r1) + " 0 0 0 " + f(x4) + "," + f(y4) + " Z"
}

#let layer-under = svg("<defs>" + sky-defs + "</defs>" + sky-rect, "0 0 210 297", 210mm)

#let layer-over = {
  let s = "<defs>" + sky-defs
  s += "<linearGradient id='fj' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#4a6ba3'/><stop offset='1' stop-color='#" + C.night + "'/></linearGradient>"
  s += "<clipPath id='fjc'><path d='M-30,158 Q72,128 92,50 L106,50 Q126,128 232,158 Z'/></clipPath>"
  s += seigaiha("sg", 4.2, C.prussian, "8fa8d0")
  s += "</defs>"
  // sky with the fan cut out (even-odd), so the portrait below shows through
  s += "<path fill-rule='evenodd' fill='url(#sky)' d='M0,0 L210,0 L210,160 L0,160 Z " + fan-path + "'/>"
  // fan: border, ribs below the leaf, pivot
  s += "<path d='" + fan-path + "' fill='none' stroke='#" + C.ochre + "' stroke-width='3.2'/>"
  s += "<path d='" + fan-path + "' fill='none' stroke='#" + C.sumi + "' stroke-width='0.5'/>"
  for k in range(0, 9) {
    let a = fan.a1 - k * (fan.a1 - fan.a2) / 8
    let (xa, ya) = fp(fan.r1 - 1.6, a)
    s += "<line x1='" + f(xa) + "' y1='" + f(ya) + "' x2='" + f(fan.cx) + "' y2='" + f(fan.cy) + "' stroke='#" + C.wood + "' stroke-width='0.9' stroke-linecap='round'/>"
  }
  s += "<circle cx='" + str(fan.cx) + "' cy='" + str(fan.cy) + "' r='1.4' fill='#" + C.ochre + "' stroke='#" + C.sumi + "' stroke-width='0.3'/>"
  // sun and a flight from the west
  s += "<circle cx='136' cy='40' r='15' fill='#" + C.ver + "'/>"
  s += "<path d='M80,30 Q100,14 132,12' fill='none' stroke='#" + C.paperhi + "' stroke-width='0.45' stroke-dasharray='1.8 1.3' stroke-opacity='0.85'/>"
  s += "<g transform='translate(135,11.6) rotate(4) scale(1.5)' fill='#" + C.paperhi + "'><path d='M-3.2,0 L3.4,0 Q4.4,0.3 3.4,0.6 L-3.2,0.6 Z'/><path d='M0.6,0.3 L-1.4,-2.6 L-0.5,-2.6 L2.0,0.3 Z'/><path d='M0.6,0.3 L-1.4,3.0 L-0.5,3.0 L2.0,0.4 Z'/><path d='M-3.2,0.3 L-4.0,-1.3 L-3.4,-1.3 L-2.4,0.3 Z'/></g>"
  // the mountain
  s += "<path d='M-30,158 Q72,128 92,50 L106,50 Q126,128 232,158 Z' fill='url(#fj)' stroke='#" + C.night + "' stroke-width='0.5'/>"
  s += "<g clip-path='url(#fjc)'><path d='M60,30 L140,30 L118,84 L114,80 L111.5,92 L108,79 L104.5,96 L101,80 L98,90 L94,78 L90.5,88 L86.5,77 L82,84 L60,86 Z' fill='#" + C.paperhi + "'/>"
  for (x1, x2) in ((95, 40), (99, 80), (103, 120), (107, 170)) {
    s += "<path d='M" + str(x1) + ",90 Q" + str((x1 + x2) / 2) + ",125 " + str(x2) + ",160' fill='none' stroke='#6d8cc0' stroke-width='0.5'/>"
  }
  s += "</g>"
  s += kasumi(40, 108, 150, 7)
  s += kasumi(-20, 64, 60, 5, op: 0.9)
  // shinkansen crossing below the mountain
  s += "<path d='M0,150 Q60,142 110,148 Q160,142 210,147 L210,160 L0,160 Z' fill='#" + C.green + "'/>"
  s += "<line x1='0' y1='151.5' x2='210' y2='151.5' stroke='#" + C.sumi + "' stroke-width='0.4'/>"
  for i in range(0, 36) { s += "<line x1='" + str(i * 6 + 3) + "' y1='151.5' x2='" + str(i * 6 + 3) + "' y2='158' stroke='#" + C.sumi + "' stroke-width='0.35'/>" }
  s += "<path d='M20,151.3 L112,151.3 Q124,151.3 128,149.2 Q120,146.4 108,146.2 L20,146.2 Z' fill='#" + C.paperhi + "' stroke='#" + C.sumi + "' stroke-width='0.35'/>"
  s += "<line x1='20' y1='149.6' x2='122' y2='149.6' stroke='#" + C.prussian + "' stroke-width='0.7'/>"
  s += "<line x1='23' y1='147.9' x2='105' y2='147.9' stroke='#" + C.prussian + "' stroke-width='0.8' stroke-dasharray='1.6 0.9'/>"
  // the lake: waves all the way down
  s += "<rect x='0' y='157' width='210' height='140' fill='url(#sg)'/>"
  // the bridge and the group at the foot of the page, at full size
  let yd(x) = 283 + 12 * calc.pow((x - 105) / 120, 2)
  s += "<path d='M-15,291.5 Q105,274.5 225,291.5 L225,297 L-15,297 Z' fill='#" + C.wood + "'/>"
  let xs = (16, 30, 44, 58, 72, 86, 100, 114, 128, 142, 156, 168)
  let coats = (C.blue, C.green, "8a5a3c", C.prussian, C.ochre, "6b4f7a", C.blue, "8a5a3c", C.green, C.prussian, C.ochre, C.blue, "6b4f7a", C.green)
  let accs = ("case", none, "pack", "case", none, "case", "pack", none, "case", none, "pack", "case", none, "case")
  for (i, x) in xs.enumerate() { s += walker(x, yd(x) - 0.3, coats.at(i), acc: accs.at(i), hat: ("brim", "kasa").at(calc.rem(i, 2)), s: 1.3) }
  s += walker(182, yd(182) - 0.3, C.ver, acc: "flag", hat: "brim", s: 1.55)
  let yr(x) = yd(x) - 4.8
  s += "<path d='M-13," + f(yr(-13)) + " Q105,269.2 223," + f(yr(223)) + "' fill='none' stroke='#" + C.wood + "' stroke-width='0.9'/>"
  for x in range(-5, 220, step: 11) {
    s += "<line x1='" + str(x) + "' y1='" + f(yr(x)) + "' x2='" + str(x) + "' y2='" + f(yd(x) + 1) + "' stroke='#" + C.wood + "' stroke-width='0.6'/>"
  }
  svg(s, "0 0 210 297", 210mm)
}

// the lake wave pattern is a paper-coloured gradient above y=160; keep it
#place(top + left, layer-under)
#place(top + left, dx: 12mm, dy: 11mm, image("../../portrait.jpg", width: 60mm))
#place(top + left, layer-over)

// ---- vertical title cartouche: the name, set like a print title ---------------
#let vstack(s, size, fill, font: serif, weight: 900, pitch: 1.0) = stack(dir: ttb, spacing: 0pt,
  ..s.clusters().map(c => box(width: size * 1.2, height: size * pitch, align(center + horizon, text(font: font, size: size, weight: weight, fill: fill, top-edge: "cap-height", bottom-edge: "baseline", c)))))

#place(top + left, dx: 180mm, dy: 7mm, box(width: 24mm, height: 176mm, fill: col("ochre"), stroke: 1.2pt + col("sumi"), inset: 1.6pt,
  box(width: 100%, height: 100%, stroke: 0.5pt + col("sumi"), align(center + horizon, {
    vstack(caps(d.name.first), 30pt, col("prussian"), pitch: 1.12)
    v(3mm)
    box(width: 9mm, height: 9mm, fill: col("ver"), radius: 1pt, align(center + horizon, text(font: kanji, weight: 800, size: 16pt, fill: col("paperhi"), "旅")))
    v(3mm)
    vstack(caps(d.name.last), 30pt, col("prussian"), pitch: 1.12)
  }))))
#place(top + left, dx: 169mm, dy: 7mm, box(width: 9.5mm, height: 62mm, fill: col("ver"), stroke: 1pt + col("sumi"), inset: 1.3pt,
  box(width: 100%, height: 100%, stroke: 0.4pt + col("sumi"), align(center + horizon, vtext(d.name.kana, 12pt, col("paperhi"), gap: 0pt)))))

// ---- mist bands that carry the CV --------------------------------------------
#let mist(w, h, body, fill: col("paperhi")) = box(width: w, height: h, radius: h / 2, fill: fill, stroke: 0.5pt + col("sumi"), inset: (x: h / 2.4, y: 3mm), body)
#set text(size: 8.8pt)
#set par(leading: 0.45em)

// band 1: who, what, how to reach him, the three numbers
#place(top + left, dx: -8mm, dy: 158mm, mist(184mm, 42mm, pad(left: 8mm, grid(columns: (1fr, 44mm), column-gutter: 4mm, {
  text(size: 21pt, weight: 900, fill: col("prussian"), d.name.el)
  v(-2.2mm)
  text(size: 9.6pt, weight: 800, tracking: 0.08em, fill: col("ver"), d.title.caps)
  linebreak()
  text(size: 9.6pt, weight: 800, tracking: 0.08em, fill: col("prussian"), d.title.specialty_caps)
  v(0.2mm)
  text(size: 8.6pt, d.profile)
}, {
  set align(center)
  v(1mm)
  for (n, l) in ((str(trips.len()), "ταξίδια στην Ιαπωνία"), (str(jdays), "ημέρες, 2018–2026"), ("N4", "JLPT, 12/2024")) {
    text(size: 19pt, weight: 900, fill: col("prussian"), n)
    v(-4mm)
    text(size: 7.2pt, weight: 700, fill: col("ver"), l)
    v(-0.6mm)
  }
}))))

// band 2: the five journeys, each under its season
#let season-kanji = (spring: "春", summer: "夏", autumn: "秋", winter: "冬")
#let season-col = (spring: "c9706c", summer: C.blue, autumn: "b8452c", winter: C.night)
#place(top + left, dx: 8mm, dy: 204mm, mist(210mm, 30mm, pad(left: 1mm, right: 6mm, grid(columns: (1fr,) * 5, column-gutter: 3mm,
  ..trips.map(t => {
    set par(leading: 0.34em)
    box(width: 7mm, height: 7mm, fill: rgb(season-col.at(t.season)), radius: 3.5mm, align(center + horizon, text(font: kanji, weight: 800, size: 12pt, fill: col("paperhi"), season-kanji.at(t.season))))
    h(1.4mm)
    box(baseline: -1mm, text(size: 11pt, weight: 900, fill: col("ver"), str(t.days)) + text(size: 7.4pt, weight: 700, fill: col("ver"), " ημ."))
    linebreak()
    text(weight: 800, fill: col("prussian"), t.when)
    linebreak()
    text(size: 7.6pt, t.places.join(", "))
    linebreak()
    text(size: 7pt, weight: 800, tracking: 0.04em, fill: (if t.kind == "colead" { col("ver") } else { col("blue") }), caps(t.kind_el))
  })))))

// band 3: the job, the groups, the credentials
#place(top + left, dx: -10mm, dy: 238mm, mist(186mm, 28mm, pad(left: 10mm, grid(columns: (56mm, 36mm, 1fr), column-gutter: 4mm, {
  set par(leading: 0.38em)
  let e = d.experience.first()
  text(size: 7.2pt, weight: 800, tracking: 0.08em, fill: col("ver"))[ΣΗΜΕΡΑ]
  linebreak()
  text(weight: 800, e.role)
  linebreak()
  text(fill: col("blue"), weight: 700)[#e.company, #e.city · #e.from–#e.to]
  linebreak()
  let e2 = d.experience.at(1)
  text(size: 8pt)[Πριν: #e2.role, #e2.company, #e2.from–#e2.to]
}, {
  set par(leading: 0.38em)
  text(size: 7.2pt, weight: 800, tracking: 0.08em, fill: col("ver"))[ΟΜΑΔΕΣ]
  linebreak()
  text(size: 17pt, weight: 900, fill: col("prussian"), str(d.groups.len()))
  text(weight: 700)[ ομάδες · ]
  text(size: 17pt, weight: 900, fill: col("prussian"), str(gpax))
  text(weight: 700)[ ταξιδιώτες]
  linebreak()
  text(size: 7.8pt)[Ιαπωνία 04/2026 συν-αρχηγός · 5 Ευρώπη αρχηγός]
}, {
  set par(leading: 0.38em)
  set text(size: 8pt)
  text(size: 7.2pt, weight: 800, tracking: 0.08em, fill: col("ver"))[ΓΛΩΣΣΕΣ · ΠΙΣΤΟΠΟΙΗΣΕΙΣ]
  linebreak()
  [*Αγγλικά* C2 · *Ιαπωνικά* JLPT N4]
  linebreak()
  [*Πρώτες Βοήθειες*, έως 03/2028]
  linebreak()
  [*Tour Leader*, 115 ώρες, 2025]
  linebreak()
  [*Πτυχίο Διοίκησης Τουρισμού*]
}))))

// contact line at the foot, over the bridge
#place(bottom + left, dx: 0mm, dy: 0mm, block(width: 210mm, height: 6.4mm, fill: col("sumi"), inset: (x: 10mm), align(horizon, {
  set text(size: 8pt, fill: col("paperhi"))
  [#text(weight: 800)[#d.contact.city]#h(1fr)#d.contact.phone#h(1fr)#d.contact.email#h(1fr)#d.contact.link#h(1fr)#text(fill: col("ochre"), weight: 700)[#d.availability.first()]#h(1fr)#text(size: 5pt, fill: col("pale"))[Φανταστικό πρόσωπο · σχέδιο CVgen]]
})))
