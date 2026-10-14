// Woodblock Road, Stylish tier, Spacious density (two pages). Idea run 2026-09-29 (magazine-editor).
// Page 1 opens on the travel print, now taller: more sky, a larger inset
// portrait, the group crossing the bridge at a bigger scale behind its
// leader's flag, then the name, the profile and the whole working record.
// Page 2 opens on a second print, the same street at dusk (pagoda, machiya,
// lanterns, the group again), then the five views of Japan as taller
// miniature prints, the two mist bands and the credentials.
// Fictional data: sample.json in the style folder.
//
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path design-concepts/fonts design-concepts/2026-09-29-woodblock-road/spacious/stylish/spacious-stylish.typ design-concepts/2026-09-29-woodblock-road/spacious/stylish/spacious-stylish.pdf

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


// ---- page 1 print: the condensed print with 24 mm more sky and a larger group ----------
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
  s += "<rect x='0' y='-24' width='210' height='" + str(print-h + 24) + "' fill='url(#sky)'/>" + kasumi(18, -9, 74, 3.2, op: 0.45) + "<g fill='none' stroke='#" + C.paperhi + "' stroke-width='0.35' stroke-linecap='round'>" + "<path d='M52,-6 l1.6,1 l1.6,-1'/><path d='M58,-10 l1.3,0.8 l1.3,-0.8'/><path d='M62,-4 l1.1,0.7 l1.1,-0.7'/><path d='M47,-12 l1,0.6 l1,-0.6'/></g>"
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
  for (i, x) in xs.enumerate() { s += walker(x, yd(x), coats.at(i), acc: accs.at(i), hat: hats.at(i), s: 1.18) }
  s += walker(176, yd(176), C.ver, acc: "flag", hat: "brim", s: 1.32)
  s += "<path d='M100," + f(yr(100)) + " Q150,86 200," + f(yr(200)) + "' fill='none' stroke='#" + C.wood + "' stroke-width='0.7'/>"
  for x in range(102, 200, step: 8) {
    s += "<line x1='" + str(x) + "' y1='" + f(yr(x)) + "' x2='" + str(x) + "' y2='" + f(yd(x)) + "' stroke='#" + C.wood + "' stroke-width='0.5'/>"
  }
  // keyline at the print's lower edge
  s += "<rect x='0' y='" + f(print-h - 0.8) + "' width='210' height='0.8' fill='#" + C.sumi + "'/>"
  svg(s, "0 -24 210 " + str(print-h + 24), 210mm)
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

#let trips = d.japan_trips
#let jdays = trips.map(t => t.days).sum()
#let gpax = d.groups.map(g => g.pax).sum()

// Greek all-caps drop the tonos (dialytika stays)
#let caps(s) = {
  let m = ("Ά": "Α", "Έ": "Ε", "Ή": "Η", "Ί": "Ι", "Ό": "Ο", "Ύ": "Υ", "Ώ": "Ω", "ΐ": "Ϊ", "ΰ": "Ϋ")
  upper(s).clusters().map(c => m.at(c, default: c)).join()
}

// ---- the five views as taller miniature prints (7 mm more sky) --------------------------
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
  s += "</defs><rect y='-7' width='34' height='27' fill='url(#g" + str(i) + ")'/>"
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
  svg(s, "0 -7 34 27", 34mm)
}

#set text(size: 10.2pt)
#set par(leading: 0.55em, spacing: 0.8em)

