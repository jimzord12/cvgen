---
id: TASK-75
title: >-
  tests-reviewer: tests that test real behaviour, and no test kept for its own
  sake
status: Active
assignee: []
created_date: '2026-11-08T09:50:00Z'
updated_date: '2026-11-08T14:24:00Z'
labels: []
milestone: m-8
dependencies:
  - TASK-74
ordinal: 75000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner: Claude Code session
Branch/worktree: feat/review-agents in .worktrees/review-agents
Integration target: main
Depends on: TASK-74
Plan: archive/work-records/review-agents/plan.md

## Outcome and boundaries
The tests-reviewer, the test-principles skill and the tests gate, as the plan's D5, D6, D12 and D19 say; queue the audit task (D17) when Ready. Excludes rewriting existing tests (the audit does that).
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Every file the plan's tables assign to T2 made or changed as D5, D6, D12 and D19 say
- [ ] #2 Known-answer runs with keys committed first (D14), as the plan's TASK-75 evidence row says
- [ ] #3 The audit task (D17) queued in m-7 on main
- [ ] #4 context-reviewer PASS
<!-- AC:END -->
