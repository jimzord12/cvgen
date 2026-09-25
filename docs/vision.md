# Vision

Read this when deciding whether a feature belongs in the project. Owned by
the product owner; last confirmed 2026-09-21.

## Approved next architecture

The owner approved a public monorepo with a locally usable CV engine, a separate
PDF workflow, and a future web application after the core is stable. Candidate
facts have a common contract; templates own their input schemas, adapters, and
presentation. The PDF workflow binds explicit owner approval to an exact PDF.
See [PDF workflow and storage](pdf-workflow.md) and
[ADR 0010](decisions/0010-public-monorepo-and-pdf-workflow.md).

The engine layout and local PDF workflow are implemented (2026-09-16), and
the engine is organised by domain, role and template (ADR 0011, implemented
2026-09-21); the web application remains pending.

## What this is

Hand-crafted, premium CVs made with AI on our own Typst framework (owner,
2026-09-25): a library of polished, distinctive CVs for any career area, organised by domain:
merchant marine first, travel and tourism next, others as they come. A CV
is something the reader on the other side, a crewing agency, a hotel group's
HR desk, a hiring manager, opens, reads and parses without friction. It is
built as Typst templates on one shared, domain-neutral core.

A **domain** (marine, travel and tourism, software development) offers what
its career area needs: a facts shape, assets, wording and rules. A **role** is one
level of specialisation inside a domain (deck and engine at sea; front-end
and back-end in software) and may refine what the domain offers. A
**template** is a named design; it may sit under a role or serve a whole
domain, and it may override anything. Each template comes in two to four
themes. Cadets and short careers are to get a one-page layout (direction
item 6, not built yet). Decided 2026-09-20,
[ADR 0011](decisions/0011-domains-roles-templates.md).

The person editing a CV changes data, not layout code. The person designing
a new look changes a theme or an artwork pack. The person opening a new career area
writes a domain: its schema, wording, assets and a first template against
the shared core, then freezes an approved render.

## What it is not

- Not a generic resume builder with one shape for everyone. Each domain
  keeps the facts and wording its career area actually uses. Two pages by default;
  one page for short careers once direction item 6 lands.
- The engine remains locally usable with one compiler. The approved future web
  application adds hosted intake, review, and delivery, with real candidate
  data in private storage outside the public source repository.
- Not an automatic layout engine. Pagination is explicit and reviewed by a
  human. The system refuses to shrink fonts to make content fit.
- Not a store of real people. Public content stays fictional.

## Principles

1. **Independent inputs, many templates.** Candidate, role, theme, artwork,
   layout, display switch. Each can change alone, and a candidate can change
   template within a domain without re-entering a career. If a feature
   needs two inputs to know about each other, it is in the wrong place.
2. **Roles are variations within a domain, never forks.** A template
   renders every role of its domain from data, artwork and copy. A section
   that must differ is a slot or a data-selected variant of the same
   template. A role-level template is the exception and needs a reason. In
   the marine tree today the deck variation is the captain artwork pack and
   example; the engine variation is the engineer pack and example.
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

1. **Domains, roles and templates.** Move Flagship and its schema under the
   marine domain, split the maritime data model out of the shared core, add
   the role level, rename the project. Four stages, each pixel-identical to
   the frozen reference. See ADR 0011. Opened and **done** 2026-09-21: all
   four stages merged the same day, each pixel-identical to v11.
2. **Travel and tourism.** The first non-marine domain: its facts shape,
   wording, assets and a first template, added without touching the marine
   domain or the core. The proof that item 1 worked.
3. **Deck data support** inside the marine domain. Real deck careers are
   recorded as contract periods, not service months. The marine schema must
   hold them, the synopsis must take its metrics from data, the certificate
   table must take its columns from data, and the skills section must be
   available inside the template, so a real deck CV fits the template
   instead of bypassing it. See ADR 0007.
4. **The component contract.** Migrate the Flagship modules to the shape in
   ADR 0008, one module per commit under the pixel gate. Opened and
   **done** 2026-09-25: core and Flagship components are ctx-first, exported
   as `core-components` and `flagship-components`; the old signatures stay
   as deprecated wrappers (`docs/framework-gaps.md`).
5. **A second marine template.** A named design with its own sections and
   frozen reference, likely grown from one of the studies under
   `archive/design-studies/`.
6. **Short-career layout.** A one-page layout profile for cadets, juniors
   and short careers, for every template.
7. **More themes.** Two to four per template.
8. **The hosted workflow** in the public monorepo: candidate intake, background
   rendering, owner review and approval, then delivery of the approved PDF.
   Build it after the core is stable; local operation remains supported.
