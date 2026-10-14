## Review round 2: code-reviewer, 2026-10-14

Snapshot: `.worktrees/task-49`, head a7926a0; delta `0ed1f3d..a7926a0` (merge 9c9fc3d of origin/main 42c3033, fixes 345d44d, Atlas 31d62b6, a7926a0). Lead lenses: correctness of the guard and the CI change, merge kept both sides; test strength.

Verdict: PASS. Recorded in substance (formatting condensed).

Coverage: the Windows CI step and the suite's build-script case reach the real `build.ps1`; the guard throws before `New-Item` in pwsh 7 and 5.1 for every malformed shape probed; no `Release` PDF changed; outputs check 0 problems; clear error, no folder left; the m2 and N3 wording true; the merge kept TASK-48's `verify.yml` and tech-stack rows, the shifted change-review citations match; the upload glob matches where `release.py:70` writes logs, `if-no-files-found: ignore` keeps it harmless.

Findings
- m1 Minor: the per-entry field check has no test (`scripts/build.ps1:27-28`, `tests/release.py:83-90`): removing `-or $incomplete.Count -gt 0` survives; the only malformed fixture is a misspelt key. Low impact (the suite's `examples()` already rejects a list lacking title or variant). Fix: run the case again with an entry without `title`.

Notes
- N1: the key-existence check (`build.ps1:25-26`) is redundant twice over (the count check and the field check catch the same cases); the comment overstates its need; optional simplification.
- N2: the merge brought TASK-33 and TASK-48, not TASK-45 (9a8ed1c); landing needs another merge from main, a suite run and an Atlas re-stamp.
- N3: `README.md:41` "Five PDFs land..." hard-codes the count.

Checks rerun: suite exit 0, PASS 109, all 10 build-script cases; `atlas check --strict` exit 0; outputs check 0 problems; mutations in disposable copies: A (guard reverted to round-1 form) caught in both shells; B, C, D survived (m1, N1); probes (no title, empty array, null entry, top-level array, `examples: null`, `examples: "x"`) all exit 1 with the guard message and no folder, in pwsh and 5.1.

Limitations: Linux pwsh reasoned, not run; CI run and artifacts not re-fetched; the author's manual walk not repeated.

## Dispositions (lead)

- m1: fix (second malformed case without `title`). N1: simplify the comment. N2: merge main again before landing. N3: fix the README wording.
