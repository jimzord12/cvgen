---
id: TASK-65
title: 'template-contract-3: coverage in the suite and checks before a render'
status: Done
assignee: []
created_date: 2026-11-04 21:41
updated_date: '2026-11-08T10:29:00Z'
labels: []
milestone: m-2
dependencies: []
ordinal: 65000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Suite proves each claim; render stops on a missing required group and warns on a dropped one; the Meta File records it (P-0019 sections 7, 8).
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
2026-11-08 code review round 2 PASS (archive/work-records/template-contract-stage1/reviews/code-round-02.md). F1-F3 fixed: variation read with a space or none, a non-string template or variation refused, two vessels prove per-vessel durations; fixture glob exact. F4: the contract run over private marine records: 2 pass, 0 missing a required group. Deferred: N2 schema-check of fixtures, N3 image marker counts any raster, N5 silent cases (custom composition variation, show-vessel-durations) - with Essential (TASK-67). N4: context-reviewer still owed on Stage 1's doc changes before merge.

## Done (2026-11-08)

Merged in 9a7c4bd. Code review round 2 PASS, context review round 2 PASS (archive/work-records/template-contract-stage1/reviews/). Suite PASS 203 cases at the merged head (builds/tests-20261108-122900-386443 in the worktree).
<!-- SECTION:NOTES:END -->
