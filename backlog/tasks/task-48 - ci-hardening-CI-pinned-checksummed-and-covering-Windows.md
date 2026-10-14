---
id: TASK-48
title: 'ci-hardening: CI pinned, checksummed, and covering Windows'
status: Active
assignee: []
created_date: '2026-10-14 04:48'
updated_date: '2026-10-14 06:06'
labels:
  - restructure
dependencies: []
ordinal: 48000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Pin actions by SHA; checksum the Typst download; pip cache; a Windows job (the owner works on Windows; `build.ps1` is never run in CI); run once per change, not push plus PR. Source: docs/work/workflow-model/handoff.md, section 4, item 16 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Every action in .github/workflows/verify.yml is pinned by full commit SHA with a version comment, each SHA verified against the tag through the GitHub API
- [ ] #2 The Typst 0.15.1 download is checked against a recorded SHA-256 on both runners, and the build fails on a mismatch; the hash source is recorded
- [ ] #3 pip downloads are cached between runs (setup-python cache, keyed on the workflow file that lists the pinned dependencies)
- [ ] #4 A Windows job runs python tests/run.py and scripts/build.ps1 on a Windows runner with the checksummed Typst; the Linux job keeps fonts-dejavu-core
- [ ] #5 Each pushed commit triggers one run (push to any branch plus manual dispatch; no pull_request duplicate, no tag-push duplicate), and the choice is explained in docs/tech-stack.md
- [ ] #6 A run on the pushed branch head is green on both Linux and Windows, with run IDs recorded in the notes; local python tests/run.py PASS; Atlas check --strict exit 0
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Resolve action SHAs and Typst asset digests (gh api, plus a local download hash). 2. Rewrite verify.yml as a two-OS matrix: pinned runners ubuntu-24.04 and windows-2025, push(branches **)+workflow_dispatch, concurrency, read-only permissions. 3. Update docs/tech-stack.md and docs/reference/verification.md. 4. Push the branch, watch the run, iterate to green. 5. Atlas check/stamp, local suite, notes.
<!-- SECTION:PLAN:END -->
