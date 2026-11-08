// The Hanami composition: the travel Domain's first Template, grown from Hanami Line 2 (the owner's
// pick of 2026-10-02) as its `showcase` Template Variation (P-0013). Two A4 pages: page 1 is the
// band with the portrait, the name plate and the route, then the profile and experience; page 2 is
// the destination page: one eki stamp per trip (with its role, contract version 2), the areas known,
// practical know-how, one trip told in detail, studies and languages, with any licence (version 2)
// in the studies heading.
// The paper below each band is a fixed slot that fails loudly when it overflows; every field placed
// outside the slots (the name, rank tab, contacts, route labels, the page-2 band block with its rank,
// region and native line, the kanji on every stamp and seal) measures itself and fails loudly too
// (constitution 4).
#import "../../data.typ": normalize-candidate, validate-candidate
#import "../../domain.typ": domain
#import "../../../../cv-framework/core/node.typ": merge, compose
#import "../../../../cv-framework/core/component.typ": make-ctx
#import "../../../../cv-framework/core/theme.typ": require-colors, validate-theme
#import "copy.typ": hanami-copy
#import "components/art.typ": art, at, paper-art, sakura, slot, tokens, two-columns
#import "components/hero.typ": hero, band, footer
#import "components/sections.typ": heading, paper-piece, profile, experience, experience-subtitle, trips, practical, studies, licence-subtitle

// The colours only Hanami paints, beside the core's five.
#let hanami-colors = ("hero", "hero-text", "hero-label", "hero-line", "cap", "plate", "keyline", "shadow", "wash", "rule",
  "label", "date", "icon", "accent-hero", "accent-soft", "tone", "ring", "ring-glow", "sun")

#let validate-hanami-theme(theme) = {
  validate-theme(theme)
  require-colors(theme, hanami-colors)
  for key in ("figures", "japanese", "japanese-display") {
    assert(key in theme.fonts, message: "Hanami theme needs the font family " + key + ": copy fonts from themes/common.typ")
  }
  for key in ("levels", "sakura", "glow") { assert(key in theme, message: "Hanami theme needs " + key + ": see themes/sakura.typ") }
}

// "A, B and C".
#let joined(list, and-word) = if list.len() <= 1 { list.join() } else { list.slice(0, -1).join(", ") + " " + and-word + " " + list.last() }

// `candidate` is a travel facts record (schema/candidate.schema.json); `variation` a Template
// Variation named in template.json (ADR 0016), none for its default.
#let hanami(body, candidate: none, theme: none, artwork: none, layout: none, copy: (:), variation: none) = {
  let design = json("template.json")
  assert((if variation == none {design.default} else {variation}) in design.variations,
    message: "Hanami has no Template Variation " + repr(variation))
  assert(candidate != none and theme != none and artwork != none and layout != none,
    message: "hanami requires candidate, theme, artwork and layout")
  assert(type(candidate) == dictionary, message: "Candidate facts must be a dictionary; load the JSON record first")
  let d = normalize-candidate(candidate)
  validate-hanami-theme(theme)
  validate-candidate(d)
  let words = merge(merge(compose(domain, (copy: hanami-copy)).copy, d.copy), copy)
  let ctx = make-ctx(theme: theme, layout: layout, artwork: artwork, copy: words)
  let P = tokens(ctx)
  let totals = (domain.totals)(d.destinations)
  let places = d.destinations
  let story = places.trips.find(t => "story" in t)

  set document(title: d.identity.name + " | " + d.identity.rank + " | " + domain.meta.title, author: domain.meta.author)
  set page(paper: layout.paper, margin: 0mm, fill: P.paper)
  set text(font: theme.fonts.body, size: 10.5pt, fill: P.ink, lang: words.lang, number-type: "lining")
  set par(leading: 0.6em, spacing: 0.6em, justify: false)
  show link: it => it

  // ---- page 1 ----
  hero(ctx, d, totals)
  at(0mm, layout.band, art(ctx, "petals-p1-field", width: 210mm, swaps: sakura(theme.sakura.paper, P.paper)))
  let f1 = layout.field-1
  at(f1.x, f1.y, slot("page 1", f1.width, f1.height, {
    if d.profile != "" or d.highlights.len() > 0 { profile(ctx, d.profile, d.availability, d.highlights) }
    v(5mm)
    v(1fr)
    heading(ctx, "01", words.experience, experience-subtitle(ctx, d.experience),
      art-piece: paper-piece(ctx, "shinkansen", 118mm, 0mm, width: 60mm))
    v(4.4mm)
    experience(ctx, d.experience)
    v(1fr)
  }))
  footer(ctx, d, 1, layout.pages)
  pagebreak()

  // ---- page 2 ----
  band(ctx, d)
  let B = layout.band-2
  at(120mm, B + 2mm, art(ctx, "branch", width: 90mm, swaps: sakura(theme.sakura.paper, P.paper)))
  at(0mm, B, art(ctx, "petals-p2-field", width: 210mm, swaps: sakura(theme.sakura.paper, P.paper)))
  let f2 = layout.field-2
  let title = if words.destinations-title == auto { places.region + ", " + words.by-trip } else { words.destinations-title }
  let has-studies = d.licences.len() + d.education.len() + d.languages.len() > 0 or d.references != none
  at(f2.x, B + f2.gap, slot("page 2", f2.width, f2.bottom - B - f2.gap, {
    heading(ctx, "02", title, words.stamp-line + " · " + joined(places.trips.map(t => t.period), words.and-word))
    v(5.2mm)
    trips(ctx, places)
    if d.practical != none {
      v(5mm)
      practical(ctx, d.practical)
    }
    if story != none {
      v(5mm)
      v(1fr)
      heading(ctx, "03", story.story.title, story.story.at("subtitle", default: ""),
        art-piece: paper-piece(ctx, "fan", 146mm, -2mm, width: 32mm))
      v(4.4mm)
      two-columns(ctx, story.story.items)
    }
    if has-studies {
      v(5mm)
      v(1fr)
      // A licence (contract version 2) takes the subtitle's place and ends at the education columns'
      // right edge (the field less the 61 mm languages column and its 6 mm gutter, less the heading's
      // 13 mm number), well before the lanterns.
      let subtitle = if d.licences.len() > 0 { licence-subtitle(ctx, d.licences, f2.width - 61mm - 6mm - 13mm) } else { words.education-subtitle }
      heading(ctx, if story != none { "04" } else { "03" }, words.education-languages, subtitle,
        art-piece: { paper-piece(ctx, "lanterns", 134mm, -2.6mm, width: 24mm); paper-piece(ctx, "pagoda", 162mm, -5.6mm, height: 20.4mm) })
      v(4.4mm)
      studies(ctx, d.education, d.languages, d.references)
    }
    v(1fr)
  }))
  footer(ctx, d, 2, layout.pages)

  // No shrinking (constitution 4): the planned pages, or the compile fails.
  context assert(counter(page).final().first() == layout.pages,
    message: "Hanami: the CV must be exactly " + str(layout.pages) + " pages, found " + str(counter(page).final().first()))
  body
}
