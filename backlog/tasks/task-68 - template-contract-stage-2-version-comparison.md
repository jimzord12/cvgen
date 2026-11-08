---
id: TASK-68
title: 'template-contract-stage-2: version comparison'
status: Active
assignee: []
created_date: 2026-11-04 21:41
updated_date: '2026-11-08T10:43:00Z'
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

## Trigger met (2026-11-08)

The travel Domain Contract reaches version 2 in TASK-80, at the owner's request, so Stage 2 (version comparison, oldestSupported, the behind-by warning) is built now.

## Result and evidence (2026-11-08)
Stage 2 built in packages/cv-workflow/cv_workflow/contracts.py: claims() (group -> set of schema versions; upTo or exactly, validated), oldest_supported/readable/supported, compare() group by group with RESULT always/held/lacking/never, judge(), broken() and check_domain() (refuse a group that loses a path or whose schemaVersion falls without a rise), shown_by(), unproved(), compatibility()/describe()/report(); choose() compares a record newer than every version a Variation names with its newest named version, refuses a skipped or older version and one below oldestSupported. python scripts/cv.py contracts [--json] prints the report. Flagship's input schema now holds only copy and refers to the marine facts schema by $ref (validate.py registry); the equal-definitions check is replaced by one that every Template input schema refers to its Domain's and adds only copy.
Timing (review m4): built before any Domain Contract reached version 2, so the travel contract v2 can use it; ADR 0016's body says 'when a contract first reaches version 2' and stays as accepted text, its Status line records the build.
Tests: tests/compatibility.py (synthetic v1/v2/v3 contracts in a temp folder), tests/coverage.py (claims proved, kept contracts whole, oldestSupported vs example records), tests/run.py (copy refusals). code-reviewer: round 1 FINDINGS (M1 required-turned-optional reported as dropped, m2, m3, N1, N3, fixed), round 2 FINDINGS (R2-M1: claimed-shape shortcut reverted), round 3 PASS (R3-m1 fixed after).
Evidence: suite PASS on f1b6b39 (merge of main), builds/tests-20261108-123228-323975 in the worktree; ruff clean; workflow anchors, check, render and atlas OK; Atlas pages stamped.

## Major decisions (docs/preferences.md grades)
1. Structure is judged by a group's paths: a path may join without a schemaVersion rise; a path leaving, or a falling schemaVersion, without a rise is refused. A new required field or changed meaning rests on the author.
2. A record newer than every version a Variation names is compared with its newest named version; a version an exactly list skips, or one older than all it names, is refused.
3. A group required at the Variation's last version stays shown after it turns optional, so it is never dropped. When a group differs in two ways, the stricter result wins.
4. A group may be claimed at several schema versions (places@1, places@2); the suite refuses a claim no rendered version has, and a claim never relaxes the changed-group error.
5. oldestSupported lives in the newest contract file (default 1); the suite refuses it above any example record's version.
6. The facts schema keeps copy an open object; only the Template's input schema closes its keys. An entry point with no Template no longer checks copy keys.
7. The coverage figure is in cv.py contracts and the suite's evidence, not the Meta File.
8. Stage 2 was built before any Domain Contract reached version 2, so the travel v2 contract can use it; ADR 0016's Status line records it.

## Review (2026-11-08)

Code review rounds 1-3 (PASS) and context review rounds 1 (FINDINGS) and 2 (PASS), verbatim in archive/work-records/template-contract-stage2/reviews/. Evidence for the head: builds/tests-20261108-123928-837247 (6be2cb2), then the merged head below.
<!-- SECTION:NOTES:END -->
