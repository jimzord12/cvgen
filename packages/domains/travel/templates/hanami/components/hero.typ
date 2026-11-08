// The two bands and the footer: page 1's hero (canopy, torii, portrait ring, region seal, contacts,
// the route through the name plate) and page 2's shallower band (name, credential seal, route,
// line art). Placement is absolute on the page, as in the approved Hanami Line 2.
#import "art.typ": art, at, caps, hex, label, line-art, band-art, sakura, soft-shadow, tokens
#import "stamp.typ": stamp

#let flying(ctx, P) = {
  let S = ctx.theme.sakura
  if S.fly == none { sakura(S.hero, P.hero) } else { sakura(S.fly, P.hero) }
}

// The seal on the portrait ring: the region, the trip count (a total from the full record,
// constitution 6) and the record's own seal words.
#let region-seal(ctx, places, totals) = {
  let n = totals.trips
  (places.region, str(n) + " " + (if n == 1 { ctx.copy.trip } else { ctx.copy.trips }), ..places.at("seal", default: ()))
}

#let contact-column(ctx, P, entries, side) = {
  assert(entries.len() <= 3, message: "Hanami: the band holds three contacts a side; move one to the other side or drop it")
  for entry in entries {
    block(width: 100%, below: 3.4mm, align(side, {
      label(ctx, entry.label, fill: P.hero-label)
      linebreak()
      v(-1.6mm)
      text(size: 10pt, fill: P.hero-text, if "href" in entry { link(entry.href, entry.value) } else { entry.value })
    }))
  }
}

#let initials(name) = name.split(" ").filter(w => w != "").map(w => w.clusters().first()).join()

// The route through the name plate: FROM code, dotted line, plate, dotted line, plane, TO code.
#let route-line(ctx, P, route, plate-x, plate-w) = {
  let fonts = ctx.theme.fonts
  let code(c) = text(font: fonts.figures, size: 30pt, fill: P.hero-text, c)
  at(16mm, 67.6mm, label(ctx, ctx.copy.from + " · " + route.from.city, fill: P.hero-label))
  at(15.4mm, 70.2mm, code(route.from.code))
  context {
    let ym = 70.2mm + measure(code(route.from.code)).height / 2
    let from-end = 15.4mm + measure(code(route.from.code)).width
    let to-start = 194.4mm - measure(code(route.to.code)).width
    let dots = (paint: P.hero-line, thickness: 0.7pt, dash: (0.6pt, 2pt), cap: "round")
    at(from-end + 2mm, ym, line(length: plate-x - from-end - 4mm, stroke: dots))
    let pw = 9mm
    let px = to-start - 2mm - pw
    at(plate-x + plate-w + 2mm, ym, line(length: px - plate-x - plate-w - 3.4mm, stroke: dots))
    at(px, ym - pw * 12 / 24 / 2, art(ctx, "plane", width: pw, swaps: ("#d2462f": hex(P.accent-hero))))
  }
  place(top + right, dx: -16mm, dy: 67.6mm, label(ctx, ctx.copy.to + " · " + route.to.city, fill: P.hero-label))
  place(top + right, dx: -15.6mm, dy: 70.2mm, code(route.to.code))
}

