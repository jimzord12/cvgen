# Plan review round 2: review-agents (reviewer A)

Snapshot: `archive/work-records/review-agents/plan.md` at 9929b69 (plan.md is unchanged at the branch head 5a9b9bd). I treated TASK-73 and TASK-74 as built.
Blind map: code/agent files 10 · data/contracts 6 · tests 6 · generated 7 · docs/context 16 · tooling/CI 5 · work in flight 6 · decisions 4 (full map below).

Checklist:
1. Impact: mostly covered. A few lines are missed (P7).
2. Fit: OK. Frozen references are protected (D6, verification.md).
3. Facts: two are false: `scripts/board.py` (P4) and code-reviewer.toml copying lens 5 (P5). The sequencing facts are stale (P6).
4. Compatibility: the first real use of plan_check fails on today's tasks (P4).
5. Reversibility: everything is docs and scripts, so it can all be reverted.
6. Verification: T2's evidence cannot be produced as written (P2).
7. Failure: on an uncommitted snapshot, D5 has no copy to make (P2).
8. Sequencing: the branch list is stale and has no end. T2 and T3 do touch files the other branches also change (P6).
9. Unknowns: D14 covers them.
10. Decisions: D12 and D13 are listed for the owner. The audit of existing tests is not offered (Note).
11. Proportion: OK.
12. Procedures: three routines fork (below).
13. Model fit: the "Depends on" header holds a non-dependency (P4). Deliberate faults cannot detect a change-detector test (P2).

Procedures walked:
- **Plan → Queued tasks on `main` → plan_check → decomposition-reviewer → Active:** forks. It does not say which branch the plan lives on, which snapshots each step reads, whether plan_check reruns after fixes, or what happens to the tasks when the plan is revised (P3).
- **Deliberate fault:** fails for change-detector tests. It forks on an uncommitted snapshot, on PowerShell piping and on permission prompts (P2).
- **plan_check on TASK-79 to 81 (named by D13):** refuses TASK-80, or demands a dependency that runs backwards. CI has no `backlog` CLI (P4).
- **Merge `main`, then regenerate:** the rule is sound, but the list of branches it waits for is stale (P6).
- **Codex pointer TOMLs:** OK. A Codex verdict is stated to be advisory.

Round 1 findings:
- **Answered:** P2, P3, P6, P8, P9 (this round has two reviewers), P10.
- **P1:** answered in the plan, but not in the TASK-77 description (P1 below).
- **P4:** answered in part (P2 below).
- **P5:** answered, but the facts are now stale (P6 below).
- **P7 and the code-reviewer.toml part of P8:** rest on a false premise (P5 below).
- **P11:** answered, except `repo-maintenance.md:90` (P7 below).

## Findings

### P1 Material: tasks 75 to 78 were not aligned with revision 2
Anchor: D8, D12, the Tasks section; `backlog/tasks/task-75…`, `task-77…`, `task-78…`
- **TASK-75 AC #2 contradicts D12.** It still triggers the tests-reviewer on "a behaviour change with no test change", which D12 removed.
- **TASK-77's description still has P1's order:** "… decomposition-reviewer, create tasks". Its AC #5 has the corrected order, so the task disagrees with itself.
- **TASK-78 lists only TASK-77 as a dependency.** It also waits on TASK-68 (contract-stage-2) and TASK-2 (travel-domain). The plan's own rubric item 5 would flag that.
- **TASK-78 AC #1 covers only the "Changed" table.** ADR 0018 and the three Codex TOMLs are in the "New" table.
- Commit 9929b69 says "Tasks 75-78 aligned". A reviewer checking T2 against AC #2 would build or demand the wide trigger.
- **Fix:** correct AC #2 and TASK-77's description. Add the dependencies, or the `blocked` label. Extend AC #1 to the "New" table.

### P2 Material: D5 cannot flag a change-detector test
Anchor: D5; T2 evidence ("each by a deliberate fault"); rubric item 3
- **The probe goes the wrong way.** A change-detector test fails on every change, faults included, so a deliberate fault makes it look good. Only a change that keeps the behaviour (a refactor) exposes it.
- **Uncommitted work:** `git archive <snapshot>` cannot copy an uncommitted patch, which `docs/review.md:129-130` allows as a snapshot.
- **PowerShell piping:** `git archive | tar -x` in PowerShell is a binary pipe that may not survive. Use `git archive -o <file>.tar`, then `tar -xf`.
- **Permission prompts:** `.claude/settings.json` allows none of these commands, so unattended rounds stall on prompts.
- **Fix:**
  - Add a second probe: an edit that keeps the behaviour, which the test must survive.
  - Reword T2's evidence to use it.
  - Copy uncommitted work as the base plus `git apply` of the patch.
  - Write the archive to a file, then extract it.
  - Name the permission rules needed.

### P3 Material: the loop has an order but no locations
Anchor: D2, D8, D14; `docs/development.md:186-196`
- **Unstated:**
  - which branch a plan is committed on before any task exists;
  - that the decomposition-reviewer needs two pins (the plan at a branch commit, the tasks at a `main` commit);
  - where plan_check runs (it ships on `main`), and whether it reruns after each round of fixes;
  - what happens to the tasks when a plan is revised after its decomposition passed (`review.md:92-93` sends the plan back; the tasks are unaddressed);
  - which reviews folder a planned task's reports go to: the plan slug's (as here) or the task slug's (`development.md:175-176`).
