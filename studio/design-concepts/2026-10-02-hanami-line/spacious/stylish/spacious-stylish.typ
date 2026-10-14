// Hanami Line, Stylish tier, Spacious density (two A4 pages). One-design run 2026-10-02 (magazine-editor).
// Flagship's skeleton (dark hero band, ringed portrait, name plate, numbered sections on a
// calm field) carrying Stamp Rally's identity (ATH -> TYO, one eki stamp per Japan trip,
// the escort's flag and group, the passenger manifest) and a cherry branch drawn into
// each page. Three inks on washi paper: ai indigo, one cinnabar, brass; sakura pink only
// in the nature artwork. Fictional data: ../../sample.json. Artwork: ../../assets/ (make_assets.py).
//
// typst compile --root . --ignore-system-fonts --font-path packages/cv-framework/fonts --font-path design-concepts/fonts design-concepts/2026-10-02-hanami-line/spacious/stylish/spacious-stylish.typ design-concepts/2026-10-02-hanami-line/spacious/stylish/spacious-stylish.pdf

#let d = json("../../sample.json")
#let A = "../../assets/"

// ---- tokens --------------------------------------------------------------------
#let C = (
  hero: rgb("1e2852"),    // ai / kon indigo
  hero2: rgb("28356a"),   // a step lighter, for keylines in the band
  ink: rgb("1b2036"),
  muted: rgb("5d6377"),
  paper: rgb("f8f4ea"),   // washi
  plate: rgb("fffcf4"),
  wash: rgb("efe8d9"),
  rule: rgb("dcd2bd"),
  brass: rgb("c4a265"),
  brass-dk: rgb("8f7037"),
  shu: rgb("c23a2b"),     // cinnabar: stamps, route, role, day counts
  on-hero: rgb("fbf7ee"),
)
#let body-font = "Source Sans 3"
#let disp = "Sofia Sans"      // Sofia Sans Extra Condensed (Greek)
#let num = "Barlow"           // Barlow Condensed SemiBold: figures and IATA codes
#let jp = "M PLUS 1p"
#let jpd = "Kaisei Tokumin"

#let trips = d.japan_trips
#let groups = d.groups
#let jdays = trips.map(t => t.days).sum()
#let gpax = groups.map(g => g.pax).sum()
#let gdays = groups.map(g => g.days).sum()
#assert(jdays == 103 and gpax == 162 and gdays == 39, message: "sample totals changed: re-check the copy that quotes them")

// Greek capitals drop the tonos
#let caps(s) = {
  let m = ("Ά": "Α", "Έ": "Ε", "Ή": "Η", "Ί": "Ι", "Ό": "Ο", "Ύ": "Υ", "Ώ": "Ω", "ΐ": "Ϊ", "ΰ": "Ϋ")
  upper(s).clusters().map(c => m.at(c, default: c)).join()
}
#let hex(c) = c.to-hex()
// a colour pre-faded into the paper (or band) it sits on: the nature artwork stays opaque and exact
#let fade(c, k, base: C.paper) = color.mix((c, k * 100%), (base, (1 - k) * 100%))

// read one of our SVGs and swap its default colours
#let art(name, width: auto, height: auto, swaps: (:)) = {
  let s = read(A + name)
  for (from, to) in swaps { s = s.replace(from, to) }
  image(bytes(s), format: "svg", width: width, height: height)
}
#let sakura(name, k-bark, k-petal, base: C.paper, petal: rgb("f2c2cd"), edge: rgb("d4869c"), heart: rgb("b0405f"), bark: rgb("5e4a55"), width: auto) = art(name, width: width, swaps: (
  "#5e4a55": hex(fade(bark, k-bark, base: base)),
  "#f2c2cd": hex(fade(petal, k-petal, base: base)),
  "#d4869c": hex(fade(edge, k-petal, base: base)),
  "#b0405f": hex(fade(heart, k-petal * 0.8, base: base)),
  "#f6efe2": hex(base),
))

