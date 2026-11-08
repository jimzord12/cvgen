# Plan review round 2: review-agents (reviewer B)

Snapshot: `archive/work-records/review-agents/plan.md` at 9929b69. HEAD moved to 5a9b9bd during the review, but plan.md is unchanged between the two commits. TASK-73 and TASK-74 are treated as built.

Blind map: code and agent files 9 · data and contracts 6 · tests 6 · generated outputs 6 · docs and context 13 · tooling and CI 5 · work in flight 6 · decisions 6. The full map is under "Impact map" below.

Checklist:
1. Impact: mostly covered. Misses the test-like files outside `tests/` (P3) and the collisions on `tests/run.py` (P2).
2. Fit: fits the goal, apart from the existing-suite part of the owner's words (P5).
3. Facts: `scripts/board.py` does not exist (P6). "Calls the check's function" is false for most of `run.py` (P2).
4. Compatibility: OK. D13 covers queued work.
5. Reversibility: n/a. Everything is docs and scripts and can be reverted.
6. Verification: OK. D14 sets the bars and the key is committed first.
7. Failure: a fault run inside the repository sees the outer Git state (P2).
8. Sequencing: `tests/run.py` is missing from the collision list, and the branch list is stale (P2, P9).
9. Unknowns: OK. The risks list questions 12 and 13 as unproven.
10. Decisions: D12 is listed for the owner. The scope that leaves the existing suite out is not (P5).
11. Proportion: there is a smaller way to change the Workflow Model (P7).
12. Procedures: the decomposition loop forks four ways (P1). The deliberate-fault routine forks (P2).
13. Model fit: the trigger vocabulary cannot classify real files (P3). The `Plan:` header line is in no template (P8).

Procedures walked:
- **Plan to Active (D8):**
  - No instruction for where a plan is committed before any task or branch exists.
  - No instruction for which checkout `plan_check.py` reads.
  - No instruction for which snapshot the decomposition-reviewer gets.
  - No instruction for a task added or re-scoped after PASS.
  - It only works for this plan because TASK-75 to 78 happen to be on this branch.
- **Deliberate fault (D5):**
  - Fails on inline cases (most of the suite).
  - Forks on Git state inside `builds/`.
  - Forks on an uncommitted snapshot.
  - Forks on network for `bun install`.
  - OK in pwsh 7.6: the pipe keeps raw bytes. Windows PowerShell 5.1 would corrupt the archive.
- **Task creation on `main`:** OK by the backlog skill's route. If the `Main Folder` is dirty, creation stalls, but that problem predates this plan.
- **T5, merge then regenerate:** OK. The handoff pitfall says which anchors base to use.
- **Codex pointers (D9):** the sandbox each pointer requests is unstated (P10).
- **Transition (D13):** the named tasks are being overtaken (P9).

## Findings

### P1 Material: the decomposition loop leaves four situations without instructions
Anchor: D8, D7. `.claude/skills/backlog/SKILL.md:116-131`, `docs/review.md:83-89`.

1. **Where the plan is committed.** A plan comes before its tasks, and a task gets its branch only when it goes Active. So a new plan has no branch to live on. `review.md` says "committed before each round" but not where.
2. **Where `plan_check.py` runs.** The tasks are created on `main`, often through a short-lived worktree that is removed right after the push. The script reads `backlog/tasks/` in the checkout it runs from. In the feature worktree the tasks are missing. TASK-76 AC 4 runs it on TASK-75 to 78, which exist on this branch, so the evidence would hide the problem.
3. **Which snapshot the decomposition-reviewer gets.** It needs the plan at a branch commit and the tasks at a `main` commit.
4. **A task added, split or re-scoped after PASS, or after a plan revision.** Nothing says whether `plan_check.py` and the decomposition round run again. A task already being worked on has its live copy on its branch, not on `main`.

Smallest fix: D8 names each of these: the plan's branch; "run `plan_check.py` in a checkout of `main` at the record commit" (or `--root`); the brief as plan@sha plus main@sha plus the task ids; and that a later change re-runs both on the changed ids only.

