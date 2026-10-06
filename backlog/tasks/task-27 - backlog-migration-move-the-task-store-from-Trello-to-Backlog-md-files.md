---
id: TASK-27
title: 'backlog-migration: move the task store from Trello to Backlog.md files'
status: Done
assignee: []
created_date: '2026-10-06 07:26'
updated_date: '2026-10-06 08:00'
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
- [x] #1 All 26 task cards are Backlog tasks with identical titles, statuses, descriptions and acceptance items (parity script, zero failures)
- [x] #2 The session-handoff card is backlog/docs session-handoff with identical text
- [x] #3 Rules, skills, agents, Codex mirrors and Atlas use Backlog.md; no live Trello instruction remains (wording check)
- [x] #4 python tests/run.py passes and the Atlas check is clean
- [x] #5 Independent review loop reaches PASS within the cap
- [x] #6 Trello board exported into the repo and closed (not deleted); late changes ported
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Result and evidence
- Trello snapshot read at 2026-10-06T07:24:16.1336849Z (UTC): 27 open cards (Handoff 1, Queued 4, Review 1, Done 21). The step 7 late-change check lists cards whose dateLastActivity is later than this time.
- Migration parity right after the import (author script, then an independent exact, case-sensitive comparison by the round 1 data reviewer): 26 tasks match title, status, description, acceptance text, state and order; the handoff doc body was byte-identical; 0 failures. Deliberate later deltas: trello-cli cancelled (Done), the handoff intro reworded from cards to tasks.
- The step 7 export must include closed cards, actions (comments) and attachments: it is the only copy of card comments.
- Suite: python tests/run.py PASS (builds/tests-20261006-103428-926766 in the worktree); atlas check all ok; outputs check 0 problems.

## Review
Plan: 5 rounds (00-plan.md). Implementation: round 1 context-reviewer FINDINGS (1 Material) plus data-migration code-reviewer PASS; rounds 2 to 5 PASS. Reports and dispositions in docs/work/backlog-migration/reviews/.

## Freeze
No card changed after the snapshot. Full export (29 cards, 201 actions) in docs/work/backlog-migration/trello-export-2026-10-06.json, one real client folder name redacted. 11 card comments ported as task comments, one dependency (TASK-18 on TASK-14). Board closed 2026-10-06 (GET after PUT: closed=True), not deleted. Merged to main as 968c3f8; CI green: https://github.com/jimzord12/cvgen/actions/runs/37433119964
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
The task store moved from the Trello board to Backlog.md files in backlog/ (ADR 0014). 26 cards and the handoff migrated verbatim, comments ported, rules, skills, agents, Codex mirrors and Atlas switched, board exported and closed. Merged in 968c3f8, CI green.
<!-- SECTION:FINAL_SUMMARY:END -->
