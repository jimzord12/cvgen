---
id: P-0019
kind: proposal
status: pending
revision: 1
created: 2026-11-04
---

# Template Contract: Templates, Variations and Domains that declare what they support

Origin: a client showed their designed CV to people in their field. Everyone
found it beautiful, and most said it was not practical: for jobs that are not
highly paid they want one clear page, without skill ratings and without images
all over it. The owner and Claude Code worked the shape out in session on
2026-11-03 and 2026-11-04. Supporting document, in this proposal's scope:
[CV format for junior and non-senior roles](../research/junior-roles-cv-format.md)
(`research-reviewer` PASS, round 3).

**Pitch:** make a `Template` a described design language with named
`Template Variation`s, and give `Domain`s and `Template`s a versioned contract
that says what each supports. A `Client` can then choose a scan-first, one-page
version of a design, and most `Domain` changes need nothing from a `Template`'s
author.

## Problem

- **A kind of CV is not a concept in the engine.** A CV is built from
  `Domain`, `Role`, `Template`, `Theme`, `Artwork Pack` and `Layout`. A
  one-page `Layout` exists (P-0012), but it only moves content. `Density` and
  `Design Tier` exist only in concept runs and are lost once a design is built.
- **No machine-readable field records a `Client`'s design.** The choice is a
  `CV Decisions` entry, a step's record and whatever `typst/cv.typ` imports;
  `envelope.json` does not hold it, so nothing can check it.
- **`Domain` and `Template` are tied by their schemas, field by field.** Two
  marine schemas state the facts. Flagship's is closed, so it refuses any field
  it does not know, and the suite requires the definitions in both to be equal.
  Nothing says what a `Template` can show or what a `Domain` requires of it, and
  a `Domain` change can fail the suite for a `Template` its author never touched.
- **Facts can go missing unnoticed.** Nothing tells the owner that a `Client`
  has facts the chosen design does not show.
- **One design bar for every CV.** `docs/vision.md` treats a quiet design as a
  failure, so the `design-reviewer` would reject a deliberately calm CV. The
  research points the other way for this audience: one full page, a strict
  hierarchy, the first-scan fields easy to find, and a personal touch that
  stays out of the reading path.

## Who it helps

- **`Client`s applying for ordinary jobs:** one practical page in a real design.
- **Whoever maintains a `Domain` and whoever makes a `Template`:** each usually
  works without waiting for the other.
- **The owner:** a clear choice per `Client`, and a warning before a claimed
  design drops a `Client`'s facts.

## Smallest suggested change

### 1. Vocabulary

The new terms are in `docs/glossary.md`, marked pending: `Template Variation`,
`Template Contract`, `Template Manifest`, `Domain Contract`, `Base Contract`,
`Fact Group`, `Coverage Fixture` and `Scan Test`.

On approval, `Template` changes to: a design language (its components, palette,
art and voice), which lives under one `Domain`, with a `Template Manifest` and
at least one `Template Variation`. A one-off in an `Envelope` stays a `Template`
without either. `Frozen Reference` changes to one per `Template Variation`.

The term is always the two words `Template Variation`. Plain "variation" keeps
its existing meanings (a `Role`, a `Design Tier`), so the constitution's wording
does not change for this. The Meta File's `variant` is a `Revision` id and is
unrelated.

### 2. The Template Contract

Every `Template` that is not a one-off:

- accepts the inputs Flagship takes today (facts, `Role`, `Theme`,
  `Artwork Pack`, `Layout`, the display switch, `copy`) plus a
  `Template Variation`;
- follows the component contract (ADR 0008), renders through the `Framework`'s
  page shell and fails loudly on overflow;
- defines no data model of its own, keeping its adapter and a schema for only
  what it adds, today `copy`;
- has a `Template Manifest` with at least one `Template Variation`, one of them
  the default (`showcase` for Flagship);
- has one `Frozen Reference` per `Template Variation`;
- proves its claims in the suite (section 7).

### 3. Template Variations

A `Template Variation` inherits from its `Template` and never copies it. It
declares only what differs:

- which `Layout`s, `Theme`s and `Artwork Pack`s it allows, and its defaults. The
  list sits in the `Template`, the one place that already sees every input, so
  these inputs still do not know about each other, and a `Role` still picks its
  `Artwork Pack`;
