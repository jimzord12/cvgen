## Review round 3: code-reviewer (its second round), 2026-10-14

Snapshot: `.worktrees/task-46`, head 83201d7; fix 55ed27a..83201d7 and the whole change (19 files). Lead lenses: tests and visible evidence (M2); repository and documentation (M1).

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Coverage: `system_family` computed once in tests/run.py and used by `fonts-system` and workflow step 11; CI runs tests/run.py. Parsing sound on 0.15.1 (one family per line, sorted; case-insensitive; embedded fonts count as bundled; ASCII filter safe; `sorted()[0]` deterministic). report.json gains `passed: null`/`skipped`, read by nothing. Failing `typst fonts` raises. M1 fully applied.

Findings
- F1 Material: tests/workflow.py:27 probes with `families(*STRICT_FONTS, '--font-path', ...)`. A regression `STRICT_FONTS = []` in render.py:27 (the single shared definition) makes the probe see every system font as bundled, return None, and both cases SKIP with a false reason; the suite ends `PASS: 96 ... SKIPPED 2`, exit 0 (reproduced on a 129-family machine). AC #3 broken on Windows/macOS for the most natural regression; the docstring (workflow.py:17-21) and verification.md claim the opposite. Fix: probe with the literal '--ignore-system-fonts'; rerun the constant mutation, expect exit 1 on fonts-system.
- F2 Note: on a runner with no non-bundled font both cases skip and CI stays green, visible only in the log and report.json. Optional: fail instead of skip when `CI` is set, or install a known font in verify.yml.
- F3 Note: atlas check --strict exits 1, STALE system-map docs/work, caused by the uncommitted 02-context-reviewer.md; re-stamp after committing.

Checks rerun (builds/review-46-r2-20261014-084448/): suite exit 0 PASS 98, exact_reference passed, fonts-system chose "3270 Nerd Font Mono" with the warning in its log; mutation STRICT_FONTS=[] in a git-archive copy: exit 0, PASS 96, SKIPPED 2; atlas check exit 1 (F3).

Limitations: ubuntu-latest font set unverified; other round-1 mutations not rerun; context documents left to the context-reviewer round.

## Dispositions (lead)

- F1: fix. F2: fix (fail rather than skip when `CI` is set). F3: stamp system-map last.
