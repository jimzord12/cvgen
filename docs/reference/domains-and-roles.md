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
