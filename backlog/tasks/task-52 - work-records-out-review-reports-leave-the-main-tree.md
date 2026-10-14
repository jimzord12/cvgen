---
id: TASK-52
title: 'work-records-out: review reports leave the main tree'
status: Active
assignee: []
created_date: '2026-10-14 04:48'
updated_date: '2026-10-14 09:15'
labels:
  - restructure
dependencies: []
ordinal: 52000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
`docs/work/*/reviews` is two thirds of all docs. Move them to an orphan `records` branch or summarize them in the task's notes. Owner decision. Source: docs/work/workflow-model/handoff.md, section 4, item 20 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started. The owner answered its open question on 2026-10-14 (docs/proposals/workflow-model.md); the decision overrides this description where they differ.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 New review reports go to the new place by task; python tests/run.py passes
- [x] #2 docs/work/ is moved to an archive folder with git history kept; every live file that `git grep docs/work` finds (rules, AGENTS.md, skills, agent definitions, .claude/repo-maintenance.md, .atlas/src) points to the new place; historical records may keep old paths
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Owner decision 2026-10-14 recorded in docs/proposals/workflow-model.md: move docs/work/ to an archive folder (archive/work-records/ suggested); new review reports go there by task; fix live links.

Done 2026-10-14. docs/work moved to archive/work-records by one git mv (history follows). New reports: archive/work-records/<task-slug>/reviews/NN-<reviewer>.md. Updated live files: AGENTS.md (new archive row), docs development/review/glossary/guides/research, open proposals P-0011/P-0014/P-0017, skills, agent and codex profiles, .claude/repo-maintenance.md (ignore and protected), docs/workflow stage.yaml paths and sources, Atlas src pages and site.json (restamped). Decisions: relative markdown links in applied or rejected proposals were repointed (path only) so they do not 404; plain-text old paths in ADRs, history.md entries, closed proposals, closed task notes and the moved reports keep docs/work, and the history entry says to read them as archive/work-records. docs/workflow/inventory (superseded) and proposals/workflow-model.md line 78 (the decision record) keep the old wording. Suite PASS 142 cases, evidence builds/tests-20261014-121454-448075.
<!-- SECTION:NOTES:END -->
