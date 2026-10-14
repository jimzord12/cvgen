## Review round 4: code-reviewer, 2026-10-14 (ran in parallel with 04-context-reviewer)

Snapshot: `.worktrees/task-46`, head 7d2d51a; fixes 83201d7..7d2d51a (code only in 1fcbfb5); whole change against b2a0dde. Lead lenses: tests and visible evidence; failure handling (CI skip versus fail).

Verdict: PASS. Recorded in substance (formatting condensed).

Coverage: all four runners pass the flag via `STRICT_FONTS` or a literal; the probe (tests/workflow.py:28) spells out the flag; family filter and lowercase match sound (on ubuntu "DejaVu Sans" passes, "DejaVu Sans Mono" is Typst-embedded and excluded); fallback revision kept, checks fail, approval refused; docstring (workflow.py:17-24) and verification.md:63 match behaviour; CI with no non-bundled font fails clearly, locally it skips loudly; diff --check clean; LF; YAML parses (7 steps); Atlas check exit 0; outputs check 19 PDFs, 0 problems.

Notes
- N1: .github/workflows/verify.yml:22-23 font step unverified on GitHub and needs the Ubuntu mirrors; likely a no-op if the image ships fonts-dejavu-core; a mirror outage would turn CI red clearly. Confirm on the first push that the `fonts-system` log names a DejaVu (or other) family.
- N2: an untracked 04-context-reviewer.md shares the round number; name reports distinctly; re-stamp system-map after committing.

Checks rerun (builds/review-46-r4-20261014-085316/): `typst fonts --ignore-system-fonts --font-path packages/cv-framework/fonts` lists the bundled families plus embedded DejaVu Sans Mono, Libertinus Serif, New Computer Modern (+Math) — DejaVu Sans neither; suite exit 0, PASS 98, nothing skipped, exact reference raster_equal and text_equal true, all four font cases passed; F1 mutation STRICT_FONTS=[] -> exit 1 `AssertionError: ('fonts-system', '')`; F2 probe CI=true with no font -> exit 1 with the install message; YAML safe_load ok; atlas and outputs checks exit 0.

Limitations: GitHub runner not exercised; local skip path not rerun; build.ps1 and other round-1 mutations not rerun (code unchanged).

## Dispositions (lead)

- N1: the lead checks the first CI run after merge. N2: reports named 04-code-reviewer and 04-context-reviewer.