### P2 Material: D5's "one case" cannot run for most of the suite, and the fix collides with work in flight
Anchor: D5, Sequencing. `tests/run.py:159-260`, `packages/cv-workflow/cv_workflow/render.py:223-232`, `tests/workflow.py:112`.

- **Neither option works for most cases.** Most cases are inline statements in `main()` that use the closures `compile_case` and `check_case`. Only a few checks are functions (`check_frozen` and the module checks). So "call the check's function from a scratch script" fails for them.
- **The other option collides.** Case selection means restructuring `run.py`. `main` (Stage 1), `feat/contract-stage-2` and `feat/travel-domain` all edit that file. T3 also wires its tests into it. Yet Sequencing says T2 to T4 touch only agent files, docs and new scripts, and "go ahead".
- **Git inside the copy.** A copy under `builds/` sits inside the checkout's repository. `engine_state` reads the outer HEAD, and an engine with a planted fault looks clean because `builds/` is ignored. Placed outside any repository, the copy fails at `workflow.py:112` instead.
- **Uncommitted work.** `git archive` needs a commit, but `review.md` allows a patch snapshot.

Smallest fix:
- Decide now between case selection after those branches merge, and running the full suite in the copy for the inline cases.
- Name `tests/run.py` in Sequencing.
- State the Git caveat and that D5 needs a committed snapshot.

### P3 Material: the tests-reviewer's trigger cannot classify real files
Anchor: D12, the scope line in "tests-reviewer". `docs/glossary.md:53` on `main`, which defines `Coverage Fixture` at `packages/domains/<id>/fixtures/`.

- "Fixture" and "baseline" are each used two ways in the sources.
- These files are tests or fixtures in practice, but sit outside "the Python suite (`tests/`) and the Bun tests":
  - `templates/<t>/tests/coverage.typ`
  - Frozen References in `tests/approved/*.pdf`, which the owner changes
  - `tests/baseline.json`
  - `examples/release.json`
- `feat/travel-domain` adds more of each.
- An agent cannot tell whether a change to a `Coverage Fixture` or a new Frozen Reference triggers the gate, or what the reviewer judges in it.

Smallest fix: D12 lists by path what triggers the gate and what it judges, and says that the content of a Frozen Reference stays outside it.

### P4 Material: the revision did not reach the tasks
Anchor: D12, D8. TASK-75 AC 2, TASK-77's outcome.

- TASK-75 AC 2 still reads "or a behaviour change with no test change", which is the trigger before D12.
- TASK-77's outcome still uses the round-1 order ("... decomposition-reviewer, create tasks"). That contradicts its own AC 5 and D8.
- TASK-75 is the next task to go Active, well before T4, where the bootstrap note waits to revise tasks.

Smallest fix: edit both tasks on this branch now.

### P5 Material: the existing suite is left out without the owner's say
Anchor: "Not in scope", TASK-75 "Excludes rewriting existing tests".

- The owner's words include "how current ones need to be removed or fixed".
- The only look at today's tests is `tests/proposals.py`, used as a calibration run.
- This is probably his intent but not certainly; he may have meant current tests inside a change.

Smallest fix: queue one tests-reviewer pass over `tests/` and `tools/workflow/test/`, with removals under D6, or list the exclusion for the owner as a Major decision.

### P6 Minor: wrong precedent in D7
- `scripts/board.py` exists in no commit. The handoff says it was untracked in the `Main Folder`, and it is gone now.
- The only reader in the repository is `tests/repo_maintenance.py:59`, which handles flat keys only: no lists, no folded text.
- "Known to `backlog milestone list`" must mean reading `backlog/milestones/*.md`. CI installs no `backlog` CLI (`verify.yml:88-103`).

### P7 Minor: a smaller Workflow Model change was not weighed
`design.client-review` (`05-design/stage.yaml:233-240`) already names two reviewers in one step with one actor. Weigh that against the new actor, step, artifact, gate and loop, and choose with a reason.

