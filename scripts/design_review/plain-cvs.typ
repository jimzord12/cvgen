// Plain market CVs for the Design Review batch view: the pile a design must
// stand out from (the `Batch Test`). Twelve fictional people in the usual
// template shapes: single column, two columns, coloured sidebar, banner.
// Rendered once by server.py; never shown as CVgen work.

#set page(paper: "a4", margin: 0mm)
#set text(size: 11pt, fill: rgb("333333"))
#set par(leading: 0.55em)

#let people = (
  ("Ελένη Παπαδοπούλου", "Υπεύθυνη Πωλήσεων", "Source Sans 3", "single", "2f4f7f"),
  ("Nikos Andreou", "Hotel Operations Manager", "Libertinus Serif", "two", "444444"),
  ("Μαρία Κωνσταντίνου", "Λογίστρια", "Source Sans 3", "sidebar", "2d6a6a"),
  ("George Vlachos", "Travel Consultant", "Barlow", "banner", "1f3b57"),
  ("Σοφία Δημητρίου", "Υπάλληλος Υποδοχής", "Libertinus Serif", "single", "6b3a3a"),
  ("Petros Ioannou", "Tour Operations Assistant", "Source Sans 3", "two", "35506e"),
  ("Αναστασία Γεωργίου", "Συνοδός Εκδρομών", "Barlow", "sidebar", "7a5a2b"),
  ("Christos Nikolaou", "Customer Service Agent", "Libertinus Serif", "banner", "3b3b3b"),
  ("Κατερίνα Μιχαηλίδου", "Υπεύθυνη Κρατήσεων", "Source Sans 3", "banner", "4b2e5c"),
  ("Dimitra Alexiou", "Event Coordinator", "Barlow", "single", "22543d"),
  ("Γιάννης Σταθόπουλος", "Αρχηγός Ομάδας", "Libertinus Serif", "sidebar", "1d3557"),
  ("Irini Makri", "Ground Handling Agent", "Source Sans 3", "two", "5a5a5a"),
)

#let filler = [Experienced professional with a strong customer focus and a record of reliable work in busy, international environments. Organised, calm under pressure and at ease with teams and guests from many countries.]
#let head(t, c) = block(above: 10pt, below: 5pt, text(size: 10pt, weight: "bold", fill: rgb(c), upper(t)) + v(-6pt) + line(length: 100%, stroke: 0.5pt + rgb(c)))
#let job(role, org, years) = block(below: 7pt)[
  #text(weight: "bold", role) #h(1fr) #text(fill: rgb("777777"), years) \
  #text(style: "italic", org) \
  #text(size: 8.5pt)[- Coordinated daily operations and schedules \ - Handled bookings, complaints and special requests \ - Trained new staff members and reported to management]
]
#let body(c) = [
  #head("Profile", c) #filler
  #head("Experience", c)
  #job("Senior Associate", "Aegean Services S.A., Athens", "2019 – today")
  #job("Associate", "Hellas Travel Group, Thessaloniki", "2015 – 2019")
  #job("Assistant", "Blue Coast Hotels, Crete", "2012 – 2015")
  #job("Seasonal Assistant", "Ionian Holidays, Corfu", "2010 – 2012")
  #job("Trainee", "City Tours Ltd, Athens", "2009 – 2010")
  #head("Education", c)
  *BSc Tourism Management* #h(1fr) 2008 – 2012 \ _University of the Aegean_
  #head("Certificates", c) First Aid (2023) · Amadeus Selling Platform (2021) · ECDL (2014)
  #head("Interests", c) Hiking, photography, volunteering at local festivals
]
#let side(c) = [
  #head("Contact", c) +30 690 000 0000 \ name\@example.com \ Athens, Greece
  #head("Languages", c) Greek — native \ English — C2 \ Italian — B1
  #head("Skills", c) MS Office \ Booking systems \ Team leadership \ Customer care
]

#for (i, p) in people.enumerate() {
  let (name, title, font, shape, c) = p
  set text(font: font)
  if i > 0 { pagebreak() }
  if shape == "single" {
    pad(x: 22mm, y: 20mm)[
      #text(size: 22pt, weight: "bold", name) \
      #text(size: 12pt, fill: rgb(c), title) \
      #v(2pt) #text(fill: rgb("777777"))[+30 690 000 0000 · name\@example.com · Athens]
      #body(c)
      #head("Languages", c) Greek (native), English (C2), Italian (B1)
    ]
  } else if shape == "two" {
    pad(x: 18mm, y: 18mm)[
      #align(center)[#text(size: 20pt, weight: "bold", upper(name)) \ #text(size: 11pt, fill: rgb("666666"), title)]
      #v(4pt) #line(length: 100%, stroke: 0.6pt)
      #grid(columns: (1fr, 2.2fr), gutter: 8mm, side(c), body(c))
    ]
  } else if shape == "sidebar" {
    grid(columns: (62mm, 1fr),
      block(fill: rgb(c), width: 100%, height: 297mm, inset: 9mm)[
        #set text(fill: white)
        #align(center, box(width: 30mm, height: 30mm, radius: 15mm, fill: rgb("ffffff").transparentize(70%)))
        #v(6pt) #text(size: 15pt, weight: "bold", name) \ #title
        #let head(t, c) = block(above: 10pt, below: 5pt, text(size: 10pt, weight: "bold", upper(t)))
        #side("ffffff")
      ],
      pad(x: 10mm, y: 14mm, body(c)))
  } else {
    block(fill: rgb(c), width: 100%, inset: (x: 20mm, y: 12mm))[
      #set text(fill: white)
      #text(size: 22pt, weight: "bold", name) #h(1fr) #text(size: 11pt, title)
    ]
    pad(x: 20mm, y: 6mm, grid(columns: (2.2fr, 1fr), gutter: 8mm, body(c), side(c)))
  }
}
