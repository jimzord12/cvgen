# Plan review round 3: review-agents (reviewer B)

Snapshot: `archive/work-records/review-agents/plan.md` at 4187667 (revision 3). TASK-73 and TASK-74 are treated as built.

Blind map: code and agents 9 · data and contracts 6 · tests 7 · generated 5 · docs and context 14 · tooling and CI 4 · work in flight 6 · decisions 4. The full map is under "Impact map" below.

Checklist:
1. **Impact:** mostly covered. One test fixture is missing from D12 (m4).
2. **Fit:** OK, apart from the frozen set (P2).
3. **Facts:** the plan's facts check out. The tasks contradict the plan (P6).
4. **Compatibility:** fails on today's tasks: their frontmatter has no dependencies (P3) and uses shapes the reader does not list (m2).
5. **Reversibility:** n/a. Everything is docs and scripts.
6. **Verification:** T2's evidence can pass without exposing P1.
7. **Failure:** a probe that is cut off, or one the suite stops before, reads as a result (P1).
8. **Sequencing:** the rule is sound. The T5 start condition may never hold (m5).
9. **Unknowns:** D5 assumes the probed test runs, and nothing tests that (P1).
10. **Decisions:** OK.
11. **Proportion:** OK.
12. **Procedures:** see P1, P4 and P5, and m1.
13. **Model fit:** see P2, P3 and P5, and m2 to m4.

Procedures walked:
- **D8, the loop:**
  - Tasks made after the plan's branch was created are not on that branch.
  - Tasks on separate branches have no plan file.
  - An Active task that is re-scoped or split has no checkout that holds all its ids.
  - A stale `Main Folder` makes `plan_check` say a task does not exist.
- **D5, the two probes:**
  - Two guard checks fire before the probed test does.
  - On a failure, no per-case result exists.
  - The copy is left unclean, so `git worktree remove` refuses it.
  - Out-of-memory failures look like a caught fault.
- **D7, `plan_check`:** the dependency and cycle checks are empty for tasks made from the template, and the reader misses frontmatter shapes the tasks use.
- **D13, the transition:** the task store's view puts three Active tasks in the Queued group, and a work whose tasks are in mixed states fits both groups.
- **Merge then regenerate:** `<base>` is undefined when a cited file changed on both sides.

## Findings

### P1 Material: D5's "probed case's result" does not exist for most probes
Anchor: D5. `tests/run.py:210`, `:471`, `:528`; `tests/workflow.py:103`; `render.py:223-230`.
- The suite is a chain of bare asserts and stops at the first failure. `report.json` is written only when every check passes.
- Inside the worktree copy, an uncommitted probe:
  - on any pinned file makes `check_frozen()` fail at line 210, the first check;
  - on `packages/` makes `engine_uncommitted_changes` true, so `workflow.py:103` fails at line 471.
- Consequences:
  - A refactor probe on the engine always fails the suite.
  - Checks after line 471 never run under an engine probe.
  - A fault the probed test misses still turns the suite red, so the test looks like it caught the fault.
  - The same happens with the out-of-memory flake the handoff records.
- Revision 3's worktree fixes B's Git finding but causes this.
- The copy also has to be clean at the end: `git worktree remove` refuses an unclean worktree (its docs say so).

**Smallest fix:**
- A probe counts only when the first failing assert is the probed test's own file:line. Any other first failure is inconclusive and is rerun or reported.
- Apply each probe with `git -C <copy> apply` and revert it with `apply -R`. This records the diff and leaves the copy clean.
- T2's evidence includes one probe on an engine file.

### P2 Material: checks that fail on any change by design
Anchor: D12, D6, the rubric item "structure-insensitive". `docs/constitution.md:28-35`, `new-theme/SKILL.md:42`.
- D12 puts `baseline.json`'s entries inside the gate. The constitution makes them the frozen set's hash pins, and adding entries is routine.
- A hash pin, like the engine-clean assert at `workflow.py:103`, is a change detector on purpose.
- D6 only stops these from being removed. The reviewer would still raise FINDINGS on every new theme's baseline addition.

**Smallest fix:** one rule in `verification.md`: checks that fail on any change on purpose are judged only on whether they pin the right files, never by the refactor probe.

### P3 Material: D7's dependency checks are empty for tasks made from the template
Anchor: D7. `docs/development.md:214-216` has no `--dep`.
- `main`'s TASK-79, 80 and 81 carry "Depends on" in the header with no frontmatter `dependencies`.
- D7 makes the frontmatter the source, so its existence and cycle checks see nothing.
- TASK-73's placement table moves dependencies and cycles out of the decomposition-reviewer's hands and into the script, so no one checks them.

**Smallest fix:**
- Add `--dep` to the create template in `development.md` and the backlog skill.
- `plan_check` refuses a task whose header names a task id while its frontmatter list is empty.

