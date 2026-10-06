# AGENTS.md — map of CVgen

CVgen makes hand-crafted, premium CVs with AI on its own Typst framework,
for any domain (ADR 0011, 2026-09-21). The engine is the domain-neutral
Framework (`packages/cv-framework`) plus the domains beside it
(`packages/domains/`, ADR 0012); `marine` is the first, with one template, `flagship`, that takes six
independent inputs: candidate JSON, role, theme, artwork pack, layout
profile and a durations switch. A domain offers a facts shape, assets,
wording and rules; a role is one level of specialisation; a template may
override anything (`docs/vision.md`, `docs/reference/domains-and-roles.md`). Read this file and `docs/preferences.md`, then
open only what your task needs.

**Design is the product** (owner, 2026-09-29; `docs/vision.md`, "Design is
the product"). The design and styling are what CVgen sells and what sets it
apart from online automated tools. A CV must pass the `Batch Test` (it
cannot be skipped in an HR batch of 100 to 200) and the `Three-Second Test`
(the page itself shouts `Domain`, specialty and role before a word is
read), going beyond "safe professional", elegantly, at the level of the
Marine Flagship. A well-crafted but quiet design is a failure. Anyone who
designs, reviews or proposes a CV design reads that section first.

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

Layout per ADR 0010 (`docs/pdf-workflow.md`), ADR 0011 (domains) and ADR 0012
(the Framework split). `W` below stands for `packages/cv-framework`, the
Framework; `M` for `packages/domains/marine`, the marine domain; `F` for
`M/templates/flagship`.

| Path | Role | Touch it when |
|---|---|---|
| `W/lib.typ` | The Framework's import surface: core names only, no domain, no side effects | Adding or renaming a core export |
| `M/lib.typ` | The marine import surface every marine entry point uses: the Framework's names plus marine and Flagship, no side effects | Adding or renaming a marine or Flagship export |
| `W/core/` | Domain-neutral core: `node` (merge, compose), `data` (common facts), `theme` check, `component` (`make-ctx`, which builds `ctx`), `components` (the ctx-first primitives and page shell as one module, exported as `core-components`), `primitives`, `page` shell, `pagination` over a domain row model, `legacy` (deprecated old signatures). Never imports a domain; the suite checks it | Changing behaviour every domain shares |
| `M/domain.typ`, `M/data.typ` | The marine domain node (id, meta, copy, experience model) and the marine facts: companies, vessels, months, totals, `normalize-candidate`, `validate-candidate` | Changing what the marine domain means |
| `M/roles/deck/`, `M/roles/engine/` | Role markers (`role.typ`); bare today | Refining something for one role |
| `M/schema/candidate.schema.json` | Marine candidate-facts contract: what a record may contain, no template wording | Changing the marine data contract |
| `F/flagship.typ` | The Flagship composition: page loop, section order, overflow check | Changing what Flagship renders |
| `F/adapter/` | Candidate facts -> Flagship input: adds Flagship wording (`copy`) and merges overrides | Changing Flagship's input shape |
| `F/schema/flagship-input.schema.json` | Flagship input contract: facts plus `copy` | Same |
| `F/components/`, `F/components.typ`, `F/legacy.typ` | Flagship sections, ctx-first: hero, experience, sections, certificates, education, skills; `components.typ` gathers them into the one module `M/lib.typ` exports as `flagship-components`; `legacy.typ` keeps their old signatures for `M/lib.typ` (deprecated) | Changing how a section renders |
| `F/themes/` | Visual tokens only: colours, fonts, sizes, tracking, leading, SVG colour map | Adding a look |
| `F/artwork/`, `M/assets/` | Artwork packs (which SVG in which slot, offsets) and the SVG files | Adding a role's illustrations |
| `F/layouts/` | Geometry and page plan: margins, gaps, widths, which companies go on which page | Fixing page balance |
| `F/tests/approved/` | Frozen v11 PDF that the engineer example must match pixel for pixel | Never |
| `W/fonts/`, `W/licenses/` | Bundled OFL fonts, licence notices | Adding a font |
| `W/typst.toml` | Package manifest for the Framework | Releasing |
| `examples/candidates/` | Fictional candidate records (engineer, captain, chief officer, deck cadet) and the one fictional portrait | Changing example data |
| `examples/marine/flagship/` | Short entry points that wire the six inputs together, each with its `Release` PDF and `Meta File` beside it (`engineer.typ`, `engineer.pdf`, `engineer.meta.json`), written only by `scripts/build.ps1 -Release` | Adding an example, releasing a new version |
| `packages/cv-workflow/` | Python package: fresh revisions (snapshot, compile, `render.json`, `checks.json`), explicit approval (`cv.approval.json` bound to the SHA-256), verified export, and the `Output Contract` (`outputs.py`, `output.schema.json`: homes and `Meta File`s). Never sends anything | Changing how a candidate PDF is produced, approved or exported |
| `tests/` | `run.py` runner, `verify.py` PDF checks, `workflow.py` end-to-end workflow case, `baseline.json` hash manifest, `fixtures/*.typ` compile cases | Changing behaviour |
| `archive/design-studies/` | Four frozen, evaluated design studies with their renders | Reading for inspiration only |
| `archive/anti-examples/` | Frozen designs the owner rejected as not his style (`Anti-example`), with their fonts and his reasons; see its `README.md` | Before proposing or reviewing a design: never repeat one |
| `design-concepts/` | Template concepts proposed by the `magazine-editor` agent: one folder per style with `brief.md` (and, when the `Domain` has no record yet, `sample.json`) shared by its two `Density`s (`condensed/`, `spacious/`), each holding three `Design Tier`s (`<tier>/<density>-<tier>.typ`, PDF, PNG per page, and every PDF its `Meta File`; see its `README.md`); earlier runs have one `concept.typ`. Proposals, not library code | Running or deciding on an idea run |
| `brand/` | CVgen's own brand assets: `logos/` (the working logo is the needle's eye, `cvgen-mark-c-eye.svg` and `cvgen-wordmark.svg`; see `brand/README.md`) | Using or replacing the logo |
| `docs/` | Governance and reference documentation, see below | Recording a decision |
| `scripts/build.ps1` | Builds the five examples into a new `builds/` folder; `-Release` then copies each beside its entry point and stamps its `Meta File` | Rarely |
| `scripts/cv.py` | `render`, `approve`, `export`, `status` for one candidate workspace, calling `packages/cv-workflow` | Producing a real CV |
| `scripts/outputs.py` | The `Output Contract` tool: `stamp` writes a PDF's `Meta File`, `check` lists every PDF with no valid, current one or outside its home (`docs/pdf-workflow.md`) | Writing a PDF someone will review |
| `scripts/intake-form.gs` | Google Apps Script the owner runs to make a client's optional `Intake Form` and its answers Sheet; Claude writes a filled copy per form as `intake/form-NN.gs` | Changing how the form is built |
| `scripts/design_review/` | The owner's local Design Review app (`server.py`, `index.html`): every PDF with a valid `Meta File` (concepts, the `Release`, client renders and `Text Draft`s) as a Board and a Loupe, the rest listed as unindexed with the reason, filters, page previews, compare, a `Batch Test` pile (`plain-cvs.typ`), his review state in `.local/design-review/state.json` (read it for his verdicts and notes), PDFs opened in the default app. Binds to 127.0.0.1 only | Changing how the owner reviews designs |
| `scripts/text-draft.typ` | The `Text Draft` a client checks before design (`Sign-off`), house design First Fitting | Changing how the text draft looks |
| `.atlas/` | The `Atlas`: open `.atlas/index.html` from disk. Facts in `src/*.json`, each step citing its sources; `python .atlas/_kit/atlas.py build` writes the pages, `check` lists pages whose sources changed or were never checked | A mapped flow, agent or model changed: update its page, `build`, `stamp` |
| `builds/` | Ignored. Every build and test run writes to a new timestamped folder here | Reading evidence |
| `.worktrees/` | Ignored. Extra Git checkouts, one per parallel branch (`docs/git-workflow.md`) | Never edit another session's |
| `private/` | Ignored. One `Envelope` per real client: `envelope.json`, `intake/`, `research/`, `draft/`, `candidate.json`, `cv.typ`, `revisions/`, `exports/` | Producing a real CV |

