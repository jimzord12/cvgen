# Domains and roles

Read this before adding a domain, a role or a template, or when a template
needs a word or a rule that seems to belong to the domain rather than to the
design. Decided in [ADR 0011](../decisions/0011-domains-roles-templates.md);
the Framework and the domains became separate folders in
[ADR 0012](../decisions/0012-framework-and-domain-packages.md).

## The three levels

```text
packages/cv-framework/                        the Framework: core, fonts; imports no domain
packages/domains/<domain>/                    lib.typ (its public surface), domain.typ exports `domain`
  roles/<role>/                               role.typ exports `role`
    <any grouping folders>/                   no marker, no meaning
      <template>/                             <template>.typ exports the template function
  templates/<template>/                       a template that serves every role of the domain
```

- A **domain** is a career area: `marine`, `travel-and-tourism`. It offers
  what its area needs and nothing is mandatory: a facts shape (`schema/`),
  the SVG files (`assets/`), wording (`domain.copy`), metadata
  (`domain.meta`) and rules. For marine the rules are the experience model in
  `data.typ`: companies, vessel-type groups, ships with rank and months, and
  totals.
- A **role** is one level of specialisation: `deck`, `engine`. It may refine
  anything the domain offers. Today both marine roles are three-line markers,
  and Flagship composes only the role's `copy`; it reads `meta` and
  `experience` from the domain node directly. A role that needs to refine
  those is the moment to compose once in `flagship.typ` and read the result.
- A **template** is a named design. It may sit under a role or directly under
  the domain; Flagship serves both marine roles. It may override anything.

## How the pieces compose

Typst has no classes, so a level is a dictionary and refinement is a merge:

```typst
#import "/packages/cv-framework/core/node.typ": merge, compose
#let words = compose(domain, role, (copy: flagship-copy)).copy   // later wins
```

`merge` is deep for dictionaries and replaces arrays, strings and functions;
`compose` skips `none`, so a domain-level template passes `role: none`.
The full order for wording is domain < role < template < `copy` inside the
candidate record < `copy` at the call site. A consequence: a role can only
override words its domain owns; Flagship's own words are changed from the
record or the call site.

A function stored in a dictionary is called with parentheses around the
access: `(domain.experience.totals)(companies)`.

## What the Framework owns and what it does not

Nothing in `packages/cv-framework/` imports or reads a file in
`packages/domains/`, and every domain file that reaches the core does so
through `cv-framework/core/` (the suite asserts both). The Framework owns:
`normalize-common` and `validate-common` (identity name, contacts, profile,
certificates, education, languages), the page shell, the page-plan grammar
(a `companies` list per page, exactly one synopsis on the last experience
page, credentials after experience), pagination over a domain-supplied row
model (`count(company)`, `slice(company, rows)`), and `merge`/`compose`.

The domain owns everything that knows its career area: for marine,
`identity.rank`, the companies model, `company-months`,
`experience-totals`, and the `experience-model` the core paginates with.

## Adding a domain without touching marine

```text
packages/domains/travel-and-tourism/
  lib.typ               its public surface: the Framework's names it needs, its own names
  domain.typ            id, meta, copy, experience (its own row model)
  data.typ              normalize-candidate = normalize-common + the domain's sections; validate-candidate
  schema/               the domain's candidate-facts contract
  assets/               its SVG files
  templates/<design>/   a first template with its adapter, components, themes, artwork, layouts, tests/approved
examples/travel-and-tourism/<design>/*.typ
```

A domain file reaches the core by a relative path through the Framework,
for example `#import "../../cv-framework/core/data.typ": normalize-common`
from `data.typ`. If the domain's template does not fit the page-plan
grammar, it calls its own validator instead of `validate-pages`; the grammar
is generalised when a second domain needs it changed, not before (ADR 0011).

A one-off design for a single client whose domain does not exist yet is not
a domain: it lives in that client's `Envelope` and imports
`/packages/cv-framework/lib.typ` (`docs/guides/client-workflow.md`, step 9).

### Wiring checklist

A new domain is done when every line below is true:

1. `domains/<domain>/domain.typ` exports `domain` (`id`, `meta`, `copy`,
   `experience` with `count` and `slice`); `data.typ` exports the domain's
   normalise and validate functions built on `normalize-common` and
   `validate-common`.
2. `schema/candidate.schema.json` describes the facts; a fictional record
   under `examples/candidates/<domain>-<who>-example.json` validates against
   it. A template adds `schema/<template>-input.schema.json`.
   `packages/cv-workflow/cv_workflow/validate.py` picks the schema from the
   entry point's imports: a template's schema, else the domain's. Only
   marine's `lib.typ` stands for a template (Flagship); if the new domain's
   `lib.typ` should stand for its first template, teach `validate.py` that
   case and add it to the suite's schema checks.
3. `packages/domains/<domain>/lib.typ` exports the domain under the naming
   rule below.
4. `examples/<domain>/<design>/<name>.typ` compiles with `--root .`.
5. `tests/run.py` compiles every new example (`compile_case`) and asserts
   its page count; `scripts/build.ps1` lists it in `$examples`.
6. Once the owner approves the first render: the frozen PDF goes to the
   template's `tests/approved/`, the example is compared against it in
   `tests/run.py`, and the reviewed SVGs, fonts and example record are
   added to `tests/baseline.json` (adding entries is routine; constitution
   section 1).
7. `python tests/run.py` passes. Its boundary check proves the Framework
   imports no domain; it does not prove the Framework was left alone.
8. `git diff --stat main...HEAD -- packages/cv-framework packages/domains/marine`
   is empty (three dots: only the domain branch's own changes, so merging
   `main` in does not raise a false alarm; use `origin/main` if that is what
   you merged). If the Framework had to change, that is a separate, reviewed
   Framework change first.
9. `AGENTS.md` ("Where things are"), this page and a history entry name the
   new domain.

### Naming rule for exports

Each domain's `lib.typ` is its own flat namespace, so a new domain may reuse
marine's function names (`normalize-candidate`, `validate-candidate`)
without a clash: an entry point imports one domain's `lib.typ`. Inside one
`lib.typ`, Typst lets a later import silently replace an earlier one with
the same name (checked 2026-09-25: two `#import ...: f` lines keep the
second `f` without a warning), so search the file before adding a name.

The domain node takes the domain's short name (as `marine` does), a template
function keeps its own unique name, and its adapter is `to-<template>-input`
(as `to-flagship-input`). A template's components are exported as one
module named `<template>-components` (`flagship-components`, later
`postcard-components`), used as `flagship-components.hero(ctx, ...)`,
because a template has dozens of components and one module keeps them out
of the flat namespace; the Framework's components follow the same form as
`core-components` (component contract, `conventions.md`). Marine's flat
component names (`hero`, `section-heading`, ...) remain only as the
deprecated pre-contract wrappers.

A composition that needs two domains at once imports each `lib.typ` as a
module (`#import "/packages/domains/marine/lib.typ" as marine-lib`); none
does today.
