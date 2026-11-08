---
id: TASK-77
title: >-
  decomposition-reviewer: a fresh reviewer checks that a plan's milestones and
  tasks are clear, complete and correctly ordered
status: Queued
assignee: []
created_date: '2026-11-08T09:51:00Z'
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
The plan skill gains the decomposition checklist and the full loop (plan, plan-reviewer, decompose, plan_check.py, decomposition-reviewer, create tasks); the decomposition-reviewer agent (Opus high, read-only, runs after plan_check.py passes); its gate in docs/review.md. Excludes a decomposer agent.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 plan skill holds the decomposition checklist and loop; decomposition-reviewer.md holds only its own procedure
- [ ] #2 docs/review.md names the gate, its brief and that plan_check.py runs first
- [ ] #3 Known-answer run on the P-0019 split (TASK-63 to TASK-68) recorded
- [ ] #4 context-reviewer PASS
<!-- AC:END -->
