# AGENTS.md — map of CVgen

CVgen is a composable Typst library that renders premium CVs for any field
(ADR 0011, 2026-09-21). The engine is a field-neutral core plus domains;
`marine` is the first, with one template, `flagship`, that takes six
independent inputs: candidate JSON, role, theme, artwork pack, layout
profile and a durations switch. A domain offers a facts shape, assets,
wording and rules; a role is one level of specialisation; a template may
override anything (`docs/vision.md`, `docs/reference/domains-and-roles.md`). Read this file and `docs/preferences.md`, then
open only what your task needs.

If `.local/preferences/user-profile.md` exists, read it alongside
`docs/preferences.md` before replying. It contains local user preferences;
keep it untracked and do not copy its contents into shared documentation.

## Agent responsibilities and orientation

- Claude Code is the primary implementation harness. It owns coding, test
  execution, implementation review, and integration work. Implementation
  follows `docs/development.md` (stages, task records, guardrails) and
  `docs/review.md` (the independent `code-reviewer` gate).
- Codex is optional for discussion, research, proposals, design decisions, and
  their documentation. Reading code for design context is allowed; it does not
  take over implementation or provide the implementation test/review verdict.
- On a fresh or resumed session, read the `session-handoff` card first (list
  Handoff on the Trello board "CVgen", through the trello skill), then
  derive a brief Goal / Now / Next / You report from the vision, relevant
  decisions/proposals, the task cards (the authoritative task records), Git
  state, and evidence for the examined revision. If the board cannot be
  read, say so rather than inferring state from an export. Distinguish an
  approved design from implemented behavior, and historical checks from
  current proof. Before stopping, rewrite the handoff card
  (`docs/development.md`, "Ending a session"). Do not use `docs/now.md`; it
  is a retired historical snapshot.
- State reporting is read-only and repeatable: unchanged inputs yield the same
  factual state. No dedicated reporting command exists yet; inspect the sources
  directly. Do not maintain a second status file or backlog. In proposals and
  protocols, prefer derived views over manually synchronized summaries.
- Use `docs/proposals/README.md` for proposal states and decision handling. At
  orientation, inspect proposal metadata and surface pending owner decisions
  with a brief recommendation and link; distinguish approved work still awaiting
  application. Check applicable decisions before acting. The tracking convention
  is active; a tracked proposal is not thereby approved.
- This development system is experimental. Notice concrete friction, missing
  guidance, and useful improvements as work proceeds. Record a brief observation
  in the active work record (or current design proposal), with its consequence
  and a suggested next step. Check for duplicates; do not manufacture findings
  or silently change active rules. Track decision-ready changes using
  `docs/proposals/README.md`. Broader process/package ideas remain deferred in
  `docs/proposals/process-evolution.md`.
- Keep process work proportional: enough to support the next CV task. Package
  extraction and tooling are optional future work, not prerequisites for delivery.
- The working agent owns routine Git management by default: choose when to
  commit, push, branch, and integrate authorized work. This includes Codex's own
  design/documentation work without taking over Claude's implementation role.
  Only an explicit session instruction that the owner will handle Git suspends
  this responsibility. Follow `docs/git-workflow.md`: no PRs for now; small,
  verified changes may go directly to `main`, and substantial work uses branches.

## Where things are

Layout per ADR 0010 (`docs/pdf-workflow.md`) and ADR 0011 (domains). `E` below stands for
`packages/cv-engine`, the engine package; `M` for `E/domains/marine`, the marine
domain; `F` for `M/templates/flagship`.