// fail loudly instead of shrinking: a block must fit its slot
#let slot(name, w, h, body) = context {
  let m = measure(block(width: w, body))
  assert(m.height <= h, message: "Overflow in " + name + ": " + repr(m.height) + " > " + repr(h) + "; change the page plan by hand")
  block(width: w, height: h, body)
}
#let at(x, y, body) = place(top + left, dx: x, dy: y, body)

#let label(s, fill: C.brass, size: 7.2pt, track: 1.3pt) = text(font: body-font, size: size, weight: 700, tracking: track, fill: fill, caps(s))

// ---- a round eki-style stamp, single ink, upright ------------------------------
// size mm; rim: text set around the rim; key: stamp-<key>.svg; label: kanji in the foot
#let stamp(size, rim, key, kanji, ink: C.shu, ground: C.paper, solid: false, kanji-font: jp, kanji-size: auto) = context {
  let S = size * 1mm
  let fg = if solid { ground } else { ink }
  let bg = if solid { ink } else { ground }
  let rim-size = size * 0.225 * 1pt
  let cs = rim.clusters()
  let ws = cs.map(c => measure(text(font: (disp, jp), size: rim-size, weight: 700, c)).width / 1mm + size * 0.012)
  let tot = ws.sum()
  let rr = size / 2 - size * 0.105
  box(width: S, height: S, {
    place(top + left, circle(radius: S / 2, fill: bg, stroke: none))
    place(top + left, dx: size * 0.03 * 1mm, dy: size * 0.03 * 1mm, circle(radius: S / 2 - size * 0.03 * 1mm, fill: none, stroke: (paint: fg, thickness: size * 0.034 * 1mm)))
    place(top + left, dx: size * 0.19 * 1mm, dy: size * 0.19 * 1mm, circle(radius: S / 2 - size * 0.19 * 1mm, fill: none, stroke: (paint: fg, thickness: size * 0.013 * 1mm)))
    let acc = 0
    for (i, c) in cs.enumerate() {
      let a = (acc + ws.at(i) / 2) / tot * 360deg
      acc += ws.at(i)
      place(center + horizon, dx: rr * calc.sin(a) * 1mm, dy: -rr * calc.cos(a) * 1mm,
        rotate(a, text(font: (disp, jp), size: rim-size, weight: 700, fill: fg, top-edge: "x-height", bottom-edge: "baseline", c)))
    }
    place(center + horizon, dy: -size * 0.075 * 1mm, art("stamp-" + key + ".svg", width: size * 0.47 * 1mm, swaps: ("#c23a2b": hex(fg), "#d2462f": hex(fg))))
    place(center + horizon, dy: size * 0.235 * 1mm, text(font: kanji-font, size: (if kanji-size == auto { size * 0.25 * 1pt } else { kanji-size }), weight: 700, fill: fg, kanji))
  })
}

// ---- section heading, Flagship's numbered form -----------------------------------
#let heading(n, title, sub) = grid(columns: (13mm, 1fr), align: (left + top, left + top),
  text(font: num, size: 28pt, fill: C.brass, n),
  pad(top: 1.4mm, stack(spacing: 0.9mm,
    text(font: body-font, size: 15pt, weight: 700, fill: C.ink, top-edge: "cap-height", bottom-edge: "descender", title),
    text(font: body-font, size: 9pt, fill: C.muted, top-edge: "cap-height", bottom-edge: "baseline", sub),
  )),
)

#let diamond = box(baseline: -0.15em, rotate(45deg, rect(width: 1.25mm, height: 1.25mm, fill: C.brass)))
#let item(t) = grid(columns: (4mm, 1fr), diamond, t)

#set page(paper: "a4", margin: 0mm, fill: C.paper)
#set text(font: body-font, size: 10.5pt, fill: C.ink, lang: "el")
#set par(leading: 0.6em, spacing: 0.6em)

