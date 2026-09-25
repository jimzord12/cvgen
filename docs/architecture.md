# Architecture

Read this before changing any module under `packages/cv-framework/` or
`packages/domains/`.

This page describes the current implementation: the monorepo of
[ADR 0010](decisions/0010-public-monorepo-and-pdf-workflow.md) and
[PDF workflow and storage](pdf-workflow.md) since 2026-09-16, with the
engine organised by domain, role and template since 2026-09-21
([ADR 0011](decisions/0011-domains-roles-templates.md),
[domains and roles](reference/domains-and-roles.md)), and split into the
Framework and the domains beside it since 2026-09-25
([ADR 0012](decisions/0012-framework-and-domain-packages.md)). The engine is
two folders: `packages/cv-framework/` (the Framework: core, fonts, licences)
and `packages/domains/` (one folder per domain). The workflow package exists;
the web app does not. Paths below are relative to `packages/` unless they
start with `examples/`, `scripts/` or `tests/`.

## The one-paragraph version

`examples/marine/flagship/engineer.typ` loads a candidate-facts JSON and passes it,
together with a role marker, a theme, an artwork pack and a layout profile,
to `flagship` in `domains/marine/templates/flagship/flagship.typ`, reached
through `domains/marine/lib.typ`. The
template runs the facts through its adapter
(`domains/marine/templates/flagship/adapter/adapter.typ`), which composes the
wording of the marine domain, the role and Flagship (`cv-framework/core/node.typ`), then
normalises and validates the data with the marine domain's rules
(`domains/marine/data.typ` over `cv-framework/core/data.typ`), validates the page plan
against the domain's row model, and walks the plan page by page, calling
section functions that return Typst content. Section functions never read
files and never branch on the candidate's role. Everything visual comes from
the theme, everything geometric from the layout, every picture from the
artwork pack.

## The six inputs

| Input | File | Owns |
|---|---|---|
| Candidate facts | `examples/candidates/*.json` (contract: `domains/marine/schema/candidate.schema.json`) | Identity, contacts, profile, companies, vessels, certificates, education, languages, disclosure. No template wording |
| Role | `domains/marine/roles/<deck or engine>/role.typ`, or none | One level of specialisation inside the domain. Flagship composes the role's `copy` today; both marine roles are bare markers |
| Theme | `domains/marine/templates/flagship/themes/*.typ` | Colours, fonts, sizes, tracking, leading, and a map from legacy SVG hex colours to theme colours |
| Artwork | `domains/marine/templates/flagship/artwork/*.typ` | Which SVG under `domains/marine/assets/` fills each named slot, with optional width, x, y and opacity |
| Layout | `domains/marine/templates/flagship/layouts/*.typ` | Margins, hero geometry, column widths, gaps, spacing scale, page plan, `anchor-education` |
| Display switch | `show-vessel-durations` on `flagship` | Show or hide every vessel duration at once without moving columns |

A seventh, optional input is `copy` on `flagship`: overrides for the
wording. The adapter composes the marine domain's words, then the role's,
then Flagship's, then a `copy` key inside the record, then the argument
(later wins, `merge`/`compose` in `cv-framework/core/node.typ`), and the result is the Flagship input
(contract: `domains/marine/templates/flagship/schema/flagship-input.schema.json`). The two
contracts differ only by that key today; keeping them apart is what lets a
second template read the same facts with its own wording.

The template is the only place that sees all inputs. It builds one `ctx`
dictionary (theme, layout, artwork, the composed copy, options such as
`show-vessel-durations`) with `make-ctx` and passes it to every component;
see below.

## The component contract

Every component takes the same shape, decided in ADR 0008 and applied to
every core and Flagship module on 2026-09-25: `ctx` first, the data it
renders second, named props with defaults, content slots last. A component
reads its own slice of `ctx.layout` (`hero` reads `ctx.layout.hero`); a
section that composes a heading and a body reads both slices it places.
Inside, in order: validation with a fix in every message, the style block of
`set` and `show` rules, one layout construct, composition of smaller
components. `cv-framework/core/component.typ` holds `make-ctx`, the only helper a
component has needed so far.

