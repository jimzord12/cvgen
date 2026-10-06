---
id: TASK-28
title: >-
  proposals-snapshot: stable IDs, a status index and a session-start summary for
  docs/proposals
status: Queued
assignee: []
created_date: '2026-10-06 09:41'
labels:
  - docs process
dependencies: []
priority: medium
ordinal: 28000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner asked 2026-10-06. Proposals are agent-written improvement ideas; they are hard to scan (15 files, flat, three with missing or odd status metadata). Give each a stable ID in its opening metadata block (id: P-0001), normalise status to the README's states (pending, trial, approved, applied, rejected, deferred), and add scripts/proposals.py that reads docs/proposals/ and prints or writes a JSON snapshot (id, title, status, revision, age in days, path). A new session runs it and tells the owner one line: 'N proposals: X pending (Y older than 7 days), Z approved-not-applied, ...'. Agent recommendation: keep status in the file's metadata as the single truth and let the generated snapshot give the by-status view; do not move files into per-status folders (a move breaks incoming links and the README's current rule says only rejected moves).
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Every file in docs/proposals/ has id and a valid status in its opening metadata block (kanban-tooling-research, review-protocol and work-records fixed or marked kind: reference)
- [ ] #2 scripts/proposals.py prints the one-line session summary and writes the JSON snapshot to a git-ignored path
- [ ] #3 AGENTS.md orientation step and docs/proposals/README.md point to the script; a test covers it on a fixture folder
<!-- AC:END -->
