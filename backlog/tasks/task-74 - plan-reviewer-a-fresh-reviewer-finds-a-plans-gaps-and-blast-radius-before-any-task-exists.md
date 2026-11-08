---
id: TASK-74
title: >-
  plan-reviewer: a fresh reviewer finds a plan's gaps and blast radius before
  any task exists
status: Queued
assignee: []
created_date: '2026-11-08T09:50:00Z'
labels: []
milestone: m-8
dependencies:
  - TASK-73
ordinal: 74000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner: Claude Code session
Branch/worktree: feat/review-agents in .worktrees/review-agents
Integration target: main
Depends on: TASK-73
Plan: archive/work-records/review-agents/plan.md

## Outcome and boundaries
A plan skill (generic plan template and plan checklist), the plan-reviewer agent (Opus high, read-only, blind impact map first) and its gate in docs/review.md with the CVgen impact items. Excludes decomposition review and plan_check.py.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 plan skill holds the plan template and checklist; plan-reviewer.md holds only its own procedure
- [ ] #2 docs/review.md names when a plan is reviewed, the brief, and the CVgen impact items
- [ ] #3 Known-answer run on archive/work-records/backlog-migration/plan.md recorded, then a run on the review-agents plan before TASK-75 starts
- [ ] #4 context-reviewer PASS
<!-- AC:END -->