- **This plan already diverges.** TASK-75 to 78 were revised on the branch, not on `main` as D8 says. `main` still holds the revision-1 tasks, so a session orienting from `main` reads a stale AC.
- **Fix:** add one paragraph to D8 for T4: where the plan and the tasks live, what each brief pins, plan_check rerun every round, re-decomposition after a plan revision, and where reports go. Sync `main`'s TASK-75 to 78.

### P4 Minor: plan_check's model against real data
Anchor: D7
- **A non-dependency in the header.** `main` TASK-80 says "Depends on: TASK-2; drives TASK-68". "Names the same task ids" would refuse it, or demand TASK-68 as a dependency, which inverts the real order.
- **CI cannot ask the CLI.** "A milestone id that `backlog milestone list` knows" needs the CLI, and CI does not install it (`verify.yml`). Read `backlog/milestones/`, with a root argument the fixtures can use.
- **The parsing precedent is not in the repository.** `scripts/board.py` is an untracked file in the Main Folder (session handoff, line 22).
- **Fix:** require every frontmatter dependency to appear in the header, and report other ids rather than refuse them. Add a fixture for this case. Drop the `board.py` reference.

### P5 Minor: code-reviewer.toml does not copy lens 5
Anchor: D9, D10; `.codex/agents/code-reviewer.toml:49-52`
- It reads `docs/review.md` "in full" and only says "1-8". The D10 sentence in `review.md` reaches it with no edit.
- It is already a pointer, so "existing counterparts copy" is not true of all of them.
- **Fix:** drop the TOML edit and qualify the README wording.

### P6 Minor: sequencing facts went stale during the review
Anchor: Sequencing, D13
- **One branch is gone.** feat/template-contract merged at 9a7c4bd, 78 seconds before 9929b69.
- **A new branch exists.** feat/hanami-essential (9298891) has appeared, stacked on travel-domain, apparently for TASK-79. TASK-79 may go Active before this merges, which undoes D13's named list.
- **D13's contract-stage-2 clause can never apply.** T5 waits for that branch to merge, so it is never "before its code review" when this branch merges.
- **"Touch only" is not true.** T2 may edit `tests/run.py` and `verification.md`, and T3 wires into `run.py`. The other branches edit both.
- **Fix:**
  - State T5's precondition as a rule: merge `main`, then regenerate, with no fixed branch list.
  - Derive D13's task names when the branch merges.
  - Say the hand-written files are merged by hand.

### P7 Minor: lines the welcome misses
- `docs/review.md:198-200`: the Opus-at-high reviewer list.
- `docs/development.md:53`: the Review-stage row.
- `.claude/repo-maintenance.md:90`: the same stale clause as line 150.
- **The trigger paths:** "test, fixture or baseline" should list them, including `packages/domains/*/fixtures/`, `templates/*/tests/` and `tools/workflow/test/fixtures/`. Travel-domain's frozen-reference candidate regeneration is a live case.
- **Stale Atlas pages:** `atlas.py check` shows four pages STALE on this branch now (design-run, change-review, system-map, roster). Development.md "Ending a session" requires restamping in the same session. State the exception until T5.

### P8 Note
- The owner's "how current ones need to be removed or fixed" may mean an audit of the existing suite. Offer it as a follow-up task.
- Until the agents are registered, the T3 and T4 gates run as general-purpose agents. Say so in their records.

## Impact map
(C covered, M missed, X excluded)
- **Agents and skills:** C: three agents, two skills, backlog, new-cv and new-theme skills, Codex. M: none.
- **Data:** C: task frontmatter, header, milestones. M: the header's non-dependency ids (P4).
- **Tests:** C: plan_check fixtures, run.py case selection, Bun. M: the refactor probe (P2), trigger paths (P7).
- **Generated:** C: anchors, render, atlas, the five Atlas pages. M: the STALE interval (P7).
- **Docs:** C: review.md, development.md, verification.md, conventions.md, glossary, ADR, history, handoff. M: review.md:198, development.md:53, repo-maintenance.md:90.
- **Tooling and CI:** C: bun check and test, ruff, atlas check. M: CI has no backlog CLI (P4).
- **In flight:** C: contract-stage-2, travel-domain, TASK-79 to 81. M: hanami-essential; `main`'s copies of TASK-75 to 78 (P3, P6).
- **Decisions:** C: D12, D13 listed for the owner. X: the existing-test audit.

## Facts checked
- template-contract still in flight: **false** (merged at 9a7c4bd).
- `scripts/board.py` is in the repository: **false** (untracked in the Main Folder).
- code-reviewer.toml copies lens 5: **false**.
- run.py has no case selection on any branch: **true**.
- Python tests resolve ROOT from the file's own path (`verify.py:10`), so a copy tests itself: **true**.
- CI installs Bun but not `backlog`: **true**.
- No ADR 0018 exists on any branch: **true**.
- AGENTS.md is 797 words: **true**.
- `repo-maintenance.md:150` is stale: **true**, and line 90 too.
- Glossary has `Plan` and `Impact Map`: **true**.

## Limitations
- I ran as a general-purpose agent following the definition.
- I did not read `private/`.
- The branches moved during the review.
- I did not run `bun run anchors`.
- I ran `atlas.py check` after reading that its check path writes nothing.

## Verdict: FINDINGS
