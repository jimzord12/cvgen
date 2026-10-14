// Fonts strict (task-46): a family the bundled fonts do not have must fail the compile case, never
// render quietly in another font. Typst substitutes, warns `unknown font family` and exits 0.
// case=missing: a family that exists nowhere.
// case=system: `family`, a font this machine has but the bundled fonts do not (the runner picks it from
// `typst fonts`); refused only while the runner passes --ignore-system-fonts.
#let case = sys.inputs.at("case", default: "missing")
#let family = if case == "system" { sys.inputs.family } else { "CVgen Missing Family" }
#set page(width: 120mm, height: 30mm)
#set text(font: "Source Sans 3")
Bundled body text, then #text(font: family)[a family the bundled fonts do not have].
