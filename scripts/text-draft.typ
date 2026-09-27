// The Text Draft a client checks before design starts (docs/guides/client-workflow.md, step 8).
// House design "First Fitting" (idea run 2026-09-27, owner's pick 2026-09-28): warm paper,
// one copper thread. Every fact the client must check is underlined with a copper stitch;
// our wording is left plain. The tailoring idea lives only in the drawing; the words are
// plain and professional. Page 1 is the Check Page in the client's language, the rest is
// the CV's content in the CV's language, one column, easy to read on a phone.
//
//   #import "/scripts/text-draft.typ": text-draft, fact
//   #show: text-draft.with(
//     title: "Eleni Example - CV text - draft 01",
//     client: (name: "Ελένη Παράδειγμα", greeting: "Ελένη", label: "Πελάτισσα"),
//     draft: "01", date: "27.09.2026",
//     samples: (("Ονόματα", "Boreal Gas Carriers"), ("Ημερομηνίες", "2023 – 2026"),
//               ("Αριθμούς", "6 months"), ("Τίτλους", "Chief Officer")),
//   )
//   = Profile
//   Chief officer with #fact[six] years on LNG carriers ...
//
// lang: the CV's language, for the running head ("en" or "el"; default "en": set "el" for a
// Greek CV). check-lang: the Check Page's language (house copy exists for "el"; any other needs
// every line in copy:). copy: overrides of the house copy, by key (kicker, headline as two
// lines, intro as a function of the greeting, ask, ours, ok, fix, client, draft, date); a
// different headline moves the thread out of place. client.label defaults to "Πελάτης".
// Wrap every name, date, number and title the client must check in #fact[...]: the Check
// Page tells the client to check only what is underlined.
//
// Compile with --font-path packages/cv-framework/fonts (Bona Nova covers Greek).

#let paper = rgb("#F3EEE3")
#let ink = rgb("#1C1814")
#let copper = rgb("#B0602B")
#let quiet = rgb("#6E655A")
#let serif = "Bona Nova"

// The copper running stitch, and the one mark the client learns to look for: a checked fact.
#let stitch(w) = (paint: copper, thickness: w, dash: (w * 5.5, w * 3.2), cap: "round")
#let fact(body, w: 0.9pt, off: 3.2pt) = underline(stroke: stitch(w), offset: off, evade: false, extent: 1pt, body)

// Greek capitals drop their accents (tonos); a vowel pair keeps its split with a dialytika.
#let caps-el(s) = {
  let plain = ("ά": "α", "έ": "ε", "ή": "η", "ί": "ι", "ό": "ο", "ύ": "υ", "ώ": "ω", "ΐ": "ϊ", "ΰ": "ϋ",
    "Ά": "Α", "Έ": "Ε", "Ή": "Η", "Ί": "Ι", "Ό": "Ο", "Ύ": "Υ", "Ώ": "Ω")
  let cs = s.clusters()
  let out = ()
  for (i, c) in cs.enumerate() {
    let prev = if i > 0 { cs.at(i - 1) } else { "" }
    if prev in ("ά", "έ", "ό", "ύ") and c == "ι" { out.push("ϊ") }
    else if prev in ("ά", "έ", "ό") and c == "υ" { out.push("ϋ") }
    else { out.push(plain.at(c, default: c)) }
  }
  upper(out.join())
}
#let spaced(s, size: 8.5pt) = text(size: size, tracking: 0.16em, fill: quiet, caps-el(s))

