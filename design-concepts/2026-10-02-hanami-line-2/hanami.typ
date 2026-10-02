// Hanami Line 2: the shared design, one source for both palettes (magazine-editor, 2026-10-02).
// Entry points: spacious/stylish/spacious-stylish.typ (soft, the main design) and
// concept-indigo.typ (the same page in v1's indigo). Fictional data: sample.json.
// Artwork: assets/ (assets/make_assets.py writes every SVG; colours are tokens swapped here).
// Paths below resolve relative to this file.

#let d = json("sample.json")
#let A = "assets/"

// ---- palettes --------------------------------------------------------------------
#let palettes = (
  soft: (
    name: "soft",
    hero: rgb("dea1ae"), glow: rgb("f3d0d5"),       // dusty sakura band, a lighter bloom behind the portrait
    hero-text: rgb("2a1f3d"), hero-label: rgb("6e3450"), hero-line: rgb("3a2c55"), cap: rgb("fbf3ef"),
    plate: rgb("fffaf5"), keyline: rgb("b5835e"), shadow: rgb("2a1f3d"),
    paper: rgb("faf6ef"), ink: rgb("231f38"), muted: rgb("625d72"), wash: rgb("f3e9e5"), rule: rgb("e2d5cc"),
    num: rgb("b5835e"), label: rgb("8a5f3e"), date: rgb("3a2c55"), icon: rgb("8a5f3e"),
    dark: rgb("2e2448"), on-dark: rgb("fbf3ef"), dark-label: rgb("eab2bd"),
    shu: rgb("c23a2b"), shu-hero: rgb("c23a2b"), shu-soft: rgb("c23a2b"),
    seigaiha: 0.12, art-fill: 0.14,
    s-hero: (bark: rgb("3a2c55"), petal: rgb("fff3f3"), deep: rgb("f6c6ce"), edge: rgb("c97b8f"), heart: rgb("a8405e"), anther: rgb("e2b14e"), lent: rgb("ffffff"), kb: 0.42, kp: 0.95),
    s-paper: (bark: rgb("5e4a55"), petal: rgb("f6d2da"), deep: rgb("e595aa"), edge: rgb("d4869c"), heart: rgb("b0405f"), anther: rgb("e0b04c"), lent: rgb("ffffff"), kb: 0.28, kp: 0.78),
    s-fly: none,
    bg-k: 0.07,
  ),
  indigo: (
    name: "indigo",
    hero: rgb("1e2852"), glow: none,
    hero-text: rgb("fbf7ee"), hero-label: rgb("c4a265"), hero-line: rgb("c4a265"), cap: rgb("fbf7ee"),
    plate: rgb("fffcf4"), keyline: rgb("c4a265"), shadow: rgb("0e1430"),
    paper: rgb("f8f4ea"), ink: rgb("1b2036"), muted: rgb("5d6377"), wash: rgb("efe8d9"), rule: rgb("dcd2bd"),
    num: rgb("c4a265"), label: rgb("8f7037"), date: rgb("28356a"), icon: rgb("8f7037"),
    dark: rgb("1e2852"), on-dark: rgb("fbf7ee"), dark-label: rgb("c4a265"),
    shu: rgb("c23a2b"), shu-hero: rgb("d65445"), shu-soft: rgb("f2907a"),
    seigaiha: 0.1, art-fill: 0.07,
    s-hero: (bark: rgb("eadad8"), petal: rgb("ffe4e0"), deep: rgb("ffbcb8"), edge: rgb("f3a3ae"), heart: rgb("e98a8f"), anther: rgb("f0c66a"), lent: rgb("ffffff"), kb: 0.3, kp: 0.82),
    s-paper: (bark: rgb("5e4a55"), petal: rgb("f6d2da"), deep: rgb("e595aa"), edge: rgb("d4869c"), heart: rgb("b0405f"), anther: rgb("e0b04c"), lent: rgb("ffffff"), kb: 0.28, kp: 0.78),
    s-fly: (bark: rgb("eadad8"), petal: rgb("ffe2dd"), deep: rgb("ffb8b4"), edge: rgb("f7a9b2"), heart: rgb("e98a8f"), anther: rgb("f0c66a"), lent: rgb("ffffff"), kb: 0.3, kp: 1.0),
    bg-k: 0.07,
  ),
)

