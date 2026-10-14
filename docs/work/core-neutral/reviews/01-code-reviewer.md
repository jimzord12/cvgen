## Review round 1: code-reviewer, 2026-10-14

Snapshot: `refactor/task-45-core-neutral` at 977539d against merge-base 275038e. Lead lenses: compatibility at the seams (legacy wrappers, private compositions); boundary-test robustness and the theme validation left out of scope.

Verdict: PASS. Recorded in substance (formatting condensed).

Coverage: all five examples, the one-page layout (inherits `shell`) and both private compositions reach the new seams; `validate-plan` copies the old rules and messages in order; recolour order unchanged; 48 matched suite PDFs pixel-identical; the two private marine compositions render identically to the branch base and to each reference.pdf (compiled from staging copies under builds/, deleted after; no client content reported); clear messages for a missing `shell.margin` and an unknown palette colour; docs match the code; Atlas and outputs checks clean.

Findings
- R1-01 Minor: the opening margin lives in two keys (flagship-v11.typ:2-8, core/page.typ:34,50, flagship.typ:52); a legacy composition that overrides `opening-margin` or `hero.band-height` is now silently ignored on page 1. No current caller affected (verified); documented. Fix: Flagship's page loop reads `layout.shell.margin` and retires `opening-margin`, or keep the warning.
- R1-02 Minor: no lasting test protects the `art-palette` seam (golden-blue.typ:11, silver-bridge.typ:4, tests/run.py:183-188): deleting golden-blue's identity mapping or silver-bridge's spread keeps the suite green; only the silver compass-bullet in the skills fixture is non-identity and it is checked by text only. Fix: assert the silver bullet's pixels contain none of #c8a579/#236a70, or differ from the gold bullet.
- R1-03 Minor: the boundary check misses named colours (`navy`, `teal`), `color.hsl(...)`, aliasing (`let l = ctx.layout; l.hero`); comment stripping eats the rest of a line after `//` inside a string. Low-noise on relationship/internship/ranking/crewed. Fix: add hsl|hsv|linear-rgb and named colours except white/black; aliasing may stay.
- N1 Note: core/theme.typ still requires Flagship-shaped colours (hero, plate, on-hero, surface, rule); acceptable out of scope (only flagship.typ calls it); the run.py comment "the core's own words" overstates it; record a Queued task.
- N2 Note: merge-tree against origin/main 7acccd8 conflicts in the generated Atlas files; rerun the suite on the merged tree.
- N3 Note: the allowlist is intentionally strict; acceptable.

Checks rerun: suite exit 0, PASS 96 (builds/tests-20261014-091027-971494); pixel comparison 48 PDFs / 120 pages identical, 10 unpaired timestamped workflow revisions; private compositions 2 vs 2 pages, 0 differing, branch vs main and vs reference.pdf (comparator sanity-checked); atlas and outputs checks exit 0; Main Folder clean, HEAD = origin/main, no diff in packages/ or tests/.

Limitations: private files use root-absolute /private/ portrait paths, so they were compiled from two staging roots (deleted); author mutations not repeated (regexes probed in isolation).

## Dispositions (lead)

- R1-01: fix loudly — Flagship reads `shell.margin`; a layout that still sets `opening-margin` or `hero.band-height` fails with a message naming the new key.
- R1-02, R1-03: fix. N1: Queued follow-up task created by the lead; fix the run.py comment. N2: merge main, rerun the suite. A context-reviewer round follows for the docs.
