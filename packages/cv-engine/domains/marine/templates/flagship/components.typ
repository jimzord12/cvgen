// Flagship's ctx-first components (ADR 0008) as one module. lib.typ exports it as
// `flagship-components` (a template's components carry the template's name,
// docs/reference/domains-and-roles.md), so these names never clash with the
// deprecated flat names that keep the pre-contract signatures.
#import "components/hero.typ": hero, portrait, portrait-frame, portrait-backdrop, contact-item, contact-group, identity-plate
#import "components/experience.typ": company-period, vessel-row, vessel-type-group, company-experience, experience-section
#import "components/sections.typ": section-heading, profile-summary, synopsis
#import "components/skills.typ": skills-heading, skill-list, skills-section, skills-layout
#import "components/certificates.typ": certificate-table, certificates-section
#import "components/education.typ": education-entry, language-entry, education-languages-section
