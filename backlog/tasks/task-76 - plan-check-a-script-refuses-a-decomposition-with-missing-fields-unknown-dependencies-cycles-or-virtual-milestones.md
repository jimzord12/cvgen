---
id: TASK-76
title: >-
  plan-check: a script refuses a decomposition with missing fields, unknown
  dependencies, cycles or virtual milestones
status: Queued
assignee: []
created_date: '2026-11-08T09:50:00Z'
updated_date: '2026-11-08T11:08:00Z'
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
scripts/plan_check.py and its fixture tests, as the plan's D7 says, wired into tests/run.py after merging main. Excludes judging task quality.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 plan_check.py does what D7 says, refusing and reporting as D7 lists
- [ ] #2 Fixtures for every D7 refusal, reported case and reader shape; suite and ruff pass with the repository's .venv
- [ ] #3 Run on TASK-75 to 78 from this branch and on TASK-79 to 81 from main, output recorded
- [ ] #4 code-reviewer and tests-reviewer PASS
<!-- AC:END -->