// The needle: the signature marker, lying on the seam and pointing at a step the client takes.
// Its eye carries a short end of the thread.
#let needle = place(left, dx: -24mm, dy: 0.2em, box(width: 20mm, height: 4mm, {
  place(top + left, curve(fill: copper,
    curve.move((0mm, 2mm)),
    curve.cubic((0mm, 0.4mm), (1.2mm, 0.5mm), (3mm, 0.6mm)),
    curve.line((19.6mm, 1.85mm)),
    curve.quad((20mm, 2mm), (19.6mm, 2.15mm)),
    curve.line((3mm, 3.4mm)),
    curve.cubic((1.2mm, 3.5mm), (0mm, 3.6mm), (0mm, 2mm)),
    curve.close()))
  place(top + left, dx: 1.1mm, dy: 1.45mm, ellipse(width: 3.2mm, height: 1.1mm, fill: paper))
  place(top + left, curve(stroke: (paint: copper, thickness: 1pt, cap: "round"),
    curve.move((2.7mm, 2mm)), curve.cubic((-1.5mm, 2.6mm), (-3mm, 6mm), (-1mm, 9mm))))
}))

// House copy of the Check Page, per language of the check; any line can be overridden per client.
#let house-copy = (
  el: (
    kicker: "Προσχέδιο κειμένου",
    headline: ("Το βιογραφικό σας,", "προς έλεγχο."),
    intro: first => [#first, αυτό είναι το κείμενο του βιογραφικού σας, πριν ξεκινήσει ο σχεδιασμός.],
    ask: [Ελέγξτε μόνο τα υπογραμμισμένα στοιχεία:],
    ours: [Τη διατύπωση την αναλαμβάνουμε εμείς.],
    ok: [Όλα σωστά; Απαντήστε «OK».],
    fix: [Κάτι λάθος; Γράψτε μας τη σελίδα και το σωστό.],
    client: "Πελάτης",
    draft: "Προσχέδιο",
    date: "Ημερομηνία",
  ),
)
// Running head of the content pages, per language of the CV.
#let running = (
  en: (text: "CV text", draft: "draft", page: (n, total) => [Page #n of #total]),
  el: (text: "Κείμενο βιογραφικού", draft: "προσχέδιο", page: (n, total) => [Σελίδα #n από #total]),
)

// A tag card with a punched eyelet; the thread starts from it.
#let tag(lines) = rotate(4deg, reflow: false, box(
  width: 54mm, fill: rgb("#FBF8F1"), stroke: 0.5pt + rgb("#CFC4B2"), inset: (x: 5.5mm, top: 12mm, bottom: 6mm),
  {
    place(top + center, dy: -7.5mm, circle(radius: 1.7mm, fill: paper, stroke: 0.6pt + rgb("#B9AC98")))
    set par(leading: 0.5em, spacing: 1em)
    lines
  }))

// The thread on the Check Page, in page coordinates. It is tied through the tag's eyelet (the knot,
// drawn over the tag), runs behind the tag, falls in a loose loop between the headline and the
// intro and ends in a free tail. Tuned to the fixed house headline and the tag's place.
#let thread = place(top + left, dx: -34mm, dy: -26mm, {
  place(top + left, curve(stroke: stitch(1.3pt),
    curve.move((168mm, 42mm)),
    curve.cubic((162mm, 60mm), (150mm, 76mm), (128mm, 79mm)),
    curve.cubic((100mm, 83mm), (62mm, 76mm), (44mm, 80mm)),
    curve.cubic((31mm, 83mm), (31mm, 93mm), (46mm, 92mm)),
  ))
  place(top + left, curve(stroke: (paint: copper, thickness: 1.3pt, cap: "round"),
    curve.move((46mm, 92mm)),
    curve.cubic((56mm, 91mm), (64mm, 85mm), (74mm, 87mm)),
  ))
})
// The knot: from the eyelet the thread runs over the card's top edge and tucks behind it.
#let knot = place(top + left, dx: -34mm, dy: -26mm, place(top + left, curve(
  stroke: (paint: copper, thickness: 1.3pt, cap: "round"),
  curve.move((168.4mm, 42mm)), curve.cubic((168.8mm, 40mm), (169.6mm, 38.6mm), (170.2mm, 37.6mm)))))

