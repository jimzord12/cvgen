// The core's ctx-first components (ADR 0008) as one module. lib.typ exports it as
// `core-components`, so these names never clash with a domain's or a template's names.
#import "primitives.typ": label, rule, decoration, metric, duration-value
#import "page.typ": page-header, page-footer, page-background, document-shell
