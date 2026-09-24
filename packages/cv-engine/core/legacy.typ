// Pre-contract signatures (data, theme, geometry), kept so custom compositions
// written before ADR 0008 landed keep rendering unchanged. `lib.typ` exports
// these under the old names. Deprecated: new code calls the ctx-first
// components directly (docs/framework-gaps.md, "Legacy component signatures").
#import "component.typ": make-ctx
#import "primitives.typ" as ui

#let label(body, theme, color: none) = ui.label(make-ctx(theme: theme), body, color: color)
#let rule(theme, weight: 0.5pt) = ui.rule(make-ctx(theme: theme), weight: weight)
#let decoration(asset, theme, width: auto, height: auto, artifact: true) = ui.decoration(make-ctx(theme: theme), asset,
  width: width, height: height, artifact: artifact)
#let metric(value, caption, theme, gap: 3mm) = ui.metric(make-ctx(theme: theme), value, caption: caption, gap: gap)
#let duration-value(months, theme) = ui.duration-value(make-ctx(theme: theme), months)
