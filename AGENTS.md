# AGENTS.md — map of this repository

Composable Typst library that renders maritime CVs. Today one template,
`flagship`, takes five independent inputs: candidate JSON, theme, artwork
pack, layout profile and a durations switch. The product is a family of such
templates on one shared core, each rendering deck and engine candidates
(`docs/vision.md`, ADR 0007). Read this file and `docs/preferences.md`, then
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
- On a fresh or resumed session, derive a brief Goal / Now / Next / You report
  from the vision, relevant decisions/proposals, authoritative task records when
  available, Git state, and evidence for the examined revision. Distinguish an
  approved design from implemented behavior, and historical checks from current
  proof. Do not use `docs/now.md`; it is a retired historical snapshot.
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

| Path | Role | Touch it when |
|---|---|---|
| `lib.typ` | Public import surface, no side effects | Adding or renaming an exported function |
| `src/` | Library modules: data, theme check, primitives, hero, experience, sections, certificates, education, skills, page, pagination, `templates/flagship.typ` | Changing how anything renders |
| `themes/` | Visual tokens only: colours, fonts, sizes, tracking, leading, SVG colour map | Adding a look |
| `artwork/` | Artwork packs: which SVG goes in which slot, plus offsets | Adding a role's illustrations |
| `layouts/` | Geometry and page plan: margins, gaps, widths, which companies go on which page | Fixing page balance |
| `content/` | Fictional candidate JSON, one per candidate | Changing example data |
| `examples/` | Seven-line entry points that wire the five inputs together | Adding an example |
| `assets/`, `fonts/`, `licenses/` | Original SVG artwork, bundled OFL fonts, licence notices | Adding art or a font |
| `tests/` | `run.py` runner, `verify.py` PDF checks, `baseline.json` hash manifest, `fixtures/*.typ` compile cases | Changing behaviour |
| `reference/` | Frozen v11 PDF that the engineer example must match pixel for pixel | Never |
| `designs/` | Four frozen, evaluated design studies as worked examples | Reading for inspiration only |
| `exports/` | The three current deliverable PDFs | Releasing a new version |
| `schema/` | JSON Schema for candidate files | Changing the data contract |
| `docs/` | Governance and reference documentation, see below | Recording a decision |
| `scripts/build.ps1` | Builds the three examples into a new `builds/` folder | Rarely |
| `builds/` | Ignored. Every build and test run writes to a new timestamped folder here | Reading evidence |

## Commands

```powershell
./scripts/build.ps1                     # three PDFs into builds/library-<timestamp>/
./scripts/build.ps1 -HideVesselDurations
python tests/run.py                     # full suite, evidence into builds/tests-<timestamp>/
typst compile --root . --font-path fonts examples/engineer.typ builds/scratch.pdf
```

`tests/run.py` needs Typst 0.15.1 on PATH plus Python with `pymupdf` and
`pillow`. Building a CV needs only Typst.

## Rules that never change

Full text in `docs/constitution.md`. The short list:

1. Every approved template has a frozen reference under `reference/` and a public example that must render pixel-identical to it; the hashes in `tests/baseline.json` are frozen with it. Today: `reference/Marine-Engineer-CV-v11.pdf` and `examples/engineer.typ`. A change that breaks this needs a new frozen reference and an ADR.
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
| `docs/pdf-workflow.md` | Approved target monorepo and PDF lifecycle; read before planning structural or workflow changes. Implementation pending (ADR 0010). |
| `docs/tech-stack.md` | Setting up a machine, or asking "why Typst" |
| `docs/constitution.md` | Before anything irreversible |
| `docs/framework-gaps.md` | Before planning framework work, and after any bypass of a component or template |
| `docs/conventions.md` | Before writing code, docs or a commit message |
| `docs/development.md` | Starting, resuming or handing off a task: stages, the task record under `docs/work/<id>/`, guardrails |
| `docs/review.md` | Requesting, performing or recording an independent review; the `code-reviewer` subagent follows it |
| `docs/proposals/README.md` | Proposal states, owner decisions, and orientation of pending/approved work |
| `docs/proposals/trello-free-trial.md` | Authorized two-task Trello Free trial: scope, temporary task records, execution evidence and adoption decision |
| `docs/git-workflow.md` | Agent-owned Git, direct pushes, feature branches, integration and tags |
| `docs/reference/candidate-schema.md` | Editing a candidate JSON |
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
`.claude/agents/code-reviewer.md` is the independent reviewer; it holds no
rules of its own and defers to `docs/review.md`.

## Working agreement for agents

- Understand the seam before editing: imports, call sites, the fixture that
  covers it. Say what you found in a line, then act.
- Prefer the owning module over a parallel one. Related components stay in
  one small file.
- Components in a migrated module follow the contract in
  `docs/conventions.md` (ADR 0008): `ctx` first, data, named props, slots.
  No module is migrated yet, so a new component matches the order already
  used by its file. Deck and engine are never separate templates
  (constitution section 7).
- Every non-trivial change ends with `python tests/run.py` passing, the
  evidence path reported, and a fresh `code-reviewer` round under
  `docs/review.md` with the report stored in the task's `reviews/` folder.
  A visual change also needs a rendered page.
- If you had to go around a component, template or the contract to deliver
  what the owner wanted, add an entry to `docs/framework-gaps.md` before
  reporting done. A bypass is a lesson, not a fault.
- Routine commits, pushes and non-destructive merges, including to `main`, are
  authorized for agreed work under `docs/git-workflow.md`. This replaces the old
  per-merge approval rule. Product/design decisions and the explicit destructive
  operation checkpoints remain with the owner.
