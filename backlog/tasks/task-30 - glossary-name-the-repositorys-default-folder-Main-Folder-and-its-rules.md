---
id: TASK-30
title: >-
  main-folder-term: name the repository's default folder (Main Folder) and its
  rules
status: Active
assignee: []
created_date: '2026-10-06 09:41'
updated_date: '2026-10-14 05:49'
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
The `Main Folder` is defined in `docs/glossary.md` (row after `Atlas`). `docs/git-workflow.md` "Branches" states its rule: keep it on `main` (or the owner's chosen branch), clean and synced, do branch work in a worktree, and handle a stale one in three cases (fast-forward on `main`; switch an agent-left branch with no tracked changes to `main` and fast-forward; otherwise leave it, use a worktree and name it in the `Session Sweep` and handoff). The `Session Sweep` Git bullet in `docs/development.md` points to the rule, and the backlog skill's route-to-`main` bullet uses the term. Atlas citations into `git-workflow.md`, `development.md` and the backlog skill were shifted and verified in `site.json` and `change-review.json`, then rebuilt and stamped. Final run: `python tests/run.py` PASS (94 cases, `builds/tests-20261014-084935-049380`), `atlas.py check --strict` clean. Not Done: the lead merges.

## Review
Round 1 (`docs/work/main-folder-term/reviews/01-context-reviewer.md`): FINDINGS (2 Material, 1 Minor); fixed the contradictory recovery steps, the duplicated rule in the glossary and Sweep, the reason placement, the Added column and the task record.
Round 2 (`.../02-context-reviewer.md`): FINDINGS (1 Material, 4 Minor); fixed the six stale Atlas ranges in `change-review.json` plus a wording slip, the overlapping cases (case 1 "with no tracked changes"), a merged branch counting as agent-left, leaving untracked files that are not the session's, the task title prefix `main-folder-term:`, and these notes.
<!-- SECTION:NOTES:END -->
