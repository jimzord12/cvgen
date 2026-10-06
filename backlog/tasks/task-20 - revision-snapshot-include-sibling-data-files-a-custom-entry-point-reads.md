---
id: TASK-20
title: 'revision-snapshot: include sibling data files a custom entry point reads'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/oUrlmz8I'
ordinal: 20000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# revision-snapshot: include sibling data files a custom entry point reads

Owner: unassigned. Found by the docs-audit review round 2 (R2-N3), 2026-09-25; code reading only, not reproduced on the real workspace.

## Problem
`cv_workflow/render.py` snapshots `cv.typ`, `candidate.json` and the portrait into `revisions/<id>/inputs/`. A custom composition (build-a-cv section 8) that also reads a sibling file such as `presentation.json` either fails inside the snapshot (relative path) or reads the live file (root-absolute path), so the revision is not self-contained and approval does not bind to what was rendered.

## Outcome
Every file an entry point reads with `json(...)`/`read(...)`/`image(...)` from its workspace is snapshotted with its hash in `render.json`, or the render refuses with a message naming the file.

## Acceptance
- A workflow test with a sibling data file renders from the snapshot alone.
- Suite green; review PASS.

## Added 2026-09-25 (framework-split)
- docs/framework-gaps.md "A client whose domain does not exist yet": a one-off Template must fit in cv.typ because a revision snapshots only cv.typ, candidate.json and the portrait. This card closes that gap.
- Add a suite case to tests/workflow.py: a fictional one-off entry importing only /packages/cv-framework/lib.typ, rendered with --pages 1; assert success and schema null (framework-split review 02, R2-N3).
## What it fixes for a real person (plain words)
When you approve a client's CV, the approval is meant to lock in exactly the files that made that PDF, so the CV you send is the CV you checked. Until tonight a custom CV that kept extra facts in a side file (like the second real client's `presentation.json`) either failed to build from its saved copy or quietly read the live file, which could change after you approved; now every file the CV reads is saved with the revision, and a CV that still reads a live file cannot be approved.

## Result and evidence (Night Shift 2026-09-27)
- Merge: https://github.com/jimzord12/cvgen/commit/20622b4 (suite PASS 52 cases on main after merging with certificate-validity-check).
- A revision now copies every workspace file `cv.typ` (or a local helper) reads by a literal path and lists it with its hash in render.json (`inputs.files`); refuses root-absolute reads into private/ or the workspace, paths leaving the workspace, missing files, a file taking the portrait's place; and after the compile, Typst's dependency list turns any `Live Read` (new glossary term) into a failed check, so approval is refused.
- Suite: a Framework-only one-off (schema null, --pages 1) with sibling data, a helper, a read after a URL; it compiles from the snapshot after the live files are deleted.
- Read-only probe of the two real compositions: one reads nothing extra, the other reads presentation.json by a relative path (now snapshotted); neither is refused. Not yet proven by a real render with the dependency check (next real render will show; a misfire would fail loudly, no data risk).
- Framework gap "A client whose domain does not exist yet": snapshot half closed.

## Review
- Round 1 FINDINGS: https://github.com/jimzord12/cvgen/blob/main/docs/work/revision-snapshot/reviews/01.md (M1 URL comment stripping hid reads: fixed, plus the dependency-list safety net; m1-m4 fixed).
- Round 2 PASS: https://github.com/jimzord12/cvgen/blob/main/docs/work/revision-snapshot/reviews/02.md. R2-m1 (an `include` inside an expression is not found; loud "file not found") documented in the cv-workflow README rather than widened; R2-N1 (check fails open on an odd dependency list or a network share) and round-1 N2 (schema chosen from cv.typ's imports only) deferred for triage.

## Handoff
Done. Deferred for triage: R2-m1, R2-N1, R1-N2 above.
<!-- SECTION:DESCRIPTION:END -->
