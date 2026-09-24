// Education and languages for Flagship (ADR 0008 shape: ctx, data, props).
#import "../../../../../core/primitives.typ": label
#import "sections.typ": section-heading

// One qualification; geometry from ctx.layout.education.
#let education-entry(ctx, entry) = {
  let (theme, geometry) = (ctx.theme, ctx.layout.education)
  block(breakable: false, below: geometry.entry-gap,
    stroke: (left: 2pt + theme.colors.metal), inset: geometry.entry-inset)[
    #stack(spacing: geometry.line-gap,
      text(size: theme.sizes.qualification, weight: "bold")[#entry.qualification],
      text(size: theme.sizes.institution, fill: theme.colors.muted)[#entry.institution],
      if entry.at("note", default: "") != "" {text(size: theme.sizes.note, fill: theme.colors.muted)[#entry.note]})
  ]
}

// One language and its level; geometry from ctx.layout.education.
#let language-entry(ctx, entry) = {
  let (theme, geometry) = (ctx.theme, ctx.layout.education)
  block(breakable: false, below: geometry.language-gap,
    fill: theme.colors.surface, width: 100%, inset: geometry.language-inset)[
    #stack(spacing: geometry.language-line-gap,
      text(size: theme.sizes.language, weight: "bold")[#entry.name],
      text(size: theme.sizes.proficiency, fill: theme.colors.muted)[#entry.level])
  ]
}

// `data` is (education: entries, languages: entries); words from ctx.copy.
#let education-languages-section(ctx, data) = {
  let (theme, layout, copy) = (ctx.theme, ctx.layout, ctx.copy)
  section-heading(ctx, copy.education-languages, number: "03", spacing: layout.headings.education)
  grid(columns: layout.education.columns, column-gutter: layout.education.gap,
    block[
      #if data.education.len() > 0 {
        label(ctx, copy.education, color: theme.colors.accent)
        v(layout.education.heading-gap)
        for entry in data.education {education-entry(ctx, entry)}
      }
    ],
    block[
      #if data.languages.len() > 0 {
        label(ctx, copy.languages, color: theme.colors.accent)
        v(layout.education.heading-gap)
        for entry in data.languages {language-entry(ctx, entry)}
      }
    ])
}
