# Vision

Read this when deciding whether a feature belongs in the project. Owned by
the product owner; last confirmed 2026-09-15.

## Approved next architecture

The owner approved a public monorepo with a locally usable CV engine, a separate
PDF workflow, and a future web application after the core is stable. Candidate
facts have a common contract; templates own their input schemas, adapters, and
presentation. The PDF workflow binds explicit owner approval to an exact PDF.
See [PDF workflow and storage](pdf-workflow.md) and
[ADR 0010](decisions/0010-public-monorepo-and-pdf-workflow.md).

The engine layout is implemented (2026-09-16); the workflow package and the
web application are pending. This decision takes precedence over earlier folder
and sharing assumptions below.

## What this is

A product for merchant marine seafarers: polished, distinctive CVs that a
crewing agency or a shipping company's HR desk opens, reads and parses
without friction. It is built as a family of Typst templates on one shared
core. Every template comes in a deck variation and an engine variation and
in two to four themes. Cadets and short careers get a one-page layout.

The person editing a CV changes data, not layout code. The person designing
a new look changes a theme or an artwork pack. The person designing a new
template writes its sections against the shared core and the component
contract, then freezes an approved render.

## What it is not

- Not a general resume framework. Maritime roles only. Two pages by
  default, one page for cadets.
- The engine remains locally usable with one compiler. The approved future web
  application adds hosted intake, review, and delivery, with real candidate
  data in private storage outside the public source repository.
- Not an automatic layout engine. Pagination is explicit and reviewed by a
  human. The system refuses to shrink fonts to make content fit.
- Not a store of real people. Public content stays fictional.

## Principles

1. **Five inputs, many templates.** Candidate, theme, artwork, layout,
   display switch. Each can change alone, and a candidate can change
   template without re-entering a career. If a feature needs two inputs to
   know about each other, it is in the wrong place.
2. **Deck and engine are variations, never forks.** A template renders both
   roles from data, artwork and copy. A section that must differ is a slot
   or a data-selected variant of the same template. In the tree today the
   deck variation is the captain artwork pack and example; the engine
   variation is the engineer pack and example.
3. **Approved looks are frozen.** Every approved template has a locked
   reference render, and the suite proves the library reproduces it on
   every run.
4. **Loud failure over silent drift.** Overflow, missing months, a name that
   does not fit the plate: each fails with a message naming the fix.
5. **Evidence, not assurance.** A change is done when the suite passes and a
   render exists in a fresh folder.
6. **Readable in one sitting.** Each template's own code stays small enough
   to read in one go. Shared code is promoted when a third template needs
   it, never speculated.
7. **The framework grows from use.** It is the happy path, not a cage.
   Going around a component to get a CV done is allowed and recorded in
   `docs/framework-gaps.md`; repeated gaps become components, slots or
   extensions. Going around a rule is not: frozen references, fictional
   content, no shrinking and totals from data still hold (constitution
   section 10). The system is meant to evolve, not to be obeyed.

## Direction

In priority order. Each item is committed when the owner opens it; none is
started on an agent's initiative.

1. **Deck data support.** Real deck careers are recorded as contract
   periods, not service months. The schema must hold them, the synopsis
   must take its metrics from data, the certificate table must take its
   columns from data, and the skills section must be available inside the
   template, so a real deck CV fits the template instead of bypassing it.
   See ADR 0007.
2. **The component contract.** Migrate the Flagship modules to the shape in
   ADR 0008, one module per commit under the pixel gate.
3. **A second template.** A named design with its own sections and frozen
   reference, likely grown from one of the studies under `archive/design-studies/`. Its
   ownership follows the approved template layout in ADR 0010.
4. **Cadet layout.** A one-page layout profile for cadets and short
   careers, for every template.
5. **More themes.** Two to four per template.
6. **The hosted workflow** in the public monorepo: candidate intake, background
   rendering, owner review and approval, then delivery of the approved PDF.
   Build it after the core is stable; local operation remains supported.
