#import "golden-blue.typ": theme as classic
// Same components and page plan; typography metrics belong to the theme.
#let theme = (
  ..classic,
  name: "Silver Bridge",
  colors: (ink: rgb("202830"), hero: rgb("202830"), accent: rgb("425565"),
    metal: rgb("b8c2cc"), muted: rgb("596570"), surface: rgb("f0f3f5"),
    paper: white, plate: white, rule: rgb("d6dde2"), on-hero: white),
  fonts: (body: "Source Sans 3", display: "Source Sans 3"),
  art-colors: ("#619095": rgb("778a99"), "#47747a": rgb("657786"),
    "#b38e61": rgb("8c9aa6"), "#e6caa0": rgb("dce3e9"),
    "#98774f": rgb("687886"), "#e4c79f": rgb("d3dde5")),
  sizes: (..classic.sizes, name: 28pt, page-name: 21pt, section-number: 25pt,
    duration: 14pt, metric: 22pt, metric-unit: 12pt),
)
