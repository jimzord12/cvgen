# 0008. One component contract, inspired by React

Date: 2026-09-12
Status: Accepted. Replaces the signature rule in `docs/conventions.md`. Paths
amended by 0010 and 0011: `src/` became `packages/cv-engine/` (shared parts in
`core/`, Flagship's components under `domains/marine/templates/flagship/`);
never recreate `src/`. The contract itself is unchanged.

## Context

The library already consists of small Typst functions that return content,
which is what a component is. What it lacks is one consistent shape:
argument order and naming differ between modules, layout slices and copy
strings are threaded separately, sections build their own headings so
nothing can be swapped, and styling is inline on every call. With several
templates ahead (ADR 0007), five dialects would be worse than one.

The owner knows React and wants that mental model: props, context,
children, named slots, scoped styles, prop validation. Typst has an
equivalent for each. It has no state, effects or hooks, and a printed CV
needs none.

## Decision

Every component under `src/` takes this shape as it is migrated:

```typst
#let component-name(ctx, data, prop: default, ..slots) = {
  // 1. validate: assertions with a fix in the message
  // 2. style block: set and show rules for this component
  // 3. layout: one grid, stack or block
  // 4. compose: call smaller components, pass ctx through untouched
}
```

- **`ctx` first, always.** One dictionary with `theme`, `layout`, `copy` and
  `options`, built once by the template with `make-ctx` and never mutated by
  a child. A component reads its own slice, `ctx.layout.hero`, never a
  sibling's.
- **`data` second.** The candidate fragment the component renders. Omitted
  for pure chrome such as a rule.
- **Named props with defaults** for anything that changes behaviour or look.
  Kebab-case. Never positional.
- **Slots last.** Positional content arguments are children. Named content
  arguments are named slots. A component without children omits the sink.
- **Style block** groups the component's `set` and `show` rules at the top of
  its returned block. A labelled show rule is used when one part of the
  component needs its own look, which is the nearest thing to a CSS class.
  Inline `text(size: ..., fill: ...)` is a one-off override, not the norm.
- **Helpers** live in `src/component.typ`: `make-ctx`, `require`, `slot`,
  `children`. They are conveniences; the shape is the contract.
- **Fixtures.** Each component gets one case under `tests/fixtures/` that
  renders it alone. This is the Storybook equivalent.

Approved by the owner in conversation on 2026-09-12, including ctx-first.

## Consequences

- `docs/conventions.md` changes its signature rule. A module is migrated
  whole; a file never mixes the old and new order. At the time of writing
  no module is migrated and `src/component.typ` does not exist yet.
- Migration is one module per commit in dependency order, leaves first,
  with the engineer pixel gate green after every commit. Order: primitives,
  sections, skills, education, certificates, experience, hero, page,
  template. `data.typ`, `theme.typ` and `pagination.typ` are pure
  functions, not components, and are exempt.
- The template stops threading layout slices and shrinks.
- No new runtime, no code generation, no macro system. A component that
  follows the shape without the helpers is still compliant.
- The pixel diff catches the main failure mode, a show rule leaking outside
  its block.