// ---- page 2 print: the same journey at dusk --------------------------------------------
#let dusk-h = 74
#let dusk-print = {
  let H = dusk-h
  let s = "<defs><linearGradient id='dsk' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#" + C.night + "'/><stop offset='0.2' stop-color='#3f3566'/><stop offset='0.46' stop-color='#b8573e'/><stop offset='0.66' stop-color='#" + C.ochre + "'/><stop offset='1' stop-color='#" + C.paperhi + "'/></linearGradient>"
  s += seigaiha("dsg", 2.2, C.prussian, "8fa8d0")
  s += "</defs>"
  s += "<rect width='210' height='" + str(H) + "' fill='url(#dsk)'/>"
  // the setting sun, far hills, mist
  s += "<circle cx='136' cy='40' r='14' fill='#" + C.ver + "'/>"
  s += "<path d='M0,44 Q20,34 40,40 Q62,30 86,38 Q110,32 130,42 Q160,34 184,40 Q200,36 210,39 L210,58 L0,58 Z' fill='#5e5a86'/>"
  s += kasumi(86, 36, 128, 4, op: 0.7)
  // birds going home
  s += "<g fill='none' stroke='#" + C.night + "' stroke-width='0.4' stroke-linecap='round'><path d='M150,15 l1.6,1 l1.6,-1'/><path d='M157,11 l1.3,0.8 l1.3,-0.8'/><path d='M163,17 l1.1,0.7 l1.1,-0.7'/><path d='M146,9 l1,0.6 l1,-0.6'/></g>"
  // the pagoda
  let px = 42
  let base = 60
  s += "<rect x='" + f(px - 4) + "' y='" + f(base - 46) + "' width='8' height='46' fill='#" + C.night + "'/>"
  for k in range(5) {
    let y = base - 8 - k * 8.4
    let w = 27 - k * 3.2
    s += "<rect x='" + f(px - w / 2 + 3.4) + "' y='" + f(y) + "' width='" + f(w - 6.8) + "' height='5.2' fill='#26315a'/>"
    s += "<path d='M" + f(px - w / 2 - 1.6) + "," + f(y - 1.9) + " Q" + f(px - w / 2) + "," + f(y + 0.4) + " " + f(px - w / 2 + 2.2) + "," + f(y + 0.4) + " L" + f(px + w / 2 - 2.2) + "," + f(y + 0.4) + " Q" + f(px + w / 2) + "," + f(y + 0.4) + " " + f(px + w / 2 + 1.6) + "," + f(y - 1.9) + " L" + f(px + w / 4) + "," + f(y - 3.6) + " L" + f(px - w / 4) + "," + f(y - 3.6) + " Z' fill='#" + C.night + "'/>"
  }
  let top = base - 8 - 4 * 8.4 - 3.6
  s += "<line x1='" + f(px) + "' y1='" + f(top) + "' x2='" + f(px) + "' y2='" + f(top - 11) + "' stroke='#" + C.night + "' stroke-width='0.8'/>"
  for r in range(5) { s += "<line x1='" + f(px - 1.7) + "' y1='" + f(top - 2.4 - r * 1.6) + "' x2='" + f(px + 1.7) + "' y2='" + f(top - 2.4 - r * 1.6) + "' stroke='#" + C.night + "' stroke-width='0.55'/>" }
  s += kasumi(-12, 26, 76, 3.6, op: 0.92)
  // the machiya street
  for i in range(10) {
    let x0 = i * 22 - 6
    let w = 21
    let ry = 45 + calc.rem(i * 7, 3) * 1.3
    s += "<rect x='" + f(x0) + "' y='" + f(ry + 2.6) + "' width='" + f(w) + "' height='" + f(63 - ry - 2.6) + "' fill='#4a3226'/>"
    s += "<rect x='" + f(x0 + 2) + "' y='" + f(ry + 5) + "' width='" + f(w - 4) + "' height='5.4' fill='#" + C.ochre + "' fill-opacity='0.5'/>"
    for j in range(1, 12) { s += "<line x1='" + f(x0 + 2 + j * (w - 4) / 12) + "' y1='" + f(ry + 5) + "' x2='" + f(x0 + 2 + j * (w - 4) / 12) + "' y2='" + f(ry + 10.4) + "' stroke='#4a3226' stroke-width='0.35'/>" }
    s += "<path d='M" + f(x0 - 1.4) + "," + f(ry + 3) + " L" + f(x0 + 1) + "," + f(ry) + " L" + f(x0 + w - 1) + "," + f(ry) + " L" + f(x0 + w + 1.4) + "," + f(ry + 3) + " Z' fill='#" + C.sumi + "'/>"
    s += "<rect x='" + f(x0 + w * 0.56) + "' y='" + f(ry + 11.4) + "' width='6.4' height='4.2' fill='#" + C.prussian + "'/><line x1='" + f(x0 + w * 0.56 + 3.2) + "' y1='" + f(ry + 11.4) + "' x2='" + f(x0 + w * 0.56 + 3.2) + "' y2='" + f(ry + 15.6) + "' stroke='#" + C.paperhi + "' stroke-width='0.3'/>"
  }
  // a string of paper lanterns
  let ly(x) = 48.6 + 3 * (1 - calc.pow((x - 136) / 72, 2))
  s += "<path d='M64," + f(ly(64)) + " Q136," + f(ly(136) * 2 - (ly(64) + ly(208)) / 2) + " 208," + f(ly(208)) + "' fill='none' stroke='#" + C.sumi + "' stroke-width='0.3'/>"
  for x in range(70, 208, step: 11) {
    let y = ly(x) + 3.2
    s += "<line x1='" + str(x) + "' y1='" + f(ly(x)) + "' x2='" + str(x) + "' y2='" + f(y - 2.2) + "' stroke='#" + C.sumi + "' stroke-width='0.25'/>"
    s += "<ellipse cx='" + str(x) + "' cy='" + f(y) + "' rx='1.8' ry='2.4' fill='#" + C.ver + "' stroke='#" + C.sumi + "' stroke-width='0.2'/>"
    s += "<rect x='" + f(x - 1) + "' y='" + f(y - 2.7) + "' width='2' height='0.6' fill='#" + C.sumi + "'/><rect x='" + f(x - 1) + "' y='" + f(y + 2.1) + "' width='2' height='0.6' fill='#" + C.sumi + "'/>"
    s += "<ellipse cx='" + f(x - 0.5) + "' cy='" + f(y - 0.6) + "' rx='0.5' ry='0.9' fill='#" + C.ochre + "' fill-opacity='0.8'/>"
  }
  // the street and the group
  s += "<rect x='0' y='63' width='210' height='" + str(H - 63) + "' fill='#d6c7a3'/>"
  s += "<line x1='0' y1='63' x2='210' y2='63' stroke='#" + C.wood + "' stroke-width='0.5'/>"
  for i in range(0, 12) { s += "<line x1='" + str(i * 18 + 4) + "' y1='67.5' x2='" + str(i * 18 + 13) + "' y2='67.5' stroke='#b9a47a' stroke-width='0.35'/>" }
  let coats = (C.blue, C.green, "8a5a3c", C.prussian, C.ochre, "6b4f7a", C.blue, "8a5a3c", C.green)
  let accs = ("case", none, "pack", "case", none, "case", "pack", none, "case")
  for (i, x) in (64, 73, 82, 91, 100, 109, 118, 127, 136).enumerate() {
    s += walker(x, 71, coats.at(i), acc: accs.at(i), hat: ("brim", "kasa").at(calc.rem(i, 2)), s: 1.22)
  }
  s += walker(150, 71, C.ver, acc: "flag", hat: "brim", s: 1.36)
  s += "<rect x='0' y='" + f(H - 0.8) + "' width='210' height='0.8' fill='#" + C.sumi + "'/>"
  svg(s, "0 0 210 " + str(H), 210mm)
}

