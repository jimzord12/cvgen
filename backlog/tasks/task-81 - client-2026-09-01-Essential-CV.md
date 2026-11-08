---
id: TASK-81
title: 'client-2026-09-01: Essential CV'
status: Queued
assignee: []
created_date: '2026-11-08T10:07:00Z'
labels: []
milestone: m-3
dependencies: []
ordinal: 81000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner: lead (Claude Code); the owner approves the PDF
Branch/worktree: private repository; engine changes on their own branches
Integration target: private main
Depends on: TASK-79, TASK-80, TASK-68

## Outcome and boundaries
The first travel Client asked for a practical one-page CV. His record moves onto the travel Domain Contract (version 2), his envelope.json names the Hanami Template and the essential Variation, and scripts/cv.py render makes a Revision through the contract checks. Facts come only from his signed-off text; nothing is added. Approval is the owner's act.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 A Revision renders through choose() with no refusal and a Meta File naming hanami, essential and contract version 2
- [ ] #2 The owner has the PDF to approve
<!-- AC:END -->
