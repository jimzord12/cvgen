// Woodblock Road, Safe tier, Spacious density (two pages). Idea run 2026-09-29 (magazine-editor).
// The calm version given room: a taller mounted print strip across page 1, a
// conventional two-column CV at 10 pt, every Japan trip under its season
// kanji; page 2 carries a second, upright print (a torii road the group is
// about to climb) beside the rest of the record. Fictional data: sample.json
// in the style folder.
//
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path design-concepts/fonts design-concepts/2026-09-29-woodblock-road/spacious/safe/spacious-safe.typ design-concepts/2026-09-29-woodblock-road/spacious/safe/spacious-safe.pdf

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

#set text(size: 10.2pt)
#set par(leading: 0.55em, spacing: 0.8em)

// ---- page 1: the mounted print strip, given more height ----------------------------
#let strip = {
  let W = 174
  let H = 68
  let s = "<defs>"
  s += "<linearGradient id='sky' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#" + C.night + "'/><stop offset='0.22' stop-color='#" + C.prussian + "'/><stop offset='0.55' stop-color='#7d97c6'/><stop offset='0.85' stop-color='#efe3c8'/></linearGradient>"
  s += "<linearGradient id='fj' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#4a6ba3'/><stop offset='1' stop-color='#" + C.prussian + "'/></linearGradient>"
  s += "<clipPath id='fjc'><path d='M76,53 Q114,45 122,13 L129,13 Q136,45 178,53 Z'/></clipPath>"
  s += seigaiha("sg", 1.8, C.prussian, "8fa8d0")
  s += "</defs>"
  s += "<rect width='" + str(W) + "' height='" + str(H) + "' fill='url(#sky)'/>"
  s += "<circle cx='98' cy='20' r='8' fill='#" + C.ver + "'/>"
  // a flight arriving from the west
  s += "<path d='M30,24 Q56,8 88,9.5' fill='none' stroke='#" + C.paperhi + "' stroke-width='0.3' stroke-dasharray='1.2 1' stroke-opacity='0.8'/>"
  s += "<g transform='translate(90.5,9.2) rotate(4) scale(1.15)' fill='#" + C.paperhi + "'><path d='M-3.2,0 L3.4,0 Q4.4,0.3 3.4,0.6 L-3.2,0.6 Z'/><path d='M0.6,0.3 L-1.4,-2.6 L-0.5,-2.6 L2.0,0.3 Z'/><path d='M0.6,0.3 L-1.4,3.0 L-0.5,3.0 L2.0,0.4 Z'/><path d='M-3.2,0.3 L-4.0,-1.3 L-3.4,-1.3 L-2.4,0.3 Z'/></g>"
  s += "<path d='M0,47 Q14,39 28,43 Q44,36 60,44 Q74,41 90,49 L90,54 L0,54 Z' fill='#" + C.hill + "'/>"
  s += "<path d='M76,53 Q114,45 122,13 L129,13 Q136,45 178,53 Z' fill='url(#fj)' stroke='#" + C.night + "' stroke-width='0.3'/>"
  s += "<g clip-path='url(#fjc)'><path d='M100,5 L150,5 L137,25 L134.8,23.6 L133.4,28 L131.4,23.4 L129.6,29 L127.6,23.8 L125.8,28 L123.6,23 L121.4,26 L100,26 Z' fill='#" + C.paperhi + "'/>"
  for (x1, x2) in ((123, 106), (125.5, 120), (127.5, 136), (129.5, 158)) {
    s += "<path d='M" + str(x1) + ",27 Q" + str((x1 + x2) / 2) + ",41 " + str(x2) + ",53' fill='none' stroke='#6d8cc0' stroke-width='0.3'/>"
  }
  s += "</g>"
  s += kasumi(56, 36, 124, 4)
  s += kasumi(-8, 27, 46, 3.4, op: 0.9)
  s += kasumi(128, 13, 50, 2.8, op: 0.55)
  // near hills with a shinkansen on its viaduct
  s += "<path d='M34,54 Q64,48 94,52 Q128,47 174,51 L174,56 L34,56 Z' fill='#" + C.green + "'/>"
  s += "<line x1='96' y1='52.6' x2='174' y2='52.6' stroke='#" + C.sumi + "' stroke-width='0.3'/>"
  for i in range(0, 14) { s += "<line x1='" + str(98 + i * 6) + "' y1='52.6' x2='" + str(98 + i * 6) + "' y2='56' stroke='#" + C.sumi + "' stroke-width='0.25'/>" }
  s += "<path d='M112,52.4 L150,52.4 Q158,52.4 161,51 Q155,48.8 147,48.6 L112,48.6 Z' fill='#" + C.paperhi + "' stroke='#" + C.sumi + "' stroke-width='0.25'/>"
  s += "<line x1='112' y1='51.1' x2='157' y2='51.1' stroke='#" + C.prussian + "' stroke-width='0.45'/>"
  s += "<line x1='114' y1='49.9' x2='146' y2='49.9' stroke='#" + C.prussian + "' stroke-width='0.5' stroke-dasharray='1.1 0.6'/>"
  s += "<rect x='0' y='55.5' width='" + str(W) + "' height='" + str(H - 55.5) + "' fill='url(#sg)'/>"
  // the group on the shore road, the leader's flag up front
  s += "<rect x='0' y='53.6' width='94' height='1.3' fill='#" + C.wood + "'/>"
  let coats = (C.blue, C.green, "8a5a3c", C.prussian, C.ochre, "6b4f7a", C.blue, "8a5a3c")
  let accs = ("case", none, "pack", "case", none, "case", "pack", none)
  for (i, x) in (14, 20, 26, 32, 38, 44, 50, 56).enumerate() {
    s += walker(x, 53.6, coats.at(i), acc: accs.at(i), hat: ("brim", "kasa").at(calc.rem(i, 2)), s: 0.8)
  }
  s += walker(65, 53.6, C.ver, acc: "flag", hat: "brim", s: 0.88)
  svg(s, "0 0 " + str(W) + " " + str(H), 174mm)
}

