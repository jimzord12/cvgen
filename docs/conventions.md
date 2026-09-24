# Conventions

How code, documents and commits are written here. Read before writing any of
them. These evolve; the rules that do not are in `constitution.md`.

## Typst code

- **Small functions that return content, one shape (ADR 0008).** A
  component takes `ctx` first, then the data it renders, then named props
  with defaults, then content slots:

  ```typst
  #let name(ctx, data, prop: default, ..slots) = { ... }
  ```

  `ctx` bundles `theme`, `layout` (the whole profile), `artwork`, `copy` and
  `options`; the template builds it once with `make-ctx`
  (`core/component.typ`) and passes it through untouched. Inside the
  function: validate, then the style block of `set` and `show` rules, then
  layout, then compose. Positional content arguments are children; named
  content arguments are named slots. A page variant the parent chooses (for
  example `spacing: layout.experience.opening`) is a named prop.
- **Entry points reach components through `lib.typ` only** (constitution
  section 3). The ctx-first components are two modules there:
  `core-components` (label, rule, decoration, metric, duration-value, the
  page shell) and `flagship-components` (every Flagship section). A
  template's components are always exported as one module named
  `<template>-components`, never as flat names, so they cannot clash with
  each other, with a later domain or with the deprecated flat names; domain
  functions are the ones that take prefixed flat names
  (`docs/reference/domains-and-roles.md`, "Naming rule for exports"). Example:
  `#import "/packages/cv-engine/lib.typ": make-ctx, flagship-components as fc`,
  then `fc.hero(ctx, d)`. Engine code inside `packages/` imports sibling
  files directly.
- **Legacy signatures stay in `legacy.typ`.** Every core and Flagship module
  follows the contract since 2026-09-25. The flat component names `lib.typ`
  exports (`hero`, `section-heading`, ...) are thin wrappers with the old
  order (data, theme, geometry slice) so custom compositions written earlier
  render unchanged; `tests/fixtures/legacy-parity.typ` calls all 32 and
  proves identical pixels and PDF metadata (the suite rejects a name called
  only in a comment, and a page-background that draws nothing). Deprecated: new code never calls them, and no new
  legacy wrapper is added.
- **Style block: not applied yet.** ADR 0008 asks each component to group
  its `set` and `show` rules at the top of its block; the 2026-09-25
  migration changed signatures only, and most components still style inline
  (`docs/framework-gaps.md`). A component touched for another reason moves
  its styling into the style block.
- **Parent owns outer spacing, child owns internal layout.** Never add an
  outer `v()` inside a component. A component reads its own slice,
  `ctx.layout.hero`, never a sibling's.
- **Tokens in themes, geometry in layouts, pictures in artwork.** A number
  with a unit inside `packages/cv-engine/core/` or a template's `components/` is a smell unless it is a structural constant
  such as a 2pt rule.
- **Assert with a fix in the message.** `assert(..., message: "Name exceeds
  identity plate: adjust theme.sizes.name or hero.plate-width")`. The reader
  should not need the source to know what to change.
- **No role branches.** A role within a domain is data, artwork and copy;
  in the marine tree today that is the captain and engineer packs and
  examples. A section that must differ is a slot or a data-selected
  variant. A role-level template folder is allowed by ADR 0011 but needs a
  recorded reason; a component never tests a role name.
- **Domain, role and template markers (ADR 0011).** A domain folder is
  `packages/cv-engine/domains/<domain>/` with `domain.typ` exporting a
  dictionary `domain`; a role folder is `roles/<role>/` inside it with
  `role.typ` exporting `role`; a template folder holds its design-named
  function file (`flagship.typ`). Any folder between a role and a template
  is grouping only and has no marker. Dictionaries merge
  domain < role < template < record `copy` < call-site `copy`.
- **Related pieces stay together.** Hero and its five helpers are one file.
  A new file is justified by a new responsibility, not by line count.
- **Paths from the project root** for assets: `/packages/cv-engine/domains/marine/assets/...`. Compile with
  `--root .`.
- **Naming:** kebab-case for functions, keys, folders and files. Domains
  are named after the field (`marine`, `travel-and-tourism`), roles after
  the specialisation (`deck`, `engine`). Templates are named after the
  design, `flagship`, never after a role. Themes and artwork packs are
  named after what they look like, not after a revision number. Layouts
  carry the template and the reference they reproduce, `flagship-v11`.
- **Comments** explain a decision or a trap, never restate the code. One line
  at the top of a file says what the file owns.

## Candidate JSON (marine domain)

- The common facts (`identity.name`, `contacts`, `certificates`,
  `education_entries`, `language_entries`, `profile`, `disclosure`, `copy`)
  are normalised by the core; `identity.rank` and `companies` are the marine
  domain's. Another domain defines its own sections (ADR 0011).
- Nested schema only: `identity`, `contacts`, `companies`, `certificates`,
  `education_entries`, `language_entries`, optional `profile`, `disclosure`,
  `copy`. Validate a candidate record against `packages/cv-engine/domains/marine/schema/candidate.schema.json` (facts) and, with `copy`, against `packages/cv-engine/domains/marine/templates/flagship/schema/flagship-input.schema.json`.
- Stable ids for companies and vessels. Whole service months.
- Display text is display text. Never encode data in a label.

## Tests

- A test exercises the real compiler and the real PDF. No mocks.
- A fixture under `tests/fixtures/` is a Typst file with `sys.inputs` cases.
  The Python runner selects cases and asserts on the output PDF.
- A test that would pass with the feature deleted is not written.
- Negative cases assert on the error message text.
- Prefer one compile case that covers a path over several that cover a mock.

## Documents

- English. Plain language. Lead with the answer.
- One concept per file under `docs/reference/`. First line says when to read
  it. Under about 100 lines.
- Anything with a shape (JSON, dictionary, command) is a code block with a
  one-line brief above it.
- Decisions go in `docs/decisions/NNNN-title.md` using the template in
  `docs/decisions/README.md`. History goes in `docs/history.md`. Neither is
  rewritten later beyond an ADR's Status line; add a new entry.
- No emojis.

## Commits

Conventional Commits, imperative, under 72 characters on the first line:

```text
feat: add chief engineer artwork pack
fix: keep rank column fixed when a duration wraps
refactor: move page-plan validation into pagination.typ
docs: record decision to freeze v11
test: cover company split across three pages
chore: bump pinned Typst version
```

Body explains why and names the evidence folder when a render or suite run
backs the change.

## Versioning of deliverables

Rendered PDFs are named `<Domain>-<Role>-CV-<Variant>-vNN.pdf`, for example
`Marine-Engineer-CV-v11.pdf`. A new render with visible changes gets a new
number and a new file. Old files are removed
in the same commit unless they are a frozen reference.
