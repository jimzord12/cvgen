---
id: TASK-36
title: 'workflow-schema: typed entity definitions for the workflow model'
status: Done
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 08:18'
labels:
  - workflow-model
dependencies:
  - TASK-35
ordinal: 36000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Bun project (suggested `tools/workflow/`), Zod types for Stage, Step, Artifact, Action (`cmd`/`skill`/`agent`/`manual`/`lead`), Actor, Gate and Loop, with external artifacts; exported JSON Schema; the YAML language-server hint. Source: docs/work/workflow-model/handoff.md, section 4, item 4 (A. Workflow model). Created 2026-10-14 at the owner's request; not started. The owner answered its open question on 2026-10-14 (docs/proposals/workflow-model.md): proceed unattended and show the types at the end; the decision overrides this description where they differ.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 `bun test` passes
- [x] #2 the JSON Schema is generated
- [x] #3 one sample `stage.yaml` validates in VS Code and through the workflow tool
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Owner decision 2026-10-14 recorded in docs/proposals/workflow-model.md: proceed unattended; explain the types with an example in the final report.

## Result and evidence
Bun project in tools/workflow/ (Bun 1.4.3 locally, .bun-version 1.4.2 for CI; zod 4.6.5, yaml 2.9.1; dev ajv 8.20.0, typescript 7.0.2, @types/bun 1.4.2). Types in src/model.ts; JSON Schema exported to schema/ (draft-07) and committed, drift test in test/cli.test.ts. bun test: 19 pass; bun run typecheck clean. Sample tools/workflow/sample/stage.yaml passes Zod, ajv (test) and Python jsonschema (walk); VS Code itself not opened, the schema hint is proven through these two JSON Schema validators. CLI walk (sample plus two broken copies, schema drift): builds/task-36-walk-20261014-101509/ (worktree). Suite after merging origin/main f6aebb4: PASS, builds/tests-20261014-105413-452717/. Atlas check --strict ok.

## Handoff
Left for TASK-38: wire bun test, typecheck and schema --check into tests/run.py and .github/workflows/verify.yml (oven-sh/setup-bun with bun-version-file tools/workflow/.bun-version); model-wide checks (ID uniqueness, references resolve, step ID prefix = stage ID, loop gate fail goes back) take loadFile().data. Independent code-reviewer round not yet run.

## Review round 1 (code-reviewer)
FINDINGS, one Material. F1 fixed: yaml-language-server 1.24.0 (the engine of the Red Hat VS Code YAML extension) run headlessly over stdio on the sample (0 diagnostics) and a broken copy (all five breaks flagged, same lines as the workflow tool); evidence builds/task-36-lsp/diagnostics.txt (worktree), driver lsp.mjs beside it, not a repo dependency. The owner opening the sample in VS Code stays the final check. F2 fixed (reserved prefixes named in the error; patternErrorMessage carries every ID message into the JSON Schema so VS Code shows it). F3 fixed (test temp folder removed in finally; 14 old folders deleted). F4 fixed (glossary). F5 fixed (spaces allowed in source paths, reversed ranges refused by the workflow tool; JSON Schema cannot compare them). F6 fixed (--frozen-lockfile). F7: sample now stamps signed-off (text.sign-off-stamp); the rest appended to TASK-37. F8: context-reviewer round still to run. Report: docs/work/workflow-schema/reviews/01-code-reviewer.md.

## Review round 2 (code-reviewer)
PASS. R2-1 fixed: a stage named art fails with the reserved-prefix message, and the exported schema must carry the readable ID messages; mutations in a disposable copy (StageId lookahead removed, StageId message reset, patternErrorMessage dropped; schema regenerated each time) are each caught (builds/task-36-mutation-r2-log.txt, worktree). R2-2 carried to TASK-37. R2-3 accepted. bun test 24 pass. Report: docs/work/workflow-schema/reviews/02-code-reviewer.md.

## Review round 3 (context-reviewer, context round 1)
FINDINGS, one Material. M1 fixed: the Artifact boolean external is renamed given (no step produces it), so external has no meaning in the types; a chat message is visibility third-party, ephemeral only for what is saved nowhere; README gains Reading the inventory, TASK-37 a pointer. m1 (illustrative steps marked), m2 (will live, from TASK-37), m3 (note headings on their own lines) fixed. TASK-38 title already says the workflow tool. Top-level folder count left to TASK-55. Report: docs/work/workflow-schema/reviews/03-context-reviewer.md.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
tools/workflow/ (TypeScript on Bun, ADR 0015): Zod types for Stage, Step, Artifact, Action (cmd/skill/agent/manual/lead), Actor, Gate and Loop with strict objects, kebab-case IDs with kind prefixes and source anchors; JSON Schema generated from the types and committed with a drift test; bun run check <file> (exit 0/1/2, file:line: path: reason); sample stage.yaml (Text Draft stage, illustrative cap) validated by the tool and by yaml-language-server 1.24.0, the VS Code YAML extension's engine. Bun 1.4.3 installed (CI pin 1.4.2); zod 4.6.5, yaml 2.9.1. Two code-reviewer rounds (FINDINGS, PASS) and two context-reviewer rounds (FINDINGS, PASS). bun test 24 pass; suite PASS (builds/tests-20261014-111543-214617 in the worktree). CI and suite wiring left to TASK-38. Owner's own look in VS Code is the final check.
<!-- SECTION:FINAL_SUMMARY:END -->
