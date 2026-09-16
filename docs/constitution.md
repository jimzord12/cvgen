# Constitution

Rules that do not change without the product owner saying so in writing.
Read before anything irreversible. Conventions, which do evolve, are in
`conventions.md`.

Path references below describe the current implementation. The owner-approved
[ADR 0010](decisions/0010-public-monorepo-and-pdf-workflow.md) establishes the
target monorepo layout and fresh private candidate revision folders. Migration
is pending; frozen content, evidence requirements, and safety checkpoints hold
throughout the move.

## 1. Frozen references are contracts

- Every approved template has a frozen reference render under `reference/`
  and a public example that must render pixel-identical to it at 144 dpi
  with identical normalised text on every page. `tests/run.py` enforces
  this. Today that is Flagship: `reference/Marine-Engineer-CV-v11.pdf` and
  `examples/engineer.typ`.
- `tests/baseline.json` pins the SHA-256 of every asset, font, example JSON,
  design study and the reference PDF, whether or not the engineer comparison
  uses it. Changing any of them is a design decision, recorded as an ADR in `docs/decisions/`, with a
  new frozen reference and a version bump on the PDF name.
- The four numbered studies and `shared.typ` under `designs/` are frozen.
  Copy ideas out of them; do not edit them. Path-only updates during a move
  are not edits.

## 2. New outputs, never overwrites

Every script and test writes into a new timestamped folder under `builds/`
and refuses to run if the folder exists. Review renders in `exports/`,
`reference/` and `designs/review/` are replaced only by a deliberate release
commit with a new version number.

## 3. Public content is fictional

Names, employers, vessels, dates, certificates and the portrait are invented.
Real candidate data lives in `private/`, which git ignores, one folder per
candidate with its own entry point. New entry points import
`../../lib.typ`; two older ones import modules under `src/` directly and
are migrated when next touched. Certificate numbers, scans and passport details
never enter this repository.

## 4. The system does not lie to fit

No automatic font shrinking, no silent reflow. When content does not fit, the
template fails with a message naming the fix: split a company, allocate
another page, shorten a name, adjust a width. A human changes the page plan
and looks at the result.

## 5. Evidence before "done"

A change is finished when `python tests/run.py` passes, the evidence folder
is named, and a visual change has a rendered page someone looked at. "It
should work" is not a state.

## 6. Totals come from data

Service months, vessel counts and company counts are computed once from the
full candidate. Pages never recompute totals from what they display. Calendar
periods are never converted into service time.

## 7. Roles do not leak into components

Deck and engine are variations of every template, expressed through the
candidate JSON, the artwork pack and copy strings. In the tree today deck is
the captain pack and example, engine the engineer pack and example. No
component branches on role. No template is forked by role. A section that must differ between the
two is a slot or a data-selected variant of the same template (ADR 0007).

## 8. Licences travel with their files

Every bundled font keeps its OFL notice in `licenses/`. Adapted code keeps
its original notice. Original artwork is MIT with the project.

## 9. Delivery bar

The team optimises for the smallest commercially sound result: happy path,
common failures, realistic regressions. No speculative abstraction, no
opportunistic cleanup in a feature change. Push back in the conversation when
a request seems wrong; proceed once the owner decides.

## 10. The framework is the happy path, not a cage

The core, the templates and the component contract are the preferred way
to build. They are new and small, and they will not cover everything. When
the work the owner wants cannot be done through them, an agent goes around
them: composes by hand, adds a one-off, extends a component locally. That is
not a failure; it is how the framework learns what it is missing.

Two conditions. First, every bypass is recorded in `docs/framework-gaps.md`
in a few lines: what was needed, what was bypassed, what was built instead,
and what the framework would need.
Second, a bypass goes around components, never around rules: the frozen
references, the fictional-content rule, the no-shrinking rule and the
totals rule still hold. The gaps log feeds the rule of three; a gap that
appears again becomes a component, a slot or an extension. Decided by the
owner on 2026-09-12, ADR 0009.