// ================================ PAGE 1 =============================================
#let BAND = 86mm

#at(0mm, 0mm, rect(width: 210mm, height: BAND, fill: C.hero))
// the cherry runs along the band's top edge from the right, above the contacts (frame 80 x 16 mm)
#let on-band = (base: C.hero, bark: rgb("eadad8"), petal: rgb("ffdcd6"), edge: rgb("ffbcb8"), heart: rgb("e98a8f"))
#place(top + right, sakura("sakura-canopy.svg", 0.3, 0.8, ..on-band, width: 80mm))

// the torii frames the portrait, the way Flagship's tools frame the engineer
#at(65mm, 4mm, art("torii.svg", width: 80mm))
// horizon line, the group following the leader's flag towards the gate, Fuji beyond
#at(18mm, 62mm, line(length: 174mm, stroke: 0.45pt + C.brass.transparentize(30%)))
#at(19mm, 43.6mm, art("group.svg", width: 44mm, swaps: ("#c9a86a": hex(C.brass), "#d2462f": hex(C.shu.lighten(8%)))))
#at(148mm, 41.6mm, art("fuji.svg", width: 44mm, swaps: ("#c9a86a": hex(C.brass), "#f3ead8": hex(C.on-hero))))

// portrait in a brass ring
#let PD = 42mm
#at(105mm - PD / 2 - 2.6mm, 15mm - 2.6mm, circle(radius: PD / 2 + 2.6mm, fill: C.hero, stroke: 0.5pt + C.brass))
#at(105mm - PD / 2, 15mm, box(width: PD, height: PD, radius: 50%, clip: true, stroke: 1.4pt + C.brass,
  image("../../portrait.jpg", width: PD, height: PD, fit: "cover")))
// the one seal struck in the band: Japan, five trips, 103 days
#at(116mm, 41mm, stamp(21, "ΙΑΠΩΝΙΑ · " + str(trips.len()) + " ΤΑΞΙΔΙΑ · " + str(jdays) + " ΗΜΕΡΕΣ · ", "fuji", "日本", solid: true, ground: C.on-hero, kanji-font: jpd))

// contacts: brass labels, light values, either side
#let contact(l, val, al) = block(width: 100%, below: 3.4mm, align(al, {
  label(l)
  linebreak()
  v(-1.6mm)
  text(size: 10pt, fill: C.on-hero, val)
}))
#at(16mm, 17mm, block(width: 50mm, {
  contact("Βάση", d.contact.city, left)
  contact("Τηλέφωνο", d.contact.phone, left)
  contact("Web", d.contact.link, left)
}))
#at(144mm, 17mm, block(width: 50mm, {
  contact("Email", d.contact.email, right)
  contact("Εξειδίκευση", [Ιαπωνία #text(font: jp, size: 9pt)[日本]], right)
  contact("Ιαπωνικά", [JLPT N4 · 12/2024], right)
}))

// the route runs through the name plate: ATH ......[ name ]...... plane TYO
#at(16mm, 67.6mm, label("Από · Αθήνα"))
#at(15.4mm, 70.2mm, text(font: num, size: 30pt, fill: C.on-hero)[ATH])
#at(37mm, 79mm, line(length: 16mm, stroke: (paint: C.brass, thickness: 0.7pt, dash: (0.6pt, 2pt), cap: "round")))
#at(157mm, 79mm, line(length: 10mm, stroke: (paint: C.brass, thickness: 0.7pt, dash: (0.6pt, 2pt), cap: "round")))
#at(168.6mm, 75.8mm, art("plane.svg", width: 8.6mm, swaps: ("#c23a2b": hex(C.shu.lighten(10%)))))
#place(top + right, dx: -16mm, dy: 67.6mm, label("Προς · Τόκιο"))
#place(top + right, dx: -15.6mm, dy: 70.2mm, text(font: num, size: 30pt, fill: C.on-hero)[TYO])

