# Calibration 03: plan-reviewer on the Workflow Model plan (held out)

Run 2026-11-08. Definition and skill at c7389f6 (twelve questions), run as a
general-purpose Opus agent following `.claude/agents/plan-reviewer.md`, against
a detached checkout of f4af2c1. The plan: P-0017, the handoff's section 3 and
TASK-33 to TASK-44 as they were then. Neither the lead nor the reviewer had
read the later reviews; the answer key (`03-answer-key-workflow-model.md`) was
built by a separate agent during the run and committed (ddebe24) before this
report arrived.

**Score** (found / partly / missed, against the key's 11 items):

| # | Item | Result |
|---|---|---|
| 1 | "external" means two things | missed |
| 2 | Gates are pass/fail only | missed |
| 3 | "Edges are derived, never written" breaks | missed |
| 4 | No place for refusals; the model cannot replace the guides | partly (P5 no home for non-step content; P8 refusals live twice) |
| 5 | Anchors drift; no sequencing against the restructure tasks | found (P3, P7) |
| 6 | Owner decisions did not cover running unattended | missed |
| 7 | Level 3 assumed the scripts work in a temporary Envelope | missed |
| 8 | TASK-41 did not name the Atlas page's consumers | partly (P4: kit, site.json, system-map.json, determinism; not the status panel, the Session Sweep line or `/atlas refresh`) |
| 9 | Guards say nothing about existing records | found (P1, Blocking: reference.pdf, the 8 delivered revisions) |
| 10 | Checks an unattended agent cannot run | found (P10) |
| 11 | Inventory deleted without a check | partly (P5) |

3 found, 3 partly, 5 missed: about 40%. Beyond the key, plausible real
findings: the `text-draft` rename's unnamed files (P1), a suite with no rule
for a missing Bun (P6; CI later gained Bun), about 30 inbound links to the
guides (P5).

**Diagnosis.** Items 1, 2, 3 and 6 share one class: the plan introduced a
model (a schema of steps, gates, edges, caps) and nobody encoded the hardest
real cases in it before building: a decision with three outcomes, an edit in
place that makes a cycle, a step with no inputs, one word with two meanings,
a field the sources do not hold. Item 7 is checklist question 9 (a
load-bearing assumption untested where a small experiment would settle it).
**Change:** the plan checklist gains question 13, "Model fit", added after
seeing this key, so this run's 40% stands as the measured score and question
13 is unproven until a later plan exercises it.

The report, verbatim:

---

# Plan review round 1: workflow-model

**Verdict: FINDINGS.** 1 Blocking, 6 Material, 3 Minor, 1 Note.

Snapshot: `docs/proposals/workflow-model.md` (P-0017), `docs/work/workflow-model/handoff.md` section 3 (and the section 4 table the tasks are copied from), and `backlog/tasks/task-33` to `task-44`. All read at `f4af2c1` (2026-10-14 08:22), in the detached checkout `km-workflow`.

Blind map (built before reading the plan): code 7, data and contracts 6, tests 4, generated outputs 5, docs and agent context 16, tooling and CI 4, work in flight 8, people and decisions 5.

**Checklist**
1. Impact: the plan misses the files that link to the guides, the Design Review app, the Atlas `site.json` and `system-map.json`, and the fixtures in `tests/design_review.py` (P2, P4, P5).
2. Fit: matches the goal and the vision. The guards would break a home documented by the `Output Contract` (P1).
3. Facts: mostly true. The handoff marks "replace, not add" as still open, but the proposal states it as agreed (P9).
4. Compatibility: fails for the `reference.pdf` home and for the 8 revisions of `client-2026-09-01`, which are `delivered` but were never exported (P1).
5. Reversibility: everything is in Git. The only irreversible work is the migration of real clients, and that belongs to TASK-32, not this plan.
6. Verification: three acceptance criteria cannot be observed by an agent (P10).
7. Failure: no rule for a suite run on a machine without Bun (P6). No rule for a screenshot that is not a PNG with the expected name.
8. Sequencing: collides with TASK-32, TASK-52, TASK-31/55, TASK-47 and TASK-48 (P3).
9. Unknowns: whether the Atlas output can be regenerated deterministically was never tested, and it cannot be today (P4).
10. Decisions: owner decisions #1, #3, #7 and #9 have no task that applies them, and #2 and #8 have no doc change before TASK-43 (P2). "Replace, not add" needs the owner's answer recorded (P9).
11. Proportion: the owner chose the toolchain. The order of states is written twice, once in the YAML gates and once in the Python guards (P8).
12. Procedures: walked below.

**Procedures walked**
- **Change a step** (edit YAML, run `check`, run `render`, commit, run the suite, regenerate and stamp the Atlas). It forks on a machine without Bun (a fresh machine, a cloud session, Codex); nothing says what happens. Two branches that edit the model will conflict in the generated blocks; nothing says to regenerate after the merge. Nothing says whether a generated Atlas page still needs `atlas.py stamp`.
- **Text Draft** (`ready`, then `sent`, then `signed-off`). Until TASK-43 lands, the skill still says to stamp `sent` at compile. It forks when the screenshot is a JPG or has another name.
- **Approve, export, write delete-by, stamp `delivered`.** It forks on `reference.pdf`, which can never have an `Export`, and on Meta Files already `delivered` with no `Export`. Nothing says who writes the "Exported, delete by" line: the script or the lead.
- **One Backlog task per `Alias`** (decision #7). The three existing clients have none, and no task creates them.
- **Level 3 against a real `Envelope`.** It must run from the main folder, because the session handoff warns that render refuses an `Envelope` reached through a junction. A cloud session has no `private/`. Nothing says where the run's output goes.

## Findings

### P1 Blocking: the TASK-44 guards break a documented home and existing data
Anchor: TASK-44; `cv_workflow/outputs.py:47-48, 101-133`; `docs/pdf-workflow.md:129`; `tests/design_review.py:42,57-60`.
- **The home.** `private/<envelope>/reference.pdf` is "a CV delivered before `cv.py`". Its status is `delivered` and it can never have an `Export`. "Stamp refuses `delivered` without an `Export`" makes this home impossible to stamp.
- **Existing data.** `client-2026-09-01` has 8 revisions stamped `delivered` with no `Export` (proposal, decision #1). The earlier Meta File feeds every new stamp, so any re-stamp of these files is refused.
- **Tests.** The fixture in `tests/design_review.py` stamps `signed-off` with no screenshot and `reference.pdf` as `delivered`.
- **The `text-draft` rename** needs migration in files the task does not name:
  - `design-concepts/2026-09-27-first-fitting/concept.meta.json`
  - `scripts/design_review/server.py:53-57`
  - `scripts/design_review/index.html:194`
  - `tests/design_review.py:42,125`
  - `docs/pdf-workflow.md:126,140`
  - `design-concepts/README.md:47`

Smallest fix: the guard runs only when the status changes in `stamp`, never in `validate()` or `load()`. Exempt `reference.pdf`, and say explicitly that Meta Files stamped before the guard stay valid. List the files the rename migrates. Add the fixture changes.

### P2 Material: decisions with no task to apply them, and docs that lag the guards
Anchor: proposal decisions #1, #3, #7, #9; TASK-44.
- TASK-44 changes behaviour that is written in `new-client` step 8, `client-workflow.md` section 8 and `pdf-workflow.md:128`. Nothing updates those files until TASK-43, which comes last.
- Decision #1: no task says who writes the delete-by line (the export script or the lead).
- Decision #3: no task gives the keep field a schema or a reader. `ENVELOPE_FIELDS` ignores it today, at `outputs.py:19`.
- Decision #7: no task creates the per-alias tasks for the three existing clients.

Fix: TASK-44 updates the docs and the skill it contradicts. Name the task that applies each of #1, #3 and #7, and put the records for existing clients in its scope.

### P3 Material: sequencing collisions with queued work
Anchor: the proposal ("run in dependency order"); TASK-32, TASK-52, TASK-31, TASK-55, TASK-47, TASK-48.
- **TASK-32** moves `cv.typ` to `typst/` and the portrait. It changes `cv.py`, and its criterion #3 writes into the guides and skills that TASK-43 removes. TASK-37 would encode paths that TASK-32 then moves.
- **TASK-52** moves `docs/work/`. Every task cites `docs/work/workflow-model/handoff.md`, and TASK-33 stores its report there.
- **TASK-31 and TASK-55** rename paths that the level-1 check will assert exist.
- **TASK-47** rewrites `tests/run.py` and the `sys.path` setup, as TASK-38 and TASK-42 do.
- **TASK-48** rewrites `verify.yml` and adds a Windows job that would also need Bun.
- None of these has a dependency on the workflow-model chain.

Fix: add the dependencies (TASK-32 before TASK-37; decide the order of TASK-52; TASK-48 after TASK-38 or install Bun itself), or state who updates the model on each move.

### P4 Material: TASK-41's design does not fit the Atlas kit
Anchor: TASK-41; `.atlas/_kit/atlas.py:1-5, 344-346`; `.atlas/README.md`.
- The kit is generic ("no repository facts live here"), and `sync-kit` overwrites it. Porting the Atlas build to TypeScript forks the kit.
- `atlas.data.js` embeds `builtAt` and HEAD, so the design's rule "CI regenerates and fails on any diff" can never pass.
- Criterion #3 ("old page data deleted") contradicts the task's other option of feeding the existing page format.
- `site.json` (for example line 299) and `system-map.json` also describe workflow steps, and no task covers them.

Fix: generate `src/pages/client-journey.json` from the model with a generator in this repository and leave the kit untouched. Define what the CI diff check excludes. Bring `site.json` and `system-map.json` into scope.

### P5 Material: TASK-43 leaves about 30 broken links and has no home for non-step content
Anchor: TASK-43. About 30 tracked files link to `client-workflow.md` or `build-a-cv.md`, including:
- `docs/glossary.md` (9 links), `docs/framework-gaps.md`, `README.md`, `brand/README.md`
- `docs/reference/*`, `docs/research/README.md`, `packages/cv-workflow/README.md`
- the message text in `workspace.py`, `scripts/intake-form.gs`, `scripts/text-draft.typ`
- `.claude/agents/context-maintainer.md`

Only `AGENTS.md` is named. The task also does not say where three things go: the delete-by history-erase commands the owner runs (guide section 9), the Scout brief, and the skill's "Report to the owner". "Grep checks" is not defined. Fix: list the files that link in and their new targets, the exact grep, and the new home of each of those three pieces.

### P6 Material: Bun becomes required by the suite, with no rule for a missing Bun
Anchor: TASK-35, TASK-38; `.github/workflows/verify.yml` (Python only); `docs/tech-stack.md` (Node is there for Backlog, Bun is not).
- Nothing says what `tests/run.py` does when `bun` is missing.
- Nothing pins the Bun version and the lockfile in CI, or updates the `verify-cv` skill.

Fix: `tests/run.py` fails loudly with an install hint. Pin Bun in `tech-stack.md` and CI. Update `verify-cv`.

### P7 Material: the source anchors stop resolving after TASK-43
Anchor: TASK-37 criterion #2 against TASK-43. The model's anchors point into the guides that TASK-43 deletes. If level 1 checks the anchors, TASK-43 fails the suite. If it does not, the anchors rot. Fix: pin them as provenance (`git:<sha>:path`, which the Atlas already accepts), or drop them at consolidation. Say whether they are checked.

### P8 Minor: the order of states lives twice
The YAML gates and the Python guards in `outputs.py` both encode it. TASK-42 should fail when a gate has no matching refusal.

### P9 Minor: "replace, not add" is not recorded as answered
The handoff (lines 212-221) lists it as a pushback still open. The proposal states it as the agreed design. Record the owner's answer before TASK-43 deletes the guides.

### P10 Minor: three criteria an agent cannot observe
"Validates in VS Code" (TASK-36), "diagrams render on GitHub" (TASK-39) and "the skills run a fictional client end to end" (TASK-43, which needs owner and client acts). Name a scripted proxy for each.

### P11 Note
TASK-33 does not serve this goal. TASK-42's real-`Envelope` mode should only print, or write inside `private/`, never to `builds/`.

## Impact map
- **Code.**
  - Covered: `cv.py`, `outputs.py stamp`, `output.schema.json`, the new engine.
  - Missed: the Design Review app (`server.py`, `index.html`), the message in `workspace.py`, `intake-form.gs`, `text-draft.typ`.
- **Data.**
  - Covered: the Meta File statuses.
  - Missed: `reference.pdf`, the 8 Meta Files `delivered` with no `Export`, the concept Meta File, the keep field in `envelope.json`.
- **Tests.**
  - Covered: `run.py`, `workflow.py`.
  - Missed: the fixtures in `tests/design_review.py`.
- **Generated.**
  - Covered: the Atlas client journey.
  - Missed: `site.json`, `system-map.json`, `atlas.lock.json`, the non-deterministic `atlas.data.js`.
- **Docs.**
  - Covered: both guides, `pdf-workflow.md`, both skills, `AGENTS.md`, `tech-stack.md`.
  - Missed: glossary, `framework-gaps.md`, the reference docs, `README.md`, `brand/README.md`, `context-maintainer`, `verify-cv`.
- **Tooling.**
  - Covered: `verify.yml`.
  - Missed: pinning Bun, a missing Bun.
- **In flight.**
  - Missed: TASK-32, 52, 31, 55, 47, 48.
  - Excluded on purpose: TASK-2 (travel domain).
- **Decisions.**
  - Covered: #2, #8.
  - Missed: who applies #1, #3, #7, #9.
  - Open: "replace, not add".

## Facts checked
| Claim | Where verified | Result |
|---|---|---|
| Only render, approval and export are enforced | `cv.py`; `render.py` also refuses without `envelope.json` | True |
| `cv.py` and `outputs.py` have argparse `--help` | both scripts | True |
| The `text-draft` kind collides with the client's `Text Draft` | `output.schema.json:10,32` | True |
| TASK-44 depends only on TASK-34 | its front matter | True |
| The chain from TASK-35 to TASK-43 matches the handoff | task front matter | True |
| A "Fixed without asking" section exists | inventory `README.md:84` | True |
| The code anchors in `c-catalog` need re-anchoring | the inventory says so itself | True |
| `tools/workflow/` and Bun exist at `f4af2c1` | the checkout | Neither exists; CI is Ubuntu with Python only |
| The Atlas builds deterministically | `atlas.py:344-346` | False |

## Limitations
- I did not read `private/`. The claim about the 8 revisions rests on the proposal and the session handoff.
- I could not see which branches existed at `f4af2c1`. Today's branches all branch off after it.
- I did not verify that Bun 1.4.2 existed (no network).
- A Windows long-path error blocks working-tree reads of TASK-32's file; I read it through `git cat-file`.

## Verdict: FINDINGS
