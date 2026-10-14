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

## 2026-09-21 — the four stages land

All four stages merged into `main` the same night, each with a passing
review round and the engineer example still pixel-identical to v11:
governance (`b54d9f9`), the move of Flagship and the marine schema under
`domains/marine/` (`195fbab`, tag `archive/pre-domains` marks the tree
before it), the split of the maritime data model out of the core with the
marine domain node and the `deck`/`engine` role markers (`3296e91`), and
the rename to CVgen: repository `github.com/jimzord12/cvgen`, Typst package
`cvgen`, board "CVgen" (`422f150`). The suite stood at 38 cases. The
owner's two private workspaces were repathed and matched their references.

## 2026-09-25 — autonomy and a documentation audit

The owner widened agent authority: routine Git and board work, including
branch and worktree cleanup, no longer needs his approval; a short list of
irreversible operations still does (`docs/preferences.md`). Review rounds
are capped at five when he attends and ten when work runs unattended. Two
auditors checked every document against the code; the findings and their
fixes are in `docs/work/docs-audit/`. Marine PDFs now carry CVgen in their
metadata.

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

## 2026-09-25 — a glossary, a client workflow and the Framework split

In one design session the owner settled the project's words and the path
a real client takes. Official terms now live in `docs/glossary.md`, kept by
the agents themselves and reported to the owner afterwards; a career area
is a `Domain` (the word `Field` was tried and dropped the same day), the
shared core is the `Framework`, a client's folder is their `Envelope`.

The client workflow (`docs/guides/client-workflow.md`, skill `new-client`)
covers the half before `new-cv`: questions sent by chat in Greek through
the owner (Relay intake, no web form), research that reads a shared
`Research Library` first, a text draft the client signs off before design.
It superseded the ceo agent's intake questionnaire proposal.

ADR 0012 then split `packages/cv-engine` into `packages/cv-framework` (the
core, importing no domain) and `packages/domains/marine` (with its own
`lib.typ` carrying every name entry points used before), so a new domain or
a client's one-off `Template` can use the Framework without marine. Paths were
rewritten by a script; the engineer example stayed pixel-identical to v11,
and both private compositions, whose engine paths are updated at the
merge with the owner's consent, render pixel-identical to their approved
references.

## 2026-10-06 — the task store moves into the repository

The owner moved the task store from the Trello board to Backlog.md
(ADR 0014). All 26 task cards became files in `backlog/tasks/`, word for
word, and the session-handoff card became `backlog/docs/`; a parity script
confirmed every title, status, description and acceptance item. Agents now
use the `backlog` CLI through the `backlog` skill, with no credentials or
network, and a task's record merges together with its work. The board was
exported to `docs/work/backlog-migration/` and closed, not deleted. The
cost is the phone board: on a phone the tasks are readable on GitHub, but
with no Kanban view.

## 2026-10-14 — the flat component names are removed

TASK-32 moved the two private marine compositions, the last callers of the
pre-contract flat names, to `core-components` and `flagship-components`,
and each re-rendered page-identical. TASK-58 then deleted `core/legacy.typ`,
`templates/flagship/legacy.typ`, their 32 re-exports in the two `lib.typ`
files and `tests/fixtures/legacy-parity.typ`; the engineer example now
proves the PDF title and author `document-shell` writes. The old-to-new
mapping table stays readable in Git history
(`git show 70631ed:docs/guides/build-a-cv.md`, section 8) for a
composition that still uses the old names.

## 2026-10-14 — the work records leave docs/

TASK-52 moved `docs/work/` to `archive/work-records/` in one `git mv` (owner's
decision, so Git history follows each file; `git log --follow` works). Review
reports now live at `archive/work-records/<task-slug>/reviews/NN-<reviewer>.md`,
the same shape as before. Entries above and in the ADRs, closed proposals and
closed tasks that name `docs/work/...` describe the past; read them with
`archive/work-records/` in place of `docs/work/`.

## 2026-10-14 — the Workflow Model is checked

TASK-38 made the workflow tool check the whole model in `docs/workflow`:
`bun run check` applies 20 rules at levels 1 (shape, references, files,
skills, agents, `cv.py` and `outputs.py` subcommands) and 2 (flow: every
input produced or given, every step reached, cycles only where a declared
loop breaks them), each rule with a broken fixture under
`tools/workflow/test/fixtures/`. CI runs it on both runners and the suite
as its `workflow-model` case. Two `after` steps that nothing reached gained
an input (inferences in `docs/workflow/GAPS.md`). `bun run anchors <commit>`
replaces the TASK-37 script that found drifted source anchors.

## 2026-10-14 — studio/ and apps/: fewer top-level folders

