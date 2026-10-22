---
id: TASK-4
title: 'codex-visual-tools: Codex image generation and a second visual reviewer'
status: Active
assignee: []
created_date: '2026-10-06 07:25'
updated_date: '2026-10-22 09:57'
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

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 codex-visual-reviewer exists and a stand-in run on a fictional Flagship page returns Codex's unedited verdict (evidence under builds/)
- [ ] #2 The documented Sol command generates an image that is copied into builds/ with no text in it
- [ ] #3 idea-run, new-cv and the 05-design stage run it beside the design-reviewer; both must pass; fallback when Codex is unavailable
- [ ] #4 magazine-editor and design-reviewer allow recorded Codex images under the rules; tech-stack documents the CLI
- [ ] #5 ruff, suite and atlas check green; context-reviewer PASS
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. codex-visual-reviewer agent (thin wrapper, Astra high, read-only, ephemeral, ignore-user-config, no repo AGENTS.md).
2. Generated images: one procedure and rule set in docs/tech-stack.md 'Codex CLI'; magazine-editor, new-cv and design-reviewer point to it.
3. Pair the reviewers in idea-run, new-cv, 05-design (README + stage.yaml), review.md; .codex counterparts; Atlas.
4. Apply review 01 findings (F1-F5, N1, N2); mark P-0014 applied.
5. Manual walk: one Codex review of a fictional page, one generated image; suite, ruff, atlas check; context-reviewer loop.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
2026-10-14 (TASK-33): before building, apply the open review of the proposal, archive/work-records/codex-visual-tools/reviews/01.md (FINDINGS: F1, F2 Material; F3-F5 Minor; N1, N2). Both codex exec commands also need --ephemeral (Codex otherwise keeps attached client pages in ~/.codex/sessions; F1) and --ignore-user-config (the owner's global config grants full access and loads plugins; F2); the Privacy line must say the pages carry the whole CV. Also recorded as a dated note in docs/proposals/codex-visual-tools.md.
<!-- SECTION:NOTES:END -->
