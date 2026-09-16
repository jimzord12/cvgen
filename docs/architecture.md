# Architecture

Read this before changing any module under `src/`.

This page describes the current implementation. The approved target monorepo
layout and candidate PDF lifecycle are in [PDF workflow and storage](pdf-workflow.md)
and [ADR 0010](decisions/0010-public-monorepo-and-pdf-workflow.md); implementation
is pending. Use that target when planning structural or workflow changes.

## The one-paragraph version

`examples/engineer.typ` loads a candidate JSON and passes it, together with a
theme, an artwork pack and a layout profile, to `flagship` in
`src/templates/flagship.typ`. The template normalises and validates the data,
validates the page plan, then walks the plan page by page, calling section
functions that return Typst content. Section functions never read files and
never branch on the candidate's role. Everything visual comes from the theme,
everything geometric from the layout, every picture from the artwork pack.

## The five inputs

| Input | File | Owns |
|---|---|---|
| Candidate | `content/*.json` | Facts and display text: identity, contacts, companies, vessels, certificates, education, languages, optional copy overrides |
| Theme | `themes/*.typ` | Colours, fonts, sizes, tracking, leading, and a map from legacy SVG hex colours to theme colours |
| Artwork | `artwork/*.typ` | Which SVG fills each named slot, with optional width, x, y and opacity |
| Layout | `layouts/*.typ` | Margins, hero geometry, column widths, gaps, spacing scale, page plan, `anchor-education` |
| Display switch | `show-vessel-durations` on `flagship` | Show or hide every vessel duration at once without moving columns |

The template is the only place that sees all five. Children receive only the
slice they need, so a hero function gets `layout.hero`, not `layout`. Once
the ADR 0008 migration starts, the template will build one `ctx` dictionary
from theme, layout, copy and options and pass that down instead; see below.

## The component contract

Every component will take the same shape, decided in ADR 0008: `ctx` first,
the data it renders second, named props with defaults, content slots last.
Inside, in order: validation with a fix in every message, the style block of
`set` and `show` rules, one layout construct, composition of smaller
components. Helpers will live in `src/component.typ` once migration starts.
Modules are migrated to this shape one per commit; an unmigrated module
keeps the older order (data, theme, geometry slice) until its turn. As of
this writing no module has been migrated.

## One core, many templates

Flagship is the first template of a family (ADR 0007). What is shared and
what is per template:

| Shared core | Per template |
|---|---|
| Candidate contract and schema, normalisation, totals (`data.typ`) | Section components: hero, experience, synopsis, certificates, education, skills |
| Page shell, header, footer, backgrounds (`page.typ`) | Layout profiles and page plans |
| Page plan validation (`pagination.typ`) | The page loop with its overflow assertion, today in `templates/flagship.typ` |
| The verification runner and its checks | Frozen reference render and its pixel gate |
| SVG recolouring and primitives | Artwork slot names the template expects |
| Component helpers, theme validation | Copy defaults |

Deck and engine are never separate templates. A section that must differ is
a slot or a data-selected variant. A section is promoted from a template to
the core when a third template needs it unchanged. Today `src/` holds the
shared core and Flagship's sections side by side, with the Flagship
composition already under `src/templates/flagship.typ`. The second template
adds `src/core/` and turns `src/templates/flagship.typ` into
`src/templates/flagship/`. Not before.

## Module map

```text
lib.typ                     public exports, no side effects
src/
  data.typ                  normalise raw JSON, validate, pure totals, duration parts
  theme.typ                 validate-theme: required colours and fonts
  primitives.typ            label, rule, decoration (SVG recolour), duration, metric
  hero.typ                  portrait, frame, backdrop, contact groups, identity plate, hero
  experience.typ            company-period, vessel-row, vessel-type-group, company-experience, experience-section
  sections.typ              section-heading, profile-summary, synopsis
  certificates.typ          certificate-table, certificates-section
  education.typ             education-entry, language-entry, education-languages-section
  skills.typ                optional skills-section with themed bullets (not in the locked template)
  page.typ                  page-header, page-footer, page-background, document-shell
  pagination.typ            validate-pages, company-fragment
  templates/flagship.typ    the composition: page loop, section order, overflow check
```

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
every frozen input so the comparison stays meaningful. See
`docs/reference/verification.md`.
