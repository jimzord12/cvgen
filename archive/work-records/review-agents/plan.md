# Plan: review-agents — a plan-reviewer, a decomposition-reviewer and a tests-reviewer

Status: **plan review PASS, round 5** (2026-11-08; two reviewers,
`reviews/12-plan-reviewer-a.md` and `-b.md`). Kept unchanged from here (D2),
apart from the "Carried into the tasks" section at the end, which records the
round's Minor findings for the tasks that apply them.
Revision 5 answers round 4 (`reviews/11-plan-reviewer-a.md`, `-b.md`;
[A4-..], [B4-..]); revision 4 (b16bb4b) answered round 3 with the probe spike
(`calibration/04-probe-spike.md`). Earlier rounds: `reviews/07` (round 1),
`reviews/09-*` (round 2), `reviews/10-*` (round 3). Revision 2 is commit
9929b69, revision 3 4187667. T2 to T5 are TASK-75 to TASK-78 [B4-Note].

**The tasks point here** [A3-P3, B3-P6]. Rounds 2 and 3 both found TASK-75 to
78 restating decisions they had not caught up with. From revision 4 each task's
description names its outcome, boundaries and the decisions it applies
("D5, D12"), and restates none of them; this file is the one source.

## Outcome

| Agent | Reviews | Runs when |
|---|---|---|
| `plan-reviewer` | A `Plan`: gaps, blast radius, procedures, model fit, future problems | Work of more than one task, a contract or migration, anything hard to undo, or the owner asks; before its tasks go Active |
| `decomposition-reviewer` | A `Plan`'s split into `Milestone`s and tasks | After `plan_check.py` passes, before the first task goes Active |
| `tests-reviewer` | Whether tests test real behaviour; which are missing or should go | A change to the test files listed in D12 |

All three: Opus at high, read-only apart from D5's prepared copy, fresh every
round, never a fork, PASS / FINDINGS / INCOMPLETE, caps 5 attended / 10
unattended. Until registered as subagent types (a new session), each runs as a
general-purpose Opus agent following its definition, and says so.

**Not in scope:** the work-board mod; the owner decision queue (P-0020); a
decomposer agent (D8); the audit of today's suite (D17, its own task).

## Sequencing [A3-P5, B3-m1, B3-m5]

- **Built:** TASK-73 and TASK-74 (Ready); the `Workflow Model` re-anchored
  after TASK-74 (6452dec).
- **Each task leaves the branch anchor-good** [A4-P3, B4-P3]. A task that
  edits a file the `Workflow Model` or the `Atlas` cites (`docs/review.md`,
  `docs/development.md`, `docs/engine/verification.md`, `docs/glossary.md`,
  and others `bun run check` lists) ends with `bun run anchors <the last
  anchor-good commit> --fix` (6452dec for T2), every EDITED span reread by
  hand, `bun run render`, `bun run atlas` and the client-journey stamp, as
  6452dec did; its record names the new anchor-good commit. `bun run check`
  alone proves only that a cited line exists.
- **Merging `main` in:** before TASK-75 starts (`main` has since changed
  `verification.md`, `git-workflow.md`, the glossary and the owner's rule on
  removing worktrees) [B4-m1], before T3's edit to `tests/run.py`, before T5,
  and before this branch merges. Hand-written files are merged by hand. Generated
  files are regenerated, never hand-merged: `bun run anchors` once against
  each parent's head (the handoff's rule), every EDITED span reread by hand,
  then `bun run render`, `bun run atlas`, the stamps.
- **No quiet window.** T5 starts when T4 is Ready. A branch that lands on
  `main` after this one merges `main` and regenerates, as every branch does.
- **Stale Atlas pages until T5** (design-run, change-review, system-map,
  roster; client-journey is regenerated and stamped by each task above):
  recorded as an exception in the session handoff.

## Decisions (Major; decided, listed for the owner)

- **D1. Placement by four questions** (TASK-73). Generic: the `plan` skill and
  the `test-principles` skill. CVgen: `docs/review.md`,
  `docs/engine/verification.md`, `docs/development.md`. Agent files: own
  procedure only.
