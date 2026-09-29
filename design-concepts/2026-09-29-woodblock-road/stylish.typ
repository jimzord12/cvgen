// Woodblock Road, Stylish tier. Idea run 2026-09-29 (magazine-editor).
// The CV opens as a travel print: flat colour, bokashi sky, kasumi mist bands,
// a title cartouche, and a modern tour group crossing a bridge behind its
// leader's flag. The career below is told as a numbered series of small views.
// Fictional data: sample.json in this folder.
//
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path design-concepts/fonts design-concepts/2026-09-29-woodblock-road/stylish.typ design-concepts/2026-09-29-woodblock-road/stylish.pdf

#let d = json("sample.json")

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

// ---- the header print ------------------------------------------------------
#let print-h = 110
#let header-print = {
  let s = "<defs>"
  s += "<linearGradient id='sky' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#" + C.night + "'/><stop offset='0.18' stop-color='#" + C.prussian + "'/><stop offset='0.45' stop-color='#6f8cc0'/><stop offset='0.72' stop-color='#efe3c8'/><stop offset='1' stop-color='#" + C.paper + "'/></linearGradient>"
  s += "<linearGradient id='fj' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#4a6ba3'/><stop offset='1' stop-color='#" + C.prussian + "'/></linearGradient>"
  s += "<clipPath id='fjc'><path d='M78,92 Q128,76 144,32 L154,32 Q170,76 222,92 Z'/></clipPath>"
  s += seigaiha("sg", 3.2, C.prussian, "8fa8d0")
  s += "</defs>"
  // sky
  s += "<rect x='0' y='0' width='210' height='" + str(print-h) + "' fill='url(#sky)'/>"
  // sun
  s += "<circle cx='116' cy='30' r='11.5' fill='#" + C.ver + "'/>"
  // flight: from the west, toward the mountain
  s += "<path d='M70,26 Q92,14 126,15' fill='none' stroke='#" + C.paperhi + "' stroke-width='0.35' stroke-dasharray='1.4 1.1' stroke-opacity='0.8'/>"
  s += "<g transform='translate(128,14.6) rotate(4)' fill='#" + C.paperhi + "'><path d='M-3.2,0 L3.4,0 Q4.4,0.3 3.4,0.6 L-3.2,0.6 Z'/><path d='M0.6,0.3 L-1.4,-2.6 L-0.5,-2.6 L2.0,0.3 Z'/><path d='M0.6,0.3 L-1.4,3.0 L-0.5,3.0 L2.0,0.4 Z'/><path d='M-3.2,0.3 L-4.0,-1.3 L-3.4,-1.3 L-2.4,0.3 Z'/></g>"
  // distant range
  s += "<path d='M0,86 Q14,76 28,82 Q44,72 60,82 Q74,78 90,86 L90,98 L0,98 Z' fill='#" + C.hill + "'/>"
  // Fuji
  s += "<path d='M78,92 Q128,76 144,32 L154,32 Q170,76 222,92 Z' fill='url(#fj)' stroke='#" + C.night + "' stroke-width='0.35'/>"
  s += "<g clip-path='url(#fjc)'><path d='M120,20 L180,20 L166,50 L162.5,48 L160.5,55 L157.5,47.5 L155,57 L152,48.5 L149.5,54.5 L146.5,47 L144,53 L141,46.5 L138.5,51.5 L134,49 L120,50 Z' fill='#" + C.paperhi + "'/>"
  for (x1, x2) in ((146, 128), (150, 146), (152, 162), (156, 184)) {
    s += "<path d='M" + str(x1) + ",52 Q" + str((x1 + x2) / 2) + ",70 " + str(x2) + ",92' fill='none' stroke='#6d8cc0' stroke-width='0.35'/>"
  }
  s += "</g>"
  // near hills and shinkansen viaduct
  s += "<path d='M40,96 Q70,86 104,92 Q140,84 176,92 Q196,88 210,90 L210,100 L40,100 Z' fill='#" + C.green + "'/>"
  s += "<line x1='0' y1='93.4' x2='124' y2='93.4' stroke='#" + C.sumi + "' stroke-width='0.35'/>"
  for i in range(0, 21) { s += "<line x1='" + str(i * 6 + 2) + "' y1='93.4' x2='" + str(i * 6 + 2) + "' y2='98' stroke='#" + C.sumi + "' stroke-width='0.3'/>" }
  s += "<path d='M46,93.2 L100,93.2 Q110,93.2 113,91.6 Q106,89.4 97,89.2 L46,89.2 Z' fill='#" + C.paperhi + "' stroke='#" + C.sumi + "' stroke-width='0.28'/>"
  s += "<line x1='46' y1='91.9' x2='109' y2='91.9' stroke='#" + C.prussian + "' stroke-width='0.55'/>"
  s += "<line x1='48' y1='90.5' x2='95' y2='90.5' stroke='#" + C.prussian + "' stroke-width='0.6' stroke-dasharray='1.3 0.7'/>"
  // mist bands
  s += kasumi(62, 70, 150, 6)
  s += kasumi(-10, 58, 60, 5)
  s += kasumi(160, 20, 60, 4.2, op: 0.55)
  // sea
  s += "<rect x='0' y='98' width='210' height='" + str(print-h - 98) + "' fill='url(#sg)'/>"
  // shore and pine on the left
  s += "<path d='M0,99 Q22,95 46,101 Q58,104 62," + str(print-h) + " L0," + str(print-h) + " Z' fill='#" + C.pine + "'/>"
  s += "<path d='M14," + str(print-h) + " Q10,96 22,86 Q30,79 26,70 Q34,76 30,84' fill='none' stroke='#" + C.wood + "' stroke-width='2.2' stroke-linecap='round'/>"
  s += "<path d='M22,86 Q34,84 44,78' fill='none' stroke='#" + C.wood + "' stroke-width='1.2' stroke-linecap='round'/>"
  for (cx, cy, rx, ry) in ((27, 69, 11, 3.2), (43, 77, 9, 2.6), (15, 80, 8, 2.4), (33, 61, 7, 2.2)) {
    s += "<ellipse cx='" + str(cx) + "' cy='" + str(cy) + "' rx='" + str(rx) + "' ry='" + str(ry) + "' fill='#" + C.pine + "'/>"
    s += "<ellipse cx='" + str(cx) + "' cy='" + f(cy - 0.9) + "' rx='" + f(rx * 0.8) + "' ry='" + f(ry * 0.45) + "' fill='#" + C.pinehi + "'/>"
  }
  // arched bridge with the group
  let yd(x) = 101 + 9 * calc.pow((x - 150) / 52, 2)
  let yr(x) = 94.5 + 8.5 * calc.pow((x - 150) / 50, 2)
  for x in (112, 150, 188) {
    s += "<line x1='" + str(x) + "' y1='" + f(yd(x) + 1) + "' x2='" + str(x) + "' y2='" + str(print-h) + "' stroke='#" + C.wood + "' stroke-width='1.1'/>"
  }
  s += "<path d='M98,110 Q150,92 202,110 L202,112.8 Q150,94.8 98,112.8 Z' fill='#" + C.wood + "'/>"
  // the group: followers then the leader at the front
  let xs = (116, 123, 130, 137, 144, 151, 158, 165)
  let coats = (C.blue, C.green, "8a5a3c", C.prussian, C.ochre, "6b4f7a", C.blue, "8a5a3c")
  let accs = ("case", none, "pack", "case", none, "case", "pack", none)
  let hats = ("brim", "kasa", "brim", "kasa", "brim", "kasa", "brim", "kasa")
  for (i, x) in xs.enumerate() { s += walker(x, yd(x), coats.at(i), acc: accs.at(i), hat: hats.at(i)) }
  s += walker(175, yd(175), C.ver, acc: "flag", hat: "brim", s: 1.08)
  s += "<path d='M100," + f(yr(100)) + " Q150,86 200," + f(yr(200)) + "' fill='none' stroke='#" + C.wood + "' stroke-width='0.7'/>"
  for x in range(102, 200, step: 8) {
    s += "<line x1='" + str(x) + "' y1='" + f(yr(x)) + "' x2='" + str(x) + "' y2='" + f(yd(x)) + "' stroke='#" + C.wood + "' stroke-width='0.5'/>"
  }
  // keyline at the print's lower edge
  s += "<rect x='0' y='" + f(print-h - 0.8) + "' width='210' height='0.8' fill='#" + C.sumi + "'/>"
  svg(s, "0 0 210 " + str(print-h), 210mm)
}