// ---- page 2: an upright pillar print, the torii road --------------------------------
#let torii(cx, yb, sc) = {
  let st = " stroke='#" + C.sumi + "' stroke-width='0.3'"
  let g = "<g transform='translate(" + f(cx) + "," + f(yb) + ") scale(" + f(sc) + ")'>"
  g += "<path d='M-10.4,0 L-7.9,0 L-8.3,-24 L-10,-24 Z' fill='#" + C.ver + "'" + st + "/>"
  g += "<path d='M10.4,0 L7.9,0 L8.3,-24 L10,-24 Z' fill='#" + C.ver + "'" + st + "/>"
  g += "<rect x='-10.6' y='-1.8' width='2.9' height='1.8' fill='#" + C.sumi + "'/><rect x='7.7' y='-1.8' width='2.9' height='1.8' fill='#" + C.sumi + "'/>"
  g += "<rect x='-13.2' y='-19.8' width='26.4' height='1.9' fill='#" + C.ver + "'" + st + "/>"
  g += "<rect x='-0.9' y='-24' width='1.8' height='4.4' fill='#" + C.ver + "'" + st + "/>"
  g += "<path d='M-15.2,-24 L15.2,-24 L14.8,-25.8 L-14.8,-25.8 Z' fill='#" + C.ver + "'" + st + "/>"
  g += "<path d='M-17.4,-28.8 Q0,-26.2 17.4,-28.8 L16.4,-25.6 Q0,-24.6 -16.4,-25.6 Z' fill='#" + C.sumi + "'/>"
  g + "</g>"
}
#let cedar(x, yb, h, w, c) = "<path d='M" + f(x - w / 2) + "," + f(yb) + " L" + f(x) + "," + f(yb - h) + " L" + f(x + w / 2) + "," + f(yb) + " Z' fill='#" + c + "'/><path d='M" + f(x - w * 0.38) + "," + f(yb - h * 0.42) + " L" + f(x) + "," + f(yb - h * 1.02) + " L" + f(x + w * 0.38) + "," + f(yb - h * 0.42) + " Z' fill='#" + c + "'/>"