TASK-55 (owner's go, unattended, report after) grouped `brand/`,
`design-concepts/` and the frozen design records (`archive/design-studies/`,
`archive/anti-examples/`) under `studio/` (design work beside the engine);
`archive/work-records/` stays top-level, where TASK-52 put it. It also
moved `scripts/design_review/` to `apps/design-review/`, where ADR 0010's
target tree already keeps `apps/web/`; all by `git mv`, so
`git log --follow` works. The `Output Contract`'s concept home is now
`studio/design-concepts/`, and `tests/baseline.json` pins the same design
study hashes under `studio/archive/design-studies/`. `tools/` stays at the
top level (17 visible entries against the limit of 18, and TASK-38 was
wiring `tools/workflow/` into the suite at the time). `docs/conventions.md`
gained one case per file type (eight README images and the source logo
renamed), and the marine `lib.typ` now exports `roles`,
`flagship-themes`, `flagship-artwork` and `flagship-layouts`, so an example
needs one import. Entries above, ADRs, closed tasks and the work records
that name `brand/`, `design-concepts/`, `archive/design-studies/`,
`archive/anti-examples/` or `scripts/design_review/` describe the past:
read the first four under `studio/` and the last as `apps/design-review/`;
`archive/work-records/` did not move. The Design Review app reads the
owner's earlier `design-concepts/...` review keys under their new paths.

## 2026-10-14 — the workflow READMEs are generated from the model

TASK-39 added `bun run render` to the workflow tool: it writes named blocks
between `<!-- generated:start <name> -->` and `<!-- generated:end <name> -->`
markers in `docs/workflow/README.md` (the stages, the journey diagram, the
handovers between stages, the actors) and in each stage's `README.md` (its
summary, a Mermaid diagram of steps, gates and loops, and tables of steps,
gates, loops with placeholder caps marked, artifacts and actions), and
leaves the text outside the markers to hand-written prose (TASK-40). CI and
the suite's `workflow-model` case run `bun run render --check`, which fails
when a README differs from what the model renders to. Each diagram is
checked against the small Mermaid subset the tool writes.

## 2026-10-14 — The Workflow Model run for real (level 3)

TASK-42 added level 3 to the workflow tool: `bun run reality` walks the
model with a fictional client in a temporary `Envelope` under `builds/`,
every `cmd` step on its path through the real `scripts/cv.py`,
`scripts/outputs.py`, Typst and `python -c` checks, every other step a
labelled stand-in, and fails naming the step when a declared artifact is
missing or invalid. The suite runs it, plus three model copies that must
fail: an output name the script does not write; an export that no
longer waits for the approval (the real `cv.py export` refuses it); and a
re-stamp that leaves its `Meta File` byte for byte unchanged.
`bun run envelope <folder>` walks a real `Envelope` read-only. The runner
lives in `tools/workflow/` beside the model graph it reuses;
`outputs.py stamp` gained `--root`, so the run can stamp an `Envelope`
outside the repository's `private/`. Every command path the model declares matched the
scripts; the three things the YAML does not say are in `docs/workflow/GAPS.md`.

## 2026-10-14 — the workflow READMEs get their prose

TASK-40 wrote the hand-written half of the `Workflow Model`'s READMEs,
outside the generated blocks. `docs/workflow/README.md` (about 250 lines,
the owner's 200-300) says what the journey is for, how to read the folder,
the main branches by gate, who decides what, where the placeholders are,
and which guide sections still hold the detail until TASK-43. Each stage's
README adds its judgement (when to stop, what good looks like), its
branches in words with their IDs, and its common mistakes; the generated
blocks got section headings. One model fix came with it:
`gate.template-exists` passed straight into `design.fill-data`, so the
no-`Template` path read as if `candidate.json` were never written. It now
passes to `design.flagship-fit`, and `design.fill-data` follows the
`Sign-off` on every path.

## 2026-10-14 — the Atlas client journey is generated from the model

TASK-41 added `bun run atlas` to the workflow tool: it writes the `Atlas`
page `.atlas/src/pages/client-journey.json` from the `Workflow Model`, in
the format the existing kit already builds (ADR 0015; the kit was not
ported). The hand-written page (20 steps, 2026-10-04) is gone; the new one
has one phase per stage and one step per model step (104), each citing the
model step's own source anchors, with gates as branches, loops drawn on the
step that goes back, and arrows derived from the data. Writing a changed
page also stamps it, so no one stamps it by hand after a model change,
unless a file it cites changed since its last stamp: then the model's
anchors are checked first and the page is stamped by hand. CI
and the suite's `workflow-model` case run `bun run atlas --check`. What the
old page said and the model does not is listed in `docs/workflow/GAPS.md`;
its "where it stands" panel for one client was out of date and was dropped.

## 2026-10-14 — one description of the client workflow

TASK-43 made the `Workflow Model` the only description of a client's
journey. `docs/guides/client-workflow.md` (373 lines) became a 222-line
reference that describes no step: the `Envelope` tree, the question list,
the `Intake Form`'s clicks, what `CV Decisions` look like and the erase
commands. `docs/guides/build-a-cv.md` became the engine reference for a
client's CV, with what the scripts print and refuse and a map from
`cv.py status`'s states to the `Meta File`'s. The lifecycle half of
`docs/pdf-workflow.md` keeps only the rules the records keep, and its
retention now follows the owner's decision (12 months after `Export`).
The `new-client` and `new-cv` skills are checklists of step IDs with the
commands; what the guides held and the model did not moved into the stage
READMEs' judgement. Every source anchor was repointed to where its fact
now lives, `docs/workflow/inventory/` was removed (in Git history at
6e93bad), and its agent-owned naming drift was fixed.
