# Calibration 04: the tests-reviewer's two probes, tried once (spike)

Run 2026-11-08 by the lead, answering plan review round 3 (A-P1, B-P1:
"D5's run is load-bearing and has never been tried once"; checklist
question 9). Script: a detached worktree of the branch head, each probe
committed in it, the copy's own suite run by absolute path.

**Setup.** `git worktree add --detach builds/spike-probes-20261108-130458
27a6490`. The suite needs the repository's virtual environment: PATH's
`python` has no `pymupdf` (`C:\Github\cvgen\.venv\Scripts\python.exe`,
Python 3.13.14, pymupdf 1.28.2; `ruff` is there too). A first attempt with
PATH's Python made both probes "fail" with `ModuleNotFoundError` at
`run.py:11`: a broken environment reads exactly like a caught fault, which is
why a probe must count only when the first failing assertion is the probed
one.

**Fault probe.** Appended `#let vessels = 1` to
`packages/cv-framework/core/primitives.typ` (comment-free Framework code; no
output changes), committed in the copy, ran
`.venv/Scripts/python.exe <copy>/tests/run.py --output <copy>/builds/fault`.
Exit 1; the first failure:

```
File "...\spike-probes-20261108-130458\tests\run.py", line 64, in check_core_boundary
    assert not words, f'{name} speaks marine or Flagship: {words}'
AssertionError: packages/cv-framework/core/primitives.typ speaks marine or Flagship: ['vessels']
```

The probed check, reached past the frozen-input check (the file is not
pinned) and past `workflow.py:103` (the probe is committed, so the engine is
clean). True positive.

**Refactor probe.** From the base, renamed the local `parts` to `pieces` in
`duration()` (lines 40-43 of the same file), committed, ran the same way.
Exit 0: "25 passed, 0 failed ... PASS: 198 compilation cases plus
PDF/data/layout assertions." No check failed a behaviour-keeping change.

**What this settles for D5.** Commit each probe in the copy (not an
uncommitted edit, not `git apply`); run the copy's suite by absolute path
with the repository's virtual environment and `--output` inside the copy; a
fault counts only when the first failure is the probed assertion's file and
line; a refactor counts only on a full PASS. Not tried: a probe on a file
pinned in `tests/baseline.json` (it fails `check_frozen` first by design,
so such checks are judged without the refactor probe), and a Bun test.

The copy was removed with `git worktree remove --force` and `git worktree
prune` after recording.