// vertical stack of CJK characters
#let vtext(s, size, fill, font: kanji, gap: 0.6pt) = stack(
  dir: ttb, spacing: gap,
  ..s.clusters().map(c => box(width: size * 1.05, align(center, text(font: font, size: size, fill: fill, weight: 800, c)))),
)

#let cartouche(body, w, h, ground) = box(
  width: w, height: h, fill: ground, stroke: 0.9pt + col("sumi"), inset: 1.3pt,
  box(width: 100%, height: 100%, stroke: 0.4pt + col("sumi"), align(center + horizon, body)),
)

// ---- page ------------------------------------------------------------------
#place(top + left, header-print)

// title cartouches (top right, as on a print)
#place(top + left, dx: 186mm, dy: 7mm, cartouche(vtext("日本の旅", 21pt, col("sumi")), 15mm, 50mm, col("ochre")))
#place(top + left, dx: 175.5mm, dy: 7mm, cartouche(vtext(d.name.kana, 10.5pt, col("paperhi"), gap: 0pt), 9mm, 50mm, col("ver")))

// portrait as an inset round picture
#place(top + left, dx: 14mm, dy: 14mm, {
  circle(radius: 27mm, fill: col("ochre"), stroke: 0.9pt + col("sumi"))
})
#place(top + left, dx: 16.4mm, dy: 16.4mm, circle(radius: 24.6mm, fill: none, stroke: 0.5pt + col("sumi")))
#place(top + left, dx: 17mm, dy: 17mm, box(width: 48mm, height: 48mm, radius: 24mm, clip: true, image("portrait.jpg", width: 48mm)))

