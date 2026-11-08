---
id: TASK-77
title: >-
  decomposition-reviewer: a fresh reviewer checks that a plan's milestones and
  tasks are clear, complete and correctly ordered
status: Queued
assignee: []
created_date: '2026-11-08T09:51:00Z'
updated_date: '2026-11-08T11:08:00Z'
labels: []
milestone: m-8
dependencies:
  - TASK-76
ordinal: 77000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner: Claude Code session
Branch/worktree: feat/review-agents in .worktrees/review-agents
Integration target: main
Depends on: TASK-76
Plan: archive/work-records/review-agents/plan.md

## Outcome and boundaries
The decomposition-reviewer, the plan skill's decomposition checklist and loop, and the template changes, as the plan's D8 and D19 say. Excludes a decomposer agent.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Every file the plan's tables assign to T4 made or changed as D8 and D19 say
- [ ] #2 Known-answer run on the P-0019 split (TASK-63 to 68), key committed first, plan_check.py skipped there (D14)
- [ ] #3 context-reviewer PASS
<!-- AC:END -->