#let body-font = "Source Sans 3"
#let disp = "Sofia Sans"      // Sofia Sans Extra Condensed (Greek)
#let num = "Barlow"           // Barlow Condensed SemiBold: figures and IATA codes, never Greek
#let jp = "M PLUS 1p"
#let jpd = "Kaisei Tokumin"

#let trips = d.japan_trips
#let groups = d.groups
#let jdays = trips.map(t => t.days).sum()
#let gpax = groups.map(g => g.pax).sum()
#let gdays = groups.map(g => g.days).sum()
#assert(jdays == 103 and gpax == 162 and gdays == 39, message: "sample totals changed: re-check the copy that quotes them")

#let caps(s) = {
  let m = ("Ά": "Α", "Έ": "Ε", "Ή": "Η", "Ί": "Ι", "Ό": "Ο", "Ύ": "Υ", "Ώ": "Ω", "ΐ": "Ϊ", "ΰ": "Ϋ")
  upper(s).clusters().map(c => m.at(c, default: c)).join()
}
#let hex(c) = c.to-hex()
#let fade(c, k, base) = color.mix((c, k * 100%), (base, (1 - k) * 100%))

#let art(name, width: auto, height: auto, swaps: (:)) = {
  let s = read(A + name)
  for (from, to) in swaps { s = s.replace(from, to) }
  image(bytes(s), format: "svg", width: width, height: height)
}
// sakura tokens, faded into the ground they sit on
#let sak(S, base) = (
  "#5e4a55": hex(fade(S.bark, S.kb, base)), "#f6d2da": hex(fade(S.petal, S.kp, base)),
  "#e595aa": hex(fade(S.deep, S.kp, base)), "#d4869c": hex(fade(S.edge, S.kp, base)),
  "#b0405f": hex(fade(S.heart, S.kp * 0.85, base)), "#e0b04c": hex(fade(S.anther, S.kp, base)),
  "#f6efe2": hex(fade(S.lent, 0.6, base)),
)
// line art on the band
#let line-art(P, band: none) = (
  "#c9a86a": hex(P.hero-line), "#f3ead8": hex(P.cap), "#d2462f": hex(P.shu-hero),
  "#0b0b0b": (if band == none { "none" } else { hex(band) }), "#fefefe": hex(if band == none { P.hero } else { band }),
  "fill-opacity='0.14'": "fill-opacity='" + str(P.art-fill) + "'",
)
// pale background pieces: 5-9 % tone of the ink on paper, tone-on-tone on the band
#let bg-paper(P) = ("#bbbbbb": hex(fade(P.ink, P.bg-k * 0.4, P.paper)), "#999999": hex(fade(P.ink, P.bg-k, P.paper)), "#0b0b0b": hex(P.paper))
#let bg-band(P) = ("#0b0b0b": hex(P.hero), "#999999": hex(fade(P.hero-line, P.seigaiha, P.hero)))

#let slot(name, w, h, body) = context {
  let m = measure(block(width: w, body))
  assert(m.height <= h, message: "Overflow in " + name + ": " + repr(m.height) + " > " + repr(h) + "; change the page plan by hand")
  block(width: w, height: h, body)
}
#let at(x, y, body) = place(top + left, dx: x, dy: y, body)
#let label(s, fill: black, size: 7.2pt, track: 1.3pt) = text(font: body-font, size: size, weight: 700, tracking: track, fill: fill, caps(s))