| Path | Role | Touch it when |
|---|---|---|
| `E/lib.typ` | Public import surface, no side effects | Adding or renaming an exported function |
| `E/core/` | Field-neutral core: `node` (merge, compose), `data` (common facts), `theme` check, `component` (`make-ctx`, which builds `ctx`), `components` (the ctx-first primitives and page shell as one module, exported as `core-components`), `primitives`, `page` shell, `pagination` over a domain row model, `legacy` (deprecated old signatures). Never imports a domain | Changing behaviour every domain shares |
| `M/domain.typ`, `M/data.typ` | The marine domain node (id, meta, copy, experience model) and the marine facts: companies, vessels, months, totals, `normalize-candidate`, `validate-candidate` | Changing what the marine field means |
| `M/roles/deck/`, `M/roles/engine/` | Role markers (`role.typ`); bare today | Refining something for one role |
| `M/schema/candidate.schema.json` | Marine candidate-facts contract: what a record may contain, no template wording | Changing the marine data contract |
| `F/flagship.typ` | The Flagship composition: page loop, section order, overflow check | Changing what Flagship renders |
| `F/adapter/` | Candidate facts -> Flagship input: adds Flagship wording (`copy`) and merges overrides | Changing Flagship's input shape |
| `F/schema/flagship-input.schema.json` | Flagship input contract: facts plus `copy` | Same |
| `F/components/`, `F/components.typ`, `F/legacy.typ` | Flagship sections, ctx-first: hero, experience, sections, certificates, education, skills; `components.typ` gathers them into the one module `lib.typ` exports as `flagship-components`; `legacy.typ` keeps their old signatures for `lib.typ` (deprecated) | Changing how a section renders |
| `F/themes/` | Visual tokens only: colours, fonts, sizes, tracking, leading, SVG colour map | Adding a look |
| `F/artwork/`, `M/assets/` | Artwork packs (which SVG in which slot, offsets) and the SVG files | Adding a role's illustrations |
| `F/layouts/` | Geometry and page plan: margins, gaps, widths, which companies go on which page | Fixing page balance |
| `F/tests/approved/` | Frozen v11 PDF that the engineer example must match pixel for pixel | Never |
| `E/fonts/`, `E/licenses/` | Bundled OFL fonts, licence notices | Adding a font |
| `E/typst.toml` | Package manifest for the engine | Releasing |
| `examples/candidates/` | Fictional candidate records (engineer, captain, chief officer) and the one fictional portrait | Changing example data |
| `examples/marine/flagship/` | Short entry points that wire the six inputs together | Adding an example |
| `packages/cv-workflow/` | Python package: fresh revisions (snapshot, compile, `render.json`, `checks.json`), explicit approval (`cv.approval.json` bound to the SHA-256), verified export. Never sends anything | Changing how a candidate PDF is produced, approved or exported |
| `tests/` | `run.py` runner, `verify.py` PDF checks, `workflow.py` end-to-end workflow case, `baseline.json` hash manifest, `fixtures/*.typ` compile cases | Changing behaviour |
| `archive/design-studies/` | Four frozen, evaluated design studies with their renders | Reading for inspiration only |
| `exports/` | The four current deliverable PDFs | Releasing a new version |
| `docs/` | Governance and reference documentation, see below | Recording a decision |
| `scripts/build.ps1` | Builds the four examples into a new `builds/` folder | Rarely |
| `scripts/cv.py` | `render`, `approve`, `export`, `status` for one candidate workspace, calling `packages/cv-workflow` | Producing a real CV |
| `builds/` | Ignored. Every build and test run writes to a new timestamped folder here | Reading evidence |
| `private/` | Ignored. Real candidate workspaces: `candidate.json`, `cv.typ`, `revisions/`, `exports/` | Producing a real CV |

`apps/web/` from the target tree is not implemented; see the Trello board.

## Commands

```powershell
./scripts/build.ps1                     # four PDFs into builds/library-<timestamp>/
./scripts/build.ps1 -HideVesselDurations
python tests/run.py                     # full suite, evidence into builds/tests-<timestamp>/
typst compile --root . --font-path packages/cv-engine/fonts examples/marine/flagship/engineer.typ builds/scratch.pdf
python scripts/cv.py render private/<candidate>            # new revision: snapshot, PDF, log, checks
python scripts/cv.py approve private/<candidate> <revision> --approver "<name>" --sha256 <reviewed hash>
python scripts/cv.py export private/<candidate> <revision>  # verified copy into exports/<revision>/
```

`tests/run.py` and `scripts/cv.py render` need Typst 0.15.1 on PATH plus
Python with `pymupdf` (the suite also `pillow`). Compiling an example needs
only Typst. Approval is the owner's act: an agent never runs `approve` on a
real candidate; `--test-only` exists for fictional fixtures and is refused
under `private/`.

## Rules that never change

Full text in `docs/constitution.md`. The short list:

1. Every approved template has a frozen reference under its `tests/approved/` folder and a public example that must render pixel-identical to it; the hashes in `tests/baseline.json` are frozen with it. Today: `packages/cv-engine/domains/marine/templates/flagship/tests/approved/Marine-Engineer-CV-v11.pdf` and `examples/marine/flagship/engineer.typ`. A change that breaks this needs a new frozen reference and an ADR.
2. Every output goes to a new folder. Scripts refuse to overwrite.
3. Public content is fictional. Real candidate data lives in `private/`, which is ignored.
4. No automatic font shrinking. Overflow fails loudly and the page plan is changed by hand.
5. Evidence before "done": the suite output, a render, or a diff image.
6. The framework is the happy path, not a cage. Go around a component when the work needs it and record the bypass in `docs/framework-gaps.md`. Never go around the frozen references, the fictional-content rule, the no-shrinking rule or the totals rule (calendar periods are never converted into service time).

