// The marine domain's public surface (ADR 0012): the Framework's names, the marine
// facts model and its first template, Flagship (its components as the module
// flagship-components). Importing this file has no document side effects.
// Framework: shared by every domain.
#import "../../cv-framework/lib.typ": merge, compose, duration-parts, normalize-common, validate-common, make-ctx, duration, core-components
// Marine: facts model, totals and the domain node (ADR 0011).
#import "domain.typ": domain as marine
#import "data.typ": normalize-candidate, validate-candidate, experience-totals, company-months, experience-model
// Flagship: the marine domain's first template.
#import "templates/flagship/flagship.typ": flagship
#import "templates/flagship/adapter/adapter.typ": to-flagship-input, flagship-copy
#import "templates/flagship/components/skills.typ": skills-layout
// Flagship's ctx-first components as one module: flagship-components.hero(ctx, d).
#import "templates/flagship/components.typ" as flagship-components
