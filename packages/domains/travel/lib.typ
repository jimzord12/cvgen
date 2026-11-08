// The travel domain's public surface (ADR 0012, P-0013): the Framework's names, the travel facts
// model and its first template, Hanami (its components as the module hanami-components).
// Importing this file has no document side effects.
// Framework: shared by every domain.
#import "../../cv-framework/lib.typ": merge, compose, normalize-common, validate-common, make-ctx, core-components
// Travel: facts model, totals and the domain node.
#import "domain.typ": domain as travel
#import "data.typ": normalize-candidate, validate-candidate, destination-totals, experience-totals
// Hanami: the travel domain's first template.
#import "templates/hanami/hanami.typ": hanami
#import "templates/hanami/copy.typ": hanami-copy
#import "templates/hanami/components.typ" as hanami-components
// The theme, artwork pack and layout as modules, so an entry point needs this one import (TASK-55):
// hanami-themes.sakura, hanami-artwork.japan, hanami-layouts.showcase.
#import "templates/hanami/themes.typ" as hanami-themes
#import "templates/hanami/artwork.typ" as hanami-artwork
#import "templates/hanami/layouts.typ" as hanami-layouts
