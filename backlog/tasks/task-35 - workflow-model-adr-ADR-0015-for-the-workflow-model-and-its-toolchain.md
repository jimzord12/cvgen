---
id: TASK-35
title: 'workflow-model-adr: ADR 0015 for the workflow model and its toolchain'
status: Done
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 06:56'
labels:
  - workflow-model
dependencies:
  - TASK-34
ordinal: 35000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Record YAML facts, the TypeScript/Bun engine, Zod plus JSON Schema, Atlas from the model, and a second toolchain beside Python (CI installs Bun). Source: docs/work/workflow-model/handoff.md, section 4, item 3 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 ADR 0015 merged
- [ ] #2 `docs/tech-stack.md` and `AGENTS.md` mention Bun
<!-- AC:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
ADR 0015 records the Workflow Model: YAML facts in docs/workflow/, Zod types with exported JSON Schema, a TypeScript workflow tool on Bun (CI pinned 1.4.2, local any 1.4.x from 1.4.2) in tools/workflow/ that checks the facts and writes workflow docs, diagrams and the Atlas client-journey page facts; cv.py, outputs.py and cv-workflow stay Python. Alternatives (Python+pydantic, Node 24, hand-written docs, Pkl/CUE, hand-written schema) recorded with honest tradeoffs. tech-stack.md and AGENTS.md mention Bun; glossary term Workflow Model; TASK-36/38/42 wording 'the workflow tool'. One context-reviewer round (PASS, minors fixed). Suite PASS 104 (builds/tests-20261014-095501-363214 in the worktree).
<!-- SECTION:FINAL_SUMMARY:END -->
