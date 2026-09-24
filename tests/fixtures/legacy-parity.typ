// One custom composition written twice: with lib.typ's 32 deprecated pre-contract
// names (api=legacy) and with the ctx-first components lib.typ exports as
// core-components and flagship-components (api=contract). Each wrapper is called at
// least once; the suite requires identical pixels, PDF artifact tags and metadata, so
// compositions written before ADR 0008 keep rendering unchanged. Known limit: the
// suite's "called" check is textual, so a call inside a never-invoked #let counts.
#import "../../packages/cv-engine/lib.typ" as L
#import "../../packages/cv-engine/lib.typ": make-ctx, normalize-candidate, to-flagship-input, experience-totals, skills-layout
#import "../../packages/cv-engine/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/cv-engine/domains/marine/templates/flagship/artwork/engineer.typ": artwork
#import "../../packages/cv-engine/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout

#let C = L.core-components
#let F = L.flagship-components
#let legacy = sys.inputs.at("api", default: "contract") == "legacy"
#let d = normalize-candidate(to-flagship-input(json("../../examples/candidates/engineer-example.json")))
#let ctx = make-ctx(theme: theme, layout: layout, artwork: artwork, copy: d.copy, options: (show-vessel-durations: true))
#let company = d.companies.first()
#let group = company.groups.first()
#let exp = layout.experience
#let tight = (..layout.education, entry-gap: 3mm, line-gap: 1mm)
#let skills-geo = (..skills-layout, column-gap: 6mm)
#let skills-ctx = make-ctx(theme: theme, layout: (skills: skills-geo))
#let columns = (1fr, exp.rank-width, exp.duration-width)

// document-shell
#let meta = (title: "Parity title", author: "Parity author")
#show: body => if legacy {L.document-shell(d, theme, artwork, layout, body, ..meta)} else {C.document-shell(ctx, d, ..meta, body)}
#set par(spacing: 0pt, leading: theme.leading.body)

// Page 1: hero, profile, headings, experience, metrics, skills.
#if legacy {L.hero(d.identity, d.contacts, theme, artwork, layout.hero)} else {F.hero(ctx, d)}
#if legacy {L.profile-summary(d.profile, artwork.profile-illustration, theme, layout.profile)} else {F.profile-summary(ctx, d.profile)}
#if legacy {L.section-heading("01", "Experience", theme, layout.headings, layout.headings.opening, subtitle: "Company / vessel")} else {
  F.section-heading(ctx, "Experience", number: "01", spacing: layout.headings.opening, subtitle: "Company / vessel")}
#if legacy {L.experience-section(d.companies.slice(0, 2), theme, exp, exp.opening, true, "Combined")} else {
  F.experience-section(make-ctx(theme: theme, layout: layout, copy: (combined: "Combined")), d.companies.slice(0, 2), spacing: exp.opening)}
#grid(columns: (1fr, 1fr, 1fr), ..("8", "7", "1").zip(("Contracts", "Vessels", "Company")).map(((v, c)) =>
  if legacy {L.metric(v, c, theme, gap: 2mm)} else {C.metric(ctx, v, caption: c, gap: 2mm)}))
#v(4mm)
#let bullet = (source: "/packages/cv-engine/domains/marine/assets/captain/compass-bullet.svg")
#if legacy {L.skills-section((("Diesel overhaul", "Purifiers"), ("Planned maintenance",)), theme, title: "Core Skills", bullet: bullet, geometry: skills-geo)} else {
  F.skills-section(skills-ctx, (("Diesel overhaul", "Purifiers"), ("Planned maintenance",)), title: "Core Skills", bullet: bullet)}

// Page 2: page header, synopsis, certificates, education, languages.
#pagebreak()
#if legacy {L.page-header(d.identity.name, d.identity.rank, "CAPTION", theme, layout.header)} else {
  C.page-header(ctx, (name: d.identity.name, headline: d.identity.rank), caption: "CAPTION")}
#if legacy {L.synopsis(experience-totals(d.companies), d.copy, theme, layout.synopsis)} else {F.synopsis(ctx, experience-totals(d.companies))}
#if legacy {L.certificates-section(d.certificates.slice(0, 3), d.copy, theme, layout)} else {F.certificates-section(ctx, d.certificates.slice(0, 3))}
#if legacy {L.education-languages-section(d.education, d.languages, d.copy, theme, layout)} else {
  F.education-languages-section(ctx, (education: d.education, languages: d.languages))}
