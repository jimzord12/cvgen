---
id: TASK-78
title: >-
  review-agents-welcome: the rest of the repository knows the three new
  reviewers and the two skills
status: Queued
assignee: []
created_date: '2026-11-08T09:51:00Z'
updated_date: '2026-11-08T10:54:00Z'
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
- [ ] #1 atlas.py check, bun run check, bun test, suite and ruff pass
- [ ] #2 context-reviewer PASS; code-reviewer PASS for the Workflow Model change
- [ ] #3 Every file in the plan's 'New' and 'Changed' tables (revision 3) made, updated or recorded as needing no change
- [ ] #4 Started only when no other branch in flight changes the Workflow Model or the Atlas (checked with git diff over git branch), after merging main and regenerating, never hand-merging, the generated files
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Scope after plan revision 2
Starts after feat/template-contract, feat/contract-stage-2 and feat/travel-domain have merged into main: merge main, then regenerate the generated files, never hand-merge them. Adds ADR 0018 and the history entry (D15), the transition rule (D13) in development.md and the handoff, the Workflow Model change sized by P3 (actor, step, agent action, report artifact, gate, loop), the four stale Atlas pages re-checked and stamped, new-cv and new-theme gate lines, .codex README and code-reviewer.toml (D9, D10), repo-maintenance.md:150.
<!-- SECTION:NOTES:END -->
