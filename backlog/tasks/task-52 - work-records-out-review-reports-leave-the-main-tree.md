---
id: TASK-52
title: 'work-records-out: review reports leave the main tree'
status: Queued
assignee: []
created_date: '2026-10-14 04:48'
updated_date: '2026-10-14 05:18'
labels:
  - restructure
dependencies: []
ordinal: 52000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
`docs/work/*/reviews` is two thirds of all docs. Move them to an orphan `records` branch or summarize them in the task's notes. Owner decision. Source: docs/work/workflow-model/handoff.md, section 4, item 20 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started. The owner answered its open question on 2026-10-14 (docs/proposals/workflow-model.md); the decision overrides this description where they differ.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 docs/work/ is moved to an archive folder with git history kept; live links and the rules naming docs/work/<id>/reviews/ (docs/development.md, docs/review.md, AGENTS.md, skills) point to the new place
- [ ] #2 New review reports go to the new place by task; python tests/run.py passes
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Owner decision 2026-10-14 recorded in docs/proposals/workflow-model.md: move docs/work/ to an archive folder (archive/work-records/ suggested); new review reports go there by task; fix live links.
<!-- SECTION:NOTES:END -->
