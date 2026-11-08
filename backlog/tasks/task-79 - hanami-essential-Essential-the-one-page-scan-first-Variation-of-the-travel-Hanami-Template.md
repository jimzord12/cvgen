---
id: TASK-79
title: >-
  hanami-essential: Essential, the one-page scan-first Variation of the travel
  Hanami Template
status: Active
assignee: []
created_date: '2026-11-08T10:07:00Z'
updated_date: '2026-11-08T11:13:00Z'
labels: []
milestone: m-2
dependencies: []
ordinal: 79000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner: lead (Claude Code)
Branch/worktree: feat/hanami-essential
Integration target: main
Depends on: TASK-2 (the travel Domain and the Hanami Template)

## Outcome and boundaries
The first scan-first Template Variation (P-0019 section 9, owner 2026-11-04 and 2026-11-08): one full page, a practical CV chosen by the operator for any Rank, the portrait optional per Client, first-scan fields in fixed prominent places, no type shrinking, a light Hanami touch. Designed with design-reviewer and codex-visual-reviewer rounds on the fictional twin; judged by the Scan Test with Flagship Parity and the Batch Test judging craft. The owner approves the look and its Frozen Reference. Marine Flagship Essential is TASK-67, a later run.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 The essential Variation renders the fictional twin on one page and passes design-reviewer and codex-visual-reviewer
- [ ] #2 The owner approved the look; its Frozen Reference is in the suite
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Read the contract, research, Hanami source and prior art.
2. Build layouts/essential.typ and an essential composition (components/essential.typ) inheriting Hanami theme, type and artwork; one A4 page, fixed slots, loud failures.
3. Long careers: recent roles in full, older summarised with totals from the data; fail loudly otherwise.
4. template.json: essential variation, designBar scan-first, supports travel upTo 1 with the groups it shows; coverage proves it.
5. Fixtures: twin, twin without portrait, long career, Greek copy; renders under builds/.
6. Frozen Reference candidate and suite pixel check; entry point with variation essential.
7. Docs: template-contract.md, Hanami docs, build-a-cv guide; Workflow anchors and Atlas.
8. tests/run.py and ruff pass; marine and showcase pixel-identical.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Result and evidence (round 1, before design review)

- Built: layouts/essential.typ, essential.typ (composition), components/essential.typ; hanami.typ dispatches on the variation and checks the layout against the manifest; template.json essential (pages 1, designBar scan-first, travel upTo 1: profile, education, languages, portrait, availability, practical, references). Showcase unchanged (pixel check passes).
- Long careers: the newest roles in full, the older in one summary with experience-totals (data.typ, domain.typ); fails loudly when the newest role alone overflows or a summarised career is not newest first.
- destinations is shown as a summary (trips, stops, totals) but not claimed in v1 (no stamps, route or story): dropped with the warning by design; TASK-80 should split it.
- Entry point examples/travel/hanami/tour-leader-essential.typ (release.json); Frozen Reference candidate tests/approved/Travel-Tour-Leader-CV-Essential-v01.pdf, not pinned in baseline.json (owner approval pending).
- Fixtures: tests/fixtures/travel-essential.typ (no portrait, indigo, sky, greek, long career, long career Greek, no destinations; failures overflow, unsorted, long name, showcase layout), tests/fixtures/tour-leader-long-career.json.
- Docs: engine/template-contract.md, architecture.md, verification.md 6b, domains-and-roles.md, glossary, guides/build-a-cv.md (choose and record the Variation), Workflow Model lead.write-flagship-entry, anchors, Atlas.
- Evidence: python tests/run.py PASS (builds/tests-20261108-125057-630396), ruff clean; review renders builds/hanami-essential-r1-20261108-125152/.
- Open: design-reviewer and codex-visual-reviewer rounds; owner approval of the look, the scan-first bar and the Frozen Reference.

## Rounds 2 and 3, and contract version 2 (2026-11-08)

- Design round 1 (design-reviewer FINDINGS D1-D9, Codex PASS) fixed in b665f55; round 2 (D10-D12) fixed in the next commit. Review files in archive/work-records/hanami-essential/reviews/.
- Merged feat/travel-contract-v2 (TASK-80). Essential supports travel exactly [2] (version 1's required destinations holds the route, stamps and story, which one page cannot show), claims destinations@2 and licences@1, leaves travel-story out; licences beside the lead, each trip's role after its period, the areas, the rank's seal words on the band.
- Evidence: tests/run.py PASS (builds/tests-20261108-131156-155946), ruff clean, Workflow Model and Atlas checked.
<!-- SECTION:NOTES:END -->
