// Woodblock Road, Creative tier, Spacious density (two pages). Idea run 2026-09-29 (magazine-editor).
// The two pages are one hanging scroll: page 1 is the sky, the fan with the
// portrait, the name cartouche, the mountain and the train, with the lake
// beginning under the first mist band (who he is); page 2 is the lake itself,
// a torii standing in the water, the career written into four mist bands, and
// the group crossing the bridge at the foot behind its leader's flag.
// Fictional data: sample.json in the style folder.
//
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path design-concepts/fonts design-concepts/2026-09-29-woodblock-road/spacious/creative/spacious-creative.typ design-concepts/2026-09-29-woodblock-road/spacious/creative/spacious-creative.pdf

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

#set text(size: 10pt)
#set par(leading: 0.5em, spacing: 0.7em)

// ---- page 1: sky, fan, mountain, train, the first of the lake (viewBox in mm) ------------
#let LAKE = 199
#let sky-defs = "<linearGradient id='sky' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#" + C.night + "'/><stop offset='0.1' stop-color='#" + C.prussian + "'/><stop offset='0.3' stop-color='#6f8cc0'/><stop offset='0.5' stop-color='#efe3c8'/><stop offset='1' stop-color='#" + C.paper + "'/></linearGradient>"
#let sky-rect = "<rect x='0' y='0' width='210' height='" + str(LAKE + 2) + "' fill='url(#sky)'/>"

#let fan = (cx: 45, cy: 99, r1: 27, r2: 74, a1: 124, a2: 56)
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
  s += "<clipPath id='fjc'><path d='M-40,200 Q68,160 91,62 L107,62 Q130,160 250,200 Z'/></clipPath>"
  s += seigaiha("sg", 4.6, C.prussian, "8fa8d0")
  s += "</defs>"
  s += "<path fill-rule='evenodd' fill='url(#sky)' d='M0,0 L210,0 L210," + str(LAKE + 2) + " L0," + str(LAKE + 2) + " Z " + fan-path + "'/>"
  // fan: border, ribs, pivot
  s += "<path d='" + fan-path + "' fill='none' stroke='#" + C.ochre + "' stroke-width='3.6'/>"
  s += "<path d='" + fan-path + "' fill='none' stroke='#" + C.sumi + "' stroke-width='0.55'/>"
  for k in range(0, 10) {
    let a = fan.a1 - k * (fan.a1 - fan.a2) / 9
    let (xa, ya) = fp(fan.r1 - 1.8, a)
    s += "<line x1='" + f(xa) + "' y1='" + f(ya) + "' x2='" + f(fan.cx) + "' y2='" + f(fan.cy) + "' stroke='#" + C.wood + "' stroke-width='1' stroke-linecap='round'/>"
  }
  s += "<circle cx='" + str(fan.cx) + "' cy='" + str(fan.cy) + "' r='1.6' fill='#" + C.ochre + "' stroke='#" + C.sumi + "' stroke-width='0.3'/>"
  // sun, a flight from the west, birds
  s += "<circle cx='138' cy='50' r='17' fill='#" + C.ver + "'/>"
  s += "<path d='M86,36 Q106,18 134,15' fill='none' stroke='#" + C.paperhi + "' stroke-width='0.5' stroke-dasharray='2 1.4' stroke-opacity='0.85'/>"
  s += "<g transform='translate(137.5,14.6) rotate(4) scale(1.7)' fill='#" + C.paperhi + "'><path d='M-3.2,0 L3.4,0 Q4.4,0.3 3.4,0.6 L-3.2,0.6 Z'/><path d='M0.6,0.3 L-1.4,-2.6 L-0.5,-2.6 L2.0,0.3 Z'/><path d='M0.6,0.3 L-1.4,3.0 L-0.5,3.0 L2.0,0.4 Z'/><path d='M-3.2,0.3 L-4.0,-1.3 L-3.4,-1.3 L-2.4,0.3 Z'/></g>"
  // the mountain
  s += "<path d='M-40,200 Q68,160 91,62 L107,62 Q130,160 250,200 Z' fill='url(#fj)' stroke='#" + C.night + "' stroke-width='0.5'/>"
  s += "<g clip-path='url(#fjc)'><path d='M56,40 L144,40 L120,100 L116,96 L113,110 L109.5,95 L105.5,113 L101.5,96 L98,108 L94,94 L90,105 L86,93 L81,101 L56,103 Z' fill='#" + C.paperhi + "'/>"
  for (x1, x2) in ((94, 30), (98, 76), (102, 124), (106, 180)) {
    s += "<path d='M" + str(x1) + ",106 Q" + str((x1 + x2) / 2) + ",150 " + str(x2) + ",200' fill='none' stroke='#6d8cc0' stroke-width='0.55'/>"
  }
  s += "</g>"
  s += kasumi(46, 132, 160, 7.5)
  s += kasumi(-22, 162, 66, 5.4, op: 0.92)
  s += kasumi(120, 96, 90, 4, op: 0.6)
  // the shinkansen on its viaduct, below the mountain
  s += "<path d='M0,190 Q60,182 110,188 Q160,182 210,187 L210," + str(LAKE + 1) + " L0," + str(LAKE + 1) + " Z' fill='#" + C.green + "'/>"
  s += "<line x1='0' y1='192' x2='210' y2='192' stroke='#" + C.sumi + "' stroke-width='0.45'/>"
  for i in range(0, 36) { s += "<line x1='" + str(i * 6 + 3) + "' y1='192' x2='" + str(i * 6 + 3) + "' y2='" + str(LAKE) + "' stroke='#" + C.sumi + "' stroke-width='0.4'/>" }
  s += "<path d='M16,191.8 L118,191.8 Q131,191.8 135,189.5 Q127,186.4 114,186.2 L16,186.2 Z' fill='#" + C.paperhi + "' stroke='#" + C.sumi + "' stroke-width='0.4'/>"
  s += "<line x1='16' y1='189.9' x2='129' y2='189.9' stroke='#" + C.prussian + "' stroke-width='0.8'/>"
  s += "<line x1='19' y1='188' x2='110' y2='188' stroke='#" + C.prussian + "' stroke-width='0.9' stroke-dasharray='1.8 1'/>"
  // the lake begins
  s += "<rect x='0' y='" + str(LAKE) + "' width='210' height='" + str(297 - LAKE) + "' fill='url(#sg)'/>"
  svg(s, "0 0 210 297", 210mm)
}