#let pillar(W, H) = {
  let s = "<defs><linearGradient id='psky' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#" + C.night + "'/><stop offset='0.14' stop-color='#" + C.prussian + "'/><stop offset='0.32' stop-color='#7d97c6'/><stop offset='0.5' stop-color='#efe3c8'/><stop offset='1' stop-color='#" + C.paper + "'/></linearGradient></defs>"
  s += "<rect width='" + str(W) + "' height='" + str(H) + "' fill='url(#psky)'/>"
  // far range and mist
  s += "<path d='M0,66 Q10,55 20,61 Q32,50 44,59 Q50,56 " + str(W) + ",60 L" + str(W) + ",76 L0,76 Z' fill='#" + C.hill + "'/>"
  s += kasumi(-8, 62, 42, 3.4, op: 0.92)
  s += kasumi(22, 38, 44, 2.8, op: 0.55)
  // cedar forest on both sides, far layer
  for (x, h) in ((3, 20), (9, 24), (15, 18), (40, 19), (46, 25), (52, 21)) { s += cedar(x, 84, h, 9, C.pinehi) }
  s += "<rect x='0' y='80' width='" + str(W) + "' height='" + str(H - 80) + "' fill='#" + C.pine + "'/>"
  // the stone stair, wide at the foot, narrow at the top
  let top = 78
  let xl(y) = 22 - 21 * (y - top) / (H - top)
  let xr(y) = 32 + 21 * (y - top) / (H - top)
  s += "<path d='M22," + str(top) + " L32," + str(top) + " L53," + str(H) + " L1," + str(H) + " Z' fill='#e6d9bb'/>"
  for k in range(0, 25, step: 2) {
    let y1 = top + (H - top) * calc.pow(k / 25, 1.7)
    let y2 = top + (H - top) * calc.pow((k + 1) / 25, 1.7)
    s += "<path d='M" + f(xl(y1)) + "," + f(y1) + " L" + f(xr(y1)) + "," + f(y1) + " L" + f(xr(y2)) + "," + f(y2) + " L" + f(xl(y2)) + "," + f(y2) + " Z' fill='#d8c8a2'/>"
  }
  s += "<path d='M22," + str(top) + " L1," + str(H) + " M32," + str(top) + " L53," + str(H) + "' stroke='#" + C.wood + "' stroke-width='0.6' fill='none'/>"
  for k in range(1, 26) {
    let y = top + (H - top) * calc.pow(k / 25, 1.7)
    s += "<line x1='" + f(xl(y)) + "' y1='" + f(y) + "' x2='" + f(xr(y)) + "' y2='" + f(y) + "' stroke='#b9a47a' stroke-width='0.3'/>"
  }
  // the gates, far to near
  for (yb, sc) in ((84, 0.26), (91, 0.33), (100, 0.42), (112, 0.53), (127, 0.66), (146, 0.82)) { s += torii(27, yb, sc) }
  // near cedars framing the view
  for (x, yb, h) in ((0, 130, 40), (5, 150, 34), (54, 128, 42), (49, 152, 30)) { s += cedar(x, yb, h, 14, C.pine) }
  s += kasumi(-12, 104, 30, 3.6, op: 0.96)
  s += kasumi(38, 118, 30, 3.2, op: 0.96)
  // a full moon behind the blossom branch
  s += "<circle cx='35' cy='24' r='12' fill='#" + C.paperhi + "' fill-opacity='0.93'/>"
  // blossom branch across the top
  s += "<path d='M-2,15 Q10,19 20,16 Q28,14 34,21' fill='none' stroke='#" + C.wood + "' stroke-width='1.6' stroke-linecap='round'/>"
  s += "<path d='M12,18 Q16,24 14.5,30' fill='none' stroke='#" + C.wood + "' stroke-width='0.7' stroke-linecap='round'/>"
  for (x, y) in ((3, 16.6), (7, 18.4), (11, 17.6), (15.5, 16.4), (19.5, 15.4), (24, 15.6), (28, 16.6), (31.5, 19.4), (14, 23), (15.2, 27.5), (9, 21), (22, 19)) {
    s += "<circle cx='" + str(x) + "' cy='" + str(y) + "' r='1.55' fill='#fbe3e1' stroke='#c46c6c' stroke-width='0.2'/><circle cx='" + str(x) + "' cy='" + str(y) + "' r='0.35' fill='#" + C.ver + "'/>"
  }
  // the group arriving at the foot of the road, the leader in front
  s += "<rect x='0' y='" + str(H - 4.6) + "' width='" + str(W) + "' height='4.6' fill='#d6c7a3'/>"
  s += "<line x1='0' y1='" + str(H - 4.6) + "' x2='" + str(W) + "' y2='" + str(H - 4.6) + "' stroke='#" + C.wood + "' stroke-width='0.4'/>"
  let coats = (C.blue, C.green, "8a5a3c", C.prussian, C.ochre, "6b4f7a")
  let accs = ("case", none, "pack", "case", none, "pack")
  for (i, x) in (5, 10.5, 16, 21.5, 27, 32.5).enumerate() {
    s += walker(x, H - 1.2, coats.at(i), acc: accs.at(i), hat: ("brim", "kasa").at(calc.rem(i, 2)), s: 0.84)
  }
  s += walker(40, H - 1.2, C.ver, acc: "flag", hat: "brim", s: 0.92)
  svg(s, "0 0 " + str(W) + " " + str(H), W * 1mm)
}