// ---- shared furniture ----------------------------------------------------------------
#let rule-double(w) = stack(spacing: 0.7pt, line(length: w, stroke: 0.8pt + col("sumi")), line(length: w, stroke: 0.3pt + col("sumi")))
#let head(title, sub: none) = block(above: 0mm, below: 2.6mm, {
  text(size: 14pt, weight: 800, fill: col("prussian"), title)
  if sub != none { h(3mm); text(size: 9.4pt, fill: col("blue"), sub) }
  v(-2.2mm)
  rule-double(100%)
})
#let seal(size) = box(baseline: -0.8mm, box(width: size, height: size, fill: col("ver"), radius: 1.2pt,
  align(center + horizon, text(font: kanji, weight: 800, size: size * 1.8 / 1mm * 1pt, fill: col("paperhi"), "旅"))))
#let X = 14mm

// =========================== PAGE 1 ===========================
#place(top + left, header-print)
#place(top + left, dx: 183mm, dy: 8mm, cartouche(vtext("日本の旅", 25pt, col("sumi")), 17.5mm, 62mm, col("ochre")))
#place(top + left, dx: 170.5mm, dy: 8mm, cartouche(vtext(d.name.kana, 12.4pt, col("paperhi"), gap: 0pt), 10.5mm, 62mm, col("ver")))
#place(top + left, dx: 14mm, dy: 15mm, circle(radius: 31mm, fill: col("ochre"), stroke: 0.9pt + col("sumi")))
#place(top + left, dx: 16.8mm, dy: 17.8mm, circle(radius: 28.2mm, fill: none, stroke: 0.5pt + col("sumi")))
#place(top + left, dx: 17.5mm, dy: 18.5mm, box(width: 55mm, height: 55mm, radius: 27.5mm, clip: true, image("../../portrait.jpg", width: 55mm)))

