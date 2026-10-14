---
id: TASK-42
title: 'workflow-reality-check: level 3, the model checked against a real run'
status: Queued
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 06:52'
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
