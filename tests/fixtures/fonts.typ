// Fonts strict (task-46): a family the bundled fonts do not have must fail the compile case, never
// render quietly in another font. Typst substitutes, warns `unknown font family` and exits 0.
// case=missing: a family that exists nowhere.
// case=system: Arial, installed on Windows and macOS but not bundled; refused only while the runner
// passes --ignore-system-fonts (on Linux, where Arial is absent, it is refused either way).
#let family = (missing: "CVgen Missing Family", system: "Arial").at(sys.inputs.at("case", default: "missing"))
#set page(width: 120mm, height: 30mm)
#set text(font: "Source Sans 3")
Bundled body text, then #text(font: family)[a family the bundled fonts do not have].