// name plate over the band's lower edge, with the role as a cinnabar tab
#let PLX = 55mm
#let PLY = 67mm
#at(PLX, PLY, rect(width: 100mm, height: 27mm, fill: C.plate, stroke: none))
#at(PLX + 1.4mm, PLY + 1.4mm, rect(width: 100mm - 2.8mm, height: 27mm - 2.8mm, stroke: 0.4pt + C.brass))
#at(105mm - 19mm, PLY - 5.6mm, rect(width: 38mm, height: 5.6mm, fill: C.shu,
  align(center + horizon, text(font: body-font, size: 7.6pt, weight: 700, tracking: 1.6pt, fill: C.on-hero)[ΑΡΧΗΓΟΣ #h(1mm) #text(font: jp, size: 7.4pt, tracking: 0.6pt)[添乗員]])))
#at(PLX, PLY + 0.6mm, block(width: 100mm, height: 27mm, align(center + horizon, stack(spacing: 2.6mm,
  text(font: disp, size: 34pt, weight: 800, tracking: 0.6pt, fill: C.ink, top-edge: "cap-height", bottom-edge: "baseline", d.name.caps),
  text(size: 8.4pt, weight: 700, tracking: 1.5pt, top-edge: "cap-height", bottom-edge: "baseline")[#text(fill: C.ink, d.title.caps) #h(1mm) #text(fill: C.shu)[· ΙΑΠΩΝΙΑ]],
))))

// ---- the field -------------------------------------------------------------------
#at(16mm, 102mm, slot("profile", 120mm, 25mm, par(leading: 0.62em, d.profile)))
// the offer, as a quiet cinnabar-labelled note beside the profile
#at(146mm, 102mm, slot("offer", 48mm, 25mm, {
  line(length: 100%, stroke: 1.2pt + C.shu)
  v(1.2mm)
  label("Για τους πελάτες σας", fill: C.shu, size: 7pt, track: 1.1pt)
  v(-0.6mm)
  text(size: 9.6pt, d.offer)
}))

// nature in the field: a branch reaching in from the right edge between the profile and
// section 01 (frame 78 x 29 mm, clear of every line of text), petals drifting in the margin
#let on-paper = (bark: rgb("5e4a55"), petal: rgb("f2c2cd"), edge: rgb("d4869c"), heart: rgb("b0405f"))
#at(132mm, 120mm, sakura("sakura-field.svg", 0.2, 0.5, ..on-paper, width: 78mm))
#at(199mm, 156mm, sakura("petals-drift.svg", 0.2, 0.42, ..on-paper, width: 10mm))

// 01 Japan, trip by trip: one eki stamp per stay
#at(16mm, 133mm, heading("01", "Η Ιαπωνία, ταξίδι προς ταξίδι", [Μία σφραγίδα για κάθε ταξίδι · #trips.len() ταξίδια · #jdays ημέρες στη χώρα · #trips.first().year–#trips.last().year]))
#let SY = 150mm
#let SD = 25
#let CW = 35.6mm
#at(16mm + SD / 2 * 1mm, SY + SD / 2 * 1mm, line(length: CW * 4, stroke: (paint: C.brass, thickness: 0.7pt, dash: (0.6pt, 2.2pt), cap: "round")))
#for (i, t) in trips.enumerate() {
  let x = 16mm + i * CW
  let rim = caps(t.places.slice(0, calc.min(3, t.places.len())).join(" · ")) + " · " + str(t.year) + " · "
  let key = ("torii", "book", "maple", "snow", "flag").at(i)
  at(x, SY, stamp(SD, rim, key, t.kanji))
  let lead = t.kind == "colead"
  at(x, SY + SD * 1mm + 3mm, slot("trip " + str(t.year), CW - 3mm, 34mm, {
    set par(leading: 0.42em)
    text(size: 11pt, weight: 700, t.when)
    linebreak()
    text(font: num, size: 15pt, fill: C.shu, str(t.days))
    h(0.8mm)
    text(size: 9pt, weight: 600, fill: C.shu)[ημέρες]
    linebreak()
    label(t.kind_el, fill: if lead { C.shu } else { C.brass-dk }, size: 6.8pt, track: 1pt)
    v(0.4mm)
    text(size: 9.4pt, t.places.join(", "))
    linebreak()
    text(font: jp, size: 8pt, fill: C.muted, t.kanji_places.join(" · "))
  }))
}

