---
id: TASK-8
title: 'intake-form: optional Google Form for intake and follow-up questions'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/do62LryA'
ordinal: 8000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
**Goal.** Clients can answer the intake and follow-up questions in a designed Google Form; answers land in a Google Sheet (owner, 2026-09-28: "build it, with sheet"; redesign asked the same day: "utilize all the types of questions", "nicer and more professional").

**Built.** `scripts/intake-form.gs`: pages with skip logic, choices, tick boxes, drop-downs, grids, scales, dates, validated text; checkForm_ rejects a bad FORM before anything is created; publishes; logs three links. `brand/forms/intake-header.png` (First Fitting) with theme steps. Guide sections 1, 2, 7 and deletion, new-client skill, glossary `Intake Form`, AGENTS.md map, two dated owner decisions in the client-workflow proposal (form allowed; form cap = about 15 minutes, at most 5 typed answers).

**Evidence.** Dry runs against a recording stand-in for Google: builds/intake-form-dryrun-20260928-212746/ (14 invalid cases). Header: builds/intake-header-20260928-211942/.

**Review.** Rounds 1 (FINDINGS), 2 (PASS), 3 (FINDINGS: cap, decided by the owner), 4 (PASS); design-reviewer PASS. Reports in `docs/work/intake-form/reviews/`.

**Open.** Stays in Review until the owner's first real run (client-2026-09-01) confirms: link opens without sign-in, form published, theme fonts offered, CSV download is a ZIP.
<!-- SECTION:DESCRIPTION:END -->