// ---- page 2: the lake, a torii in the water, the bridge with the group --------------------
#let torii(cx, yb, sc) = {
  let st = " stroke='#" + C.sumi + "' stroke-width='0.3'"
  let g = "<g transform='translate(" + f(cx) + "," + f(yb) + ") scale(" + f(sc) + ")'>"
  g += "<path d='M-10.4,0 L-7.9,0 L-8.3,-24 L-10,-24 Z' fill='#" + C.ver + "'" + st + "/>"
  g += "<path d='M10.4,0 L7.9,0 L8.3,-24 L10,-24 Z' fill='#" + C.ver + "'" + st + "/>"
  g += "<rect x='-13.2' y='-19.8' width='26.4' height='1.9' fill='#" + C.ver + "'" + st + "/>"
  g += "<rect x='-0.9' y='-24' width='1.8' height='4.4' fill='#" + C.ver + "'" + st + "/>"
  g += "<path d='M-15.2,-24 L15.2,-24 L14.8,-25.8 L-14.8,-25.8 Z' fill='#" + C.ver + "'" + st + "/>"
  g += "<path d='M-17.4,-28.8 Q0,-26.2 17.4,-28.8 L16.4,-25.6 Q0,-24.6 -16.4,-25.6 Z' fill='#" + C.sumi + "'/>"
  g + "</g>"
}
#let lake-page = {
  let s = "<defs>" + seigaiha("sg2", 4.6, C.prussian, "8fa8d0") + "</defs>"
  s += "<rect width='210' height='297' fill='url(#sg2)'/>"
  // the torii standing in the water, its reflection broken by the waves
  s += "<g opacity='0.5'>" + "<path d='M41,60 L45.6,60 L45,76 L41.6,76 Z M79,60 L74.4,60 L75,76 L78.4,76 Z' fill='#" + C.ver + "'/></g>"
  s += "<path d='M28,60.6 Q60,57 92,60.6' fill='none' stroke='#" + C.paperhi + "' stroke-width='0.9' stroke-opacity='0.8'/>"
  s += torii(60, 60, 1.86)
  s += kasumi(78, 30, 70, 4.4, op: 0.95)
  // a small boat
  s += "<path d='M118,50 L142,50 L138,54 L121,54 Z' fill='#" + C.wood + "' stroke='#" + C.sumi + "' stroke-width='0.3'/><line x1='130' y1='50' x2='130' y2='38' stroke='#" + C.wood + "' stroke-width='0.5'/><path d='M130.4,39 L138,48.4 L130.4,48.4 Z' fill='#" + C.paperhi + "' stroke='#" + C.sumi + "' stroke-width='0.25'/>"
  // the bridge and the group at the foot of the page
  let yd(x) = 283 + 12 * calc.pow((x - 105) / 120, 2)
  s += "<path d='M-15,291.5 Q105,274.5 225,291.5 L225,297 L-15,297 Z' fill='#" + C.wood + "'/>"
  let xs = (14, 27, 40, 53, 66, 79, 92, 105, 118, 131, 144, 157, 169)
  let coats = (C.blue, C.green, "8a5a3c", C.prussian, C.ochre, "6b4f7a", C.blue, "8a5a3c", C.green, C.prussian, C.ochre, C.blue, "6b4f7a")
  let accs = ("case", none, "pack", "case", none, "case", "pack", none, "case", none, "pack", "case", none)
  for (i, x) in xs.enumerate() { s += walker(x, yd(x) - 0.3, coats.at(i), acc: accs.at(i), hat: ("brim", "kasa").at(calc.rem(i, 2)), s: 1.3) }
  s += walker(183, yd(183) - 0.3, C.ver, acc: "flag", hat: "brim", s: 1.55)
  let yr(x) = yd(x) - 4.8
  s += "<path d='M-13," + f(yr(-13)) + " Q105,269.2 223," + f(yr(223)) + "' fill='none' stroke='#" + C.wood + "' stroke-width='0.9'/>"
  for x in range(-5, 220, step: 11) {
    s += "<line x1='" + str(x) + "' y1='" + f(yr(x)) + "' x2='" + str(x) + "' y2='" + f(yd(x) + 1) + "' stroke='#" + C.wood + "' stroke-width='0.6'/>"
  }
  svg(s, "0 0 210 297", 210mm)
}

