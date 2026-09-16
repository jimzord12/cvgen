#import "data.typ": duration-parts

#let label(body, theme, color: none) = text(size: theme.sizes.label, weight: "bold",
  tracking: theme.tracking.label, fill: if color == none {theme.colors.muted} else {color})[#upper(body)]

#let rule(theme, weight: 0.5pt) = line(length: 100%, stroke: weight + theme.colors.metal)

// The original art's palette is mapped in memory; no frozen SVG is edited.
#let decoration(asset, theme, width: auto, height: auto, artifact: true) = {
  if asset != none {
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

#let duration(months) = {
  let p = duration-parts(months)
  let parts = ()
  if p.years > 0 {parts.push(str(p.years) + if p.years == 1 {" year"} else {" years"})}
  if p.months > 0 or p.years == 0 {parts.push(str(p.months) + if p.months == 1 {" month"} else {" months"})}
  parts.join(" ")
}

#let metric(value, caption, theme, gap: 3mm) = stack(spacing: gap,
  text(font: theme.fonts.display, size: theme.sizes.metric)[#value],
  label(caption, theme, color: theme.colors.metal))

#let duration-value(months, theme) = {
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
