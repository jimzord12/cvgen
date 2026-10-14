---
id: TASK-37
title: 'workflow-facts: the client journey encoded as YAML'
status: Queued
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 08:04'
labels:
  - workflow-model
dependencies:
  - TASK-34
  - TASK-36
ordinal: 37000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
`catalog.yaml` plus seven `stage.yaml` files from the inventory, re-anchored to current `main`, applying the owner's decisions in docs/proposals/workflow-model.md (TASK-34). Source: docs/work/workflow-model/handoff.md, section 4, item 5 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 All seven stages encoded
- [ ] #2 every entity carries its source anchor
- [ ] #3 the inventory's implicit steps (port a concept, update `CV Decisions`, close the record, keep request) are named
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Notes from TASK-36 review (round 1, F7) - Gates are pass/fail only (ADR 0015): a multi-outcome or decision gate such as gate.template-exists (marine Template or not) or gate.client-answered (chat and/or form) must be written as pass/fail pairs, or as a chain of gates; decide the encoding before writing stage 5. A per-item repeat (one Deep Dive per chosen question) exists only as a step's when text; name it there consistently. Source anchors may contain spaces; a range must run low to high. Report: docs/work/workflow-schema/reviews/01-code-reviewer.md.
<!-- SECTION:NOTES:END -->