#if legacy {L.label("Personal details", theme, color: theme.colors.accent)} else {C.label(ctx, "Personal details", color: theme.colors.accent)}
#for e in d.education {if legacy {L.education-entry(e, theme, tight)} else {F.education-entry(make-ctx(theme: theme, layout: (education: tight)), e)}}

// Page 3: remaining core and hero wrappers, each called once.
#pagebreak()
#if legacy {L.section-heading(none, "No number", theme, layout.headings, layout.headings.continuation)} else {
  F.section-heading(ctx, "No number", spacing: layout.headings.continuation)}
#if legacy {L.rule(theme, weight: 1pt)} else {C.rule(ctx, weight: 1pt)}
#if legacy {L.decoration(artwork.profile-illustration, theme, width: 30mm, height: 12mm, artifact: false)} else {
  C.decoration(ctx, artwork.profile-illustration, width: 30mm, height: 12mm, artifact: false)}
#if legacy {L.duration-value(27, theme)} else {C.duration-value(ctx, 27)}
#block(height: 12mm, if legacy {L.page-footer("Disclosure", "BRAND", theme, layout.footer)} else {C.page-footer(ctx, "Disclosure", brand: "BRAND")})
#grid(columns: (auto, auto, auto), column-gutter: 4mm,
  if legacy {L.portrait(d.identity, theme, layout.hero)} else {F.portrait(ctx, d.identity)},
  box(width: 40mm, if legacy {L.portrait-frame(artwork.portrait-frame, theme)} else {F.portrait-frame(ctx, artwork.portrait-frame)}),
  box(width: 40mm, if legacy {L.portrait-backdrop(artwork.portrait-backdrop, theme)} else {F.portrait-backdrop(ctx, artwork.portrait-backdrop)}))
#block(fill: theme.colors.hero, inset: 3mm)[
  #if legacy {L.contact-item(d.contacts.left.first(), theme)} else {F.contact-item(ctx, d.contacts.left.first())}
  #if legacy {L.contact-group(d.contacts.right, right, theme, layout.hero)} else {F.contact-group(ctx, d.contacts.right, alignment: right)}
]
#if legacy {L.identity-plate(d.identity, theme, layout.hero)} else {F.identity-plate(ctx, d.identity)}

// Page 4: experience and skills parts, a language, the bare certificate table.
#pagebreak()
#if legacy {L.company-period(company.period, 27, "Combined", theme, exp)} else {
  F.company-period(make-ctx(theme: theme, layout: layout, copy: (combined: "Combined")), (period: company.period, months: 27))}
#grid(columns: columns, ..if legacy {L.vessel-row(group.ships.first(), false, theme, exp)} else {
  F.vessel-row(make-ctx(theme: theme, layout: layout, options: (show-vessel-durations: false)), group.ships.first())})
#grid(columns: columns, ..if legacy {L.vessel-row(group.ships.first(), true, theme, exp)} else {
  F.vessel-row(ctx, group.ships.first())})
#if legacy {L.vessel-type-group(group, true, theme, exp, exp.continuation)} else {F.vessel-type-group(ctx, group, spacing: exp.continuation)}
#if legacy {L.company-experience(company, theme, exp, exp.continuation, true, "Combined", continued: true)} else {
  F.company-experience(make-ctx(theme: theme, layout: layout, copy: (combined: "Combined")), company, spacing: exp.continuation, continued: true)}
#if legacy {L.skills-heading("Technical Skills", theme, geometry: skills-geo)} else {F.skills-heading(skills-ctx, "Technical Skills")}
#if legacy {L.skill-list(("Welding", "Lathe work"), theme, geometry: skills-geo)} else {F.skill-list(skills-ctx, ("Welding", "Lathe work"))}
#if legacy {L.language-entry(d.languages.first(), theme, tight)} else {F.language-entry(make-ctx(theme: theme, layout: (education: tight)), d.languages.first())}
#if legacy {L.certificate-table(d.certificates.slice(0, 2), ("A", "B", "C", "D"), theme, layout.certificates)} else {
  F.certificate-table(make-ctx(theme: theme, layout: layout, copy: (certificate-columns: ("A", "B", "C", "D"))), d.certificates.slice(0, 2))}

// Page 5: page-background alone. The shell's own background and footer are switched off,
// so a wrapper that drew nothing would leave the page blank (the suite checks it is not).
#set page(background: none, footer: none)
#if legacy {L.page-background(theme, artwork, layout)} else {C.page-background(ctx)}
