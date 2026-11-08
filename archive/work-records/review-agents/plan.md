# Plan: review-agents — a plan-reviewer, a decomposition-reviewer and a tests-reviewer

Status: agreed with the owner 2026-11-08 in direction; revised in place on
`feat/review-agents` until its plan review passes (D2), then kept unchanged.
Revision 3 answers plan review round 2 (two reviewers:
`reviews/09-plan-reviewer-a.md`, `-b.md`; findings named [A1]..[A8],
[B1]..[B11]) and two owner answers of 2026-11-08 (D12, D17). Revision 2
answered round 1 (`reviews/07-plan-reviewer.md`, [P1]..[P11]).

## Outcome

Three fresh-context review gates join the four everyday ones:

| Agent | Reviews | Runs when |
|---|---|---|
| `plan-reviewer` | A `Plan`, before its tasks are created: gaps, blast radius, procedures, model fit, future problems | Work of more than one task, a contract or migration, anything hard to undo, or the owner asks for a plan |
| `decomposition-reviewer` | A `Plan`'s split into `Milestone`s and tasks, created as Queued | After the `Plan`'s PASS, `plan_check.py` and before the first of its tasks goes Active |
| `tests-reviewer` | Whether tests test real behaviour, and which are missing or should go | A change to the test files listed in D12 |

All three: Opus at high (the owner's standing choice for reviewers,
2026-09-26), read-only apart from D5's prepared copy, fresh every round, never
a fork, verdict PASS / FINDINGS / INCOMPLETE, round caps 5 attended / 10
unattended. Until the three are registered as subagent types (a new session),
each runs as a general-purpose Opus agent told to follow its definition, and
its report says so [A8].

**Not in scope:** the work-board mod; the owner decision queue (P-0020); a
separate decomposer agent (D8); the audit of today's suite, queued as its own
task (D17).

## Sequencing [P5, A6, B2, B9]

- **Built:** TASK-73 and TASK-74, both Ready. The `Workflow Model` was
  re-anchored after TASK-74 moved `docs/review.md` lines (6452dec).
- **Rule, not a list:** branches merge into `main` in their own order. Before
  T3's edit to `tests/run.py`, before T5, and before this branch merges: merge
  `main` into it; resolve hand-written files by hand; **regenerate, never
  hand-merge**, the generated ones (`bun run anchors <base> --fix`, edited
  spans by hand, `bun run render`, `bun run atlas`, then the stamps).
- **Shared files:** `tests/run.py` (T3 wires its tests in), the `Workflow
  Model`, the `Atlas`, `docs/engine/verification.md`, `docs/glossary.md` and
  `.claude/skills/new-cv/SKILL.md` are also changed by branches in flight
  (`feat/contract-stage-2`, `feat/travel-domain` and those stacked on it, as
  of 2026-11-08). T2 does not restructure `tests/run.py` (D5).
- **T5 starts** once no other branch in flight changes the `Workflow Model`
  or the `Atlas`, checked with `git diff --name-only main...<branch>` over
  `git branch`, then merges `main` as above.
- **Stale Atlas pages until T5:** design-run, change-review, system-map and
  roster cite lines in files this branch changes; they stay STALE on this
  branch until T5 re-checks and stamps them, an exception to "Ending a
  session" recorded in the session handoff [A7].

## Decisions (Major; decided, listed for the owner)

- **D1. Placement by four questions** (TASK-73,
  `.claude/agents/context-maintainer.md`, "Where things live"). For this
  work: the `plan` skill (template, impact map, thirteen questions,
  decomposition checklist, the loop) and the `test-principles` skill
  (generic principles, D6) are generic; gates, triggers, briefs, caps, storage
  and the CVgen impact items are in `docs/review.md`; this suite's rules in
  `docs/engine/verification.md`; each agent file holds its own procedure.
- **D2. A `Plan` is a file with an identity**, committed before each round
  (where: D8).
- **D3. Tools:** Read, Grep, Glob, Bash, PowerShell; the shell reads, and runs
  checks that write only under `builds/`.
