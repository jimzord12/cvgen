// Japan Passage owns this two-page fictional design proposal; no library code.
#let d = json("../../sample.json")
#let ink = rgb("293b46")
#let red = rgb("b3574e")
#let gold = rgb("b29570")
#let muted = rgb("66747a")
#let pale = rgb("f2f5f4")
#let rule = rgb("d9e0e0")
#let jp = "M PLUS 1p"
#let trips = d.japan_trips
#let days = trips.map(t => t.days).sum()
#let pax = d.groups.map(g => g.pax).sum()
#let group-days = d.groups.map(g => g.days).sum()
#set document(title: "Japan Passage - Spacious Stylish", author: "CVgen / magazine-editor")
#set text(font: "Source Sans 3", size: 11pt, fill: ink, lang: "el")
#set par(leading: 0.55em, spacing: 0pt)
#set page(paper: "a4", margin: (x: 16mm, top: 0mm, bottom: 14mm), background: context {
  place(bottom + right, dx: 11mm, dy: -8mm, image("../../assets/cherry.svg", width: 35mm))
}, footer: context {
  line(length: 100%, stroke: 0.5pt + gold)
  v(2mm)
  grid(columns: (1fr, auto), text(size: 7.2pt, fill: muted)[ΦΑΝΤΑΣΤΙΚΟ ΠΡΟΣΩΠΟ · ΣΧΕΔΙΟ CVGEN], text(size: 7.2pt, fill: muted)[JAPAN PASSAGE  #counter(page).display("01") / 02])
})
#let label(body, color: muted) = text(size: 8.4pt, weight: "semibold", tracking: .6pt, fill: color, body)
#let sec(n, title, subtitle: none) = {
  v(5mm)
  grid(columns: (10mm, 1fr), align: bottom,
    text(font: "Barlow", size: 23pt, weight: "semibold", fill: gold, n),
    [#text(size: 15pt, weight: "bold", title)#if subtitle != none {linebreak(); text(size: 8.5pt, fill: muted, subtitle)}])
  v(2.5mm)
}
#let points(items) = {
  for x in items {grid(columns: (3mm, 1fr), text(fill: red)[·], [#x]); v(2mm)}
}
#let seal(size: 14mm) = box(width: size, height: size, stroke: .8pt + red, radius: 50%, inset: 1.1mm)[
  #align(center + horizon)[#text(font: jp, size: 11pt, weight: "bold", fill: red)[日本]]
]
#let hero(continued: false) = block(width: 100%, height: if continued {39mm} else {64mm})[
  #place(top + left, dx: -16mm, rect(width: 210mm, height: if continued {39mm} else {64mm}, fill: ink, stroke: none))
  #place(top + right, dx: 5mm, dy: if continued {1mm} else {5mm}, image("../../assets/journey.svg", width: if continued {57mm} else {70mm}))
  #place(top + left, dy: if continued {7mm} else {10mm}, label(color: rgb("c9b38e"))[TOUR LEADER / JAPAN])
  #place(top + left, dy: if continued {11.5mm} else {16mm}, text(font: "Bona Nova", size: if continued {25pt} else {34pt}, weight: "bold", fill: rgb("f7f4ee"))[#d.name.el])
  #place(top + left, dy: if continued {23mm} else {32mm}, text(size: if continued {11pt} else {12pt}, weight: "semibold", fill: white)[#d.title.el])
  #place(top + left, dy: if continued {29mm} else {39mm}, text(size: 10.5pt, fill: rgb("c9b38e"))[#d.title.specialty])
  #if not continued {place(top + left, dy: 49mm, label(color: rgb("b9c8cc"))[MARKOS ILIADIS · #text(font: jp, size: 8pt)[#d.name.kana]])}
]
#hero()
#v(4mm)
#grid(columns: (auto, 1fr), column-gutter: 4mm,
 label(color: red)[ATH → TYO], text(size: 9.5pt)[#d.contact.city · #d.contact.phone · #d.contact.email · #d.contact.link])
#v(4mm)
#d.profile
#v(4mm)
#block(fill: pale, inset: (x: 4mm, y: 2.5mm), width: 100%)[
 #grid(columns: (1fr, 1fr, 1fr), column-gutter: 5mm,
 [#text(font: "Barlow", size: 22pt, weight: "semibold")[#trips.len()] #label[ΤΑΞΙΔΙΑ ΣΤΗΝ ΙΑΠΩΝΙΑ]],
 [#text(font: "Barlow", size: 22pt, weight: "semibold")[#days] #label[ΗΜΕΡΕΣ ΣΤΗ ΧΩΡΑ]],
 [#text(font: "Barlow", size: 22pt, weight: "semibold")[N4] #label[JLPT · 12/2024]])
]
#sec("01", "Η Ιαπωνία, ταξίδι προς ταξίδι", subtitle: "Διαμονές, σπουδές και συν-αρχηγία · 2018–2026")
#for t in trips {
 block(width: 100%, inset: (y: 4.2mm))[
  #grid(columns: (31mm, 1fr, 14mm), column-gutter: 3mm,
   [#text(weight: "bold")[#t.when]#linebreak()#text(size: 9.5pt, fill: if t.kind == "colead" {red} else {muted})[#t.kind_el]],
   [#t.places.join(", ")#linebreak()#text(font: jp, size: 8pt, fill: muted)[#t.kanji_places.join(" · ")]],
   align(right)[#text(size: 13pt, weight: "semibold", fill: red)[#t.days]#linebreak()#text(size: 8pt, fill: muted)[ημέρες]])
 ]
 line(length: 100%, stroke: .35pt + rule)
}
#sec("02", "Επαγγελματική εμπειρία")
#for (i,e) in d.experience.enumerate() {
 if i > 0 {v(2.5mm)}
 grid(columns: (1fr, auto), column-gutter: 3mm,
  [#text(weight: "bold")[#e.role]#linebreak()#text(size: 10.5pt, fill: muted)[#e.company · #e.city]],
  text(size: 9.5pt, fill: red)[#e.from–#e.to])
 v(1mm)
 points(e.points)
}
#pagebreak()
#hero(continued: true)
#v(4mm)
#grid(columns: (1fr, auto), column-gutter: 4mm,
 [#label(color: red)[ATH → TYO] #h(3mm) #text(size: 9.5pt)[#d.contact.phone · #d.contact.email]],
 text(size: 9pt, fill: muted)[ΕΜΠΕΙΡΙΑ / ΕΤΟΙΜΟΤΗΤΑ])
#sec("03", "Ομάδες που συνόδευσε", subtitle: "Μία συν-αρχηγία στην Ιαπωνία · πέντε ομάδες Ευρώπης ως αρχηγός")
#set table(stroke: none, inset: (x: 2mm, y: 1.7mm))
#table(columns: (19mm, 1fr, 27mm, 13mm, 13mm), align: (left, left, left, right, right),
 fill: (x,y) => if y == 0 {ink} else if calc.odd(y) {pale} else {white},
 table.header(..("Πότε", "Προορισμός", "Ρόλος", "Άτομα", "Ημ.").map(x => text(size: 9pt, fill: white, weight: "semibold", x))),
 ..d.groups.map(g => (text(size: 10pt, g.date),text(size: 10pt, weight: if g.japan {"semibold"} else {"regular"}, fill: if g.japan {red} else {ink}, g.where),text(size: 9.5pt, g.role),text(size: 10pt,str(g.pax)),text(size:10pt,str(g.days)))).flatten())
#v(2mm)
#grid(columns: (1fr,auto), text(size: 10pt, weight: "semibold")[#d.groups.len() ομάδες · #pax συμμετοχές ταξιδιωτών], text(size: 10pt, weight: "semibold")[#group-days ημέρες συνοδείας])
#grid(columns: (1fr, 1fr), column-gutter: 9mm,
 [#sec("04", "Στην Ιαπωνία")#points(d.knowhow)],
 [#sec("05", "Στη συνοδεία")#points(d.operations)])
#grid(columns: (103mm, 1fr), column-gutter: 9mm,
 [#sec("06", "Σπουδές & πιστοποίηση")
 #for e in d.education {
  grid(columns: (1fr,auto), column-gutter: 3mm, text(weight: "semibold", e.title), text(size: 9.5pt, fill: red,e.years))
  v(1mm)
  text(size: 10.5pt, fill: muted,e.school)
  v(4mm)
 }
 #for c in d.certificates {
  text(weight: "semibold",c.title); linebreak(); text(size: 10pt, fill: muted,c.issuer); linebreak(); text(size: 10pt, fill: red,c.valid)
 }],
 [#sec("07", "Γλώσσες")
 #for l in d.languages {
  text(weight: "semibold",l.name); linebreak(); text(size: 10.5pt,l.level)
  if "note" in l {linebreak(); text(size: 9.5pt, fill: muted,l.note)}
  v(3mm)
 }
 #v(2mm)#seal()])
#sec("08", "Διαθεσιμότητα")
#grid(columns: (1fr,1fr), column-gutter: 9mm,
 [#points(d.availability.slice(0,2))], [#points(d.availability.slice(2,4))])
#v(3mm)
#block(fill: pale, inset: 3mm, width: 100%)[
 #label(color: red)[ΠΡΙΝ ΤΗΝ ΑΝΑΧΩΡΗΣΗ]
 #v(1mm)
 #d.offer
]
