#import "shared.typ": *
#show: base
#let teal = rgb("236467")
#set page(margin: (x: 18mm, top: 14mm, bottom: 15mm), footer: footer("HORIZON"))
#text(size: 9pt, tracking: 2pt, fill: teal)[MARINE & MECHANICAL ENGINEERING]
#v(5mm)
#grid(columns: (1fr, 66mm), align: horizon,
 [#text(font: "Cormorant Garamond", size: 45pt, weight: "medium")[#lower(cv.name).split(" ").map(w => upper(w.slice(0, 1)) + w.slice(1)).join(" ")]
  #v(2mm)
  #text(size: 11pt, fill: teal)[Propulsion. Precision. Reliability.]],
 image("../assets/hull.svg", width: 66mm))
#v(5mm)
#line(length: 100%, stroke: 0.6pt + teal)
#v(3mm)
#text(size: 9pt)[#contact()]
#v(5mm)
#block(fill: rgb("eff5f3"), inset: 5mm, width: 100%)[#cv.summary]
#section("Sea service & experience", color: teal)
#for j in cv.jobs { job(j, color: teal) }
#grid(columns: (1.1fr, 1fr), column-gutter: 12mm,
 [#section("Technical expertise", color: teal)
  #skills(color: teal)],
 [#section("Qualifications", color: teal)
  #qualifications()
  #section("Education & availability", color: teal)
  #strong(cv.education.at(0)) \ #cv.education.at(1)
  #v(5pt)
  #cv.languages \ #cv.availability])