// ---- a round eki-style stamp: double-ring rim, set type, one ink ------------------
// rim items are joined by small four-point stars; key = stamp-<key>.svg
#let stamp(size, items, key, kanji, ink: red, ground: white, solid: false, kanji-font: jp, kanji-size: auto) = context {
  let S = size * 1mm
  let fg = if solid { ground } else { ink }
  let bg = if solid { ink } else { ground }
  let rim-size = size * 0.205 * 1pt
  let star-w = size * 0.034
  let seq = ()
  for it in items { for c in it.clusters() { seq.push(c) }; seq.push("✦") }
  let ws = seq.map(c => if c == "✦" { star-w * 3.2 } else { measure(text(font: (disp, jp), size: rim-size, weight: 600, c)).width / 1mm + size * 0.016 })
  let tot = ws.sum()
  let rr = size / 2 - size * 0.13
  let ring(r, t) = place(center + horizon, circle(radius: r * 1mm, fill: none, stroke: (paint: fg, thickness: t * 1mm)))
  box(width: S, height: S, {
    place(center + horizon, circle(radius: S / 2, fill: bg, stroke: none))
    ring(size / 2 - size * 0.025, size * 0.036)
    ring(size / 2 - size * 0.068, size * 0.009)
    ring(size / 2 - size * 0.2, size * 0.012)
    let acc = 0
    for (i, c) in seq.enumerate() {
      let a = (acc + ws.at(i) / 2) / tot * 360deg
      acc += ws.at(i)
      let dx = rr * calc.sin(a) * 1mm
      let dy = -rr * calc.cos(a) * 1mm
      if c == "✦" {
        place(center + horizon, dx: dx, dy: dy, rotate(a + 45deg, rect(width: star-w * 1mm, height: star-w * 1mm, fill: fg)))
      } else {
        place(center + horizon, dx: dx, dy: dy, rotate(a, text(font: (disp, jp), size: rim-size, weight: 600, tracking: 0pt, fill: fg, top-edge: "x-height", bottom-edge: "baseline", c)))
      }
    }
    place(center + horizon, dy: -size * 0.07 * 1mm, art("stamp-" + key + ".svg", width: size * 0.46 * 1mm, swaps: ("#c23a2b": hex(fg), "#fefefe": hex(bg))))
    place(center + horizon, dy: size * 0.23 * 1mm, text(font: kanji-font, size: (if kanji-size == auto { size * 0.24 * 1pt } else { kanji-size }), weight: 700, fill: fg, kanji))
  })
}

#let heading(P, n, title, sub) = grid(columns: (13mm, 1fr), align: (left + top, left + top),
  text(font: num, size: 28pt, fill: P.num, n),
  pad(top: 1.4mm, stack(spacing: 0.9mm,
    text(font: body-font, size: 15pt, weight: 700, fill: P.ink, top-edge: "cap-height", bottom-edge: "descender", title),
    text(font: body-font, size: 9pt, fill: P.muted, top-edge: "cap-height", bottom-edge: "baseline", sub),
  )),
)
#let diamond(P) = box(baseline: -0.15em, rotate(45deg, rect(width: 1.25mm, height: 1.25mm, fill: P.num)))
#let item(P, t) = grid(columns: (4mm, 1fr), diamond(P), t)

// a soft shadow from stacked translucent layers (vector, prints cleanly): about 2 mm down, ~16 % at its core
#let soft-shadow(x, y, w, h, col) = for i in range(9) {
  let s = i * 0.34mm
  at(x - s + 0.6mm, y + 2.2mm - s * 0.5, rect(width: w + 2 * s - 1.2mm, height: h + 2 * s - 0.8mm, radius: s + 0.6mm, fill: col.transparentize(98%)))
}