// Page 1's band. `d` is the normalised record, `totals` the domain's totals over it.
#let hero(ctx, d, totals) = {
  let P = tokens(ctx)
  let fonts = ctx.theme.fonts
  let band = ctx.layout.band
  let places = d.destinations
  at(0mm, 0mm, rect(width: 210mm, height: band, fill: P.hero))
  at(0mm, band - 23mm, art(ctx, "seigaiha-band", width: 210mm, swaps: band-art(P)))
  if P.glow != none {
    at(105mm - 75mm, 36mm - 52mm, ellipse(width: 150mm, height: 104mm, fill: gradient.radial((P.glow, 0%), (P.glow.transparentize(40%), 45%), (P.hero.transparentize(100%), 100%))))
  }
  place(top + right, art(ctx, "canopy", width: 80mm, swaps: sakura(ctx.theme.sakura.hero, P.hero)))
  at(65mm, 4mm, art(ctx, "torii", width: 80mm, swaps: line-art(P)))
  at(18mm, 62mm, line(length: 174mm, stroke: 0.45pt + P.hero-line.transparentize(35%)))
  at(18mm, 62mm - 46mm * 23 / 56, art(ctx, "group", width: 46mm, swaps: line-art(P)))
  at(148mm, 62mm - 44mm * 26 / 56, art(ctx, "fuji", width: 44mm, swaps: line-art(P)))

  // the portrait (or the initials) in the gold-glow ring
  let PD = ctx.layout.portrait
  let RR = PD / 2 + 2.6mm
  for i in range(11).rev() {
    let r = RR + 0.6mm + i * 0.42mm
    at(105mm - r, 36mm - r, circle(radius: r, fill: P.ring-glow.transparentize(P.glow-alpha), stroke: none))
  }
  at(105mm - RR, 36mm - RR, circle(radius: RR, fill: P.hero, stroke: 2.1pt + P.ring))
  let portrait = d.identity.at("portrait", default: none)
  at(105mm - PD / 2, 36mm - PD / 2, box(width: PD, height: PD, radius: 50%, clip: true, stroke: 0.9pt + P.ring, fill: P.plate,
    if portrait != none {
      image(portrait, width: PD, height: PD, fit: "cover", alt: d.identity.at("portrait-alt", default: d.identity.name))
    } else {
      align(center + horizon, text(font: fonts.display, size: 40pt, weight: 800, fill: P.hero-line, top-edge: "cap-height", bottom-edge: "baseline", caps(initials(d.identity.name))))
    }))
  at(116mm, 41mm, stamp(ctx, region-seal(ctx, places, totals), "fuji", kanji: places.at("native", default: ""), size: 21,
    ink: P.accent, ground: P.plate, solid: true, kanji-font: fonts.japanese-display))
  at(0mm, 0mm, art(ctx, "petals-p1-hero", width: 210mm, swaps: flying(ctx, P)))

  at(16mm, 17mm, block(width: 50mm, contact-column(ctx, P, d.contacts.at("left", default: ()), left)))
  at(144mm, 17mm, block(width: 50mm, contact-column(ctx, P, d.contacts.at("right", default: ()), right)))

  // the name plate, with the route running through it
  let PLW = ctx.layout.plate.width
  let PLH = ctx.layout.plate.height
  let PLX = 105mm - PLW / 2
  let PLY = 67mm
  if "route" in places { route-line(ctx, P, places.route, PLX, PLW) }
  soft-shadow(PLX, PLY, PLW, PLH, P.shadow)
  at(PLX, PLY, rect(width: PLW, height: PLH, fill: P.plate, stroke: none))
  at(PLX + 1.4mm, PLY + 1.4mm, rect(width: PLW - 2.8mm, height: PLH - 2.8mm, stroke: 0.4pt + P.keyline))
  at(105mm - 19mm, PLY - 5.6mm, rect(width: 38mm, height: 5.6mm, fill: P.accent,
    align(center + horizon, text(font: fonts.body, size: 7.6pt, weight: 700, tracking: 1.6pt, fill: P.plate)[#caps(d.identity.rank) #if ctx.copy.tab-native != "" [#h(1mm) #text(font: fonts.japanese, size: 7.4pt, tracking: 0.6pt, ctx.copy.tab-native)]])))
  let name = text(font: fonts.display, size: 34pt, weight: 800, tracking: 0.6pt, fill: P.ink, top-edge: "cap-height", bottom-edge: "baseline", caps(d.identity.name))
  context assert(measure(name).width <= PLW - 6mm, message: "Hanami: the name is wider than the name plate; shorten it (a middle name can go) or widen layout.plate.width")
  let specialty = d.identity.at("specialty", default: none)
  at(PLX, PLY + 0.6mm, block(width: PLW, height: PLH, align(center + horizon, stack(spacing: 2.6mm, name,
    text(size: 8pt, weight: 700, tracking: 1.3pt, top-edge: "cap-height", bottom-edge: "baseline")[#text(fill: P.ink, caps(d.identity.rank)) #if specialty != none [#h(0.6mm) #text(fill: P.accent)[· #caps(specialty)]]],
  ))))
}

// Page 2's band: name, rank and region, contacts, the credential seal, a short route and line art.
#let band(ctx, d) = {
  let P = tokens(ctx)
  let fonts = ctx.theme.fonts
  let B = ctx.layout.band-2
  let places = d.destinations
  at(0mm, 0mm, rect(width: 210mm, height: B, fill: P.hero))
  at(0mm, B - 8mm, art(ctx, "seigaiha-p2", width: 100mm, swaps: band-art(P)))
  at(0mm, 0mm, art(ctx, "petals-p2-hero", width: 210mm, swaps: flying(ctx, P)))
  let name = text(font: fonts.display, size: 30pt, weight: 800, tracking: 0.5pt, fill: P.hero-text, top-edge: "cap-height", bottom-edge: "baseline", caps(d.identity.name))
  let contacts = d.contacts.at("left", default: ()) + d.contacts.at("right", default: ())
  let linked = contacts.filter(c => "href" in c).map(c => link(c.href, c.value))
  let plain = d.contacts.at("left", default: ()).filter(c => "href" not in c).map(c => c.value)
  at(16mm, 8.4mm, block(width: 100mm, {
    set par(leading: 0.5em)
    name
    v(1.4mm)
    label(ctx, d.identity.rank, fill: P.hero-label, size: 7.8pt, track: 1.5pt)
    h(1.2mm)
    text(size: 7.8pt, weight: 700, fill: P.accent)[·]
    h(1.2mm)
    label(ctx, places.region, fill: P.accent-soft, size: 7.8pt, track: 1.5pt)
    if "native" in places { h(1.8mm); text(font: fonts.japanese, size: 7.8pt, weight: 400, fill: P.accent-soft, places.native) }
    v(1.2mm)
    text(size: 9pt, fill: P.hero-text)[#linked.join([#h(1.6mm) · #h(1.6mm)]) #if plain.len() > 0 [\ #plain.join(" · ")]]
  }))
  let HZ = 35mm
  let GX = 103mm
  if "seal" in d.identity {
    context {
      // the seal follows the name; it must end above the travellers' heads
      let nx = 16mm + measure(name).width + 4.4mm
      at(nx, 6mm, stamp(ctx, d.identity.seal, "flag", size: 17, ink: P.accent, ground: P.plate, solid: true))
      assert(nx + 17mm < GX or 6mm + 17mm < HZ - 46mm * 23 / 56 + 8mm,
        message: "Hanami page 2: the credential seal would touch the travellers; shorten the name or drop identity.seal")
    }
  }
  at(GX, HZ, line(length: 194mm - GX, stroke: 0.45pt + P.hero-line.transparentize(35%)))
  at(158mm, HZ - 38mm * 26 / 56, art(ctx, "fuji", width: 38mm, swaps: line-art(P, band: P.hero)))
  at(146mm, HZ - 28mm * 58 / 80, art(ctx, "torii", width: 28mm, swaps: line-art(P, band: P.hero)))
  at(GX, HZ - 46mm * 23 / 56, art(ctx, "group", width: 46mm, swaps: line-art(P)))
  if "route" in places {
    context {
      let from = text(font: fonts.figures, size: 19pt, fill: P.hero-text, places.route.from.code)
      let to = text(font: fonts.figures, size: 19pt, fill: P.hero-text, places.route.to.code)
      let y0 = 4.6mm
      let ym = y0 + measure(to).height / 2
      let xt = 194mm - measure(to).width
      let xp = xt - 1.8mm - 7.6mm
      let xl = xp - 1.2mm - 12mm
      at(xt, y0, to)
      at(xp, ym - 7.6mm * 12 / 24 / 2, art(ctx, "plane", width: 7.6mm, swaps: ("#d2462f": hex(P.accent-hero))))
      at(xl, ym, line(length: 12mm, stroke: (paint: P.hero-line, thickness: 0.8pt, dash: (0.6pt, 2.2pt), cap: "round")))
      at(xl - 1.8mm - measure(from).width, y0, from)
    }
  }
}

// The footer: the name (and the record's disclosure), the page number and the CVgen wordmark.
#let footer(ctx, d, n, total) = {
  let P = tokens(ctx)
  at(16mm, 284mm, line(length: 178mm, stroke: 0.4pt + P.rule))
  let notice = d.at("disclosure", default: "")
  at(16mm, 286mm, text(size: 6.6pt, tracking: 0.8pt, fill: P.muted, caps(d.identity.name) + (if notice != "" { "  ·  " + notice } else { "" })))
  place(top + right, dx: -16mm, dy: 285.25mm, box(art(ctx, "logo", width: 10.4mm, swaps: ("#131210": hex(P.muted), "#B7713D": hex(P.label)))))
  place(top + right, dx: -29.4mm, dy: 286mm, text(size: 6.6pt, tracking: 0.8pt, fill: P.muted)[#n / #total])
}