// ---- name block ------------------------------------------------------------
#let trips = d.japan_trips
#let jdays = trips.map(t => t.days).sum()
#let gpax = d.groups.map(g => g.pax).sum()

// Greek all-caps drop the tonos (dialytika stays)
#let caps(s) = {
  let m = ("Ά": "Α", "Έ": "Ε", "Ή": "Η", "Ί": "Ι", "Ό": "Ο", "Ύ": "Υ", "Ώ": "Ω", "ΐ": "Ϊ", "ΰ": "Ϋ")
  upper(s).clusters().map(c => m.at(c, default: c)).join()
}

#let Y = (name: 113, rule: 137, prof: 140.5, views: 158.5, tiles: 165.5, bands: 205, cols: 227, foot: 282)

#place(top + left, dx: 14mm, dy: Y.name * 1mm, block(width: 132mm, {
  set par(leading: 0.3em)
  text(size: 40pt, weight: 900, fill: col("prussian"), tracking: -0.01em, d.name.el)
  h(3mm)
  box(baseline: -1mm, box(width: 11mm, height: 11mm, fill: col("ver"), radius: 1.2pt,
    align(center + horizon, text(font: kanji, weight: 800, size: 20pt, fill: col("paperhi"), "旅"))))
  v(-1mm)
  text(size: 11pt, weight: 700, tracking: 0.1em, fill: col("ver"), d.title.caps)
  text(size: 11pt, weight: 700, tracking: 0.1em, fill: col("prussian"), [ · ] + d.title.specialty_caps)
}))

