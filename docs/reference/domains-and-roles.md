# Domains and roles

Read this before adding a field, a role or a template, or when a template
needs a word or a rule that seems to belong to the field rather than to the
design. Decided in [ADR 0011](../decisions/0011-domains-roles-templates.md).

## The three levels

```text
packages/cv-engine/domains/<domain>/          domain.typ exports `domain`
  roles/<role>/                               role.typ exports `role`
    <any grouping folders>/                   no marker, no meaning
      <template>/                             <template>.typ exports the template function
  templates/<template>/                       a template that serves every role of the domain
```

- A **domain** is a field: `marine`, `travel-and-tourism`. It offers what its
  field needs and nothing is mandatory: a facts shape (`schema/`), the SVG
  files (`assets/`), wording (`domain.copy`), metadata (`domain.meta`) and
  rules. For marine the rules are the experience model in `data.typ`:
  companies, vessel-type groups, ships with rank and months, and totals.
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
#import "/packages/cv-engine/core/node.typ": merge, compose
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

## What the core owns and what it does not

`core/` never imports from `domains/` (the suite asserts it). It owns:
`normalize-common` and `validate-common` (identity name, contacts, profile,
certificates, education, languages), the page shell, the page-plan grammar
(a `companies` list per page, exactly one synopsis on the last experience
page, credentials after experience), pagination over a domain-supplied row
model (`count(company)`, `slice(company, rows)`), and `merge`/`compose`.

The domain owns everything that knows the field: for marine, `identity.rank`,
the companies model, `company-months`, `experience-totals`, and the
`experience-model` the core paginates with.

## Adding a field without touching marine

```text
domains/travel-and-tourism/
  domain.typ            id, meta, copy, experience (its own row model)
  data.typ              normalize-candidate = normalize-common + the field's sections; validate-candidate
  schema/               the field's candidate-facts contract
  assets/               its SVG files
  templates/<design>/   a first template with its adapter, components, themes, artwork, layouts, tests/approved
examples/travel-and-tourism/<design>/*.typ
```

If the field's template does not fit the page-plan grammar, it calls its own
validator instead of `validate-pages`; the grammar is generalised when a
second domain needs it changed, not before (ADR 0011).

### Wiring checklist

A new field is done when every line below is true:

1. `domains/<field>/domain.typ` exports `domain` (`id`, `meta`, `copy`,
   `experience` with `count` and `slice`); `data.typ` exports the field's
   normalise and validate functions built on `normalize-common` and
   `validate-common`.
2. `schema/candidate.schema.json` describes the facts; a fictional record
   under `examples/candidates/<field>-<who>-example.json` validates against it.
   A template adds `schema/<template>-input.schema.json`.
   `packages/cv-workflow/cv_workflow/validate.py` picks the schema from the
   entry point's imports; teach it the new field's case (today a
   `lib.typ`-only entry falls back to Flagship's schema only when every
   named domain is marine).
3. `packages/cv-engine/lib.typ` exports the field under the naming rule below.
4. `examples/<field>/<design>/<name>.typ` compiles with `--root .`.
5. `tests/run.py` compiles every new example (`compile_case`) and asserts
   its page count; `scripts/build.ps1` lists it in `$examples`.
6. Once the owner approves the first render: the frozen PDF goes to the
   template's `tests/approved/`, the example is compared against it in
   `tests/run.py`, and the reviewed SVGs, fonts and example record are
   added to `tests/baseline.json` (adding entries is routine; constitution
   section 1).
7. `python tests/run.py` passes. Its core-boundary check only proves that
   core modules import their own siblings; it does not prove the core was
   left alone.
8. `git diff --stat main...HEAD -- packages/cv-engine/core packages/cv-engine/domains/marine`
   is empty (three dots: only the field branch's own changes, so merging
   `main` in does not raise a false alarm; use `origin/main` if that is what
   you merged).
   If the core had to change, that is a separate, reviewed core change first.
9. `AGENTS.md` ("Where things are"), this page and a history entry name the
   new field.

### Naming rule for exports

`lib.typ` is one flat namespace, and Typst lets a later import silently
replace an earlier one with the same name (checked 2026-09-25: two
`#import ...: f` lines keep the second `f` without a warning). Marine came
first and keeps its flat names (`normalize-candidate`, `validate-candidate`,
`hero`, ...) so existing entry points and private workspaces keep working.
Every later domain exports **prefixed names**, renamed at the
import in `lib.typ`:

```typst
#import "domains/travel-and-tourism/domain.typ": domain as tourism
#import "domains/travel-and-tourism/data.typ": (normalize-candidate as tourism-normalize-candidate,
  validate-candidate as tourism-validate-candidate)
#import "domains/travel-and-tourism/templates/postcard/postcard.typ": postcard
```

The domain node takes the field's short name (as `marine` does), functions
take `<short-name>-` as a prefix, and a template function keeps its own
unique name, and its adapter is `to-<template>-input` (as
`to-flagship-input`). For domain functions, prefixed names were chosen over module
bindings (`import ... as tourism-data`) because they read the same way as
marine's existing names and can be found with one search. A template's
components are the exception: they are exported as one module named
`<template>-components` (`flagship-components`, later
`postcard-components`), used as `flagship-components.hero(ctx, ...)`,
because a template has dozens of components and one module keeps them out
of the flat namespace entirely; the shared core's components follow the same
form as `core-components` (component contract, `conventions.md`). Marine's
flat component names (`hero`, `section-heading`, ...) remain only as the
deprecated pre-contract wrappers.
Before adding an export, search `lib.typ` for the name. The rule is a convention today; when the
second domain lands, `tests/run.py` should also check that no name is bound
twice in `lib.typ`.