#let render(pal) = {
  let P = palettes.at(pal)
  set page(paper: "a4", margin: 0mm, fill: P.paper)
  set text(font: body-font, size: 10.5pt, fill: P.ink, lang: "el")
  set par(leading: 0.6em, spacing: 0.6em)
  let H = sak(P.s-hero, P.hero)
  let W = sak(P.s-paper, P.paper)
  let FH = if P.s-fly == none { H } else { sak(P.s-fly, P.hero) }

  // =============================== PAGE 1 =========================================
  let BAND = 86mm
  at(0mm, 0mm, rect(width: 210mm, height: BAND, fill: P.hero))
  if P.glow != none {
    at(105mm - 75mm, 36mm - 52mm, ellipse(width: 150mm, height: 104mm, fill: gradient.radial((P.glow, 0%), (P.glow.transparentize(40%), 45%), (P.hero.transparentize(100%), 100%))))
  }
  // seigaiha: the sea under the horizon, tone-on-tone, in both lower corners of the band
  at(0mm, 63mm, box(width: 56mm, height: 23mm, clip: true, art("bg-seigaiha.svg", width: 60mm, swaps: bg-band(P))))
  at(154mm, 63mm, box(width: 56mm, height: 23mm, clip: true, art("bg-seigaiha.svg", width: 60mm, swaps: bg-band(P))))
  // the cherry canopy along the band's top edge
  place(top + right, art("sakura-canopy.svg", width: 80mm, swaps: H))

  at(65mm, 4mm, art("torii.svg", width: 80mm, swaps: line-art(P)))
  at(18mm, 62mm, line(length: 174mm, stroke: 0.45pt + P.hero-line.transparentize(35%)))
  at(18mm, 62mm - 46mm * 23 / 56, art("group.svg", width: 46mm, swaps: line-art(P)))
  at(148mm, 62mm - 44mm * 26 / 56, art("fuji.svg", width: 44mm, swaps: line-art(P)))

  let PD = 42mm
  at(105mm - PD / 2 - 2.6mm, 15mm - 2.6mm, circle(radius: PD / 2 + 2.6mm, fill: P.hero, stroke: 0.5pt + P.keyline))
  at(105mm - PD / 2, 15mm, box(width: PD, height: PD, radius: 50%, clip: true, stroke: 1.4pt + P.keyline,
    image("portrait.jpg", width: PD, height: PD, fit: "cover")))
  at(116mm, 41mm, stamp(21, ("ΙΑΠΩΝΙΑ", str(trips.len()) + " ΤΑΞΙΔΙΑ", str(jdays) + " ΗΜΕΡΕΣ"), "fuji", "日本", ink: P.shu, ground: P.plate, solid: true, kanji-font: jpd))
  // petals in flight through the band (laid out clear of every line of text)
  at(0mm, 0mm, art("petals-p1-hero.svg", width: 210mm, swaps: FH))

  let contact(l, val, al) = block(width: 100%, below: 3.4mm, align(al, {
    label(l, fill: P.hero-label)
    linebreak()
    v(-1.6mm)
    text(size: 10pt, fill: P.hero-text, val)
  }))
  at(16mm, 17mm, block(width: 50mm, {
    contact("Βάση", d.contact.city, left)
    contact("Τηλέφωνο", d.contact.phone, left)
    contact("Web", d.contact.link, left)
  }))
  at(144mm, 17mm, block(width: 50mm, {
    contact("Email", d.contact.email, right)
    contact("Εξειδίκευση", [Ιαπωνία #text(font: jp, size: 9pt)[日本]], right)
    contact("Ιαπωνικά", [JLPT N4 · 12/2024], right)
  }))

  // the route runs through the name plate
  at(16mm, 67.6mm, label("Από · Αθήνα", fill: P.hero-label))
  at(15.4mm, 70.2mm, text(font: num, size: 30pt, fill: P.hero-text)[ATH])
  at(37mm, 79mm, line(length: 16mm, stroke: (paint: P.hero-line, thickness: 0.7pt, dash: (0.6pt, 2pt), cap: "round")))
  at(157mm, 79mm, line(length: 10mm, stroke: (paint: P.hero-line, thickness: 0.7pt, dash: (0.6pt, 2pt), cap: "round")))
  at(168mm, 75.6mm, art("plane.svg", width: 9mm, swaps: ("#d2462f": hex(P.shu-hero))))
  place(top + right, dx: -16mm, dy: 67.6mm, label("Προς · Τόκιο", fill: P.hero-label))
  place(top + right, dx: -15.6mm, dy: 70.2mm, text(font: num, size: 30pt, fill: P.hero-text)[TYO])

  // the name plate, lifted a little by a soft shadow, with the role as a cinnabar tab
  let PLX = 55mm
  let PLY = 67mm
  soft-shadow(PLX, PLY, 100mm, 27mm, P.shadow)
  at(PLX, PLY, rect(width: 100mm, height: 27mm, fill: P.plate, stroke: none))
  at(PLX + 1.4mm, PLY + 1.4mm, rect(width: 100mm - 2.8mm, height: 27mm - 2.8mm, stroke: 0.4pt + P.keyline))
  at(105mm - 19mm, PLY - 5.6mm, rect(width: 38mm, height: 5.6mm, fill: P.shu,
    align(center + horizon, text(font: body-font, size: 7.6pt, weight: 700, tracking: 1.6pt, fill: P.plate)[ΑΡΧΗΓΟΣ #h(1mm) #text(font: jp, size: 7.4pt, tracking: 0.6pt)[添乗員]])))
  at(PLX, PLY + 0.6mm, block(width: 100mm, height: 27mm, align(center + horizon, stack(spacing: 2.6mm,
    text(font: disp, size: 34pt, weight: 800, tracking: 0.6pt, fill: P.ink, top-edge: "cap-height", bottom-edge: "baseline", d.name.caps),
    text(size: 8.4pt, weight: 700, tracking: 1.5pt, top-edge: "cap-height", bottom-edge: "baseline")[#text(fill: P.ink, d.title.caps) #h(1mm) #text(fill: P.shu)[· ΙΑΠΩΝΙΑ]],
  ))))

  // ---- the field ----------------------------------------------------------------
  at(0mm, BAND, art("petals-p1-field.svg", width: 210mm, swaps: W))
  at(139mm, 136mm, art("bg-shinkansen.svg", width: 66mm, swaps: bg-paper(P)))
  at(166mm, 212mm, art("bg-lanterns.svg", width: 26mm, swaps: bg-paper(P)))

  // profile, structured: the lead statement, the offer, then four facts from the profile
  at(16mm, 99.6mm, block(width: 112mm, {
    text(size: 15pt, weight: 600, fill: P.ink)[Αρχηγός-συνοδός με εξειδίκευση στην Ιαπωνία]
  }))
  at(132mm, 96.8mm, slot("offer", 62mm, 13.4mm, block(stroke: (left: 1.6pt + P.shu), inset: (left: 3mm, y: 0.4mm), {
    set par(leading: 0.42em)
    label("Για τους πελάτες σας", fill: P.shu, size: 6.8pt, track: 1.1pt)
    linebreak()
    text(size: 8.8pt, d.offer)
  })))
  at(16mm, 111mm, line(length: 178mm, stroke: 0.5pt + P.keyline.transparentize(30%)))
  let cell(icon, title, body) = grid(columns: (8.6mm, 1fr), column-gutter: 2.2mm,
    pad(top: 0.2mm, art("icon-" + icon + ".svg", width: 8.6mm, swaps: ("#7a5a3a": hex(P.icon), "#fefefe": hex(P.paper)))),
    {
      set par(leading: 0.42em)
      text(size: 10pt, weight: 700, title)
      linebreak()
      text(size: 9.2pt, fill: P.muted, body)
    },
  )
  at(16mm, 113.8mm, slot("profile cells", 178mm, 19mm, grid(columns: (1fr, 1fr, 1fr, 1fr), column-gutter: 4.4mm,
    cell("seasons", "Όλες οι εποχές", [Ταξίδια σε όλες τις εποχές, σπουδές ιαπωνικών στη Φουκουόκα]),
    cell("flag", "Συν-αρχηγία", [Ομαδική εκδρομή στην Ιαπωνία, άνοιξη 2026]),
    cell("check", "Ακρίβεια", [Καταμετρήσεις, vouchers, καθημερινή αναφορά· ψύχραιμος στα απρόοπτα]),
    cell("calendar", "Διαθεσιμότητα", [10–15ήμερα ταξίδια και διαδοχικές αναχωρήσεις]),
  )))

  // 01 Japan, trip by trip
  at(16mm, 136mm, heading(P, "01", "Η Ιαπωνία, ταξίδι προς ταξίδι", [Μία σφραγίδα για κάθε ταξίδι · #trips.len() ταξίδια · #jdays ημέρες στη χώρα · #trips.first().year–#trips.last().year]))
  let SY = 153mm
  let SD = 25
  let CW = 35.6mm
  at(16mm + SD / 2 * 1mm, SY + SD / 2 * 1mm, line(length: CW * 4, stroke: (paint: P.num, thickness: 0.7pt, dash: (0.6pt, 2.2pt), cap: "round")))
  for (i, t) in trips.enumerate() {
    let x = 16mm + i * CW
    let rim = t.places.slice(0, calc.min(3, t.places.len())).map(caps) + (str(t.year),)
    let key = ("torii", "book", "maple", "snow", "flag").at(i)
    at(x, SY, stamp(SD, rim, key, t.kanji, ink: P.shu, ground: P.paper))
    let lead = t.kind == "colead"
    at(x, SY + SD * 1mm + 3mm, slot("trip " + str(t.year), CW - 3mm, 34mm, {
      set par(leading: 0.42em)
      text(size: 11pt, weight: 700, t.when)
      linebreak()
      text(font: num, size: 15pt, fill: P.shu, str(t.days))
      h(0.8mm)
      text(size: 9pt, weight: 600, fill: P.shu)[ημέρες]
      linebreak()
      label(t.kind_el, fill: if lead { P.shu } else { P.label }, size: 6.8pt, track: 1pt)
      v(0.4mm)
      text(size: 9.4pt, t.places.join(", "))
      linebreak()
      text(font: jp, size: 8pt, fill: P.muted, t.kanji_places.join(" · "))
    }))
  }

  // 02 Experience
  at(16mm, 214.5mm, heading(P, "02", "Επαγγελματική εμπειρία", [Συνοδεία ομάδων, προγράμματα Ιαπωνίας, φιλοξενία]))
  let job(e) = grid(columns: (31mm, 1fr), column-gutter: 5mm,
    {
      set par(leading: 0.3em)
      text(font: num, size: 15pt, fill: P.date, e.from)
      linebreak()
      text(font: num, size: 15pt, fill: P.date)[–]
      h(1.2mm)
      if e.current { text(size: 12.5pt, weight: 600, fill: P.date)[σήμερα] } else { text(font: num, size: 15pt, fill: P.date, e.to) }
      linebreak()
      v(0.6mm)
      text(size: 8.6pt, fill: P.muted, e.city)
    },
    block(stroke: (left: 1.6pt + P.date), inset: (left: 5mm, top: 0.4mm, bottom: 1mm), {
      set par(leading: 0.5em)
      text(size: 13pt, weight: 700, e.role)
      linebreak()
      label(e.company, fill: P.label, size: 7.6pt, track: 1.4pt)
      v(0.2mm)
      for p in e.points { block(above: 2.4mm, below: 0mm, item(P, p)) }
    }),
  )
  at(16mm, 230.5mm, slot("experience", 178mm, 52.2mm, {
    job(d.experience.at(0))
    v(4.2mm)
    job(d.experience.at(1))
  }))
  at(16mm, 284mm, line(length: 178mm, stroke: 0.4pt + P.rule))
  at(16mm, 286mm, text(size: 6.6pt, tracking: 0.8pt, fill: P.muted)[ΦΑΝΤΑΣΤΙΚΟ ΠΡΟΣΩΠΟ ΚΑΙ ΠΟΡΤΡΑΙΤΟ AI · ΣΧΕΔΙΟ CVGEN])
  place(top + right, dx: -16mm, dy: 286mm, text(size: 6.6pt, tracking: 0.8pt, fill: P.muted)[HANAMI LINE #h(3mm) 01 / 02])

  pagebreak()

  // =============================== PAGE 2 =========================================
  let BAND2 = 46mm
  at(0mm, 0mm, rect(width: 210mm, height: BAND2, fill: P.hero))
  at(0mm, 38mm, box(width: 100mm, height: 8mm, clip: true, art("bg-seigaiha.svg", width: 100mm, swaps: bg-band(P))))
  at(0mm, 0mm, art("petals-p2-hero.svg", width: 210mm, swaps: FH))
  at(16mm, 10.5mm, block(width: 92mm, {
    set par(leading: 0.5em)
    text(font: disp, size: 30pt, weight: 800, tracking: 0.5pt, fill: P.hero-text, top-edge: "cap-height", bottom-edge: "baseline", d.name.caps)
    v(1.4mm)
    label(d.title.caps, fill: P.hero-label, size: 7.8pt, track: 1.5pt)
    h(1.2mm)
    label("· Ιαπωνία", fill: P.shu-soft, size: 7.8pt, track: 1.5pt)
    h(1.8mm)
    text(font: jp, size: 7.8pt, weight: 400, fill: P.shu-soft)[日本]
    v(1.2mm)
    text(size: 9pt, fill: P.hero-text)[#d.contact.phone #h(1.6mm) · #h(1.6mm) #d.contact.email \ #d.contact.city #h(1.6mm) · #h(1.6mm) #d.contact.link]
  }))
  at(84mm, 7.4mm, stamp(17, ("ΑΡΧΗΓΟΣ", str(groups.len()) + " ΟΜΑΔΕΣ", str(gpax) + " ΘΕΣΕΙΣ"), "flag", "添乗員", ink: P.shu, ground: P.plate, solid: true, kanji-size: 4.6pt))
  let HZ = 41mm
  at(103mm, HZ, line(length: 91mm, stroke: 0.45pt + P.hero-line.transparentize(35%)))
  at(155.4mm, HZ - 40mm * 26 / 56, art("fuji.svg", width: 40mm, swaps: line-art(P, band: P.hero)))
  at(144.6mm, HZ - 28mm * 58 / 80, art("torii.svg", width: 28mm, swaps: line-art(P, band: P.hero)))
  at(101mm, HZ - 46mm * 23 / 56, art("group.svg", width: 46mm, swaps: line-art(P)))
  place(top + right, dx: -16mm, dy: 5.4mm, {
    text(font: num, size: 19pt, fill: P.hero-text)[ATH]
    h(1.8mm)
    box(baseline: -1.2mm, line(length: 12mm, stroke: (paint: P.hero-line, thickness: 0.8pt, dash: (0.6pt, 2.2pt), cap: "round")))
    h(1.2mm)
    box(baseline: 0.2mm, art("plane.svg", width: 7.6mm, swaps: ("#d2462f": hex(P.shu-hero))))
    h(1.8mm)
    text(font: num, size: 19pt, fill: P.hero-text)[TYO]
  })

  // the field: the page-2 branch 2 mm under the band (frame 90 x 20 mm, 6 mm clear of the table)
  at(120mm, BAND2 + 2mm, art("sakura-field-2.svg", width: 90mm, swaps: W))
  at(0mm, BAND2, art("petals-p2-field.svg", width: 210mm, swaps: W))
  at(160mm, 150mm, art("bg-fan.svg", width: 34mm, swaps: bg-paper(P)))
  at(172mm, 223mm, art("bg-pagoda.svg", height: 22mm, swaps: bg-paper(P)))

  at(16mm, 57mm, heading(P, "03", "Ομάδες που συνόδευσε", [Λίστα επιβατών · #groups.last().date.slice(3)–#groups.first().date.slice(3)]))
  at(16mm, 74mm, slot("manifest", 178mm, 52mm, {
    set text(size: 10pt)
    table(
      columns: (24mm, 1fr, 32mm, 30mm, 20mm), stroke: none, inset: (x: 3mm, y: 1.9mm),
      align: (left, left, left, right, right),
      fill: (_, y) => if y == 0 { P.dark } else if calc.even(y) { P.wash } else { none },
      ..("Αναχώρηση", "Προορισμός", "Ρόλος", "Συμμετέχοντες", "Ημέρες").map(h => text(size: 8.6pt, weight: 700, fill: P.on-dark, h)),
      ..groups.map(g => (
        text(font: num, size: 11pt, g.date),
        if g.japan { text(weight: 700, fill: P.shu, g.where) } else { g.where },
        if g.japan { text(weight: 700, fill: P.shu, g.role) } else { g.role },
        text(font: num, size: 11pt, str(g.pax)),
        text(font: num, size: 11pt, str(g.days)),
      )).flatten(),
      table.hline(stroke: 0.5pt + P.rule),
    )
  }))
  let metric(n, l) = stack(spacing: 1.4mm,
    text(font: num, size: 24pt, fill: P.on-dark, top-edge: "cap-height", bottom-edge: "baseline", n),
    label(l, fill: P.dark-label, size: 6.8pt, track: 1.2pt),
  )
  at(16mm, 123mm, block(width: 178mm, height: 18mm, fill: P.dark, inset: (x: 8mm), align(horizon, grid(columns: (1fr, 1fr, 1fr, 1fr),
    metric(str(groups.len()), "Ομάδες"),
    metric(str(gpax), "Θέσεις συμμετεχόντων"),
    metric(str(gdays), "Ημέρες συνοδείας"),
    metric(str(jdays), "Ημέρες στην Ιαπωνία"),
  ))))
  at(16mm, 142.6mm, text(size: 7.6pt, fill: P.muted)[Οι θέσεις συμμετεχόντων αθροίζονται ανά αναχώρηση και δεν είναι μοναδικά άτομα. Οι ημέρες στην Ιαπωνία μετρούν και τα πέντε ταξίδια του.])

  at(16mm, 154mm, heading(P, "04", "Σπουδές, γλώσσες, διαθεσιμότητα", [Τουρισμός, συνοδεία ομάδων, ιαπωνική γλώσσα, πρώτες βοήθειες]))
  let entry(title, school, when, note: none) = block(below: 4.4mm, stroke: (left: 1.6pt + P.num), inset: (left: 4mm, y: 0.6mm), {
    set par(leading: 0.42em)
    grid(columns: (1fr, auto), text(size: 11pt, weight: 700, title), text(font: num, size: 12pt, fill: P.date, when))
    v(-0.6mm)
    text(size: 9.4pt, fill: P.muted, school)
    if note != none { linebreak(); text(size: 9pt, weight: 700, fill: P.date, note) }
  })
  at(16mm, 171mm, slot("studies", 100mm, 56mm, {
    for e in d.education { entry(e.title, e.school, e.years) }
    let c = d.certificates.first()
    entry(c.title, c.issuer, "", note: c.valid)
  }))
  at(124mm, 171mm, slot("languages and availability", 70mm, 56mm, {
    for l in d.languages {
      block(width: 100%, fill: P.wash, inset: (x: 3.4mm, y: 1.9mm), above: 0mm, below: 1.6mm, {
        set par(leading: 0.4em)
        text(size: 10.5pt, weight: 700, l.name)
        h(1fr)
        text(size: 9.6pt, l.level)
        if "note" in l { linebreak(); h(1fr); text(size: 8.6pt, fill: P.muted, l.note) }
      })
    }
    v(1.6mm)
    label("Διαθεσιμότητα", fill: P.label)
    for k in d.availability { block(above: 2.4mm, below: 0mm, item(P, text(size: 9.6pt, k))) }
  }))

  at(16mm, 228mm, heading(P, "05", "Στην Ιαπωνία · Στη συνοδεία", [Πρακτική γνώση της χώρας και καθήκοντα αρχηγού στον δρόμο]))
  at(16mm, 245mm, slot("know-how", 86mm, 37mm, {
    label("Στην Ιαπωνία", fill: P.label)
    for k in d.knowhow { block(above: 2.4mm, below: 0mm, item(P, text(size: 10.5pt, k))) }
  }))
  at(108mm, 245mm, slot("on the road", 86mm, 37mm, {
    label("Στη συνοδεία", fill: P.label)
    for k in d.operations { block(above: 2.4mm, below: 0mm, item(P, text(size: 10.5pt, k))) }
  }))
  at(16mm, 284mm, line(length: 178mm, stroke: 0.4pt + P.rule))
  at(16mm, 286mm, text(size: 6.6pt, tracking: 0.8pt, fill: P.muted)[ΦΑΝΤΑΣΤΙΚΟ ΠΡΟΣΩΠΟ ΚΑΙ ΠΟΡΤΡΑΙΤΟ AI · ΣΧΕΔΙΟ CVGEN])
  place(top + right, dx: -16mm, dy: 286mm, text(size: 6.6pt, tracking: 0.8pt, fill: P.muted)[HANAMI LINE #h(3mm) 02 / 02])
}
