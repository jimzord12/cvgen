# Plan: review-agents — a plan-reviewer, a decomposition-reviewer and a tests-reviewer

Status: agreed with the owner 2026-11-08 in direction; revised in place on
`feat/review-agents` until its plan review passes (D2), then kept unchanged.
Revision 2 answers plan review round 1 (`reviews/07-plan-reviewer.md`); the
finding each change answers is named in brackets, P1 to P11.

## Outcome

Three fresh-context review gates join the four everyday ones:

| Agent | Reviews | Runs when |
|---|---|---|
| `plan-reviewer` | A plan, before its tasks are created: gaps, blast radius, procedures, model fit, future problems | Work of more than one task, a contract or migration, anything hard to undo, or the owner asks for a plan |
| `decomposition-reviewer` | The plan's split into `Milestone`s and tasks, created as Queued | Every reviewed plan that becomes tasks, after `plan_check.py` passes and before the first of them goes Active |
| `tests-reviewer` | Whether tests test real behaviour, and which are missing or should go | A change that adds, edits or deletes a test, fixture or baseline, including tests written because a `code-reviewer` found a behaviour change with no test (D12) |

All three: Opus at high (the owner's standing choice for reviewers, 2026-09-26),
read-only apart from what D5 allows the tests-reviewer under `builds/`, fresh
every round, never a fork, verdict PASS / FINDINGS / INCOMPLETE, round caps 5
attended / 10 unattended, reports stored verbatim as
`archive/work-records/<slug>/reviews/NN-<reviewer>.md`.

**Not in scope:** the work-board mod; the owner decision queue (P-0020); a
separate decomposer agent (D8); running the new gates on work already done
(the transition rule, D13, says what "done" means).

## Sequencing [P5]

- **Built:** TASK-73 (Ready) and TASK-74 (in review). TASK-74's edits moved
  `docs/review.md` lines the `Workflow Model` cites; re-anchored on this branch
  (6452dec) with `bun run anchors 9b06670 --fix` and the edited span by hand.
- **In flight on other branches, all touching files this plan touches:**
  `feat/template-contract` (14 ahead of `main`), `feat/contract-stage-2`
  (stacked on it, 17 ahead) and `feat/travel-domain` (14 ahead). All three
  change `docs/workflow/*/stage.yaml`, `catalog.yaml`, the generated `Atlas`
  pages, `docs/engine/verification.md`, `docs/glossary.md`,
  `.claude/skills/new-cv/SKILL.md` and `tests/run.py`.
- **`main` has moved** since this branch's base (9b06670): the owner's answers
  of 2026-11-08 and TASK-79 to TASK-81, Queued.
- **Order.** T2 to T4 touch only agent files, skills, `docs/review.md`,
  `docs/conventions.md`, `docs/engine/verification.md` and new scripts; they go
  ahead. T5's `Workflow Model` and `Atlas` part waits until those three
  branches have merged into `main`. Before T5 and before this branch merges:
  merge `main` into it, then **regenerate, never hand-merge**, the generated
  files (`bun run anchors <base> --fix`, the edited spans by hand, `bun run
  render`, `bun run atlas`, then the stamps), because `atlas.data.js`,
  `atlas.lock.json`, `client-journey.json` and the README blocks are outputs.

## Decisions (Major; decided, listed for the owner)

- **D1. Placement by four questions (owner, 2026-11-08).** The questions, in
  their reviewed wording, live in `.claude/agents/context-maintainer.md`,
  "Where things live" (TASK-73); in short: an agent's own job → its file;
  repository-specific → the owning document or CVgen skill; working with the
  owner → preferences; a generic method or one activity's convention, his own
  cross-project ones included → that activity's skill when more than one agent
  does or checks it, else the agent file. For this work:
  - **`plan` skill** (built in T1, extended in T4, generic): the plan template,
    the impact map, the plan checklist (thirteen questions), the decomposition
    checklist and the loop.
  - **`test-principles` skill** (T2, generic): what makes a test worth keeping,
    including D6.
  - **CVgen-specific:** gates, triggers, briefs, caps and storage in
    `docs/review.md`; the impact items peculiar to this repository in
    `docs/review.md`, "Plan review"; the task template in `docs/development.md`;
    what this suite's checks must do, and that frozen-reference checks are
    never removed through D6, in `docs/engine/verification.md` [P8].
  - **Agent files:** each reviewer's own procedure only.
  - **Codex counterparts** point to the Claude agent file and the skills
    instead of copying them, a new pattern `.codex/README.md` must describe
    (D9) [P7].
- **D2. A plan is a file with an identity.** `archive/work-records/<slug>/plan.md`,
  committed before each round; revised in place until PASS.
- **D3. Tools:** Read, Grep, Glob, Bash, PowerShell for all three; the shell
  for reading and for checks that write only under `builds/`.
- **D4. Blind first pass (plan-reviewer).** Built in T1.
- **D5. Deliberate faults (tests-reviewer)** [P4]. For a test whose value is in
  doubt:
  - **The copy:** `git archive <snapshot> | tar -x` into a new
    `builds/tests-review-<timestamp>/`. It holds tracked files only: no
    `private/`, no `builds/`, no `.worktrees/`, and no change to Git's state.
  - **The fault:** the reviewer edits the behaviour the test claims to guard,
    in that copy only, and records the edit as a diff in its report.
  - **The run:** one case, not the suite. T2 reads `tests/run.py` and either
    adds a way to select a case, or the reviewer calls the check's function
    from a scratch script in the copy; T2 records which, and it is reviewed as
    code. A Bun test needs `node_modules`: the reviewer may run `bun install
    --frozen-lockfile` inside the copy only; if that fails, the fault is
    reported INCOMPLETE, never guessed.
  - **The boundary:** `docs/review.md`, "Reviewer boundaries", gains this as
    the one exception to source-read-only. The copy stays in `builds/` as
    evidence; clearing `builds/` remains the lead's decision.
- **D6. Removal needs a reason.** A test is removed only by naming what it
  fails to catch (with a deliberate fault as evidence) or the test that already
  catches the same faults. In the `test-principles` skill. A check of a frozen
  reference is never removed this way [P8].
- **D7. A script checks what has an exact answer** [P1, P2]. `scripts/plan_check.py
  TASK-N [TASK-M ...]` takes the plan's task ids, not a milestone, so a
  milestone's Done and Trello-era tasks never block it. For each listed task:
  - it exists and is not Done; it names a milestone id that `backlog
    milestone list` knows (Backlog.md #919 makes virtual ones silently);
  - the title is `<slug>: <outcome>`; the description has the header (Owner,
    Branch/worktree, Integration target, Depends on) and an "Outcome and
    boundaries" section; at least one acceptance criterion;
  - **dependencies:** the frontmatter `dependencies:` list is the source; every
    id in it exists; the header's "Depends on" names the same task ids (other
    text there, such as a decision, is allowed); the graph over the listed
    tasks and their dependencies has no cycle; a dependency outside the plan
    or in another milestone is allowed and reported.
  - **Parsing:** standard library only, a frontmatter reader for the shapes
    Backlog.md writes (scalars, `>-` folded text, `- ` lists), as
    `scripts/board.py` does; no YAML package, so `pyproject.toml` and
    `requirements.lock` do not change.
  - **Tests:** fixtures only, wired into `tests/run.py`; the suite never checks
    the live backlog, so a later malformed task cannot break CI.
- **D8. A `plan` skill, not a decomposer agent** (owner agreed, 2026-11-08).
  **The loop, in an order that can run** [P1]: write the plan → plan-reviewer
  until PASS → decompose → create the milestone if new and the tasks as Queued
  on `main` (record-keeping, the backlog skill) → `plan_check.py` on their ids →
  decomposition-reviewer until PASS → the first task may go Active. Fixes to
  tasks between rounds are task-store edits on `main`.
- **D9. Codex counterparts for all three, as pointers** [P7]. Each TOML tells
  Codex to read the Claude agent file and the skills, and copies none of
  their rules. `.codex/README.md` changes accordingly: its claim that every
  counterpart preserves the source's brief and rubrics becomes "existing
  counterparts copy; reviewers added from 2026-11-08 point". Its counts are
  corrected. **A Codex verdict is advisory and never satisfies one of these
  gates**, as for `code-reviewer`.
- **D10. `code-reviewer` keeps lens 5.** When a tests-reviewer ran on the same
  snapshot, the code-reviewer may rely on its report for test quality and says
  so. `.codex/agents/code-reviewer.toml`, which copies lens 5, gets the same
  sentence [P8].
- **D11. Milestone m-8, "Agent-ready repository".**
- **D12. The tests-reviewer's trigger is narrower than first planned** [P11].
  It runs when a change adds, edits or deletes a test, fixture or baseline.
  Spotting a behaviour change with no test stays with the `code-reviewer`
  (lens 5, which already asks whether "tests can detect the relevant
  defect"); the tests written in answer go to the tests-reviewer. A second
  reviewer on every code change was the first plan; this keeps the new gate
  where it adds judgement. **Listed for the owner:** he may widen it.
- **D13. Transition** [P5]. The gates apply to plans whose tasks go Active,
  and to changes reviewed, after this branch merges into `main`. Work Active,
  in Review or Ready at the merge finishes under the rules it started with.
  Named: TASK-79, TASK-80 and TASK-81 (Queued, more than one task between them)
  will need a plan and its plan review before the first goes Active;
  `feat/contract-stage-2`'s new tests are reviewed by the tests-reviewer only if
  the branch is still before its code review when this merges. The session
  handoff says so.
- **D14. Bars for the known-answer runs** [P6]. Before each run its answer key
  is committed, as ddebe24 did. The lead records the score and decides with a
  reason; a score under half of the key needs either a named change to the
  skill or agent, or a stated limitation in the task. A run that uses tasks
  from before the template (TASK-63 to TASK-68) skips `plan_check.py` and says
  so.
- **D15. An ADR and a history entry** [P11]. ADR 0018 records the three gates,
  the two skills, the placement questions and D12, with ADR 0017 as the
  precedent for a workflow change; `docs/history.md` gets its entry. Both in T5.
- **D16. Two plan-reviewers for this plan's next round** [P9]. The gates are a
  contract all later work depends on, which `docs/review.md` counts as hard to
  undo.

## The rubrics

The plan-reviewer's rubric is the `plan` skill's checklist (thirteen questions)
and the repository's impact items in `docs/review.md`, "Plan review"; it is not
restated here [P10].

### decomposition-reviewer (after `plan_check.py` passes; generic parts to the `plan` skill)
1. **Traceability both ways:** every part of the plan has a task; every task
   traces to the plan.
2. **One outcome per task,** with its boundaries.
3. **Acceptance criteria** are observable and name their evidence; none needs
   an act an agent cannot perform without saying who performs it.
4. **Size:** each task fits one branch and one review loop.
5. **Dependencies make sense:** every real ordering is a dependency, including
   a review gate built by another task; no dependency is invented.
6. **Parallel safety:** tasks meant to run together touch no shared file,
   generated outputs included.
7. **Milestone:** its done-condition is reached by its tasks.
8. **Gates and tests named** for each task.
9. **Owner-blocked tasks** carry `blocked` and the unblock condition.
10. **Project rules:** the task template, where task changes go, integration
    targets (CVgen's, in `docs/development.md`).

### tests-reviewer (generic parts to the `test-principles` skill)
Sources: Kent Beck's Test Desiderata; Software Engineering at Google, ch. 12;
Google's "Change-Detector Tests Considered Harmful"; reports of agents
weakening assertions, editing fixtures to pass and gaming coverage.
1. **Behavioural:** through a real entry point, not internal calls.
2. **Can fail:** it fails when the behaviour breaks (D5); no tautology, no
   comparison with output the test itself regenerates.
3. **Structure-insensitive:** it survives a refactor that keeps the behaviour.
4. **Specific:** its failure message points at the cause.
5. **Deterministic and isolated.**
6. **Honest changes:** no deleted or weakened assertion, no skip, no fixture or
   baseline changed without a reason the change requires.
7. **Not duplicated.**
8. **Missing tests:** each behaviour the change touches has a test for its
   likely faults.
9. **Removal with a reason** (D6).
10. **Cost:** a slow test earns its time.
Applies to the Python suite (`tests/`) and the Bun tests in `tools/workflow/`.

## Files

### New
| File | What | Task |
|---|---|---|
| `.claude/agents/plan-reviewer.md`, `.claude/skills/plan/SKILL.md` | Built | T1 |
| `.claude/skills/test-principles/SKILL.md` | Generic test principles, D6 | T2 |
| `.claude/agents/tests-reviewer.md` | Its procedure, D5 | T2 |
| `scripts/plan_check.py`, `tests/plan_check.py`, fixtures under `tests/fixtures/plan_check/` | D7 | T3 |
| `.claude/agents/decomposition-reviewer.md` | Its procedure | T4 |
| `.codex/agents/{plan,decomposition,tests}-reviewer.toml` | Pointers, D9 | T5 |
| `docs/decisions/0018-review-gates-for-plans-and-tests.md` | D15 | T5 |

### Changed
| File | Change | Task |
|---|---|---|
| `docs/review.md` | "Plan review" (built); the tests gate and its trigger (D12); "Reviewer boundaries" gains D5's exception; the decomposition gate and the loop (D8); D10 under lens 5 | T1, T2, T4 |
| `docs/development.md` | The planning paragraph points to the gate (built in T1); the loop's order (D8); roles list and file map; the transition (D13) | T1, T4, T5 |
| `docs/engine/verification.md` | This suite's test rules, frozen references never removed through D6, how one case runs (D5) | T2 |
| `docs/conventions.md` | "Tests": the CVgen-specific rules stay, the generic ones move to the skill, a pointer | T2 |
| `tests/run.py` | Case selection, if T2 chooses it (D5) | T2 |
| `docs/glossary.md` | `Plan` (the plan file, as distinct from its source and from a task's Implementation Plan field) and `Impact Map` now, because T1's text already uses them (glossary Rule 4) [P10]; `Deliberate Fault` with T2 if its text keeps the term | T1, T2 |
| `.claude/skills/backlog/SKILL.md` | Tasks from a plan: created Queued on `main`, none Active before the decomposition review (D8) | T4 |
| `.claude/skills/new-cv/SKILL.md`, `.claude/skills/new-theme/SKILL.md` | Their gate lines name the tests-reviewer where a test, fixture or `baseline.json` changes [P8] | T5 |
| `.codex/README.md`, `.codex/agents/code-reviewer.toml` | D9, D10 | T5 |
| `.claude/repo-maintenance.md` | Line 150's stale note on the agent-context owners [P11] | T5 |
| `docs/workflow/catalog.yaml`, `docs/workflow/05-design/stage.yaml` | [P3] A tests-reviewer in `design.engine-review` needs a new actor, a step with an agent action, its report artifact, a gate and a revise loop, since a step is one actor doing one action (`tools/workflow/src/model.ts`); plus the anchors every move needs; then render and atlas. Under D12 the step fires only when the engine change touches tests | T5 |
| `docs/workflow/05-design/README.md` (generated blocks), `.atlas/src/pages/client-journey.json`, `.atlas/atlas.data.js`, `.atlas/atlas.lock.json` | Regenerated, never edited | T5 |
| `.atlas/src/site.json`, `.atlas/src/pages/{change-review,roster,design-run,system-map}.json` | Roster entries; the change-review flow gains plan, decomposition and tests gates; every cited line in `docs/review.md` and `docs/development.md` re-checked; stamped | T5 |
| `docs/history.md` | D15 | T5 |
| `backlog/docs/doc-1 - session-handoff.md` | New gates and the transition (D13); drop the "more than three agents" pitfall (owner, 2026-11-08) | T5 |
| `AGENTS.md` | Nothing: "Which reviewer gates which change: `docs/review.md`" already points there; it is at 797 of 800 words | — |

## Tasks (milestone m-8)

```
T0 TASK-73 ─► T1 TASK-74 ─► T2 TASK-75 tests-reviewer ─► T3 TASK-76 plan_check.py ─► T4 TASK-77 decomposition-reviewer
                                                                                              │
           (template-contract, contract-stage-2, travel-domain merged into main) ──► T5 TASK-78 the welcome
```

| Task | Gate | Evidence |
|---|---|---|
| **T0** TASK-73 | context-reviewer | Ready, round 4 PASS |
| **T1** TASK-74 | context-reviewer | Three calibration runs (`calibration/`); this plan reviewed; the glossary terms |
| **T2** TASK-75 | context-reviewer; code-reviewer if `tests/run.py` changes | Known-answer runs, key committed first (D14): a seeded tautological test and a seeded change-detector test in a `builds/` copy are flagged, each by a deliberate fault; `tests/proposals.py` reviewed for real |
| **T3** TASK-76 | code-reviewer and tests-reviewer | Suite and ruff pass; fixtures with a cycle, a missing dependency, a header that disagrees with the frontmatter and a virtual milestone each refused; the script on TASK-75 to TASK-78 |
| **T4** TASK-77 | context-reviewer | Known-answer run on the P-0019 split (TASK-63 to 68), key committed first, `plan_check.py` skipped there (D14) |
| **T5** TASK-78 | context-reviewer; code-reviewer for the `Workflow Model` | `bun run anchors <base>`, `check`, `render`, `atlas`, `bun test`, `python .atlas/_kit/atlas.py check` clean, suite, ruff |

**Bootstrap, honestly:** this plan's tasks existed before the plan review; its
split is reviewed by the decomposition-reviewer only once T4 has built it, and
the tasks TASK-75 to 78 are revised then if it finds gaps.

## Risks

- **Review churn:** narrower triggers (D12), the script for exact checks, the
  round caps.
- **Rubric drift:** D1; the context-reviewer checks restatement.
- **The reviewer is not deterministic** (calibration 01 against 02): two
  plan-reviewers for plans that are hard to undo.
- **Questions 12 and 13 were added after seeing their answer keys** and are
  unproven until a later plan exercises them.
- **The in-flight branches** (Sequencing) merge before T5; their order is
  theirs, not this plan's.
- **`ruff` is not installed on this machine:** install it before T3.
