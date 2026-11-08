---
id: TASK-76
title: >-
  plan-check: a script refuses a decomposition with missing fields, unknown
  dependencies, cycles or virtual milestones
status: Queued
assignee: []
created_date: '2026-11-08T09:50:00Z'
updated_date: '2026-11-08T10:31:00Z'
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
Plan: archive/work-records/review-agents/plan.md (revision 2)

## Outcome and boundaries
scripts/plan_check.py TASK-N [TASK-M ...] checks the plan's listed tasks, not a milestone (D7): each exists, is not Done and names a known milestone id; the title shape, the description header, Outcome and boundaries, at least one acceptance criterion; the frontmatter dependencies are the source, exist, agree with the header's Depends on, and form no cycle; dependencies outside the plan or milestone are allowed and reported. Standard library only. Its tests use fixtures, wired into tests/run.py; the suite never reads the live backlog. Excludes judging task quality.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 plan_check.py exits non-zero naming each refused task and reason
- [ ] #2 Suite and ruff pass
- [ ] #3 code-reviewer and tests-reviewer PASS
- [ ] #4 Fixtures with a cycle, a missing dependency, a header that disagrees with the frontmatter and a virtual milestone are each refused; the script run on TASK-75 to TASK-78
<!-- AC:END -->