`domains/marine/lib.typ` still exports the component names with their
pre-contract order (data, theme, geometry slice), from the Framework's
`core/legacy.typ` (through `cv-framework/lib.typ`) and the template's
`legacy.typ`: each wrapper builds a small `ctx` and calls the ctx-first
component, so custom compositions written before the migration render the
same pixels (`tests/fixtures/legacy-parity.typ` calls all 32). Entry
points reach the ctx-first components through their domain's `lib.typ` as
the modules `core-components` and `flagship-components`. The wrappers are
deprecated; `docs/framework-gaps.md` records when they can go.

## One Framework, domains, templates

The Framework is domain-neutral; a domain owns what its career area needs;
a template owns its design (ADR 0007, ADR 0011, ADR 0012). Who owns what:

| Framework (`cv-framework/core/`) | Marine domain (`domains/marine/`) | Per template |
|---|---|---|
| Common facts: identity name, contacts, profile, certificates, education, languages (`normalize-common`, `validate-common` in `data.typ`) | The marine facts: `identity.rank`, companies, vessel-type groups, ships with months; `company-months`, `experience-totals`, the row model (`data.typ`); the schema | Section components: hero, experience, synopsis, certificates, education, skills |
| Page shell, header, footer, backgrounds (`page.typ`); the header takes a name and headline (no domain data) and a caption, the shell takes title and author | `domain.meta` (PDF title suffix, author) | Layout profiles and page plans |
| Page plan grammar and pagination over a domain row model (`pagination.typ`) | `experience-model`: `count`, `slice`, `totals` | The page loop with its overflow assertion, in `flagship.typ` |
| `merge` and `compose` (`node.typ`) | `domain.copy`: the domain's six words | The adapter: input contract and Flagship's nine words |
| SVG recolouring and primitives; theme validation | The SVG files (`assets/`) | Artwork packs: which SVG in which slot |
| The verification runner and its checks | Role markers (`roles/deck`, `roles/engine`) | Frozen reference render and its pixel gate |

Roles are variations within a domain, never forks; Flagship serves both
marine roles from data, artwork and copy. A section that must differ is a
slot or a data-selected variant. A section is promoted from a template to
the Framework when a third template needs it unchanged, and from a domain to
the Framework when a second domain needs it unchanged. Nothing in
`cv-framework/` imports or reads anything in `domains/`; domain files reach
the core only through `cv-framework/`; the suite asserts both. A second
marine template gets its own folder beside Flagship and its own adapter; a
second domain gets its own folder beside `marine/`, with its own `lib.typ`,
and touches neither `cv-framework/` nor `marine/`.

## Module map

