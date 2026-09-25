// Plain text draft for a client's Sign-off (docs/guides/client-workflow.md, step 8).
// No design: large type, one column, easy to read on a phone. The first page
// is the check page, written per client in the client's language; the rest
// is the CV's content in the CV's language.
//
//   #import "/scripts/text-draft.typ": text-draft
//   #show: text-draft.with(title: "Maria Papadaki - CV text", version: "Draft 01, 25 Sep 2026",
//     check: [ ... what to check, in Greek ... ], lang: "en", check-lang: "el")
//   = Profile
//   ...
//
// Compile with --font-path packages/cv-engine/fonts (Source Sans 3 covers Greek).

#let text-draft(title: "", version: "", check: none, lang: "en", check-lang: "el", body) = {
  set document(title: title)
  set page(paper: "a4", margin: (x: 22mm, y: 20mm),
    footer: context align(right, text(size: 10pt, fill: luma(110))[#version #h(1fr) #counter(page).display("1 / 1", both: true)]))
  set text(font: "Source Sans 3", size: 13pt, lang: lang)
  set par(leading: 0.75em, spacing: 1.2em)
  show heading.where(level: 1): it => block(above: 1.6em, below: 0.8em, text(size: 17pt, weight: "bold", it.body))
  show heading.where(level: 2): it => block(above: 1.2em, below: 0.6em, text(size: 14pt, weight: "bold", it.body))

  if check != none {
    block(text(size: 20pt, weight: "bold", title))
    v(0.6em)
    text(lang: check-lang, check)
    pagebreak()
  }
  body
}
