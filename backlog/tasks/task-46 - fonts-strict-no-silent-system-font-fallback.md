---
id: TASK-46
title: 'fonts-strict: no silent system-font fallback'
status: Active
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 05:51'
labels:
  - restructure
dependencies: []
ordinal: 46000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Add `--ignore-system-fonts` to `tests/run.py` and `cv_workflow/render.py` compiles (only `design_review/server.py` has it); make `validate-theme` check that fonts exist. Source: docs/work/workflow-model/handoff.md, section 4, item 14 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Every compile in tests/run.py, cv_workflow/render.py and scripts/build.ps1 passes --ignore-system-fonts (CI runs tests/run.py)
- [x] #2 A font family Typst reports as unknown fails loudly: a suite case fails, a cv.py render fails its checks (exit 1, approval refused), build.ps1 throws
- [x] #3 A regression case through the real runners fails if the guard or the flag is removed
- [x] #4 The frozen reference stays pixel-identical; python tests/run.py and scripts/outputs.py check pass
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Shared helper in cv_workflow/render.py: STRICT_FONTS flag (--ignore-system-fonts) and font_fallbacks(stderr) reading Typst's 'unknown font family' warnings.
2. tests/run.py compile_case: pass the flag; a fallback warning fails the case.
3. render.py: pass the flag; a fallback warning is a check error (revision kept, exit 1, approval refused), like a live read.
4. scripts/build.ps1: pass the flag; a fallback warning throws. CI runs tests/run.py, so it inherits the guard.
5. Regression cases: tests/fixtures/fonts.typ (missing family and a system-only family) refused by the suite runner; a one-off workspace naming a missing family in tests/workflow.py refused by cv.py render.
6. Docs: verification.md, theme.md. Manual walk of cv.py render; suite; outputs check.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Result and evidence (2026-10-14, branch fix/task-46-fonts-strict)

Seams: Typst is called by tests/run.py (compile_case), tests/workflow.py (one direct snapshot compile), cv_workflow/render.py (render_revision), scripts/build.ps1 and scripts/design_review/server.py (already strict). CI runs only tests/run.py. No runner compiles design concepts (the magazine-editor compiles them by hand with --ignore-system-fonts and --font-path design-concepts/fonts; unchanged).

Design: Typst 0.15.1 has no deny-warnings flag and gives a document no way to ask whether a font exists, so validate-theme cannot check fonts (it would also miss fonts named outside a theme). The guard lives in the runners: --ignore-system-fonts on every compile, and Typst's `warning: unknown font family` read from stderr as a failure. Shared in cv_workflow/render.py (STRICT_FONTS, font_fallbacks). In render.py the warning is a check error, like a live read: the revision is kept and stamped, exit 1, approval refused. Limit: Typst's embedded fonts (Libertinus Serif, New Computer Modern, DejaVu Sans Mono) still count as found.

Regression: tests/fixtures/fonts.typ (case=missing, case=system with Arial) through compile_case; tests/workflow.py step 11 (one-off naming a missing family and Arial) through scripts/cv.py. Mutations, each run of python tests/run.py failed as expected: guard removed from compile_case -> fonts-missing failed; flag removed from compile_case -> fonts-system failed; check removed from render.py -> workflow step 11 failed (exit 0, checks passed); flag removed from render.py -> workflow step 11 failed on Arial. Evidence: builds/mutation-46-*.

Manual walk (fictional workspace builds/task-46-manual/fictional-engineer, built like tests/workflow.py):
- python scripts/cv.py render builds/task-46-manual/fictional-engineer -> exit 0, status success, checks_passed true.
- cv.typ with `#let theme = theme + (fonts: (body: "Source Sans 3", display: "Barlow Typo"))` -> exit 1, checks_passed false, error: Font family "barlow typo" is not in packages/cv-framework/fonts, so Typst set that text in another font; fix the name or bundle the font there (render.log shows where it is used). render.json command carries --ignore-system-fonts.
- python scripts/cv.py approve <that revision> --test-only -> exit 2, REFUSED: automated checks failed (Font family "barlow typo" ...).
- ./scripts/build.ps1 -OutputDirectory builds/task-46-build-ok -> 5 CVs created. With golden-blue's display font changed to "Barlow Typo" (restored after) -> throws "A font family is not bundled, so Typst used another font: examples/marine/flagship/engineer.typ" after printing the warnings.

