---
id: TASK-56
title: 'legacy-removal: the deprecated component layer has a removal date'
status: Active
assignee: []
created_date: '2026-10-14 04:48'
updated_date: '2026-10-14 05:30'
labels:
  - restructure
dependencies: []
ordinal: 56000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
32 wrappers in `W/core/legacy.typ` and `F/legacy.typ` exist for "two private compositions"; `tests/fixtures/skills.typ` still uses them. Migrate the fixture and set a date. Source: docs/work/workflow-model/handoff.md, section 4, item 24 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 tests/fixtures/skills.typ calls only ctx-first components (make-ctx and flagship-components) and renders pixel-identical to its pre-migration render (evidence in the notes)
- [ ] #2 No public file outside the legacy layer itself (the two legacy.typ files, the lib.typ re-exports and the legacy-parity fixture with its suite check) calls a deprecated flat component name
- [ ] #3 The legacy layer's fate is decided on evidence: either both legacy.typ files and their lib.typ exports are gone, or the layer has a removal date and precondition recorded in docs/framework-gaps.md, docs/conventions.md, AGENTS.md and a follow-up task
- [ ] #4 A mapping table from each deprecated flat name to its ctx-first call is in the docs, so an old private composition migrates without reading legacy.typ
- [ ] #5 python tests/run.py passes with the frozen v11 reference pixel-identical; scripts/outputs.py check passes
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Trace every caller of the 32 deprecated flat names (public tree; import lines of the private compositions). 2. Migrate tests/fixtures/skills.typ to make-ctx + flagship-components; prove its render pixel-identical before/after. 3. Decide: remove the legacy layer if nothing still imports it, else keep it with a dated removal plan, a migration mapping table (old name -> ctx-first call) and a follow-up task. 4. Update docs that describe legacy.typ (AGENTS.md, conventions, framework-gaps, skills reference, build-a-cv). 5. Suite, outputs check, Atlas check.
<!-- SECTION:PLAN:END -->
