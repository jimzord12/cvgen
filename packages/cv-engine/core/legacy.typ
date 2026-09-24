// Pre-contract signatures (data, theme, geometry), kept so custom compositions
// written before ADR 0008 landed keep rendering unchanged. `lib.typ` exports
// these under the old names. Deprecated: new code calls the ctx-first
// components directly (docs/framework-gaps.md, "Legacy component signatures").
#import "component.typ": make-ctx
#import "primitives.typ" as ui
#import "page.typ" as shell

#let label(body, theme, color: none) = ui.label(make-ctx(theme: theme), body, color: color)
#let rule(theme, weight: 0.5pt) = ui.rule(make-ctx(theme: theme), weight: weight)
#let decoration(asset, theme, width: auto, height: auto, artifact: true) = ui.decoration(make-ctx(theme: theme), asset,
  width: width, height: height, artifact: artifact)
#let metric(value, caption, theme, gap: 3mm) = ui.metric(make-ctx(theme: theme), value, caption: caption, gap: gap)
#let duration-value(months, theme) = ui.duration-value(make-ctx(theme: theme), months)

#let page-header(name, headline, caption, theme, geometry) = shell.page-header(
  make-ctx(theme: theme, layout: (header: geometry)), (name: name, headline: headline), caption: caption)
#let page-footer(disclosure, brand, theme, geometry) = shell.page-footer(
  make-ctx(theme: theme, layout: (footer: geometry)), disclosure, brand: brand)
#let page-background(theme, artwork, layout) = shell.page-background(make-ctx(theme: theme, layout: layout, artwork: artwork))
#let document-shell(candidate, theme, artwork, layout, body, title: none, author: none) = shell.document-shell(
  make-ctx(theme: theme, layout: layout, artwork: artwork, copy: candidate.copy), candidate, title: title, author: author, body)
