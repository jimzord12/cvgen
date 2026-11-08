---
id: TASK-75
title: >-
  tests-reviewer: tests that test real behaviour, and no test kept for its own
  sake
status: Queued
assignee: []
created_date: '2026-11-08T09:50:00Z'
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
A test-principles skill (generic: behavioural, can fail, structure-insensitive, specific, deterministic, honest changes, no duplicates, missing tests, removal with a reason), the tests-reviewer agent (Opus high; deliberate faults in a builds/ copy) and docs/engine/verification.md's suite-specific rules; the trigger in docs/review.md. Excludes rewriting existing tests.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 test-principles skill and tests-reviewer.md placed by the four questions; verification.md points to the skill
- [ ] #2 docs/review.md triggers: a change to tests, fixtures or baselines, or a behaviour change with no test change
- [ ] #3 Known-answer runs: a seeded tautological test and a seeded change-detector test in a builds/ copy are flagged; tests/proposals.py reviewed for real
- [ ] #4 context-reviewer PASS
<!-- AC:END -->
