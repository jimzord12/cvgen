<!-- Validation evidence: headless code-reviewer run on a fictional fixture, 2026-09-16. Fixture and briefs are in the session scratchpad; report stored unchanged. -->

# Review round 1: reviewer-check-b

Snapshot: fixture folder `…\scratchpad\reviewer-check\case-b-clean` as found on disk (no git; files `README.md`, `sea_time.py` 15 lines, `test_sea_time.py` 17 lines, `evidence/pytest.txt`). No file hashes were supplied in the brief; I could not compute them myself (see Limitations), so identity rests on the contents I read, quoted by line below.
Lead lenses: 2 (correctness and edge cases), 5 (tests and visible evidence)
Coverage:
1. Product fit and wiring: n/a — isolated fixture, no caller or entry point exists; the function meets the README outcome as stated.
2. Correctness and edge cases: reviewed in depth; happy path, inclusive bounds, overlap, year boundary, empty input, explicit `end: None` all correct; inverted period silently contributes zero (B1-02).
3. Data and document integrity: n/a for the fixture (no persistence, no PDFs). One product-level note (B1-04).
4. Contracts, access and privacy: input shape matches README; no credentials or real data. No findings.
5. Tests and visible evidence: reviewed in depth; each test fails for the defect it targets; year-boundary arithmetic is untested (B1-01).
6. Failure handling: open-ended period fails loudly with a useful message. Missing `start` key raises `KeyError` while formatting the error (line 12) — acceptable for a fixture, noted in B1-03.
7. Simplicity and ownership: single 15-line module, no duplication, scope matches README.
8. Repository and documentation: n/a — outside the repository; `__pycache__` and `.pytest_cache` are present in the snapshot folder, not a concern here.

## Findings

### B1-01 Minor: year-boundary arithmetic has no test
Anchor: `test_sea_time.py:5-16`, `sea_time.py:4-5`
Scenario: all three tests stay inside a single calendar year. `_index` is the only non-trivial arithmetic (`y*12 + (m-1)`), and an implementation with the wrong radix (e.g. `y*10 + m`, or `y*12 + m` combined with an off-by-one elsewhere) would pass the current suite unchanged.
Expected: a test that would fail if the month index were wrong across years.
Actual: none; by hand, `(2020,12)-(2021,1)` gives indices 24251..24252 → 2, which is correct, but the suite cannot prove it.
Impact: low for the fixture; it is the one behaviour the tests would let regress silently.
Fix: add `assert total_months([{"start": (2020, 12), "end": (2021, 1)}]) == 2`.

### B1-02 Minor: inverted period silently counts as zero
Anchor: `sea_time.py:13`
Scenario: `{"start": (2021, 3), "end": (2021, 1)}` (data entry swapped the dates).
Expected: under the fixture's own stance that unknown service time fails loudly (and this project's constitution rule 4/6 spirit), an impossible period should raise.
Actual: `range(24254, 24253)` is empty, the period contributes 0 months and the total looks valid.
Impact: an under-counted total that nothing flags. Not in the acceptance list, so Minor rather than Material.
Fix: `if _index(p["end"]) < _index(p["start"]): raise ValueError(...)` before line 13, plus one test.

### B1-03 Note: no validation of month range
Anchor: `sea_time.py:4-5`
`(2020, 13)` indexes the same as `(2021, 1)` and `(2020, 0)` the same as `(2019, 12)`. Optional guard; not required by the README.

### B1-04 Note: would conflict with the totals rule if it entered the product
Anchor: `README.md:4-5`; `docs/constitution.md` rule 6 ("calendar periods are never converted into service time").
The fixture converts calendar month ranges into "service months". Fine for an isolated validation fixture; flagged only so this shape is not copied into `src/` without an owner decision.

## Checks rerun
`python -m pytest -q -p no:cacheprovider <fixture>\test_sea_time.py` — result: `3 passed in 5.11s`, exit 0. Output was captured in this session only; I could not write it under `builds/` (see Limitations). The author's `evidence/pytest.txt` (3 passed in 0.02s) is consistent with my rerun but is the author's run, not mine.

## Evidence inspected
- `case-b-clean/README.md`, `sea_time.py`, `test_sea_time.py`, `evidence/pytest.txt` — on-disk contents at review time.
- `docs/review.md` (repository, working tree) — protocol applied.

## Limitations
- The shell sandbox rejected every compound command (directory creation + tee, `cd`, `$LASTEXITCODE`, `python -c` probes), so: no output file under `builds/`, no SHA-256 hashes of the snapshot, and the edge-case probes in B1-02/B1-03 were verified by hand arithmetic from the source, not executed.
- Brief supplied no file hashes; snapshot identity is by content read, not by hash.

## Verdict: PASS

No Blocking or Material findings; both Minor items are optional hardening for the author to fix or record as deferred.

Tools available to me: Read, Grep, Glob, Bash, PowerShell