#let check-page(client, draft, date, samples, copy, check-lang) = {
  let c = house-copy.at(check-lang, default: (:)) + copy
  let missing = house-copy.el.keys().filter(k => k not in c)
  assert(missing.len() == 0, message: "Text Draft: no house copy for check-lang \"" + check-lang
    + "\" (house copy exists for: " + house-copy.keys().join(", ") + "); pass these in copy: " + missing.join(", "))
  set text(lang: check-lang)
  place(top + left, dy: -6mm, spaced(c.kicker))
  thread
  place(top + right, dx: 10mm, dy: 10mm, tag[
    #spaced(client.at("label", default: c.client), size: 7pt) \
    #text(size: 13pt, client.name) \
    #v(1.5mm)
    #spaced(c.draft, size: 7pt) #h(1fr) #spaced(c.date, size: 7pt) \
    #text(size: 13pt, draft) #h(1fr) #text(size: 11pt, date) \
    #v(1.5mm)
    #text(size: 8pt, style: "italic", fill: quiet)[CVgen]
  ])
  knot

  v(12mm)
  block(width: 108mm, text(size: 38pt, style: "italic", {
    set par(leading: 0.42em)
    c.headline.at(0); linebreak(); c.headline.at(1)
  }))

  v(34mm)
  block(width: 140mm, text(size: 16pt, (c.intro)(client.greeting), hyphenate: false))

  v(14mm)
  block({ needle; text(size: 18pt, weight: "bold", c.ask) })
  v(6mm)
  // Rows grow with their content: a long company name wraps inside its own row.
  grid(columns: (52mm, 1fr), row-gutter: 5.5mm, align: (left + top, left + top),
    ..samples.map(((kind, sample)) => (text(size: 16pt, kind), text(size: 16pt, fact(sample, w: 1.1pt, off: 4pt)))).flatten())
  v(10mm)
  text(size: 15pt, style: "italic", fill: quiet, c.ours)

  // The reply stays in the flow at the foot of the page, so nothing above can print over it.
  v(1fr, weak: true)
  v(12mm)
  block(width: 150mm, breakable: false, {
    needle
    text(size: 22pt, weight: "bold", c.ok)
    v(1mm)
    text(size: 17pt, c.fix)
  })
  // No shrinking (constitution rule 4): a Check Page that runs past one page fails loudly.
  context assert(counter(page).get().first() == 1,
    message: "Text Draft: the Check Page runs past one page; shorten the samples or the copy overrides")
}

#let text-draft(title: "", client: none, draft: "01", date: "", samples: (), copy: (:),
                lang: "en", check-lang: "el", body) = {
  assert(lang in running, message: "Text Draft: no running head for lang \"" + lang + "\" (supported: "
    + running.keys().join(", ") + "); add it to `running` in scripts/text-draft.typ")
  let head = running.at(lang)
  set document(title: title)
  set page(paper: "a4", fill: paper, margin: (left: 34mm, right: 26mm, top: 26mm, bottom: 24mm),
    background: place(top + left, line(start: (15mm, 0mm), end: (15mm, 297mm), stroke: stitch(1.2pt))),
    header: context if counter(page).get().first() > 1 or client == none {
      set text(lang: lang)
      spaced(head.text + " · " + head.draft + " " + draft + " · " + date, size: 7.5pt)
      h(1fr)
      text(size: 12pt, (head.page)(counter(page).get().first(), counter(page).final().first()))
    })
  set text(font: serif, fill: ink, size: 13pt, lang: lang, number-type: "lining")
  set par(justify: false, leading: 0.78em, spacing: 1.3em)
  show heading.where(level: 1): it => block(above: 13mm, below: 5mm, { needle; text(size: 17pt, weight: "regular", style: "italic", it.body) })
  show heading.where(level: 2): it => block(above: 7mm, below: 3mm, text(size: 13.5pt, weight: "bold", it.body))

  if client != none {
    check-page(client, draft, date, samples, copy, check-lang)
    pagebreak()
  }
  body
}
