---
id: TASK-27
title: 'backlog-migration: move the task store from Trello to Backlog.md files'
status: Active
assignee: []
created_date: '2026-10-06 07:26'
updated_date: '2026-10-06 07:26'
labels: []
dependencies: []
ordinal: 27000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner: Claude Code. Branch/worktree: `feature/backlog-migration` in `../cvgen-backlog`.
Integration target: `main`. Depends on: none.

## Outcome and boundaries
The task store moves from the Trello board "CVgen" to Backlog.md files in `backlog/` (ADR 0014). Every card is migrated verbatim, the rules, skills, agents and Atlas point to the new store, and the board is exported and closed (not deleted). Historical records are not rewritten.

Plan: `docs/work/backlog-migration/plan.md`. Plan review: `docs/work/backlog-migration/reviews/00-plan.md`.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 All 26 task cards are Backlog tasks with identical titles, statuses, descriptions and acceptance items (parity script, zero failures)
- [ ] #2 The session-handoff card is backlog/docs session-handoff with identical text
- [ ] #3 Rules, skills, agents, Codex mirrors and Atlas use Backlog.md; no live Trello instruction remains (wording check)
- [ ] #4 python tests/run.py passes and the Atlas check is clean
- [ ] #5 Independent review loop reaches PASS within the cap
- [ ] #6 Trello board exported into the repo and closed (not deleted); late changes ported
<!-- AC:END -->
