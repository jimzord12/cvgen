---
id: TASK-50
title: 'fonts-dedupe: the fonts stored twice are kept once'
status: Active
assignee: []
created_date: '2026-10-14 04:48'
updated_date: '2026-10-14 05:59'
labels:
  - restructure
dependencies: []
ordinal: 50000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
The pack is about 52 MiB against a 28 MB tree; each release adds about 11 MB. Publish the `Release` PDFs and `docs/images` PNGs as GitHub Release assets or move them to LFS; dedupe the three fonts in `design-concepts/fonts/` vs `packages/cv-framework/fonts/`. Owner decision (it changes the `Release` location). Source: docs/work/workflow-model/handoff.md, section 4, item 18 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started. The owner answered its open question on 2026-10-14 (docs/proposals/workflow-model.md); the decision overrides this description where they differ.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Release PDFs and docs/images stay in the repo (owner decision 2026-10-14: no LFS, no history rewrite)
- [x] #2 Each font family exists once; design-concepts compile and the suite passes with the single copy
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Hash every font in design-concepts/fonts, packages/cv-framework/fonts and archive/anti-examples/fonts; list exact duplicates.
2. Compile the 14 design-concept entry points to builds/ (documented flags), delete the duplicate families from design-concepts/fonts (Framework copy and licences stay canonical), compile again, compare pages at 2x.
3. Point briefs, README and magazine-editor profiles at the single copy; run the suite, outputs check and Atlas check.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Owner decision 2026-10-14 recorded in docs/proposals/workflow-model.md: keep release PDFs and README images in the repo (no LFS, no history rewrite); only deduplicate the fonts stored twice (design-concepts/fonts vs packages/cv-framework/fonts).

## Result and evidence

Duplicates found (SHA-256 of every font file in design-concepts/fonts, packages/cv-framework/fonts and archive/anti-examples/fonts; anti-examples share nothing). The review said only Bona Nova; the hashes show four families, seven files, byte-identical with the Framework copies, and the four OFL.txt files identical to packages/cv-framework/licenses/*-OFL.txt:
- Bona Nova: Regular 401524, Italic 429716, Bold 396420 bytes
- M PLUS 1p: Regular 1758688, Bold 1766552 bytes
- Kaisei Tokumin: ExtraBold 4564000 bytes
- Sofia Sans Extra Condensed: [wght] 345304 bytes
Total 9,662,204 bytes of fonts (about 9.2 MiB) plus four 4.4 KB licences removed. design-concepts/fonts/ keeps only families the Framework lacks: alegreya, fira-sans, jost.

Changes: the four duplicate folders removed from design-concepts/fonts/; the Framework fonts and licences stay canonical (the licences were already in packages/cv-framework/licenses/). Briefs of first-fitting, concourse, stamp-rally and woodblock-road, design-concepts/README.md and both magazine-editor profiles (.claude, .codex) now point to the single copy.

Visual proof: all 14 design-concept entry points compiled with the documented flags (--ignore-system-fonts, Framework font path first, then design-concepts/fonts) to builds/task-50-fonts-before-20261014-085407 (before) and builds/task-50-fonts-after-20261014-085451 (after). 0 compile warnings either run. 23 pages rendered at 2x with pymupdf: every pixel buffer identical, embedded font names identical. The committed concept PDFs were not rewritten (compiled to builds/ only).

Checks: python tests/run.py PASS, 94 compilation cases (builds/tests-20261014-085504-952984); scripts/outputs.py check: 19 PDFs indexed, 0 problems; Atlas check: design-run and roster pages cited changed sources, facts still true, restamped.
<!-- SECTION:NOTES:END -->
