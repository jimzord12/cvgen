# Plan review round 3: review-agents (reviewer A)

Snapshot: `archive/work-records/review-agents/plan.md` at 4187667 (revision 3), with TASK-75 to TASK-78 at the same commit. TASK-73 and TASK-74 are treated as built.

Blind map: code and agents 9 · data and contracts 6 · tests 7 · generated 4 · docs and context 16 · tooling and CI 5 · work in flight 6 · decisions 5. The full map is under "Impact map" below.

Checklist:
1. Impact: mostly covered. Misses `docs/git-workflow.md` (P2) and `AGENTS.md:39` (P8).
2. Fit: OK. The frozen set is named more narrowly than in the constitution (P7).
3. Facts: D5's run command and "read the probed case's result" do not match `tests/run.py` (P1).
4. Compatibility: plan_check's reader misses `dependencies: []`, the shape 60 tasks use (P4).
5. Reversibility: n/a. Docs, agents and one script, all revertible. ADR 0018 records the gates.
6. Verification: TASK-75 AC #4 is observable, but real probes on engine code give false results (P1).
7. Failure: a round cut off midway leaves a registered worktree under `builds/` (P2).
8. Sequencing: T5's quiet-window precondition is rarely satisfiable (P5).
9. Unknowns: D5's run is load-bearing and has never been tried once (P1).
10. Decisions: D12 and D17 are the owner's answers. The permissions are named for him. OK.
11. Proportion: OK. D18 is the smaller option.
12. Procedures: D5 forks (P1, P2). D8 forks on later changes (P6).
13. Model fit: `[]` lists (P4). The frozen set versus `baseline.json` pins (P7).

Procedures walked:
- **D5 copy and probes:**
  - Default cwd: the run tests the outer checkout, not the copy. Agent shells reset cwd between calls.
  - Engine probe: the run aborts at `workflow.py:103` because the copy is dirty.
  - Pinned-file probe: the run aborts at the first `check_frozen`.
  - Crash: a stale worktree is left behind.
  - Cleaning `builds/` "by path": leaves a prunable worktree registration.
  - Placement: conflicts with `git-workflow.md:43-50`.
- **D8 plan → tasks → plan_check → decomposition → Active:**
  - OK for a first run, with `--root`.
  - Forks when a task the branch already works is later re-scoped, and when the tasks use branches other than the plan's (P6).
- **Merge `main` → regenerate:** OK.
- **T5 start condition:** forks indefinitely (P5).
- **Codex pointers (D9):** OK.
- **Transition (D13):** OK, because `check_active_branches: true` lets the CLI see branch states.

Round 2 findings:
- **Answered:** A2, A3 (the sync is declined with a reason in D8.5), A4 in the plan, A5 in the plan, A6, A7, A8, B1 to B3, B5 to B11.
- **Not answered: A1 and B4, the tasks.** The tasks still disagree with the plan (P3).
- **New problems from the answers:**
  - The worktree copy (A2/B2) now makes `engine_state` see the probe edits (P1).
  - Placing it under `builds/` conflicts with the worktree rule (P2).

## Findings

### P1 Material: D5's run reads a result the suite does not produce
Anchor: D5, "The run". `tests/run.py:159-210, 471, 520-530`; `tests/workflow.py:103`; `tests/verify.py:17-21`.
- **The suite stops at the first failure.** Every check is a bare `assert` in `main()`. `report.json` is written only when every check passes. No per-case result exists after a failure.
- **Engine probes fail for an unrelated reason.**
  - The copy is a real worktree, so `engine_state` sees probe edits under `packages/cv-framework` or `packages/domains` as uncommitted.
  - `workflow.py:103` asserts `engine_uncommitted_changes is False`, so the run aborts there.
  - Fault probe: planting a domain import in the Framework to probe `check_core_boundary` (line 527) shows "failed", but the boundary check never ran. That is a false "guards".
  - Refactor probe: every engine refactor fails, so every `workflow-*` check and every later check looks like a change detector.
- **Pinned files:** a probe on a file pinned in `baseline.json` aborts at the first `check_frozen` (line 210).
- **Wrong checkout:** `python tests/run.py --output <copy>/builds/...` from the default cwd runs the outer checkout. The probe is not there, so every fault "survives".
- **Fix:**
  - Run `python <copy>/tests/run.py --output <copy>/builds/...`. ROOT comes from the file's path (`verify.py:10`).
  - A probe counts only when the traceback names the probed assertion.
  - Commit each probe in the copy's detached HEAD, or account for the dirty-engine assertion.
  - Do one fault probe and one refactor probe on an engine case before writing T2's text (question 9).

### P2 Material: the copy's location breaks the worktree rule, and its lifecycle is unstated
Anchor: D5 "The copy". `docs/git-workflow.md:43-50`; `docs/development.md:126`.
- **Placement:** worktrees live only under `.worktrees/`. The single exception is the backlog skill's scratchpad checkout. D5 creates one under `builds/`. The Changed table names neither file.
- **Lifecycle:**
  - A crashed round leaves the worktree registered.
  - "Clear old folders by path" leaves a prunable entry.
  - The Session Sweep's `git worktree list` shows detached checkouts with no owner.
