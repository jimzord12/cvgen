---
id: TASK-4
title: 'codex-visual-tools: Codex image generation and a second visual reviewer'
status: Queued
assignee: []
created_date: '2026-10-06 07:25'
updated_date: '2026-10-14 06:18'
labels: []
dependencies: []
references:
  - 'https://trello.com/c/rBfOnuY0'
ordinal: 4000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner, 2026-09-29: use Codex (his ChatGPT subscription) as (1) an image-creation tool (GPT-6 Sol, high) and (2) a second visual reviewer, codex-visual-reviewer, beside the design-reviewer (GPT-6 Astra, high).

Record: docs/proposals/codex-visual-tools.md (status approved): verified commands, pitfalls (prompt before -i; always pass -m, effort and -s; tell Codex to ignore AGENTS.md orientation), plan, docs to update.

Done when: the agent file exists; idea-run and new-cv run it beside the design-reviewer (both must pass); the editor and reviewer profiles allow recorded Codex images; tech-stack and AGENTS updated; first used on the 2026-09-29 tour-leader idea run; review PASS.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
2026-10-14 (TASK-33): before building, apply the open review of the proposal, archive/work-records/codex-visual-tools/reviews/01.md (FINDINGS: F1, F2 Material; F3-F5 Minor; N1, N2). Both codex exec commands also need --ephemeral (Codex otherwise keeps attached client pages in ~/.codex/sessions; F1) and --ignore-user-config (the owner's global config grants full access and loads plugins; F2); the Privacy line must say the pages carry the whole CV. Also recorded as a dated note in docs/proposals/codex-visual-tools.md.
<!-- SECTION:NOTES:END -->