`apps/web/` from the target tree is not implemented; see the Trello board.

## Commands

```powershell
./scripts/build.ps1                     # five PDFs into builds/library-<timestamp>/
./scripts/build.ps1 -HideVesselDurations
./scripts/build.ps1 -Release            # the same, then the `Release`: copied beside the entry points, stamped
python tests/run.py                     # full suite, evidence into builds/tests-<timestamp>/
typst compile --root . --font-path packages/cv-framework/fonts examples/marine/flagship/engineer.typ builds/scratch.pdf
python scripts/cv.py render private/<candidate>            # new revision: snapshot, PDF, log, checks
python scripts/cv.py approve private/<candidate> <revision> --approver "<name>" --sha256 <reviewed hash>
python scripts/cv.py export private/<candidate> <revision>  # verified copy into private/<candidate>/exports/<revision>/
python scripts/outputs.py stamp <pdf> status=<status> [key=value ...]   # write the PDF's Meta File
python scripts/outputs.py check [--private]   # every PDF in its home with a valid, current Meta File
python scripts/design_review/server.py   # the owner's Design Review app on http://127.0.0.1:8765/
```

`tests/run.py` and `scripts/cv.py render` need Typst 0.15.1 on PATH plus
Python with `pymupdf` and `jsonschema` (the suite also `pillow`). Compiling an example needs
only Typst. Approval is the owner's act: an agent never runs `approve` on a
real candidate; `--test-only` exists for fictional fixtures and is refused
under `private/`.