Verification: python tests/run.py PASS, 97 cases, exact v11 reference passed, evidence builds/tests-20261014-082621-592052. python scripts/outputs.py check: 19 PDFs indexed, 0 problems.

## Review

Round 1 (code-reviewer, docs/work/fonts-strict/reviews/01-code-reviewer.md): PASS with two Minor findings and three Notes.
- M1 fixed: `--ignore-system-fonts` added to the documented manual commands (AGENTS.md, new-cv skill, build-a-cv.md `typst watch`, client-workflow.md, the Atlas client-journey page, brand/forms/intake-header.typ comment; the header still compiles clean with the flag). Left as is: archive/ (frozen history) and docs/workflow/inventory/ (a dated inventory). The Atlas render step now also names the font check. Atlas: every page was already stale on main (stamped 2026-10-06; drift: private/ as its own repo, .worktrees/, the delete-by erase); checked each page against that drift and this change, no contradiction, stamped all five; `atlas.py check --strict` clean.
- M2 fixed: the system-font case no longer names Arial. tests/workflow.py `system_font_family` picks the first plain family `typst fonts` lists that the bundled set lacks (here "3270 Nerd Font Mono"); `fonts-system` (fixture input `family`) and workflow step 11 (`system-font-fails-checks`) use it. With none on the machine both print `SKIPPED <case>: <reason>`, land in report.json with the reason and in the final line. Proof: flag removed from compile_case -> exit 1, `AssertionError: ('fonts-system', '')` (builds/mutation-46-r1-flag-console.txt); skip path forced -> both cases SKIPPED, suite PASS 96 (builds/probe-46-r1-skip-console.txt).
- N1: follow-up task by the lead (PDF font-subset check for glyph-level fallback).
- N2: reported to the owner by the lead (runner guard instead of `validate-theme`; context-reviewer round added).
- N3: accepted; mutation consoles are now saved.
Merged origin/main (clean). Suite PASS 98 cases, exact v11 match, builds/tests-20261014-084056-354234 (console builds/task-46-r1-final-console.txt); `scripts/outputs.py check` 19 PDFs, 0 problems.

## Review

Rounds 2 (context-reviewer, docs/work/fonts-strict/reviews/02-context-reviewer.md) and 3 (code-reviewer, 03-code-reviewer.md): FINDINGS, all fixed.
- Code F1 (Material) fixed: `system_font_family` probes with the literal `--ignore-system-fonts`, not STRICT_FONTS. Mutation `STRICT_FONTS = []` in render.py, in an isolated `git archive` copy: exit 1, `AssertionError: ('fonts-system', '')` (builds/mutation-46-r3-strict-empty-console.txt).
- Code F2 fixed: with `CI` set and no non-bundled font, tests/run.py fails instead of skipping (locally it still skips loudly); verify.yml installs `fonts-dejavu-core` (DejaVu Sans is not bundled or embedded) so the case runs on ubuntu-latest. Probe with CI=true and no font: exit 1 with the reason (builds/probe-46-r3-ci-nofont-console.txt). Not verified on the GitHub runner itself (no push).
- Code F3 / context M1: system-map stamped last, after every report was committed.
- Context M2: the Atlas retention step names the private-repo history erase; origin/main had made the same fix (another task), so the merge took main's wording and sources (client-workflow.md:298-327, preferences.md:69-80).
- Context M3: build-a-cv.md render checks list names "every font family bundled".
- Context m4, m5, notes: text-draft.typ comment and tech-stack.md carry the flag; new-cv skill says a `warning: unknown font family` line is a failure; cv-workflow README says fonts are all embedded and every family bundled.
Merged origin/main (one conflict in client-journey.json, resolved as above; generated Atlas files rebuilt). Suite PASS 98 cases, exact v11 match, builds/tests-20261014-084944-089231 (console builds/task-46-r3-suite-console.txt); `scripts/outputs.py check` 19 PDFs, 0 problems.
<!-- SECTION:NOTES:END -->