// ---- shared furniture ------------------------------------------------------------------
#let rule-double(w) = stack(spacing: 0.7pt, line(length: w, stroke: 0.8pt + col("sumi")), line(length: w, stroke: 0.3pt + col("sumi")))
#let head(title) = block(above: 6.4mm, below: 2.6mm, {
  box(width: 2.9mm, height: 2.9mm, fill: col("ver"), baseline: -0.2mm)
  h(2mm)
  text(size: 13pt, weight: 800, fill: col("prussian"), title)
  v(-1.6mm)
  line(length: 100%, stroke: 0.4pt + col("sumi"))
})
#let seal(size) = box(baseline: -0.6mm, box(width: size, height: size, fill: col("ver"), radius: 1pt,
  align(center + horizon, text(font: kanji, weight: 800, size: size * 1.75 / 1mm * 1pt, fill: col("paperhi"), "旅"))))
#let dash(body) = grid(columns: (3.6mm, 1fr), text(fill: col("ver"), "–"), body)
#let dot(body) = grid(columns: (3.6mm, 1fr), text(fill: col("ver"), "·"), body)
#let season-kanji = (spring: "春", summer: "夏", autumn: "秋", winter: "冬")
#let season-col = (spring: "c9706c", summer: C.blue, autumn: "b8452c", winter: C.night)
#let foot-band = {
  let s = "<defs>" + seigaiha("fs", 2.2, C.prussian, "8fa8d0") + "</defs><rect width='210' height='9' fill='url(#fs)'/>"
  svg(s, "0 0 210 9", 210mm)
}
#let footer(body) = {
  place(bottom + left, foot-band)
  place(bottom + left, dy: -9mm, line(length: 210mm, stroke: 0.9pt + col("sumi")))
  place(bottom + left, dx: 18mm, dy: -12.4mm, block(width: 174mm, text(size: 9pt, fill: col("prussian"), body)))
}
#let X = 18mm

// =========================== PAGE 1 ===========================
#place(top + left, dx: 16.2mm, dy: 14.2mm, rect(width: 177.6mm, height: 71.6mm, fill: col("paperhi"), stroke: 0.9pt + col("sumi")))
#place(top + left, dx: X, dy: 16mm, box(stroke: 0.35pt + col("sumi"), strip))
#place(top + left, dx: 179mm, dy: 21mm, box(width: 10mm, height: 44mm, fill: col("ochre"), stroke: 0.8pt + col("sumi"), inset: 1pt,
  box(width: 100%, height: 100%, stroke: 0.35pt + col("sumi"), align(center + horizon, vtext("日本の旅", 14.5pt, col("sumi"))))))

// identity
#place(top + left, dx: X, dy: 94mm, block(width: 134mm, {
  set par(leading: 0.34em)
  text(size: 38pt, weight: 900, fill: col("prussian"), d.name.el)
  h(3mm)
  seal(10mm)
  v(0.2mm)
  text(size: 11.6pt, weight: 700, tracking: 0.1em, fill: col("ver"), d.title.caps)
  linebreak()
  text(size: 11.6pt, weight: 700, tracking: 0.1em, fill: col("prussian"), d.title.specialty_caps)
  v(2.6mm)
  set text(size: 10pt)
  let sep = [#h(2.6mm)#text(fill: col("ver"), "◆")#h(2.6mm)]
  [#text(weight: 700)[#d.contact.city]#sep#d.contact.phone \ #d.contact.email#sep#text(fill: col("blue"), d.contact.link)]
}))
#place(top + left, dx: 157mm, dy: 92mm, box(stroke: 0.9pt + col("sumi"), inset: 1.4pt, fill: col("paperhi"),
  box(stroke: 0.35pt + col("sumi"), clip: true, width: 32mm, height: 39mm, image("../../portrait.jpg", width: 39mm))))