#place(top + right, dx: -14mm, dy: (Y.name + 4) * 1mm, block(width: 52mm, {
  set align(right)
  set text(size: 8.6pt)
  set par(leading: 0.45em)
  [#text(weight: 700)[#d.contact.city] \
  #d.contact.phone \
  #d.contact.email \
  #text(fill: col("blue"), d.contact.link)]
}))

// ---- profile and the three numbers ----------------------------------------
#let rule-double(w) = stack(spacing: 0.7pt, line(length: w, stroke: 0.8pt + col("sumi")), line(length: w, stroke: 0.3pt + col("sumi")))

#place(top + left, dx: 14mm, dy: Y.rule * 1mm, rule-double(182mm))
#place(top + left, dx: 14mm, dy: Y.prof * 1mm, block(width: 114mm, text(size: 9.4pt, d.profile)))

#let bignum(n, label) = block(width: 21mm, {
  set align(center)
  text(size: 24pt, weight: 900, fill: col("prussian"), n)
  v(-4.6mm)
  text(size: 7.2pt, weight: 700, tracking: 0.06em, fill: col("ver"), caps(label))
})
#place(top + left, dx: 133mm, dy: (Y.prof - 0.5) * 1mm, box(width: 63mm, fill: col("paperhi"), stroke: 0.4pt + col("sumi"), inset: (x: 0mm, top: 1mm, bottom: 1.6mm), {
  grid(columns: 3, bignum(str(trips.len()), "ταξίδια"), bignum(str(jdays), "ημέρες"), bignum("N4", "JLPT"))
  v(-0.6mm)
  align(center, text(size: 7pt, fill: col("blue"))[στην Ιαπωνία, #trips.first().year–#trips.last().year · JLPT 12/2024])
}))

