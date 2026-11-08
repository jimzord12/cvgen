---
id: TASK-77
title: >-
  decomposition-reviewer: a fresh reviewer checks that a plan's milestones and
  tasks are clear, complete and correctly ordered
status: Queued
assignee: []
created_date: '2026-11-08T09:51:00Z'
updated_date: '2026-11-08T10:54:00Z'
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
Plan: archive/work-records/review-agents/plan.md (revision 3)

## Outcome and boundaries
The plan skill gains the decomposition checklist (with a files column for parallel safety) and the loop with its locations (D8): the Plan on its branch and reviewed; tasks created Queued on main with a Plan: header line; plan_check.py from a checkout of main on their ids; the decomposition-reviewer with three pins (Plan at its branch commit, tasks at the main commit, the ids), fixes as record edits on main and plan_check.py rerun each round; then the first task goes Active; later changes re-run both on the changed ids. The decomposition-reviewer agent (Opus high, read-only) and its gate in docs/review.md; the backlog skill. Excludes a decomposer agent.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 plan skill holds the decomposition checklist and loop; decomposition-reviewer.md holds only its own procedure
- [ ] #2 docs/review.md names the gate, its brief and that plan_check.py runs first
- [ ] #3 context-reviewer PASS
- [ ] #4 Known-answer run on the P-0019 split (TASK-63 to TASK-68) with its key committed first; plan_check.py skipped there and said so; the score decided with a reason, under half of the key needs a named change or a stated limitation (D14)
- [ ] #5 plan skill and backlog skill give the loop's order: tasks created Queued on main, plan_check.py on their ids, the decomposition-reviewer, then the first task goes Active (D8)
<!-- AC:END -->
