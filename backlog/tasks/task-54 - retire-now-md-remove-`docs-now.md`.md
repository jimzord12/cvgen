---
id: TASK-54
title: 'retire-now-md: remove `docs/now.md`'
status: Done
assignee: []
created_date: '2026-10-14 04:48'
updated_date: '2026-10-14 05:41'
labels:
  - restructure
dependencies: []
ordinal: 54000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Retired, but it still holds the repo's only broken link; delete it and the audit exclusion in `.claude/repo-maintenance.md`. Source: docs/work/workflow-model/handoff.md, section 4, item 22 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 docs/now.md is deleted
- [x] #2 The audit exclusion for it in .claude/repo-maintenance.md and the AGENTS.md sentence calling it retired are removed
- [x] #3 git grep for now.md finds only dated historical records
- [x] #4 tests/run.py, the Atlas check and the repo-maintenance quick audit show no failure or finding caused by the removal
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Result and evidence
Deleted docs/now.md (its last git version stays in history), the ignore entry for it in .claude/repo-maintenance.md, and the sentence in AGENTS.md calling it retired. No live pointer remained in docs/development.md, skills or .atlas/src. Atlas pages design-run, change-review, system-map and roster were stale only because AGENTS.md, docs and repo-maintenance.md changed; build, stamp (those four), build, then check: all five ok.
Left as written (dated records): backlog tasks 12 and 25, docs/work/** (docs-audit findings, handoff, test-evidence review, Trello export), docs/proposals/repo-maintenance.md (status applied) and docs/proposals/work-records.md (specification history).
Checks on the branch worktree: python tests/run.py PASS, 94 compilation cases, evidence builds/tests-20261014-083633-720134. atlas.py check clean. repo-maintenance audit --mode quick: no now.md finding (only unrelated R3 AGENTS.md line count and two N3 notes). git grep for now.md lists only the files named above.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Deleted the retired docs/now.md (git history keeps it), its audit ignore line in .claude/repo-maintenance.md and the AGENTS.md sentence pointing at it; dated records keep their mentions. Atlas pages re-stamped. Review: context-reviewer round 1 PASS (docs/work/retire-now-md/reviews/01-context-reviewer.md). Suite PASS.
<!-- SECTION:FINAL_SUMMARY:END -->