### P4 Material: D8 still forks
Anchor: D8.1 to D8.7.
- **(a) Task files missing from the plan's branch.** The CLI says "Task lookups read only the local working copy" (verified with `task view TASK-80` here). Tasks created on `main` after the plan's branch was made are not on that branch.
  - This plan never exercised it: the branch was made at 9b06670, the commit that queued its tasks.
  - Merge `main` into the branch before the first task goes Active.
- **(b) Tasks on their own branches.** D8.7 allows them, and item 6 (parallel safety) invites them, but those branches lack `plan.md`. The `Plan:` path does not exist on `main` either. Say how the plan reaches them: child branches off the plan's branch, or merging the plan first.
- **(c) Changes after the first task goes Active.** The live copy of a re-scoped task is on the branch. A split puts new ids on `main` and old ones on the branch. Run `plan_check` in the branch's checkout after merging `main`. Check that `--root` is at the record commit (a `Main Folder` that was not pulled is stale).

### P5 Material: D13 classifies tasks from a view that is wrong today
Anchor: D13.
- TASK-2, 79 and 80 are Active on their branches but Queued on `main` and here. `backlog task list --plain -s Active` returns "No tasks found".
- TASK-81, a client CV, is Queued but depends on TASK-79 and 80, which are Active, so it fits both groups.

**Smallest fix:** read each task's state from the copy on the branch working on it. Classify by work: a Queued task whose work already has an Active task finishes under the old rules.

### P6 Material: revision 3 did not fully reach the tasks
- **TASK-75's description** still says "git-archive copy", "how one case runs", case selection "only if chosen" and "(revision 2)". TASK-75 is the next task to go Active.
- **TASK-76 AC #4** refuses "a header that disagrees with the frontmatter". D7 says such ids are reported, not refused. The AC also lacks the non-dependency fixture and the run from `main`'s checkout.
- **TASK-78's note "Scope after plan revision 2"** contradicts the plan in three places:
  - a start that waits on three named branches;
  - a Workflow Model change "sized by P3", against D18;
  - an edit to `code-reviewer.toml`, against D10.

**Fix:** edit all three on the branch.

### m1 Minor: the merge's `<base>` for `bun run anchors` is undefined
- `docs/glossary.md` is cited 17 times by the model and changed on both `main` and this branch since 9b06670.
- One base cannot judge both sides' anchors.
- **Fix:** run it once against each parent's head, as the handoff says, then reread every EDITED span by hand.

### m2 Minor: the frontmatter shapes D7 must read
- `dependencies: []` appears in 63 of 81 tasks.
- Some titles are single-quoted.
- TASK-76's real run on TASK-75 to 78 hits neither, so add fixtures for both.

### m3 Minor: `plan_check` does not check the `Plan:` line
Revision 3 adds the line (B8), but D7 does not check it. Its "(revision N)" suffix is already stale in TASK-75 and TASK-76.

### m4 Minor: D12 misses `tools/workflow/sample/stage.yaml`
The workflow tool's README says the tests use it.

### m5 Minor: the T5 start condition may never hold
- All three branches in flight change `docs/workflow`, because the model cites widely.
- The rule has no fallback.
- `feat/contract-stage-2` has merged (addc8dd).

### Note
Name which lines of `review.md` that list the reviewers change: 7-21, 135-137, 244-247 and 281.

## Impact map
(C covered, M missed)
- **Code and agents:** C: the three agents, the two skills, `plan_check` and its tests, the Codex TOMLs and README, lens 5.
- **Data and contracts:** C: the header, milestones, report paths. M: frontmatter dependencies (P3), the frozen set in the gate (P2), the `Plan:` line (m3).
- **Tests:** C: the `run.py` wiring and the Bun tests. M: the guard asserts at lines 210 and 471 (P1), the sample stage (m4).
- **Generated:** C: anchors, render, atlas, the four stale pages (`atlas.py check` confirms them). M: the base after a merge (m1).
- **Docs and context:** C: all the rows in the Changed table.
- **Tooling and CI:** C: ruff, Bun, the permission rules. M: the CLI's local-only view (P4, P5).
- **Work in flight:** C: the rule. M: tasks that are Active on branches (P5), the start condition (m5).
- **Decisions:** C: D12, D17, Opus.

Round 2: A2 to A8 and B2, B3, B5 to B11 are answered. Partly answered: A1 and B4 (P6), A3 and B1 (P4). The fix for B2 introduced P1.

## Facts checked
| Claim | Result |
|---|---|
| The `repo_maintenance.py:59` reader handles flat keys only | true |
| `stage.yaml` 233-240 holds `design.client-review` | true |
| `repo-maintenance.md` lines 90 and 150 are stale | true |
| The four STALE pages | true |
| `run.py` has `--output` | true |
| Tasks were created after the plan's branch | false (branch made at 9b06670, the queue commit) |
| `run.py` installs Bun itself when it is missing | true (line 510) |

## Limitations
- `bun run anchors` was not run.
- `private/` was not read.
- I ran as a general-purpose agent following the definition.

## Verdict: FINDINGS
