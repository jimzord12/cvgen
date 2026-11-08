# The Template Contract

Read this before adding a `Template`, a `Template Variation` or a `Domain`, or
changing what a `Domain`'s facts hold. The decision is ADR 0016; P-0019 holds the
reasoning and examples.

## What every Template provides

A `Template` lives under one `Domain`, accepts the inputs in
`docs/architecture.md`, follows the component contract (ADR 0008), fails loudly on
overflow and defines no data model of its own (Flagship keeps its closed input
schema, with the suite's equal-definitions check, until Stage 2). It has a
`Template Manifest`, `templates/<t>/template.json`, with at least one
`Template Variation` and a default, and an entry that renders a `Coverage
Fixture` (`coverage` in the manifest). A one-off in an `Envelope` has none of
this.

Today two `Template`s have one: Flagship (marine), with the single `Template
Variation` `showcase`, and Hanami (travel, P-0013), with two: `showcase` (two
pages) and `essential` (one page, `scan-first`, TASK-79). Hanami reads the travel
facts record itself; the travel facts contract carries the record's `copy`, so it
needs no input schema of its own.

## Hanami's two Template Variations

`essential` inherits Hanami's themes, type, artwork, words and components and
declares only what differs: its layout (`layouts/essential.typ`, named
`essential`, which `hanami` checks against the manifest's `layouts`), its
composition (`essential.typ`) and its parts (`components/essential.typ`).
`hanami` reads the `variation` and calls the composition; `showcase` is
unchanged. On one A4 page the name block sits in a shallow band, the profile
row under it, then each role's title, employer and dates in a career column with
education at its foot, and availability, languages, destinations, practical
know-how and references on a rail. The gaps between roles widen with spare
height only up to a cap; the rest stays at the column's foot. When the roles do
not fit, education moves to the rail if it has room, the newest roles stay in
full and the older ones become one summary whose count and span come from the
domain (`experience-totals`); when even the newest role does not fit, the compile
fails.

It claims `profile`, `education`, `languages`, `portrait`, `availability`,
`practical` and `references` at version 1. It shows a summary of `destinations`
(the trips, their stops and the domain's totals) but not the stamps, the route or
the trip told in detail, so it does not claim the group: a record that holds it
renders with the warning and lists it under `dropped`. Contract version 2
(TASK-80) is where that changes. Its `designBar` is `scan-first`, and its
`Frozen Reference` is a candidate until the owner approves the design.

## Domain Contracts

`packages/cv-framework/contracts/base-v1.json` is the `Base Contract`;
`packages/domains/<id>/contracts/v<N>.json` extends it, and a group the `Domain`
names replaces the base's. A `Fact Group` lists the `paths` of the record that
belong to it, with `*` for each item of a list. It is `required` or optional and
has a `schemaVersion`, which rises on a breaking change: a renamed or removed
field, a changed meaning, or a new required field. The contract's `version` rises
on any change. Every past version stays.

A record says which version it follows in `domainContract`; none means 1.

The travel contract (`domains/travel/contracts/v1.json`) makes `rank` required
(`identity.rank`, `specialty` and the credential `seal`) and adds the optional
`destinations`, `availability`, `practical` and `references`; it replaces the
base's `profile` with the lead statement and its highlight cells, and keeps
`portrait` optional, as marine does.

## Template Manifests

Each `Template Variation` under `variations` states `pages`, its `designBar`
(`showcase` for the bar in `docs/vision.md`, "Design is the product", or
`scan-first`), the `layouts`, `themes` and `artwork` it allows, and `supports`:
for a `Domain`, either `upTo` or `exactly` the versions it handles, and
`groups`, the optional `Fact Group`s it shows as `name@schemaVersion`.
Required groups follow from the version.
A `Template Variation` inherits and never copies; it declares only what differs,
and its `designBar` is set when the owner approves the design.

## What is checked

- **In the suite** (`tests/coverage.py`): each claim is rendered on the `Domain`'s
  `Coverage Fixture`, a marker in every printed field, with one fixture for each
  way a `Domain` records its experience. A missing marker fails; a
  group rendered but not claimed warns.
- **Before a client's render** (`cv_workflow/contracts.py`): a missing required
  group stops the render, as does an `envelope.json` that disagrees with
  `typst/cv.typ`, an unknown `Template Variation`, or a version it does not
  support. An optional group the record holds
  and the `Template Variation` does not claim gives a warning, and the `Meta File`
  lists it under `dropped`. In `envelope.json`, `template` and `variation` are
  names in quotes: no `template` only warns, and no `variation` means the
  manifest's default. `typst/cv.typ` passes `variation:` as a name in quotes
  or `none`, the default; anything else stops the render, which reads it from
  the text.
- A custom composition is checked against the `Domain Contract` alone, and a
  `Domain` with no contract yet is not checked.

Nothing reads `pages`, `designBar`, `layouts`, `themes` or `artwork` from a
manifest yet: they describe the design for people and reviewers, and `--pages`
still sets a render's page check.

Stage 2 of ADR 0016 is built when a contract first reaches version 2 (TASK-68):
the group-by-group comparison, `oldestSupported`, and dropping the closed input
schema.
