#import "shared.typ": *
#show: base
#let copper = rgb("98613d")
#set page(footer: footer("ENGINE ROOM"))
#block(fill: ink, inset: 6mm, width: 100%)[
  #set text(fill: white)
  #grid(columns: (1fr, 48mm), column-gutter: 4mm, align: horizon,
    stack(dir: ttb, spacing: 3mm,
      text(size: 8pt, tracking: 1pt, fill: rgb("e4b58e"))[PROPULSION / SYSTEMS / RELIABILITY],
      text(font: "Barlow", size: 32pt, weight: "semibold")[#cv.name],
      text(size: 12pt)[#cv.role]),
    image("../assets/shaft.svg", width: 48mm))
]
#v(2mm)
#line(length: 100%, stroke: 1.5pt + ink)
#v(3mm)
#text(size: 9pt)[#contact()]
#v(3mm)
#line(length: 100%, stroke: 0.4pt + copper)
#section("01 / Professional profile", color: copper)
#cv.summary
#section("02 / Sea service & experience", color: copper)
#for j in cv.jobs { job(j, color: copper) }
#section("03 / Technical expertise", color: copper)
#grid(columns: (1fr, 1fr), column-gutter: 8mm, row-gutter: 8pt,
  ..cv.skills.map(s => block(below: 5pt)[#strong(s.title) \ #s.items]))
#section("04 / Qualifications & education", color: copper)
#grid(columns: (1fr, 1fr), column-gutter: 8mm,
  [#qualifications()],
  [#strong(cv.education.at(0)) \ #cv.education.at(1)
   #v(7pt)
   #cv.languages \ #cv.availability])
