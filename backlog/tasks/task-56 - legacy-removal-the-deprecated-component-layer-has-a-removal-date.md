---
id: TASK-56
title: 'legacy-removal: the deprecated component layer has a removal date'
status: Active
assignee: []
created_date: '2026-10-14 04:48'
updated_date: '2026-10-14 05:44'
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
- [x] #1 tests/fixtures/skills.typ calls only ctx-first components (make-ctx and flagship-components) and renders pixel-identical to its pre-migration render (evidence in the notes)
- [x] #2 No public file outside the legacy layer itself (the two legacy.typ files, the lib.typ re-exports and the legacy-parity fixture with its suite check) calls a deprecated flat component name
- [x] #3 The legacy layer's fate is decided on evidence: either both legacy.typ files and their lib.typ exports are gone, or the layer has a removal date and precondition recorded in docs/framework-gaps.md, docs/conventions.md, AGENTS.md and a follow-up task
- [x] #4 A mapping table from each deprecated flat name to its ctx-first call is in the docs, so an old private composition migrates without reading legacy.typ
- [x] #5 python tests/run.py passes with the frozen v11 reference pixel-identical; scripts/outputs.py check passes
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Trace every caller of the 32 deprecated flat names (public tree; import lines of the private compositions). 2. Migrate tests/fixtures/skills.typ to make-ctx + flagship-components; prove its render pixel-identical before/after. 3. Decide: remove the legacy layer if nothing still imports it, else keep it with a dated removal plan, a migration mapping table (old name -> ctx-first call) and a follow-up task. 4. Update docs that describe legacy.typ (AGENTS.md, conventions, framework-gaps, skills reference, build-a-cv). 5. Suite, outputs check, Atlas check.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Result and evidence (2026-10-14)

Callers traced: in the public tree only `tests/fixtures/skills.typ` called a deprecated flat name (`skills-section`); `legacy-parity.typ` calls all 32 on purpose. No example, design concept, archive file, script or skill imports one; doc snippets were already ctx-first. Import lines of the owner's private compositions (main checkout's `private/`, read-only grep of import lines, nothing else read or touched): the two marine custom compositions import 12 of the 32 names (document-shell, page-header, hero, section-heading, synopsis, experience-section, education-languages-section, label, metric, profile-summary, education-entry, skills-section); the third private composition (not marine) imports only `normalize-common`, `validate-common`.

Decision: keep the layer and give it a date, not remove it now. Deleting it would break the compile of both delivered marine CVs, and re-pointing their `cv.typ` needs the owner's go (framework-gaps entry; preferences allow agents to edit `cv.typ` only for a CV he asked for). Removal date 2026-10-31, follow-up TASK-58 (due date set) with the precondition and steps.

Done: `skills.typ` migrated to `make-ctx` + `flagship-components` (default `skills-layout`). Mapping table of all 32 old calls to ctx-first calls in `docs/guides/build-a-cv.md` section 8 (each row is the call pair `legacy-parity.typ` already proves pixel-identical). Date and pointer added to AGENTS.md, conventions.md, framework-gaps.md (Update line), architecture.md, domains-and-roles.md, skills-component.md, verification.md and both legacy.typ headers.

Evidence:
- Skills fixture before/after: `builds/task-56-skills-before/skills.pdf` vs `builds/task-56-skills-after/skills.pdf` and the suite's `skills/skills.pdf`: 1 page, 2481x3508 px at 300 dpi, 0 differing bytes, 10/10 `/Artifact` tags, identical text (PDF bytes differ only in Typst's IDs).
- `python tests/run.py` PASS at 62c373e: 94 compilation cases, evidence `builds/tests-20261014-083324-779143` (frozen v11 reference pixel-identical).
- `python scripts/outputs.py check`: 19 PDFs indexed, 0 problems.
- `python .atlas/_kit/atlas.py check`: all five pages already STALE on main before this change (snapshot 2026-10-06); no page describes the legacy layer, so none was updated or restamped here.

## Review

Round 1, code-reviewer, 2026-10-14: PASS with minors (`docs/work/legacy-removal/reviews/01-code-reviewer.md`). All four fixed in 5ca7401:
- m1: removal written as planned everywhere ("removal planned 2026-10-31 (TASK-58)": AGENTS.md, architecture.md, domains-and-roles.md, conventions.md, build-a-cv.md, skills-component.md).
- m2: both lib.typ surfaces carry the date and the pointer to the mapping table.
- n1: legacy-parity.typ has a default-geometry `skills-section` pair (no `geometry:`). Mutation check: a wrapper default with `column-gap: 20mm` makes page 4 differ, the real default keeps all 5 pages identical.
- n2 and lead's settled decision: the owner authorized TASK-32 in this run, so TASK-58 now depends on TASK-56 and TASK-32; its precondition is TASK-32's migration of the two clients' cv.typ to ctx-first calls (no separate owner go); 2026-10-31 stays as the backstop. TASK-32 has a note naming the 12 names and the table.

Merged origin/main (TASK-29) cleanly. After the fixes: `python tests/run.py` PASS, 94 cases, evidence `builds/tests-20261014-084152-662927`; `scripts/outputs.py check` 19 PDFs, 0 problems; Atlas: the five pages went stale only on this branch's files, no cited line range or page fact touches the changed passages, all five restamped (`ok`). A context-reviewer round for the doc changes follows (lead).
<!-- SECTION:NOTES:END -->
