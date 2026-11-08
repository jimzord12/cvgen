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

## AC #3 deferred
The audit task (D17) is drafted but not queued: on 2026-11-08 the Main Folder's main was 33 commits ahead of origin/main (another session's unpushed merge of feat/travel-contract-v2, 81c9529), so the backlog skill's route to main was closed. Queue it, title 'suite-audit: every test in today's suite tests real behaviour, and none is kept for its own sake', in m-7 with --dep TASK-75, once that session has pushed or at this branch's merge.

### Draft description
Owner: Claude Code session
Branch/worktree: feat/suite-audit in .worktrees/suite-audit
Integration target: main
Depends on: TASK-75 (the tests-reviewer and the test-principles skill must be on main)
Plan: none yet; the first step decides whether the findings need one (the plan skill, "When a plan is needed")

## Outcome and boundaries
One audit of today's suite (owner, 2026-11-08: "Queue one audit"): every check in `tests/` and every Bun test in `tools/workflow/test/` judged by a fresh tests-reviewer against the test-principles skill, with probes as docs/engine/verification.md "Probing a test" says, and each finding acted on: tests that cannot fail or only detect change are fixed through their entry point or removed with a stated reason, and missing tests for likely faults are added. No test is added to raise a count.

Excludes: the frozen set (each template's tests/approved/ and tests/baseline.json's pins; judged only on whether they pin the right files); changing product behaviour; checks whose rule is about structure (check 10, check 13) are judged on whether they pin their rule, not refactor-probed.

## Known items (from TASK-75's calibration runs)
- tools/workflow anchors: a shift that ignores a hunk's removed lines passes every Bun test (calibration 05, P5, confirmed by the lead); several hunks above one anchor are also untested.
- tests/proposals.py: a malformed id (P-00012) is accepted unnoticed (T1); a missing revision (T2); next_id when the highest id is a reference (T3); two bad files named (T4). calibration 06.

## Shape
The suite is large (20 checks, 211 cases, 8 Bun files): split the audit into rounds by area (Framework and fixtures; workflow and output contract; scripts' own tests; the Bun tests), one tests-reviewer per area, run one suite at a time.
<!-- SECTION:NOTES:END -->
