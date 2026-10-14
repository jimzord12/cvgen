---
id: TASK-55
title: 'repo-layout: fewer top-level folders and a clean `scripts/`'
status: Active
assignee: []
created_date: '2026-10-14 04:48'
updated_date: '2026-10-14 09:40'
labels:
  - restructure
dependencies:
  - TASK-52
  - TASK-31
ordinal: 55000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Group `brand/`, `design-concepts/` and `archive/` under one folder; move `scripts/design_review/` to `apps/design-review/`; one naming case per file type (`docs/conventions.md`); have `M/lib.typ` re-export themes, artwork and layouts so an example needs one import. Owner decision 2026-10-14: go ahead unattended, report the tree before and after (no per-move approval). Source: archive/work-records/workflow-model/handoff.md, section 4, item 23 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started. The owner answered its open question on 2026-10-14 (docs/proposals/workflow-model.md); the decision overrides this description where they differ.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Suite passes, the Design Review app still starts and lists PDFs; the final report shows the tree before and after
- [ ] #2 Top-level folders grouped and scripts/design_review moved to apps/design-review, history kept, links fixed
- [ ] #3 One naming case per file type, written in docs/conventions.md and applied
- [ ] #4 M/lib.typ re-exports themes, artwork and layouts so an example needs one import; frozen reference stays pixel-identical
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Owner decision 2026-10-14 recorded in docs/proposals/workflow-model.md: go ahead unattended; history kept, links fixed, suite passing; report shows the tree before and after.

From TASK-52 review: regrouping archive/ moves archive/work-records again; repoint the same live files TASK-52 touched (git show --stat of the TASK-52 merge: AGENTS.md, docs/development.md, docs/review.md, glossary, guides, research notes, open proposals, .claude agents and skills, .codex agents, .claude/repo-maintenance.md, docs/workflow stage.yaml 03/05/07, .atlas/src).

Decision (grouping folder): brand/, design-concepts/ and archive/ moved under studio/ (studio/brand, studio/design-concepts, studio/archive with design-studies, anti-examples and work-records); inner names kept so glossary terms and globs only gain a prefix. 'studio' because three of its four parts are design work beside the engine.

Decision (tools/): tools/ stays top-level. Visible top-level entries go from 17 to 16 (limit 18 in .claude/repo-maintenance.md); TASK-38 is wiring tools/workflow into the suite and CI right now, and ADR 0015 docs and docs/workflow anchors name it. apps/ is for apps a person runs, tools/ for developer tooling, scripts/ for local commands.

Decision (frozen and protected): tests/baseline.json keys repointed to studio/archive/design-studies/ with identical hashes (the frozen check stays intact). The one concept Meta File whose source field named the old path (2026-09-27-first-fitting) had only that string changed; sha256 and date untouched. Frozen anti-example sources and briefs keep their old compile comments; their README now gives the new command.

Decision (old paths left on purpose): closed tasks, docs/history.md entries, ADRs, studio/archive/work-records, the session-handoff doc (the lead rewrites it on main) and task-38 (active in a parallel session; its file has no moved path) keep old paths; the owner's quote in docs/proposals/workflow-model.md ('Move to archive/') is unchanged.

Decision (naming): conventions.md 'File names' table: kebab-case for folders and every file of ours, snake_case for Python, tool-fixed names as the tool wants, vendored fonts and licences upstream, the frozen reference and its archived renders exempt. Renamed 9: eight docs/images PNGs (lowercase) and CVgen_Logo.v3.jpg -> cvgen-logo-source.jpg (a -v3 stem would trip audit check N2).

Decision (one import): marine lib.typ exports roles, flagship-themes, flagship-artwork, flagship-layouts as modules gathered in roles.typ, templates/flagship/themes.typ, artwork.typ, layouts.typ (the components.typ pattern; modules rather than dictionaries because flagship-layouts.one-page(candidate) must be callable). Examples, README sample and build-a-cv snippets use it; fixtures and direct imports unchanged.

Decision (Atlas): system-map node titles that were paths (design-concepts/, brand/, archive/work-records/) became names (Design concepts, Brand, Work records) so the longer studio/ paths stay in the path line.
<!-- SECTION:NOTES:END -->