- **D2. A `Plan` is a file with an identity**, committed before each round.
- **D3. Tools:** Read, Grep, Glob, Bash, PowerShell; the shell reads, and
  runs checks that write only inside D5's copy or `builds/`.
- **D4. Blind first pass (plan-reviewer).** Built.
- **D5. Two probes in a copy the lead prepares; reading where a probe cannot
  decide** [A3-P1, A3-P2, B3-P1, A4-P1, A4-P2, B4-P1, B4-P2, m1-m3].
  - **The copy:** `git -C <Main Folder> worktree add --detach <Main
    Folder>/.worktrees/probe-<timestamp> <reviewed commit>` (absolute paths),
    under `.worktrees/` like every checkout; `docs/git-workflow.md` gains the
    `probe-*` name: detached, owned by one review round. An uncommitted
    snapshot is committed first as a WIP commit; for Bun tests the lead runs
    `bun install --frozen-lockfile` in the copy. Removed after the round with
    `git worktree remove` (it ignores the ignored `builds/`; `--force` only
    for a probe the same round left uncommitted, under the owner's rule on
    removing worktrees), then `git worktree prune`. Any session may remove a
    clean `probe-*` copy no running round owns. Never `git stash` in it.
  - **A probe is a commit in the copy** (engine clean, copy removable): the
    fault probe breaks the behaviour a test claims to guard; the refactor
    probe keeps the behaviour and changes its shape. Each recorded as its
    diff.
  - **The runs:** the Python suite as the copy's own `tests/run.py` by
    absolute path, with the repository's interpreter that has
    `requirements.lock` installed (`.venv/Scripts/python.exe` on Windows,
    `.venv/bin/python` elsewhere) and `--output` inside the copy; a Bun test
    as `bun test <file>` in `<copy>/tools/workflow`, which `tests/run.py`
    never runs.
  - **Three outcomes for a fault** (the suite stops at its first failure; a
    compile case is identified by file, line *and* the case name in the
    message): **caught**, the first failure is the probed check; **survived**,
    the suite passes or first fails *after* the probed check, so the check ran
    and missed the fault; **masked by X**, an earlier check fails first. When
    X is a by-design detector (the frozen-reference comparison, a hash pin),
    the probe commit also re-baselines X in the copy (the probe's render as
    the reference, its pin updated) and reruns; otherwise masking is itself
    evidence that the two checks overlap (D6). A skipped case, a crash or a
    missing module decides nothing. A **refactor counts only on a full PASS**.
  - **Reading where a probe cannot decide.** A check no probe reaches is
    judged by reading, and the report says which and why. Calibration 04
    proved one case (a check reached, output unchanged); TASK-75's evidence
    adds a fault that changes the engineer example's output and one Bun probe.
  - **Checks that fail on any change by design** (the frozen set: the
    frozen references and `tests/baseline.json`'s pins; `tests/workflow.py`'s
    clean-engine assertion) are judged on whether they pin the right things,
    never by the refactor probe. `docs/engine/verification.md` says so.
  - **The boundary:** `docs/review.md`, "Reviewer boundaries": the
    tests-reviewer may commit probes inside its prepared copy and run its
    tests there; nothing else. The owner's settings hold no permission rules
    today, so nothing is added; an unattended round that meets a prompt
    stops and reports INCOMPLETE.
- **D6. Removal needs a reason** (the `test-principles` skill). A check of the
  frozen set is never removed this way.
