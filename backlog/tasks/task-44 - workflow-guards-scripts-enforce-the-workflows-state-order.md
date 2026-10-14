---
id: TASK-44
title: 'workflow-guards: scripts enforce the workflow''s state order'
status: Done
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 06:57'
labels:
  - workflow-model
dependencies:
  - TASK-34
ordinal: 44000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Per decisions #2 and #8: a `ready` status for the `Text Draft`; `outputs.py stamp` refuses `approved` without a receipt, `delivered` without an `Export`, and `signed-off` without the screenshot; rename Meta File kind `text-draft` (the concept) so it no longer collides with the client's `Text Draft`. Code change: `code-reviewer` round. Depends on TASK-34 only; the decisions are in docs/proposals/workflow-model.md (#2, #8). Source: docs/work/workflow-model/handoff.md, section 4, item 12 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Tests for each refusal
- [x] #2 schema updated
- [x] #3 the suite passes
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Result and evidence (2026-10-14, branch feature/task-44-workflow-guards):
- outputs.stamp refuses `approved` without the revision's cv.approval.json for these bytes and this revision, `delivered` without that receipt and a verified `Export` (private/<envelope>/reference.pdf in its home exempt), `signed-off` without draft/sign-off-NN.png. Client-draft status `ready` added; Meta File kind `text-draft` renamed `house-design` (glossary term `House Design`).
- Tests: suite case workflow-stamp-guards (tests/workflow.py), Design Review fixture updated. Mutation check of R1-01 (no revision binding) and R1-03 (reference.pdf by name only): both caught, builds/mutations-task44-20261014-094250/mutations.log in the worktree.
- Manual walk of the real CLI: builds/manual-walk-task44-20261014-092952/walk.log in the worktree.
- Review: docs/work/workflow-guards/reviews/01-code-reviewer.md (PASS, minors fixed).
- Legacy real data: 8 `delivered` revisions without receipt or export and one `signed-off` draft without its screenshot; `check` stays silent, a later re-stamp of those is refused.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
outputs.py stamp now refuses approved without a receipt for this revision and these bytes, delivered without that receipt and a verified Export, and signed-off without sign-off-NN.png beside the draft; private/<envelope>/reference.pdf (delivered before cv.py) is exempt. Text Draft gains a ready status (compile stamps ready, sent only when the owner confirms). Meta File kind text-draft renamed house-design; new glossary term House Design. Code review round 1 PASS (minors fixed: revision-binding test, exemption limited to its home), context review round 1 PASS (minors fixed). Suite PASS 105 (builds/tests-20261014-095504-186232 in the worktree); manual walk builds/manual-walk-task44-20261014-092952/walk.log. Legacy real data: 8 delivered revisions without receipt/export and one signed-off draft without screenshot stay valid but any re-stamp is refused until proof is filed.
<!-- SECTION:FINAL_SUMMARY:END -->