## Documentation

| Read | When |
|---|---|
| `docs/preferences.md` | Before every reply to the owner: who he is, how to talk to him, what he decides |
| `docs/vision.md` | Deciding whether a feature belongs here |
| `docs/architecture.md` | Before changing any module |
| `docs/pdf-workflow.md` | Target monorepo and the PDF lifecycle, both implemented 2026-09-16 except `apps/web/`; read before structural or workflow changes (ADR 0010). |
| `docs/tech-stack.md` | Setting up a machine, or asking "why Typst" |
| `docs/constitution.md` | Before anything irreversible |
| `docs/framework-gaps.md` | Before planning framework work, and after any bypass of a component or template |
| `docs/conventions.md` | Before writing code, docs or a commit message |
| `docs/development.md` | Starting, resuming or handing off a task: stages, the card as task record, review reports under `docs/work/<id>/reviews/`, guardrails |
| `docs/review.md` | Requesting, performing or recording an independent review; the `code-reviewer` subagent follows it |
| `docs/proposals/README.md` | Proposal states, owner decisions, and orientation of pending/approved work |
| `docs/proposals/trello-free-trial.md` | Why Trello is the task store: the trial, its evidence, the adoption decision |
| `docs/git-workflow.md` | Agent-owned Git, direct pushes, feature branches, integration and tags |
| `docs/reference/domains-and-roles.md` | Adding a field, a role or a template; how domain, role and template compose |
| `docs/reference/candidate-schema.md` | Editing a marine candidate JSON |
| `docs/reference/theme.md` | Creating or editing a theme |
| `docs/reference/artwork-pack.md` | Creating or editing an artwork pack |
| `docs/reference/layout-and-pagination.md` | Page balance, splits, overflow errors |
| `docs/reference/skills-component.md` | Using the optional skills section |
| `docs/reference/verification.md` | What the suite checks and how to read its output |
| `docs/guides/build-a-cv.md` | Producing a CV for a real person |
| `docs/decisions/` | Why things are the way they are (ADRs) |
| `docs/history.md` | How the project got here |

## Skills and agents

`.claude/skills/new-cv`, `verify-cv`, `new-theme`. Each is a short checklist
that names the files to copy, the commands to run and the evidence to report.
`.claude/skills/trello` reads and updates the Trello board "CVgen"
through the REST API; every task's record is a card there, so use it for
orientation and for any task state change.
`.claude/agents/code-reviewer.md` is the independent reviewer; it holds no
rules of its own and defers to `docs/review.md`.

## Working agreement for agents

- Understand the seam before editing: imports, call sites, the fixture that
  covers it. Say what you found in a line, then act.
- Prefer the owning module over a parallel one. Related components stay in
  one small file.
- Every component follows the contract in `docs/conventions.md` (ADR 0008):
  `ctx` first, data, named props, slots; the template builds `ctx` once with
  `make-ctx` (`core/component.typ`). All core and Flagship modules are
  migrated (2026-09-25). Entry points reach them only through `lib.typ`, as
  the modules `core-components` and `flagship-components`. The flat
  component names `lib.typ` exports keep the pre-contract signatures for
  older custom compositions (`core/legacy.typ`, `F/legacy.typ`,
  deprecated); new code never calls them. Roles are
  variations within a domain, never forks (constitution section 7); `core/`
  never imports from `domains/`.
- Every non-trivial change to code, fixtures or inputs ends with
  `python tests/run.py` passing and the evidence path reported; a visual
  change also needs a rendered page. Whether a change needs an independent
  `code-reviewer` round is decided by `docs/review.md` ("When a review is
  required"); reports go in the task's `reviews/` folder.
- If you had to go around a component, template or the contract to deliver
  what the owner wanted, add an entry to `docs/framework-gaps.md` before
  reporting done. A bypass is a lesson, not a fault.
- Agents act as senior developers and do not ask for routine work: commits,
  pushes, merges to `main`, history edits on feature work, branch, worktree
  and (non-`archive/*`) tag cleanup, clearing `builds/` by path, board
  updates (owner's instruction, 2026-09-25). Product decisions, real-candidate
  approval and a short list of irreversible operations stay with the owner.
  That list lives only in `docs/preferences.md` ("What he decides and what
  agents decide"); read it there rather than from a summary.