- **Fix:** add `docs/git-workflow.md` (the exception) and `development.md`'s `builds/` line to the Changed table for T2. Say `git worktree remove --force`, or `git worktree prune` after deleting the folder. Forbid `git stash` in the copy, because the stash stack is shared.

### P3 Material: the tasks still disagree with revision 3 (A1/B4 recur)
Anchor: Tasks; `backlog/tasks/task-75…`, `task-76…`, `task-78…`.
- **TASK-75 outcome:**
  - It still says "a git-archive copy" and "case selection only if chosen". D5 now says a worktree, and no case selection.
  - Its header says "Plan: … (revision 2)".
- **TASK-76:**
  - The outcome says the header must "agree", and AC #4 refuses "a header that disagrees". D7 reports a non-dependency in the header and does not refuse it. TASK-80's "drives TASK-68" would be refused.
  - It says "a known milestone id", where D7 checks for a file. `--root` is missing.
  - The fixture for the "reported, not refused" case is missing.
- **TASK-78 Implementation Notes ("after plan revision 2"):**
  - They keep the full Workflow Model change. D18 replaced it.
  - They keep the `code-reviewer.toml` edit. D10 drops it.
  - They name `repo-maintenance.md:150` only, not line 90.
  - They keep a fixed branch list.
- **Fix:** edit the three tasks to match D5, D7, D10 and D18 on this branch.

### P4 Minor: plan_check's reader omits `[]`
D7 lists "scalars, `>-` folded text, `- ` lists". 60 task files write `dependencies: []`, and 78 write `assignee: []`. If `[]` is read as a scalar, the reader refuses a dependency named "[]". Name the shape and add a fixture for it.

### P5 Minor: T5's start condition is rarely true
All three branches in flight change both the Workflow Model and the Atlas, and they are stacked on each other. Every docs branch re-anchors both. Merging `main` and then regenerating already resolves the collision. Drop the quiet window, or bound it.

### P6 Minor: D8 step 6 has no location
- **A re-scoped task already worked on a branch:** its live copy is on that branch. Say "plan_check `--root` on that branch" for it.
- **A plan whose tasks run on other branches:** say when the plan's branch merges, so the `Plan:` header resolves on `main`.

### P7 Minor: the frozen set is narrower than the constitution's
D6 and D12 name only `tests/approved/*.pdf`. Constitution §1 freezes every pin in `tests/baseline.json`, "whether or not the comparison uses them". A "no test for its own sake" reviewer would flag exactly those pins. Name the whole frozen set.

### P8 Minor: `AGENTS.md:39` lists every script
`plan_check.py` would be missing from that list. Adding it costs one word: 797 becomes 798.

### P9 Note
- "Decomposition" is a recurring term with no glossary row.
- Name commit 9929b69 for the rubrics in revision 2.
- plan_check could check the `Plan:` line.
- The handoff's STALE exception is still to be written.

## Impact map
(C covered, M missed)
- **Agents and skills:** C: the three agents, both skills, the backlog, new-cv and new-theme skills, three TOMLs and the README.
- **Data and contracts:** C: frontmatter and header, milestones, report paths. M: `[]` (P4), the baseline pins (P7).
- **Tests:** C: plan_check fixtures, the D12 paths, Bun. M: fail-fast, the dirty-engine assertion, `check_frozen` (P1).
- **Generated outputs:** C: anchors, render, Atlas pages and lock.
- **Docs and context:** C: review.md, development.md, verification.md, conventions.md, glossary, ADR, history, handoff, repo-maintenance.md 90 and 150. M: git-workflow.md (P2), AGENTS.md:39 (P8).
- **Tooling and CI:** C: ruff, CI without the backlog CLI, the permissions in `settings.json`.
- **Work in flight:** C: `main`'s drift (80 files), travel-domain, travel-contract-v2, hanami-essential, TASK-2 and TASK-79 to 81 by branch. M: the quiet window (P5).
- **Decisions:** C: D12, D17, Opus at high, read-only, two reviewers.

## Facts checked
- Cases are inline and stop at the first failure: true.
- `report.json` is written only on a pass: true.
- `workflow.py:103` asserts a clean engine: true.
- `check_frozen` runs first: true.
- ROOT comes from the file's path: true.
- `run.py --output` exists: true.
- `stage.yaml:233-240` names two reviewers in one step: true.
- `repo_maintenance.py:59` reads flat keys only: true.
- `dependencies: []` appears in 60 files: true.
- ADR 0018 is free on every branch: true.
- AGENTS.md is 797 words: true.
- `review.md:200` already lists plan-reviewer: true.
- `repo-maintenance.md:90` and `:150` are stale: true.
- No test file sits outside the D12 paths: true.
- `check_active_branches: true`: true.
- The suite runs in about 45 seconds: true (from travel-domain's evidence).

## Limitations
- I ran as a general-purpose agent following the definition.
- I did not read `private/`.
- I ran no probe and no suite. The P1 claims come from reading the code.
- I did not run `bun run anchors`.

## Verdict: FINDINGS
