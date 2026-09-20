#import "../../../../../core/primitives.typ": label
#import "sections.typ": section-heading

#let education-entry(entry, theme, geometry) = block(breakable: false, below: geometry.entry-gap,
  stroke: (left: 2pt + theme.colors.metal), inset: geometry.entry-inset)[
  #stack(spacing: geometry.line-gap,
    text(size: theme.sizes.qualification, weight: "bold")[#entry.qualification],
    text(size: theme.sizes.institution, fill: theme.colors.muted)[#entry.institution],
    if entry.at("note", default: "") != "" {text(size: theme.sizes.note, fill: theme.colors.muted)[#entry.note]})
]

#let language-entry(entry, theme, geometry) = block(breakable: false, below: geometry.language-gap,
  fill: theme.colors.surface, width: 100%, inset: geometry.language-inset)[
  #stack(spacing: geometry.language-line-gap,
    text(size: theme.sizes.language, weight: "bold")[#entry.name],
    text(size: theme.sizes.proficiency, fill: theme.colors.muted)[#entry.level])
]

#let education-languages-section(education, languages, copy, theme, layout) = {
  section-heading("03", copy.education-languages, theme, layout.headings, layout.headings.education)
  grid(columns: layout.education.columns, column-gutter: layout.education.gap,
    block[
      #if education.len() > 0 {
        label(copy.education, theme, color: theme.colors.accent)
        v(layout.education.heading-gap)
        for entry in education {education-entry(entry, theme, layout.education)}
      }
    ],
    block[
      #if languages.len() > 0 {
        label(copy.languages, theme, color: theme.colors.accent)
        v(layout.education.heading-gap)
        for entry in languages {language-entry(entry, theme, layout.education)}
      }
    ])
}
