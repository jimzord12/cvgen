// Sakura: the dusty-pink band of Hanami Line 2 (the concept's "soft" palette, the client build's
// "pink"). Visual tokens only; geometry lives in layouts/.
#import "common.typ": fonts, paper-sakura

#let theme = (
  name: "Sakura",
  colors: (ink: rgb("231f38"), accent: rgb("c23a2b"), metal: rgb("b5835e"), muted: rgb("625d72"), paper: rgb("faf6ef"),
    hero: rgb("dea1ae"), hero-text: rgb("2a1f3d"), hero-label: rgb("5a2840"), hero-line: rgb("3a2c55"), cap: rgb("fbf3ef"),
    plate: rgb("fffaf5"), keyline: rgb("b5835e"), shadow: rgb("2a1f3d"), wash: rgb("f3e9e5"), rule: rgb("e2d5cc"),
    label: rgb("8a5f3e"), date: rgb("3a2c55"), icon: rgb("8a5f3e"), accent-hero: rgb("c23a2b"), accent-soft: rgb("5a2840"),
    tone: rgb("3a2c55"), ring: rgb("a77a2c"), ring-glow: rgb("fff1d6"), sun: rgb("fbf3ef")),
  // The bloom behind the portrait, or none.
  glow: rgb("f3d0d5"),
  fonts: fonts,
  // Opacities: the band's seigaiha, the line art's fills, the portrait glow's layers, the paper pieces.
  levels: (seigaiha: 0.12, art-fill: 0.14, glow-alpha: 94%, paper-art: 0.07),
  // Sakura colours: on the band, on the paper, and for the flying petals on the band (none: as on the band).
  sakura: (
    hero: (bark: rgb("3a2c55"), petal: rgb("fff3f3"), deep: rgb("f6c6ce"), edge: rgb("c97b8f"), heart: rgb("a8405e"), anther: rgb("e2b14e"), lent: rgb("ffffff"), kb: 0.42, kp: 0.95),
    paper: paper-sakura,
    fly: none,
  ),
)
