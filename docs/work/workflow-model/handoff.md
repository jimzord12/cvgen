# Handoff: workflow-model (2026-10-06)

For the next agent. This file lists what was done on branch `docs/workflow-model`,
what the owner decided, what is still open, and the work broken into tasks for
Backlog.md. Session: a Claude Code cloud session, 2026-10-04 to 2026-10-06,
halted by the owner.

---

## 1. How to integrate the branch

**Branch:** `docs/workflow-model` (pushed to GitHub).
**Contents beyond `main`:** one commit with a new folder, `docs/workflow/inventory/`
(a README plus three inventory files), and this handoff. `main` was merged into
the branch at `57a6c32`, with no conflicts. Nothing outside these two folders
changes, so no code, fixture or PDF is touched.

Steps:

1. `git fetch origin` and check that the branch still merges cleanly:
   `git merge-tree $(git merge-base origin/main origin/docs/workflow-model) origin/main origin/docs/workflow-model`
   should list no conflicts. If `main` has moved, merge `main` into the branch first.
2. Review. Both folders are work records (`docs/review.md`, record-keeping), so no
   full round is required. One fresh `context-reviewer` pass on
   `docs/workflow/inventory/` is still worth it, for one reason: it is public and
   describes a real client's workflow. Confirm that it names no client other than
   the `Alias` `client-2026-09-01`. (It does not. The only client-specific detail
   is the one-off file names already public in `docs/framework-gaps.md`.)
3. Evidence: `python tests/run.py` (expected PASS; the branch touches no tested
   path) and `python scripts/outputs.py check` (no PDFs added).
4. Merge into `main` with `--no-ff` from a checkout that has `main` checked out,
   then `git push origin main` (the owner's settings refuse refspecs naming
   `:main`; see `.claude/skills/backlog/SKILL.md`, "Route to `main`").
5. Delete the branch, locally and on GitHub. Also delete
   `ccr-e35bf17e-r3ipn8` on GitHub. It was this session's cloud working branch,
   and everything on it is in `docs/workflow-model`. The cloud session could not
   delete remote branches (HTTP 403 from its proxy), so it must happen from the
   owner's machine.
6. Create the Backlog.md tasks from section 4 on `main`, through the backlog skill.

**Related Session Sweep item.** The `main` handoff doc (`backlog/docs/doc-1`, "Next",
item 3) flags `git log 0488c4f..1e684eb` as merged without review reports. Those
commits are this session's work of 2026-10-04. The branches were merged at the
owner's request ("merge all branches until only main remains"), and each had
been reviewed on its own branch. What was **not** reviewed is the merge-time
changes made by this session:

- `a66b448`: `docs/idea-run-2026-10-02-editor-b` merged cleanly. It already
  contained `codex/repo-agents`, `docs/idea-run-2026-10-02-editor` and
  `docs/idea-run-2026-09-29-editor`.
- `1db32e8`: `feature/hanami-client-cv`, with 8 add/add conflicts. All were
  resolved to the Hanami branch's side, because it held the owner's later
  "chosen/parked" decision and the fonts moved into the Framework. The
  exceptions:
  - `design-concepts/README.md` kept the editor-b version and swapped in only
    the two Hanami rows.
  - The last paragraph of `docs/work/idea-runs/2026-10-02-editor-2/run.md` was
    reworded to say the cross-branch references now resolve on `main`.
- `74a6f82`: `docs/codex-visual-tools`, with one conflict in `AGENTS.md`. Both
  paragraphs were kept: the context-maintainer/context-reviewer sentence first,
  then repo-maintenance.
- `1e684eb`: the Atlas.
  - Every `git:<branch>:` source was re-pointed to the same path on `main`.
  - The context agents moved from `planned` to `built`.
  - The status panels of client-journey, design-run and change-review were
    rewritten.
  - The pages were rebuilt and stamped.

The suite passed after all four (94 compilation cases, `builds/merge-check-2/`,
not kept). Not done: a stored review report. Suggested: one `context-reviewer`
round over those four commits (task 1 below), stored in
`docs/work/workflow-model/reviews/`.

Two known leftovers from those merges, to fix in the restructure, not now:

- The three fonts exist twice, in `design-concepts/fonts/` and
  `packages/cv-framework/fonts/` (about 6 MB).
