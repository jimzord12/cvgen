# Context review round 2: TASK-75 (tests-reviewer)

**Snapshot:** `8306aae..0b9daa0` on `feat/review-agents`, read in `C:\Github\cvgen\.worktrees\review-agents`. The fixes since round 1 are `4085e84..0b9daa0`.

**What the feedback implies (written before reading the diff):** a test is kept only if it fails when the behaviour it guards breaks, and survives a change that keeps that behaviour. Tautologies, padding, change detectors and tests bent to pass are blocked. The reviewer names the tests that are missing, the ones to fix and the ones to remove. The number of tests is not a goal. The gate fires on test changes only. It must not discourage real regression tests or checks whose rule is itself structural, and it is not an audit of the existing suite.

## Round 1 fixes checked

1. **Structural rules (fixed).** `SKILL.md:32-34` covers checks whose rule is about structure, and `:105-108` routes them to "pins the right things" instead of a refactor probe. The pattern table still separates these from the "Change detector" row ("incidental text or layout"), so no loophole opens. The agent's step 4 and Bar defer to the skill.
2. **Reference path (fixed).** `verification.md:339` now gives the full path. It matches `tests/run.py:294`, `tests/workflow.py:123` and the key in `baseline.json`.
3. **New files in probe commits (fixed).** `verification.md:326-327` now runs `add -A` before `commit -m`.
4. **Pointer from the code-reviewer paragraph (fixed).** `review.md:208` now points to the skill.
5. **Owner's convention (fixed).** `SKILL.md:141-143` carries it, dated and attributed. That matches question 4 of "Where things live" and the owner's placement decision.
6. **"Not a reason to remove" (fixed).** `verification.md:346-347` points to "Removing a test", which holds the reason ("shown across the faults this test claims, not for one probe").

## Fresh pass

- **Placement holds.** The generic method is in the skill, the CVgen probe procedure in `verification.md`, the gate and boundary in `review.md`, and the `probe-*` folder in `git-workflow.md` and the `AGENTS.md` row. The agent file restates only briefly and points to the owners. `conventions.md` swapped its old one-liner for a pointer, consolidating rather than appending.
- **No reviewer list left stale.** The only other files naming `plan-reviewer` are the plan agent, the plan skill and the glossary.
- **Plan decisions all applied:** D5, D6, D12 and D19, plus every TASK-75 bullet under "Carried into the tasks".
- **Terms and identifiers check out:** `check_frozen()` and `verify()` in `tests/verify.py`; the clean-engine assertion at `tests/workflow.py:104` over `render.py`'s `engine_state()`; `tests/report.py:10` reading `sample.json`; and the D12 paths.
- **`Probe` and `Probe Copy`** are in the glossary.
- **Workflow Model anchors land on the intended text:** `review.md:25-32`, `:281-300`, `:288-295` and `:296-300`. The rest of the diff in `docs/workflow/` only shifts line numbers.
- **Hygiene:** LF everywhere, no client data, no edited dated record. The round 1 report is stored and the dispositions are appended after it.

## Findings

### 1. Minor: line wrapping drift in the new text
- **Where:**
  - `docs/engine/verification.md:305` is 88 columns ("...keeps its empty folder behind. The lock tells other sessions the").
  - `:340-341` leaves a two-word line ("runs again. That") after fix 2.
  - `docs/review.md:208` is 108 columns after fix 4.
- **Problem:** the surrounding paragraphs wrap at about 78 columns.
- **Why it matters:** a reader notices the ragged lines; nothing is misread.
- **Smallest fix:** reflow those three paragraphs. Line 339, the path, cannot wrap.

### 2. Note: the owner's quote half-repeats the intro and assumes the convention is cross-project
- **Where:** `.claude/skills/test-principles/SKILL.md:141-143`, against `:12-13`.
- **Problem:** the intro already says "The number of tests is not a goal". The quote was said about CVgen, and the section frames it as a convention for every project.
- **Why it is only a Note:** the owner's decision sends his conventions for an activity to that activity's skill, and the line names its source and date. It is acceptable as it stands. If he ever limits it to CVgen, it moves to `docs/conventions.md`.

**Not raised (out of scope):** the four stale Atlas pages (the plan's recorded exception), TASK-76 to 78's files, and the existing tests (the D17 audit). AC #3, queuing the audit, is still open in the task record. That is the lead's to close and not a documentation finding.

Verdict: PASS

---

## Dispositions (lead)

1. **Fixed** under the trivial path (mechanical formatting): the three paragraphs are reflowed with no word changed. `review.md` keeps the same number of lines, so no Workflow Model anchor moved (`anchors 0b9daa0`: 0 moved, 0 edited).
2. **Kept as it is**, as the reviewer allows. The owner asked for his conventions to go in the activity's skill. Whether this one is wider than CVgen is his call, to be confirmed in the report.
