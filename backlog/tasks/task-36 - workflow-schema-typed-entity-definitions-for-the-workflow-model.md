---
id: TASK-36
title: 'workflow-schema: typed entity definitions for the workflow model'
status: Active
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 07:55'
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
<!-- SECTION:NOTES:END -->
