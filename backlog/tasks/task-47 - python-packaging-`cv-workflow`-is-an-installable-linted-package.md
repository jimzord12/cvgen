---
id: TASK-47
title: 'python-packaging: `cv-workflow` is an installable, linted package'
status: Queued
assignee: []
created_date: '2026-10-14 04:48'
labels:
  - restructure
dependencies: []
ordinal: 47000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
A `pyproject.toml` with pinned dependencies (pillow is unpinned in CI); drop the `sys.path` inserts; ruff; consider pytest for `tests/run.py` (bare asserts stop at the first failure and vanish under `-O`). Source: docs/work/workflow-model/handoff.md, section 4, item 15 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->
