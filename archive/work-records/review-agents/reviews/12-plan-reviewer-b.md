# Plan review round 5: review-agents (reviewer B)

Snapshot: `archive/work-records/review-agents/plan.md` at 123db03 (revision 5), with TASK-73 to 78 at the same commit. I ran as a general-purpose agent following `.claude/agents/plan-reviewer.md`.

Blind map (built from the goal before reading the plan): code and agents 10 · data and contracts 6 · tests 8 · generated 4 · docs and context 16 · tooling and CI 5 · work in flight 5 · decisions 5. The full map is under "Impact map".

Checklist:
1. **Impact:** covered. Nothing on my map is missing from the plan.
2. **Fit:** OK. One wording gap against constitution §1 and §2 (m6).
3. **Facts:** true, with one exception: D13's "the CLI reads only the local checkout" (Note 1).
4. **Compatibility:** OK. D13 classifies TASK-79 to 81 correctly: they finish under the old rules, because 79 and 80 are Active on their branches.
5. **Reversibility:** n/a. The work is docs, agents and one script; probe commits die with the copy.
6. **Verification:** OK. TASK-75's evidence now covers the masked path and a Bun probe.
7. **Failure:** a crashed round is handled, but nothing marks a live copy as live (m2).
8. **Sequencing:** OK, apart from m1.
9. **Unknowns:** OK. Anything not yet proven is judged by reading until TASK-75 proves it.
10. **Decisions:** OK.
11. **Proportion:** OK. A suite run takes about 50 s (`travel-domain/builds/tests-20261108-130437`: 13:04:37 to 13:05:24), so whole-suite probes are cheap.
12. **Procedures:** m1 to m4.
13. **Model fit:** the refactor probe has no outcomes for failures other than the probed check (m5); Notes 2 to 4.

Procedures walked:
- **Probe copy (D5):**
  - Add and remove: OK.
  - Ignored `builds/`, `node_modules/` and `__pycache__/` do not block `worktree remove`: true.
  - Two sessions at once: forks. A live copy is clean, because its probes are committed, so another session may remove it mid-round (m2).
  - Second probe: forks. Nothing says to return to the base, and the boundary allows only "commit" (m3).
  - Masked path: needs two runs; the probe's render exists only after the first (m3).
  - Bun probe: forks on `PYTHON` and on the outcome rule (m4).
  - Refactor probe failing at another check: forks (m5).
- **Anchor-good per task:** forks after the pre-TASK-75 merge (m1).
- **D7 on the real headers:** checked against "none", "TASK-2 (…)", "TASK-2; drives TASK-68", task slugs and links to proposals or decisions: OK except Notes 3 and 4.
- **D8 loop and D13 transition:** OK. The task files that have backticks in their names are all Done.

Round 4: every finding is answered. B4-P2 (`PYTHON`) and A4-m1 (the exact commands) are only partly answered (m4, m3). A4's Note about "none; drives TASK-N" got no reply (Note 3).

## Findings

### m1 Minor: "6452dec for T2" contradicts the pre-TASK-75 merge
Anchor: Sequencing, both bullets; `tools/workflow/README.md:277-285`.
- Revision 5 merges `main` before TASK-75 starts. After that merge, the last anchor-good commit is the merge commit, not 6452dec.
- `main` changed cited files since then: `new-cv/SKILL.md`, `preferences.md` (anchors 76-78 → 78-80) and the glossary.
- Run against 6452dec, `anchors` re-reports `main`'s EDITED spans. It can also shift an anchor a second time on a value collision; the README warns against exactly this.
- Fix: drop the parenthetical, or write "6452dec, or the merge commit if `main` was merged since".

### m2 Minor: a live probe copy looks orphaned
Anchor: D5, "The copy".
- "Any session may remove a clean `probe-*` copy no running round owns", but nothing records that a round owns it.
- Fix: `git worktree add --lock --reason "<session, round>"`. A locked copy is then removed only by its round, or once that session has ended (`remove` refuses a locked worktree).

### m3 Minor: the commands between probes are missing
Anchor: D5, "A probe is a commit" and "The boundary".
- Before each new probe the reviewer must return to the base (`git -C <copy> checkout --detach <reviewed commit>`). Otherwise a refactor stacked on a fault fails and convicts the test.
- The masked path needs a second commit after the first run, because only that run produces the render to re-baseline from.
- The boundary says "commit … nothing else". Name these commands so the text allows them.

