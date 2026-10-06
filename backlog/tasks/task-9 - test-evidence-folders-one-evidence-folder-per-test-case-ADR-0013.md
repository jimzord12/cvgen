---
id: TASK-9
title: 'test-evidence-folders: one evidence folder per test case (ADR 0013)'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/ae8gPDr4'
ordinal: 9000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# test-evidence-folders: one evidence folder per test case

Owner: Claude Code session 2026-09-28
Branch/worktree: feat/test-evidence-folders
Integration target: main
Depends on: none

## Outcome and boundaries
Each case of `python tests/run.py` keeps all its evidence in one folder (PDF, compile.log, check result, suite-rendered page PNGs). Owner's request 2026-09-28 ("I love it! Make it also a short ADR"). ADR 0013. Excludes: the candidate workflow's own layout, old run folders.

## Acceptance
- [x] Every case writes into builds/tests-<ts>/<case>/; nothing flat but report.json
- [x] Checked cases carry page-N.png rendered by the suite and check/result.json
- [x] ADR 0013, verification.md and verify-cv describe the layout
- [x] Suite PASS; independent review PASS

## Result and evidence
Merged to main at 307e749 (CI run 36431544991: success). Suite PASS, 61 cases (builds/tests-20260928-165017-043897, local). The CI artifact holds 48 compile.log, 28 page PNGs, 18 result.json and the workflow commands.log (downloaded to builds/ci-artifact-36431544991).

## Review
Two rounds, `code-reviewer`: round 1 FINDINGS (F1 Material: CI still uploaded flat *.log; fixed), round 2 PASS. Reports in docs/work/test-evidence-folders/reviews/.

## Handoff
Done.
<!-- SECTION:DESCRIPTION:END -->
