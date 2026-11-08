---
id: TASK-75
title: >-
  tests-reviewer: tests that test real behaviour, and no test kept for its own
  sake
status: Queued
assignee: []
created_date: '2026-11-08T09:50:00Z'
updated_date: '2026-11-08T10:54:00Z'
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
Plan: archive/work-records/review-agents/plan.md (revision 2)

## Outcome and boundaries
A test-principles skill (generic, including 'a test is removed only with a reason', D6), the tests-reviewer agent (Opus high; deliberate faults in a git-archive copy under builds/, D5), docs/engine/verification.md's suite-specific rules (frozen-reference checks never removed through D6; how one case runs), docs/conventions.md 'Tests' split into CVgen rules and a pointer, the trigger in docs/review.md (D12) and D5's exception in 'Reviewer boundaries'. tests/run.py gains case selection only if chosen (D5). Excludes rewriting existing tests.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 test-principles skill and tests-reviewer.md placed by the four questions; verification.md points to the skill
- [ ] #2 context-reviewer PASS
- [ ] #3 docs/review.md's trigger lists the D12 paths (test changes only, owner 2026-11-08); a behaviour change with no test stays with the code-reviewer's lens 5
- [ ] #4 Known-answer runs, keys committed first (D14), in a copy the lead prepares (D5): a seeded tautological test is flagged by the fault probe, a seeded change-detector test by the refactor probe; tests/proposals.py reviewed for real
- [ ] #5 docs/review.md 'Reviewer boundaries' carries D5's exception; the permission rules it needs are named for the owner
<!-- AC:END -->
