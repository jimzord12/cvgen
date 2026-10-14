#let d = json("content/extended-company-example.json")
// All vessel durations are shown or hidden together.
#let show-vessel-durations = sys.inputs.at("vessel-durations", default: "true") == "true"
#let navy = rgb("102f3a")
#let teal = rgb("236a70")
#let brass = rgb("c8a579")
#let grey = rgb("546870")
#let mist = rgb("eef4f3")
#set document(title: "Alex Morgan | Second Engineer | Flagship Company Experience sample", author: "Marine CV Studio")
#set text(font: "Source Sans 3", size: 10.5pt, fill: navy, lang: "en")
#set par(leading: 0.55em)
#set page(paper: "a4", margin: (x: 16mm, top: 12mm, bottom: 15mm),
  footer: context [#line(length: 100%, stroke: 0.5pt + brass)
  #v(2pt)#text(size: 7pt, fill: grey)[FICTIONAL CANDIDATE & AI PORTRAIT / DESIGN STUDY #h(1fr) FLAGSHIP #h(6pt) #counter(page).display("01")]],
  background: context {
    place(top + left, pdf.artifact(image(if counter(page).get().first() == 1 { "../assets/workshop-background-1.svg" } else { "../assets/workshop-background-2.svg" }, width: 210mm, height: 297mm)))
    if counter(page).get().first() == 1 {
      place(top, rect(width: 100%, height: 83mm, fill: navy, stroke: none))
    }
  })
