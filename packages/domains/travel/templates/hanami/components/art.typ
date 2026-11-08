// Hanami's small shared parts: the artwork reader with the theme's colour swaps, capitals, labels,
// fixed slots, absolute placement and the bullet list. Every other component builds on these.

// Greek capitals carry no accents; Latin text is only upper-cased.
#let caps(s) = {
  let m = ("Ά": "Α", "Έ": "Ε", "Ή": "Η", "Ί": "Ι", "Ό": "Ο", "Ύ": "Υ", "Ώ": "Ω", "ΐ": "Ϊ", "ΰ": "Ϋ")
  upper(s).clusters().map(c => m.at(c, default: c)).join()
}
#let hex(c) = c.to-hex()
#let fade(c, k, base) = color.mix((c, k * 100%), (base, (1 - k) * 100%))

// The theme's colours, levels and glow as one flat dictionary, read by every component.
#let tokens(ctx) = (..ctx.theme.colors, ..ctx.theme.levels, glow: ctx.theme.glow)

// One picture of the pack, its source colours swapped for the theme's (each SVG is drawn in fixed
// token colours, so a swap is a plain text replacement).
#let art(ctx, key, width: auto, height: auto, swaps: (:)) = {
  assert(key in ctx.artwork, message: "The artwork pack has no " + key + "; add it to the pack (templates/hanami/artwork/)")
  let s = read(ctx.artwork.at(key))
  for (from, to) in swaps { s = s.replace(from, to) }
  image(bytes(s), format: "svg", width: width, height: height)
}

// Sakura drawn in fixed colours, recoloured by one of the theme's sakura sets over a ground.
#let sakura(S, base) = (
  "#5e4a55": hex(fade(S.bark, S.kb, base)), "#f6d2da": hex(fade(S.petal, S.kp, base)),
  "#e595aa": hex(fade(S.deep, S.kp, base)), "#d4869c": hex(fade(S.edge, S.kp, base)),
  "#b0405f": hex(fade(S.heart, S.kp * 0.85, base)), "#e0b04c": hex(fade(S.anther, S.kp, base)),
  "#f6efe2": hex(fade(S.lent, 0.6, base)),
)
// The band's line art (torii, Fuji, the group, the plane); `band` paints the ground behind it.
#let line-art(P, band: none) = (
  "#c9a86a": hex(P.hero-line), "#f3ead8": hex(P.cap), "#d2462f": hex(P.accent-hero), "#7f8fa6": hex(P.tone), "#f1dcae": hex(P.sun),
  "#0b0b0b": (if band == none { "none" } else { hex(band) }), "#fefefe": hex(if band == none { P.hero } else { band }),
  "fill-opacity='0.14'": "fill-opacity='" + str(P.art-fill) + "'",
)
#let paper-art(P) = ("#bbbbbb": hex(fade(P.ink, P.paper-art * 0.4, P.paper)), "#999999": hex(fade(P.ink, P.paper-art, P.paper)), "#0b0b0b": hex(P.paper))
#let band-art(P) = ("#0b0b0b": hex(P.hero), "#999999": hex(fade(P.hero-line, P.seigaiha, P.hero)))

// A fixed slot: the content must fit its height or the compile fails (no shrinking, constitution 4).
#let slot(name, w, h, body) = context {
  let m = measure(block(width: w, body))
  assert(m.height <= h, message: "Hanami: " + name + " overflows (" + repr(m.height) + " > " + repr(h)
    + "); shorten its text or move a section, then look at the page")
  block(width: w, height: h, body)
}
#let at(x, y, body) = place(top + left, dx: x, dy: y, body)

#let label(ctx, s, fill: black, size: 7.2pt, track: 1.3pt) = text(font: ctx.theme.fonts.body, size: size, weight: 700, tracking: track, fill: fill, caps(s))

// The last two words of a line hold together, so no word is left alone on a line.
#let keep-end(s) = {
  let w = s.split(" ").filter(x => x != "")
  if w.len() <= 3 { w.join(" ") } else [#w.slice(0, -2).join(" ") #box(w.slice(-2).join(" "))]
}
#let diamond(P) = box(baseline: -0.15em, rotate(45deg, rect(width: 1.25mm, height: 1.25mm, fill: P.metal)))
#let items(ctx, list, size: 10.5pt, gap: 2.4mm) = {
  let P = tokens(ctx)
  for (i, b) in list.enumerate() {
    block(above: if i == 0 { 0mm } else { gap }, below: 0mm, grid(columns: (4mm, 1fr), diamond(P), text(size: size, keep-end(b))))
  }
}
// Two columns of bullets, split where the two hold about the same amount of text.
#let split(list) = {
  let total = list.map(s => s.len()).sum(default: 0)
  let best = calc.max(1, calc.ceil(list.len() / 2))
  let diff = total
  for k in range(1, list.len()) {
    let left = list.slice(0, k).map(s => s.len()).sum()
    if calc.abs(2 * left - total) < diff { diff = calc.abs(2 * left - total); best = k }
  }
  (list.slice(0, calc.min(best, list.len())), list.slice(calc.min(best, list.len())))
}
#let two-columns(ctx, list, gutter: 8mm) = {
  let (a, b) = split(list)
  grid(columns: (1fr, 1fr), column-gutter: gutter, items(ctx, a), items(ctx, b))
}

// A soft shadow from stacked translucent layers (vector, prints cleanly).
#let soft-shadow(x, y, w, h, col) = for i in range(9) {
  let s = i * 0.34mm
  at(x - s + 0.6mm, y + 2.2mm - s * 0.5, rect(width: w + 2 * s - 1.2mm, height: h + 2 * s - 0.8mm, radius: s + 0.6mm, fill: col.transparentize(98%)))
}
