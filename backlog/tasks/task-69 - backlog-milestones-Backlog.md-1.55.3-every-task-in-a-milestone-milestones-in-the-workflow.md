---
id: TASK-69
title: >-
  backlog-milestones: Backlog.md 1.55.3, every task in a milestone, milestones
  in the workflow
status: Queued
assignee: []
created_date: '2026-11-08T09:06:00Z'
labels: []
dependencies: []
ordinal: 69000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Move the Backlog.md pin from 1.52.0 to 1.55.3 (#1038 closed) with an amending ADR; group every task into milestones through the CLI; make plan -> milestones -> tasks part of the main workflow (development.md, backlog skill, glossary, Codex counterparts). The plan-reviewer agent and its gate in review.md are another agent's work.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Every live mention of the pin says 1.55.3 with the reason; only archive/work-records/ holds 1.52 or #1038
- [ ] #2 Every task has exactly one milestone with a done-condition; verified with milestone list and task list
- [ ] #3 development.md, the backlog skill, the glossary and .codex/ carry milestones as principles
- [ ] #4 Suite and ruff pass; context-reviewer PASS; reports verbatim under archive/work-records/backlog-milestones/reviews/
<!-- AC:END -->