// name block
#place(top + left, dx: X, dy: 138mm, block(width: 134mm, {
  set par(leading: 0.3em)
  text(size: 46pt, weight: 900, fill: col("prussian"), tracking: -0.01em, d.name.el)
  h(3.4mm)
  seal(13mm)
  v(0.4mm)
  text(size: 12.6pt, weight: 700, tracking: 0.1em, fill: col("ver"), d.title.caps)
  linebreak()
  text(size: 12.6pt, weight: 700, tracking: 0.1em, fill: col("prussian"), d.title.specialty_caps)
}))
#place(top + right, dx: -X, dy: 141mm, block(width: 50mm, {
  set align(right)
  set text(size: 10pt)
  set par(leading: 0.5em)
  [#text(weight: 700)[#d.contact.city] \ #d.contact.phone \ #d.contact.email \ #text(fill: col("blue"), d.contact.link)]
}))
#place(top + left, dx: X, dy: 169mm, rule-double(182mm))

// profile and the three numbers
#place(top + left, dx: X, dy: 174mm, block(width: 112mm, text(size: 10.8pt, d.profile)))
#let bignum(n, label) = block(width: 22mm, {
  set align(center)
  text(size: 28pt, weight: 900, fill: col("prussian"), n)
  v(-5.4mm)
  text(size: 8pt, weight: 700, tracking: 0.06em, fill: col("ver"), caps(label))
})
#place(top + left, dx: 131mm, dy: 173.5mm, box(width: 65mm, fill: col("paperhi"), stroke: 0.4pt + col("sumi"), inset: (x: 0mm, top: 1.6mm, bottom: 2.4mm), {
  grid(columns: 3, bignum(str(trips.len()), "ταξίδια"), bignum(str(jdays), "ημέρες"), bignum("N4", "JLPT"))
  v(-0.4mm)
  align(center, text(size: 8.4pt, fill: col("blue"))[στην Ιαπωνία, #trips.first().year–#trips.last().year · JLPT 12/2024])
}))

// the working record, full width
#place(top + left, dx: X, dy: 208mm, block(width: 182mm, {
  head[Εμπειρία]
  for e in d.experience {
    block(below: 4.6mm, {
      set par(leading: 0.46em)
      grid(columns: (1fr, auto), text(size: 11.4pt, weight: 800, e.role), text(size: 10.4pt, weight: 800, fill: col("ver"), e.from + " – " + e.to))
      text(weight: 700, fill: col("blue"), e.company + ", " + e.city)
      v(0.6mm)
      for p in e.points { block(below: 2.3mm, grid(columns: (3.6mm, 1fr), text(fill: col("ver"), "–"), p)) }
    })
  }
}))

