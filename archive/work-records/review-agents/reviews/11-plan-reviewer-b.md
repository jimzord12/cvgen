# Plan review round 4: review-agents (reviewer B)

Snapshot: `archive/work-records/review-agents/plan.md` at b16bb4b (revision 4), with TASK-73 to 78 at the same commit. I ran as a general-purpose agent following `.claude/agents/plan-reviewer.md`.

Blind map: code and agents 9 · data and contracts 6 · tests 7 · generated 5 · docs and context 15 · tooling and CI 4 · work in flight 5 · decisions 5. The full map is under "Impact map".

Checklist:
1. **Impact:** covered, apart from the merge and anchor gap (P3).
2. **Fit:** OK.
3. **Facts:** true where checked. The probe rules were proven on one probe that changes no output (P1).
4. **Compatibility:** OK. The reader handles every frontmatter shape on all five branches.
5. **Reversibility:** n/a. The work is docs, agents and one script.
6. **Verification:** TASK-75's evidence repeats calibration 04's easy case (P1).
7. **Failure:** an inconclusive probe is handled, but on most of the suite every probe is inconclusive (P1).
8. **Sequencing:** OK, with m1.
9. **Unknowns:** a fault probe that changes rendered output has never been tried (P1).
10. **Decisions:** OK. Main's 2026-11-08 deletion grade bears on D5's removal (m1).
11. **Proportion:** OK.
12. **Procedures:** P1, P2, P3, m2 to m4.
13. **Model fit:** shared assert lines, Bun tests, skipped cases (P2); the `Plan:` value (m3).

Procedures walked:
- **D5, the probes:**
  - A fault that changes the engineer example's output is caught first by the reference check at `run.py:279-280` (P1).
  - The 198 compile cases share one assert line (P2).
  - `tools/workflow/test/**` is never run by `run.py` (P2).
  - A probed case that is skipped on this machine gives no result (P2).
  - The lead's working folder is a branch worktree, so a relative path nests the copy (m2).
  - A crash or a dead session leaves the copy behind (m2).
  - The `--force` removal sits against main's new deletion grade (m1).
- **D7, `plan_check`:**
  - The reader is OK for `[]`, `''` escapes and `>-` titles, checked on all branches.
  - "Root is `main`" is unspecified, and the check never refuses there (m3).
- **D8, the loop:**
  - OK for a first run and for a re-scope.
  - A child branch "merging `main`" skips its parent branch (m4).
- **D13, the transition:** OK. "Piece of work" is undefined (Note).
- **Merge, then regenerate:** misses this branch's own shifted anchors (P3).

Round 3: every finding is answered. A3-P2's crash case is only partly answered (m2). Revision 4 dropped revision 3's sentence on permission rules. The owner's settings carry no rules, so this is not a finding.

## Findings

### P1 Material: a fault probe cannot reach most checks
Anchor: D5 "The run"; `tests/run.py:276-280`; `tests/verify.py:28`.
- The engineer example is compared pixel by pixel with the frozen reference at line 279. Most of `main()`'s checks run after that line.
- A fault in Framework or Flagship rendering code changes that example. The suite then stops at line 280, so under D5's rule the result is "inconclusive", and a rerun gives the same result.
- Calibration 04 chose a probe that changes no output. TASK-75's evidence repeats that case.
- Consequence: "can fail", the rubric's main test, has no working procedure for the most common kind of test here.
- Smallest fix:
  - D5 says what to do when the first failure is a by-design detector. In the copy, the probe commit re-baselines it: replace the approved PDF with the probe's render and its pin in `baseline.json`, then rerun. Otherwise the reviewer judges that test by reading and says so.
  - TASK-75's evidence adds one fault probe that changes the engineer example.

### P2 Material: D5's match rule and run command do not fit three shapes the suite has
Anchor: D5; D12; `run.py:174-193`, `:500-525`; `verify.yml:100-106`.
- **Shared assert lines.** All 198 compile cases fail at `run.py:189` or `:191`. "By file and line" accepts an earlier case as the probed one. The case name is in the assertion message: match on file, line and case.
- **Bun tests.** `run.py` runs `bun run check`, `render` and `atlas`, never `bun test`. CI runs `bun test` separately. A probe guarded by `tools/workflow/test/**` (inside D12) "survives" under D5's command.
  - Name the Bun run: `bun test <file>` in `<copy>/tools/workflow`, with `PYTHON` set to the `.venv` interpreter.
  - Bun reports every failure, so a fault counts when the probed test fails by name.
  - Try it once, or say Bun tests are judged by reading until it has been tried.
- **Skipped cases.** A case skipped on this machine (`fonts-system`, or `workflow-model` without Bun) cannot fail. A probe on it is inconclusive.