// ---- five views: the Japan record as a print series -------------------------
#let tile-svg(t, i) = {
  let s = "<defs>"
  let W = 34
  let H = 20
  if t.season == "spring" {
    s += "<linearGradient id='g" + str(i) + "' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#d98e8a'/><stop offset='0.6' stop-color='#" + C.sakura + "'/><stop offset='1' stop-color='#" + C.paperhi + "'/></linearGradient>"
  } else if t.season == "summer" {
    s += "<linearGradient id='g" + str(i) + "' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#" + C.blue + "'/><stop offset='0.7' stop-color='#" + C.pale + "'/><stop offset='1' stop-color='#" + C.paperhi + "'/></linearGradient>"
  } else if t.season == "autumn" {
    s += "<linearGradient id='g" + str(i) + "' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#b8452c'/><stop offset='0.6' stop-color='#" + C.ochre + "'/><stop offset='1' stop-color='#" + C.paperhi + "'/></linearGradient>"
  } else {
    s += "<linearGradient id='g" + str(i) + "' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#" + C.night + "'/><stop offset='0.7' stop-color='#" + C.hill + "'/><stop offset='1' stop-color='#" + C.paperhi + "'/></linearGradient>"
  }
  s += seigaiha("w" + str(i), 1.6, C.prussian, "8fa8d0")
  s += "</defs><rect width='34' height='20' fill='url(#g" + str(i) + ")'/>"
  if t.kind == "colead" {
    s += "<circle cx='9' cy='6' r='3' fill='#" + C.ver + "'/>"
    s += "<path d='M6,16 Q15,13 18,5.2 L20,5.2 Q23,13 34,15.5 L34,20 L6,20 Z' fill='#" + C.blue + "' stroke='#" + C.night + "' stroke-width='0.2'/>"
    s += "<path d='M16.8,8.6 L18,5.2 L20,5.2 L21.2,8.6 L20.2,7.8 L19.4,9.2 L18.6,7.6 L17.7,8.9 Z' fill='#" + C.paperhi + "'/>"
    s += "<rect x='0' y='16' width='34' height='4' fill='#" + C.green + "'/>"
    for (k, x) in (4, 7, 10, 13, 16, 19).enumerate() { s += walker(x, 19.4, (C.blue, C.ochre, C.prussian, C.green, C.blue, "8a5a3c").at(k), hat: "brim", s: 0.36) }
    s += walker(23, 19.4, C.ver, acc: "flag", hat: "brim", s: 0.42)
  } else if t.season == "spring" {
    // pagoda and a blossom branch
    let px = 22
    for k in range(5) {
      let y = 17 - k * 2.6
      let w = 7 - k * 0.9
      s += "<path d='M" + f(px - w / 2) + "," + f(y) + " L" + f(px + w / 2) + "," + f(y) + " L" + f(px + w / 2 - 1.1) + "," + f(y - 0.9) + " L" + f(px - w / 2 + 1.1) + "," + f(y - 0.9) + " Z' fill='#" + C.night + "'/>"
      s += "<rect x='" + f(px - w / 2 + 1.4) + "' y='" + f(y - 2.6) + "' width='" + f(w - 2.8) + "' height='1.7' fill='#" + C.prussian + "'/>"
    }
    s += "<line x1='22' y1='4' x2='22' y2='1' stroke='#" + C.night + "' stroke-width='0.35'/>"
    s += "<rect x='0' y='17' width='34' height='3' fill='#" + C.green + "'/>"
    s += "<path d='M0,2 Q6,4 12,3 Q15,2.5 17,5' fill='none' stroke='#" + C.wood + "' stroke-width='0.7'/>"
    for (x, y) in ((3, 3.4), (6, 4.1), (9, 3.6), (12, 3.2), (14.5, 3.6), (16.5, 5.2), (7.5, 5.6), (11, 5.1)) {
      s += "<circle cx='" + str(x) + "' cy='" + str(y) + "' r='1.05' fill='#fbe3e1' stroke='#c46c6c' stroke-width='0.15'/>"
    }
  } else if t.season == "summer" {
    s += "<circle cx='24' cy='7' r='3.4' fill='#" + C.ver + "'/>"
    s += "<path d='M0,12.5 Q6,10.5 12,12.4 L12,13 L0,13 Z' fill='#" + C.green + "'/>"
    s += "<rect x='0' y='12.8' width='34' height='7.2' fill='url(#w" + str(i) + ")'/>"
    s += "<path d='M19,12.2 L27,12.2 L26,13.2 L20,13.2 Z' fill='#" + C.wood + "'/><line x1='23' y1='12.2' x2='23' y2='8.6' stroke='#" + C.wood + "' stroke-width='0.3'/><path d='M23,8.8 L25.6,11.6 L23,11.6 Z' fill='#" + C.paperhi + "'/>"
  } else if t.season == "autumn" {
    s += "<path d='M0,20 L0,11 L6,6 L11,10 L17,4 L24,10 L28,7 L34,12 L34,20 Z' fill='#" + C.prussian + "'/>"
    s += "<path d='M15.4,5.6 L17,4 L18.8,5.8 L17.8,5.4 L17,6.4 L16.3,5.3 Z' fill='#" + C.paperhi + "'/>"
    s += "<path d='M0,20 L0,15 L9,12 L20,15.5 L34,13 L34,20 Z' fill='#" + C.wood + "'/>"
    for (x, y, r) in ((5, 4, 12), (28, 3, -20), (25, 16.5, 30), (9, 16, -8), (31, 9, 15)) {
      s += "<g transform='translate(" + str(x) + "," + str(y) + ") rotate(" + str(r) + ")'><path d='M0,-2 L0.5,-0.6 L1.9,-0.9 L1,0.2 L1.6,1.4 L0.2,0.8 L0,2 L-0.2,0.8 L-1.6,1.4 L-1,0.2 L-1.9,-0.9 L-0.5,-0.6 Z' fill='#" + C.ver + "'/></g>"
    }
  } else {
    s += "<path d='M0,20 L0,12 L8,7 L13,10 L21,5 L28,9.5 L34,8 L34,20 Z' fill='#" + C.paperhi + "' stroke='#" + C.night + "' stroke-width='0.2'/>"
    s += "<path d='M0,20 L0,15 L12,13 L22,16 L34,14 L34,20 Z' fill='#dfe6f0'/>"
    for (x, y) in ((4, 3), (9, 5.5), (15, 2.5), (19, 7), (26, 3.5), (31, 5.5), (6, 9), (12, 8.5), (29, 12)) {
      s += "<circle cx='" + str(x) + "' cy='" + str(y) + "' r='0.45' fill='#" + C.paperhi + "'/>"
    }
  }
  svg(s, "0 0 34 20", 34mm)
}



