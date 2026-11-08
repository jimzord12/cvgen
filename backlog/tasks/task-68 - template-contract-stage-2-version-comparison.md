---
id: TASK-68
title: 'template-contract-stage-2: version comparison'
status: Active
assignee: []
created_date: 2026-11-04 21:41
updated_date: '2026-11-08T10:11:00Z'
labels: []
milestone: m-2
dependencies: []
ordinal: 68000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Compatibility script, oldestSupported, group-by-group comparison. Built when a Domain Contract first reaches version 2 (P-0019 section 6).
<!-- SECTION:DESCRIPTION:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. contracts.py: oldestSupported, supported versions, group-by-group compare with record-independent findings, judge on a record, behind report, contract structure check; choose() uses it for records on unsupported versions. 2. Template input schema keeps only copy ($ref to the domain schema); drop the equal-definitions check. 3. Suite: synthetic contracts v1/v2 in a temp folder, Variations upTo 1, exactly [1,2], upTo 2; behind report on real manifests. 4. Docs: engine manual, ADR 0016 status, ADR index, glossary if needed; anchors, render, atlas. 5. tests/run.py and ruff.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Also drop the closed Flagship input schema and the suite's equal-definitions check, moved here from Stage 1 (P-0019 Decisions, 2026-11-04).
<!-- SECTION:NOTES:END -->