// 02 Experience, Flagship's date column and rule
#at(16mm, 213mm, heading("02", "Επαγγελματική εμπειρία", [Συνοδεία ομάδων, προγράμματα Ιαπωνίας, φιλοξενία]))
#let job(e) = grid(columns: (31mm, 1fr), column-gutter: 5mm,
  {
    set par(leading: 0.3em)
    text(font: num, size: 15pt, fill: C.hero2, e.from)
    linebreak()
    if e.current { text(size: 12.5pt, weight: 600, fill: C.hero2)[– σήμερα] } else { text(font: num, size: 15pt, fill: C.hero2)[– #e.to] }
    linebreak()
    v(0.6mm)
    text(size: 8.6pt, fill: C.muted, e.city)
  },
  block(stroke: (left: 1.6pt + C.hero), inset: (left: 5mm, top: 0.4mm, bottom: 1mm), {
    set par(leading: 0.5em)
    text(size: 13pt, weight: 700, e.role)
    linebreak()
    label(e.company, fill: C.brass-dk, size: 7.6pt, track: 1.4pt)
    v(0.2mm)
    for p in e.points { block(above: 2.4mm, below: 0mm, item(p)) }
  }),
)
#at(16mm, 229mm, slot("experience", 178mm, 53mm, {
  job(d.experience.at(0))
  v(4.2mm)
  job(d.experience.at(1))
}))

// footer
#at(16mm, 284mm, line(length: 178mm, stroke: 0.4pt + C.rule))
#at(16mm, 286mm, text(size: 6.6pt, tracking: 0.8pt, fill: C.muted)[ΦΑΝΤΑΣΤΙΚΟ ΠΡΟΣΩΠΟ ΚΑΙ ΠΟΡΤΡΑΙΤΟ AI · ΣΧΕΔΙΟ CVGEN])
#place(top + right, dx: -16mm, dy: 286mm, text(size: 6.6pt, tracking: 0.8pt, fill: C.muted)[HANAMI LINE #h(3mm) 01 / 02])

#pagebreak()

