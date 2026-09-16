<!-- Validation evidence: headless code-reviewer run on a fictional fixture, 2026-09-16. Fixture and briefs are in the session scratchpad; report stored unchanged. -->

# Review round 1: reviewer-check-a

Snapshot: fixture folder `…\scratchpad\reviewer-check\case-a-defect`, files as found on 2026-09-16 (no git). SHA-256: `sea_time.py` 1e2c4c59…4fe3, `test_sea_time.py` 2637f6fb…cede, `README.md` d50d8d5c…32af.
Lead lenses: 2 (correctness and edge cases), 5 (tests and visible evidence)
Coverage:
1. Product fit and wiring: n/a — isolated fixture, no caller; `total_months` is the only entry point.
2. Correctness and edge cases: examined in depth — three acceptance failures (A1–A3), one edge (A5).
3. Data and document integrity: n/a — no persisted data or PDFs.
4. Contracts, access and privacy: input contract `{"start": (y,m), "end": (y,m)}` read; no privacy surface.
5. Tests and visible evidence: examined in depth — tests cannot detect any defect (A4); cited evidence absent (A6).
6. Failure handling: open-ended period silently ignored instead of failing (A1); reversed period silently negative (A5).
7. Simplicity and ownership: fine — one 10-line module, no scope creep.
8. Repository and documentation: README states acceptance clearly; `evidence/` it references does not exist (A6).

## Findings

### A1 Material: open-ended period is skipped instead of raising
Anchor: `sea_time.py:7-8`
Scenario: `total_months([{"start": (2023, 1)}])`. Expected: `ValueError` (README acceptance). Actual: `continue` → returns 0, which is exactly the behaviour the acceptance criterion forbids. Impact: an ongoing contract silently contributes nothing to a service total. Fix: replace the `continue` with `raise ValueError(f"period starting {p['start']} has no end")`.

### A2 Material: off-by-one — end month not inclusive
Anchor: `sea_time.py:9`
Scenario: `[{"start": (2024, 1), "end": (2024, 3)}]`. Expected 3 (both months inclusive). Actual 2. A single-month period `(2024,1)-(2024,1)` returns 0. Impact: every period is under-counted by one month. Fix: add `+ 1` to the per-period term.

### A3 Material: overlapping periods are double-counted
Anchor: `sea_time.py:6-9`
Scenario: `[{"start": (2024,1), "end": (2024,6)}, {"start": (2024,4), "end": (2024,9)}]`. Expected 9 (Jan–Sep once). Actual 5 + 5 = 10 with the current formula (11 after fixing A2). Impact: the "counted once" acceptance criterion is not implemented at all. Fix: convert each period to a set/range of absolute month indices (`y*12 + m`), union them, return the size; or sort by start and merge intervals.

### A4 Material: tests cannot detect any of the above
Anchor: `test_sea_time.py:4-9`
`test_total_months_exists` checks only that the attribute exists; `test_empty` passes for `return 0`. Neither exercises a period, an overlap or an open end. Both pass with the implementation body deleted. Impact: "pytest passes" is not evidence of the acceptance criteria. Fix: add at minimum three cases — inclusive count (`(2024,1)-(2024,3) == 3`), overlap (`== 9` above), and `pytest.raises(ValueError)` for a missing `end`. All three would fail on this snapshot.

### A5 Minor: reversed period contributes a negative value
Anchor: `sea_time.py:9`
`{"start": (2024,6), "end": (2024,1)}` yields −5, lowering the total silently. Expected: `ValueError`. Fix: validate `end >= start` next to the A1 check.

### A6 Material: author evidence is missing
Anchor: README.md line 8; brief ("see evidence/ for the run")
No `evidence/` folder exists under the fixture root (only `.pytest_cache/` and `__pycache__/`). The author's check cannot be inspected. Since I reran the suite myself and the code defects are demonstrable, this does not by itself make the round INCOMPLETE, but the claim as briefed is unsupported. Fix: store the pytest output where the brief says it is.

## Checks rerun
`python -m pytest -q -p no:cacheprovider <fixture-root>` — exit 0, `2 passed in 7.31s`. Output not persisted (cache provider disabled so nothing was written; the folder is outside `builds/`). Both tests passing is consistent with A4: they pass on a defective implementation.

## Evidence inspected
- `README.md`, `sea_time.py`, `test_sea_time.py` at the hashes above.
- `.pytest_cache/v/cache/nodeids` (pre-existing, lists the same two test IDs — confirms no other tests were run by the author).
- `docs/review.md` in the main repository (protocol applied).

## Limitations
- Sandbox denied `cd` into the fixture folder and any chained/PowerShell command; I could only run single Bash commands by absolute path (pytest, sha256sum). Directory listing via `ls` was denied, so absence of `evidence/` rests on Glob `**/*`, which lists no file under such a folder.
- The pre-existing `__pycache__` and `.pytest_cache` were left untouched; I did not write anything into the fixture.

## Verdict: FINDINGS

Tools available to me: Read, Grep, Glob, Bash, PowerShell
