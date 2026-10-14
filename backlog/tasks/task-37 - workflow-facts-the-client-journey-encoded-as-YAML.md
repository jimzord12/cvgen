---
id: TASK-37
title: 'workflow-facts: the client journey encoded as YAML'
status: Active
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 08:46'
labels:
  - workflow-model
dependencies:
  - TASK-34
  - TASK-36
ordinal: 37000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
`catalog.yaml` plus seven `stage.yaml` files from the inventory, re-anchored to current `main`, applying the owner's decisions in docs/proposals/workflow-model.md (TASK-34). Source: docs/work/workflow-model/handoff.md, section 4, item 5 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 All seven stages encoded
- [x] #2 every entity carries its source anchor
- [x] #3 the inventory's implicit steps (port a concept, update `CV Decisions`, close the record, keep request) are named
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Notes from TASK-36 review (round 1, F7)
Gates are pass/fail only (ADR 0015): a multi-outcome or decision gate such as gate.template-exists (marine Template or not) or gate.client-answered (chat and/or form) must be written as pass/fail pairs, or as a chain of gates; decide the encoding before writing stage 5. A per-item repeat (one Deep Dive per chosen question) exists only as a step's when text; name it there consistently. Source anchors may contain spaces; a range must run low to high. Report: docs/work/workflow-schema/reviews/01-code-reviewer.md.

## Notes from TASK-36 review (round 2, R2-2)
Source anchors with backslashes (docs\guides\x.md:3) pass the shape check, and a quoted newline inside a path matches too. Decide in TASK-37 or TASK-38 whether anchors get resolved against the files on disk (path exists, line range within the file); if they do, refuse backslashes there. Report: docs/work/workflow-schema/reviews/02-code-reviewer.md.

## Reading the inventory (TASK-36 context review, M1)
The types name things differently from the inventory: its artifact visibility external (Google, the chat app) is visibility: third-party, a chat message is third-party, and ephemeral is only for what is saved nowhere. given: true means no step produces the artifact (a repo file, the client's first message); a Google Form is third-party, not given. See tools/workflow/README.md, Reading the inventory. Report: docs/work/workflow-schema/reviews/03-context-reviewer.md.

## Result and evidence
docs/workflow/catalog.yaml plus seven stage.yaml files (01-open ... 07-after), each with the yaml-language-server hint; docs/workflow/GAPS.md lists what the sources leave open. Counts: 7 stages, 104 steps, 101 artifacts, 90 actions, 8 actors, 16 gates, 11 loops; 674 source anchors, all resolving on disk at 70631ed (throwaway check builds/task-37-refs/check_refs.py: 0 unresolved references, 0 bad anchors, 0 unused definitions, 0 inputs nothing produces; 6 derived cycles, each holding a declared loop).
Gate encoding: binary only; the three build paths are a chain (gate.template-exists, then gate.template-fits); choices that are not checks are `when` texts; code refusals with no stated next step stay in the action's description. Per-item repeat: "Once per Deep Dive question the owner chose."
Implicit steps named: research.decisions-update, design.port-concept, after.keep-request (+ after.keep-record), after.close.
Checks: `bun run check` OK on all eight files; `bun test` 24 pass; `python tests/run.py` PASS (builds/tests-20261014-114524-436513); `python .atlas/_kit/atlas.py check --strict` all ok, nothing to stamp.
<!-- SECTION:NOTES:END -->
