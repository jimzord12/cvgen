#import "../../../packages/domains/travel/lib.typ": hanami, hanami-themes, hanami-artwork, hanami-layouts
#let candidate = json("../../candidates/tour-leader-essential-example.json")
#show: hanami.with(candidate: candidate, theme: hanami-themes.sakura, artwork: hanami-artwork.japan,
  layout: hanami-layouts.essential, variation: "essential")