- `copy`;
- component overrides through named slots.

Each has a design bar, a field in the manifest set when the owner approves its
design; the reviewers read it. Today's Flagship becomes `showcase`, with the bar
in `docs/vision.md` as it stands. It must stay pixel-identical to its `Frozen
Reference` and lists both Flagship `Layout`s, so the one-page cadet CV stays
under it.

No threshold separates a `Template Variation` from a new `Template`; the
reviewer judges. If Essential shares little with Flagship beyond its palette, it
becomes a new `Template` and the contract is unchanged.

`Template Variation` does not replace `Density` or `Design Tier`: those stay
the shape of a concept run.

### 4. Domain Contracts

The `Base Contract` belongs to the `Framework`; each `Domain` extends it, and a
change to it raises every `Domain`'s version.

- **Required in the base (owner, 2026-11-04):** `identity`, `contacts` and
  `experience`, whose shape each `Domain` supplies. **Optional in the base:**
  `profile`, `education`, `languages`, `certificates`.
- A `Domain` adds its own required and optional `Fact Group`s.
- A `Fact Group` is a group of facts, not a single field. A `Template` supports
  it whole, so anything a `Template Variation` may leave out is its own optional
  group. A group points at parts of the record and need not be a key of it: a
  portrait group points at `identity.portrait`, and the record stays as it is.
- A group's `schemaVersion` rises only on a breaking change: a renamed or removed
  field, a changed meaning, or a new required field.
- The `Domain Contract`'s `version` rises on any change to it, a new optional
  field included.
- Every past version is kept. The `Domain Contract` stays closed, so a misspelt
  group or field is refused.

Illustrative shape; marine's real groups are settled when this is applied:

```json
{
  "domain": "marine",
  "version": 1,
  "extends": "base@1",
  "groups": {
    "experience":         { "required": true,  "schemaVersion": 1, "schema": "#/$defs/company" },
    "vessel-particulars": { "required": false, "schemaVersion": 1, "schema": "#/$defs/tonnage" }
  }
}
```

The `Domain Contract` becomes the one statement of a `Domain`'s facts. The
closed `Template` input schema and the suite's equal-definitions check give way
to it.

Every record says which version it follows, in a `domainContract` field in
`candidate.json`. A record without one follows version 1, so the frozen example
records need no edit. A new `Client`'s record takes the latest version its
`Template Variation` can render, set when the choice is written (section 8).

### 5. Template Manifests

Each `Template` has a `template.json`: id, name, version, suggested `Domain`s,
tags, and its `Template Variation`s. Support is declared per `Template
Variation`, because a scan-first one deliberately shows less. A `Template` names
the `Domain Contract` versions it supports, either up to one or exactly some,
and the optional `Fact Group`s it renders, at which `schemaVersion`. The required
groups follow from the versions it names.

```json
{
  "id": "flagship",
  "variations": {
    "essential": {
      "pages": "1",
      "designBar": "scan-first",
      "supports": {
        "marine": { "upTo": 1, "groups": ["education@1", "languages@1", "certificates@1"] }
      }
    }
  }
}
```

A `Template` is never required to name a `Domain`'s latest version.

### 6. Compatibility (Stage 2)

A version is **supported** when the `Template Variation` names it. A record on a
supported version renders normally. For a record on a newer version, a script
compares the two contracts group by group, so nobody labels a structural change
by hand: it refuses a contract whose structure broke without a `schemaVersion`
rise. Only a changed meaning rests on the author raising it. Below, "changed"
means its `schemaVersion` rose:

| Difference from the `Template Variation`'s last supported version | Result |
|---|---|
| Nothing it uses | Warning: it renders |
| A new optional group, or a new optional field in any group | Warning: it renders, and the new facts count as dropped |
| An optional group it claims changed or was removed | Warning if the record does not hold that group; otherwise error |
| A required group became optional | Warning if the record still holds that group; otherwise error |
| An optional group became required | Warning: it renders if it claims that group; otherwise error |
| A required group is new, changed or removed | Error |

A group the `Template Variation` renders whose `schemaVersion` rose is an error
whenever the record holds it, whatever else moved.