// footer: availability and the offer, set like a print's margin inscription
#place(top + left, dy: 274mm, block(width: 210mm, height: 23mm, fill: col("prussian"), inset: (x: 14mm, y: 3.6mm), {
  set text(size: 10pt, fill: col("paperhi"))
  set par(leading: 0.5em)
  grid(columns: (1fr, 74mm), column-gutter: 8mm,
    [#text(weight: 800, fill: col("ochre"), "ΔΙΑΘΕΣΙΜΟΤΗΤΑ")#h(2mm)#d.availability.join("  ·  ")],
    [#text(weight: 800, fill: col("ochre"), "ΠΡΟΤΑΣΗ")#h(2mm)#d.offer],
  )
}))
#place(bottom + right, dx: -3mm, dy: -1.2mm, text(size: 5pt, fill: col("pale"))[Φανταστικό πρόσωπο · σχέδιο CVgen · 1/2])

#pagebreak()

// =========================== PAGE 2 ===========================
#place(top + left, dusk-print)
#place(top + left, dx: 186mm, dy: 7mm, cartouche(vtext("日本の旅", 17pt, col("sumi")), 12mm, 44mm, col("ochre")))
#place(top + left, dx: 177mm, dy: 7mm, cartouche(vtext(d.name.kana, 9pt, col("paperhi"), gap: 0pt), 8mm, 44mm, col("ver")))

// the name again, as the print's margin title
#place(top + left, dx: X, dy: 79mm, block(width: 182mm, {
  set par(leading: 0.3em)
  text(size: 30pt, weight: 900, fill: col("prussian"), d.name.el)
  h(2.6mm)
  seal(9mm)
  h(1fr)
  box(baseline: -1.6mm, align(right, {
    text(size: 10.4pt, weight: 700, tracking: 0.1em, fill: col("ver"), d.title.caps)
    linebreak()
    text(size: 10.4pt, weight: 700, tracking: 0.1em, fill: col("prussian"), d.title.specialty_caps)
  }))
}))
#place(top + left, dx: X, dy: 94.5mm, rule-double(182mm))

// five views of Japan
#place(top + left, dx: X, dy: 100mm, {
  text(size: 14pt, weight: 800, fill: col("prussian"))[Πέντε όψεις της Ιαπωνίας]
  h(3mm)
  text(size: 9.6pt, fill: col("blue"))[ταξίδια, σπουδές και συνοδεία ομάδας, με τη σειρά]
})
#let roman = ("一", "二", "三", "四", "五")
#place(top + left, dx: X, dy: 109mm, grid(
  columns: (34mm,) * 5, column-gutter: 3mm,
  ..trips.enumerate().map(((i, t)) => {
    let pro = t.kind == "colead"
    block(width: 34mm, {
      box(stroke: (if pro { 1.4pt + col("ver") } else { 0.6pt + col("sumi") }), inset: 1.1pt, fill: col("paperhi"),
        box(stroke: 0.3pt + col("sumi"), tile-svg(t, i)))
      place(top + right, dx: -1.5mm, dy: 1.6mm, box(fill: col("paperhi"), stroke: 0.4pt + col("sumi"), inset: (x: 1.3pt, y: 1.6pt),
        stack(dir: ttb, spacing: 0.6pt,
          text(font: kanji, weight: 800, size: 7pt, fill: col("ver"), roman.at(i)),
          v(0.6pt),
          ..t.kanji.clusters().map(c => text(font: kanji, weight: 800, size: 7pt, c)))))
    })
    v(1.8mm)
    set par(leading: 0.4em)
    text(size: 9.8pt, weight: 800, fill: col("prussian"), t.when)
    h(1fr)
    text(size: 9.8pt, weight: 900, fill: col("ver"), str(t.days) + " ημ.")
    linebreak()
    text(size: 9pt, t.places.join(", "))
    linebreak()
    text(size: 8pt, weight: 700, tracking: 0.04em, fill: (if pro { col("ver") } else { col("blue") }), caps(t.kind_el))
  }),
))

