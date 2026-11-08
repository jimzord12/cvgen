# Plan review round 4: review-agents (reviewer A)

Snapshot: `archive/work-records/review-agents/plan.md` at b16bb4b (revision 4), with TASK-75 to TASK-78 at the same commit. TASK-73 and TASK-74 were checked as built (both `status: Ready`).

Blind map: agents and skills 8 · data and contracts 6 · tests 8 · generated 4 · docs and context 15 · tooling and CI 5 · work in flight 6 · decisions 5. The full map is under "Impact map" below.

Checklist:
1. **Impact:** mostly covered. Missed: within-branch anchor drift (P3), and Bun tests are not in the suite (P1).
2. **Fit:** OK.
3. **Facts:** true, except the implied claim that `tests/run.py` runs every D12 test (P1).
4. **Compatibility:** OK. D13 reads each task's state from its own branch.
5. **Reversibility:** n/a. The changes are docs, agents and one script. Probe commits are dangling objects in a removed checkout.
6. **Verification:** D5's evidence has been tried on one check only, the last one in the suite (P2).
7. **Failure:** a crashed probe round leaves `probe-*` behind, and no rule says who may remove it (m2).
8. **Sequencing:** the merge rule is sound for merges. It misses edits made inside the branch (P3).
9. **Unknowns:** P1 and P2 are untested paths of D5. The plan's Risks section names the Bun one but gives no instruction for it.
10. **Decisions:** OK. Revision 4 dropped revision 3's permissions sentence (m1).
11. **Proportion:** OK.
12. **Procedures:** see "Procedures walked".
13. **Model fit:** the fault probe needs three outcomes, not two (P2).

Procedures walked:
- **D5, probe round.**
  - Python test, probed check reached: works, as calibration 04 shows.
  - Probed check sits after a check the same fault breaks: forks (P2).
  - Bun test: no run is stated (P1).
  - Crash, then the next session: m2.
  - Subagent commits under the owner's settings: m1.
  - Another operating system: m3.
- **D8, plan → tasks → `plan_check` → decomposition → Active:** OK. Rounds 2 and 3's forks are answered.
- **D13, transition:** OK.
- **Merge `main`, then regenerate:** OK at a merge. It forks when T2 or T4 edits a cited file without re-anchoring (P3).

Round 3 findings:
- **Answered:** all of them (A3-P1 to P9, B3-P1 to P6, m1 to m5). The tasks now point to the plan. TASK-78's old note is marked superseded.
- **New problems:**
  - P2 comes from the first-failure rule adopted for A3-P1 and B3-P1.
  - m1 comes from revision 3's permission sentence being dropped.

## Findings

### P1 Material: D5's run never runs a Bun test, yet D12 gates them
Anchor: D5, "The run"; D12; `tests/run.py:500-519`; `.github/workflows/verify.yml:101-106`; `tools/workflow/package.json`.
- **Gap:** `tests/run.py` runs `bun install`, `run check`, `render --check`, `atlas --check` and `reality`. It never runs `bun test`; only CI does.
- **Consequence:** D12 puts `tools/workflow/test/**` (eight `*.test.ts` files) and `sample/**` in the gate.
  - For a fault probe on one of these, the first failure can never be the probed `.test.ts` line. Every such probe is inconclusive, or reads a `bun run check` failure.
  - T2's `verification.md` text, "how a probe runs", would be wrong for a third of the trigger.
  - The plan's line "the lead runs `bun install`" assumes a Bun run that D5 never names.
- **Smallest fix:**
  - Name the Bun run in D5: `bun test <file>` in `<copy>/tools/workflow`. It reports per test and does not stop at the first failure, so a fault counts when the probed test fails, and a refactor counts when all pass.
  - Either add one Bun probe to TASK-75's evidence, or state that Bun tests are judged by reading until one is tried.

### P2 Material: the first-failure rule leaves most behaviour probes inconclusive
Anchor: D5, "The run". `tests/run.py:210-213` and `:279`; calibration 04.
- **Gap:** the suite is one chain of asserts.
  - At `run.py:279` it compares the engineer example to the frozen approved PDF, ahead of the layout, options, pagination and workflow checks (lines 284-470).
  - A fault probe on rendering behaviour that one of those later checks guards fails first at 279 or at an earlier fixture.
  - D5 calls that "inconclusive … rerun or reported". A rerun is deterministic and changes nothing.
  - The spike probed `check_core_boundary`, the suite's last check, so it never met this case.
- **Missed outcome:** a first failure *after* the probed check is conclusive: the probed check ran and passed, so the test survived its fault. D5 has no word for this.
- **Consequence:** the "can fail" rubric goes unproven for the main kind of test, and a redundant test cannot be told apart from one that guards.
- **Smallest fix:** three outcomes in D5 and in T2's text:
  - **caught:** the first failure is the probed assertion.
  - **survived:** the suite passes, or the first failure comes after the probed check.
  - **masked by X:** an earlier check fails first. The reviewer then commits one more change in the copy that skips X, reruns, and records the diff. Being masked is itself evidence of overlap for D6.