- **D7. `plan_check.py`** [A3-P4, B3-P3, B3-m2, B3-m3].
  `scripts/plan_check.py [--root DIR] --plan PATH TASK-N [TASK-M ...]`,
  standard library only; every listed task's `Plan:` line must equal PATH
  (refused otherwise) [B4-m3]. For each listed task: exists and is not Done; its `milestone` id is a
  file in `backlog/milestones/`; the title is `<slug>: <outcome>`; the
  description has the header (Owner, Branch/worktree, Integration target,
  Depends on, `Plan:`) and "Outcome and boundaries"; at least one acceptance
  criterion; whether PATH exists under the root is reported, not refused
  (on `main` the `Plan` is usually still on its branch).
  **Dependencies:** when the header's "Depends on" names a task id and the
  frontmatter list is empty, refused (the template now writes `--dep`); every
  frontmatter id exists and appears in the header; header ids that are not in
  the frontmatter ("drives TASK-68") are reported, not refused; no cycle over
  the listed tasks and their dependencies; dependencies outside the list or
  milestone reported. **The reader** handles what Backlog.md writes: plain and
  single-quoted scalars, `>-` folded text, `- ` lists and `[]`. Fixtures in the
  suite cover each of these, never the live backlog.
- **D8. The loop, where each step runs** [A3-P6, B3-P4].
  1. The `Plan` is written and reviewed on the work's branch, `feat/<slug>`.
  2. Its tasks are created Queued on `main` (the backlog skill's route), each
     with `--dep` for its dependencies and a `Plan:` header line (both added to
     the template in `docs/development.md` and the backlog skill).
  3. `plan_check.py` runs **where the tasks' current copies are**: for Queued
     tasks, a checkout of `main` pulled to the record commit; for tasks a
     branch already works, that branch's checkout after merging `main` into
     the `Plan`'s branch and that branch into the child, if any [B4-m4].
  4. The `decomposition-reviewer` gets the `Plan` at its branch commit, the
     tasks at the commit `plan_check.py` read, and the ids. Fixes are record
     edits where the tasks live; `plan_check.py` reruns every round.
  5. Before the first task goes Active, `main` is merged into the `Plan`'s
     branch, so the branch holds the tasks. The `Plan`'s tasks run on that
     branch or on child branches off it (integration target: the `Plan`'s
     branch), so every task's checkout holds the `Plan` file.
  6. A task added, split or re-scoped, or a `Plan` revision that changes
     outcome, scope or sequencing, reruns step 3 and a decomposition round on
     the changed ids.
  7. Reviews of the `Plan` and its decomposition go beside the `Plan`; each
     task's own reviews follow `docs/development.md`.
- **D9. Codex counterparts as pointers.** Read-only sandbox for the plan and
  decomposition reviewers, workspace-write for the tests-reviewer (it commits
  probes in its copy; whether Codex's sandbox lets it commit into the shared
  `.git` is checked once in T5, else its counterpart reads only) [B4-m6].
  `.codex/README.md` describes both patterns. A Codex verdict is advisory and
  never satisfies one of these gates.
- **D10. `code-reviewer` keeps lens 5**; one sentence in `docs/review.md`
  lets it rely on a tests-reviewer's report for the same snapshot.
- **D11. Milestone m-8.**
- **D12. The tests-reviewer's trigger, by path** (owner: "Test changes only")
  [B3-m4]. A change that adds, edits or deletes: `tests/**`,
  `tools/workflow/test/**`, `tools/workflow/sample/**`,
  `packages/domains/*/fixtures/**`, `packages/**/templates/*/tests/**` other
  than frozen references, `examples/release.json`'s list, and
  `studio/brand/report/sample.json` (read by `tests/report.py`) [A4-Note]. The frozen set
  (frozen references and `tests/baseline.json`'s pins) is the owner's: adding
  a pin is reviewed only for pinning the right file (D5). A behaviour change
  with no test is the `code-reviewer`'s to flag.
- **D13. Transition, by work** [B3-P5]. A piece of work is a `Plan`'s tasks,
  or, without a `Plan`, a task and the tasks its header's "Depends on" names
  [B4-Note]. At this branch's merge, each piece of work is classified by its tasks' states, read from the branch that works
  each task (the CLI reads only the local checkout, so `git show
  <branch>:<task file>` for each branch in `git branch`): if any of its tasks
  is Active, in Review or Ready on any branch, the whole work finishes under
  the rules it started with; otherwise its Queued tasks need a `Plan` (when
  the work needs one) before the first goes Active. The handoff written at
  the merge lists both groups.
- **D14. Bars for the known-answer runs**: key committed first; the lead
  decides with a reason; under half needs a named change or a stated
  limitation.
- **D15. ADR 0018 and a history entry** (T5).
- **D16. Two plan-reviewers per round for this `Plan`.**
- **D17. One audit of today's suite** (owner: "Queue one audit"), its own
  task in m-7, queued when T2 is Ready.
- **D18. The `Workflow Model`, the smaller way:** `design.engine-review`
  names the tests-reviewer beside the `code-reviewer`, as
  `design.client-review` names two reviewers.
- **D19. Glossary:** `Plan`, `Impact Map` (done); `Decomposition` with T4
  [A3-P9]; the probe names if T2's text keeps them.

## Rubrics

The `plan-reviewer`'s: the `plan` skill and `docs/review.md`'s impact items.
The decomposition and tests rubrics: revision 2 (9929b69), into the `plan`
skill (T4, with a files column for parallel safety) and the
`test-principles` skill (T2), the tests rubric's "can fail" and
"structure-insensitive" tested by D5's probes.

## Files

### New
| File | Task |
|---|---|
| `.claude/skills/test-principles/SKILL.md`, `.claude/agents/tests-reviewer.md` | T2 |
| `scripts/plan_check.py`, `tests/plan_check.py`, `tests/fixtures/plan_check/` | T3 |
| `.claude/agents/decomposition-reviewer.md` | T4 |
| `.codex/agents/{plan,decomposition,tests}-reviewer.toml`, `docs/decisions/0018-review-gates-for-plans-and-tests.md` | T5 |

### Changed
| File | Change | Task |
|---|---|---|
| `docs/review.md` | The tests gate (D12) and brief; "Reviewer boundaries" (D5); reviewer lists at the intro, the brief, the Opus list, the loop's step 1 and "Report and persistence"'s own-shape list [B4-Note]; D10 | T2 |
| `docs/review.md` | The decomposition gate and the loop (D8); the same lists | T4 |
| `docs/engine/verification.md` | The suite's rules; the frozen set and change-detecting checks (D5); how a probe runs | T2 |
| `docs/conventions.md` | "Tests": CVgen rules stay; generic ones move to the skill; a pointer | T2 |
| `docs/git-workflow.md` | The `.worktrees/probe-*` checkout (D5) | T2 |
| `tests/run.py` | Wires in `tests/plan_check.py` | T3 |
| `AGENTS.md` | `plan_check.py` in the `scripts/` row (797 to 798 words) [A3-P8] | T3 |
| `.claude/skills/plan/SKILL.md` | Decomposition checklist, the loop (D8), the files column | T4 |
| `docs/development.md`, `.claude/skills/backlog/SKILL.md` | The task template gains `--dep` and `Plan:` (D7, D8); the loop | T4 |
| `docs/development.md` | Stage table's Review row; roles list; file map; the transition (D13) | T5 |
| `docs/glossary.md` | D19 | T2, T4 |
| `.claude/skills/new-cv/SKILL.md`, `.claude/skills/new-theme/SKILL.md` | Their gate lines name the tests-reviewer for the D12 paths | T5 |
| `.codex/README.md` | D9 | T5 |
| `.claude/repo-maintenance.md` | Lines 90 and 150 | T5 |
| `docs/workflow/05-design/stage.yaml` and its generated outputs | D18 | T5 |
| `.atlas/src/site.json`, `.atlas/src/pages/{change-review,roster,design-run,system-map}.json` | Roster; the change-review flow; citations re-checked; stamped | T5 |
| `docs/history.md`, `backlog/docs/doc-1 - session-handoff.md` | D15; the gates, D13's groups, the STALE exception, drop the three-agent pitfall | T5 |

## Tasks (m-8; the audit in m-7)

TASK-75 → TASK-76 → TASK-77 → TASK-78, in that order; the audit is queued
when TASK-75 is Ready.

| Task | Applies | Gate | Evidence |
|---|---|---|---|
| TASK-75 tests-reviewer | D5, D6, D12, D17 (queue), D19 | context-reviewer | Keys first (D14); a seeded tautological test flagged by a fault probe, a seeded change-detector test by a refactor probe; a fault that changes the engineer example's output, run through the masked-and-re-baselined path; one Bun probe; `tests/proposals.py` reviewed for real |
| TASK-76 plan_check.py | D7 | code-reviewer and tests-reviewer; context-reviewer for `AGENTS.md` [B4-m5] | Suite and ruff (the `.venv`); fixtures for every D7 refusal, every reported case and every reader shape; the script on TASK-75 to 78 from this branch, and on TASK-79 to 81 from `main` |
| TASK-77 decomposition-reviewer | D8, D19 | context-reviewer | Known-answer run on the P-0019 split (TASK-63 to 68), key first, `plan_check.py` skipped there |
| TASK-78 the welcome | D9, D10, D13, D15, D18 | context-reviewer; code-reviewer for the `Workflow Model` | `bun run anchors` per parent, `check`, `render`, `atlas`, `bun test`, `atlas.py check` clean, suite, ruff |

## Risks

- **One reviewer's run varies:** two `plan-reviewer`s for hard-to-undo work.
- **Questions 12 and 13** were added after seeing their answer keys; D5's
  probes are proven on one Framework check (calibration 04). The masked path
  and the Bun run are TASK-75's evidence; until proven there, such checks are
  judged by reading.
- **Branches in flight** change shared files: merge `main`, regenerate.
- **Review churn:** narrow triggers, the script for exact checks, the caps.

## Carried into the tasks (round 5 Minor findings)

Both round 5 reviewers passed the plan; their Minor findings are applied by
the task named, whose own review checks them. [A5-..] is
`reviews/12-plan-reviewer-a.md`, [B5-..] `-b.md`.

- **TASK-75 (D5, in `docs/engine/verification.md` and `docs/review.md`):**
  - the anchor base for T2 is the commit that merged `main` in, not 6452dec
    [A5-P1, B5-m1];
  - no fault outcome is read until the copy passes in full in that
    environment; one suite at a time; Bun run from PowerShell with `PYTHON`
    set to the virtual environment's interpreter, and a Bun fault counts when
    the probed test fails by name [A5-P2, B5-m4];
  - the copy is added with `--lock --reason "<session, round>"`, so a live
    copy is never taken for an orphan, and its path is recorded in the task
    notes [B5-m2, A5-Note];
  - the boundary names every move a round makes: writing files in the copy,
    `git -C <copy> checkout --detach <reviewed commit>` before each probe,
    the probe commits, the masked path's second commit after its first run
    [A5-P3, B5-m3];
  - a refactor that fails at another check first is invalid and redone, not
    evidence against the test [B5-m5];
  - a re-baseline commit inside a probe copy is never on a branch and the copy
    is removed, so it is no change to the frozen set; it is allowed nowhere
    else [A5-P3, B5-m6];
  - masking by an ordinary check shows overlap for that fault only and is not
    by itself a reason to remove a check under D6 [B5-Note 5];
  - `AGENTS.md`'s `.worktrees/` row names the `probe-*` copies (797 to about
    800 words; T3's `plan_check.py` word counted with it) [A5-P4].
- **TASK-76 (D7):** a milestone matched by its `id:`, not a file-name prefix
  (`m-1` against `m-10`) [B5-Note 2]; every problem listed, not the first only
  [B5-Note 4]; "Depends on: none; drives TASK-N" with an empty list is not
  refused [A4-Note, B5-Note 3]; the run on TASK-79 to 81 from `main` is
  expected to refuse all three (no `Plan:` line; TASK-81's header names
  dependencies its frontmatter lacks) and records that as the evidence that
  older tasks predate the template [A5-Note].
- **TASK-78 (D13):** the reason for reading task states from each branch is
  that the work must be classified from every branch's copy, not that the CLI
  reads only the local checkout (it lists branches touched in the last 30
  days) [B5-Note 1].