#place(top + left, dx: X, dy: 139mm, rule-double(174mm))

// main column: profile, experience, the Japan record
#place(top + left, dx: X, dy: 144mm, block(width: 110mm, {
  block(above: 0mm, text(size: 10.6pt, d.profile))
  head[Επαγγελματική εμπειρία]
  for e in d.experience {
    block(below: 3.2mm, {
      set par(leading: 0.46em)
      grid(columns: (1fr, auto), text(size: 11pt, weight: 800, e.role), text(weight: 700, fill: col("ver"), e.from + " – " + e.to))
      text(weight: 700, fill: col("blue"), e.company + ", " + e.city)
      v(0.6mm)
      for p in e.points { dash(p) }
    })
  }
  head[Διαθεσιμότητα]
  for k in d.availability { dot(k) }
}))
#place(top + left, dx: 138mm, dy: 144mm, block(width: 54mm, {
  block(above: 0mm, fill: col("paperhi"), stroke: 0.4pt + col("sumi"), inset: (x: 3.4mm, y: 3mm), width: 100%, {
    for (n, l) in ((str(trips.len()), [ταξίδια στην Ιαπωνία]), (str(jdays), [ημέρες, #trips.first().year–#trips.last().year]), ("N4", [JLPT, 12/2024])) {
      block(below: 1.6mm, grid(columns: (21mm, 1fr), align: horizon,
        text(size: 25pt, weight: 900, fill: col("prussian"), n), text(size: 9pt, weight: 700, fill: col("ver"), l)))
    }
  })
  head[Γλώσσες]
  for l in d.languages {
    block(below: 1.4mm, grid(columns: (19mm, 1fr), text(weight: 800, l.name), [#l.level#if "note" in l [ \ #text(size: 8.8pt, fill: col("blue"), l.note)]]))
  }
  head[Πιστοποιήσεις]
  for c in d.certificates [#text(weight: 800, c.title) \ #text(size: 9pt, fill: col("blue"), c.issuer + ", " + c.valid)]
  head[Στην Ιαπωνία]
  set par(leading: 0.46em)
  for k in d.knowhow { block(below: 2mm, dot(k)) }
}))

#footer[#text(weight: 800, fill: col("ver"), "ΣΥΝΕΧΕΙΑ")#h(2mm)η Ιαπωνία ταξίδι προς ταξίδι, οι ομάδες, οι σπουδές και μια πρόταση για το γραφείο σας #h(1mm) #text(fill: col("ver"), "→")]
#place(bottom + right, dx: -2mm, dy: -10mm, text(size: 5pt, fill: col("blue"))[Φανταστικό πρόσωπο · σχέδιο CVgen · 1/2])

#pagebreak()

// =========================== PAGE 2 ===========================
// running head: the name as on page 1, a small title cartouche at the right
#place(top + left, dx: X, dy: 15mm, block(width: 150mm, {
  set par(leading: 0.34em)
  text(size: 26pt, weight: 900, fill: col("prussian"), d.name.el)
  h(2.4mm)
  seal(7.6mm)
  linebreak()
  text(size: 10pt, weight: 700, tracking: 0.1em, fill: col("ver"), d.title.caps)
  text(size: 10pt, weight: 700, tracking: 0.1em, fill: col("prussian"), [ · ] + d.title.specialty_caps)
}))
#place(top + left, dx: 181mm, dy: 12mm, box(width: 8.4mm, height: 27mm, fill: col("ochre"), stroke: 0.8pt + col("sumi"), inset: 1pt,
  box(width: 100%, height: 100%, stroke: 0.35pt + col("sumi"), align(center + horizon, vtext("日本の旅", 9.6pt, col("sumi"))))))
#place(top + left, dx: X, dy: 43mm, rule-double(174mm))

// the second print, upright in the side column, with its own cartouche
#place(top + left, dx: 136.6mm, dy: 49.4mm, rect(width: 56.8mm, height: 200.8mm, fill: col("paperhi"), stroke: 0.9pt + col("sumi")))
#place(top + left, dx: 138mm, dy: 50.8mm, box(stroke: 0.35pt + col("sumi"), pillar(54, 198)))
#place(top + left, dx: 182.6mm, dy: 54mm, box(width: 7.6mm, height: 34mm, fill: col("ochre"), stroke: 0.8pt + col("sumi"), inset: 0.9pt,
  box(width: 100%, height: 100%, stroke: 0.35pt + col("sumi"), align(center + horizon, vtext("鳥居の道", 10pt, col("sumi"))))))
