// Pre-contract signatures (data, theme, geometry) of Flagship's components, kept so
// custom compositions written before ADR 0008 landed keep rendering unchanged.
// `lib.typ` exports these under the old names. Deprecated: new code calls the
// ctx-first components in components/ (docs/framework-gaps.md, "Legacy component signatures").
#import "../../../../core/component.typ": make-ctx
#import "components/sections.typ" as sections

#let section-heading(number, title, theme, geometry, spacing, subtitle: none) = sections.section-heading(
  make-ctx(theme: theme, layout: (headings: geometry)), title, number: number, spacing: spacing, subtitle: subtitle)
#let profile-summary(body, illustration, theme, geometry) = sections.profile-summary(
  make-ctx(theme: theme, layout: (profile: geometry), artwork: (profile-illustration: illustration)), body)
#let synopsis(totals, captions, theme, geometry) = sections.synopsis(
  make-ctx(theme: theme, layout: (synopsis: geometry), copy: captions), totals)
