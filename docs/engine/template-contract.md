# The Template Contract

Read this before adding a `Template`, a `Template Variation` or a `Domain`, or
changing what a `Domain`'s facts hold. The decision is ADR 0016; P-0019 holds the
reasoning and examples.

## What every Template provides

A `Template` lives under one `Domain`, accepts the inputs in
`docs/architecture.md`, follows the component contract (ADR 0008), fails loudly on
overflow and defines no data model of its own: its input schema, with an `$id`,
refers to its `Domain`'s facts schema by `$ref` and declares only `copy`, with
no `$defs`. The facts schema, also with an `$id`, keeps `copy` an open object, and
the `Template`'s schema closes its keys. It has a `Template Manifest`,
`templates/<t>/template.json`, with at least one `Template Variation` and a
default, and an entry that renders a `Coverage Fixture` (`coverage` in the
manifest). A one-off in an `Envelope` has none of this.

Today two `Template`s have one: Flagship (marine) and Hanami (travel, P-0013),
each with the single `Template Variation` `showcase`. Hanami reads the travel
facts record itself; the travel facts contract carries the record's `copy`, so it
needs no input schema of its own. Hanami `showcase` renders travel versions 1
and 2.

## Domain Contracts

`packages/cv-framework/contracts/base-v1.json` is the `Base Contract`;
`packages/domains/<id>/contracts/v<N>.json` extends it, and a group the `Domain`
names replaces the base's. A `Fact Group` lists the `paths` of the record that
belong to it, with `*` for each item of a list. It is `required` or optional and
has a `schemaVersion`, which rises on a breaking change: a renamed or removed
field, a changed meaning, or a new required field. The contract's `version` rises
on any change. Every past version stays. A path may join a group without a
`schemaVersion` rise (a new optional field). A path that leaves a group without
a rise, or a `schemaVersion` that falls, is a broken contract and is refused. A
new required field or a changed meaning is not visible in the paths, so it rests
on the author raising the `schemaVersion`.

The newest contract may name `oldestSupported`, the oldest version the engine
still reads (none means 1). A record below it stops and asks to be upgraded.
It cannot pass a version an example record uses without the constitution's
step: an ADR, a new `Frozen Reference` and a version bump on the PDF.

A record says which version it follows in `domainContract`; none means 1.

The travel contract (`domains/travel/contracts/v1.json`) makes `rank`
(`identity.rank`, `specialty` and the credential `seal`) and `destinations` (the
region, its trips and areas: a travel CV shows where the person has been)
required, and adds the optional `availability`, `practical` and `references`; it replaces the
base's `profile` with the lead statement and its highlight cells, and keeps
`portrait` optional, as marine does.

Travel is the first `Domain` at version 2 (`contracts/v2.json`, TASK-80), and
the worked example of the rules above:

- `destinations` is required and rises to `schemaVersion` 2. Every trip
  states its `Trip Role` in `role`: `led` (led a group), `organised` (planned
  it, for others or for themselves) or `travelled` (went as a traveller). The
  field is required within the group, a new required field, so the
  `schemaVersion` rises; the path `destinations.trips.*.role` names it.
  Recruiters weigh a led group, and a self-organised trip must never read as
  one. At version 2 the group holds only what every travel CV must show: the
  region, each trip's period, length, kind, role and stops, and the areas known
  (the totals come from them).
- `travel-story` is a new optional group at `schemaVersion` 1 with the telling
  of the trips: the route (`destinations.route`), the region's name in its own
  script and its seal words (`native`, `seal`), each trip's `stamp` and the trip
  `story`. In version 1 these were part of `destinations`; split out, a one-page
  `Template Variation` with no room for them still renders the required group,
  and drops them with a warning.
- `licences` is a new optional group at `schemaVersion` 1: official
  tour-leader or guide licences, each with a `title` and `issuer`, and an
  optional `region` and `until` ("14 Jul 2029"; a day its month lacks is
  refused). A date in `until` is read at render: an expired or soon-expiring
  licence is a `Certificate Warning`.
- Version 1 is kept and `oldestSupported` is not set, so a version 1 record
  renders as before. The facts schema and `data.typ` read both shapes by
  `domainContract`: a version 1 record holding a role or a licence is refused
  and told to set `domainContract` to 2; a record of either version without
  destinations, or a version 2 trip without a role, is refused.

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
"supports": { "travel": { "exactly": [1, 2], "groups": ["destinations@1", "destinations@2", "travel-story@1", "licences@1"] } }
```
Hanami `showcase` declares that line, as `upTo: 2`, beside its other groups: it
renders both shapes of `destinations` (no role on a version 1 trip, a role label
under a version 2 trip's stamp), the route, stamps and story, and a licence in
place of the studies subtitle. A required group may be claimed too, to say
which shapes the Variation renders. At version 1 the route, seal words, stamps
and story belong to the required `destinations`, so a Variation that renders
version 1 must show them, and then claims `travel-story@1` as well. A one-page
Variation with no room for them declares `exactly: [2]` and claims
`destinations@2` without `travel-story@1`; it refuses a version 1 record. A
Variation that stays at version 1 renders no version 2 record (next section).

A `Template Variation` inherits and never copies; it declares only what differs,
and its `designBar` is set when the owner approves the design.

## What is checked

- **In the suite** (`tests/coverage.py`): each claim is rendered on the
  `Domain`'s `Coverage Fixture` of each version it names that the engine still
  reads, a marker in every printed field, none inside another, with one fixture
  for each way a `Domain` records its experience. A missing marker fails; a
  group rendered but not claimed warns.
- **Before a client's render** (`cv_workflow/contracts.py`): a missing required
  group stops the render, as does an `envelope.json` that disagrees with
  `typst/cv.typ`, an unknown `Template Variation`, a version below
  `oldestSupported`, one below the newest version the `Template Variation`
  names that it skips, and any version when the `Template Variation` names no
  version the engine still reads. An optional group the record holds
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
dropped. Each difference gives one of four results: a warning; an error; an
error only when the record holds that group; or an error only when the record
has none of it. A group that differs in two ways takes the stricter result, so a
group it renders whose `schemaVersion` rose is an error whenever the record
holds it, whatever else moved:

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

On travel, a version 2 record on a `Template Variation` up to version 1 is
always refused: `destinations` is required there and changed shape, so a
record with destinations meets `destinations changed (schemaVersion 1 to 2)`
and one without them misses a required group. A Variation that renders
version 2 and does not claim `travel-story@1` or `licences@1` drops those facts
with a warning.

`python scripts/cv.py contracts` (`--json` for the data) prints each `Template
Variation` against its `Domain`s' newest contract: the versions it renders, how
far behind it is, each difference with its result, and the coverage figure
(`3 of 6 optional groups`). The suite keeps the same report and never fails on
"behind".
