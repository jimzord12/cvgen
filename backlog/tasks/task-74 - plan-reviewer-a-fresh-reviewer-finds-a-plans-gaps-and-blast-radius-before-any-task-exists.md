---
id: TASK-74
title: >-
  plan-reviewer: a fresh reviewer finds a plan's gaps and blast radius before
  any task exists
status: Active
assignee: []
created_date: '2026-11-08T09:50:00Z'
updated_date: '2026-11-08T10:16:00Z'
labels: []
milestone: m-8
dependencies:
  - TASK-73
ordinal: 74000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner: Claude Code session
Branch/worktree: feat/review-agents in .worktrees/review-agents
Integration target: main
Depends on: TASK-73
Plan: archive/work-records/review-agents/plan.md

## Outcome and boundaries
A plan skill (generic plan template and plan checklist), the plan-reviewer agent (Opus high, read-only, blind impact map first) and its gate in docs/review.md with the CVgen impact items. Excludes decomposition review and plan_check.py.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 plan skill holds the plan template and checklist; plan-reviewer.md holds only its own procedure
- [ ] #2 docs/review.md names when a plan is reviewed, the brief, and the CVgen impact items
- [ ] #3 Known-answer run on archive/work-records/backlog-migration/plan.md recorded, then a run on the review-agents plan before TASK-75 starts
- [ ] #4 context-reviewer PASS
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Calibration (AC 3, first half)

- 01 (archive/work-records/review-agents/calibration/01-...): the backlog-migration plan against the repository at 1e684eb, answer key of four procedure gaps found later. 0 of 4; three other real gaps found that five rounds of the earlier plan review missed (two confirmed by later events). Diagnosis: the map traces files, never walks a new routine.
- Change: plan skill question 12 "Procedures" and a plan-reviewer step to walk each routine (e321f3c).
- 02: about 2 of 4 (child-task Done found; stale main and live sessions partly; combined filters missed). Weak evidence: question 12 was written knowing the key. One confirmed gap from run 01 (the wrong review gate) was lost in run 02, so a single run varies: docs/review.md now asks for two independent plan-reviewers for a plan that is hard to undo.
- Still open: a held-out calibration on a plan whose later gaps the lead has not read, before AC 3 is checked; then the review of the review-agents plan itself.

## Review round 1 (context-reviewer): FINDINGS, dispositions
Report: reviews/05-context-reviewer.md (verbatim; reviews/ is shared with TASK-73, whose rounds are 01-04).
| # | Disposition |
|---|---|
| M1 | Fixed: review.md says the plan-reviewer's severities are its own; the loop, caps and storage are review.md's |
| M2 | Fixed in review.md (intro, Timing, Plan review) and development.md: before its tasks are created or, when they exist, before the first goes Active |
| M3 | Fixed now, not deferred to T5: development.md's planning paragraph says where a plan starts, when a plan file is needed, and points to "Plan review"; review.md says an approved proposal or brief is where a plan starts, not the plan |
| M4 | Fixed: question 12's situations are examples ("such as"), with the reviewer's additions (first run on empty state, a run cut off midway, another OS or shell, a missing tool); the agent walks "the situations the question names and any others the routine meets" |
| m1 | Fixed: "adopted by the lead on 2026-11-08" with the reason; contracts counted as hard to undo on purpose; the loop's "Prefer one reviewer" points to the pair |
| m2 | Fixed: question 12 trimmed from 11 to 8 lines, the rationale left to the agent file |
| N1 | Kept: the brief in the agent file is its own "what you receive" |
| N2 | As planned: T5 |
The held-out calibration started on the definition at c7389f6, before these edits.
<!-- SECTION:NOTES:END -->
