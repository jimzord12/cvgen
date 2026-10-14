---
id: TASK-58
title: 'legacy-delete: remove the deprecated component layer on 2026-10-31'
status: Queued
assignee: []
created_date: '2026-10-14 05:31'
updated_date: '2026-10-14 05:41'
due_date: '2026-10-31'
labels:
  - restructure
dependencies:
  - TASK-56
  - TASK-32
ordinal: 58000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Removal date set by TASK-56. On 2026-10-14 the only callers of the 32 deprecated flat component names are the two private marine custom compositions (12 of the names, through marine's lib.typ); every public file is ctx-first. Precondition: TASK-32 (client folder layout, authorized by the owner) has migrated those two clients' cv.typ to ctx-first calls, using the mapping table in docs/guides/build-a-cv.md section 8, and its re-render proved each PDF unchanged. Then delete packages/cv-framework/core/legacy.typ, packages/domains/marine/templates/flagship/legacy.typ, their lib.typ re-exports, tests/fixtures/legacy-parity.typ and its suite block (keep a document-shell metadata check on an example), and close the docs/framework-gaps.md entry. 2026-10-31 is the backstop: if TASK-32 has not landed by then, re-plan the date with it.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 No file in this repository or in the two private compositions imports a deprecated flat component name; both private compositions render pixel-identical to their pre-migration renders
- [ ] #2 Both legacy.typ files, their lib.typ exports and the legacy-parity fixture are gone; python tests/run.py passes with the frozen v11 reference pixel-identical
- [ ] #3 The docs/framework-gaps.md entry 'Legacy component signatures' is closed and the docs no longer describe legacy.typ
<!-- AC:END -->
