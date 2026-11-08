# Plan review round 5: review-agents (reviewer A)

Snapshot: `archive/work-records/review-agents/plan.md` at 123db03 (revision 5), with TASK-73 to TASK-78 at the same commit. I ran as a general-purpose agent following `.claude/agents/plan-reviewer.md`.

Blind map, built from the goal before I opened the plan: code and agents 7 · data and contracts 5 · tests 7 · generated outputs 4 · docs and context 15 · tooling and CI 5 · work in flight 5 · decisions 5. The full map is under "Impact map".

Checklist:
1. **Impact:** covered. One small gap: the AGENTS.md `.worktrees/` row (P4).
2. **Fit:** OK. Re-baselining the frozen reference in the copy needs one sentence placing it against constitution section 1 (P3).
3. **Facts:** true where checked. One example in the plan, "(6452dec for T2)", contradicts its own sequencing (P1).
4. **Compatibility:** OK. D13 is consistent with TASK-79 and TASK-80, which are Active on their own branches.
5. **Reversibility:** n/a. The work is docs, agents and one script. Probe commits are never reachable from a branch.
6. **Verification:** OK. TASK-75's evidence now covers the masked path and one Bun probe.
7. **Failure:** a test that already fails before the probe is not handled (P2).
8. **Sequencing:** OK, apart from P1.
9. **Unknowns:** OK. The Risks section states that the masked path and Bun are judged by reading until TASK-75 proves them.
10. **Decisions:** OK. Read-only "apart from D5's copy" is listed as a Major decision.
11. **Proportion:** OK.
12. **Procedures:** see below.
13. **Model fit:** OK. The D7 reader shapes match every branch.

Procedures walked:
- **D5 probe round:** prepare the copy, Bun install, fault probe, masked, re-baseline, rerun, return to the base, refactor probe, remove the copy.
  - Forks at a failure that exists before the probe (P2).
  - Forks at the step back to the base and the re-baseline step, which the stated boundary does not allow (P3).
  - Removal is OK: `git worktree remove` ignores `builds/` and `node_modules`.
- **D8:** plan on the branch → tasks on `main` → `plan_check` → decomposition review → merge `main` → Active. OK.
- **D13 transition:** OK.
- **Merge `main`, then re-anchor:** P1.

Round 4: every finding is answered. A4-P1 to P3, B4-P1 to P3, A4-m1 to m3, B4-m1 to m6 and the Notes are all carried into revision 5. B4-P2's "with `PYTHON` set to the `.venv` interpreter" was dropped without a reason (P2). One answer added a new problem (P1).

## Findings

### P1 Minor: "(6452dec for T2)" contradicts merging `main` before TASK-75
Anchor: Sequencing, "Each task leaves the branch anchor-good"; `tools/workflow/README.md:279-285`.
- **Gap:** "Merging `main` in" puts a merge before TASK-75. After that merge and its regeneration, the last anchor-good commit is the merge commit, not 6452dec.
- **Why it matters:** `anchors` judges only anchors that were already in the model at the base commit. Anchors that `main` wrote after 6452dec are skipped, so T2's shifts to them would go unseen. That is round 4's P3 again, on a smaller scale.
- **Today's effect:** small. `main`'s glossary edits are in place (hunks at lines 40-56 and 77, no line count change), so the old base yields only spurious EDITED lines.
- **Fix:** "the commit that merged `main` in, for T2".

### P2 Minor: no clean run before reading a probe outcome; Bun runs without `PYTHON`
Anchor: D5, "The runs" and "Three outcomes"; `tools/workflow/src/check.ts:371`; `test/atlas.test.ts:52`; `test/check.test.ts:67`.
- **Python on PATH lacks the packages:** I verified `ModuleNotFoundError: fitz` with the PATH Python. Bun's check and atlas tests then fail without any probe.
- **How a pre-existing failure misreads:**
  - In `bun test`, a failure in the probed test reads as **caught**.
  - In the Python chain, an earlier failure reads as **masked**, then as overlap evidence for D6, which can lead to removing a test.
