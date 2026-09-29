// Woodblock Road, Safe tier. Idea run 2026-09-29 (magazine-editor).
// The calm version: the travel print is a mounted strip across the top, the
// body is a conventional two-column CV, and every Japan trip carries its season
// kanji. Fictional data: sample.json in this folder.
//
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path design-concepts/fonts design-concepts/2026-09-29-woodblock-road/safe.typ design-concepts/2026-09-29-woodblock-road/safe.pdf

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

// ---- the mounted print strip -------------------------------------------------
#let strip = {
  let W = 182
  let H = 52
  let s = "<defs>"
  s += "<linearGradient id='sky' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#" + C.night + "'/><stop offset='0.22' stop-color='#" + C.prussian + "'/><stop offset='0.55' stop-color='#7d97c6'/><stop offset='0.85' stop-color='#efe3c8'/></linearGradient>"
  s += "<linearGradient id='fj' x1='0' y1='0' x2='0' y2='1'><stop offset='0' stop-color='#4a6ba3'/><stop offset='1' stop-color='#" + C.prussian + "'/></linearGradient>"
  s += "<clipPath id='fjc'><path d='M92,45 Q130,38 139,11 L145,11 Q154,38 196,45 Z'/></clipPath>"
  s += seigaiha("sg", 1.7, C.prussian, "8fa8d0")
  s += "</defs>"
  s += "<rect width='" + str(W) + "' height='" + str(H) + "' fill='url(#sky)'/>"
  s += "<circle cx='112' cy='17' r='6.5' fill='#" + C.ver + "'/>"
  s += "<path d='M0,41 Q14,33 28,37 Q44,30 60,38 Q76,34 96,43 L96,47 L0,47 Z' fill='#" + C.hill + "'/>"
  s += "<path d='M92,45 Q130,38 139,11 L145,11 Q154,38 196,45 Z' fill='url(#fj)' stroke='#" + C.night + "' stroke-width='0.3'/>"
  s += "<g clip-path='url(#fjc)'><path d='M120,5 L170,5 L152,21 L150,20 L148.5,24 L146.5,20 L144.5,25 L142.5,20.5 L140.5,24 L138.5,19.5 L136,22 L120,22 Z' fill='#" + C.paperhi + "'/></g>"
  s += kasumi(66, 31, 130, 3.6)
  s += kasumi(-8, 22, 44, 3.2, op: 0.9)
  s += "<path d='M40,47 Q70,41 100,45 Q140,40 182,44 L182,48 L40,48 Z' fill='#" + C.green + "'/>"
  s += "<rect x='0' y='46.5' width='" + str(W) + "' height='" + str(H - 46.5) + "' fill='url(#sg)'/>"
  // the group on the shore road, the leader's flag up front
  s += "<rect x='0' y='45.6' width='96' height='1.2' fill='#" + C.wood + "'/>"
  let coats = (C.blue, C.green, "8a5a3c", C.prussian, C.ochre, "6b4f7a", C.blue)
  let accs = ("case", none, "pack", "case", none, "case", "pack")
  for (i, x) in (22, 27, 32, 37, 42, 47, 52).enumerate() {
    s += walker(x, 45.6, coats.at(i), acc: accs.at(i), hat: ("brim", "kasa").at(calc.rem(i, 2)), s: 0.66)
  }
  s += walker(59, 45.6, C.ver, acc: "flag", hat: "brim", s: 0.72)
  svg(s, "0 0 " + str(W) + " " + str(H), 182mm)
}

#place(top + left, dx: 12.4mm, dy: 10.4mm, rect(width: 185.2mm, height: 55.2mm, fill: col("paperhi"), stroke: 0.9pt + col("sumi")))
#place(top + left, dx: 14mm, dy: 12mm, box(stroke: 0.35pt + col("sumi"), strip))
#place(top + left, dx: 184mm, dy: 15mm, box(width: 9mm, height: 34mm, fill: col("ochre"), stroke: 0.8pt + col("sumi"), inset: 1pt,
  box(width: 100%, height: 100%, stroke: 0.35pt + col("sumi"), align(center + horizon, vtext("日本の旅", 13pt, col("sumi"))))))

