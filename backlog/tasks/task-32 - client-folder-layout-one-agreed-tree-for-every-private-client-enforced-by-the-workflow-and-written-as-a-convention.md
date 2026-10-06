---
id: TASK-32
title: >-
  client-folder-layout: one agreed tree for every private/<client>/, enforced by
  the workflow and written as a convention
status: Queued
assignee: []
created_date: '2026-10-06 09:56'
labels:
  - docs workflow
dependencies: []
priority: medium
ordinal: 32000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner 2026-10-06: a client folder's root should hold mostly directories and only a few files; things that belong together live together; the portrait gets its own images/portrait/. Agreed shape (owner's idea plus two agent tweaks: candidate.json stays at the root because the workflow reads it there, and the folder is called typst/ not materialization): root files envelope.json, candidate.json, README.md; folders intake/, research/, draft/, typst/ (cv.typ on its top level; designs/, text/, art/ below), images/portrait/, reviews/, revisions/, exports/. Cost: scripts/cv.py and packages/cv-workflow hard-code cv.typ at the workspace root (workspace.py, render.py snapshot, README); the snapshot already keeps relative paths so it needs a small change, not a redesign. Old revisions keep their flat inputs/ and are not touched. private/ is git-ignored, so migrating the tour-leader client (alias client-2026-09-01) and the two marine clients is not recorded in Git: back up first, re-render after to prove the PDF is unchanged. Order: owner confirms the tree, then engine change with tests, then convention doc (docs/guides/client-workflow.md and the new-client / new-cv skills so agents know where everything goes), then migrate the three clients.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Owner confirms the tree
- [ ] #2 cv.py render, approve, export and status work with typst/cv.typ; a fixture in tests covers the nested layout and the old flat one is refused or migrated with a clear message
- [ ] #3 Convention written in docs and in the new-client and new-cv skills
- [ ] #4 The three clients migrated; a re-render of each reproduces its last delivered PDF's content
<!-- AC:END -->