- `docs/proposals/codex-visual-tools.md` is `approved` and still not built
  (TASK-4).

---

## 2. What we were doing

The owner wants CVgen to reach "A+ in every category". He is freezing product
work to invest in restructure, maintenance and enhancement. This session ran
in four parts.

1. **Audit (2026-10-04).** Three read-only reviewers looked at code and
   architecture, docs and process, and structure and hygiene.

   | Area | Grade |
   |---|---|
   | Engineering rules (frozen reference, never overwrite, no shrinking, evidence) | A |
   | Code quality | B |
   | Architecture | C+ |
   | Python and tooling | C |
   | Structure and navigation | C |
   | Docs and process | D |

   The headline: the process outweighs the product. There are about 187k words
   of Markdown, with 125k of them in `docs/work/`, against about 1k lines of
   Typst and 2.8k of Python. The concrete findings became the "restructure"
   tasks in section 4. The suite passed: 94 cases, and 25/25 repo-maintenance
   tests.
2. **Branches (2026-10-04).** Six unmerged branches were merged into `main`
   (section 1). GitHub now has only `main` and the cloud branch.
3. **Workflow model, design discussion (2026-10-04/05).** The owner asked for a
   single, anchored description of the client workflow from first contact to
   deletion (section 3).
4. **Inventory (2026-10-05).** Three agents listed every entity of today's
   client workflow, anchored to file:line. They found:
   - 7 stages and about 81 steps, 85 artifacts, 58 actions and 46 gates
     (counted per stage; the two halves overlap).
   - 34 drift items and 53 conflicts or gaps.
   - 9 decisions for the owner.

   Result: `docs/workflow/inventory/README.md`.

The owner has **not yet answered the nine decisions**. The session halted there.

---

## 3. What we thought, and how we would have continued

### The owner's requirements, in his words, condensed

- A `docs/workflow/` folder, one subfolder per stage, and a top README that
  explains each stage and how they connect. It must not be a bare router; he
  suggested about 500 lines.
