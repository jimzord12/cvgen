---
id: TASK-29
title: >-
  remove-night-shift: delete the retired .night-shift folder, its two skills and
  every mention
status: Queued
assignee: []
created_date: '2026-10-06 09:41'
labels:
  - docs cleanup
dependencies: []
priority: low
ordinal: 29000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner asked 2026-10-06 to delete .night-shift. It holds three tracked history files (2026-09-27/28) plus ignored local nights/ and input.json (about 2 MB). Also remove the skills .claude/skills/start-night-shift and do-night-shift-follow-up, and every reference: .gitignore, .claude/settings.json, .claude/repo-maintenance.md, .codex/README.md, docs/development.md (the Night Shift lines), docs/review.md (history commits line), docs/glossary.md, docs/proposals/certificate-validity-check.md, and the Atlas pages that cite it (rebuild and stamp the Atlas). Leave old task records untouched except where they would now link to a missing path.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 No .night-shift folder and no night-shift skill remain; git grep -i 'night-shift' finds only historical task records and decision logs
- [ ] #2 python tests/run.py and the Atlas check pass
<!-- AC:END -->
