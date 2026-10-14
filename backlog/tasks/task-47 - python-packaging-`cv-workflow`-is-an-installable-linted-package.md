---
id: TASK-47
title: 'python-packaging: `cv-workflow` is an installable, linted package'
status: Queued
assignee: []
created_date: '2026-10-14 04:48'
updated_date: '2026-10-14 06:27'
labels:
  - restructure
dependencies: []
ordinal: 47000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
A `pyproject.toml` with pinned dependencies (pillow is unpinned in CI); drop the `sys.path` inserts; ruff; consider pytest for `tests/run.py` (bare asserts stop at the first failure and vanish under `-O`). Source: docs/work/workflow-model/handoff.md, section 4, item 15 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
2026-10-14, from TASK-48 review round 2 (N4, N5): CI now pins pillow==12.3.0, pymupdf==1.28.2, jsonschema==4.26.0 in .github/workflows/verify.yml; jsonschema's transitive dependencies (attrs, referencing, jsonschema-specifications, rpds-py) still float, so a constraints or lock file belongs here; docs/tech-stack.md local setup line and docs/work/workflow-model/handoff.md still describe pillow as unpinned.
<!-- SECTION:NOTES:END -->
