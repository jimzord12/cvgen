---
id: TASK-62
title: 'atlas-site-citations: the Atlas check covers site.json citations'
status: Queued
assignee: []
created_date: '2026-10-14 08:53'
labels:
  - atlas
dependencies: []
ordinal: 62000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Follow-up from the 2026-10-14 run: python .atlas/_kit/atlas.py check --strict does not verify the citations in .atlas/src/site.json; a reviewer found 6 stale line ranges by hand. Extend the check so site.json citations are hashed and reported like the page sources. Created by the lead 2026-10-14.
<!-- SECTION:DESCRIPTION:END -->
