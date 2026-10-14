---
id: TASK-30
title: 'glossary: name the repository''s default folder (Main Folder) and its rules'
status: Active
assignee: []
created_date: '2026-10-06 09:41'
updated_date: '2026-10-14 05:40'
labels:
  - docs
dependencies: []
priority: low
ordinal: 30000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner coined the need 2026-10-06: a term for the default checkout of the repo, C:\Users\jimzord12\Documents\GitHub\cvgen, as opposed to extra worktrees. Proposed term: Main Folder. Define it in docs/glossary.md with the rule that agents leave it on main (or on the owner's chosen branch) and do real work in a worktree; today it was left on an old merged branch 48 commits behind main with another session's untracked folders, which made the project look older than it is.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 docs/glossary.md defines the term; docs/git-workflow.md uses it
- [x] #2 docs/glossary.md defines Main Folder in the existing row style
- [x] #3 docs/git-workflow.md uses the term and states the rule: Main Folder stays on main, clean and synced; branch work in a worktree
- [x] #4 docs/development.md Session Sweep and the backlog skill use the term consistently
- [ ] #5 tests/run.py passes and atlas check is clean
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Result and evidence
Term 'Main Folder' added to docs/glossary.md (row after Atlas). docs/git-workflow.md Branches now states the rule (Main Folder on main, clean and synced; branch work in a worktree; never ended a session on a feature branch). docs/development.md Session Sweep Git bullet and the backlog skill's route-to-main bullet use the term. Atlas citations shifted (git-workflow 84-97, backlog skill 1-118), rebuilt and stamped; atlas check all ok. python tests/run.py: PASS, 94 compilation cases, evidence builds/tests-20261014-083817-463259. Not Done: awaiting review and merge by the lead.
<!-- SECTION:NOTES:END -->