```text
cv-framework/                           the Framework (ADR 0012); imports no domain
  lib.typ                               core exports only, no side effects
  typst.toml                            package manifest
  fonts/  licenses/                     bundled OFL fonts and their notices
  core/
    node.typ                              merge, compose: domain < role < template
    data.typ                              duration-parts, required-text, normalize-common, validate-common
    theme.typ                             validate-theme: required colours and fonts
    component.typ                         make-ctx: builds the one ctx dictionary every component takes first (ADR 0008)
    components.typ                        the core's ctx-first components as one module; cv-framework/lib.typ exports it as core-components
    primitives.typ                        label, rule, decoration (SVG recolour), duration, metric
    page.typ                              page-header, page-footer, page-background, document-shell
    legacy.typ                            deprecated pre-contract signatures of primitives and page, exported by cv-framework/lib.typ
    pagination.typ                        validate-pages, company-fragment over a domain row model
domains/marine/                         the marine domain (ADR 0011)
  lib.typ                               the marine surface: the Framework's names, marine, Flagship (flat names)
  domain.typ                            id, meta, copy, experience
  data.typ                              company-months, experience-totals, normalize-candidate, validate-candidate, experience-model
  schema/candidate.schema.json          marine candidate-facts contract
  assets/                               the SVG files, shared by the domain's templates
  roles/deck/role.typ  roles/engine/role.typ   role markers
  templates/flagship/
    flagship.typ                          the composition: page loop, section order, overflow check
    adapter/adapter.typ                   flagship-copy defaults, to-flagship-input
    components.typ                        Flagship's ctx-first components as one module; marine's lib.typ exports it as flagship-components
    legacy.typ                            deprecated pre-contract signatures of the components, exported by marine's lib.typ
    schema/flagship-input.schema.json     Flagship input contract (facts + copy)
    components/hero.typ                   portrait, frame, backdrop, contact groups, identity plate, hero
    components/experience.typ             company-period, vessel-row, vessel-type-group, company-experience, experience-section
    components/sections.typ               section-heading, profile-summary, synopsis
    components/certificates.typ           certificate-table, certificates-section
    components/education.typ              education-entry, language-entry, education-languages-section
    components/skills.typ                 optional skills-section with themed bullets (not in the locked template)
    themes/  artwork/  layouts/           three of the four presentation inputs (assets live at domain level)
    tests/approved/                       the frozen v11 reference PDF

packages/cv-workflow/cv_workflow/       Python; owns everything around a candidate render
  workspace.py                          workspace and revision paths, ids, hashes, records, the refusal rules
  validate.py                           candidate record against the template's (or domain's) JSON Schema, before anything is written
  render.py                             validate, snapshot inputs, compile, render.json + render.log, then checks
  checks.py                             page count, empty page, fonts, bounds; bound to the PDF hash
  approve.py                            explicit approval receipt, bound to revision id and hash
  export.py                             verify, copy into a .partial- folder, verify, rename into place
scripts/cv.py                           the four local commands calling that package
```

The engine renders from its inputs and knows nothing about revisions or
approval; the workflow calls the compiler like any other user of the engine
(`typst compile --root <repo> --font-path <fonts>` on the snapshot's `cv.typ`).
The future web backend calls the same package functions.

## Composition tree

```text
flagship → document-shell
  page 1: hero → profile-summary → section-heading + experience-section
  page n: page-header → section-heading + experience-section
  last experience page: synopsis
  then: certificates-section, [v(1fr) if anchor-education], education-languages-section
```

## Who owns spacing

The parent owns outer gaps. The child owns its internal layout using its
geometry slice. Opening versus continuation spacing is chosen by the template
per page. Education does not decide to sit low on the page; the template's
`v(1fr)` under `anchor-education` does.

Vessel rows return grid cells, not their own grid, so every row in a group
shares the parent's column tracks. When durations are hidden the third column
keeps its measured width and height but emits no text, so vessel and rank
never move.

## Data rules

- Months are service months, not calendar differences. Company `period` is
  display text only.
- Each company has a unique id. Each vessel has a stable id. The same vessel
  under two ranks or companies counts once in the vessel total; its months
  add up.
- If per-vessel months are unknown, hide durations and give the company a
  `service-months` total. If both are given, they must agree.
- Totals are computed once from the full candidate, never from what a page
  happens to show.

## Pagination

The layout's `pages` array says which companies, or which row ranges of a
company, go on each page, and which page carries synopsis, certificates and
education. `validate-pages` checks every vessel row appears exactly once, in
order, and that synopsis follows the last experience page. After each page
the template asserts the page counter, so overflow fails with a message
instead of spilling onto an unplanned page.

## Verification

`tests/run.py` compiles the fixtures and the examples, checks fonts, text
bounds and page counts, and compares the engineer example to the frozen v11
PDF at 144 dpi plus normalised text. `tests/baseline.json` pins the hashes of
every frozen input so the comparison stays meaningful. `tests/workflow.py`
drives `scripts/cv.py` through a fictional workspace end to end, including
every refusal. See `docs/reference/verification.md`.
