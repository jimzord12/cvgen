---
id: TASK-80
title: 'travel-contract-v2: the travel Domain Contract version 2'
status: Active
assignee: []
created_date: '2026-11-08T10:07:00Z'
updated_date: '2026-11-08T11:19:00Z'
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
- [x] #1 contracts/v2.json and its Coverage Fixture exist; v1 is still kept and its fixture still passes
- [x] #2 Hanami showcase (up to v2: destinations@1, destinations@2, licences@1) proves its claims on the v1 and v2 fixtures; what essential must claim for v2 is recorded in the notes
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

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Result and evidence (2026-11-08)
- Merged feat/contract-stage-2, then main (Stage 2, addc8dd/379e425); conflicts resolved by hand, Atlas regenerated and stamped.
- contracts/v2.json: destinations required, schemaVersion 2, paths destinations + destinations.trips.*.role (Trip Role: led | organised | travelled, required on every trip); licences new optional @1 (title, issuer required; region, until '14 Jul 2029' optional). v1.json kept; no oldestSupported.
- Schema and data.typ read both shapes by domainContract; a role or licence on v1 is refused; v2 without destinations or a role is refused. Licences feed the Certificate Warning (warning, never a failure).
- Hanami showcase upTo 2, claims destinations@1, destinations@2, licences@1: role label beside a trip's length (led in the accent), licence on one line above the studies. The twin moved to v2 (both trips organised, a fictional licence); a v1 twin renders pixel-identical to the previous candidate. Frozen Reference candidate regenerated (not yet approved by the owner).
- Fixture coverage-v2.json + markers; cv.py contracts: hanami showcase renders 1 to 2, 8 of 9 optional groups at v2.
- Suite: builds/tests-20261108-124856-609053 (25 passed, 232 compilations); ruff clean; build builds/library-20261108-124849-274.
- essential, if it renders v2: claims destinations@2 (and destinations@1 to read v1 records); licences@1 optional (else dropped with a warning). Up to v1 only, every v2 record is refused.
- To do when feat/travel-domain round 1 lands (v1 destinations required): merge; the calm refusal text becomes 'destinations changed (schemaVersion 1 to 2)' (no 'became required'), and the calm describe line changes the same way.

## Round 2 (2026-11-08): merged feat/travel-domain (TASK-2 round 1) and split travel-story
- destinations is required in v1 and stays required at schemaVersion 2; at v2 it holds region, trips (period, days, kind, role, stops) and areas. New optional travel-story@1: destinations.native, .route, .seal, trips.*.stamp, trips.*.story (lead's decision). v1.json unchanged.
- Hanami showcase claims destinations@1, destinations@2, travel-story@1, licences@1 (+ its other optional groups); cv.py contracts: 9 of 10 optional groups at v2.
- v2 Coverage Fixture rebuilt from TASK-2's unique-marker v1 fixture; markers split between destinations and travel-story.
- Twin: TASK-2's new facts plus domainContract 2, both trips organised, the fictional licence; Frozen Reference candidate regenerated (not approved).
- essential should claim (upTo 2): its v1 optional groups, destinations@1, destinations@2, licences@1 if it shows a licence; not travel-story@1 (dropped with a warning).
- Anchors: glossary citations checked by hand against their terms after the two merges (the anchors tool double-counts a row both branches added); render.py spans updated to 102-213 and 192-209.
- Suite builds/tests-20261108-125912-962608 (25 passed, 238 compilations); ruff clean; build builds/library-20261108-130031-831.

## Round 3 (2026-11-08): merged feat/travel-domain 54cbd2c (TASK-2 round 2)
- v2 Coverage Fixture rebuilt from the new v1 fixture; markers follow the no-marker-inside-another rule (new trips Qxspringtrip/Qxwintertrip, kinds Qxsolojourney/Qxfamilyjourney, stops Qxhillstop/Qxlakestop, licence region Qxvalidzone; route markers ZQA/ZQB under travel-story).
- Twin: TASK-2's new facts plus domainContract 2, both trips organised, the fictional licence. Page 2 had no slack left, so with a licence the gap under the studies heading shrinks from 4.4 to 2.6 mm and the licence line's gap below from 2.8 to 1.6 mm (a licence beside availability on page 1 was tried and ran into the fixed petal layer). Frozen Reference candidate regenerated, not yet approved.
- Glossary citations in the Workflow Model checked by hand against their terms; anchors main still reports false MOVED lines for rows both branches shifted; never --fix them.
- First suite run failed on a transient jsonschema/attrs import error in the shared .venv (outputs.py stamp); the rerun passed.
- Suite builds/tests-20261108-130825-559180 (25 passed, 242 compilations); ruff clean; build builds/library-20261108-130917-160.

## Round 4 (2026-11-08): design round 2 (D14-D16) and code review round 1 (m1, m2, n1, n2)
- D14: the licence replaces the studies subtitle inside heading(), no rule, 4.4 mm gap restored, measured against the 104 mm before the languages column (second line when needed; fails loudly beyond).
- D15: the trip role is its own small tracked line centred under the stamp (led in the accent), measured against the 26 mm stamp column. Above the period it cost a line in the binding left column and pushed page 2 into overflow and a petal; under the stamp it fits. Tested: led-long-period ('September 2024', 'Led the group' in full), long-role refusal.
- D16: twin kinds drop 'which he planned himself'; twin licence is now title 'Tour Leader', issuer 'Thermaic Tour Board', no region, so it stays on one line clear of a petal.
- m1: deliver.approve cites build-a-cv.md:165-170. n1: both versions require destinations (docs). n2: a licence day its month lacks ('31 Feb 2029') is refused; a leap day passes.
- m2 (correction to the round 2 note): a one-page Variation that does not render the v1 route, stamps and story declares 'exactly: [2]' with destinations@2 (and licences@1 if shown), no travel-story@1, and refuses v1 records. A Variation that renders version 1 must show those fields (they are part of v1's required destinations) and then claims travel-story@1 too.
- Suite builds/tests-20261108-131841-005884 (247 compilations); design renders builds/design-renders-20261108-r3.
<!-- SECTION:NOTES:END -->
