---
id: TASK-76
title: >-
  plan-check: a script refuses a decomposition with missing fields, unknown
  dependencies, cycles or virtual milestones
status: Queued
assignee: []
created_date: '2026-11-08T09:50:00Z'
updated_date: '2026-11-08T09:51:00Z'
labels: []
milestone: m-8
dependencies:
  - TASK-74
  - TASK-75
ordinal: 76000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner: Claude Code session
Branch/worktree: feat/review-agents in .worktrees/review-agents
Integration target: main
Depends on: TASK-74, TASK-75
Plan: archive/work-records/review-agents/plan.md

## Outcome and boundaries
scripts/plan_check.py <milestone> checks every task of a milestone: the milestone exists, the title shape, the description header, Outcome and boundaries, at least one acceptance criterion, dependencies that exist and form no cycle. Its tests wired into tests/run.py. Excludes judging task quality.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 plan_check.py exits non-zero naming each refused task and reason
- [ ] #2 Fixtures with a cycle, a missing dependency and a virtual milestone are each refused; the current milestones run
- [ ] #3 Suite and ruff pass
- [ ] #4 code-reviewer and tests-reviewer PASS
<!-- AC:END -->
