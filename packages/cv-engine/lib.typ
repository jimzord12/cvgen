// Importing this file has no document side effects.
// Core: shared by every domain.
#import "core/node.typ": merge, compose
#import "core/data.typ": duration-parts, normalize-common, validate-common
#import "core/page.typ": document-shell, page-header, page-footer, page-background
#import "core/component.typ": make-ctx
#import "core/primitives.typ": duration
// Pre-contract signatures for custom compositions written before ADR 0008 (deprecated).
#import "core/legacy.typ": label, rule, metric, duration-value, decoration
// Marine domain: facts model, totals and the domain node (ADR 0011).
#import "domains/marine/domain.typ": domain as marine
#import "domains/marine/data.typ": normalize-candidate, validate-candidate, experience-totals, company-months, experience-model
// Flagship: the marine domain's first template and its sections. Component names below
// are the pre-contract signatures from legacy.typ where a module is migrated (deprecated).
#import "domains/marine/templates/flagship/flagship.typ": flagship
#import "domains/marine/templates/flagship/adapter/adapter.typ": to-flagship-input, flagship-copy
#import "domains/marine/templates/flagship/components/hero.typ": hero, portrait, portrait-frame, portrait-backdrop, contact-item, contact-group, identity-plate
#import "domains/marine/templates/flagship/components/experience.typ": company-period, vessel-row, vessel-type-group, company-experience, experience-section
#import "domains/marine/templates/flagship/legacy.typ": section-heading, profile-summary, synopsis
#import "domains/marine/templates/flagship/components/skills.typ": skills-layout
#import "domains/marine/templates/flagship/legacy.typ": skills-heading, skill-list, skills-section
#import "domains/marine/templates/flagship/components/certificates.typ": certificate-table, certificates-section
#import "domains/marine/templates/flagship/components/education.typ": education-entry, language-entry, education-languages-section
