# History

How the project got here. Append, never rewrite. Decisions with lasting
consequences also get an ADR in `decisions/`.

## 2026-09-09 — from studies to a library, in one day

**Three one-page studies.** Soundings, Engine Room and Horizon explored three
visual directions on the same fictional data. All three had extractable text,
embedded fonts and text inside the page bounds. They survive in `designs/`.

**Flagship, revisions 04 to 07.** A two-page design with a circular portrait,
contact columns and an identity plate over the portrait's lower edge.
Successive passes added mechanical SVG details, a shared spacing scale and
refined hero artwork. Each pass was checked to be pixel-identical to the
previous one outside the changed region.

**Revision 08.** Experience regrouped as company, vessel type, vessel with
whole-month durations. Summary metrics derived from data. Education and
languages replaced the toolkit. Component extraction paused until the design
settled.

**Revision 09.** A longer fictional career, 23 vessels across six companies,
ending mid page two. A global `vessel-durations` input to hide all durations
at once.

**Revision 10.** The synopsis moved to the end of experience, before
certificates. PDF naming became `Marine-Engineer-CV-vNN.pdf`.

**Revision 11, locked.** Education anchored lower with flexible space above,
an 11 mm bottom margin on page two. The owner approved v11 as the frozen
reference. Source `designs/11-flagship-balance.typ`, render
`reference/Marine-Engineer-CV-v11.pdf`.

**The library.** Built task by task against v11, each task reviewed and
committed before the next:

| Task | Outcome |
|---|---|
| Baseline | Fresh compile equals v11 at 144 dpi and normalised text. A deliberate red-text change is rejected. Hash manifest of frozen inputs. |
| Configuration | Theme, artwork slots and geometry separated. |
| Data | Normalisation, validation and pure totals. Repeated vessels deduplicate; company-only months accepted when durations are hidden. |
| Hero | Exact match of the hero region. Fit assertions for name, rank and contacts. SVG recolouring via `image(bytes(...))`. |
| Content | Experience, synopsis, certificates, education composed from small modules. Hidden durations keep geometry. |
| Composition | Public `flagship` template renders v11 with zero raster differences. A scoped page-margin rule that caused an extra page was moved to the page loop. |
| Captain | Same components, new artwork pack, wheel and chart backgrounds. No engineer wording leaks. |
| Silver | A second theme changes only the theme import. Legacy SVG colours mapped through `art-colors`. |
| Boundary review | 21 compile cases: overflow, duplicate allocation, three-page split with continued company, certificate header repeat, optional fields, wrapped durations. |
| Delivery | Build script, Greek guides, versioned PDFs, main entry matches v11. |

Then the original blue and gold theme was named Golden Blue and an optional
skills section with themed bullets was extracted.

## 2026-09-12 — restructure for agents

Historical revisions 04 to 10, their renders and per-revision verification
records were removed (tag `archive/pre-restructure`). The four distinct
studies stayed as worked examples. `roles/` became `artwork/`, the duplicate
theme file was folded into `golden-blue.typ`, fixtures moved under
`tests/fixtures/`, the frozen PDF under `reference/`. The legacy flat-schema
adapter was removed with its data. Greek guides were replaced by an English
documentation set: vision, architecture, tech stack, constitution,
conventions, git workflow, per-concept references, ADRs, a JSON Schema,
project skills and CI. The engineer example still matches v11 exactly.

## 2026-09-12 — product direction set

The owner considered replacing Typst with React or headless Chromium for
finer control and a component model he can read. A research pass against
the library's requirements found neither option could keep the pixel gate,
the tagged PDF artifacts and measured rows without trade-offs Typst does not
have. Typst stays (ADR 0006).

The owner stated the product: several named templates, each rendering deck
and engine candidates, each with two to four themes, plus a one-page layout
for cadets. The restructure docs had inferred "one template" as a principle
and were corrected (ADR 0007). The two real CVs produced so far both bypass
the template: the deck CV because contract periods are not in the schema,
the engineer CV because its approved design uses a three-column certificate
table. Closing that gap became roadmap item one.

A React-inspired component contract was accepted, ctx-first, with slots and
scoped style blocks (ADR 0008). Migrating the Flagship modules to it was
planned as the next code task; it landed on 2026-09-25 (below).

The owner added a standing rule: the framework is the happy path, not a
cage. Agents may go around components to deliver, must log each bypass in
`docs/framework-gaps.md`, and never go around the frozen-reference,
fictional-content, no-shrinking or totals rules (ADR 0009, constitution
section 10). The log opened with the three bypasses found in the real CVs.
`docs/preferences.md` was added to tell every agent how the owner wants to
be briefed.

## 2026-09-15 — monorepo and PDF workflow approved

The owner approved the public monorepo and candidate PDF lifecycle in ADR 0010.
The detailed document moved from proposals to `docs/pdf-workflow.md` and is
marked approved with implementation pending. Templates own their presentation
and input contracts; candidate facts retain a common contract. The CV engine
renders documents, while a separate workflow manages private revisions,
hash-based owner approval, export, and eventual web delivery.

