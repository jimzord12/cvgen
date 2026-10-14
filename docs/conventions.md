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
- **Entry points reach components through a `lib.typ` only** (constitution
  section 3): their domain's (`packages/domains/<domain>/lib.typ`), or the
  Framework's (`packages/cv-framework/lib.typ`) for a one-off `Template` with no
  domain. The ctx-first components are modules there:
  `core-components` (label, rule, decoration, metric, duration-value, the
  page shell; in both) and `flagship-components` (every Flagship section,
  in marine's). A template's components are always exported as one module
  named `<template>-components`, never as flat names, so they cannot clash
  with each other. Each domain's `lib.typ`
  is its own namespace (`docs/engine/domains-and-roles.md`, "Naming rule
  for exports"). Example:
  `#import "/packages/domains/marine/lib.typ": make-ctx, flagship-components as fc`,
  then `fc.hero(ctx, d)`. The role, theme, artwork pack and layout come
  from the same import as modules (`roles.engine`,
  `flagship-themes.golden-blue`, `flagship-artwork.engineer`,
  `flagship-layouts.flagship-v11`), so an example has one import (TASK-55).
  Engine code inside `packages/` imports its files
  directly; a domain file reaches the core by a relative path through
  `cv-framework/core/` (`../../cv-framework/core/data.typ` from a domain's
  `data.typ`).
- **One signature per component.** Every core and Flagship module follows
  the contract since 2026-09-25. The flat names with the old order (data,
  theme, geometry slice) that `lib.typ` kept for earlier compositions were
  removed on 2026-10-14 (TASK-58); `docs/history.md` has the story.
- **Style block: not applied yet.** ADR 0008 asks each component to group
  its `set` and `show` rules at the top of its block; the 2026-09-25
  migration changed signatures only, and most components still style inline
  (`docs/framework-gaps.md`). A component touched for another reason moves
  its styling into the style block.
- **Parent owns outer spacing, child owns internal layout.** Never add an
  outer `v()` inside a component. A component reads its own slice,
  `ctx.layout.hero`, never a sibling's.
- **Tokens in themes, geometry in layouts, pictures in artwork.** A number
  with a unit inside `packages/cv-framework/core/` or a template's `components/` is a smell unless it is a structural constant
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
  `packages/domains/<domain>/` with `domain.typ` exporting a
  dictionary `domain`; a role folder is `roles/<role>/` inside it with
  `role.typ` exporting `role`; a template folder holds its design-named
  function file (`flagship.typ`). Any folder between a role and a template
  is grouping only and has no marker. Dictionaries merge
  domain < role < template < record `copy` < call-site `copy`.
- **Related pieces stay together.** Hero and its five helpers are one file.
  A new file is justified by a new responsibility, not by line count.
- **Paths from the project root** for assets: `/packages/domains/marine/assets/...`. Compile with
  `--root .`.
- **Naming:** kebab-case for functions, keys, folders and files (one case
  per file type: "File names" below). Domains
  are named after the career area (`marine`, `travel-and-tourism`), roles after
  the specialisation (`deck`, `engine`). Templates are named after the
  design, `flagship`, never after a role. Themes and artwork packs are
  named after what they look like, not after a revision number. Layouts
  carry the template and the reference they reproduce, `flagship-v11`.
- **Comments** explain a decision or a trap, never restate the code. One line
  at the top of a file says what the file owns.

## File names

One case per file type (TASK-55, 2026-10-14). A file that breaks it is
renamed with `git mv` in a move commit of its own; the repo-maintenance
audit (check N1) flags mixed cases inside one folder.

| Files | Case | Examples |
|---|---|---|
| Every folder, and every file of ours: `.typ`, `.json`, `.md`, `.yaml`, `.yml`, `.toml`, `.svg`, `.png`, `.jpg`, `.pdf`, `.html`, `.js`, `.ts`, `.ps1`, `.gs` | kebab-case; a role suffix stays dotted | `flagship-v11.typ`, `golden-blue.typ`, `candidate.schema.json`, `engineer.meta.json`, `model.test.ts`, `apps/design-review/` |
| Python files and packages | snake_case, because Python imports them by name | `design_review.py`, `cv_workflow/`, `make_assets.py` |
| Names a tool or an ecosystem fixes | as the tool wants | `README.md`, `AGENTS.md`, `CLAUDE.md`, `SKILL.md`, `LICENSE`, `__init__.py`, dotfiles, Backlog.md's `task-27 - <title>.md`, the Atlas kit's `.atlas/_kit/` |
| Vendored fonts and their licences | the upstream name, unmodified | `FiraSans-Bold.ttf`, `Jost[wght].ttf`, `OFL.txt`, `bonanova-OFL.txt` |
| The frozen reference and its archived renders | frozen: never renamed (`tests/baseline.json`, constitution) | `Marine-Engineer-CV-v11.pdf`, `studio/archive/design-studies/review/Marine-Engineer-CV-v11-page-1.png` |

## Candidate JSON (marine domain)

- The common facts (`identity.name`, `contacts`, `certificates`,
  `education_entries`, `language_entries`, `profile`, `disclosure`, `copy`)
  are normalised by the core; `identity.rank` and `companies` are the marine
  domain's. Another domain defines its own sections (ADR 0011).
- Nested schema only: `identity`, `contacts`, `companies`, `certificates`,
  `education_entries`, `language_entries`, optional `profile`, `disclosure`,
  `copy`. Validate a candidate record against `packages/domains/marine/schema/candidate.schema.json` (facts) and, with `copy`, against `packages/domains/marine/templates/flagship/schema/flagship-input.schema.json`.
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
- Official terms as in `docs/glossary.md`, never a synonym. A term the
  glossary lacks but the text needs repeatedly is added to it in the same
  change and named in the next report (glossary Rule 4).
- One concept per file under `docs/engine/`. First line says when to read
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

A `Release` PDF is named after its entry point (`engineer.pdf` beside
`engineer.typ`) and carries its version in the `title` of its entry in
`examples/release.json`, which becomes the `Meta File`'s `title`
(`Marine Engineer CV v12`). A release with visible changes raises that
number; Git keeps the earlier bytes. Only a frozen reference keeps a
versioned file name (`Marine-Engineer-CV-v11.pdf`).