The output gives a coverage figure for any later UI, such as "3 of 6 optional
groups". Every error names the fix: update the `Template`, keep the record on a
version it renders, or pick another `Template Variation`. So a behind `Template`
stays usable for new `Client`s on a version it can render. A record on an older
version than the `Template Variation` supports stops the same way.

**The limit.** There is one live engine: every render uses today's code, and
Flagship calls the `Domain`'s code directly. So a kept version works only while
that code still reads it. `oldestSupported` in the `Domain Contract` names the
oldest version it reads, and a record below it stops and asks to be upgraded. A
breaking change costs its author a choice: keep reading the old shape, or raise
`oldestSupported`.

`oldestSupported` cannot pass a version the frozen records use without the
constitution's step: an ADR, a new `Frozen Reference` and a version bump on the
PDF. Past `Revision`s are untouched, since each holds its own inputs and PDF.

### 7. Proof in the suite

Every `Domain` provides a `Coverage Fixture`: a marker in every printed field of
every `Fact Group`, for each version still read. It is fictional, lives in the
public repository, and tests coverage, not capacity. Whether a full career fits
stays with the `Frozen Reference`s and the overflow check.

For each `Template Variation` and each version it supports, `python tests/run.py`
renders the fixture, reads the PDF's text with the `pymupdf` the suite already
uses, and looks for the markers; an image field is proved by the image being in
the PDF. Evidence goes to the test run's own folder, with
the coverage figure.

| Situation | Result |
|---|---|
| A marker of a claimed or required group is missing | The suite fails: it is the `Template`'s own bug |
| A group is rendered but not claimed | Warning: update the manifest |
| The `Domain` has moved past the `Template Variation`'s versions | Reported as "behind", never a failure, and saying when the gap is an error under section 6 |

A `Domain` change that keeps reading older records therefore does not turn the
suite red because of someone else's `Template`. One that drops a version a frozen
record uses does, by design (section 6).

### 8. Checks before a `Client`'s render

A new step before `design.entry-point` offers the `Template Variation`s the
`Domain` has, and `design.entry-point` writes `template` and `variation` into
`envelope.json` and the version into `candidate.json`. Render stops if
`typst/cv.typ` disagrees with them. When `typst/cv.typ` renders a `Template`, the
checks below always run: a missing field gives a warning, and a
missing `variation` means the default.

| Check | Result |
|---|---|
| The record lacks a required group | Error: the render stops and names it |
| The record holds an optional group the `Template Variation` does not claim | Warning in the CLI; a confirmation dialog in any future UI |
| The record's version is not supported | Section 6 |

The `Revision`'s `Meta File` records the `Template`, the `Template Variation`, the
`Domain Contract` version and anything dropped. An empty optional group needs no message.

A new custom composition, built from the `Domain`'s components, gets the latest
version from `design.custom-composition`. It is checked against the `Domain
Contract` with no `Template` checks, and a `Framework Gap` still records it. A one-off `Template` imports only
the `Framework` and is checked as today. `contacts` becoming required is checked
against every existing record when this is applied.

### 9. First use: Flagship · Essential

