---
id: TASK-8
title: 'intake-form: optional Google Form for intake and follow-up questions'
status: Done
assignee: []
created_date: '2026-10-06 07:25'
updated_date: '2026-10-06 07:49'
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

## Comments

<!-- COMMENTS:BEGIN -->
author: Trello
created: 2026-10-06 07:49
---
Trello comment, 2026-09-28 18:30 UTC (migrated):

2026-09-28 21:29, first real run (client-2026-09-01): script ran, three links logged. Checked from outside: answer link HTTP 200 with no sign-in redirect, form published and accepting, title and questions as written. Still to confirm: theme fonts offered, CSV download is a ZIP.
---

author: Trello
created: 2026-10-06 07:49
---
Trello comment, 2026-09-28 18:53 UTC (migrated):

2026-09-28 21:50, owner's test answer: the Sheet's File, Download, CSV gives a plain UTF-8 CSV (not a ZIP), one column per question and grid row, skipped page empty, dates M/D/YYYY (Sheet locale). Theme applied: header image and Bona Nova live; Source Sans 3 not detected (questions likely keep Google's default font; the guide's fallback covers it, not a regression). Review round 5 PASS. All first-run checks done: card to Done.
---
<!-- COMMENTS:END -->
