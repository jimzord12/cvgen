// Sky: the light-blue (mizu-iro) band of Hanami Line 2, navy type and line art. Visual tokens only.
#import "common.typ": fonts, paper-sakura

#let theme = (
  name: "Sky",
  colors: (ink: rgb("1b2238"), accent: rgb("c23a2b"), metal: rgb("b08a4c"), muted: rgb("5b6274"), paper: rgb("faf6ee"),
    hero: rgb("9cc2de"), hero-text: rgb("13284a"), hero-label: rgb("1d3a66"), hero-line: rgb("1f3562"), cap: rgb("f7f9fc"),
    plate: rgb("fffbf4"), keyline: rgb("b08a4c"), shadow: rgb("13284a"), wash: rgb("efe9de"), rule: rgb("ddd4c4"),
    label: rgb("75582a"), date: rgb("1f3562"), icon: rgb("75582a"), accent-hero: rgb("c23a2b"), accent-soft: rgb("1d3a66"),
    tone: rgb("1f3562"), ring: rgb("a77a2c"), ring-glow: rgb("fff3d8"), sun: rgb("fbf0d6")),
  glow: rgb("d9e9f4"),
  fonts: fonts,
  levels: (seigaiha: 0.13, art-fill: 0.12, glow-alpha: 94%, paper-art: 0.07),
  sakura: (
    hero: (bark: rgb("1f3562"), petal: rgb("fff1f3"), deep: rgb("f6c2cc"), edge: rgb("c97b8f"), heart: rgb("a8405e"), anther: rgb("e2b14e"), lent: rgb("ffffff"), kb: 0.38, kp: 0.95),
    paper: paper-sakura,
    fly: none,
  ),
)
