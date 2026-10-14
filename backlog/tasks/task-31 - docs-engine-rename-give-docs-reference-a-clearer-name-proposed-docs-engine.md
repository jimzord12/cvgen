---
id: TASK-31
title: 'docs-engine-rename: give docs/reference a clearer name (proposed: docs/engine)'
status: Done
assignee: []
created_date: '2026-10-06 09:56'
updated_date: '2026-10-14 08:00'
labels:
  - docs cleanup
dependencies: []
priority: low
ordinal: 31000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner 2026-10-06: docs/reference only holds the engine manuals (candidate schema, theme, artwork pack, domains and roles, layout and pagination, skills component, verification), so 'reference' says too little. Proposed name docs/engine (docs/guides stays for step-by-step workflows). Mechanical but wide: about 84 mentions in 51 files. Update live docs, skills, agents, code comments and the Atlas; leave old task records (docs/work) as written, they are history. Owner can veto the name before the task starts.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 docs/reference no longer exists; every live link points to the new folder
- [ ] #2 git grep 'docs/reference' finds only historical task records and decision logs
- [ ] #3 tests/run.py and the Atlas check pass
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Owner decision 2026-10-14 recorded in docs/proposals/workflow-model.md: the new name is docs/engine.

Renamed on branch docs/task-31-docs-engine (git mv, 22 live files updated). Remaining docs/reference mentions are dated records only. Suite and Atlas strict check pass.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
docs/reference renamed to docs/engine with git mv (7 files, history kept); every live mention updated (AGENTS.md, docs, skills, agents, scripts, tests, packages, Atlas); dated records, Done tasks, applied proposals and the owner's decision record left as written. Glossary engine row names docs/engine/; review scope wording now 'guides and engine manuals'. Context review round 1 PASS (minor fixed). Suite PASS 145 (builds/tests-20261014-105517-876753 in the worktree); Atlas check --strict 0.
<!-- SECTION:FINAL_SUMMARY:END -->
