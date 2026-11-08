---
id: TASK-78
title: >-
  review-agents-welcome: the rest of the repository knows the three new
  reviewers and the two skills
status: Queued
assignee: []
created_date: '2026-11-08T09:51:00Z'
labels: []
milestone: m-8
dependencies:
  - TASK-77
ordinal: 78000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner: Claude Code session
Branch/worktree: feat/review-agents in .worktrees/review-agents
Integration target: main
Depends on: TASK-77
Plan: archive/work-records/review-agents/plan.md

## Outcome and boundaries
development.md (roles, planning paragraph, file map, plan and decomposition PASS before planned work goes Active), glossary terms the text keeps using, the backlog skill pointer, .codex counterparts for the three reviewers and the README table, the Atlas roster and change-review flow, the Workflow Model's design.engine-review step, and the session handoff (drop the three-agent pitfall). Excludes the work-board mod.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Every file in the plan's 'Changed' table updated or recorded as needing no change
- [ ] #2 atlas.py check, bun run check, bun test, suite and ruff pass
- [ ] #3 context-reviewer PASS; code-reviewer PASS for the Workflow Model change
<!-- AC:END -->
