---
id: TASK-32
title: >-
  client-folder-layout: one agreed tree for every private/<client>/, enforced by
  the workflow and written as a convention
status: Done
assignee: []
created_date: '2026-10-06 09:56'
updated_date: '2026-10-14 08:20'
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
- [x] #1 Owner confirms the tree
- [x] #2 cv.py render, approve, export and status work with typst/cv.typ; a fixture in tests covers the nested layout and the old flat one is refused or migrated with a clear message
- [x] #3 Convention written in docs and in the new-client and new-cv skills
- [x] #4 The three clients migrated; a re-render of each reproduces its last delivered PDF's content
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Owner confirmed the tree on 2026-10-06. Decision 9 (2026-10-14): drop reviews/text-NN.md from the Envelope layout.

## Note from TASK-56 (2026-10-14)

The two private marine compositions import 12 deprecated flat component names through marine's lib.typ (document-shell, page-header, hero, section-heading, synopsis, experience-section, education-languages-section, label, metric, profile-summary, education-entry, skills-section). This task's migration re-points them (re-pointing authorized by the owner, 2026-10-14) to ctx-first calls (make-ctx, core-components, flagship-components) with the mapping table in docs/guides/build-a-cv.md section 8, and its re-render proves each PDF unchanged. That unblocks TASK-58, which deletes the legacy layer.

Proof coverage (AC #4, 2026-10-14): each migrated Envelope was compiled from a staged copy (portrait repointed as cv.py render does) and compared at 150 dpi, before and after the move. client-2026-09-03 and client-2026-09-02: their delivered reference.pdf (2 pages each, 0 differing; re-proved after the switch to relative portrait paths, private 695beb8). client-2026-09-01: its 8 delivered revisions of 2026-10-02 (6 Hanami, 2 Stamp Rally, each with its own compiler inputs; 16 pages, 0 differing). Its two 2026-09-29 revisions were not part of the proof: they no longer reproduce from the sources, a drift that predates the move (their recorded cv.typ and record hashes already differ at private 3c2fe4b; code review round 1, N1).
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Client Envelopes share one tree (docs/guides/client-workflow.md section 1): root envelope.json, candidate.json, README.md; intake/, research/, draft/, typst/ (cv.typ, designs/, text/, art/), images/portrait/, reviews/, revisions/, exports/. cv.py render/approve/export/status use typst/cv.typ and refuse a flat workspace with the full migration steps; snapshots mirror the layout under inputs/. Three clients migrated in the private repo (aliases client-2026-09-01, -02, -03), each re-render page-identical to its last delivered PDF (the 2026-10-02 revisions for client-2026-09-01); the two marine compositions re-pointed from 12 deprecated names to ctx-first calls; marine portraits now relative. Code review round 1 PASS, context reviews FINDINGS then PASS. Suite PASS (builds/tests-20261014-111551-794638 in the worktree); outputs check --private 0 problems.
<!-- SECTION:FINAL_SUMMARY:END -->
