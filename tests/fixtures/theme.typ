// Theme checks (TASK-59). The core's `validate-theme` asks only for what every template needs, so
// `core` passes a theme that has none of Flagship's colours, and still refuses one that lacks a colour
// of its own (`core-missing`, with `key`); Flagship refuses a theme that lacks one
// of its own (`missing`, with `key`) or holds it as something other than a colour (`not-color`),
// through `flagship` itself, with the same messages the core check gave before the split.
#import "../../packages/cv-framework/core/theme.typ": validate-theme
#import "../../packages/domains/marine/lib.typ": flagship
#import "../../packages/domains/marine/templates/flagship/themes/golden-blue.typ": theme as base
#import "../../packages/domains/marine/templates/flagship/artwork/engineer.typ": artwork
#import "../../packages/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout
#let case = sys.inputs.at("case", default: "core")
#let key = sys.inputs.at("key", default: "plate")
#if case in ("core", "core-missing") {
  let colors = (:)
  for name in ("ink", "accent", "metal", "muted", "paper") { colors.insert(name, base.colors.at(name)) }
  if case == "core-missing" { let _ = colors.remove(key) }
  validate-theme((..base, colors: colors))
  [Core check passed with #colors.len() colours]
} else {
  let colors = base.colors
  if case == "missing" { let _ = colors.remove(key) } else { colors.insert(key, "white") }
  flagship([], candidate: json("../../examples/candidates/engineer-example.json"),
    theme: (..base, colors: colors), artwork: artwork, layout: layout)
}
