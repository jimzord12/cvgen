#import "../../packages/domains/marine/lib.typ": make-ctx, flagship-components as fc
#import "../../packages/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/domains/marine/templates/flagship/themes/silver-bridge.typ": theme as silver
// No `skills` slice in the layout: every section uses the default `skills-layout`.
#let gold = make-ctx(theme: theme)
#let grey = make-ctx(theme: silver)
#set page(paper: "a4", margin: 16mm)
#set text(font: theme.fonts.body)
#fc.skills-section(gold, (("Navigation", "A longer skill that should wrap naturally within its column without losing its bullet"), ("Cargo handling", "GMDSS")),
  bullet: (source: "/packages/domains/marine/assets/captain/compass-bullet.svg"))
#v(10mm)
#fc.skills-section(grey, (("One column", "Plain bullet"),), title: "Technical Skills")
#v(10mm)
#fc.skills-section(grey, (("First",), ("Second",), ("Third",)), title: "Three columns",
  bullet: (source: "/packages/domains/marine/assets/captain/compass-bullet.svg"))
