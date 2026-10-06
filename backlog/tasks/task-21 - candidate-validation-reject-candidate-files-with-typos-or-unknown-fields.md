---
id: TASK-21
title: 'candidate-validation: reject candidate files with typos or unknown fields'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/h4PRTww0'
ordinal: 21000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# candidate-validation: reject candidate files with typos or unknown fields

Owner: Claude Code, overnight 2026-09-25. Branch `feat/candidate-validation` -> `main`. Approved by the owner 2026-09-25 (overnight job C).

## Outcome
`scripts/cv.py render` and the suite check a candidate JSON against the marine schema before compiling. A misspelt or unknown field, a wrong type or a missing required field stops the render with a readable message naming the field; today such a field is silently dropped. Fictional examples and both private workspaces still pass.

## Acceptance
- Render refuses an invalid record with a message that names the field and path (the first ten offending fields, then "... and N more"); exit code non-zero; no revision folder left half-written.
- Suite has a failing-record case and all current examples validate.
- CI installs whatever the check needs; `python tests/run.py` green; review PASS.

## Result (2026-09-25)
Done. Merged at 207e795 (branch head 95204d7), CI `verify` run 36078589311 success. Suite PASS 40: `cvgen-wt-validation/builds/tests-20260925-033936-361260` (worktree since removed). Reviews 01-05 in `docs/work/candidate-validation/reviews/`, round 5 PASS. New dependency: `jsonschema==4.26.0` (CI pinned). Schema selection: template input schema > Flagship's via lib.typ for marine > domain candidate schema > none; `render.json` records the schema used. Branch and worktree deleted.
<!-- SECTION:DESCRIPTION:END -->
