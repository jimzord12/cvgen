---
id: TASK-45
title: 'core-neutral: the Framework core holds no Flagship or marine rules'
status: Active
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 06:22'
labels:
  - restructure
dependencies: []
ordinal: 45000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
`core/pagination.typ` hard-codes synopsis, certificates and education rules and "vessel" wording; `core/primitives.typ` hard-codes the marine SVG palette; `core/page.typ` reads Flagship layout keys. Move them into Flagship; extend the boundary test beyond imports. Source: docs/work/workflow-model/handoff.md, section 4, item 13 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 The Framework core (packages/cv-framework/core, lib.typ) holds no marine or Flagship rule: no synopsis/certificates/education page-plan rule, no vessel wording, no SVG hex palette, no read of a Flagship layout key (opening-margin, hero.band-height); Flagship and the marine domain supply them
- [x] #2 Every PDF the suite writes is pixel-identical (144 dpi) to the same PDF from origin/main, and the frozen v11 reference still matches; legacy-parity passes
- [x] #3 Flagship still enforces its page-plan rules: a plan without a synopsis fails with 'exactly one synopsis' (new suite case), and the core alone accepts a plan without one (core-model fixture)
- [x] #4 The suite's boundary check fails when marine or Flagship vocabulary, a Flagship layout key or a colour literal is put back into core code (mutations recorded), and passes on the change
- [x] #5 python tests/run.py passes; python scripts/outputs.py check and python .atlas/_kit/atlas.py check --strict are clean; docs describing the core/domain split are updated
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Baseline: run python tests/run.py on origin/main (275038e) and keep builds/tests-20261014-085355-538450 as before-evidence.
2. pagination.typ: keep the neutral grammar (non-empty plan, every row once in order, fragments); the row noun comes from the domain's model (`row`, marine: "vessel"); move the closing-section rules (one synopsis after the last Experience page, certificates/education placement) into Flagship (flagship.typ).
3. primitives.typ: decoration takes the source-colour map from the theme (`art-palette`: SVG hex -> theme colour name, supplied by the marine domain and carried by Flagship's themes); `{{name}}` placeholders resolve against every theme colour; `art-colors` unchanged; replacement order unchanged.
4. page.typ: the shell reads its own layout slice `shell` (first-page margin, optional band height) instead of Flagship's opening-margin and hero.band-height; Flagship layouts supply it.
5. Boundary test: add a vocabulary check (marine/Flagship words in core code), an allowlist of layout slices and artwork slots the core may read, and no colour literals in core code. Prove with mutations.
6. Pixel-compare every suite PDF before/after; update docs (architecture, domains-and-roles, layout-and-pagination, theme, artwork-pack, AGENTS rows, new-theme skill); Atlas check.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Result and evidence
Branch `refactor/task-45-core-neutral` (worktree `.worktrees/task-45`), code at cdbbdb1, docs 69a7a6e, Atlas b64d994..2410afe.
- `core/pagination.typ` checks only the shared grammar (non-empty plan, every row once in candidate order, fragments); the row noun comes from the domain's model (`experience-model.row = "vessel"`, so marine's messages are unchanged). Flagship's `validate-plan` (`flagship.typ`) calls it and adds the closing-section rules (one synopsis on the last Experience page, certificates/education after it), same messages, same order.
- `core/primitives.typ`: `decoration` recolours by the theme's `art-palette` (source hex -> theme colour name; marine's `domain.art-palette`, carried by `golden-blue.typ`, inherited by `silver-bridge.typ`), then `{{<colour>}}` for every theme colour, then `art-colors`; same order as before. The metric message example no longer says "Vessels".
- `core/page.typ` reads its own layout slice `shell` (`margin`, optional `band`) instead of `opening-margin` and `hero.band-height`; `flagship-v11.typ` supplies `shell` (after review round 1 its only opening margin; `opening-margin` is retired) and moves the band height out of `hero`.
- Boundary check (`check_core_boundary`, tests/run.py): on comment-free Framework code, (1) no marine/Flagship word or Flagship layout key (whole words), (2) layout keys and artwork slots read only from an allowlist (`paper`, `width`, `height`, `shell`, `header`, `footer`; `background-first`, `background-continuation`), (3) no colour literal (hex string or rgb/cmyk/luma/oklab/oklch call).
- Evidence: before `builds/tests-20261014-085355-538450` (origin/main 275038e, PASS 94 cases); after `builds/tests-20261014-090529-155502` (head 2410afe, PASS 96 cases: new `no-synopsis`, `early-credentials`). Pixel comparison of every suite PDF at 144 dpi (workflow revisions paired by order; the deliberate `.partial-` export skipped): 57 PDFs, 136 pages, 57 identical, 0 differ. Frozen v11 and legacy-parity pass inside the suite.
- Mutations (each reverted): "vessel" back in pagination -> "speaks marine or Flagship: ['vessel']"; `layout.opening-margin` in page.typ -> caught as vocabulary; `artwork.portrait-frame` -> "reads artwork keys the Framework does not own"; `ctx.layout.hero` -> "reads layout keys ... ['hero']"; `"#102f3a"` in primitives -> "hard-codes colours".
- `python scripts/outputs.py check`: 19 PDFs, 0 problems. `python .atlas/_kit/atlas.py check --strict`: all five pages ok.
- Not covered: the two private compositions (legacy `document-shell` with a spread Flagship layout and theme) were not recompiled here (no `private/` in worktrees); by construction they inherit `shell` and `art-palette` from the spread base.
- Out of scope, recorded: `core/theme.typ` still requires Flagship-shaped colours (`hero`, `plate`, `on-hero`, `surface`, `rule`), and the shell's band paints `theme.colors.hero`; a second domain's theme must define them. Suggested next step: split `validate-theme` into the core's colours and Flagship's when a second template needs a different set.