- **D4. Blind first pass (plan-reviewer).** Built.
- **D5. Two probes in a copy the lead prepares (tests-reviewer)** [P4, A2, B2].
  - **Two probes.** A *fault* breaks the behaviour a test claims to guard: the
    test must fail. A *refactor* keeps the behaviour but changes its shape: the
    test must pass. A test that survives its fault guards nothing; a test that
    fails a refactor is a change detector. Each probe is recorded as a diff.
  - **The copy is prepared by the lead, not the reviewer**, so the reviewer
    changes no Git state and installs nothing: `git worktree add --detach
    builds/tests-review-<timestamp> <commit>`, a real checkout whose `HEAD` is
    the reviewed commit (so `engine_state` and `tests/workflow.py`'s Git
    checks see the copy, not the outer repository); for Bun tests, `bun
    install --frozen-lockfile` inside it. An uncommitted snapshot is committed
    first, as a WIP commit; D5 needs a commit. The lead removes the worktree
    with `git worktree remove` after recording the round.
  - **The run.** Most of `tests/run.py`'s cases are inline in `main()`, and
    case selection would restructure a file three branches change; so the
    reviewer runs the whole suite in the copy (`python tests/run.py --output
    <copy>/builds/...`) and reads the probed case's result, or calls the few
    function-shaped checks directly. Case selection is left as a follow-up
    once those branches have merged, recorded in the audit task (D17).
  - **The boundary.** `docs/review.md`, "Reviewer boundaries": the
    tests-reviewer may edit files inside the prepared copy and run the suite
    there; nothing else. The permission rules this needs (writes under
    `builds/tests-review-*`) are named in T2 for the owner to allow, or the
    round runs attended.
- **D6. Removal needs a reason.** A test is removed only by naming what it
  fails to catch (the fault probe as evidence) or the test that already
  catches the same faults; in the `test-principles` skill. A check of a frozen
  reference is never removed this way.