// ---- identity ------------------------------------------------------------------
#place(top + left, dx: 14mm, dy: 72mm, block(width: 140mm, {
  set par(leading: 0.3em)
  text(size: 33pt, weight: 900, fill: col("prussian"), d.name.el)
  h(2.5mm)
  box(baseline: -0.6mm, box(width: 9mm, height: 9mm, fill: col("ver"), radius: 1pt,
    align(center + horizon, text(font: kanji, weight: 800, size: 16pt, fill: col("paperhi"), "旅"))))
  v(-0.6mm)
  text(size: 10.5pt, weight: 700, tracking: 0.1em, fill: col("ver"), d.title.caps)
  text(size: 10.5pt, weight: 700, tracking: 0.1em, fill: col("prussian"), [ · ] + d.title.specialty_caps)
  v(1.2mm)
  set text(size: 8.8pt)
  [#text(weight: 700)[#d.contact.city]#h(3mm)#text(fill: col("ver"), "◆")#h(3mm)#d.contact.phone#h(3mm)#text(fill: col("ver"), "◆")#h(3mm)#d.contact.email#h(3mm)#text(fill: col("ver"), "◆")#h(3mm)#text(fill: col("blue"), d.contact.link)]
}))
// portrait, mounted like a small print
#place(top + left, dx: 164mm, dy: 70mm, box(stroke: 0.9pt + col("sumi"), inset: 1.3pt, fill: col("paperhi"),
  box(stroke: 0.35pt + col("sumi"), clip: true, width: 29mm, height: 35mm, image("portrait.jpg", width: 35mm))))

#let rule-double(w) = stack(spacing: 0.7pt, line(length: w, stroke: 0.8pt + col("sumi")), line(length: w, stroke: 0.3pt + col("sumi")))
#place(top + left, dx: 14mm, dy: 109mm, rule-double(182mm))

#let head(title) = block(above: 3.4mm, below: 1.8mm, {
  box(width: 2.6mm, height: 2.6mm, fill: col("ver"), baseline: -0.4mm)
  h(1.8mm)
  text(size: 11.5pt, weight: 800, fill: col("prussian"), title)
  v(-1.5mm)
  line(length: 100%, stroke: 0.4pt + col("sumi"))
})
#set text(size: 9pt)
#set par(leading: 0.5em)

// ---- main column -------------------------------------------------------------
#let season-kanji = (spring: "春", summer: "夏", autumn: "秋", winter: "冬")
#let season-col = (spring: "c9706c", summer: C.blue, autumn: "b8452c", winter: C.night)

