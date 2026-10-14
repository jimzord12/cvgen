---
id: TASK-38
title: 'workflow-check: the workflow tool verifies the model (levels 1 and 2)'
status: Active
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 09:08'
labels:
  - workflow-model
dependencies:
  - TASK-37
ordinal: 38000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
`check` command: shape, references, existence of files, commands (`cv.py`/`outputs.py` via `--help`) and skills; flow rules with declared loops. A negative-fixture suite of broken models. Wired into `tests/run.py` and `.github/workflows/verify.yml`. Source: docs/work/workflow-model/handoff.md, section 4, item 6 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Every rule has a failing fixture
- [ ] #2 CI runs it
- [ ] #3 the real model passes
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
2026-10-14, from TASK-36 context review round 2 (m1): the handoff's flow rule 'produced by an earlier step or marked external' (docs/work/workflow-model/handoff.md:216) means the Artifact flag given: true in the types (tools/workflow/src/model.ts); there is no external flag, and the inventory's 'external' is visibility third-party (tools/workflow/README.md, Reading the inventory).

## Notes from TASK-37 (the facts in docs/workflow/) -- Gates are binary: a three-way choice is a chain (gate.template-exists, then gate.template-fits on design.flagship-fit); choices that are not checks are when texts. -- Per-item repeat: the when text "Once per Deep Dive question the owner chose." on every Deep Dive step. -- Placeholder caps: a loop with no sourced cap says "(placeholder cap)" in its name and cites its row in docs/workflow/GAPS.md; decide whether the check or the render flags them. -- Versions of one file: a file rewritten later and read earlier has one ID per version (art.facts-md/art.facts-final, art.messages-md/art.messages-follow-up, one README.md ID per line or section), so derived edges run forward. -- In-place edits: typst/cv.typ and candidate.json are written in design and edited by design.fix and deliver.fix, so derived edges merge the design and deliver loops into one 16-step cycle holding five declared loops; the flow check needs a rule for this or those steps their own IDs. -- Order with no data: design.clear-review-input before deliver.render, and design.record-choice before design.fill-data on the one-off path, follow only from gates. -- AND inputs with optional producers (when steps) need a rule. -- Escalation steps (<stage>.cap-reached) have no inputs: reached only through a loop. -- Visibility: builds/ files (art.design-review-input, art.page-png) are neither tracked, private nor third-party; encoded ephemeral; the types may want a value for an ignored local file. -- The refusals of approve, export and stamp are in no entity: a cmd action holds only its run line. -- Anchors: all resolve on disk; builds/task-37-refs/check_refs.py <root> <base> [--fix] finds anchors whose cited lines moved since a commit, a check worth keeping since every merge to main can move them.

From TASK-37 context round 2: intake.no-consent has no outputs (an owner-decision endpoint); the flow check needs a rule that allows such endpoints, beside the rule for escalation steps. The anchor checker builds/task-37-refs/check_refs.py lives in ignored builds/ and is gone on another machine: rebuild it in tools/workflow as part of this task.
<!-- SECTION:NOTES:END -->
