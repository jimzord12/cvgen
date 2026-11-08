---
id: TASK-2
title: 'travel-domain: Travel & Tourism, the first non-marine domain (roadmap item 2)'
status: Active
assignee: []
created_date: 2026-10-06 07:25
updated_date: '2026-11-08T10:32:00Z'
labels: []
milestone: m-3
dependencies: []
references:
  - https://trello.com/c/iiB1VyaE
ordinal: 2000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
**Goal.** A `Travel & Tourism` `Domain` beside `Marine`, built from the first real client's one-off CV (owner's process, 2026-09-28).

**Proposal (deferred, revision 2):** https://github.com/jimzord12/cvgen/blob/main/docs/proposals/travel-domain.md

**Trigger:** the first Travel & Tourism client's one-off CV reaches Export (not its Sign-off). Then the proposal returns to pending for the owner's approval of steps 3-4: study the one-off, create the Domain and first Template with a fictional twin as the public example, audit and extend lightly.

**Done when.** The Domain, Template, fictional example and frozen reference land with the suite passing and the engineer example still pixel-identical to v11.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. packages/domains/travel: domain.typ, data.typ (normalise, validate, destination totals), schema, contracts/v1.json, lib.typ.
2. Coverage Fixture coverage-v1.json + markers.
3. templates/hanami: port of Hanami Line 2 (client one-off) as the showcase Template Variation; themes sakura/indigo/sky, Japan artwork pack, template.json, tests/coverage.typ.
4. Fictional twin examples/candidates/tour-leader-example.json + examples/travel/hanami/<twin>.typ; render to builds/.
5. Frozen Reference candidate in tests/approved (owner approval pending) + pixel check in the suite; travel checks in tests/run.py and coverage.py.
6. Docs: architecture, domains-and-roles, template-contract, glossary, workflow YAML facts; anchors, render, atlas.
7. Suite + ruff; notes with evidence.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Approved scope (owner, 2026-11-08)

P-0013 steps 3 and 4 approved: `packages/domains/travel/` with its facts model, schema, wording and `contracts/v1.json` (extends base@1: `rank` required; `destinations`, `availability`, `practical` optional), a Coverage Fixture, and the Hanami Template grown from Hanami Line 2 (the owner's pick of 2026-10-02) as its `showcase` Template Variation, with a Template Manifest. Its public example and Frozen Reference use a fictional twin (invented guide, the real CV's shape). The owner approves the Frozen Reference. Next: TASK-79 (Essential), TASK-80 (contract v2), TASK-81 (the client's CV).

## Result and evidence (2026-11-08, branch feat/travel-domain, not merged)
- Built: packages/domains/travel/ (domain, data with destination-totals, schema, contracts/v1.json, Coverage Fixture), templates/hanami/ (showcase; themes sakura, indigo, sky; Japan artwork pack; layout showcase), twin examples/candidates/tour-leader-example.json + examples/travel/hanami/tour-leader.typ, tests/travel.py and tests/fixtures/travel.typ.
- Suite PASS (214 cases), ruff clean: builds/tests-20261108-123156-201976. Coverage: hanami showcase on coverage-v1, 8 of 9 optional groups (certificates not shown). Engineer still pixel-identical to v11; git diff main...HEAD on packages/cv-framework and packages/domains/marine is empty.
- FROZEN REFERENCE NOT APPROVED: packages/domains/travel/templates/hanami/tests/approved/Travel-Tour-Leader-CV-v01.pdf is a candidate; the suite compares the twin with it, but the owner must approve it before merge. Not pinned in tests/baseline.json until he does. Page PNGs: builds/travel-3/reference-page-1.png, -2.png.
- No Release PDF written (owner's go). build.ps1 now stamps a list entry's style (Hanami) instead of always Flagship.
- Gaps: docs/framework-gaps.md 2026-11-08 (absolute placement, pre-laid petal layer, no page shell).
- Next: review (code-reviewer, design-reviewer), owner approval of the reference.
<!-- SECTION:NOTES:END -->
