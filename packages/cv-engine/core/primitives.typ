// Leaf components shared by every template (ADR 0008 shape: ctx, data, props).
#import "data.typ": duration-parts

#let label(ctx, body, color: none) = text(size: ctx.theme.sizes.label, weight: "bold",
  tracking: ctx.theme.tracking.label, fill: if color == none {ctx.theme.colors.muted} else {color})[#upper(body)]

#let rule(ctx, weight: 0.5pt) = line(length: 100%, stroke: weight + ctx.theme.colors.metal)

// The original art's palette is mapped in memory; no frozen SVG is edited.
#let decoration(ctx, asset, width: auto, height: auto, artifact: true) = {
  if asset != none {
    let theme = ctx.theme
    let source = read(asset.source)
    let palette = (("#102f3a", theme.colors.ink), ("#236a70", theme.colors.accent),
      ("#c8a579", theme.colors.metal), ("#546870", theme.colors.muted),
      ("{{metal}}", theme.colors.metal), ("{{accent}}", theme.colors.accent), ("{{ink}}", theme.colors.ink))
    for (old, new) in palette { source = source.replace(old, new.to-hex()) }
    for (old, new) in theme.at("art-colors", default: (:)) { source = source.replace(old, new.to-hex()) }
    if "opacity" in asset {
      assert(0 <= asset.opacity and asset.opacity <= 1, message: "Artwork opacity must be between 0 and 1")
      let root = source.match(regex("<svg[^>]*>"))
      assert(root != none, message: "Decoration requires an SVG root")
      source = source.replace(root.text, root.text + "<g opacity=\"" + str(asset.opacity) + "\">")
      source = source.replace("</svg>", "</g></svg>")
    }
    let art = image(bytes(source), format: "svg", width: if width == auto {asset.at("width", default: auto)} else {width}, height: height)
    if artifact {pdf.artifact(art)} else {art}
  }
}

// A pure function, not a component: "2 years 3 months" for whole service months.
#let duration(months) = {
  let p = duration-parts(months)
  let parts = ()
  if p.years > 0 {parts.push(str(p.years) + if p.years == 1 {" year"} else {" years"})}
  if p.months > 0 or p.years == 0 {parts.push(str(p.months) + if p.months == 1 {" month"} else {" months"})}
  parts.join(" ")
}

#let metric(ctx, value, caption: none, gap: 3mm) = {
  assert(caption != none, message: "metric needs a caption: metric(ctx, value, caption: \"Vessels\")")
  stack(spacing: gap,
    text(font: ctx.theme.fonts.display, size: ctx.theme.sizes.metric)[#value],
    label(ctx, caption, color: ctx.theme.colors.metal))
}

#let duration-value(ctx, months) = {
  let theme = ctx.theme
  let p = duration-parts(months)
  let parts = ()
  if p.years > 0 {
    parts.push([#p.years #text(font: theme.fonts.body, size: theme.sizes.metric-unit)[#if p.years == 1 {"year"} else {"years"}]])
  }
  if p.months > 0 or p.years == 0 {
    parts.push([#p.months #text(font: theme.fonts.body, size: theme.sizes.metric-unit)[#if p.months == 1 {"month"} else {"months"}]])
  }
  parts.join([ ])
}
