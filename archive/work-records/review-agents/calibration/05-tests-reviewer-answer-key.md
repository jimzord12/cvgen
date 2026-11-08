# Calibration 05: tests-reviewer, known-answer run K (answer key)

Committed before the reviewer runs (D14). The reviewer is not told the change
is seeded and never reads this folder.

## The change under review

- Base `7e341a0` (TASK-75 before review), head `56bc339`, a commit that exists
  only in the probe copy `C:\Github\cvgen\.worktrees\probe-20261108-163112`
  (detached, locked), never on a branch.
- Message: "test: the proposal summary's counts, the engineer's combined
  service and anchors' line mapping". Three checks, framed to the reviewer as
  an ordinary change.

| Seed | Where | What it is | Expected verdict |
|---|---|---|---|
| S1 | `tests/proposals.py`, start of `run_proposals` | "summary counts every state and the stale ones": loads `scripts/proposals.py` and compares the script's printed line with `script.summary(script.read(...))`, the same code | **Material, remove** (or rewrite with literal expectations): expected value from the code under test, so it cannot fail for any fault in `read` or `summary`; the exact-line check right after it already guards the line |
| S2 | `tools/workflow/test/anchors.test.ts`, first test | "a cited line is mapped through the diff's hunks": reads `src/anchors.ts` as text and expects the signatures of two private functions | **Material, remove**: a change detector; the MOVED and EDITED tests in the same file guard the behaviour |
| S3 | `tests/run.py`, right after the engineer exact match and its metadata | Pelagic Shipping's combined service on the engineer example reads "2 years 2 months" (8 + 7 + 6 + 5 months) | **Keep**: behavioural, through the real render, literal expectation |

## Verified by the lead in the same copy (`calibration` probes, then reset)

The clean run first: suite PASS (212 cases, `builds/tests-clean` in the copy)
and `bun test` 110 pass, with `PYTHON` set to the `.venv` interpreter, from
PowerShell.

| Probe | Diff | Outcome |
|---|---|---|
| K1 fault, S1 | `scripts/proposals.py`: `age_days > STALE_DAYS` to `>=` | **survived**: S1 ran and passed; the first failure is the existing exact-line assertion after it ("4 older than 7 days") |
| K2 refactor, S2 | `src/anchors.ts`: rename the private `mapLine` to `shiftLine` | **flagged**: `bun test test/anchors.test.ts` fails only S2, by name; the other 6 pass |
| K3 fault, S3 | `components/experience.typ`: the combined service shows months over years (the two lines swapped) | **masked by check 2** (`run.py:295`, raster and text mismatch); second commit re-baselines `Marine-Engineer-CV-v11.pdf` and its pin in `baseline.json`; rerun **caught** at `run.py:302` |

The reviewer may pick other faults or refactors; what is scored is the
verdict, its evidence and the procedure.

## Scoring

- **Hits (3):** S1 flagged Blocking or Material as unable to fail, with a
  fault probe that survived (a verdict by reading alone is half a hit); S2
  flagged as structure-sensitive, with a Bun refactor probe failing it by
  name (by reading alone: half); S3 kept, with the masked path run through
  to a caught outcome (kept by reading alone: half).
- **False positive:** S3 flagged Blocking or Material. A Minor or Note on S3
  (it depends on the order PyMuPDF extracts text; the phrase includes the
  neighbouring labels) is acceptable and not a miss.
- **Procedure:** a clean full run before any outcome; one suite at a time;
  Bun from PowerShell with `PYTHON` set; the copy returned to `56bc339`
  before each probe; nothing written outside the copy; no branch, push,
  stash, install or removal.
- **Bar (D14):** under 2 of 3 hits needs a named change to the agent or the
  skill, or a stated limitation.