#let main = block(width: 118mm, {
  block(above: 0mm, text(size: 9.6pt, d.profile))
  head[Επαγγελματική εμπειρία]
  for e in d.experience {
    block(below: 2.4mm, {
      set par(leading: 0.42em)
      grid(columns: (1fr, auto), text(size: 10pt, weight: 800, e.role), text(weight: 700, fill: col("ver"), e.from + " – " + e.to))
      text(weight: 700, fill: col("blue"), e.company + ", " + e.city)
      v(0.4mm)
      for p in e.points [#grid(columns: (3mm, 1fr), text(fill: col("ver"), "–"), p)]
    })
  }
  head[Η Ιαπωνία, ταξίδι προς ταξίδι]
  table(
    columns: (8mm, 24mm, 1fr, 13mm), stroke: none, inset: (x: 1mm, y: 1.1mm), align: (center + horizon, left + horizon, left + horizon, right + horizon),
    table.hline(stroke: 0.4pt + col("sumi")),
    ..trips.map(t => (
      box(width: 6.4mm, height: 6.4mm, fill: rgb(season-col.at(t.season)), radius: 0.8pt, align(center + horizon, text(font: kanji, weight: 800, size: 11pt, fill: col("paperhi"), season-kanji.at(t.season)))),
      [#text(weight: 800, t.when) \ #text(size: 7.8pt, fill: (if t.kind == "colead" { col("ver") } else { col("blue") }), weight: 700, caps(t.kind_el))],
      t.places.join(", "),
      text(weight: 800, fill: col("prussian"), str(t.days) + " ημ."),
    )).flatten(),
    table.hline(stroke: 0.4pt + col("sumi")),
  )
  head[Ομάδες που συνόδευσε]
  table(
    columns: (16mm, 1fr, 16mm, 14mm, 22mm), stroke: none, inset: (x: 1mm, y: 0.95mm),
    fill: (_, y) => if calc.odd(y) and y <= d.groups.len() { col("paperhi") } else { none },
    ..("Πότε", "Προορισμός", "Άτομα", "Ημέρες", "Ρόλος").map(h => text(size: 8pt, weight: 700, fill: col("blue"), h)),
    table.hline(stroke: 0.4pt + col("sumi")),
    ..d.groups.map(g => (g.date, (if g.japan { text(weight: 800, fill: col("ver"), g.where) } else { g.where }), str(g.pax), str(g.days), g.role)).flatten(),
    table.hline(stroke: 0.4pt + col("sumi")),
    [], text(weight: 800)[#d.groups.len() ομάδες], text(weight: 800, str(gpax)), text(weight: 800, str(d.groups.map(g => g.days).sum())), [],
  )
})

// ---- side column -------------------------------------------------------------
#let stat(n, label) = block(below: 1.6mm, grid(columns: (21mm, 1fr), align: horizon,
  text(size: 22pt, weight: 900, fill: col("prussian"), n), text(size: 8pt, weight: 700, fill: col("ver"), label)))

#let side = block(width: 56mm, {
  block(above: 0mm, fill: col("paperhi"), stroke: 0.4pt + col("sumi"), inset: (x: 3mm, y: 2.4mm), width: 100%, {
    stat(str(trips.len()), [ταξίδια στην Ιαπωνία])
    stat(str(jdays), [ημέρες, #trips.first().year–#trips.last().year])
    stat("N4", [JLPT, 12/2024])
  })
  head[Γλώσσες]
  for l in d.languages { grid(columns: (17mm, 1fr), text(weight: 800, l.name), l.level) }
  head[Πιστοποιήσεις]
  for c in d.certificates [#text(weight: 800, c.title) \ #text(size: 8pt, fill: col("blue"), c.issuer + ", " + c.valid) \ ]
  head[Σπουδές]
  set par(leading: 0.4em)
  for e in d.education { block(below: 1.4mm)[#text(weight: 800, e.title) #h(1fr) #text(weight: 700, fill: col("ver"), e.years) \ #text(size: 8pt, fill: col("blue"), e.school)] }
  head[Στην Ιαπωνία]
  for k in d.knowhow [#grid(columns: (3mm, 1fr), text(fill: col("ver"), "·"), k)]
  head[Διαθεσιμότητα]
  for k in d.availability [#grid(columns: (3mm, 1fr), text(fill: col("ver"), "·"), k)]
})

#place(top + left, dx: 14mm, dy: 113mm, main)
#place(top + left, dx: 140mm, dy: 113mm, side)

// closing wave band, as the lower margin of a print
#let foot = {
  let s = "<defs>" + seigaiha("fs", 2.2, C.prussian, "8fa8d0") + "</defs><rect width='210' height='9' fill='url(#fs)'/>"
  svg(s, "0 0 210 9", 210mm)
}
#place(bottom + left, foot)
#place(bottom + left, dy: -9mm, line(length: 210mm, stroke: 0.9pt + col("sumi")))
#place(bottom + left, dx: 14mm, dy: -11.5mm, text(size: 8.4pt, fill: col("prussian"))[#text(weight: 800, fill: col("ver"), "ΠΡΟΤΑΣΗ")#h(2mm)#d.offer])
#place(bottom + right, dx: -2mm, dy: -10mm, text(size: 5pt, fill: col("blue"))[Φανταστικό πρόσωπο · σχέδιο CVgen])
