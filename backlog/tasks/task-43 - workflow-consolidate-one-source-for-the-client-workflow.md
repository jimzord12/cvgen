---
id: TASK-43
title: 'workflow-consolidate: one source for the client workflow'
status: Queued
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 10:49'
labels:
  - workflow-model
dependencies:
  - TASK-40
  - TASK-41
  - TASK-42
ordinal: 43000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Replace `client-workflow.md`, `build-a-cv.md` and the lifecycle half of `pdf-workflow.md` with the model; reduce `new-client`/`new-cv` to step-ID pointers; fix the naming-drift items (inventory README: 34 drift items and 53 conflicts, "Fixed without asking"); update `AGENTS.md`; delete `docs/workflow/inventory/`. Source: archive/work-records/workflow-model/handoff.md, section 4, item 11 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 No second description of any step remains (grep checks)
- [ ] #2 the skills still run a fictional client end to end
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Notes from TASK-37 (prose that disagrees with the Workflow Model) -- #1: docs/guides/client-workflow.md:330 and new-client SKILL.md:76-77 write "Delivered <date>. Delete by ..."; the model writes "Exported <date>, delete by <date>" at Export. -- #3: docs/pdf-workflow.md:211 retains approved revisions and copies with no limit; the model deletes 12 months after Export unless a keep request is recorded. -- #4: new-cv SKILL.md:68-86 runs the design-reviewer loop only for a Domain with no Template; the model runs it for every client CV. -- #5: new-cv SKILL.md:111-112 names no one for Export; the model gives it to the lead after Approval. -- #6, #7: no guide or skill has the engine change through code review (design.engine-change, design.engine-review) or the client task (open.task-create, after.close). -- Stall rule, two wordings: "three months without progress" (client-workflow.md:333-336) against "no Export three months after intake" (new-client SKILL.md:97-99). -- Library-note review reports, two places: client-workflow.md:257-258 and new-client SKILL.md:51-52 say archive/work-records/research-<topic>/reviews/, docs/research/README.md:29-30 says archive/work-records/<task or client-free id>/reviews/ (TASK-52 may move both). -- new-cv SKILL.md:75-76 names the preview folder for the design-reviewer but no command. -- Owner answers to docs/proposals/workflow-gaps.md (P-0018) land in the YAML first, then here.

From TASK-42 (level 3, review round 1): open model question: deliver.render reads nothing the design review writes, so a run that starts a step once its inputs exist renders beside design.preview, before the review returns (design.clear-review-input before deliver.render follows from gates only). Decide whether render should read the review's result (or a cleared-review artifact) so the order is in the data; see docs/workflow/GAPS.md, What the YAML leaves out.
<!-- SECTION:NOTES:END -->
