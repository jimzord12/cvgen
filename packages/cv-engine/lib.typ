// Importing this file has no document side effects.
// Core: shared by every domain.
#import "core/node.typ": merge, compose
#import "core/data.typ": duration-parts, normalize-common, validate-common
#import "core/component.typ": make-ctx
#import "core/primitives.typ": duration
// Marine domain: facts model, totals and the domain node (ADR 0011).
#import "domains/marine/domain.typ": domain as marine
#import "domains/marine/data.typ": normalize-candidate, validate-candidate, experience-totals, company-months, experience-model
// Flagship: the marine domain's first template.
#import "domains/marine/templates/flagship/flagship.typ": flagship
#import "domains/marine/templates/flagship/adapter/adapter.typ": to-flagship-input, flagship-copy
#import "domains/marine/templates/flagship/components/skills.typ": skills-layout
// Component names below keep their pre-contract signatures (data, theme, geometry) so
// custom compositions written before ADR 0008 render unchanged. Deprecated: new code
// imports the ctx-first components from core/ and the template's components/ and
// passes a make-ctx(...) dictionary (docs/framework-gaps.md, "Legacy component signatures").
#import "core/legacy.typ": label, rule, metric, duration-value, decoration, document-shell, page-header, page-footer, page-background
#import "domains/marine/templates/flagship/legacy.typ": hero, portrait, portrait-frame, portrait-backdrop, contact-item, contact-group, identity-plate
#import "domains/marine/templates/flagship/legacy.typ": company-period, vessel-row, vessel-type-group, company-experience, experience-section
#import "domains/marine/templates/flagship/legacy.typ": section-heading, profile-summary, synopsis
#import "domains/marine/templates/flagship/legacy.typ": skills-heading, skill-list, skills-section
#import "domains/marine/templates/flagship/legacy.typ": certificate-table, certificates-section
#import "domains/marine/templates/flagship/legacy.typ": education-entry, language-entry, education-languages-section
