// ADR 0008 "Fixtures": 31 of the 32 ctx-first components rendered alone, one per
// page, each page headed by the component's name. The 32nd, document-shell, wraps a
// whole document, so the examples and tests/fixtures/legacy-parity.typ cover it.
#import "../../packages/cv-framework/core/component.typ": make-ctx
#import "../../packages/cv-framework/core/primitives.typ": label, rule, decoration, metric, duration-value
#import "../../packages/cv-framework/core/page.typ": page-header, page-footer, page-background
#import "../../packages/domains/marine/data.typ": normalize-candidate, experience-totals
#import "../../packages/domains/marine/templates/flagship/adapter/adapter.typ": to-flagship-input
#import "../../packages/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/domains/marine/templates/flagship/artwork/engineer.typ": artwork
#import "../../packages/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout
#import "../../packages/domains/marine/templates/flagship/components/sections.typ": section-heading, profile-summary, synopsis
#import "../../packages/domains/marine/templates/flagship/components/skills.typ": skills-heading, skill-list, skills-section
#import "../../packages/domains/marine/templates/flagship/components/education.typ": education-entry, language-entry, education-languages-section
#import "../../packages/domains/marine/templates/flagship/components/certificates.typ": certificate-table, certificates-section
#import "../../packages/domains/marine/templates/flagship/components/experience.typ": company-period, vessel-row, vessel-type-group, company-experience, experience-section
#import "../../packages/domains/marine/templates/flagship/components/hero.typ": portrait, portrait-frame, portrait-backdrop, contact-item, contact-group, identity-plate, hero

#let d = normalize-candidate(to-flagship-input(json("../../examples/candidates/engineer-example.json")))
#let ctx = make-ctx(theme: theme, layout: layout, artwork: artwork, copy: d.copy, options: (show-vessel-durations: true))
#let company = d.companies.first()
#let spacing = layout.experience.opening
#set text(font: theme.fonts.body, size: theme.sizes.body, fill: theme.colors.ink, lang: "en")
#set par(spacing: 0pt, leading: theme.leading.body)
#set page(paper: "a4", margin: 16mm, fill: theme.colors.plate)

#let cases = (
  ("label", label(ctx, "Label")),
  ("rule", rule(ctx)),
  ("decoration", decoration(ctx, artwork.profile-illustration, width: 60mm)),
  ("metric", metric(ctx, "7", caption: "Vessels")),
  ("duration-value", duration-value(ctx, 27)),
  ("section-heading", section-heading(ctx, "Experience", number: "01", spacing: layout.headings.opening, subtitle: "Subtitle")),
  ("profile-summary", profile-summary(ctx, d.profile)),
  ("synopsis", synopsis(ctx, experience-totals(d.companies))),
  ("skills-heading", skills-heading(ctx, "Professional Skills")),
  ("skill-list", skill-list(ctx, ("Diesel overhaul", "Purifiers"))),
  ("skills-section", skills-section(ctx, (("Diesel overhaul", "Purifiers"), ("Planned maintenance",)))),
  ("education-entry", education-entry(ctx, d.education.first())),
  ("language-entry", language-entry(ctx, d.languages.first())),
  ("education-languages-section", education-languages-section(ctx, (education: d.education, languages: d.languages))),
  ("certificate-table", certificate-table(ctx, d.certificates)),
  ("certificates-section", certificates-section(ctx, d.certificates)),
  ("company-period", company-period(ctx, (period: company.period, months: 27))),
  ("vessel-row", grid(columns: (1fr, layout.experience.rank-width, layout.experience.duration-width),
    ..vessel-row(ctx, company.groups.first().ships.first()))),
  ("vessel-type-group", vessel-type-group(ctx, company.groups.first(), spacing: spacing)),
  ("company-experience", company-experience(ctx, company, spacing: spacing)),
  ("experience-section", experience-section(ctx, d.companies.slice(0, 2), spacing: spacing)),
  ("portrait", portrait(ctx, d.identity)),
  ("portrait-frame", portrait-frame(ctx, artwork.portrait-frame)),
  ("portrait-backdrop", portrait-backdrop(ctx, artwork.portrait-backdrop)),
  ("contact-item", contact-item(ctx, d.contacts.left.first())),
  ("contact-group", block(fill: theme.colors.hero, contact-group(ctx, d.contacts.left))),
  ("identity-plate", identity-plate(ctx, d.identity)),
  ("hero", block(fill: theme.colors.hero, hero(ctx, d))),
  ("page-header", page-header(ctx, (name: d.identity.name, headline: d.identity.rank), caption: "CAPTION")),
  ("page-footer", page-footer(ctx, "Disclosure", brand: "BRAND")),
  ("page-background", block(width: layout.width, height: 60mm, clip: true, page-background(ctx))),
)

#for (i, (name, body)) in cases.enumerate() {
  if i > 0 {pagebreak()}
  text(size: 8pt, fill: theme.colors.muted)[case: #name]
  v(4mm)
  body
}
