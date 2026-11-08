---
id: TASK-78
title: >-
  review-agents-welcome: the rest of the repository knows the three new
  reviewers and the two skills
status: Queued
assignee: []
created_date: '2026-11-08T09:51:00Z'
updated_date: '2026-11-08T11:08:00Z'
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
The rest of the repository knows the new reviewers and skills, as the plan's D9, D10, D13, D15 and D18 and its T5 rows say. Starts when TASK-77 is Ready, after merging main and regenerating. Excludes the work-board mod.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Every file the plan's tables assign to T5 made, changed or recorded as needing no change
- [ ] #2 bun run anchors per parent head, check, render, atlas, bun test, atlas.py check clean, suite and ruff pass
- [ ] #3 context-reviewer PASS; code-reviewer PASS for the Workflow Model change
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Scope after plan revision 2
Starts after feat/template-contract, feat/contract-stage-2 and feat/travel-domain have merged into main: merge main, then regenerate the generated files, never hand-merge them. Adds ADR 0018 and the history entry (D15), the transition rule (D13) in development.md and the handoff, the Workflow Model change sized by P3 (actor, step, agent action, report artifact, gate, loop), the four stale Atlas pages re-checked and stamped, new-cv and new-theme gate lines, .codex README and code-reviewer.toml (D9, D10), repo-maintenance.md:150.

## Revision 4 supersedes the note above
The 'Scope after plan revision 2' note is superseded by the plan (revision 4): no fixed branch list, the smaller Workflow Model change (D18), no code-reviewer.toml edit (D10). The plan is the one source; this task only points to it.
<!-- SECTION:NOTES:END -->
