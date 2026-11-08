// Indigo: the dark band of Hanami Line 2, with warm brass. Visual tokens only.
#import "common.typ": fonts, paper-sakura

#let theme = (
  name: "Indigo",
  colors: (ink: rgb("1b2036"), accent: rgb("c23a2b"), metal: rgb("c4a265"), muted: rgb("5d6377"), paper: rgb("f8f4ea"),
    hero: rgb("1e2852"), hero-text: rgb("fbf7ee"), hero-label: rgb("c4a265"), hero-line: rgb("c4a265"), cap: rgb("fbf7ee"),
    plate: rgb("fffcf4"), keyline: rgb("c4a265"), shadow: rgb("0e1430"), wash: rgb("efe8d9"), rule: rgb("dcd2bd"),
    label: rgb("7a5d29"), date: rgb("28356a"), icon: rgb("7a5d29"), accent-hero: rgb("d65445"), accent-soft: rgb("f2907a"),
    tone: rgb("9aa4cf"), ring: rgb("d9b46a"), ring-glow: rgb("f1d79c"), sun: rgb("e8cf98")),
  glow: none,
  fonts: fonts,
  levels: (seigaiha: 0.1, art-fill: 0.07, glow-alpha: 96.4%, paper-art: 0.07),
  sakura: (
    hero: (bark: rgb("eadad8"), petal: rgb("ffe4e0"), deep: rgb("ffbcb8"), edge: rgb("f3a3ae"), heart: rgb("e98a8f"), anther: rgb("f0c66a"), lent: rgb("ffffff"), kb: 0.3, kp: 0.82),
    paper: paper-sakura,
    fly: (bark: rgb("eadad8"), petal: rgb("ffe2dd"), deep: rgb("ffb8b4"), edge: rgb("f7a9b2"), heart: rgb("e98a8f"), anther: rgb("f0c66a"), lent: rgb("ffffff"), kb: 0.3, kp: 1.0),
  ),
)
