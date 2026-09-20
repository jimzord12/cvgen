#import "../../packages/cv-engine/lib.typ": skills-section
#import "../../packages/cv-engine/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/cv-engine/domains/marine/templates/flagship/themes/silver-bridge.typ": theme as silver
#set page(paper: "a4", margin: 16mm)
#set text(font: theme.fonts.body)
#skills-section((("Navigation", "A longer skill that should wrap naturally within its column without losing its bullet"), ("Cargo handling", "GMDSS")), theme,
  bullet: (source: "/packages/cv-engine/domains/marine/assets/captain/compass-bullet.svg"))
#v(10mm)
#skills-section((("One column", "Plain bullet"),), silver, title: "Technical Skills")
#v(10mm)
#skills-section((("First",), ("Second",), ("Third",)), silver, title: "Three columns",
  bullet: (source: "/packages/cv-engine/domains/marine/assets/captain/compass-bullet.svg"))