#let screw = pdf.artifact(image("../assets/screw-bullet.svg", width: 3mm))
#set list(marker: screw, indent: 0pt, body-indent: 4pt, spacing: 3pt)
#let label(t, color: grey) = text(size: 8pt, weight: "bold", tracking: 1.1pt, fill: color)[#upper(t)]
// Continuation spacing makes room for the synopsis at the end of Experience.
#let space = (xs: 1.5mm, sm: 3mm, md: 5mm, lg: 7mm, xl: 9mm)
#let heading(n, title, sub: none, above: space.lg, below: space.md) = block(above: above, below: below)[
  #grid(columns: (12mm, 1fr), align: horizon,
    text(font: "Barlow", size: 28pt, fill: brass)[#n],
    stack(spacing: space.xs, text(size: 15pt, weight: "bold")[#title], if sub != none {text(size: 9pt, fill: grey)[#sub]}))
]
// Durations are supplied as whole service months; never infer service from calendar spans.
#let duration(months) = {
  let years = calc.quo(months, 12)
  let rest = calc.rem(months, 12)
  let parts = ()
  if years > 0 { parts.push(str(years) + if years == 1 { " year" } else { " years" }) }
  if rest > 0 or years == 0 { parts.push(str(rest) + if rest == 1 { " month" } else { " months" }) }
  parts.join(" ")
}
#let ships = d.companies.map(c => c.groups.map(g => g.ships).flatten()).flatten()
#let total-months = ships.map(s => s.months).sum()
#let company(c, continuation: false) = block(breakable: false, above: 0pt, below: if continuation {4mm} else {8mm})[
  #let months = c.groups.map(g => g.ships.map(s => s.months).sum()).sum()
  #grid(columns: (31mm, 1fr), column-gutter: space.md,
    stack(spacing: 2mm,
      label(c.period),
      block[
        #set par(leading: 0.2em)
        #text(font: "Barlow", size: 16pt, fill: teal)[#if months >= 12 and calc.rem(months, 12) > 0 {
          [#duration(months - calc.rem(months, 12)) \ #duration(calc.rem(months, 12))]
        } else { duration(months) }]
      ],
      text(size: 8pt, fill: grey)[Combined service]),
    block(stroke: (left: 2pt + teal), inset: (left: space.md, top: 0.5mm, bottom: 1mm))[
      #text(size: 15pt, weight: "bold")[#c.name]
      #for group in c.groups [
        #v(3mm)
        #label(group.type, color: teal)
        #v(3mm)
        #grid(columns: if show-vessel-durations {(1fr, 31mm, 28mm)} else {(1fr, auto)},
          column-gutter: 2mm, row-gutter: if continuation {2.5mm} else {3.5mm},
          align: if show-vessel-durations {(left, left, right)} else {(left, right)},
          ..group.ships.map(ship => {
            let cells = (text(size: 10.5pt, weight: "semibold")[#ship.name], text(size: 9pt, fill: grey)[#ship.rank])
            if show-vessel-durations { cells.push(text(size: 9pt, fill: teal)[#duration(ship.months)]) }
            cells
          }).flatten())
      ]
    ])
]
// The nameplate overlaps the lower edge of the portrait by 4 mm.
#block(width: 100%, height: 77mm)[
  #place(top + center, dy: -18mm)[#pdf.artifact(image("../assets/spanners-refined.svg", width: 94mm))]
  #place(top + center, dy: -2mm)[#image("../assets/porthole.svg", width: 56mm)]
  #place(top + center, dy: 3mm)[#block(width: 46mm, height: 46mm, radius: 50%, clip: true)[#image("../assets/fictional-engineer.png", width: 46mm, height: 46mm, fit: "cover", alt: "AI-generated portrait of the fictional candidate")]]
  #place(top + left, dy: -2mm)[#block(width: 54mm)[
    #set text(fill: white, size: 10pt)
    #stack(spacing: 4mm,
      [#label("Based in", color: brass) \ #d.location],
      [#label("Telephone", color: brass) \ #d.phone],
      [#label("Nationality", color: brass) \ #d.nationality])]]
  #place(top + right, dy: -2mm)[#block(width: 54mm)[
    #set align(right)
    #set text(fill: white, size: 10pt)
    #stack(spacing: 4mm,
      [#label("Email", color: brass) \ #link("mailto:"+d.email)[#d.email]],
      [#label("Discipline", color: brass) \ Marine / mechanical],
      [#label("Rank", color: brass) \ Second Engineer])]]
  #place(top + left, dy: 48mm)[#pdf.artifact(image("../assets/hero-coupling-left.svg", width: 33mm))]
  #place(top + right, dy: 48mm)[#pdf.artifact(image("../assets/hero-coupling-right.svg", width: 33mm))]
  #place(top + center, dy: 45mm)[#block(width: 100mm, fill: rgb("f7f4ee"), inset: (x: 5mm, y: 3mm))[
    #align(center)[#stack(spacing: 2mm,
      text(font: "Barlow", weight: "semibold", size: 34pt)[#d.name],
      text(size: 11pt, tracking: 2.2pt, weight: "bold", fill: teal)[#d.rank])]]]
]
#set par(spacing: 0pt, leading: 0.6em)
#grid(columns: (1fr, 48mm), column-gutter: space.lg, align: horizon,
  [#d.profile],
  [#image("../assets/vessel-profile.svg", width: 48mm)])
#heading("01", "Experience", sub: "Company / vessel type / vessel")
#for c in d.companies.slice(0, 3) { company(c) }
#pagebreak()
// Give the concluding sections more vertical room on this page only.
#set page(margin: (x: 16mm, top: 12mm, bottom: 11mm))
#grid(columns: (1fr, auto), align: horizon,
  stack(spacing: 1mm, text(font: "Barlow", size: 23pt)[#d.name], label(d.rank, color: teal)),
  text(size: 9pt, fill: grey)[EXPERIENCE / CREDENTIALS])
#v(space.sm)
#line(length: 100%, stroke: 1pt + brass)
#heading("01", "Experience", sub: "Continued / earlier companies", above: 5mm, below: 3mm)
#for c in d.companies.slice(3) { company(c, continuation: true) }
#block(fill: navy, width: 100%, inset: (x: space.lg, y: space.md))[
 #set text(fill: white)
 #grid(columns: (1.4fr, 1fr, 1fr), column-gutter: 5mm,
   stack(spacing: 3mm, text(font: "Barlow", size: 25pt)[#calc.quo(total-months, 12) #text(font: "Source Sans 3", size: 14pt)[years] #calc.rem(total-months, 12) #text(font: "Source Sans 3", size: 14pt)[months]], label("Total experience", color: brass)),
   stack(spacing: 3mm, text(font: "Barlow", size: 25pt)[#ships.map(s => s.id).dedup().len()], label("Vessels", color: brass)),
   stack(spacing: 3mm, text(font: "Barlow", size: 25pt)[#d.companies.len()], label("Companies", color: brass)))
]

#heading("02", "Certificates & endorsements", sub: "Illustrative register - dates and credentials are fictional", above: 7mm, below: 5mm)
#set table(inset: (x: 3mm, y: 2.2mm), stroke: (left: none, right: none, top: none, bottom: 0.4pt + rgb("cfdddd")))
#text(size: 9.5pt)[
#table(columns: (1.25fr, 1.15fr, 0.65fr, 0.8fr),
 fill: (x,y) => if y == 0 {navy} else if calc.odd(y) {mist} else {white},
 table.header(..("Certificate", "Scope / record", "Issued", "Expires / review").map(t => text(fill: white, weight: "bold")[#t])),
 ..d.certificates.flatten())]
#v(1fr)
#heading("03", "Education & languages", above: 7mm, below: 4mm)
#grid(columns: (1.25fr, 1fr), column-gutter: 9mm,
  block[
    #label("Education", color: teal)
    #v(4mm)
    #for entry in d.education_entries [
      #block(breakable: false, below: 5mm, stroke: (left: 2pt + brass), inset: (left: 4mm))[
        #stack(spacing: 2.5mm,
          text(size: 12pt, weight: "bold")[#entry.qualification],
          text(size: 10pt, fill: grey)[#entry.institution],
          text(size: 8pt, fill: grey)[#entry.note])
      ]
    ]
  ],
  block[
    #label("Languages", color: teal)
    #v(4mm)
    #for entry in d.language_entries [
      #block(breakable: false, below: 4mm, fill: mist, width: 100%, inset: 3mm)[
        #stack(spacing: 1.5mm,
          text(size: 11pt, weight: "bold")[#entry.name],
          text(size: 9.5pt, fill: grey)[#entry.level])
      ]
    ]
  ])