## Rules that never change

Full text in `docs/constitution.md`. The short list:

1. Every approved template has a frozen reference under its `tests/approved/` folder and a public example that must render pixel-identical to it; the hashes in `tests/baseline.json` are frozen with it. Today: `packages/domains/marine/templates/flagship/tests/approved/Marine-Engineer-CV-v11.pdf` and `examples/marine/flagship/engineer.typ`. A change that breaks this needs a new frozen reference and an ADR.
2. Every output goes to a new folder. Scripts refuse to overwrite.
3. Public content is fictional. Real candidate data lives in `private/`, which is ignored.
4. No automatic font shrinking. Overflow fails loudly and the page plan is changed by hand.
5. Evidence before "done": the suite output, a render, or a diff image.
6. The framework is the happy path, not a cage. Go around a component when the work needs it and record the bypass in `docs/framework-gaps.md`. Never go around the frozen references, the fictional-content rule, the no-shrinking rule or the totals rule (calendar periods are never converted into service time).

## Documentation

| Read | When |
|---|---|
| `docs/preferences.md` | Before every reply to the owner: who he is, how to talk to him, what he decides |
| `docs/glossary.md` | Before every reply to the owner, proposal or document: the official terms, backticks in replies, adding terms and reporting them |
| `docs/vision.md` | Deciding whether a feature belongs here |
| `docs/architecture.md` | Before changing any module |
| `docs/pdf-workflow.md` | Target monorepo and the PDF lifecycle, both implemented 2026-09-16 except `apps/web/`, and the `Output Contract` (where every PDF we show lives, its `Meta File`); read before structural or workflow changes (ADR 0010) and before writing a PDF someone will review |
| `docs/tech-stack.md` | Setting up a machine, or asking "why Typst" |
| `docs/constitution.md` | Before anything irreversible |
| `docs/framework-gaps.md` | Before planning framework work, and after any bypass of a component or template |
| `docs/conventions.md` | Before writing code, docs or a commit message |
| `docs/development.md` | Starting, resuming or handing off a task: stages, the card as task record, review reports under `docs/work/<id>/reviews/`, guardrails |
| `docs/review.md` | Requesting, performing or recording an independent review; the `code-reviewer` subagent follows it |
| `docs/proposals/README.md` | Proposal states, owner decisions, and orientation of pending/approved work |
| `docs/proposals/trello-free-trial.md` | Why Trello is the task store: the trial, its evidence, the adoption decision |
| `docs/git-workflow.md` | Agent-owned Git, direct pushes, feature branches, integration and tags |
| `docs/reference/domains-and-roles.md` | Adding a domain, a role or a template; how domain, role and template compose |
| `docs/reference/candidate-schema.md` | Editing a marine candidate JSON |
| `docs/reference/theme.md` | Creating or editing a theme |
| `docs/reference/artwork-pack.md` | Creating or editing an artwork pack |
| `docs/reference/layout-and-pagination.md` | Page balance, splits, overflow errors |
| `docs/reference/skills-component.md` | Using the optional skills section |
| `docs/reference/verification.md` | What the suite checks and how to read its output |
| `docs/guides/client-workflow.md` | A new client: intake, research, `Sign-off`, before building the CV |
| `docs/research/` | The `Research Library`: shared, dated research notes, no client data |
| `docs/guides/build-a-cv.md` | Producing a CV for a real person |
| `docs/decisions/` | Why things are the way they are (ADRs) |
| `docs/history.md` | How the project got here |

