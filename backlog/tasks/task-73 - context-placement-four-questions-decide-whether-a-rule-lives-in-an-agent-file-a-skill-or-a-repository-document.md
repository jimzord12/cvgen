---
id: TASK-73
title: >-
  context-placement: four questions decide whether a rule lives in an agent
  file, a skill or a repository document
status: Active
assignee: []
created_date: '2026-11-08T09:50:00Z'
updated_date: '2026-11-08T09:52:00Z'
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
- [x] #1 The four questions, in order, are in context-maintainer.md with one home per rule and pointers elsewhere
- [x] #2 context-reviewer's placement check names them
- [x] #3 Every piece of the three new reviewers' content is placed by the questions with no case undecided (recorded in the task notes)
- [ ] #4 context-reviewer PASS; reports verbatim under archive/work-records/review-agents/reviews/
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Placement of the review-agents content (AC 3)

| Content | Question | Home |
|---|---|---|
| plan-reviewer's blind impact map, report shape, limits | 1 own job | plan-reviewer.md |
| deliberate-fault procedure in a builds/ copy | 1 own job | tests-reviewer.md |
| decomposition-reviewer's order (after plan_check.py), report, limits | 1 own job | decomposition-reviewer.md |
| when each gate runs, briefs, round caps, report storage | 2 CVgen | docs/review.md |
| CVgen impact items (frozen references, baseline.json, Release PDFs, real records, Atlas, Workflow Model) | 2 CVgen | docs/review.md |
| task template, where task changes go | 2 CVgen | docs/development.md (exists) |
| what this suite's checks must do (pixel match, hashes, evidence folders) | 2 CVgen | docs/engine/verification.md |
| plan template, plan checklist, decomposition checklist | 4 generic, planner and reviewers | plan skill |
| test principles, including "a test is removed only with a reason" (whoever removes a test, not only the reviewer) | 4 generic, writer and reviewer | test-principles skill |
| decomposition rules with an exact answer (fields, deps, cycles, milestone ids) | 4 exact answer | scripts/plan_check.py, rules named in the plan skill |
| Opus at high for reviewers | 1 (frontmatter), owner's standing choice | each agent file |

No case undecided. One moved from the plan: "removal needs a reason" was the tests-reviewer's (D6); question 4 puts it in the test-principles skill, because the lead removes tests too.
<!-- SECTION:NOTES:END -->