#place(top + left, dx: 14mm, dy: Y.views * 1mm, {
  text(size: 13pt, weight: 800, fill: col("prussian"))[Πέντε όψεις της Ιαπωνίας]
  h(2.5mm)
  text(size: 8.4pt, fill: col("blue"))[ταξίδια, σπουδές και συνοδεία ομάδας, με τη σειρά]
})

#let roman = ("一", "二", "三", "四", "五")
#place(top + left, dx: 14mm, dy: Y.tiles * 1mm, grid(
  columns: (34mm,) * 5, column-gutter: 3mm,
  ..trips.enumerate().map(((i, t)) => {
    let pro = t.kind == "colead"
    block(width: 34mm, {
      box(stroke: (if pro { 1.4pt + col("ver") } else { 0.6pt + col("sumi") }), inset: 1.1pt, fill: col("paperhi"),
        box(stroke: 0.3pt + col("sumi"), tile-svg(t, i)))
      place(top + right, dx: -1.5mm, dy: 1.6mm, box(fill: col("paperhi"), stroke: 0.4pt + col("sumi"), inset: (x: 1.2pt, y: 1.5pt),
        stack(dir: ttb, spacing: 0.6pt,
          text(font: kanji, weight: 800, size: 6.4pt, fill: col("ver"), roman.at(i)),
          v(0.6pt),
          ..t.kanji.clusters().map(c => text(font: kanji, weight: 800, size: 6.4pt, c)))))
      v(1.2mm)
      set par(leading: 0.34em)
      text(size: 9pt, weight: 800, fill: col("prussian"), t.when)
      h(1fr)
      text(size: 9pt, weight: 800, fill: col("ver"), str(t.days) + " ημ.")
      linebreak()
      text(size: 7.6pt, t.places.join(", "))
      linebreak()
      text(size: 7.2pt, weight: 700, tracking: 0.04em, fill: (if pro { col("ver") } else { col("blue") }), caps(t.kind_el))
    })
  }),
))

// ---- two mist bands: know-how in Japan, and on the road with a group --------
#let band(label, items) = box(width: 182mm, height: 9.4mm, radius: 4.7mm, fill: col("paperhi"), stroke: 0.4pt + col("sumi"), inset: (left: 3mm, right: 4mm), {
  set align(horizon)
  grid(columns: (27mm, 1fr), align: horizon,
    box(fill: col("prussian"), radius: 3mm, inset: (x: 2.2mm, y: 1.4mm), text(size: 7.4pt, weight: 800, tracking: 0.08em, fill: col("paperhi"), label)),
    text(size: 8.3pt, items.join([#h(1.2mm)#text(fill: col("ver"), "◆")#h(1.2mm)])),
  )
})
#place(top + left, dx: 14mm, dy: Y.bands * 1mm, band("ΣΤΗΝ ΙΑΠΩΝΙΑ", d.knowhow))
#place(top + left, dx: 14mm, dy: (Y.bands + 11) * 1mm, band("ΣΤΗ ΣΥΝΟΔΕΙΑ", d.operations))

// ---- three columns ---------------------------------------------------------
#let head(title) = block(above: 0mm, below: 1.6mm, {
  text(size: 11.5pt, weight: 800, fill: col("prussian"), title)
  v(-2.3mm)
  rule-double(100%)
})
#set text(size: 8.4pt)

