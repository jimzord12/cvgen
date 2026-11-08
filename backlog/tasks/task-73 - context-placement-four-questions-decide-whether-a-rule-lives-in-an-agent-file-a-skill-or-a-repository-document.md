---
id: TASK-73
title: >-
  context-placement: four questions decide whether a rule lives in an agent
  file, a skill or a repository document
status: Review
assignee: []
created_date: '2026-11-08T09:50:00Z'
updated_date: '2026-11-08T10:02:00Z'
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
- [x] #4 context-reviewer PASS; reports verbatim under archive/work-records/review-agents/reviews/
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

## Review round 1 (context-reviewer): FINDINGS, dispositions

Report: archive/work-records/review-agents/reviews/01-context-reviewer.md (verbatim).

| # | Severity | Disposition |
|---|---|---|
| 1 | Material | Fixed: question 1 now excludes anything another agent that does or checks the same work also needs; the trailing paragraph shrank to the example |
| 2 | Material | Fixed: docs/conventions.md, "Documents", points to the four questions (AGENTS.md is at 797 of 800 words, so not there) |
| 3 | Minor | Fixed: "points to it, restating at most its essentials" |
| 4 | Minor | Fixed: the skills row keeps CVgen workflows; question 2 names "the repository document or CVgen skill" |
| 5 | Minor | Fixed: "Does more than one agent do or check that activity, the lead included?" |
| 6 | Minor | Fixed: re-wrapped |
| 7 | Note | Taken: "the more of an agent file or skill comes from question 4, the more of it can be reused" |
| 8 | Note | The plan is revised in place until its plan review (D2), so its question 3 now says .local/preferences/ |
| 9 | Note | Fixed: the plan's status line |
| 10 | Note | Recorded: "Opus at high" sits in each agent file only because model and effort are set in its header; the choice itself is the owner's standing preference (question 3), restated there as a setting |

Found while fixing: docs/conventions.md "Tests" already holds test rules; added to the plan's Changed table for TASK-75.

## Review round 2 (context-reviewer): PASS

Report: archive/work-records/review-agents/reviews/02-context-reviewer.md (verbatim). Dispositions:
- Minor 1 (line wrap): fixed, mechanical formatting.
- Note 2 (where question 2 ends and question 4 begins, for a naming choice like `*.spec.*`): not decided by the lead. Whether the owner's own cross-project conventions are repository choices (question 2), owner preferences (question 3) or an activity's skill (question 4) is his call; raised with him, open.
- Note 3: the plan's D1 now points to context-maintainer.md and summarises, no second copy of the questions.
- Note 4: the round 1 fixes also moved D6 ("a test is removed only with a reason") from the tests-reviewer to the test-principles skill in the plan (plan.md D6).

## Owner decision, 2026-11-08 (round 2, Note 2)
The owner's own conventions that he holds across projects go in the activity's skill (question 4), not in preferences or a repository document: 'The skill'. The `*.spec.*` example was fictional; it is not his convention and is not a rule. Questions 2 and 3 narrowed so such a convention reaches question 4. Back to Review for round 3.

## Review round 3 (context-reviewer): FINDINGS, dispositions
Report: reviews/03-context-reviewer.md (verbatim).
- Material 1: fixed; context-maintainer.md's table row and context-reviewer.md's placement check now say private preferences and personal detail, and that his conventions for an activity are placed by question 4. The hard rule ('Personal detail about the owner belongs in .local/') left as is: it means private detail.
- Minor 2: fixed; the plan's D1 summary says 'working with the owner'.
- Note 3: fixed; the description says 'working with the owner'.
- Note 4: no change, as the reviewer advised (question 3 comes first in order).
<!-- SECTION:NOTES:END -->
