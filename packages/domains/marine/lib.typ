// The marine domain's public surface (ADR 0012): the Framework's names, the marine
// facts model and its first template, Flagship, under the flat names entry points have
// used since ADR 0011. Importing this file has no document side effects.
// Framework: shared by every domain.
#import "../../cv-framework/lib.typ": merge, compose, duration-parts, normalize-common, validate-common, make-ctx, duration, core-components
#import "../../cv-framework/lib.typ": label, rule, metric, duration-value, decoration, document-shell, page-header, page-footer, page-background
// Marine: facts model, totals and the domain node (ADR 0011).
#import "domain.typ": domain as marine
#import "data.typ": normalize-candidate, validate-candidate, experience-totals, company-months, experience-model
// Flagship: the marine domain's first template.
#import "templates/flagship/flagship.typ": flagship
#import "templates/flagship/adapter/adapter.typ": to-flagship-input, flagship-copy
#import "templates/flagship/components/skills.typ": skills-layout
// Flagship's ctx-first components as one module: flagship-components.hero(ctx, d).
#import "templates/flagship/components.typ" as flagship-components
// Flagship's pre-contract signatures, deprecated like the Framework's above.
#import "templates/flagship/legacy.typ": hero, portrait, portrait-frame, portrait-backdrop, contact-item, contact-group, identity-plate
#import "templates/flagship/legacy.typ": company-period, vessel-row, vessel-type-group, company-experience, experience-section
#import "templates/flagship/legacy.typ": section-heading, profile-summary, synopsis
#import "templates/flagship/legacy.typ": skills-heading, skill-list, skills-section
#import "templates/flagship/legacy.typ": certificate-table, certificates-section
#import "templates/flagship/legacy.typ": education-entry, language-entry, education-languages-section
