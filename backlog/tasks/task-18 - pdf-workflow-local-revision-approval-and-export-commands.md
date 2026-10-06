---
id: TASK-18
title: 'pdf-workflow: local revision, approval and export commands'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
updated_date: '2026-10-06 07:49'
labels: []
dependencies:
  - TASK-14
references:
  - 'https://trello.com/c/iG8cLU6L'
ordinal: 18000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# pdf-workflow: local revision, approval and export commands

Owner: Claude Code. Branch: `feat/pdf-workflow` (from main 4a3d6ad), fast-forwarded into `main` at bb976a6. Integration target: `main`.
Depends on: monorepo-migration (Done, main 4a3d6ad).

## Outcome and boundaries
The smallest useful `cv-workflow` boundary and local commands from the approved lifecycle in docs/pdf-workflow.md: render and retain a revision, run checks, explicit approval, export with receipt. Reserve the future web boundary; build no web app, accounts, database, hosting or job service.

## Acceptance
See checklist (5/5).

## Result and evidence
- `packages/cv-workflow/cv_workflow/` (Python: workspace, render, checks, approve, export) + `scripts/cv.py render|approve|export|status <workspace>`. Records per revision: inputs/{cv.typ,candidate.json,assets/}, render.log, render.json, checks.json, cv.pdf, cv.approval.json; exports/<id>/{cv.pdf,cv.approval.json} via a .partial- folder and rename.
- Suite `python tests/run.py` at ce3ac93: PASS, 35 cases (9 workflow checks) - builds/tests-20260916-222751-164262/. The workflow's own render of the fictional engineer equals the frozen v11 reference (raster + text). Every refusal on the card is exercised through the real CLI on a fictional workspace under builds/: changed bytes, missing/copied/forged receipt, failing/stale/corrupt checks, repeated export, conflicting destination and bundle, interrupted render and export, refused renders leaving nothing, Greek name in a compiler error.
- CI green on ce3ac93 (code snapshot); main bb976a6 adds only the round-3 report.
- No real candidate approved, nothing delivered: `--test-only` approvals are refused under private/; the two private workspaces were not touched.

## Review
- Round 1 FINDINGS (F1 Material: cp1252 decode crash on a Greek name in a Typst error; F2-F4 Minor; N1-N2) - docs/work/pdf-workflow/reviews/01.md, all fixed in f5ef0e1.
- Round 2 PASS with F5 Minor (corrupt JSON record tracebacks) and N3 - reviews/02.md, fixed in ce3ac93.
- Round 3 PASS, no findings; N4 Note deferred (wrong-shape but parseable record still tracebacks in status; needs a hand edit) - reviews/03.md.

## Follow-ups (not blocking)
- N4: guard `read_json` against non-object JSON and make `describe()` tolerate a success record without `pdf`.
- The two private entry points still use relative imports; the workflow needs root-absolute ones (owner decision pending, see monorepo-migration).

## Handoff
Done 2026-09-16. Next card: none queued for the workflow; apps/web remains future work.

## Links
- Lifecycle: https://github.com/jimzord12/marine-engineer-cv/blob/main/docs/pdf-workflow.md
- Guide: https://github.com/jimzord12/marine-engineer-cv/blob/main/docs/guides/build-a-cv.md
- Package: https://github.com/jimzord12/marine-engineer-cv/blob/main/packages/cv-workflow/README.md
- Reviews: https://github.com/jimzord12/marine-engineer-cv/tree/main/docs/work/pdf-workflow/reviews
- ADR 0010: https://github.com/jimzord12/marine-engineer-cv/blob/main/docs/decisions/0010-public-monorepo-and-pdf-workflow.md
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 End-to-end on fictional data in a fresh isolated workspace: render, retain revision, checks, explicit test-only approval, export bytes and receipt verified
- [x] #2 Failure checks: changed PDF bytes after review, missing or mismatched approval, failing or stale check evidence, repeated export, conflicting destination, interrupted operation
- [x] #3 A later revision inherits no earlier approval; export never rerenders
- [x] #4 No real candidate approval invented, no actual delivery performed
- [x] #5 Suite PASS and code-reviewer PASS on the final snapshot
<!-- AC:END -->
