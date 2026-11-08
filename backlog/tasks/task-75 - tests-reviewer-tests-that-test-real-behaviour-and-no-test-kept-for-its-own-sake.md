---
id: TASK-75
title: >-
  tests-reviewer: tests that test real behaviour, and no test kept for its own
  sake
status: Ready
assignee: []
created_date: '2026-11-08T09:50:00Z'
updated_date: '2026-11-08T15:00:00Z'
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
The tests-reviewer, the test-principles skill and the tests gate, as the plan's D5, D6, D12 and D19 say; queue the audit task (D17) when Ready. Excludes rewriting existing tests (the audit does that).
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Every file the plan's tables assign to T2 made or changed as D5, D6, D12 and D19 say
- [x] #2 Known-answer runs with keys committed first (D14), as the plan's TASK-75 evidence row says
- [ ] #3 The audit task (D17) queued in m-7 on main
- [x] #4 context-reviewer PASS
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Probe copy for calibration run K: C:\Github\cvgen\.worktrees\probe-20261108-163112 (detached at 56bc339, locked: session f1e864b5, TASK-75 calibration K). Anchor base for this task: 8306aae.

Probe copy K removed. Probe copy for calibration run R: C:\Github\cvgen\.worktrees\probe-20261108-164120 (detached at 0bdfc98, locked).

Probe copy R removed.

## Result and evidence
- Built: .claude/agents/tests-reviewer.md, .claude/skills/test-principles/SKILL.md; docs/review.md "Tests review" and the boundary; docs/engine/verification.md "Probing a test"; conventions.md, git-workflow.md, AGENTS.md (800 words), glossary Probe and Probe Copy.
- Known-answer run K: key first (calibration/05-tests-reviewer-answer-key.md, 3a0e309), run 05-tests-reviewer-K.md: 3 of 3, no false positive; the masked-and-re-baselined path and a Bun refactor probe both worked.
- Real run R on tests/proposals.py (06-tests-reviewer-R-proposals.md): 5 faults caught, 4 survived, which became missing tests T1-T4 for the audit.
- Context review: round 1 FINDINGS (reviews/13), round 2 PASS (reviews/14).
- Suite PASS (211 cases, builds/tests-20261108-165914-246054); ruff clean; anchors since 8306aae re-fixed by hand (0f85179) and clean since; atlas.py check: client-journey ok, four pages STALE until TASK-78 (recorded exception).
- Both probe copies removed.
<!-- SECTION:NOTES:END -->
