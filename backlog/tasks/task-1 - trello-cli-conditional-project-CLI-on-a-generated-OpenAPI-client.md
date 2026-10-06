---
id: TASK-1
title: 'trello-cli (conditional): project CLI on a generated OpenAPI client'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
updated_date: '2026-10-06 07:26'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/1BB8s9M0'
ordinal: 1000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# trello-cli: build a project Trello CLI on a generated client (conditional)

Owner: unassigned. Requested by the owner on 2026-09-16 at adoption time.
Integration target: `main`. Depends on: real use of the trello skill.

## This card is a reminder, not authorised work
Do not start it on its own. Pick it up when one of these triggers is observed and recorded on this card:
- an agent needed three or more raw `trello.ps1` calls for one routine board operation (orientation, card create with checklist, stage move with evidence link), or
- the recipes file grew past roughly 100 lines, or
- a second repository wants the same integration, or
- a Trello API change broke the helper.
When a trigger fires, move to Active only after the owner confirms.

## Outcome
A small project CLI that exposes only the operations this workflow uses (orient, card create/update/move, checklist, blocked, export), built on a TypeScript client generated from Trello's OpenAPI description (Hey API is the candidate generator, not a decision). The skill keeps owning agent guidance; the CLI owns useful project operations; the generated client owns auth, request construction and API failures. Workflow policy stays out of generated code. Generated types do not replace runtime validation.

## Acceptance (to refine when picked up)
- One command per routine operation; a fresh agent completes orientation and a card update from SKILL.md alone.
- Credentials handled at least as safely as trello.ps1 (header auth, no diagnostics leak; see docs/work/trello-trial/reviews/).
- Generated client checked in or reproducibly generated; Trello OpenAPI source and generator version recorded.

## Links
- Progression and rationale: https://github.com/jimzord12/marine-engineer-cv/blob/main/docs/proposals/trello-free-trial.md (section "Owner amendment: skill and direct API")
- Current helper: https://github.com/jimzord12/marine-engineer-cv/blob/main/.claude/skills/trello/trello.ps1
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Cancelled
2026-10-06. The task store moved to Backlog.md (task backlog-migration, ADR 0014), so a project CLI for Trello is no longer needed. Decided by Claude Code on the owner's behalf in the approved migration plan; nothing was kept.
<!-- SECTION:NOTES:END -->
