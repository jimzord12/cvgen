// The Framework: the shared core every CV is built on (ADR 0012). It imports no
// domain; a domain imports it. Importing this file has no document side effects.
#import "core/node.typ": merge, compose
#import "core/data.typ": duration-parts, normalize-common, validate-common
#import "core/component.typ": make-ctx
#import "core/primitives.typ": duration
// The ctx-first components (ADR 0008) as one module, so they cannot clash with a
// domain's names: core-components.page-header(ctx, ...).
#import "core/components.typ" as core-components
// Pre-contract signatures (data, theme, geometry) kept so custom compositions written
// before ADR 0008 render unchanged. Deprecated (docs/framework-gaps.md, "Legacy
// component signatures").
#import "core/legacy.typ": label, rule, metric, duration-value, decoration, document-shell, page-header, page-footer, page-background