### P8 Minor: the `Plan:` header line is in no template
- TASK-73 to 78 carry a `Plan:` header line, which decomposition rubric item 1 relies on.
- It is in neither `development.md:206` nor D7.
- That file's task-record table also labels the Implementation Plan field **Plan**, so the word has a third use.

### P9 Minor: Sequencing and D13 are stale
- `feat/template-contract` merged (9a7c4bd) one minute before revision 2 was committed.
- During this review, `feat/hanami-essential` (TASK-79, whose task file is modified and uncommitted) and `feat/travel-contract-v2` (TASK-80) appeared, both stacked on `feat/travel-domain`.
- D13's claim that TASK-79 to 81 "will need a plan" may not hold. Phrase it by each task's state at the merge.

### P10 Minor: D9 does not say which sandbox each Codex pointer requests
The tests-reviewer's TOML needs workspace-write for its `builds/` copy, and network for `bun install`. `.codex/README.md` says read-only roles request a read-only sandbox.

### P11 Note: smaller items for later
- Rubric item 6 (parallel safety) needs a map of which task touches which file. The plan template has no such column.
- `development.md`'s Stage table "Review" row and `review.md:199-200` (the list of reviewers on Opus) are not named in the Changed table.

## Impact map
(C = covered, M = missed by the plan)

- **Code and agents:**
  - C: the three agents, the two skills, `.codex` TOMLs and README, `code-reviewer.toml`.
  - M: the sandbox per pointer (P10).
- **Data and contracts:**
  - C: frontmatter against header dependencies, virtual milestones, cross-milestone dependencies, report paths.
  - M: the `Plan:` header (P8); where a plan is committed (P1).
- **Tests:**
  - C: `tests/plan_check.py` and its fixtures; Bun tests.
  - M: inline cases in `run.py`; Git-dependent assertions; Coverage Fixtures, `coverage.typ`, Frozen References, `release.json` (P2, P3).
- **Generated outputs:**
  - C: the Atlas pages, the lock, client-journey, Workflow Model anchors and step.
- **Docs and context:**
  - C: `review.md`, `development.md`, `conventions.md`, `verification.md`, glossary, backlog, new-cv and new-theme skills, the handoff, `repo-maintenance.md`, ADR 0018 (still free on every branch), history.
  - M: the Stage table row (P11).
- **Tooling and CI:**
  - C: ruff, `bun run anchors`, `atlas.py check`.
  - M: no `backlog` CLI in CI (P6).
- **Work in flight:**
  - C: contract-stage-2, travel-domain, `main`'s drift.
  - M: `run.py` collisions; hanami-essential and travel-contract-v2 (P2, P9).
- **Decisions:**
  - C: Opus at high, read-only, D12 listed, D5's exception, two reviewers.
  - M: the existing-suite scope (P5).

Round 1: P1 to P11 are each answered in substance. Gaps left inside those answers: P1's order (P1 here), P4's single case (P2), P11's AC (P4).

## Facts checked
| Claim | Result |
|---|---|
| `scripts/board.py` exists | false |
| No YAML dependency in the lock files | true |
| `repo-maintenance.md:149-151` is stale | true |
| AGENTS.md is 797 words | true |
| The Atlas pages named in T5 exist | true |
| ADR 0018 is free on every branch | true |
| TASK-79 to 81 are Queued on `main`, and TASK-81's header disagrees with its frontmatter | true |
| A Workflow Model step has optional `when` and one actor | true |
| `run.py` cases are functions | false, mostly inline |
| CI installs the `backlog` CLI | false |
| pwsh is 7.6 | true |
| `tar` and `bun` are on PATH; ruff is absent | true |

## Limitations
- `bun run anchors` was not run.
- The calibration reports were not read.
- `private/` was not read.
- New branches appeared during the review.
- I ran as a general-purpose agent following the definition.

## Verdict: FINDINGS
