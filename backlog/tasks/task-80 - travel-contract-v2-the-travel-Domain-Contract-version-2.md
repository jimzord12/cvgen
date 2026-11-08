---
id: TASK-80
title: 'travel-contract-v2: the travel Domain Contract version 2'
status: Queued
assignee: []
created_date: '2026-11-08T10:07:00Z'
labels: []
milestone: m-3
dependencies: []
ordinal: 80000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner: lead (Claude Code)
Branch/worktree: feat/travel-contract-v2
Integration target: main
Depends on: TASK-2; drives TASK-68

## Outcome and boundaries
Agents' choice (Major, owner 2026-11-08: "think of something the domain might need"): version 2 changes the `destinations` Fact Group to schema 2, where each trip says whether the person led a group, organised the trip or travelled (recruiters weigh led groups; a self-organised trip must not read as leading), and adds an optional `licences` group (an official tour-leader or guide licence: title, issuer, region, valid until). Version 1 stays kept. A Coverage Fixture for v2 marks every new field.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 contracts/v2.json and its Coverage Fixture exist; v1 is still kept and its fixture still passes
- [ ] #2 The Hanami showcase (up to v1) and essential (v2) Variations prove their claims on their fixtures
<!-- AC:END -->
