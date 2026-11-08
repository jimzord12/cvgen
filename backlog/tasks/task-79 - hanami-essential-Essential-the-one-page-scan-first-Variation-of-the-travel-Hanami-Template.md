---
id: TASK-79
title: >-
  hanami-essential: Essential, the one-page scan-first Variation of the travel
  Hanami Template
status: Active
assignee: []
created_date: '2026-11-08T10:07:00Z'
updated_date: '2026-11-08T10:35:00Z'
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
