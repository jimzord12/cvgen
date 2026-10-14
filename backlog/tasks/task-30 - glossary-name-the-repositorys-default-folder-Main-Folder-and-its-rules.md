---
id: TASK-30
title: 'glossary: name the repository''s default folder (Main Folder) and its rules'
status: Active
assignee: []
created_date: '2026-10-06 09:41'
updated_date: '2026-10-14 05:45'
labels:
  - docs
dependencies: []
priority: low
ordinal: 30000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner coined the need 2026-10-06: a term for the default checkout of the repo (the `Main Folder`), as opposed to extra worktrees. Proposed term: Main Folder. Define it in docs/glossary.md with the rule that agents leave it on main (or on the owner's chosen branch) and do real work in a worktree; today it was left on an old merged branch 48 commits behind main with another session's untracked folders, which made the project look older than it is.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 docs/glossary.md defines Main Folder in the existing row style
- [x] #2 docs/git-workflow.md uses the term and states the rule: Main Folder stays on main, clean and synced; branch work in a worktree
- [x] #3 docs/development.md Session Sweep and the backlog skill use the term consistently
- [x] #4 tests/run.py passes and atlas check is clean
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Result and evidence
Term 'Main Folder' added to docs/glossary.md (row after Atlas). docs/git-workflow.md Branches now states the rule (Main Folder on main, clean and synced; branch work in a worktree; never ended a session on a feature branch). docs/development.md Session Sweep Git bullet and the backlog skill's route-to-main bullet use the term. Atlas citations shifted (git-workflow 84-97, backlog skill 1-118), rebuilt and stamped; atlas check all ok. python tests/run.py: PASS, 94 compilation cases, evidence builds/tests-20261014-083817-463259. Not Done: awaiting review and merge by the lead.

## Review
Round 1 (context-reviewer, docs/work/main-folder-term/reviews/01-context-reviewer.md): FINDINGS, 2 Material, 1 Minor, notes. Fixed: git-workflow Main Folder rule rewritten as three cases (fast-forward on main; switch an agent-left branch with no tracked changes to main and fast-forward; otherwise leave, use a worktree, name it in the Session Sweep and handoff) with the stale-checkout reason on the whole rule; glossary row keeps definition and pointer only, Added = 2026-10-14; Session Sweep points to the rule; task record lost the local path and its duplicate AC. Merged origin/main (Atlas lock conflict taken from main, rebuilt, citations git-workflow 87-100, stamped). Re-run: tests/run.py PASS (94 cases, builds/tests-20261014-084453-263210), atlas check all ok. Round 2 is the lead's.
<!-- SECTION:NOTES:END -->
