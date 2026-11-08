# The Template Contract

Read this before adding a `Template`, a `Template Variation` or a `Domain`, or
changing what a `Domain`'s facts hold. The decision is ADR 0016; P-0019 holds the
reasoning and examples.

## What every Template provides

A `Template` lives under one `Domain`, accepts the inputs in
`docs/architecture.md`, follows the component contract (ADR 0008), fails loudly on
overflow and defines no data model of its own: its input schema refers to its
`Domain`'s facts schema by `$ref` and adds only what it renders beyond the facts,
today `copy`. It has a `Template Manifest`,
`templates/<t>/template.json`, with at least one `Template Variation` and a
default, and an entry that renders a `Coverage Fixture` (`coverage` in the
manifest). A one-off in an `Envelope` has none of this.

## Domain Contracts

`packages/cv-framework/contracts/base-v1.json` is the `Base Contract`;
`packages/domains/<id>/contracts/v<N>.json` extends it, and a group the `Domain`
names replaces the base's. A `Fact Group` lists the `paths` of the record that
belong to it, with `*` for each item of a list. It is `required` or optional and
has a `schemaVersion`, which rises on a breaking change: a renamed or removed
field, a changed meaning, or a new required field. The contract's `version` rises
on any change. Every past version stays. A path may join a group without a
`schemaVersion` rise (a new optional field); a path leaving it, or a
`schemaVersion` falling, without a rise is a broken contract and is refused. A
new required field or a changed meaning is not visible in the paths, so it rests
on the author raising the `schemaVersion`.

The newest contract may name `oldestSupported`, the oldest version the engine
still reads (none means 1). A record below it stops and asks to be upgraded.
It cannot pass a version an example record uses without the constitution's
step: an ADR, a new `Frozen Reference` and a version bump on the PDF.

A record says which version it follows in `domainContract`; none means 1.

## Template Manifests

Each `Template Variation` under `variations` states `pages`, its `designBar`
(`showcase` for the bar in `docs/vision.md`, "Design is the product", or
`scan-first`), the `layouts`, `themes` and `artwork` it allows, and `supports`:
for a `Domain`, either `upTo` N (versions 1 to N) or `exactly` a rising list of
the versions it handles, and `groups`, the optional `Fact Group`s it shows as
`name@schemaVersion`. A group it renders in two shapes is claimed twice
(`places@1`, `places@2`), and the suite proves each claim on a version it
names. Required groups follow from the version. A `Template Variation` is never
required to name the newest version.

```json
"supports": { "travel": { "exactly": [1, 2], "groups": ["destinations@1", "destinations@2", "licences@1"] } }
```
A `Template Variation` inherits and never copies; it declares only what differs,
and its `designBar` is set when the owner approves the design.

## What is checked

- **In the suite** (`tests/coverage.py`): each claim is rendered on the `Domain`'s
  `Coverage Fixture` of each version it names that the engine still reads, a marker in every printed field, with one fixture for each
  way a `Domain` records its experience. A missing marker fails; a
  group rendered but not claimed warns.
- **Before a client's render** (`cv_workflow/contracts.py`): a missing required
  group stops the render, as does an `envelope.json` that disagrees with
  `typst/cv.typ`, an unknown `Template Variation`, a version below
  `oldestSupported`, or one below the newest version the `Template Variation`
  names that it skips. An optional group the record holds
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

## A record on a newer version (Stage 2)

When the record's version is newer than every version the `Template
Variation` names, its contract is compared group by group with the newest one
it names (`compare` in `contracts.py`); a version below that which an `exactly`
list skips is refused, since it was left out on purpose. A group required at
that last version is shown even after it turns optional, so it is never
dropped. Each difference is a warning, or an error always, when the record
holds that group, or when it has none of it:

| Difference | Result |
|---|---|
| A group it does not render changed, or was removed | Warning |
| A new optional group; a new optional field in any group | Warning; the facts count as `dropped` |
| An optional group it claims changed or was removed | Error when the record holds it |
| A required group became optional | Error when the record has none of it |
| An optional group became required | Warning if it claims it; else error |
| A required group is new, changed or removed | Error |

A warning names how many versions behind the `Template Variation` is. An error
lists every difference that stops it and the fix: update the `Template`, keep
the record on a version it renders, or pick another `Template Variation`. A new
field shown nowhere goes into the `Meta File`'s `dropped` as `group: path`.

`python scripts/cv.py contracts` (`--json` for the data) prints each `Template
Variation` against its `Domain`s' newest contract: the versions it renders, how
far behind it is, each difference with its result, and the coverage figure
(`3 of 6 optional groups`). The suite keeps the same report and never fails on
"behind".
