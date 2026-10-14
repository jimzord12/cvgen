// Entry hierarchy and category helpers adapted from cobalt-cv 0.1.0 (MIT).
// Layouts and illustration assets are original to this project.
#let cv = json("content/example.json")
#let ink = rgb("172c35")
#let muted = rgb("53666d")
#let base(body) = {
  set document(title: cv.name + " - Marine Engineer - Fictional Prototype", author: "Marine CV Studio")
  set page(paper: "a4", margin: 16mm)
  set text(font: "Source Sans 3", size: 10pt, fill: ink, lang: "en")
  set par(leading: 0.55em)
  set list(indent: 10pt, body-indent: 4pt, spacing: 4pt)
  body
}
#let section(title, color: ink) = block(above: 13pt, below: 7pt)[
  #text(size: 9pt, weight: "bold", tracking: 1.4pt, fill: color)[#upper(title)]
  #v(3pt)
  #line(length: 100%, stroke: 0.5pt + color.lighten(55%))
]
#let job(j, color: ink, technical: false) = block(above: 0pt, below: 12pt, breakable: false)[
  #grid(columns: (1fr, auto), column-gutter: 5pt,
    text(size: 12pt, weight: "bold", fill: color)[#j.role],
    text(size: 9pt, fill: muted)[#j.dates])
  #text(weight: "semibold")[#j.company] #text(fill: muted)[#("/ ")#j.vessel]
  #v(2pt)
  #text(size: 9pt, fill: color)[#j.plant]
  #v(4pt)
  #for b in j.bullets { [- #b] }
]
#let skills(color: ink) = {
  for s in cv.skills {
    block(below: 9pt)[#text(weight: "bold", fill: color)[#s.title] \
    #s.items]
  }
}
#let qualifications() = { for q in cv.qualifications { block(below: 5pt)[#q] } }
#let contact() = [#cv.location #h(7pt) / #h(7pt) #link("mailto:" + cv.email)[#cv.email] #h(7pt) / #h(7pt) #cv.phone]
#let footer(label) = context [#text(size: 7pt, fill: muted)[#cv.note #h(1fr) #label #h(8pt) #counter(page).display()]]
