# 0011. Domains, roles and templates: a CV library for any field

Date: 2026-09-21
Status: Accepted. Amends 0002 (a sixth entry-point input, `role`), 0007
(deck and engine become roles of the marine domain; the core no longer owns a
data model) and 0010 (templates and their schemas move under
`domains/<domain>/`). The PDF workflow half of 0010 is untouched.

## Context

The product served merchant marine seafarers only; the vision said so
explicitly. On 2026-09-20 the owner widened it: the library renders CVs for
any field, and each candidate belongs to a domain such as marine, travel and
tourism or software development. The next domain is travel and tourism.

This is not a rename. Maritime knowledge lives in the shared core:
`core/data.typ` and `core/pagination.typ` model companies, vessel-type
groups and ships with rank and months; the candidate schema requires
`identity.rank` and allows no other shape. Three open entries in
`docs/framework-gaps.md` (contract periods instead of service months, a
certificate table with data-driven columns, a skills slot inside the page
plan) are the same pressure seen from inside the marine domain: the facts
shape and the wording are baked in where they should be supplied.

Typst has no classes. "A domain is like a flexible abstract class" has to be
realised with dictionaries and functions.

## Decision

- **Hierarchy.** `domain > role > (grouping folders) > template`. A domain
  offers a facts shape (schema), assets, wording (`copy`) and rules (for
  marine: totals and the months rule). A role is exactly one level of
  specialisation inside a domain and may refine anything the domain offers.
  Grouping folders between a role and a template carry no meaning; the
  framework never reads them. A template is a named design and may override
  anything.
- **Markers.** A folder is a domain when it holds `domain.typ` exporting a
  dictionary `domain`; a role when it holds `role.typ` exporting `role`; a
  template is its design-named function file (`flagship.typ`). No registry,
  no discovery.
- **Composition.** Dictionaries merge in the order
  domain < role < template < `copy` inside the record < `copy` at the call
  site; later wins, nested dictionaries merge, arrays and scalars are
  replaced. A `merge`/`compose` helper in `core/node.typ` is added in the
  core-split stage; today the adapter does a shallow `+` of `copy`. A
  consequence: a role can
  override only what its domain offers; template words are overridden from
  the record or the call site, never by a role.
- **Domain-level templates.** A template may sit under a role or directly
  under a domain, in which case it serves every role of that domain.
  Flagship renders engineer and captain from data, artwork and copy with no
  role branch, so it stays one template at `domains/marine/templates/flagship/`.
  A role-level template is the exception, not the rule: a role fork doubles
  the section set forever (ADR 0007).
- **Core stays neutral.** `packages/cv-engine/core/` never imports from
  `domains/`. The core normalises and validates the common facts (identity
  name, contacts, profile, certificates, education, languages), owns the page
  shell, the page-plan grammar (a `companies` list per page, one synopsis on
  the last experience page, credentials after experience) and the merge
  helper. Everything that knows about vessels, ranks, service months and
  totals moves to `domains/marine/`. A second domain's template either fits
  the page-plan grammar or calls its own validator; the grammar is promoted
  or generalised when a second domain needs it changed, not before.
- **What moves and what does not.** Flagship, its assets and the candidate
  schema move under `domains/marine/`. `examples/candidates/` stays where it
  is: the frozen example records pin their portrait by root-absolute path.
  Every frozen file moves by `git mv` with its bytes unchanged and
  `tests/baseline.json` is regenerated with identical values; the engineer
  example stays pixel-identical to the v11 reference after every step.
- **Marine keeps its facts shape.** `identity.rank` and the
  companies/groups/ships model remain the marine domain's contract. The core
  requires only `identity.name`.
- **Name.** The project is renamed **CVgen** (repository `cvgen`, Typst
  package `cvgen`); the README and Trello board follow. Folder names `packages/cv-engine` and
  `packages/cv-workflow` stay. Frozen reference and export file names stay;
  the deliverable rule becomes `<Domain>-<Role>-CV-<Variant>-vNN.pdf`, which
  the existing names already satisfy.

Direction approved by the owner in conversation on 2026-09-20; the name
CVgen, the rewording of constitution sections 6 and 7 (explicitly), the
staged delivery and the repository rename on 2026-09-21.

## Consequences

- Constitution sections 6 and 7 are rewritten under this decision; the
  vision drops "maritime roles only".
- The entry point takes six inputs: candidate, role, theme, artwork, layout,
  display switch (plus the optional `copy`). `role` defaults to none.
- Delivered in four stages, each merged only with the suite green: the
  governance documents (this ADR); the mechanical move with baseline
  regeneration; the core split with the marine domain node, role markers and
  the tests that fail if the composition is wired wrong; the rename.
- Travel and tourism becomes the first proof: a new `domains/<domain>/`
  folder with its own schema, assets, wording and a template, added without
  touching `domains/marine/` or `core/`.
- The three open framework gaps stay open; they are now marine-domain work
  (contract periods, certificate columns, skills slot) rather than core work.
- Documentation that names the current tree (`AGENTS.md`, `architecture.md`,
  the reference pages, the skills) is updated stage by stage, never ahead of
  the code.