// ================================ PAGE 2 =============================================
#let BAND2 = 46mm
#at(0mm, 0mm, rect(width: 210mm, height: BAND2, fill: C.hero))
#at(16mm, 10.5mm, block(width: 92mm, {
  set par(leading: 0.5em)
  text(font: disp, size: 30pt, weight: 800, tracking: 0.5pt, fill: C.on-hero, top-edge: "cap-height", bottom-edge: "baseline", d.name.caps)
  v(1.4mm)
  label(d.title.caps, size: 7.8pt, track: 1.5pt)
  h(1.2mm)
  label("· Ιαπωνία", fill: rgb("f2907a"), size: 7.8pt, track: 1.5pt)
  h(1.8mm)
  text(font: jp, size: 7.8pt, weight: 400, fill: rgb("f2907a"))[日本]
  v(1.2mm)
  text(size: 9pt, fill: C.on-hero)[#d.contact.phone #h(1.6mm) · #h(1.6mm) #d.contact.email \ #d.contact.city #h(1.6mm) · #h(1.6mm) #d.contact.link]
}))
// the escort's own seal beside the name, as a hanko beside a signature
#at(84mm, 7.4mm, stamp(17, "ΑΡΧΗΓΟΣ · " + str(groups.len()) + " ΟΜΑΔΕΣ · " + str(gpax) + " ΘΕΣΕΙΣ · ", "flag", "添乗員", solid: true, ground: C.on-hero, kanji-size: 4.6pt))
// the escort drawing at full size: the group walks to the gate under the leader's flag, Fuji beyond
// (group, torii and Fuji at about 1.2-1.3x the first round; horizon at 41 mm)
#let HZ = 41mm
#at(103mm, HZ, line(length: 91mm, stroke: 0.45pt + C.brass.transparentize(30%)))
#at(148.6mm, HZ - 46mm * 26 / 56, art("fuji.svg", width: 46mm, swaps: ("#c9a86a": hex(C.brass), "#f3ead8": hex(C.on-hero))))
#at(144.6mm, HZ - 28mm * 58 / 80, art("torii.svg", width: 28mm, swaps: ("fill='none'": "fill='" + hex(C.hero) + "'")))
#at(102mm, HZ - 45mm * 21 / 50, art("group.svg", width: 45mm, swaps: ("#c9a86a": hex(C.brass), "#d2462f": hex(C.shu.lighten(8%)))))
#place(top + right, dx: -16mm, dy: 5.4mm, {
  text(font: num, size: 19pt, fill: C.on-hero)[ATH]
  h(1.8mm)
  box(baseline: -1.2mm, line(length: 12mm, stroke: (paint: C.brass, thickness: 0.8pt, dash: (0.6pt, 2.2pt), cap: "round")))
  h(1.2mm)
  box(baseline: 0.2mm, art("plane.svg", width: 7.4mm, swaps: ("#c23a2b": hex(C.shu.lighten(10%)))))
  h(1.8mm)
  text(font: num, size: 19pt, fill: C.on-hero)[TYO]
})

// nature in the field: a branch hanging in from the right edge just under the band
// (frame 90 x 24 mm from 2.5 mm below the band, clear of the heading and the table), petals in the margin
#at(120mm, BAND2 + 2.5mm, sakura("sakura-field-2.svg", 0.2, 0.5, ..on-paper, width: 90mm))
#at(199mm, 150mm, sakura("petals-drift.svg", 0.2, 0.42, ..on-paper, width: 10mm))

// 03 The groups he escorted: the manifest, with the totals in a band below it
#at(16mm, 57mm, heading("03", "Ομάδες που συνόδευσε", [Λίστα επιβατών · #groups.last().date.slice(3)–#groups.first().date.slice(3)]))
#at(16mm, 74mm, slot("manifest", 178mm, 52mm, {
  set text(size: 10pt)
  table(
    columns: (24mm, 1fr, 32mm, 30mm, 20mm), stroke: none, inset: (x: 3mm, y: 1.9mm),
    align: (left, left, left, right, right),
    fill: (_, y) => if y == 0 { C.hero } else if calc.even(y) { C.wash } else { none },
    ..("Αναχώρηση", "Προορισμός", "Ρόλος", "Συμμετέχοντες", "Ημέρες").map(h => text(size: 8.6pt, weight: 700, fill: C.on-hero, h)),
    ..groups.map(g => (
      text(font: num, size: 11pt, g.date),
      if g.japan { text(weight: 700, fill: C.shu, g.where) } else { g.where },
      if g.japan { text(weight: 700, fill: C.shu, g.role) } else { g.role },
      text(font: num, size: 11pt, str(g.pax)),
      text(font: num, size: 11pt, str(g.days)),
    )).flatten(),
    table.hline(stroke: 0.5pt + C.rule),
  )
}))
#let metric(n, l) = stack(spacing: 1.4mm,
  text(font: num, size: 24pt, fill: C.on-hero, top-edge: "cap-height", bottom-edge: "baseline", n),
  label(l, size: 6.8pt, track: 1.2pt),
)
#at(16mm, 123mm, block(width: 178mm, height: 18mm, fill: C.hero, inset: (x: 8mm), align(horizon, grid(columns: (1fr, 1.25fr, 1fr, 1fr),
  metric(str(groups.len()), "Ομάδες"),
  metric(str(gpax), "Θέσεις συμμετεχόντων"),
  metric(str(gdays), "Ημέρες συνοδείας"),
  metric(str(jdays), "Ημέρες στην Ιαπωνία"),
))))
#at(16mm, 142.6mm, text(size: 7.6pt, fill: C.muted)[Οι θέσεις συμμετεχόντων αθροίζονται ανά αναχώρηση και δεν είναι μοναδικά άτομα. Οι ημέρες στην Ιαπωνία μετρούν και τα πέντε ταξίδια του.])