- **Other causes:** the handoff's out-of-memory pitfall (two suite runs at once), and Git Bash swallowing `bun run` exit codes.
- **Fix:** in T2's `verification.md` text:
  - read no fault outcome until a full pass of that copy in that environment (the refactor probe can serve);
  - run Bun with `PYTHON=<the .venv interpreter>`, from PowerShell;
  - run one suite at a time.

### P3 Minor: the boundary omits the moves the round needs; the re-baseline needs a sentence on the constitution
Anchor: D5, "The boundary" and "masked by X"; `docs/constitution.md:28-34`.
- **What the boundary allows:** "commit probes … and run its tests; nothing else".
- **What the round also needs:**
  - writing files with the shell;
  - returning to the base between probes (`git checkout --detach <base>`);
  - copying the probe's render into `tests/approved/` and editing `baseline.json`.
- **The constitution:** it calls changing a pinned file a design decision that needs an ADR.
- **Fix:** list these moves in T2's text. Add that a probe commit is never reachable from a branch, so the frozen set and constitution section 1 are unchanged. Otherwise the reviewer, or TASK-75's context-reviewer, may balk.

### P4 Minor: AGENTS.md's `.worktrees/` row
`AGENTS.md`, "Where things are", reads "one checkout per parallel branch, never another session's". D5 adds detached `probe-*` copies that any session may remove. T2's Files rows leave AGENTS.md out. Fix: add AGENTS.md to T2's rows, or name it for T5 (word count 797/798).

### Notes
- TASK-76's run on TASK-79 to 81 from `main`:
  - None of the three has a `Plan:` line.
  - TASK-81's header names dependencies while its frontmatter list is empty.
  - So all three are refused. Say what the run is expected to show, and which `--plan` it uses.
- "No running round owns" cannot be checked by another session. If the lead records the copy's path in the task notes, the next session has a basis.

## Impact map
(C covered, M missed)
- **Code and agents:** C: three agents, the `plan` and `test-principles` skills, `plan_check.py`, the backlog skill.
- **Data and contracts:** C: `Plan:` and `Depends on`, `--dep`, m-7 and m-8 (both exist), the frozen set, report names.
- **Tests:**
  - C: `run.py`'s chain with the frozen comparison at line 279, `check_frozen` inside `verify()`, `workflow.py`'s clean-engine assertion, `bun test` (CI only), the D12 paths. No test file outside D12 exists.
  - M: a failure that exists before the probe (P2).
- **Generated outputs:** C: model anchors, generated READMEs, client-journey, the four STALE pages and the lock.
- **Docs and context:**
  - C: `review.md`, `development.md` (stage table, file map, the flow), `conventions.md`, `verification.md`, `git-workflow.md`, glossary, `new-cv`, `new-theme`, `repo-maintenance.md` lines 90 and 150, `.codex`, ADR 0018, history, handoff.
  - M: AGENTS.md row (P4), constitution section 1 wording (P3).
- **Tooling and CI:** C: Linux and Windows CI, ruff, `.venv`, `anchors`, permissions. M: `PYTHON` for Bun (P2).
- **Work in flight:** C: the three travel branches (D13), `main` 43 commits ahead, TASK-79 to 81.
- **Decisions:** C.

## Facts checked
- `anchors <commit> [--fix]` exists; MOVED and EDITED behave as the plan says: true.
- `verify()` calls `check_frozen()`, so a re-baseline must update the pin: true; D5 says so.
- Tests put the copy's `packages/cv-workflow` first on `sys.path`, and `.venv` has no installed copy that would shadow it: true.
- ADR 0018 is free on all five heads: true.
- TASK-73 and TASK-74 are Ready; TASK-75 to 78 point to the plan: true.
- `design.engine-review` and `design.client-review` exist: true.
- The project settings hold only `allow` rules for `backlog`, no deny rules: true.
- AGENTS.md has 797 words here and on `main`, 795 on the three travel branches: true.

## Limitations
- I ran no probe, no suite and no `anchors`.
- I did not read `private/` or the other reviewer's round 5 report.

## Verdict: PASS
No Blocking or Material finding remains. P1 to P4 are one-line wording fixes for T2's text and the Files table.
