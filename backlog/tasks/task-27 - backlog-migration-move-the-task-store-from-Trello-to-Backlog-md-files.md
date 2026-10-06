---
id: TASK-27
title: 'backlog-migration: move the task store from Trello to Backlog.md files'
status: Active
assignee: []
created_date: '2026-10-06 07:26'
updated_date: '2026-10-06 07:43'
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

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Result and evidence
- Trello snapshot read at 2026-10-06T07:24:16.1336849Z (UTC): 27 open cards (Handoff 1, Queued 4, Review 1, Done 21). The step 7 late-change check lists cards whose dateLastActivity is later than this time.
- Migration parity right after the import (author script, then an independent exact, case-sensitive comparison by the round 1 data reviewer): 26 tasks match title, status, description, acceptance text, state and order; the handoff doc body was byte-identical; 0 failures. Deliberate later deltas: trello-cli cancelled (Done), the handoff intro reworded from cards to tasks.
- The step 7 export must include closed cards, actions (comments) and attachments: it is the only copy of card comments.
- Suite: python tests/run.py PASS (builds/tests-20261006-103428-926766 in the worktree); atlas check all ok; outputs check 0 problems.
<!-- SECTION:NOTES:END -->