// ---- furniture ------------------------------------------------------------------------
#let vstack(s, size, fill, font: serif, weight: 900, pitch: 1.0) = stack(dir: ttb, spacing: 0pt,
  ..s.clusters().map(c => box(width: size * 1.2, height: size * pitch, align(center + horizon, text(font: font, size: size, weight: weight, fill: fill, top-edge: "cap-height", bottom-edge: "baseline", c)))))
#let mist(w, h, body, fill: col("paperhi")) = box(width: w, height: h, radius: h / 2, fill: fill, stroke: 0.5pt + col("sumi"), inset: (x: calc.min(h / 2.4, 14mm), y: 3mm), align(left + horizon, body))
#let lab(t) = text(size: 8.4pt, weight: 800, tracking: 0.08em, fill: col("ver"), t)
#let season-kanji = (spring: "春", summer: "夏", autumn: "秋", winter: "冬")
#let season-col = (spring: "c9706c", summer: C.blue, autumn: "b8452c", winter: C.night)
#let seal(size) = box(width: size, height: size, fill: col("ver"), radius: 1pt, align(center + horizon, text(font: kanji, weight: 800, size: size * 1.75 / 1mm * 1pt, fill: col("paperhi"), "旅")))

// =========================== PAGE 1 ===========================
#place(top + left, layer-under)
#place(top + left, dx: 8mm, dy: 17mm, image("../../portrait.jpg", width: 74mm))
#place(top + left, layer-over)

// the name down the title cartouche
#place(top + left, dx: 179mm, dy: 7mm, box(width: 25mm, height: 186mm, fill: col("ochre"), stroke: 1.2pt + col("sumi"), inset: 1.6pt,
  box(width: 100%, height: 100%, stroke: 0.5pt + col("sumi"), align(center + horizon, {
    vstack(caps(d.name.first), 32pt, col("prussian"), pitch: 1.12)
    v(3mm)
    seal(9.5mm)
    v(3mm)
    vstack(caps(d.name.last), 32pt, col("prussian"), pitch: 1.12)
  }))))
#place(top + left, dx: 167mm, dy: 7mm, box(width: 10mm, height: 68mm, fill: col("ver"), stroke: 1pt + col("sumi"), inset: 1.3pt,
  box(width: 100%, height: 100%, stroke: 0.4pt + col("sumi"), align(center + horizon, vtext(d.name.kana, 13pt, col("paperhi"), gap: 0pt)))))