### P3 Material: anchor drift from T2 and T4 escapes the per-parent-head rule
Anchor: Sequencing, "Merging `main` in"; the Files table (`review.md`, `development.md`, `verification.md`, `glossary.md`); `tools/workflow/README.md:277-284`; 6452dec.
- **What is cited:** the Workflow Model and the Atlas cite `docs/review.md` 26 times. They also cite `development.md`, `verification.md:26-38` and `glossary.md:38-81`.
- **Why the suite misses it:** `check` only proves that cited lines exist.
  - T2 and T4 rewrite `review.md`. T2's "how a probe runs" naturally lands in `verification.md`, "Run", lines 6-38.
  - The suite passes while the citations drift.
- **Why the merge rule misses it:**
  - `anchors` diffs against a base where the anchors were good.
  - Against the branch's pre-merge head, it sees no change to `review.md`.
  - Against `main`'s head, it compares the branch's anchors with `main`'s older `review.md`.
  - Neither run finds the drift. TASK-74's drift was found only by a plan reviewer (6452dec).
- **Smallest fix:** every task that edits a cited file ends with `bun run anchors <last anchor-good commit> --fix`, plus a hand reread of every EDITED span and `render`. For T2 that commit is 6452dec. Each task then leaves the branch anchor-good, and the per-parent rule holds at merges.

### m1 Minor: the permissions sentence dropped in revision 4
Revision 3 named the permission rules the probes need, "for the owner to allow, or the round runs attended". The tests-reviewer now writes files, commits, and resets between probes in `.worktrees/probe-*`; the spike was run by the lead, not by a subagent. Restore the sentence and name the exact commands.

### m2 Minor: an orphaned `probe-*` checkout has no owner
`git-workflow.md:51` says "Never edit another session's worktree", and the Session Sweep lists worktrees. In T2's `git-workflow.md` text, say that any session may remove a `probe-*` not in a running round (`remove --force`, then `prune`).

### m3 Minor: the interpreter path is Windows-only and undocumented
`.venv/Scripts/python.exe` appears nowhere in `docs/tech-stack.md`; the `.venv` exists only in the Main Folder. Write it as "the repository's interpreter with `requirements.lock` installed", with both the Windows and POSIX paths.

### Notes
- `studio/brand/report/sample.json` is read by `tests/report.py:10` but lies outside D12.
- Codex's workspace-write sandbox may keep `.git` read-only, which would block probe commits. This is unverified; D9's verdict is advisory either way.
- D7: a header such as "Depends on: none; drives TASK-N" with an empty frontmatter list would be refused.
- D18: the tests-reviewer joins `design.engine-review` only when D12 paths change.

## Impact map
(C covered, M missed)
- **Agents and skills:** C: three agents, the two skills, the backlog, new-cv and new-theme skills, the TOMLs and the `.codex` README.
- **Data and contracts:** C: task header, `--dep`, milestones, frozen set, report paths.
- **Tests:** C: `plan_check` fixtures, the `run.py` wiring, the D12 paths. M: `bun test` outside the suite (P1); chain order and the frozen comparison at line 279 (P2); `sample.json` (Note).
- **Generated outputs:** C: render, atlas, stamps, the STALE exception. M: within-branch drift (P3).
- **Docs and context:** C: all rows in the Changed table.
- **Tooling and CI:** C: ruff, CI Bun steps. M: permissions (m1), interpreter (m3).
- **Work in flight:** C: three branches, `main`'s 43 commits (`verification.md`, `run.py`, the Atlas), ADR 0018 free on every branch.
- **Decisions:** C: D12, D17, Opus, read-only plus the copy, two reviewers.

## Facts checked
- `run.py` does not run `bun test`; CI does (`verify.yml:102`): true.
- The frozen engineer comparison is at `run.py:279`, before the layout checks: true.
- `workflow.py:103` asserts a clean engine: true.
- `check` proves only that anchors exist (`README.md:277`): true.
- No cited file has changed since 6452dec except the glossary, whose rows were added below the cited lines: true.
- TASK-73 and TASK-74 are Ready; the tasks point to the plan: true.
- `main` has not touched task-73 to 78: true.
- No branch in flight touches `review.md` or `development.md`; all three touch `verification.md`, `run.py` and the Atlas: true.
- `repo-maintenance.md:90` and `:150` are stale: true.
- No git hooks; the design-review test uses a free port: true.

## Limitations
- I ran as a general-purpose agent following the definition.
- I ran no probe, no suite and no `bun run anchors`. P1 to P3 come from reading the code.
- I did not read `private/`, and I did not read the other reviewer's report.

## Verdict: FINDINGS
