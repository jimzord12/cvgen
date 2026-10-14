#import "shared.typ": *
#show: base
#set page(margin: (top: 0mm, bottom: 14mm, left: 0mm, right: 14mm), footer: block(inset: (left: 14mm))[#footer("SOUNDINGS")])
#let sea = rgb("123d4b")
#let aqua = rgb("9cd1cc")
#grid(columns: (62mm, 1fr), column-gutter: 12mm,
  block(fill: sea, width: 100%, height: 276mm, inset: (x: 9mm, top: 16mm, bottom: 12mm))[
    #set text(fill: white, size: 9.5pt)
    #text(size: 9pt, tracking: 2pt, fill: aqua)[MARINE / ENGINEERING]
    #v(10mm)
    #image("../assets/soundings.svg", width: 40mm)
    #v(10mm)
    #section("Contact", color: aqua)
    #cv.location \
    #v(4pt)
    #link("mailto:" + cv.email)[#cv.email] \
    #v(4pt)
    #cv.phone
    #section("Qualifications", color: aqua)
    #qualifications()
    #section("Education", color: aqua)
    #strong(cv.education.at(0)) \
    #cv.education.at(1)
    #section("Languages", color: aqua)
    #cv.languages
    #section("Availability", color: aqua)
    #cv.availability
  ],
  block(inset: (top: 18mm))[
    #text(size: 40pt, font: "Barlow", weight: "semibold", fill: sea)[#cv.name.split(" ").join(linebreak())]
    #v(5mm)
    #text(size: 13pt, fill: sea)[#cv.role]
    #v(5mm)
    #line(length: 20mm, stroke: 2pt + rgb("ba8a57"))
    #section("Professional profile", color: sea)
    #cv.summary
    #section("Sea service & experience", color: sea)
    #for j in cv.jobs { job(j, color: sea) }
    #section("Technical expertise", color: sea)
    #skills(color: sea)
  ]
)
