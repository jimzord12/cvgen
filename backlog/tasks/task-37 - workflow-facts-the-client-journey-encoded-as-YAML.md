---
id: TASK-37
title: 'workflow-facts: the client journey encoded as YAML'
status: Queued
assignee: []
created_date: '2026-10-14 04:47'
labels:
  - workflow-model
dependencies:
  - TASK-34
  - TASK-36
ordinal: 37000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
`catalog.yaml` plus seven `stage.yaml` files from the inventory, re-anchored to current `main`, applying task 2's decisions. Source: docs/work/workflow-model/handoff.md, section 4, item 5 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 All seven stages encoded
- [ ] #2 every entity carries its source anchor
- [ ] #3 the inventory's implicit steps (port a concept, update `CV Decisions`, close the record, keep request) are named
<!-- AC:END -->
