---
id: TASK-40
title: 'workflow-prose: the stage READMEs and the journey README'
status: Queued
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 10:25'
labels:
  - workflow-model
dependencies:
  - TASK-39
ordinal: 40000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Hand-written purpose, judgement and branches per stage; the top README at 200-300 lines (owner decision, docs/proposals/workflow-model.md). Refers to IDs and never restates contracts. Source: archive/work-records/workflow-model/handoff.md, section 4, item 8 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 A context-reviewer PASS
- [ ] #2 a newcomer test: an agent answers five "what happens if" questions from these files alone
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
From TASK-39 context review: the generated summary block already prints each stage's Purpose from the YAML; write judgement and branches, not a second purpose line. In 05-design, design.fill-data is entered only from gate.template-exists pass; on the no-Template path port-concept reads art.candidate-json but nothing leads into fill-data: check against the guides and fix the model or explain the branch in prose.
<!-- SECTION:NOTES:END -->