### P3 Material: "anchors against each parent's head" misses this branch's own shifts
Anchor: Sequencing, "Merging `main` in"; TASK-78 AC #2.
- The model cites `docs/review.md` 16 times. Commit 6452dec gave 12 of those citations values that `main` does not have (242-260, 248-255, 256-260, 283-286).
- `main` has not changed `review.md`. So:
  - against the branch head, the cited file has no diff;
  - against `main`'s head, those values are "written since", so the tool does not judge them (`tools/workflow/README.md:279-285`).
- T2 and T4 edit `review.md` above those lines (the intro, the Opus list, loop step 1). The shifts land on `main` unseen, and `check` still passes.
- `client-journey` also goes STALE from T2 onward, and the handoff exception does not list it.
- Smallest fix: each task that edits a cited file re-anchors in the same task, as 6452dec did, so each branch head is a valid baseline. Alternatively, T5 also runs `bun run anchors 6452dec`. Add `client-journey` to the STALE exception.

### m1 Minor: merge `main` before TASK-75
- Since the merge base, `main` changed three files T2 edits: `verification.md` (checks 18 and 20 added, 19 renumbered), `git-workflow.md` and the glossary.
- Its `preferences.md` now lets agents remove a worktree "once it holds no uncommitted work".
- `git worktree remove` without `--force` already ignores the copy's ignored `builds/`. Use `--force` only on a probe the same run left uncommitted, and cite that grade.

### m2 Minor: the copy's path and a leftover copy
- Give the absolute path: `git -C <Main Folder> worktree add --detach <Main Folder>/.worktrees/probe-…`.
- Say that a later session may remove a clean `probe-*` copy left by a dead round.

### m3 Minor: `plan_check`'s `Plan:` check
- How the script knows "the root is `main`" is unspecified.
- Step 3 checks Queued tasks on `main`, so a wrong `Plan:` line (for example "none") is only reported, never refused.
- Fix: take the expected path as an argument (`--plan <path>`) and refuse any task whose line differs.

### m4 Minor: D8.3 on a child branch
Main's changes should reach a child branch through the `Plan`'s branch (`git-workflow.md:41-45`). Say "after merging `main` into the `Plan`'s branch, and that branch into the child".

### m5 Minor: TASK-76's gate
TASK-76 also edits `AGENTS.md`. A change that mixes code and context gets the context-reviewer as well (`review.md:12-13`).

### m6 Minor (unverified): the Codex tests-reviewer's commits
Under `workspace-write`, committing in the copy writes into `<Main Folder>/.git`, which may be read-only to Codex. The reviewer's verdict is advisory either way. Check once in T5, or state the limit.

### Note
- `review.md:281` lists the reviewers that have their own report shape; it needs the two new ones.
- Nothing states the mapping T2 to T5 = TASK-75 to 78.
- D13 does not define "piece of work". TASK-81 is linked to its work only through its header.

## Impact map
(C covered, M missed)
- **Code and agents:** C, all nine.
- **Data:** C: header, `--dep` (confirmed in `backlog task create --help`), milestones, D12 paths (no test file on any branch falls outside them), baseline pins. M: the `Plan:` value (m3).
- **Tests:** C: `check_frozen`, `workflow.py:103`, fixtures. M: the reference check at line 280 (P1), shared asserts, `bun test`, skips (P2).
- **Generated:** C: Atlas pages, lock, render. M: the branch's own anchors, `client-journey` (P3).
- **Docs:** C: every row. M: `review.md:281` (Note), `preferences.md` (m1).
- **Work in flight:** C: three travel branches (`AGENTS.md` 795 words there, lines 3-4 only), the merge simulation (conflicts only in Atlas generated files).
- **Decisions:** C.

## Facts checked
| Claim | Result |
|---|---|
| ADR 0018 is free on all branches | true |
| `roster.json` exists | true |
| `repo-maintenance.md` lines 90 and 150 are stale | true |
| `design.engine-review` and `design.client-review` exist | true |
| `AGENTS.md` is 797 words | true |
| `workflow.py:103` asserts a clean engine | true |
| `--dep` exists in Backlog.md 1.55.3 | true |
| `tools/workflow/sample/` exists | true |
| Glossary edit 9929b69 shifted no anchor (inserted at line 84; anchors cite up to 81) | true |
| `run.py` runs `bun test` | false |
| A probe that changes the engineer example reaches the checks after line 280 | false |

## Limitations
- No probe, suite or `bun run anchors` was run. P1 to P3 come from reading the code.
- I did not read `private/`.
- One read-only command ran with the `Main Folder` as its working directory (`git config`, `ls .git/hooks`).
- The merge simulation used `git merge-tree`'s old three-argument form, which writes nothing.

## Verdict: FINDINGS
