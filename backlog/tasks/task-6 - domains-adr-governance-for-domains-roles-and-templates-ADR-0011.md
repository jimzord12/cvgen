---
id: TASK-6
title: 'domains-adr: governance for domains, roles and templates (ADR 0011)'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/kU9Ql6rm'
ordinal: 6000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
# domains-adr

Stage 0 of ADR 0011 (a CV library for any field: domain > role > template). Governance documents only; no code moves.

## Outcome and boundaries
The rulebook allows the restructure: ADR 0011 accepted, Status lines of 0002/0007/0010 amended, vision no longer says "maritime roles only", constitution sections 6 and 7 generalised without weakening, conventions carry the domain/role/template markers and the deliverable naming rule, history entry added. Excludes every file move (domains-move) and every code change (domains-core-split). The project name is filled into ADR 0011 when the owner picks it.

## Acceptance
- [ ] ADR 0011 text and the exact new constitution sections 6 and 7 shown to the owner in chat; owner's written go recorded as "approved in conversation on <date>" in the ADR.
- [ ] `python tests/run.py` PASS on the branch (nothing but docs changed).
- [ ] One code-reviewer round (lenses 8 repository/docs, 7 simplicity/ownership) with verdict PASS, report under docs/work/domains-adr/reviews/.
- [ ] Merged to main and pushed; CI green.

## Plan
Branch docs/adr-0011-domains. Files: docs/decisions/0011-domains-roles-templates.md (new), 0002/0007/0010 Status lines, decisions/README.md, vision.md, constitution.md sections 6-7, conventions.md, history.md.

## Result and evidence
Merged to main as b54d9f9 (branch docs/adr-0011-domains, 4 commits). ADR 0011 with the name CVgen and the owner's explicit approvals (direction 2026-09-20; name, constitution 6/7 rewording, staged delivery, repo rename 2026-09-21). Suite PASS at 00b034e: builds/tests-20260921-015002-430709 (35 cases, exact reference equal). Tag archive/pre-domains on b54d9f9, pushed.

## Review
Round 1 PASS (lenses 8, 7): https://github.com/jimzord12/marine-engineer-cv/blob/main/docs/work/domains-adr/reviews/01.md . Three Minor fixed before merge; Notes dispositioned in the report.

## Handoff
Done 2026-09-21. Next: domains-move.
<!-- SECTION:DESCRIPTION:END -->
