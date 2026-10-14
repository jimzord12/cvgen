## Review round 1 (code): code-reviewer, 2026-10-14

Snapshot: `feature/task-47-python-packaging` at 00f16cc, merge-base 6207def (24 files). Lead lenses: behaviour neutrality of the ruff fixes; supply chain and reproducibility.

Verdict: PASS. Recorded in substance (formatting condensed).

Coverage: CI installs `-r requirements.lock`, runs `ruff check`, then the suite (run log); every changed `.py` hunk is neutral (`tests/release.py:65` default-bound loop variables keep each iteration's values, no caller passes them; `run.py:139` local `import shutil` removal safe, module-level import at `:7`; lambda-to-def and `l`-to-`line` textual); pyproject pins match the lock; `raise ... from` changes only the traceback chain, `cv.py` still prints `REFUSED: {error}`; scope matches the lead's notes.

Findings
- m1 Minor: `README.md:79` and `.claude/skills/verify-cv/SKILL.md:14` still list packages without the lock; README's "44 cases" count is stale too.

Notes
- n1: `docs/work/workflow-model/handoff.md:305` "pillow is unpinned in CI" is the historical audit row; may stay.
- n2: pyproject `build-system` (`setuptools>=77`) is not hashed; matters only if someone builds the package.

Checks rerun: suite in the worktree exit 0, 142 cases; `python -O` and `PYTHONOPTIMIZE=1` both exit 1 with the refusal and no output folder; offline `uv pip compile --generate-hashes` reproduces `requirements.lock` byte-for-byte below its header; `gh run view 38537514739`: both jobs installed the nine locked versions (hash-checking on because the `-r` file has hashes), ruff "All checks passed!"; 137 vs 142 cases explained by 5 Windows-only `build-script-powershell-*` cases (`release.py:40`), no SKIPPED line, `run.py:439` asserts CI never skips them; Atlas check exit 0.

Limitations: no fresh-venv install (would download; CI's clean installs stand in); ruff not installed locally.

## Dispositions (lead)

- m1: fix (with the context round's items 1-2). n1, n2: accepted.