## Skills and agents

`.claude/skills/new-client`, `new-cv`, `verify-cv`, `new-theme`. Each is a short checklist
that names the files to copy, the commands to run and the evidence to report.
`new-client` takes a client from first message to signed-off facts; `new-cv`
builds the CV from there.
`.claude/skills/trello` reads and updates the Trello board "CVgen"
through the REST API; every task's record is a card there, so use it for
orientation and for any task state change.
`.claude/agents/code-reviewer.md` is the independent reviewer; it holds no
rules of its own and defers to `docs/review.md`. For the agent context
(this file, `docs/`, skills, agent definitions) the pair is
`context-maintainer`, which integrates owner feedback into the file that
owns the rule, and `context-reviewer`, the independent gate for such
changes (`docs/review.md`).
`.claude/skills/repo-maintenance` keeps the tree easy to navigate
(`/repo-maintenance quick|audit|deep|apply`): a read-only audit script, the
read-only `repo-auditor-lite` agent for the judgement checks, and CVgen's own
rules in `.claude/repo-maintenance.md`. It reports; the owner approves fixes
by ID; `apply` moves only those, on a branch. `quick` is in the `Session
Sweep`.
`.claude/skills/idea-run` runs the idea agents in a closed review loop:
`ceo` proposes product ideas (checked by `ceo-reviewer`), `magazine-editor`
proposes three very distinct styles, each in two `Density`s and three
`Design Tier`s, as mock-up PDFs (checked by `design-reviewer`, which also judges client CV
designs, first on the `Batch Test` and the `Three-Second Test`),
and `research-reviewer` checks the web research behind both. They only
propose; the owner decides.

## Working agreement for agents

- Speak the glossary (`docs/glossary.md`). Use its official terms, never a
  synonym, and wrap them in backticks in every reply to the owner. Keep it
  current yourself: a concept that keeps coming up unnamed, two words for
  one thing, one word for two things, or a term the owner coins becomes a
  term without asking. Name every term you added, renamed or dropped in
  your next report or Recap; the owner changes it then if he dislikes it.
- Understand the seam before editing: imports, call sites, the fixture that
  covers it. Say what you found in a line, then act.
- Prefer the owning module over a parallel one. Related components stay in
  one small file.
- Every PDF someone will review sits in its home with a `Meta File`
  beside it (the `Output Contract`, `docs/pdf-workflow.md`): stamp it with
  `scripts/outputs.py stamp` after each compile, or let the script that
  wrote it stamp it. Scratch renders go to `builds/`. The suite fails on a
  public PDF without a valid, current `Meta File`.
- Every component follows the contract in `docs/conventions.md` (ADR 0008):
  `ctx` first, data, named props, slots; the template builds `ctx` once with
  `make-ctx` (`W/core/component.typ`). All core and Flagship modules are
  migrated (2026-09-25). Entry points reach them only through a `lib.typ`
  (`M/lib.typ` for marine, `W/lib.typ` for a one-off with no domain), as
  the modules `core-components` and `flagship-components`. The flat
  component names `M/lib.typ` exports keep the pre-contract signatures for
  older custom compositions (`W/core/legacy.typ`, `F/legacy.typ`,
  deprecated); new code never calls them. Roles are
  variations within a domain, never forks (constitution section 7); the
  Framework never imports from `packages/domains/` (ADR 0012).
- Every non-trivial change to code, fixtures or inputs ends with
  `python tests/run.py` passing and the evidence path reported; a visual
  change also needs a rendered page. Every change gets an independent
  review round, documentation, rules, proposals and assets included; only
  truly trivial changes are exempt, idea runs use their own gates, and
  pure record-keeping commits need no round (`docs/review.md`, "When a
  review is required"). Reports go in the
  task's `reviews/` folder.
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
