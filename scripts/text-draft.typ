// The Text Draft a client checks before design (docs/guides/client-workflow.md, step 8).
// One reusable house design, the first thing a client receives from us: a check page like
// the cover of a private dossier, then the CV's content set quietly, readable on a phone.
// All words the client reads come from the call, so the check page is written per client
// in their language; `labels` carries the few words of the page chrome.
//
//   #import "/scripts/text-draft.typ": text-draft
//   #show: text-draft.with(
//     name: "Eleni Example", role: "Licensed tour guide · Japan",
//     version: "Draft 01 · 25 Sep 2026", lang: "en", check-lang: "el",
//     labels: (kicker: "...", reply: "...", confidential: "...", prepared: "..."),
//     check: [ + ... + ... + ... ])
//   = Profile
//   ...
//
// Compile with --font-path packages/cv-framework/fonts (GFS Didot and Source Sans 3 both set Greek).

#let ink = rgb("#16202C")
#let brass = rgb("#A5804A")
#let hair = rgb("#D8D1C4")
#let muted = rgb("#6A6F77")
#let display = "GFS Didot"
#let body-font = "Source Sans 3"

#let default-labels = (
  kicker: "Your CV text, for checking",
  reply: "If everything is correct, reply OK.",
  confidential: "Confidential",
  prepared: "Prepared for",
)

// Greek set in capitals drops its accents (ΒΙΟΓΡΑΦΙΚΟΥ, never ΒΙΟΓΡΑΦΙΚΟΎ); a diaeresis stays.
#let unaccented = ("ά": "α", "έ": "ε", "ή": "η", "ί": "ι", "ό": "ο", "ύ": "υ", "ώ": "ω", "ΐ": "ϊ", "ΰ": "ϋ",
  "Ά": "Α", "Έ": "Ε", "Ή": "Η", "Ί": "Ι", "Ό": "Ο", "Ύ": "Υ", "Ώ": "Ω")
#let caps(s) = if type(s) == str { upper(unaccented.pairs().fold(s, (acc, p) => acc.replace(p.at(0), p.at(1)))) } else { upper(s) }

#let smallcaps-label(s, fill: muted, lang: none) = {
  let t = text(font: body-font, size: 7.5pt, weight: 600, tracking: 0.16em, fill: fill, caps(s))
  if lang != none { text(lang: lang, t) } else { t }
}

#let wordmark(size: 13pt) = text(font: display, size: size, tracking: 0.06em, fill: ink)[CV#text(fill: brass)[gen]]

#let text-draft(name: "", role: none, title: none, version: "", check: none, labels: (:),
                lang: "en", check-lang: "el", body) = {
  let labels = default-labels + labels
  set document(title: if title != none { title } else { name })
  set text(font: body-font, size: 11.5pt, fill: ink, lang: lang, hyphenate: false)
  set par(leading: 0.78em, spacing: 1.15em, justify: false)

  // Check page: a cover. No running header or footer here.
  if check != none {
    page(paper: "a4", margin: (x: 26mm, top: 22mm, bottom: 22mm), header: none, footer: none)[
      #grid(columns: (1fr, auto), align: (left + horizon, right + horizon),
        wordmark(), smallcaps-label(version))
      #v(5mm)
      #line(length: 100%, stroke: 0.5pt + hair)
      #v(1fr)
      #smallcaps-label(labels.kicker, fill: brass, lang: check-lang)
      #v(5mm)
      #text(font: display, size: 38pt, fill: ink, name)
      #if role != none [
        #v(2mm)
        #text(size: 13pt, fill: muted, role)
      ]
      #v(9mm)
      #line(length: 22mm, stroke: 1pt + brass)
      #v(9mm)
      #block(width: 100%)[
        #set text(lang: check-lang, size: 12pt)
        #set enum(numbering: n => text(font: display, size: 17pt, fill: brass, str(n)), indent: 0pt, body-indent: 7mm, spacing: 1.4em)
        #check
      ]
      #v(8mm)
      #block(width: 100%, inset: (y: 4mm), stroke: (top: 0.5pt + hair, bottom: 0.5pt + hair))[
        #text(lang: check-lang, font: display, size: 15pt, fill: ink, labels.reply)
      ]
      #v(1fr)
      #grid(columns: (1fr, auto), align: (left, right),
        smallcaps-label(labels.prepared + " " + name, lang: check-lang),
        smallcaps-label(labels.confidential, lang: check-lang))
    ]
  }

  // Content pages: a quiet manuscript with a running head and a folio.
  set page(paper: "a4", margin: (x: 26mm, top: 30mm, bottom: 26mm),
    header: context {
      grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
        wordmark(size: 10pt), smallcaps-label(name))
      v(-1.5mm)
      line(length: 100%, stroke: 0.5pt + hair)
    },
    footer: context {
      line(length: 100%, stroke: 0.5pt + hair)
      v(-1mm)
      grid(columns: (1fr, auto), align: (left, right),
        smallcaps-label(version),
        smallcaps-label(counter(page).display("1 / 1", both: true)))
    })
  show heading.where(level: 1): it => block(above: 2.2em, below: 1.1em, breakable: false)[
    #text(font: display, size: 21pt, weight: "regular", fill: ink, it.body)
    #v(-2.5mm)
    #line(length: 14mm, stroke: 0.8pt + brass)
  ]
  show heading.where(level: 2): it => block(above: 1.6em, below: 0.7em, breakable: false,
    text(font: body-font, size: 12pt, weight: 600, fill: ink, it.body))
  set list(marker: text(fill: brass)[–], indent: 0pt, body-indent: 4mm, spacing: 0.9em)
  show strong: set text(weight: 600)
  body
}