// 04 Studies, papers, languages, availability
#at(16mm, 154mm, heading("04", "Σπουδές, γλώσσες, διαθεσιμότητα", [Τουρισμός, συνοδεία ομάδων, ιαπωνική γλώσσα, πρώτες βοήθειες]))
#let entry(title, school, when, note: none) = block(below: 4.4mm, stroke: (left: 1.6pt + C.brass), inset: (left: 4mm, y: 0.6mm), {
  set par(leading: 0.42em)
  grid(columns: (1fr, auto), text(size: 11pt, weight: 700, title), text(font: num, size: 12pt, fill: C.hero2, when))
  v(-0.6mm)
  text(size: 9.4pt, fill: C.muted, school)
  if note != none { linebreak(); text(size: 9pt, weight: 700, fill: C.shu, note) }
})
#at(16mm, 171mm, slot("studies", 100mm, 56mm, {
  for e in d.education { entry(e.title, e.school, e.years) }
  let c = d.certificates.first()
  entry(c.title, c.issuer, "", note: c.valid)
}))
#at(124mm, 171mm, slot("languages and availability", 70mm, 56mm, {
  for l in d.languages {
    block(width: 100%, fill: C.wash, inset: (x: 3.4mm, y: 1.9mm), above: 0mm, below: 1.6mm, {
      set par(leading: 0.4em)
      text(size: 10.5pt, weight: 700, l.name)
      h(1fr)
      text(size: 9.6pt, l.level)
      if "note" in l { linebreak(); h(1fr); text(size: 8.6pt, fill: C.muted, l.note) }
    })
  }
  v(1.6mm)
  label("Διαθεσιμότητα", fill: C.brass-dk)
  for k in d.availability { block(above: 2.4mm, below: 0mm, item(text(size: 9.6pt, k))) }
}))

// 05 On the ground in Japan, and on the road with a group
#at(16mm, 228mm, heading("05", "Στην Ιαπωνία · Στη συνοδεία", [Πρακτική γνώση της χώρας και καθήκοντα αρχηγού στον δρόμο]))
#at(16mm, 245mm, slot("know-how", 86mm, 37mm, {
  label("Στην Ιαπωνία", fill: C.brass-dk)
  for k in d.knowhow { block(above: 2.4mm, below: 0mm, item(text(size: 10.5pt, k))) }
}))
#at(108mm, 245mm, slot("on the road", 86mm, 37mm, {
  label("Στη συνοδεία", fill: C.brass-dk)
  for k in d.operations { block(above: 2.4mm, below: 0mm, item(text(size: 10.5pt, k))) }
}))

#at(16mm, 284mm, line(length: 178mm, stroke: 0.4pt + C.rule))
#at(16mm, 286mm, text(size: 6.6pt, tracking: 0.8pt, fill: C.muted)[ΦΑΝΤΑΣΤΙΚΟ ΠΡΟΣΩΠΟ ΚΑΙ ΠΟΡΤΡΑΙΤΟ AI · ΣΧΕΔΙΟ CVGEN])
#place(top + right, dx: -16mm, dy: 286mm, text(size: 6.6pt, tracking: 0.8pt, fill: C.muted)[HANAMI LINE #h(3mm) 02 / 02])
