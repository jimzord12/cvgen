// Monochrome: Hanami in chosen greys, black and white, for a client who wants a plain professional
// page that prints and copies exactly as it looks. Not a greyscale filter: a warm pale band so the
// black name and the black rank tab carry the page, one near-black for every accent (the tab, the
// red rules, the day counts), a mid grey for the quiet metal (section numbers, diamonds, rules) and a
// true white plate behind the portrait. Visual tokens only; geometry lives in layouts/.
#import "common.typ": fonts

#let ink = rgb("18181a")
#let theme = (
  name: "Monochrome",
  colors: (ink: ink, accent: ink, metal: rgb("8e8e8c"), muted: rgb("5a5a5c"), paper: rgb("fcfcfb"),
    hero: rgb("ebeae6"), hero-text: ink, hero-label: rgb("4e4e50"), hero-line: rgb("8e8e8c"), cap: rgb("ffffff"),
    plate: rgb("ffffff"), keyline: rgb("a9a9a6"), shadow: rgb("000000"), wash: rgb("f2f2ef"), rule: rgb("dcdcd8"),
    label: rgb("4e4e50"), date: ink, icon: rgb("4e4e50"), accent-hero: ink, accent-soft: rgb("4e4e50"),
    tone: rgb("6e6e70"), ring: rgb("8e8e8c"), ring-glow: rgb("ffffff"), sun: rgb("f6f6f4"),
    // behind a cut-out portrait: pale grey, so a light shirt keeps its edge
    portrait-plate: rgb("d9d9d6")),
  glow: none,
  fonts: fonts,
  // no blurred petals, on the band or the paper: in grey they print as smudges
  levels: (seigaiha: 0.1, art-fill: 0.08, glow-alpha: 96%, paper-art: 0.06, soft-petals: false, soft-field-petals: false),
  // the sakura, where an artwork pack draws it, in greys
  sakura: (
    hero: (bark: rgb("6e6e70"), petal: rgb("fafafa"), deep: rgb("d9d9d6"), edge: rgb("a9a9a6"), heart: rgb("7a7a7c"), anther: rgb("9a9a98"), lent: rgb("ffffff"), kb: 0.4, kp: 0.95),
    paper: (bark: rgb("6e6e70"), petal: rgb("ececea"), deep: rgb("d0d0cd"), edge: rgb("b5b5b2"), heart: rgb("7a7a7c"), anther: rgb("9a9a98"), lent: rgb("ffffff"), kb: 0.28, kp: 0.78),
    fly: none,
  ),
)
