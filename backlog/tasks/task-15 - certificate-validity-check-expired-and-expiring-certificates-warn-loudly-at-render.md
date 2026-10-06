---
id: TASK-15
title: >-
  certificate-validity-check: expired and expiring certificates warn loudly at
  render
status: Done
assignee: []
created_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/PMLbsl6C'
ordinal: 15000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# certificate-validity-check: expired and expiring certificates warn loudly at render

Owner: Claude Code (Night Shift 2026-09-27-a)
Branch/worktree: feat/certificate-validity-check (merged)
Integration target: main
Depends on: proposal https://github.com/jimzord12/cvgen/blob/main/docs/proposals/certificate-validity-check.md (owner 2026-09-25, Day Shift question 07: APPROVE WARN-ONLY; now `applied`)

## Outcome and boundaries
`cv.py render` reads the certificate dates in the revision's snapshot record and prints a `WARNING:` line for each certificate that has expired or expires within 180 days; `status` repeats them; checks.json records them with the counts and the day used. Warnings only (owner's choice over the proposal's error): the render succeeds and approval is not refused. Dates not written like `14 Jul 2029` are counted and reported in a `NOTE:` line.

## Acceptance
- [x] Expired and near dates warn in render, status and checks.json; the render still succeeds and approval works.
- [x] Suite case with a fixed reference date: expired, near, the 180-day edge, free text, a non-date, both certificate shapes, broken blocks.
- [x] Suite passes (51 cases on main); code-reviewer PASS (round 2); merged and pushed; CI green (run 36282565285).

## Result and evidence
- Merge: https://github.com/jimzord12/cvgen/commit/3f93864 ; applied: https://github.com/jimzord12/cvgen/commit/c2cabc2
- Example output: WARNING: Certificate "Expired medical" EXPIRED on 31 May 2026 (119 days before the render date). Renew and update the date, remove the row, or replace the date with text such as "Renewal booked".
- New glossary term: `Certificate Warning`. The new-cv skill now tells agents to pass WARNING and NOTE lines to the owner word for word.

## Review
- Round 1 FINDINGS: https://github.com/jimzord12/cvgen/blob/main/docs/work/certificate-validity-check/reviews/01.md (F1 unchecked count not shown: fixed with the NOTE line and counts; F2 status traceback on a broken block: fixed; F3 docs: fixed).
- Round 2 PASS: https://github.com/jimzord12/cvgen/blob/main/docs/work/certificate-validity-check/reviews/02.md (F4, N4 applied as docs-only after the PASS; N5 print order left as is).

## Handoff
Done. Deferred note N5: WARNING/NOTE lines print above the JSON, so with many revisions `status` can scroll them away; print them after the JSON if it bothers anyone.
<!-- SECTION:DESCRIPTION:END -->