// band 1: who he is, the three numbers
#place(top + left, dx: -10mm, dy: 206mm, mist(204mm, 60mm, pad(left: 10mm, grid(columns: (1fr, 42mm), column-gutter: 6mm, {
  text(size: 32pt, weight: 900, fill: col("prussian"), d.name.el)
  v(-3mm)
  text(size: 11pt, weight: 800, tracking: 0.08em, fill: col("ver"), d.title.caps)
  h(2mm)
  text(size: 11pt, weight: 800, tracking: 0.08em, fill: col("prussian"), d.title.specialty_caps)
  v(0.4mm)
  set par(leading: 0.48em)
  text(size: 10pt, d.profile)
  v(0.2mm)
  let e = d.experience.first()
  [#lab[ΣΗΜΕΡΑ] #h(1mm) #text(weight: 800)[#e.role], #text(weight: 700, fill: col("blue"))[#e.company, #e.city, #e.from–]]
}, {
  set align(center)
  v(0.6mm)
  for (n, l) in ((str(trips.len()), "ταξίδια στην Ιαπωνία"), (str(jdays), "ημέρες, 2018–2026"), ("N4", "JLPT, 12/2024")) {
    text(size: 23pt, weight: 900, fill: col("prussian"), n)
    v(-4.6mm)
    text(size: 8.2pt, weight: 700, fill: col("ver"), l)
    v(-0.2mm)
  }
}))))

// band 2: how to reach him
#place(top + left, dx: 52mm, dy: 273mm, mist(170mm, 15mm, align(horizon, {
  set text(size: 10pt)
  [#text(weight: 800)[#d.contact.city] #h(4mm) #d.contact.phone #h(4mm) #d.contact.email #h(4mm) #text(fill: col("blue"), d.contact.link)]
})))
#place(bottom + left, dx: 3mm, dy: -2mm, text(size: 5pt, fill: col("pale"))[Φανταστικό πρόσωπο · σχέδιο CVgen · 1/2])

#pagebreak()

// =========================== PAGE 2 ===========================
#place(top + left, lake-page)
#place(top + left, dx: 186mm, dy: 0mm, box(width: 16mm, height: 52mm, fill: col("ochre"), stroke: 1.1pt + col("sumi"), inset: 1.4pt,
  box(width: 100%, height: 100%, stroke: 0.45pt + col("sumi"), align(center + horizon, vtext("日本の旅", 20pt, col("sumi"))))))
#place(top + left, dx: 175.5mm, dy: 0mm, box(width: 9mm, height: 52mm, fill: col("ver"), stroke: 1pt + col("sumi"), inset: 1.2pt,
  box(width: 100%, height: 100%, stroke: 0.4pt + col("sumi"), align(center + horizon, vtext(d.name.kana, 10.6pt, col("paperhi"), gap: 0pt)))))

// band A: the five journeys, each under its season, with the name as its title
#place(top + left, dx: -8mm, dy: 66mm, mist(226mm, 47mm, pad(left: 10mm, right: 12mm, {
  text(size: 17pt, weight: 900, fill: col("prussian"), d.name.el)
  h(3mm)
  text(size: 9.4pt, weight: 800, tracking: 0.08em, fill: col("ver"))[ΠΕΝΤΕ ΤΑΞΙΔΙΑ ΣΤΗΝ ΙΑΠΩΝΙΑ, #trips.first().year–#trips.last().year]
  v(-0.6mm)
  grid(columns: (1fr,) * 5, column-gutter: 3.4mm,
    ..trips.map(t => {
      set par(leading: 0.4em)
      box(width: 8mm, height: 8mm, fill: rgb(season-col.at(t.season)), radius: 4mm, align(center + horizon, text(font: kanji, weight: 800, size: 13pt, fill: col("paperhi"), season-kanji.at(t.season))))
      h(1.6mm)
      box(baseline: -1.4mm, text(size: 13pt, weight: 900, fill: col("ver"), str(t.days)) + text(size: 8.4pt, weight: 700, fill: col("ver"), " ημ."))
      linebreak()
      text(weight: 800, fill: col("prussian"), t.when)
      linebreak()
      text(size: 9.6pt, t.places.join(", "))
      linebreak()
      text(size: 8pt, weight: 800, tracking: 0.04em, fill: (if t.kind == "colead" { col("ver") } else { col("blue") }), caps(t.kind_el))
    }))
})))

