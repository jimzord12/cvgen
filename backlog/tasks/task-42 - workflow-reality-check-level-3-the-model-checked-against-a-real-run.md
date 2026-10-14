---
id: TASK-42
title: 'workflow-reality-check: level 3, the model checked against a real run'
status: Active
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 10:37'
labels:
  - workflow-model
dependencies:
  - TASK-38
ordinal: 42000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Extend `tests/workflow.py`, or drive it from the workflow tool, so a fictional client runs every automated step in a temporary `Envelope`; declared artifacts must exist and validate; labelled stand-ins cover human steps. Add a read-only local mode for a real `Envelope` that never copies data. Source: archive/work-records/workflow-model/handoff.md, section 4, item 10 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Suite step passes
- [ ] #2 changing a script's output name makes it fail with the step ID
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
From TASK-38 review: removing art.approval-json from deliver.export's inputs still passes levels 1-2 (order without data is unchecked); level 3 should prove export waits for approval.

Decisions (TASK-42): (1) The runner lives in tools/workflow (src/reality.ts, TypeScript): it reuses TASK-38's loadModel/checkModel and the model graph (new entities() helper in check.ts) instead of re-reading the YAML in Python; tests/workflow.py run_reality only drives it for the suite. (2) Walk rule: a step runs once its inputs exist, in waves, model order inside a wave; a gate's branch waits for its gate except a loop's way back; optional steps only when the scenario names them; no loop turns (happy path only, per the brief). (3) Scenario happyPath: consent, no Deep Dive, Text Draft signed off first time, Flagship fits, every review passes: 50 steps taken, 10 cmd run (approve with a stand-in approver and --test-only), 40 stand-ins (13 manual, 23 lead, 3 skill, 1 agent), 54 not taken. 3 of 13 cmd steps are off this path: text-draft.draft-supersede (correction branch), design.record-choice and design.record-other-answer (concept stamps, which would write in studio/). (4) scripts/outputs.py stamp gained --root so the run can stamp an Envelope under builds/; cv.py approve gets --test-only; both are logged adjustments, the model's commands are unchanged. (5) Stand-ins write fictional outputs; paths outside private/ (backlog/tasks/, docs/research/) land in the run's repo copy under builds/, never in the repository. (6) The candidate stand-in is the engineer example with a client's footer and brand and none of the example wording: gate.example-wording is read from the real wording check, which found fictional/illustrative/flagship on the raw example. (7) Model unchanged: every path the model declares for a command's output matched what the script wrote; docs/workflow/GAPS.md gained two items (deliver.page-png's folder is not made by its command; order without data: render runs beside design.preview before the design review returns). (8) ajv stays a devDependency (bun install installs it; no lockfile change). (9) envelope mode prints only the Alias, model paths and counts, opens only envelope.json.

Real-Envelope walk (read-only, bun run envelope on the Main Folder's private/ Envelope with Alias client-2026-09-03): 41 steps declare Envelope artifacts: 17 complete, 1 partial, 23 none; 37 declared Envelope artifacts: 18 present, 19 missing (that Envelope predates the intake workflow: intake, research, Text Draft and Export artifacts absent). Paths and modification times of every file in it were identical before and after; nothing was copied.

Evidence: suite PASS 146 cases incl. workflow-model-reality, workflow-model-reality-renamed-output (FAILED level 3 at deliver.render, art.render-json) and workflow-model-reality-export-waits-for-approval (FAILED level 3 at deliver.export: cv.py export refuses, not approved; no Export written), builds/tests-20261014-133529-052544 on 5058ae4+; bun test 65 pass, typecheck and bun run check clean, ruff 0.16.10 clean, anchors since a84e303: 0 moved, 0 edited. Not reviewed (review left to the lead).
<!-- SECTION:NOTES:END -->