Essential (agents' name, 2026-11-04) is the first new `Template Variation`: one
full page for the marine `Domain`, on its own one-page `Layout`, built from the
research note:

- the first-scan fields (name; each job's title, employer and dates; education)
  in fixed, prominent places, and role-critical facts near them;
- real text in a logical reading order, with no text in images;
- no self-rated skill bars, dots or percentages;
- no body type below about 9 to 10 pt, with no shrinking (constitution
  section 4);
- the personal touch in the name block, one accent colour along the reading
  path, and at most one small motif from the `Domain`'s own art.

How far this evidence goes:

- The note's base is weak: almost all figures come from companies selling CV
  services, and nothing separates hourly work from entry-level.
- The note covers neither marine nor crewing practice, so Essential's design
  starts by checking what crewing offices expect, the portrait above all. The
  note's "no photo by default" is for UK, US and international applications, and
  it leaves Greece undecided.
- The light-touch elements are inference: no study tests them directly.

## Out of scope

- A second `Template`, or a `Template` serving several `Domain`s; the contract
  allows both, and neither is built here.
- Porting one-off `Template`s; TASK-2 decides how Hanami Line 2 becomes the
  travel `Template`.
- Essential for travel, which needs a travel `Template` first.
- Any UI, ratings or sales.

## Consequence

- **Rules and vision, needing the owner (Decisions 1 to 3).** `docs/vision.md`:
  the "Approved next architecture" line on `Template` schemas, the design tests,
  "safe professional", "What it is not", principle 3 and Direction.
  `docs/constitution.md` section 1.
- **Decisions and engine docs.** A new ADR amending ADR 0007, 0010, 0011 and
  0012; `docs/architecture.md`, `docs/engine/verification.md`,
  `docs/engine/candidate-schema.md`, `docs/engine/domains-and-roles.md`,
  `docs/conventions.md`, `docs/pdf-workflow.md`, `docs/glossary.md`,
  `docs/review.md`'s design bar and lenses, and the `AGENTS.md` lines on the
  tests.
- **Workflow and agents.** The `Workflow Model`'s design stage and catalogue,
  `docs/guides/`, the Atlas, and `new-cv`, `new-theme`, `idea-run`,
  `magazine-editor`, `design-reviewer` and `codex-visual-reviewer`, with their
  `.codex/` counterparts.
- **Engine.** Flagship is restructured onto the contract with no visible change:
  its `Frozen Reference` is the proof. New contract files, the marine
  `Coverage Fixture`, and changes in `cv_workflow/` (`render.py`, `validate.py`,
  `output.schema.json`), `scripts/outputs.py`, both marine schemas and
  `tests/run.py`.
- **Size.** Large: about six tasks. Stage 1, with every `Domain Contract` at
  version 1: the ADR and vocabulary; contracts and fixture; manifest and Flagship
  restructure; suite and render checks; workflow and record fields; Essential's
  design, the only step that shows the owner something new. Stage 2: section 6.
- **Risk.** The constitution rules out speculative abstraction (section 9), and
  this contract would be designed with one `Template` and one `Domain` to test
  it. The owner chose to invest in this design (in session, 2026-11-03). Travel
  is the second `Domain`, and its first task should be allowed to revise the
  contract.

## Recommendation

Approve revision 1, recording the whole design in the ADR and building it in
two stages. Stage 1 is useful at once: a `Client` can choose Essential, and a
render warns before dropping a group. Stage 2 has nothing to compare until a
`Domain Contract` first moves to version 2, so that change triggers it. A calm
`Template` alone would cost less, but would leave the choice unrecorded and the
`Domain` coupling as it is. The vision conflict needs answering in any case: it
is Decision 2, not a result of the contract.

## Decision requested

Approve, defer or reject revision 1, and answer:

1. **The design bar for Essential.** Today `Flagship Parity` asks for a portrait
   and a ship in the page, which Essential may not have, the `Three-Second Test`
   asks the page to shout, and the `Batch Test` says it cannot be skipped.
   Recommended, for a `Template Variation` with the `scan-first` bar: a `Scan
   Test` replaces the `Three-Second Test`, so a reader finds the first-scan
   fields in seconds; `Flagship Parity` means equal in craft; the `Batch Test`
   means it stands out in a stack through craft and order, not volume. The
   alternative is to keep the `Three-Second Test` in a quieter form, with the
   `Domain` still readable at a glance.
2. **The vision wording.** Recommended: "Design is the product" stays, and the
   lines "safe professional is a defect" and "a design that is well crafted but
   quiet fails" gain "except under a `scan-first` bar, which is its own"; "Not a
   tasteful, invisible template" stays for the rest; "Two pages by default" gives
   way to each `Template Variation`'s page count; "templates own their input
   schemas" narrows to what a `Template` adds; Direction gains this work as an
   item. "Never brief or judge a design by banning its domain's imagery" stands:
   Essential uses that imagery, small.
3. **The constitution.** Section 1 moves from one `Frozen Reference` per
   `Template` to one per `Template Variation`. Recommended: approve.
4. **Where it starts.** Recommended: Flagship on marine, since a `Template`
   exists there, and open TASK-3 first, so its deck facts enter the contract as
   version 1 and Flagship is restructured once. The feedback came from a travel
   `Client`, who would not benefit until TASK-2 is built. The alternative is to
   open TASK-2 first, which needs [P-0013](travel-domain.md), deferred, reopened
   and revised onto these contracts.

## Decisions