#let col-exp = block(width: 62mm, {
  head[Εμπειρία]
  for e in d.experience {
    block(below: 2mm, {
      set par(leading: 0.38em)
      text(size: 9.2pt, weight: 800, e.role)
      linebreak()
      text(weight: 700, fill: col("blue"), e.company + ", " + e.city)
      h(1fr)
      text(weight: 700, fill: col("ver"), e.from + "–" + e.to)
      v(0.2mm)
      for p in e.points.slice(0, calc.min(3, e.points.len())) [
        #grid(columns: (2.6mm, 1fr), text(fill: col("ver"), "–"), p)
      ]
    })
  }
})

#let col-groups = block(width: 60mm, {
  head[Ομάδες που συνόδευσε]
  table(
    columns: (12.5mm, 1fr, 7mm, 6mm), stroke: none, inset: (x: 0.8mm, y: 0.85mm),
    fill: (_, y) => if calc.odd(y) and y < d.groups.len() + 1 { col("paperhi") } else { none },
    text(weight: 700, fill: col("blue"))[Πότε], text(weight: 700, fill: col("blue"))[Πού], text(weight: 700, fill: col("blue"))[Άτ.], text(weight: 700, fill: col("blue"))[Ημ.],
    table.hline(stroke: 0.4pt + col("sumi")),
    ..d.groups.map(g => {
      let w = if g.japan { text(weight: 800, fill: col("ver"))[Ιαπωνία, #lower(g.role)] } else { g.where }
      (g.date, w, str(g.pax), str(g.days))
    }).flatten(),
    table.hline(stroke: 0.4pt + col("sumi")),
    [], text(weight: 800)[#d.groups.len() ομάδες], text(weight: 800, str(gpax)), text(weight: 800, str(d.groups.map(g => g.days).sum())),
  )
})

#let col-creds = block(width: 52mm, {
  head[Γλώσσες]
  for l in d.languages {
    grid(columns: (15mm, 1fr), text(weight: 800, l.name), l.level)
  }
  v(2.6mm)
  head[Πιστοποιήσεις, σπουδές]
  set par(leading: 0.36em)
  for e in d.certificates.map(c => (title: c.title, school: c.issuer + " · " + c.valid, years: "")) + d.education.slice(0, 2) {
    block(below: 1.3mm, {
      text(weight: 800, e.title)
      if e.years != "" { h(1fr); text(fill: col("ver"), weight: 700, e.years) }
      linebreak()
      text(size: 7.8pt, fill: col("blue"), e.school)
    })
  }
})

#place(top + left, dx: 14mm, dy: Y.cols * 1mm, col-exp)
#place(top + left, dx: 80mm, dy: Y.cols * 1mm, col-groups)
#place(top + left, dx: 144mm, dy: Y.cols * 1mm, col-creds)

// footer: availability and the offer, set like a print's margin inscription
#place(top + left, dx: 0mm, dy: Y.foot * 1mm, block(width: 210mm, height: 15mm, fill: col("prussian"), inset: (x: 14mm, y: 2.6mm), {
  set text(size: 8.2pt, fill: col("paperhi"))
  set par(leading: 0.45em)
  grid(columns: (1fr, 66mm), column-gutter: 6mm,
    [#text(weight: 800, fill: col("ochre"), "ΔΙΑΘΕΣΙΜΟΤΗΤΑ")#h(2mm)#d.availability.join("  ·  ")],
    [#text(weight: 800, fill: col("ochre"), "ΠΡΟΤΑΣΗ")#h(2mm)#d.offer],
  )
}))
#place(bottom + right, dx: -3mm, dy: -1mm, text(size: 5pt, fill: col("pale"))[Φανταστικό πρόσωπο · σχέδιο CVgen])
