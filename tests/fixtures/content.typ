#import "../../packages/cv-engine/domains/marine/templates/flagship/themes/golden-blue.typ": theme
#import "../../packages/cv-engine/domains/marine/templates/flagship/layouts/flagship-v11.typ": layout
#import "../../packages/cv-engine/domains/marine/data.typ": normalize-candidate, experience-totals
#import "../../packages/cv-engine/domains/marine/templates/flagship/adapter/adapter.typ": to-flagship-input
#import "../../packages/cv-engine/domains/marine/templates/flagship/components/experience.typ": experience-section
#import "../../packages/cv-engine/domains/marine/templates/flagship/components/sections.typ": synopsis
#import "../../packages/cv-engine/core/component.typ": make-ctx
#import "../../packages/cv-engine/domains/marine/templates/flagship/components/certificates.typ": certificates-section
#import "../../packages/cv-engine/domains/marine/templates/flagship/components/education.typ": education-languages-section
// Components read Flagship input, so the facts record goes through the adapter first.
#let d = normalize-candidate(to-flagship-input(json("../../examples/candidates/engineer-example.json")))
#set text(font: theme.fonts.body, size: theme.sizes.body, fill: theme.colors.ink, lang: "en")
#set par(spacing: 0pt, leading: theme.leading.body)
#set page(paper: "a4", margin: 16mm)
#experience-section(d.companies.slice(0, 1), theme, layout.experience, layout.experience.opening, sys.inputs.at("times", default: "true") == "true", d.copy.combined)
#synopsis(make-ctx(theme: theme, layout: layout, copy: d.copy), experience-totals(d.companies))
#certificates-section(d.certificates, d.copy, theme, layout)
#education-languages-section(d.education, d.languages, d.copy, theme, layout)