// band B: the work
#place(top + left, dx: -12mm, dy: 119mm, mist(206mm, 43mm, pad(left: 12mm, grid(columns: (1fr, 50mm), column-gutter: 6mm, {
  set par(leading: 0.44em)
  let e = d.experience.first()
  lab[ΕΜΠΕΙΡΙΑ · ΣΗΜΕΡΑ]
  linebreak()
  text(weight: 800, e.role)
  h(1fr)
  text(weight: 700, fill: col("ver"), e.from + "–" + e.to)
  linebreak()
  text(weight: 700, fill: col("blue"), e.company + ", " + e.city)
  v(0.4mm)
  set text(size: 10pt)
  for p in e.points { grid(columns: (3mm, 1fr), text(fill: col("ver"), "–"), p) }
}, {
  set par(leading: 0.44em)
  let e = d.experience.at(1)
  lab[ΠΡΙΝ]
  linebreak()
  text(weight: 800, e.role)
  linebreak()
  text(weight: 700, fill: col("blue"), e.company + ", " + e.city)
  linebreak()
  text(weight: 700, fill: col("ver"), e.from + "–" + e.to)
  linebreak()
  text(size: 10pt, e.points.first())
}))))

// band C: the groups, the languages and papers
#place(top + left, dx: 14mm, dy: 167mm, mist(210mm, 51mm, pad(right: 12mm, grid(columns: (84mm, 1fr), column-gutter: 6mm, {
  lab[ΟΜΑΔΕΣ ΠΟΥ ΣΥΝΟΔΕΥΣΕ]
  set text(size: 10pt)
  table(columns: (14mm, 1fr, 9mm, 7mm), stroke: none, inset: (x: 0.6mm, top: 0.5mm, bottom: 1.3mm),
    ..d.groups.map(g => (g.date, (if g.japan { text(weight: 800, fill: col("ver"))[Ιαπωνία, #lower(g.role)] } else { [#g.where] }), align(right, str(g.pax)), align(right, str(g.days)))).flatten(),
    table.hline(stroke: 0.4pt + col("sumi")),
    [], text(weight: 800)[#d.groups.len() ομάδες · άτομα, ημέρες], align(right, text(weight: 800, str(gpax))), align(right, text(weight: 800, str(d.groups.map(g => g.days).sum()))))
}, {
  set par(leading: 0.44em)
  lab[ΓΛΩΣΣΕΣ]
  linebreak()
  for l in d.languages [#text(weight: 800, l.name) #l.level \ ]
  v(0.4mm)
  lab[ΠΙΣΤΟΠΟΙΗΣΕΙΣ · ΣΠΟΥΔΕΣ]
  linebreak()
  set text(size: 10pt)
  [*Πρώτες Βοήθειες & ΚΑΡΠΑ/AED*, έως 03/2028 \ ]
  for e in d.education [*#e.title*, #e.years \ ]
}))))

// band D: in Japan, on the road, when, and an offer
#place(top + left, dx: -10mm, dy: 223mm, mist(214mm, 41mm, pad(left: 10mm, grid(columns: (1fr, 1fr, 50mm), column-gutter: 5mm, {
  set par(leading: 0.42em)
  lab[ΣΤΗΝ ΙΑΠΩΝΙΑ]
  linebreak()
  text(size: 9.8pt, d.knowhow.join(" · "))
}, {
  set par(leading: 0.42em)
  lab[ΣΤΗ ΣΥΝΟΔΕΙΑ]
  linebreak()
  text(size: 9.8pt, d.operations.join(" · "))
}, {
  set par(leading: 0.42em)
  lab[ΔΙΑΘΕΣΙΜΟΤΗΤΑ]
  linebreak()
  text(size: 9.8pt, d.availability.join(" · "))
}))))

// the offer, and the contacts along the foot, over the bridge
#place(bottom + left, block(width: 210mm, height: 6.6mm, fill: col("sumi"), inset: (x: 10mm), align(horizon, {
  set text(size: 8.6pt, fill: col("paperhi"))
  [#text(weight: 800)[#d.name.el]#h(1fr)#d.contact.phone#h(1fr)#d.contact.email#h(1fr)#text(fill: col("ochre"), weight: 700)[ΠΡΟΤΑΣΗ: δωρεάν βραδιά ενημέρωσης για την Ιαπωνία]#h(1fr)#text(size: 5pt, fill: col("pale"))[Φανταστικό πρόσωπο · σχέδιο CVgen · 2/2]]
})))