### m4 Minor: the Bun run, partly answered
Anchor: D5, "The runs".
- `check.ts:371`, `atlas.ts:251` and `reality.ts:170` call `process.env.PYTHON || "python"`. PATH's `python` has no `pymupdf` (calibration 04), so `bun test` must set `PYTHON` to the `.venv` interpreter.
- The three outcomes assume a run that stops at its first failure, and Bun does not. Say that a Bun fault counts when the probed test fails by name.

### m5 Minor: the refactor probe's outcomes
Anchor: D5, "A refactor counts only on a full PASS".
- Say what a failure means:
  - **Flagged:** the probed test fails first.
  - **Refactor invalid:** another check fails first, for example the frozen comparison at `run.py:279`. The refactor changed behaviour, and it is redone; it is not evidence against the test.

### m6 Minor: re-baselining in the copy, against the constitution's wording
Anchor: D5, masked path; `docs/constitution.md` §1 and §2.
- The constitution says the frozen reference is "replaced only by a deliberate release commit".
- T2's text should say that a re-baseline commit inside a probe copy (never on a branch, the copy removed) is not a change to the frozen set, and that it is allowed nowhere else.

### Notes
1. D13: Backlog.md's lists include other branches touched in the last 30 days (`check_active_branches`, backlog skill, line 36). The `git show` procedure is right; its stated reason is not. Do not copy that reason into `development.md`.
2. D7: if a milestone is matched by file name, `m-1` is a prefix of `m-10 - …` and `m-11 - …`. Match `m-1 - ` exactly, or read `id:`. Add a fixture.
3. D7: "Depends on: none; drives TASK-N" with an empty dependency list is refused, because "Depends on" is used two ways in the sources.
4. D7 does not say whether the script lists every problem or stops at the first. TASK-79 to 81 have no `Plan:` line, so TASK-76's run on them shows little unless every problem is listed.
5. A check masked by an ordinary check shows overlap for that one fault only. That alone is not a reason to remove the masked check (D6).

## Impact map
(C covered, M missed)
- **Code and agents:** C: the three agents, two skills, `plan_check.py`, the three TOMLs and the `.codex` README.
- **Data:** C: task header, `--dep`, `Plan:`, milestone files, frozen set, report paths.
- **Tests:** C:
  - the `run.py` wiring and the fixtures;
  - `bun test` outside the suite;
  - the comparisons with the frozen reference (`run.py:279`, `workflow.py:120`) and `check_frozen` inside `verify()`;
  - the clean-engine assertion and `report.py`'s sample;
  - the Release PDFs: no check compares them, so a re-baseline does not reach them.
- **Generated:** C: client-journey, `atlas.data.js` and the lock, four hand-written pages and `site.json` in T5, the READMEs `render` writes.
- **Docs:** C: every row. M: the constitution's wording (m6).
- **Tooling:** C: CI's Bun steps, ruff, `.venv`, `anchors`, `atlas.py check`.
- **Work in flight:** C:
  - `main` is 80 files ahead (`stage.yaml`, `run.py`, `verification.md`);
  - three travel branches, which change `run.py`, `verification.md` and the Atlas;
  - `AGENTS.md` is 797 words on `main`.
- **Decisions:** C.

## Facts checked
| Claim | Result |
|---|---|
| `run.py` never runs `bun test` | true |
| Bun tests call Python through `PYTHON` | true (m4) |
| `workflow.py:103` asserts a clean engine | true |
| ADR 0018 is free on all five branches | true |
| `repo-maintenance.md:90` and `:150` are stale | true |
| `sample.json` is read by `tests/report.py:10` | true |
| `--dep` exists in `task create` and `task edit` | true |
| `design.engine-review` and `design.client-review` exist | true |
| Milestone files use double-quoted titles and plain ids | true (Note 2) |
| "The CLI reads only the local checkout" | false (Note 1) |
| Ignored files do not block `worktree remove` | true |

## Limitations
- I ran no probe, no suite and no `anchors`; the findings come from reading.
- I did not read `private/` or the other reviewer's report.
- One read-only command (`git ls-tree` / `git show`) ran by mistake with the Main Folder as its working directory. It wrote nothing.
- I read the user's Claude settings for permission rules and found none.

## Verdict: PASS
No Blocking or Material finding remains. m1 to m6 are Minor: TASK-75's own context review can settle them if the plan names them.