The existing folder tree and runtime remain unchanged. Earlier historical
statements about the next code task are not the current sequencing: the owner
has opened discussion of a common development protocol for Codex and Claude
Code, followed by migration planning. No new development protocol has been
adopted in this documentation update.

## 2026-09-16 — agent-managed Git without pull requests

The owner assigned routine Git decisions to the working agent, except when the
owner explicitly takes Git management over for a session. Mandatory PRs and
per-merge owner approval were replaced with direct pushes for small verified
changes and branches for substantial work. Existing destructive-operation
checkpoints and product/design approvals remain. Longer feature branches are
available where useful; short topic branches and limited child branching are
the recommended default. The broader development protocol remains pending.

## 2026-09-16 — development protocol, Trello board, engine migration

Three things landed the same day. The approved development and review
protocols became `docs/development.md` and `docs/review.md`, with a
fresh-context `code-reviewer` subagent that follows them; its first job was
its own validation. A two-card Trello Free trial passed every check, the
owner adopted the board "Marine CV" as the task store, and the `trello`
skill became the integration (six review rounds, five of them closing
credential-handling paths in PowerShell diagnostics). Then the engine moved
into `packages/cv-engine/` per ADR 0010: shared core under `core/`, Flagship
with its components, presentation inputs, schema, adapter and frozen
reference under `templates/flagship/`, fictional records and entry points
under `examples/`, the design studies under `archive/`. The candidate-facts
contract was separated from the Flagship input contract; Flagship's wording
defaults moved from the core into the adapter. Every frozen hash carried
over; the engineer example stayed pixel-identical. A third fictional
dataset, a Chief Officer without a portrait, joined the gallery. The
pre-migration tree is tagged `archive/pre-monorepo`.

## 2026-09-16 — local PDF revision, approval and export workflow

The workflow half of ADR 0010 landed as a small Python package,
`packages/cv-workflow`, behind `scripts/cv.py`. A render snapshots the
candidate's entry point, record and portrait into a fresh
`revisions/<id>/` folder that compiles on its own, keeps the compiler log,
records the engine commit, compiler version, imports and PDF hash, and
runs the page checks against that hash. Approval is a separate explicit
command that needs the reviewed hash and an approver and writes a receipt
bound to the revision and its bytes; export verifies render, checks and
receipt, copies the bytes into `exports/<id>/` through a partial folder,
verifies the copy and never compiles. The suite drives the whole lifecycle
and every refusal through the real commands on a fictional workspace; the
workflow's own render of the fictional engineer equals the frozen v11
reference pixel for pixel. Entry points now import the engine by
root-absolute path. No web app, database or job service was built.

## 2026-09-21 — a CV library for any field

The owner widened the product from maritime CVs to CVs for any field,
organised as domain, role and template: a domain offers a facts shape,
assets, wording and rules; a role is one level of specialisation; a
template may override anything and may serve a whole domain. Marine is the
first domain, travel and tourism the next. ADR 0011 records the decision,
amends 0002, 0007 and 0010; the constitution's totals rule was generalised
unchanged and its roles rule now admits a role-level template with a
recorded reason, both approved by the owner. The work was planned in four
stages under the pixel gate: governance, the mechanical move of Flagship
under `domains/marine/`, the split of the maritime data model out of the
shared core, and the rename to CVgen.

## 2026-09-25 — the component contract applied

The owner opened roadmap item 4 and the ADR 0008 migration ran overnight on
`refactor/component-contract`: one module per commit in the ADR's order
(core primitives, sections, skills, education, certificates, experience,
hero, core page shell, the template), the engineer example pixel-identical
to the frozen v11 reference after every commit and both private candidate
workspaces pixel-identical to their approved `reference.pdf`. All 32
components now take `ctx` first; the template builds it once. Four details
differ from the ADR's text, recorded here because the contract itself did
not change:

- `ctx` also carries `artwork`, the sixth independent input, because the
  hero, the profile summary and the page background place pictures.
- `core/component.typ` holds only `make-ctx`; no component needed
  `require`, `slot` or `children`, so they were not added.
- `lib.typ` exports the ctx-first components as two modules,
  `core-components` and `flagship-components`, and keeps exporting the old
  flat names with the old signatures as thin wrappers (`core/legacy.typ`,
  `templates/flagship/legacy.typ`), because the private custom compositions
  import them and are never edited without the owner.
  `tests/fixtures/legacy-parity.typ` calls all 32 wrappers and requires the
  same pixels as the ctx-first components; `docs/framework-gaps.md` tracks
  the wrappers' removal.
- The style-block clause (each component's `set`/`show` rules grouped at
  the top of its block) is not applied yet: most components still style
  inline, as before. Recorded in `docs/framework-gaps.md`.

Fixtures: `tests/fixtures/contract.typ` renders 31 components alone, one
per page; `document-shell` wraps a whole document and is covered by the
parity fixture and the examples.