## Review
Round 1 (code-reviewer, docs/work/core-neutral/reviews/01-code-reviewer.md): PASS with three Minors and three Notes; the lead had the Minors fixed (08cf1bd).
- R1-01 fixed: `shell.margin` is Flagship's only opening margin (`opening-margin` removed from flagship-v11.typ; the page loop reads `layout.shell.margin`). Flagship's `check-layout` refuses a layout that still sets `opening-margin` or `hero.band-height`, with a message naming the `shell` key, in `flagship` and in the deprecated `document-shell` (marine's lib.typ now takes it from Flagship's legacy.typ: the Framework's wrapper after the check; the legacy-name count dedupes it, still 32). New fixture `retired-keys.typ`, four refusal cases. The two private compositions spread the base layout and set neither key (reviewer-verified; not re-read).
- R1-02 fixed: the skills case renders the page and asserts the Silver Bridge compass bullets contain no #c8a579/#236a70 pixels (gold section: 778, silver: 0). Mutation `art-palette: (:)` in silver-bridge.typ -> silver 38, assertion fails.
- R1-03 fixed: colour check adds hsl/hsv/linear-rgb and named colours other than white/black (strings excluded); comment stripping is one scan that keeps string literals. Mutations (each reverted, absolute worktree paths, Main Folder checked clean): `color.hsl(...)` -> ['hsl('], `color.linear-rgb(...)` -> ['linear-rgb('], `navy` -> ['navy'], `"https://example.org", "vessel"` on one line -> ['vessel'] (the old stripper hid it); the five round-0 mutations still fail as before.
- N1: run.py comment corrected; the theme-check split is the lead's follow-up task. N2: merged origin/main 7acccd8 (ed942c3; Atlas generated files taken from main, rebuilt). N3: no change.
- Evidence after the merge: origin/main 7acccd8 suite PASS 98 (`builds/base-origin-main-7acccd8-tests-20261014-092007-432312`); branch 08cf1bd suite PASS 104 (`builds/tests-20261014-092049-058408`; +2 page-plan, +4 retired-key cases). Pixel comparison of every suite PDF at 144 dpi: 61 PDFs, 140 pages, 61 identical, 0 differ (workflow revisions paired by order, the deliberate `.partial-` export skipped). Atlas citation ranges into changed files (AGENTS.md:28-44, 35-44; new-theme SKILL.md:1-5) are unchanged from main.
<!-- SECTION:NOTES:END -->