- **D7. `plan_check.py` checks what has an exact answer** [P1, P2, A4, B6].
  `scripts/plan_check.py [--root DIR] TASK-N [TASK-M ...]`, run from a
  checkout that holds the tasks (D8). For each listed task: it exists and is
  not Done; its `milestone` id is a file in `backlog/milestones/` (no CLI, so
  CI can run the fixtures; catches Backlog.md #919's virtual milestones);
  the title is `<slug>: <outcome>`; the description has the header (Owner,
  Branch/worktree, Integration target, Depends on) and "Outcome and
  boundaries"; at least one acceptance criterion; every id in the frontmatter
  `dependencies:` exists and also appears in the header's "Depends on"; other
  task ids in the header ("drives TASK-68") are reported, not refused; the
  graph over the listed tasks and their dependencies has no cycle;
  dependencies outside the list or milestone are reported. Standard library
  only, with a frontmatter reader for the shapes Backlog.md writes (scalars,
  `>-` folded text, `- ` lists); `tests/repo_maintenance.py:59`'s reader
  handles flat keys only, so this one is new. Fixtures only in the suite.
- **D8. The loop, with its locations** [P1, A3, B1].
  1. **The `Plan`** is written and committed on the work's branch,
     `feat/<slug>`, created for it at the start of planning; it is reviewed
     there (`plan-reviewer` until PASS; two for work that is hard to undo).
     Its reports go to `archive/work-records/<plan-slug>/reviews/`.
  2. **The tasks** are created Queued on `main` (record-keeping, the backlog
     skill's route), each with a `Plan: archive/work-records/<plan-slug>/plan.md`
     header line (added to the template in `docs/development.md`) [B8].
  3. **`plan_check.py`** runs in a checkout of `main` at that record commit
     (the `Main Folder` or the short-lived records worktree), or with `--root`
     pointing at one, on the new task ids.
  4. **The `decomposition-reviewer`** gets three pins: the `Plan` at its
     branch commit, the tasks at the `main` commit, and the task ids. Its
     reports go beside the `Plan`'s. Fixes are record edits on `main`;
     `plan_check.py` reruns every round.
  5. **The first task goes Active** on PASS. From then on the branch works its
     tasks, and their edits are on the branch (the backlog skill's existing
     rule); `main`'s copies of those tasks stay as they were, as for any task
     a branch works on.
  6. **Later changes:** a task added, split or re-scoped, or a `Plan`
     revision that changes outcome, scope or sequencing, re-runs
     `plan_check.py` and a decomposition round on the changed ids only.
  7. **Each task's own reviews** go to its task's folder
     (`docs/development.md`) unless the tasks share the `Plan`'s branch, when
     they go beside the `Plan`'s, as here.
- **D9. Codex counterparts for all three, as pointers** [P7, A5, B10]. Each
  TOML points to the Claude agent file and the skills; the `plan-reviewer`'s
  and `decomposition-reviewer`'s request a read-only sandbox, the
  `tests-reviewer`'s workspace-write for the prepared copy. `.codex/README.md`
  describes both patterns (the existing `code-reviewer.toml` already points to
  `docs/review.md`) and corrects its counts. A Codex verdict is advisory and
  never satisfies one of these gates.
- **D10. `code-reviewer` keeps lens 5.** When a tests-reviewer ran on the same
  snapshot, the code-reviewer may rely on its report for test quality; one
  sentence in `docs/review.md`, which `code-reviewer.toml` already reads [A5].
- **D11. Milestone m-8, "Agent-ready repository".**
- **D12. The tests-reviewer's trigger, by path** (owner, 2026-11-08: "Test
  changes only") [P11, B3]. A change that adds, edits or deletes any of:
  `tests/**` (the suite, its fixtures, `baseline.json`'s entries),
  `tools/workflow/test/**`, `packages/domains/*/fixtures/**` (`Coverage
  Fixture`s), `packages/**/templates/*/tests/**` other than the frozen PDFs,
  and `examples/release.json`'s list of what the suite builds. It judges
  whether each check tests behaviour. The *content* of a frozen reference
  (`tests/approved/*.pdf`) is the owner's and outside the gate; adding or
  replacing one is reviewed as it is today. A behaviour change with no test
  change is the `code-reviewer`'s to flag (lens 5); the tests written in
  answer then trigger this gate.
- **D13. Transition** [P5, A6, B9]. At this branch's merge, a task's state
  decides: Queued tasks of work that needs a plan get one before their first
  goes Active; work already Active, in Review or Ready finishes under the
  rules it started with. The session handoff written at the merge names the
  tasks in each group, read from the task store then, not now.
- **D14. Bars for the known-answer runs.** The answer key is committed before
  each run; the lead records the score and decides with a reason; under half
  of the key needs a named change or a stated limitation. Runs on tasks from
  before the template (TASK-63 to TASK-68) skip `plan_check.py` and say so.
- **D15. ADR 0018 and a history entry** for the three gates, the two skills,
  the placement questions, D12 and D17. In T5.
- **D16. Two plan-reviewers per round for this `Plan`** (hard to undo: the
  gates are a contract later work depends on).
- **D17. One audit of today's suite** (owner, 2026-11-08: "Queue one
  audit"). A separate task in m-7, "Verified builds", queued on `main` when T2
  is Ready: the tests-reviewer over `tests/` and `tools/workflow/test/`, its
  findings fixed or removed under D6, frozen references untouched, and the
  case-selection follow-up of D5. It is a code change with its own gates.
- **D18. The Workflow Model, the smaller way** [B7, P3]. `design.client-review`
  already names two reviewers in one step with one actor
  (`docs/workflow/05-design/stage.yaml:233-240`). `design.engine-review`
  follows it: the step names the tests-reviewer beside the `code-reviewer`
  for an engine change that touches the D12 paths, with the gate's check
  saying both must PASS. No new actor, artifact or loop; anchors, render and
  atlas as usual. Chosen because it matches how the model already holds a
  review pair; if `bun run check` refuses it, T5 falls back to the
  round-1 shape and says why.

## The rubrics

The `plan-reviewer`'s is the `plan` skill's checklist and `docs/review.md`'s
impact items. The `decomposition-reviewer`'s and the `tests-reviewer`'s are
drafted in revision 2 of this file (Git history) and go, generic parts first,
into the `plan` skill (T4) and the `test-principles` skill (T2), with these
additions: decomposition item 6 (parallel safety) needs a files column in the
plan template's task table [B11], and the tests rubric's "can fail" and
"structure-insensitive" items are tested by D5's two probes.

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
| `docs/review.md` | The tests gate (D12) and its brief; "Reviewer boundaries" (D5); the Opus reviewer list gains the new two [A7]; the decomposition gate and the loop (D8); D10 | T2, T4 |
| `docs/engine/verification.md` | This suite's rules; frozen references never removed through D6; how the reviewer runs a case (D5) | T2 |
| `docs/conventions.md` | "Tests": CVgen rules stay, the generic ones move to the skill, a pointer | T2 |
| `tests/run.py` | Wires in `tests/plan_check.py` only (after merging `main`) | T3 |
| `.claude/skills/plan/SKILL.md` | The decomposition checklist, the loop (D8) and a files column in the task table | T4 |
| `docs/development.md` | The loop (D8); `Plan:` header in the task template [B8]; the Stage table's Review row names the new gates [A7]; roles list, file map; the transition (D13) | T4, T5 |
| `.claude/skills/backlog/SKILL.md` | Tasks from a `Plan`: Queued on `main`, `plan_check.py`, none Active before the decomposition PASS | T4 |
| `docs/glossary.md` | `Plan`, `Impact Map` (done, T1); `Deliberate Fault` or the probe names if T2's text keeps them | T2 |
| `.claude/skills/new-cv/SKILL.md`, `.claude/skills/new-theme/SKILL.md` | Their gate lines name the tests-reviewer for the D12 paths | T5 |
| `.codex/README.md` | D9 | T5 |
| `.claude/repo-maintenance.md` | Lines 90 and 150, the stale clauses on the agent-context owners [A7] | T5 |
| `docs/workflow/05-design/stage.yaml` and its generated outputs | D18 | T5 |
| `.atlas/src/site.json`, `.atlas/src/pages/{change-review,roster,design-run,system-map}.json` | Roster entries; the change-review flow; every cited line re-checked; stamped | T5 |
| `docs/history.md`, `backlog/docs/doc-1 - session-handoff.md` | D15; the gates, the transition (D13), the STALE exception until T5, drop the three-agent pitfall | T5 |
| `AGENTS.md` | Nothing (797 of 800 words; it points to `docs/review.md`) | — |

## Tasks (milestone m-8; the audit in m-7)

```
TASK-73 ─► TASK-74 ─► TASK-75 tests-reviewer ─► TASK-76 plan_check.py ─► TASK-77 decomposition-reviewer ─► TASK-78 the welcome
                              └─► (queue the audit task, m-7, when TASK-75 is Ready)
```

| Task | Gate | Evidence |
|---|---|---|
| TASK-75 | context-reviewer | Keys committed first (D14). Fault probe: a seeded tautological test survives its fault and is flagged. Refactor probe: a seeded change-detector test fails a behaviour-keeping refactor and is flagged. `tests/proposals.py` reviewed for real |
| TASK-76 | code-reviewer and tests-reviewer | Suite and ruff; fixtures with a cycle, a missing dependency, a header without a frontmatter dependency, a header naming a non-dependency (reported, not refused) and a virtual milestone; the script run from `main`'s checkout on TASK-75 to TASK-78 |
| TASK-77 | context-reviewer | Known-answer run on the P-0019 split (TASK-63 to 68), key first, `plan_check.py` skipped there |
| TASK-78 | context-reviewer; code-reviewer for the `Workflow Model` | `bun run anchors <base>`, `check`, `render`, `atlas`, `bun test`, `atlas.py check` clean, suite, ruff |

## Risks

- **The reviewer is not deterministic:** two `plan-reviewer`s for work that is
  hard to undo.
- **Questions 12 and 13 and D5's refactor probe** were added after seeing
  where earlier runs failed; unproven until later work exercises them.
- **Branches in flight** change shared files: the merge-then-regenerate rule.
- **`ruff` is not installed on this machine:** install before T3.
- **Review churn:** narrow triggers, the script for exact checks, the caps.
