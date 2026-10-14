---
id: TASK-45
title: 'core-neutral: the Framework core holds no Flagship or marine rules'
status: Active
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 05:58'
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
- [ ] #1 The Framework core (packages/cv-framework/core, lib.typ) holds no marine or Flagship rule: no synopsis/certificates/education page-plan rule, no vessel wording, no SVG hex palette, no read of a Flagship layout key (opening-margin, hero.band-height); Flagship and the marine domain supply them
- [ ] #2 Every PDF the suite writes is pixel-identical (144 dpi) to the same PDF from origin/main, and the frozen v11 reference still matches; legacy-parity passes
- [ ] #3 Flagship still enforces its page-plan rules: a plan without a synopsis fails with 'exactly one synopsis' (new suite case), and the core alone accepts a plan without one (core-model fixture)
- [ ] #4 The suite's boundary check fails when marine or Flagship vocabulary, a Flagship layout key or a colour literal is put back into core code (mutations recorded), and passes on the change
- [ ] #5 python tests/run.py passes; python scripts/outputs.py check and python .atlas/_kit/atlas.py check --strict are clean; docs describing the core/domain split are updated
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