// two mist bands
#let band(label, items) = box(width: 182mm, height: 15.5mm, radius: 7.75mm, fill: col("paperhi"), stroke: 0.4pt + col("sumi"), inset: (left: 3.4mm, right: 6mm), {
  set align(horizon)
  grid(columns: (31mm, 1fr), align: horizon, column-gutter: 1mm,
    box(fill: col("prussian"), radius: 3.4mm, inset: (x: 2.6mm, y: 1.8mm), text(size: 8.4pt, weight: 800, tracking: 0.08em, fill: col("paperhi"), label)),
    {
      set par(leading: 0.45em)
      text(size: 9.6pt, items.join([#h(1.4mm)#text(fill: col("ver"), "◆")#h(1.4mm)]))
    },
  )
})
#place(top + left, dx: X, dy: 163mm, band("ΣΤΗΝ ΙΑΠΩΝΙΑ", d.knowhow))
#place(top + left, dx: X, dy: 181mm, band("ΣΤΗ ΣΥΝΟΔΕΙΑ", d.operations))

// two columns: the groups, the credentials
#place(top + left, dx: X, dy: 204mm, block(width: 94mm, {
  head[Ομάδες που συνόδευσε]
  set text(size: 9.8pt)
  table(
    columns: (15mm, 1fr, 10mm, 9mm), stroke: none, inset: (x: 1mm, y: 1.25mm),
    fill: (_, y) => if calc.odd(y) and y < d.groups.len() + 1 { col("paperhi") } else { none },
    text(weight: 700, fill: col("blue"))[Πότε], text(weight: 700, fill: col("blue"))[Πού], text(weight: 700, fill: col("blue"))[Άτ.], text(weight: 700, fill: col("blue"))[Ημ.],
    table.hline(stroke: 0.4pt + col("sumi")),
    ..d.groups.map(g => {
      let w = if g.japan { text(weight: 800, fill: col("ver"))[Ιαπωνία, #lower(g.role)] } else { [#g.where, #lower(g.role)] }
      (g.date, w, str(g.pax), str(g.days))
    }).flatten(),
    table.hline(stroke: 0.4pt + col("sumi")),
    [], text(weight: 800)[#d.groups.len() ομάδες], text(weight: 800, str(gpax)), text(weight: 800, str(d.groups.map(g => g.days).sum())),
  )
}))
#place(top + left, dx: 116mm, dy: 204mm, block(width: 80mm, {
  head[Γλώσσες]
  for l in d.languages {
    block(below: 1.2mm, grid(columns: (19mm, 1fr), text(weight: 800, l.name), l.level))
  }
  v(3.4mm)
  head[Πιστοποιήσεις, σπουδές]
  set par(leading: 0.42em)
  for e in d.certificates.map(c => (title: c.title, school: c.issuer + " · " + c.valid, years: "")) + d.education {
    block(below: 2mm, {
      text(weight: 800, e.title)
      if e.years != "" { h(1fr); text(fill: col("ver"), weight: 700, e.years) }
      linebreak()
      text(size: 9pt, fill: col("blue"), e.school)
    })
  }
}))

// footer: the contacts
#place(top + left, dy: 284mm, block(width: 210mm, height: 13mm, fill: col("prussian"), inset: (x: 14mm), align(horizon, {
  set text(size: 10pt, fill: col("paperhi"))
  text(weight: 800, fill: col("ochre"), d.name.el)
  h(1fr); d.contact.phone; h(1fr); d.contact.email; h(1fr); text(fill: col("ochre"), d.contact.link)
})))
#place(bottom + right, dx: -3mm, dy: -0.6mm, text(size: 5pt, fill: col("pale"))[Φανταστικό πρόσωπο · σχέδιο CVgen · 2/2])
