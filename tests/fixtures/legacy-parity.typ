// One custom composition written twice: with lib.typ's pre-contract names (api=legacy)
// and with the ctx-first components (api=contract). The suite requires identical
// pixels, so compositions written before ADR 0008 keep rendering unchanged.
#import "../../packages/cv-engine/lib.typ" as lib
#import "../../packages/cv-engine/core/component.typ": make-ctx
#import "../../packages/cv-engine/core/primitives.typ": label, metric
#import "../../packages/cv-engine/core/page.typ": document-shell, page-header
#import "../../packages/cv-engine/domains/marine/data.typ": normalize-candidate, experience-totals
#import "../../packages/cv-engine/domains/marine/templates/flagship/adapter/adapter.typ": to-flagship-input
#import "../../packages/cv-engine/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/cv-engine/domains/marine/templates/flagship/artwork/engineer.typ": artwork
#import "../../packages/cv-engine/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout
#import "../../packages/cv-engine/domains/marine/templates/flagship/components/sections.typ": section-heading, profile-summary, synopsis
#import "../../packages/cv-engine/domains/marine/templates/flagship/components/skills.typ": skills-section
#import "../../packages/cv-engine/domains/marine/templates/flagship/components/education.typ": education-entry, education-languages-section
#import "../../packages/cv-engine/domains/marine/templates/flagship/components/certificates.typ": certificates-section
#import "../../packages/cv-engine/domains/marine/templates/flagship/components/experience.typ": experience-section
#import "../../packages/cv-engine/domains/marine/templates/flagship/components/hero.typ": hero

#let legacy = sys.inputs.at("api", default: "contract") == "legacy"
#let d = normalize-candidate(to-flagship-input(json("../../examples/candidates/engineer-example.json")))
#let ctx = make-ctx(theme: theme, layout: layout, artwork: artwork, copy: d.copy, options: (show-vessel-durations: true))
#let tight = (..layout.education, entry-gap: 3mm, line-gap: 1mm)

#show: body => if legacy {lib.document-shell(d, theme, artwork, layout, body)} else {document-shell(ctx, d, body)}
#set par(spacing: 0pt, leading: theme.leading.body)

#if legacy {lib.hero(d.identity, d.contacts, theme, artwork, layout.hero)} else {hero(ctx, d)}
#if legacy {lib.profile-summary(d.profile, artwork.profile-illustration, theme, layout.profile)} else {profile-summary(ctx, d.profile)}
#if legacy {lib.section-heading("01", "Experience", theme, layout.headings, layout.headings.opening, subtitle: "Company / vessel")} else {
  section-heading(ctx, "Experience", number: "01", spacing: layout.headings.opening, subtitle: "Company / vessel")}
#if legacy {lib.experience-section(d.companies.slice(0, 2), theme, layout.experience, layout.experience.opening, true, "Combined")} else {
  experience-section(make-ctx(theme: theme, layout: layout, copy: (combined: "Combined")), d.companies.slice(0, 2), spacing: layout.experience.opening)}
#grid(columns: (1fr, 1fr, 1fr), ..("8", "7", "1").zip(("Contracts", "Vessels", "Company")).map(((v, c)) =>
  if legacy {lib.metric(v, c, theme)} else {metric(ctx, v, caption: c)}))
#v(4mm)
#if legacy {lib.skills-section((("Diesel overhaul", "Purifiers"), ("Planned maintenance",)), theme, geometry: (..lib.skills-layout, column-gap: 6mm))} else {
  skills-section(make-ctx(theme: theme, layout: (skills: (..lib.skills-layout, column-gap: 6mm))), (("Diesel overhaul", "Purifiers"), ("Planned maintenance",)))}
#pagebreak()
#if legacy {lib.page-header(d.identity.name, d.identity.rank, "CAPTION", theme, layout.header)} else {
  page-header(ctx, (name: d.identity.name, headline: d.identity.rank), caption: "CAPTION")}
#if legacy {lib.synopsis(experience-totals(d.companies), d.copy, theme, layout.synopsis)} else {synopsis(ctx, experience-totals(d.companies))}
#if legacy {lib.certificates-section(d.certificates.slice(0, 3), d.copy, theme, layout)} else {certificates-section(ctx, d.certificates.slice(0, 3))}
#if legacy {lib.education-languages-section(d.education, d.languages, d.copy, theme, layout)} else {
  education-languages-section(ctx, (education: d.education, languages: d.languages))}
#if legacy {lib.label("Personal details", theme, color: theme.colors.accent)} else {label(ctx, "Personal details", color: theme.colors.accent)}
#for e in d.education {if legacy {lib.education-entry(e, theme, tight)} else {education-entry(make-ctx(theme: theme, layout: (education: tight)), e)}}
