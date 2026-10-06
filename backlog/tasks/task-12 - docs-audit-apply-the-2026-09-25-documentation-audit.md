---
id: TASK-12
title: 'docs-audit: apply the 2026-09-25 documentation audit'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/4YdYGADH'
ordinal: 12000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# docs-audit: apply the 2026-09-25 documentation audit

Owner: Claude Code. Branch: `docs/audit-2026-09-25` -> `main`. Opened 2026-09-25 at the owner's request ("run an audit for all docs").

## Outcome
Agent-facing and product/reference docs agree with each other and with the code at HEAD; a real CV built from the guide carries no fictional wording.

## Scope
Findings A-H1..A-L12 and P-H1..P-L22 in https://github.com/jimzord12/cvgen/blob/docs/audit-2026-09-25/docs/work/docs-audit/findings.md. Docs only; no engine, schema or render change. P-H1 metadata wording and P-M7 schema validation stay owner decisions / separate work.

## Progress
- Done 2026-09-25. Merged to main as db03370 (CI run 36075410587 success on that commit).
- Commits: 2439af7 authority, eaa2f21 findings, b0cde6c metadata CVgen, 160adfb governance, 52a5e36 guides/reference, 623e464 r1 fixes, c123394 r2, 85e635a r3, c84da39 r4 + naming rule, 10c4bc3 r5, round-6 record.
- Suite PASS 38 (reviewer rerun at 10c4bc3: builds/tests-20260925-025450-946461).
- Reviews: docs/work/docs-audit/reviews/01-06 (PASS at round 6; 01-04 are lead condensations, labelled).
- Left for the owner: the four exports/ PDFs still carry "Marine CV" metadata (refresh needs his go); constitution section 1 now states chief-officer-example.json is not pinned (factual correction). A-L12 docs/now.md kept. P-M7 done by candidate-validation.
<!-- SECTION:DESCRIPTION:END -->
