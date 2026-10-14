## Review round 1: code-reviewer, 2026-10-14

Snapshot: `fix/task-46-fonts-strict`, base 1b95e5e, head e37d21e. Lead lenses: correctness at the seams; tests that would pass with the feature broken.

Verdict: PASS. Recorded in substance (formatting condensed).

Coverage: all four runners get the flag and the check (`scripts/design_review/server.py:206` already had the flag). Warning format probed on Typst 0.15.1: lowercased, one line per family, on stderr, also for unknown names in a font list, measured-only text, page 2 text and non-ASCII names; exit code always 0; the regex catches all. A fallback revision is kept, stamped `status=render`, `checks_passed=false`, approval refused (`workspace.py:160`), as on the live-read path. `checks.json`/`render.json` shapes unchanged; the flag is recorded in `render.json`. `build.ps1` throws before any `-Release` copy (pwsh 7 and Windows PowerShell 5.1). LF, `diff --check` clean.

Findings
- M1 Minor: manual compile commands still read system fonts — AGENTS.md:126, .claude/skills/new-cv/SKILL.md:93, docs/guides/client-workflow.md:260, .atlas/src/pages/client-journey.json:307, brand/forms/intake-header.typ:5. A misspelt family in a documented preview or a client's `Text Draft` (no runner) renders in Arial with exit 0. Fix: add `--ignore-system-fonts` (needs a context-reviewer round).
- M2 Minor: CI cannot catch removal of the flag — tests/fixtures/fonts.typ:6, tests/workflow.py:390. On ubuntu-latest without Arial, the "system" case is refused either way. Fix: choose the system family at run time from `typst fonts` minus the bundled ones; if none, record the case as skipped by name.
- N1 Note: glyph-level fallback stays silent (Greek in Barlow lands in embedded Libertinus Serif, no warning even with `--ignore-embedded-fonts`). No product PDF uses Libertinus today, so a check that a PDF's fonts are a subset of the bundled ones would be green and would catch it. Suggest a follow-up task (Greek CVs are in the market).
- N2 Note: the description asked for `validate-theme` to check fonts; the author replaced it with the runner guard and recorded why; report it to the owner as a decision taken on his behalf. Docs and the new-theme skill changed, so a context-reviewer round is also required.
- N3 Note: `builds/mutation-46-*` hold partial case folders without console output; saving it would make AC #3 auditable.

Checks rerun (under builds/review-46-r1-20261014-082923/): suite exit 0, PASS 97 cases, engineer matches frozen v11 (`raster_equal`/`text_equal` true); mutation flag removed from `compile_case` -> exit 1 `('fonts-system', '')`; mutation render check removed -> exit 1, step 11 got `checks_passed: true`; build.ps1 ok on both shells, throws on a misspelt display font; warning and glyph probes stored.

Limitations: two of four mutations not rerun; ubuntu-latest font set not verified; manual cv.py walk not repeated (workflow step covers it).

## Dispositions (lead)

- M1, M2: fix now (cheap).
- N1: follow-up task created for a PDF font-subset check.
- N2: reported to the owner; context-reviewer round added.
- N3: accepted as is; the reviewer's own reruns are stored.