#place(top + left, dx: 138mm, dy: 253.5mm, block(width: 54mm, {
  set par(leading: 0.4em)
  text(size: 8.6pt, style: "italic", fill: col("blue"))[Δεύτερη όψη: ο δρόμος των πυλών, η ομάδα πίσω από τη σημαία του αρχηγού.]
}))

// main column: groups, education, on the road, availability
#place(top + left, dx: X, dy: 44mm, block(width: 112mm, {
  head[Η Ιαπωνία, ταξίδι προς ταξίδι]
  table(
    columns: (10.5mm, 31mm, 1fr, 14mm), stroke: none, inset: (x: 1.1mm, y: 1.9mm), align: (center + horizon, left + horizon, left + horizon, right + horizon),
    table.hline(stroke: 0.4pt + col("sumi")),
    ..trips.map(t => (
      box(width: 8mm, height: 8mm, fill: rgb(season-col.at(t.season)), radius: 1pt, align(center + horizon, text(font: kanji, weight: 800, size: 14pt, fill: col("paperhi"), season-kanji.at(t.season)))),
      [#text(weight: 800, t.when) \ #text(size: 8.6pt, tracking: 0.03em, fill: (if t.kind == "colead" { col("ver") } else { col("blue") }), weight: 700, caps(t.kind_el))],
      t.places.join(", "),
      text(size: 11pt, weight: 800, fill: col("prussian"), str(t.days) + " ημ."),
    )).flatten(),
    table.hline(stroke: 0.4pt + col("sumi")),
  )
  head[Ομάδες που συνόδευσε]
  table(
    columns: (16mm, 1fr, 13mm, 12mm, 23mm), stroke: none, inset: (x: 1.1mm, y: 1.7mm),
    fill: (_, y) => if calc.odd(y) and y <= d.groups.len() { col("paperhi") } else { none },
    ..("Πότε", "Προορισμός", "Άτομα", "Ημ.", "Ρόλος").map(h => text(size: 9pt, weight: 700, fill: col("blue"), h)),
    table.hline(stroke: 0.4pt + col("sumi")),
    ..d.groups.map(g => (g.date, (if g.japan { text(weight: 800, fill: col("ver"), g.where) } else { g.where }), str(g.pax), str(g.days), g.role)).flatten(),
    table.hline(stroke: 0.4pt + col("sumi")),
    [], text(weight: 800)[#d.groups.len() ομάδες], text(weight: 800, str(gpax)), text(weight: 800, str(d.groups.map(g => g.days).sum())), [],
  )
  head[Σπουδές]
  set par(leading: 0.46em)
  for e in d.education {
    block(below: 3.4mm)[#grid(columns: (1fr, auto), column-gutter: 2mm, text(weight: 800, e.title), text(weight: 700, fill: col("ver"), e.years)) #v(-1.6mm) #text(size: 9.4pt, fill: col("blue"), e.school)]
  }
  head[Στη συνοδεία]
  for k in d.operations { block(below: 2.2mm, dot(k)) }
  v(5mm)
  block(width: 100%, fill: col("paperhi"), stroke: 0.9pt + col("sumi"), inset: 1.3pt, block(width: 100%, stroke: 0.35pt + col("sumi"), inset: (x: 4mm, y: 3.2mm),
    grid(columns: (12mm, 1fr), column-gutter: 4mm, align: horizon, seal(12mm), {
      text(size: 9pt, weight: 800, tracking: 0.1em, fill: col("ver"))[ΠΡΟΤΑΣΗ]
      linebreak()
      text(size: 11pt, weight: 700, fill: col("prussian"), d.offer)
    })))
}))

#footer[#text(weight: 800)[#d.name.el]#h(2.4mm)#text(fill: col("ver"), "◆")#h(2.4mm)#d.contact.phone#h(2.4mm)#text(fill: col("ver"), "◆")#h(2.4mm)#d.contact.email#h(2.4mm)#text(fill: col("ver"), "◆")#h(2.4mm)#text(fill: col("blue"), d.contact.link)]
#place(bottom + right, dx: -2mm, dy: -10mm, text(size: 5pt, fill: col("blue"))[Φανταστικό πρόσωπο · σχέδιο CVgen · 2/2])
