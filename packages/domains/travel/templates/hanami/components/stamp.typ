// A round eki-style stamp: a double-ring rim with set type, a drawing in the middle, one ink.
#import "art.typ": art, caps, hex

// `words` run round the rim: the first ones clockwise over the top, the rest upright along the
// bottom, a star between words and one at each side where the arcs meet. `drawing` is a stamp
// key of the artwork pack (stamp-<art>); `kanji` sits under it ("" for none).
#let stamp(ctx, words, drawing, kanji: "", size: 26, ink: red, ground: white, solid: false, kanji-font: auto, kanji-size: auto) = context {
  assert(words.len() >= 2, message: "A stamp needs at least two rim words")
  let fonts = ctx.theme.fonts
  let kanji-font = if kanji-font == auto { fonts.japanese } else { kanji-font }
  let S = size * 1mm
  let fg = if solid { ground } else { ink }
  let bg = if solid { ink } else { ground }
  let rim-size = size * 0.205 * 1pt
  let star-w = size * 0.034
  let glyph(c) = text(font: (fonts.display, fonts.japanese), size: rim-size, weight: 600, tracking: 0pt, fill: fg, top-edge: "cap-height", bottom-edge: "baseline", c)
  let seq(part) = { let out = (); for (i, it) in part.enumerate() { if i > 0 { out.push("✦") }; for c in caps(it).clusters() { out.push(c) } }; out }
  let width(c) = if c == "✦" { star-w * 3.2 } else { measure(glyph(c)).width / 1mm + size * 0.016 }
  let chars(part) = seq(part).len()
  // split where the two arcs are closest in length, the top never the shorter
  let k = range(1, words.len()).filter(j => chars(words.slice(0, j)) >= chars(words.slice(j))).sorted(key: j => chars(words.slice(0, j)) - chars(words.slice(j))).first()
  let top = seq(words.slice(0, k))
  let bottom = seq(words.slice(k))
  let tw = top.map(width)
  let bw = bottom.map(width)
  let rr = size / 2 - size * 0.13
  let per-mm = 360 / (2 * calc.pi * rr)
  let T0 = tw.sum() * per-mm
  let B0 = bw.sum() * per-mm
  // letters spread as on the concept's rims, but the top stays above 100° and the bottom below
  let st = calc.min(312 / (T0 + B0), 196 / T0, 152 / B0)
  assert(st >= 1, message: "stamp: the rim text " + repr(words) + " is too long for a " + str(size) + " mm stamp; shorten a rim word")
  let T = T0 * st
  let B = B0 * st
  let ring(r, t) = place(center + horizon, circle(radius: r * 1mm, fill: none, stroke: (paint: fg, thickness: t * 1mm)))
  box(width: S, height: S, {
    if solid { place(center + horizon, circle(radius: S / 2 + size * 0.04 * 1mm, fill: ground, stroke: none)) }
    place(center + horizon, circle(radius: S / 2, fill: bg, stroke: none))
    ring(size / 2 - size * 0.025, size * 0.036)
    ring(size / 2 - size * 0.068, size * 0.009)
    ring(size / 2 - size * 0.2, size * 0.012)
    let put(a, rot, c) = place(center + horizon, dx: rr * calc.sin(a) * 1mm, dy: -rr * calc.cos(a) * 1mm,
      if c == "✦" { rotate(a + 45deg, rect(width: star-w * 1mm, height: star-w * 1mm, fill: fg)) } else { rotate(rot, glyph(c)) })
    let acc = 0
    for (i, c) in top.enumerate() {
      let a = (-T / 2 + (acc + tw.at(i) / 2) * per-mm * st) * 1deg
      acc += tw.at(i)
      put(a, a, c)
    }
    acc = 0
    for (i, c) in bottom.enumerate() {
      let a = (180 + B / 2 - (acc + bw.at(i) / 2) * per-mm * st) * 1deg
      acc += bw.at(i)
      put(a, a - 180deg, c)
    }
    for side in (1, -1) { put(side * (T / 2 + (360 - T - B) / 4) * 1deg, 0deg, "✦") }
    place(center + horizon, dy: (if kanji == "" { 0mm } else { -size * 0.07 * 1mm }),
      art(ctx, "stamp-" + drawing, width: size * 0.46 * 1mm, swaps: ("#c23a2b": hex(fg), "#fefefe": hex(bg))))
    if kanji != "" {
      place(center + horizon, dy: size * 0.23 * 1mm, text(font: kanji-font, size: (if kanji-size == auto { size * 0.24 * 1pt } else { kanji-size }), weight: 700, fill: fg, kanji))
    }
  })
}
