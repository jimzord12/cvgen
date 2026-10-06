---
id: TASK-30
title: 'glossary: name the repository''s default folder (Main Folder) and its rules'
status: Queued
assignee: []
created_date: '2026-10-06 09:41'
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
- [ ] #1 docs/glossary.md defines the term; docs/git-workflow.md uses it
<!-- AC:END -->
