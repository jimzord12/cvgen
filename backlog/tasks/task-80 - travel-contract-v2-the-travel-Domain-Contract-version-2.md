---
id: TASK-80
title: 'travel-contract-v2: the travel Domain Contract version 2'
status: Active
assignee: []
created_date: '2026-11-08T10:07:00Z'
updated_date: '2026-11-08T10:37:00Z'
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

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Merge feat/contract-stage-2 (TASK-68), resolve, suite green.
2. contracts/v2.json: destinations@2 (each trip's required role: led, organised, travelled), new optional licences@1 (title, issuer, region, until).
3. Schema and data.typ accept both shapes by domainContract; licences read by the Certificate Warning check.
4. Coverage Fixture coverage-v2 with markers.
5. Hanami showcase renders v2 (upTo 2; destinations@1, @2, licences@1): the role as a label on each trip card, the licence beside studies; twin to v2; regenerate the Frozen Reference candidate.
6. Suite cases: v1 record on v2, v2 record on an upTo-1 Variation with and without destinations, licences dropped with a warning.
7. Docs, anchors, render, atlas, build; suite and ruff.
<!-- SECTION:PLAN:END -->
