---
id: TASK-41
title: 'atlas-from-model: the Atlas client journey is built from the model'
status: Done
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 11:41'
labels:
  - workflow-model
dependencies:
  - TASK-39
ordinal: 41000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Port the Atlas build to TypeScript (or feed the existing page format from the model); retire hand-written `client-journey.json` facts. Later pages follow. Source: archive/work-records/workflow-model/handoff.md, section 4, item 9 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 The client-journey page is generated
- [x] #2 `atlas check` (or its successor) passes
- [x] #3 the old page data is deleted
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Decisions (TASK-41, 2026-10-14): (1) Route: feed the kit's existing page format from the model (ADR 0015), no port; new command bun run atlas in tools/workflow (src/atlas.ts), separate from render because render also runs on fixture folders and must never touch the real .atlas. (2) One phase per stage, one Atlas step per model step (104), model order; step sources = the model step's own anchors; a note names the step, action and stage.yaml. (3) Arrows: derived edges forward to non-optional steps minus gate branches, transitively reduced; optional (when) steps sit beside the line as the kit draws them; gates give pass and fail branches; a loop is drawn on the step that goes back (the gate's step when the fail step is earlier, else the fail step back to the nearest step it feeds). (4) Stamping: writing a changed page runs atlas.py stamp client-journey (the facts come from a model that just passed check); a cited-file change with the page unchanged is re-checked with bun run anchors and stamped by hand; CI and the suite run bun run atlas --check (page JSON only, deterministic). (5) Dropped the status panel (one client, 2026-10-04, out of date: delivery recorded); old-page facts the model lacks listed in docs/workflow/GAPS.md (7 items). (6) design-run.json link build-cv -> design.port-concept. (7) Map view kept as the default; 104 steps make a long swimlane, the Walk through view reads easier: owner may want defaultView story.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
bun run atlas writes the Atlas client-journey page from the Workflow Model in the kit's existing format (7 phases, 104 steps, each citing its step's source anchors) and stamps it unless a cited source is already stale (then it names the files and exits 1); bun run atlas --check runs in the suite and CI; the hand-written page data is deleted; old-page facts the model lacks are in docs/workflow/GAPS.md. Code rounds FINDINGS, PASS, PASS; context rounds FINDINGS, PASS. Suite PASS 147 builds/tests-20261014-142243-601078, CI 38557530833 green, 108 bun tests.
<!-- SECTION:FINAL_SUMMARY:END -->
