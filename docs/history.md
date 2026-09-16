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
scoped style blocks (ADR 0008). Migration of the Flagship modules to it is
the next code task.

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
