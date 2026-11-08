---
id: TASK-73
title: >-
  context-placement: four questions decide whether a rule lives in an agent
  file, a skill or a repository document
status: Queued
assignee: []
created_date: '2026-11-08T09:50:00Z'
labels: []
milestone: m-8
dependencies: []
ordinal: 73000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner: Claude Code session
Branch/worktree: feat/review-agents in .worktrees/review-agents
Integration target: main
Depends on: none
Plan: archive/work-records/review-agents/plan.md

## Outcome and boundaries
context-maintainer.md, 'Where things live', gains the four placement questions (own job -> agent file; project-specific -> owning document; the owner as a person -> preferences; generic or one activity's convention -> that activity's skill if anyone else does or checks it, else the agent file). context-reviewer checks placement against them. Excludes moving existing rules.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 The four questions, in order, are in context-maintainer.md with one home per rule and pointers elsewhere
- [ ] #2 context-reviewer's placement check names them
- [ ] #3 Every piece of the three new reviewers' content is placed by the questions with no case undecided (recorded in the task notes)
- [ ] #4 context-reviewer PASS; reports verbatim under archive/work-records/review-agents/reviews/
<!-- AC:END -->
