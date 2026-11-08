# Review round 1: figure numbers in the Report Template (owner request 2026-11-08, no task record)

Snapshot: worktree `C:\Github\cvgen\.worktrees\report-figure-numbers`, branch `fix/report-figure-numbers`, head b90678d, clean tree. Delta 0dc93e7..b90678d (66e6a70, b90678d).
Lead lenses: 2. Correctness of the normalisation; 6. Loud failure.
Coverage:
1. Product fit and wiring: the CLI path `main → refusal → build` works for string ids. The sample uses "1" and "2". It does not deliver the documented `1` (R1-1).
2. Correctness: probed in memory (details below). One defect (R1-1).
3. Data integrity: `refusal` changes `data` in place, and `build` depends on that (R1-2).
4. Contracts: README contradicts the code (R1-1).
5. Tests: no case covers a bare integer evidence id, so R1-1 got through.
6. Failure handling: every bad id or citation I tried is refused, and nothing invalid reaches the page. A few messages are misleading (R1-1).
7. Simplicity: small and in the owning module. The lambda follows the file's existing `noqa: E731` pattern.
8. Repository/docs: `docs/engine/verification.md` item 19 ("a figure id missing or malformed") is still accurate, not stale (R1-3). The task-82 record still says "Figure A", but that is a historical record. The prose changes are left to the context-reviewer.

## Findings

### R1-1 Material: an integer evidence id is refused, against the documented contract
Anchor: `scripts/report.py:115` (with `:41` NOT_TEXT, `:126-128`); `studio/brand/report/README.md` `evidence` row; the comment at `scripts/report.py:43`.
Scenario: `"evidence": [{"id": 1, "kind": "page", ...}]`, a form the README allows ("`"1"`, or `1`").
Expected: read as "1" and accepted. Citing it as `"1"` or `1` also works.
Actual: `refusal` returns `evidence: an item needs id`. The SECTIONS loop runs before the normalisation, and `'id'` is not in `NOT_TEXT`, so `is_text(1)` fails first. The id normalisation at lines 126-128 never runs on an integer and is dead code. I reproduced this with `refusal()` in memory. The same misleading "needs id" message appears for `0`, `-1`, `1.0` and `true`, when "must be a number from 1 to 999" would be the right message. Integer citations do work (`"1"` cited as `1` returns None, and placement gives `['1']`). Only evidence ids are affected.
Impact: an agent that follows the README gets a refusal that says the id is missing when it is not. The brief's claim "1 and "1" are the same" holds only for citations.
Smallest useful fix: add `'id'` to `NOT_TEXT`, or move the normalisation ahead of the SECTIONS loop with type guards. With `NOT_TEXT`, `0`, `1.0` and `true` reach line 137 and get the number message. Add a test case where `"id": 1` is cited as `"1"` and renders, plus one where `"id": 1.0` is refused with the number message.

### R1-2 Note: the validator changes its input, and the build depends on it
Anchor: `scripts/report.py:125-132`, `:185-191`.
`refusal` now rewrites `data` so that `placement` and the embedded JSON see string ids. If `placement` is called on data that has not been through `refusal` and contains an integer citation, it raises KeyError (`count[name]`). Nothing calls it that way today; the tests' direct call uses strings. Consider a separate `normalise(data)` step in `main`, or say in the docstring that `refusal` normalises.

### R1-3 Note: verification item 19 could name the letter case
Anchor: `docs/engine/verification.md:275-276`. "a figure id missing or malformed" still covers the new letter refusal. Optionally add "(a letter, a sentence)".

Edge cases confirmed correct: `"01"`, `"0"`, `"1000"`, `" 1"`, `"1\n"`, Arabic-Indic digit, citation `1.0`, `true`, `null` and `{}` are all refused with clear messages. Mixed `"1"`/`1` duplicate citations are caught. `report.html` holds ids as strings throughout (`includes`, `FIG[...]`, `fig-1` anchors). The integer-key ordering of `Object.fromEntries` does not matter because the order comes from `PLACE.figures`.

## Checks rerun
- `tests/report.py` `run_report` alone (via `python -B`, no bytecode written): exit 0, every report check printed. Output: `C:\Github\cvgen\.worktrees\report-figure-numbers\builds\review-report-figures-20261108-183643\` (`log.txt`, `report/`).
- In-memory `refusal()`/`placement()` probes of the edge cases above (no files written).
- `ruff check`: not rerun, because ruff is not installed in my shell (`ruff`/`python -m ruff` not found).
- Full suite: not rerun. I saw the author's evidence at `builds\tests-20261108-183410-452285\report.json`, which includes the new letter case.

## Evidence inspected
At b90678d: `scripts/report.py`, `tests/report.py`, `studio/brand/report/sample.json`, `studio/brand/report/README.md`, `studio/brand/report/report.html` (id handling), `docs/preferences.md` diff, `docs/engine/verification.md` item 19, `tests/run.py` (wiring), the full diff 0dc93e7..b90678d.

## Limitations
Ruff not rerun. The page script was not executed in a browser. The docs prose was left to the context-reviewer.

## Verdict: FINDINGS

**Next:** the lead fixes R1-1 (an integer evidence id should be accepted, and a test should prove it), reruns the suite and ruff, then sends the new snapshot to a fresh round-2 code-reviewer.