- **Anchoring above all.** Every action, file, procedure, flow and phase is a
  concrete, named entity. The contracts between them are explicit ("this phase
  consists of A, B, C; A connects to B like this; it produces that"). No
  abstract or vague workflow prose. Everything traceable and identifiable, and
  ideally verifiable.
- The same source must generate the Atlas.

### Decisions the owner made (2026-10-05)

| Decision | Choice |
|---|---|
| Data model or strict Markdown | **Data model** |
| The Atlas | **Rebuild it from the model** |
| Facts format | **YAML**, type-checked |
| Engine language | **Modern TypeScript on Bun 1.4.2+ or Node.js 24+.** He knows these; he does not know Python. We recommended Bun: native TypeScript, built-in `bun test`, few dependencies. |
| Scope first | Client journey (our recommendation; he did not object) |

### The agreed design

```
FACTS (YAML)                   ENGINE (TypeScript, Bun)            OUTPUTS (generated, never hand-edited)
docs/workflow/catalog.yaml  →  load + validate (Zod types)    →   docs/workflow/**/README.md generated blocks
docs/workflow/NN-<stage>/      check (levels 1-3, below)           + Mermaid diagrams (GitHub renders them)
  stage.yaml                   render                              the Atlas pages
                                                                   pass/fail inside the test suite and CI
```

**Layout.**
- `docs/workflow/README.md`: the whole journey, with a generated diagram and a
  short section per stage.
- `docs/workflow/catalog.yaml`: actors, actions, artifacts and schemas shared by
  all stages.
- One folder per stage, each with `README.md` (prose: purpose, judgement calls)
  and `stage.yaml` (contract): `01-open/`, `02-intake/`, `03-research/`,
  `04-text-draft/`, `05-design/`, `06-deliver/`, `07-after/`. These are the
  Atlas client-journey phases, proven against the first real client.

**Entities and ID scheme** (used by the inventory):

| Entity | ID | Fields |
|---|---|---|
| Stage | `intake` | purpose, entry condition, exit condition, steps |
| Step | `intake.relay` | actor, action, inputs → outputs, next, on failure |
| Artifact | `art.envelope-json` | path pattern (`private/<envelope>/envelope.json`), schema, public/private/external |
| Actor | `actor.owner`, `actor.client`, `actor.lead`, `actor.<agent>`, `actor.script` | what it may do |
| Action | `cmd.*` (exact command), `skill.*`, `agent.*`, `manual.*` (human act), `lead.*` (Claude's own work, added after the inventory) | invocation |
| Gate | `gate.sign-off` | check, pass → step, fail → step |
| Loop | on a step or gate | declared with its round cap (`Deep Dive`, design-review and draft-correction loops), so a cycle is allowed only when declared |

Edges are **derived, never written**. When step B lists an input that step A
outputs, that is the connection. One step in YAML would look like this:

```yaml
- id: deliver.approve
  actor: actor.owner
  action: cmd.cv-approve          # python scripts/cv.py approve <envelope> <revision> --approver ... --sha256 ...
  inputs: [art.revision-pdf, art.checks-json]
  outputs: [art.approval-json]
  gate: { check: "owner viewed the exact SHA-256", pass: deliver.export, fail: design.build-cv }
```

**Type checking.** The types are defined once in TypeScript with **Zod**, and Zod
exports a JSON Schema. Two things read it:
- The VS Code YAML language server (Red Hat), which underlines errors while
  typing, through a `# yaml-language-server: $schema=...` line.
- The engine at run time, which fails with file, line and reason.

Pkl and CUE were considered and rejected: a third language.

**Verification levels.**

| Level | What it proves |
|---|---|
| 1. Shape and references | Every YAML file matches its type. Every ID resolves. Every path, command, skill and schema exists: files on disk, `cv.py` subcommands through `--help`, skills by folder. |
| 2. Flow | Every input is produced by an earlier step or marked external. Every gate has both a pass and a fail branch. No step is unreachable. Cycles exist only as declared loops with caps. |
| 3. Reality | A fictional client runs through the real scripts in a temporary `Envelope` (extending `tests/workflow.py`). After each automated step, the declared artifacts must exist and validate. Human judgement steps get labelled fixture stand-ins and are checked only at their edges. |

- **Proof that the checker works:** a set of deliberately broken models (dangling
  reference, gate without a fail branch, orphan step) that it must reject.
- **Generated outputs:** CI regenerates them and fails on any diff.

**Pushbacks we raised, still open for the owner:**
- Top README at about 200-300 lines rather than 500, because every line there
  repeats a stage file and repetition drifts. He has not answered.
- The model must **replace**, not add:
  - `docs/guides/client-workflow.md`, `docs/guides/build-a-cv.md`, the
    lifecycle half of `docs/pdf-workflow.md` and the Atlas client-journey
    page data.
  - The skills (`new-client`, `new-cv`) shrink to pointers at step IDs.

  Otherwise it becomes a fifth source.

**Alternative considered and rejected:** strict Markdown with an ID convention
and a path-only checker. It is half the work, but the connections stay
hand-written.

### The nine owner decisions (open; recommendations in `docs/workflow/inventory/README.md`)

Two have partly moved on `main` since then:
- **#1 (when the delete-by date starts).** `main` now records one delete-by date
  per client, written at delivery (2027-10-02 for `client-2026-09-01`).
- **#7.** It now reads "a Backlog.md task per `Alias`", not a Trello card.

Re-ask the owner before encoding. Answers go into a proposal (task 2), and the
model encodes them.

### Access facts the next agent needs

- **A cloud session has no `private/`.** `private/` is now its own private Git
  repository (`jimzord12/cvgen-private`, `docs/guides/client-workflow.md`
  section 9).
  - Level-3 checks against a real `Envelope` should run in a **local** session
    on the owner's machine, read-only.
  - Do not clone client data into a cloud container.
  - The model and levels 1-2 need no private data.
- **The cloud proxy refuses remote branch deletion (HTTP 403).**
- **The inventory's anchors are from `1e684eb`.** Re-anchor before encoding;
  the guides, `new-client` and `development.md` changed on `main` since then.

---

## 4. Suggested tasks for Backlog.md

**Before creating any, check for duplicates** with
`backlog search "<words>" --plain`. TASK-28 (proposals snapshot), TASK-29
(remove night-shift), TASK-30 (Main Folder term) and TASK-4 (codex-visual-tools)
already exist.

Create on `main` with:

```
backlog task create "<id>: <Outcome>" -s Queued -d "<description>" --ac "<item>" --no-dod-defaults --plain
```

Each id names its `docs/work/<id>/` folder.

### A. Workflow model (in order; each depends on the one before unless noted)

| # | Id: outcome | Description | Acceptance criteria |
|---|---|---|---|
| 1 | `merge-review-2026-10-04`: the 2026-10-04 branch merges have a review record | Review the merge-time changes in `a66b448`, `1db32e8`, `74a6f82` and `1e684eb` (section 1). Closes item 3 of the `main` handoff. Independent of the rest. | A `context-reviewer` report is stored in `docs/work/workflow-model/reviews/`; findings are fixed or dispositioned; the `main` handoff item is closed |
| 2 | `workflow-decisions`: the owner's nine workflow decisions are recorded | Put the nine questions in `docs/workflow/inventory/README.md` (updated for #1 and #7) to the owner, plus the README-length question. Record the answers in `docs/proposals/workflow-model.md`. | The proposal exists with each decision, its date and the owner's words; `status: approved` |
| 3 | `workflow-model-adr`: ADR 0015 for the workflow model and its toolchain | Record YAML facts, the TypeScript/Bun engine, Zod plus JSON Schema, Atlas from the model, and a second toolchain beside Python (CI installs Bun). | ADR 0015 merged; `docs/tech-stack.md` and `AGENTS.md` mention Bun |
| 4 | `workflow-schema`: typed entity definitions for the workflow model | Bun project (suggested `tools/workflow/`), Zod types for Stage, Step, Artifact, Action (`cmd`/`skill`/`agent`/`manual`/`lead`), Actor, Gate and Loop, with external artifacts; exported JSON Schema; the YAML language-server hint. **Show the types to the owner before the engine.** | `bun test` passes; the JSON Schema is generated; one sample `stage.yaml` validates in VS Code and through the engine |
| 5 | `workflow-facts`: the client journey encoded as YAML | `catalog.yaml` plus seven `stage.yaml` files from the inventory, re-anchored to current `main`, applying task 2's decisions. | All seven stages encoded; every entity carries its source anchor; the inventory's implicit steps (port a concept, update `CV Decisions`, close the record, keep request) are named |
| 6 | `workflow-check`: the engine verifies the model (levels 1 and 2) | `check` command: shape, references, existence of files, commands (`cv.py`/`outputs.py` via `--help`) and skills; flow rules with declared loops. A negative-fixture suite of broken models. Wired into `tests/run.py` and `.github/workflows/verify.yml`. | Every rule has a failing fixture; CI runs it; the real model passes |
| 7 | `workflow-render`: docs and diagrams generated from the model | `render` writes the generated blocks (between markers) in `docs/workflow/**/README.md` and the Mermaid diagrams. CI fails if regeneration changes anything. | The regenerated tree is identical in CI; diagrams render on GitHub |
| 8 | `workflow-prose`: the stage READMEs and the journey README | Hand-written purpose, judgement and branches per stage; the top README at the length the owner chose. Refers to IDs and never restates contracts. | A context-reviewer PASS; a newcomer test: an agent answers five "what happens if" questions from these files alone |
| 9 | `atlas-from-model`: the Atlas client journey is built from the model | Port the Atlas build to TypeScript (or feed the existing page format from the model); retire hand-written `client-journey.json` facts. Later pages follow. | The client-journey page is generated; `atlas check` (or its successor) passes; the old page data is deleted |
| 10 | `workflow-reality-check`: level 3, the model checked against a real run | Extend `tests/workflow.py`, or drive it from the engine, so a fictional client runs every automated step in a temporary `Envelope`; declared artifacts must exist and validate; labelled stand-ins cover human steps. Add a read-only local mode for a real `Envelope` that never copies data. | Suite step passes; changing a script's output name makes it fail with the step ID |
| 11 | `workflow-consolidate`: one source for the client workflow | Replace `client-workflow.md`, `build-a-cv.md` and the lifecycle half of `pdf-workflow.md` with the model; reduce `new-client`/`new-cv` to step-ID pointers; fix the about 60 naming-drift items (inventory README, "Fixed without asking"); update `AGENTS.md`; delete `docs/workflow/inventory/`. | No second description of any step remains (grep checks); the skills still run a fictional client end to end |
| 12 | `workflow-guards`: scripts enforce the workflow's state order | Per decisions #2 and #8: a `ready` status for the `Text Draft`; `outputs.py stamp` refuses `approved` without a receipt, `delivered` without an approval (or export, per decision), and `signed-off` without the screenshot; rename Meta File kind `text-draft` (the concept) so it no longer collides with the client's `Text Draft`. Code change: `code-reviewer` round. Depends on task 2 only. | Tests for each refusal; schema updated; the suite passes |

### B. Restructure backlog from the 2026-10-04 audit (independent of A; the owner's "A+" goal)

| # | Id: outcome | Description |
|---|---|---|
| 13 | `core-neutral`: the Framework core holds no Flagship or marine rules | `core/pagination.typ` hard-codes synopsis, certificates and education rules and "vessel" wording; `core/primitives.typ` hard-codes the marine SVG palette; `core/page.typ` reads Flagship layout keys. Move them into Flagship; extend the boundary test beyond imports. |
| 14 | `fonts-strict`: no silent system-font fallback | Add `--ignore-system-fonts` to `tests/run.py` and `cv_workflow/render.py` compiles (only `design_review/server.py` has it); make `validate-theme` check that fonts exist. |
| 15 | `python-packaging`: `cv-workflow` is an installable, linted package | A `pyproject.toml` with pinned dependencies (pillow is unpinned in CI); drop the `sys.path` inserts; ruff; consider pytest for `tests/run.py` (bare asserts stop at the first failure and vanish under `-O`). |
| 16 | `ci-hardening`: CI pinned, checksummed, and covering Windows | Pin actions by SHA; checksum the Typst download; pip cache; a Windows job (the owner works on Windows; `build.ps1` is never run in CI); run once per change, not push plus PR. |
| 17 | `build-no-overwrite`: `build.ps1` obeys "scripts never overwrite" | `Copy-Item -Force` at `scripts/build.ps1:39` contradicts constitution rule 2; one shared example list instead of two (`build.ps1` and `run.py`). Consider porting to the TypeScript tooling. |
| 18 | `binaries-out-of-history`: release PDFs and PNGs stop growing the repository | The pack is about 52 MiB against a 28 MB tree; each release adds about 11 MB. Publish the `Release` PDFs and `docs/images` PNGs as GitHub Release assets or move them to LFS; dedupe the three fonts in `design-concepts/fonts/` vs `packages/cv-framework/fonts/`. Owner decision (it changes the `Release` location). |
| 19 | `agents-map-trim`: `AGENTS.md` is a map of under 800 words | Move the product pitch to `vision.md` and the Git and agent policy to `development.md`; link the constitution instead of copying six rules. |
| 20 | `work-records-out`: review reports leave the main tree | `docs/work/*/reviews` is two thirds of all docs. Move them to an orphan `records` branch or summarize them in the task's notes. Owner decision. |
| 21 | `review-proportional`: review effort scales with risk | One round by default; multi-round only for the frozen reference and the data contract (the Atlas alone took 18 reports). Owner decision: `docs/review.md`. |
| 22 | `retire-now-md`: remove `docs/now.md` | Retired, but it still holds the repo's only broken link; delete it and the audit exclusion in `.claude/repo-maintenance.md`. |
| 23 | `repo-layout`: fewer top-level folders and a clean `scripts/` | Group `brand/`, `design-concepts/` and `archive/` under one folder; move `scripts/design_review/` to `apps/design-review/`; one naming case per file type (`docs/conventions.md`); have `M/lib.typ` re-export themes, artwork and layouts so an example needs one import. Owner approves moves (`repo-maintenance apply`). |
| 24 | `legacy-removal`: the deprecated component layer has a removal date | 32 wrappers in `W/core/legacy.typ` and `F/legacy.typ` exist for "two private compositions"; `tests/fixtures/skills.typ` still uses them. Migrate the fixture and set a date. |
| 25 | `github-metadata`: the GitHub description matches the product | The repository description still reads "Three distinctive marine and mechanical engineer resume prototypes built with Typst". Owner act: repository settings. |

### Suggested order

Start with 1 and 2; they need no code. 3 and 4 follow, and the owner sees the
types. After that, 5 → 6 → 7 → 8 → 9 → 10 → 11; 12 can run beside them once 2
is done. Group B can be interleaved; 14, 17, 22 and 24 are small and safe.
