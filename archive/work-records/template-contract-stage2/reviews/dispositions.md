# TASK-68 code review: dispositions

Reviewer: `code-reviewer`, fresh context, three rounds on branch `feat/contract-stage-2`. The reports are stored verbatim in `code-round-01.md` to `code-round-03.md`, as the agent returned them, without the two-space indent the hand-back frame adds. Round 1 reviewed `c1a5761`, round 2 `e91e270` and round 3 `cac5b60`.

| Finding | Round | Disposition | Commit |
|---|---|---|---|
| M1: a required group that became optional is reported as dropped | 1 | Fixed: `shown_by()` adds the groups required at the Variation's last version, both for `dropped` and for the coverage figure; tested on the `shift` Domain | 5ee2afb |
| m2: a version an `exactly` list skips renders through `compare` | 1 | Fixed: refused as not rendered; tested with the `gap` Variation | 5ee2afb |
| m3: no test that Flagship refuses a bad `copy` key | 1 | Fixed: `tests/run.py` refuses `{'brnad': 'X'}` and `{'brand': 5}` | 5ee2afb |
| m4: ADR 0016's body is stale | 1 | Accepted: accepted ADR text is never edited beyond its Status line (`docs/conventions.md`); the Status line records Stage 2 built 2026-11-08, and the TASK-68 notes record the timing | f88365e (notes) |
| N1: `compare` ignores claimed schema versions | 1 | Tried in 5ee2afb, then reverted on R2-M1; stays a Note. Claims are now proved instead (R2-M1 fix) | cac5b60 |
| N2: the facts schema accepts any `copy` object | 1 | Accepted as a Note; documented in `docs/engine/candidate-schema.md` and in the final report's Major decision 6 | - |
| N3: finding texts can name the wrong version | 1 | Fixed: the texts say "by version N" | 5ee2afb |
| N4: `registry()` import and rescanning | 1 | Accepted as a Note: `referencing` ships with `jsonschema`, and the rescan is cheap at today's size | - |
| R2-M1: a claimed new `schemaVersion` turns errors into warnings | 2 | Fixed: the branch and its table wording are reverted; the error cases are pinned in tests; the suite refuses a claim at a `schemaVersion` that no rendered version has | cac5b60 |
| R2-N1: `shown_by` replaces a claim set instead of joining it | 2 | Fixed: the sets are joined | cac5b60 |
| R2-N2: stray spaces in a test line | 2 | Fixed | cac5b60 |
| R3-m1: the claim proof is untested and misleads when nothing is rendered | 3 | Fixed after the PASS: `unproved()` in `contracts.py`, with negative cases in `tests/compatibility.py`; empty when the Variation renders nothing | 0e8cc19 |

Final evidence: suite PASS on f1b6b39 (main merged in), `builds/tests-20261108-123228-323975` in the worktree.
