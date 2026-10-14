---
id: TASK-38
title: 'workflow-check: the workflow tool verifies the model (levels 1 and 2)'
status: Active
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 09:30'
labels:
  - workflow-model
dependencies:
  - TASK-37
ordinal: 38000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
`check` command: shape, references, existence of files, commands (`cv.py`/`outputs.py` via `--help`) and skills; flow rules with declared loops. A negative-fixture suite of broken models. Wired into `tests/run.py` and `.github/workflows/verify.yml`. Source: archive/work-records/workflow-model/handoff.md, section 4, item 6 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Every rule has a failing fixture
- [x] #2 CI runs it
- [x] #3 the real model passes
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
2026-10-14, from TASK-36 context review round 2 (m1): the handoff's flow rule 'produced by an earlier step or marked external' (archive/work-records/workflow-model/handoff.md:216) means the Artifact flag given: true in the types (tools/workflow/src/model.ts); there is no external flag, and the inventory's 'external' is visibility third-party (tools/workflow/README.md, Reading the inventory).

## Notes from TASK-37 (the facts in docs/workflow/) -- Gates are binary: a three-way choice is a chain (gate.template-exists, then gate.template-fits on design.flagship-fit); choices that are not checks are when texts. -- Per-item repeat: the when text "Once per Deep Dive question the owner chose." on every Deep Dive step. -- Placeholder caps: a loop with no sourced cap says "(placeholder cap)" in its name and cites its row in docs/workflow/GAPS.md; decide whether the check or the render flags them. -- Versions of one file: a file rewritten later and read earlier has one ID per version (art.facts-md/art.facts-final, art.messages-md/art.messages-follow-up, one README.md ID per line or section), so derived edges run forward. -- In-place edits: typst/cv.typ and candidate.json are written in design and edited by design.fix and deliver.fix, so derived edges merge the design and deliver loops into one 16-step cycle holding five declared loops; the flow check needs a rule for this or those steps their own IDs. -- Order with no data: design.clear-review-input before deliver.render, and design.record-choice before design.fill-data on the one-off path, follow only from gates. -- AND inputs with optional producers (when steps) need a rule. -- Escalation steps (<stage>.cap-reached) have no inputs: reached only through a loop. -- Visibility: builds/ files (art.design-review-input, art.page-png) are neither tracked, private nor third-party; encoded ephemeral; the types may want a value for an ignored local file. -- The refusals of approve, export and stamp are in no entity: a cmd action holds only its run line. -- Anchors: all resolve on disk; builds/task-37-refs/check_refs.py <root> <base> [--fix] finds anchors whose cited lines moved since a commit, a check worth keeping since every merge to main can move them.

From TASK-37 context round 2: intake.no-consent has no outputs (an owner-decision endpoint); the flow check needs a rule that allows such endpoints, beside the rule for escalation steps. The anchor checker builds/task-37-refs/check_refs.py lives in ignored builds/ and is gone on another machine: rebuild it in tools/workflow as part of this task.

2026-10-14, TASK-38 implementation (lead decisions, each open to review):

(1) Command: bun run check with no argument checks the whole model in docs/workflow; a folder argument checks the model there (the fixtures); file arguments keep the old shape-only check. Chosen over a separate check-model command so the one word means the one check; README and AGENTS.md say so.

(2) 20 rules, each printed as [rule] with file, line and path: shape, stage-folder, duplicate-id, step-prefix, unresolved, scope, unused, gate-step, gate-branches, source, given-path, skill, agent, command (level 1); given-produced, unproduced, unreachable, cycle, loop-open, dead-end (level 2). A shape problem stops the check before the other rules. Each rule has a broken fixture in tools/workflow/test/fixtures/<rule>/ and a test asserts that exactly that rule fires at the named path; valid/ passes.

(3) Placeholder caps: a non-failing NOTE line listing every loop named (placeholder cap), on every run, so they stay visible without blocking CI.

(4) Loops: each declared loop removes the edges from its gate step to its fail step; any cycle left fails. This is the rule for the in-place edits: the 16-step design+deliver cycle passes because its five loops break every turn (mutation check: without the removal the check reports it, with the two Idea Run loops). No new artifact IDs were needed.

(5) AND inputs with optional producers: any producer counts, when or not; whether when branches cover every case is level 3 (TASK-42). Order with no data (clear-review-input before render) follows from gates and is not checked.

(6) Reach: from the given artifacts a step runs once all its inputs exist; a gate step enters both branches and, through a loop on that gate, its escalation step. A step with no inputs is reached only as an escalation step.

(7) Endpoints (dead-end rule): a step with no outputs and no gate is allowed only as a loop escalation step, a gate branch (an owner decision such as intake.no-consent, library-commit, clear-review-input) or an optional step (when).

(8) Facts were wrong, rules kept: after.keep-request and after.revision-cleanup had no inputs, so nothing reached them. keep-request now reads art.intake-message (its consent text offers keeping, client-workflow.md:164-167); revision-cleanup reads art.status-listing (cv.py status lists failed and unapproved Revisions). Both are inferences in GAPS.md; both artifacts moved to catalog.yaml because the new scope rule refuses a stage-local artifact used in another stage.

(9) Anchor checker rebuilt as bun run anchors <base> [--fix] (git diff -U0 mapping; MOVED is fixable, EDITED needs a person; only anchors present in the model at <base> are judged). Run against d7da40d it found 15 anchors that had drifted by 1-3 lines (GAPS.md gained a line in 99379f1, verify-cv moved in TASK-47); fixed in 6f00e54. Its 4 EDITED spans (build-a-cv.md, render.py, export.py) changed only in wording and from error; facts hold. Not in CI: it needs a base commit.

(10) Not encoded, no rule: builds/ files stay visibility ephemeral; the refusals of approve, export and stamp stay in GAPS.md. Agents: general-purpose is the only built-in accepted without a file. Commands: only python <script>.py <subcommand> is checked through --help; typst and python -c lines are not.

(11) CI: oven-sh/setup-bun v2.2.0 pinned by SHA 0c5077e5, bun-version-file tools/workflow/.bun-version; install, bun test, typecheck and check in one bash step (pwsh would mask a failing middle line on Windows). tests/run.py case workflow-model: bun run check with PYTHON set to the suite interpreter, bun install --frozen-lockfile first when node_modules is missing, SKIPPED without Bun locally and a failure on CI.

Observation: TASK-52 moves docs/work/ to archive/; the model cites docs/work/workflow-model/handoff.md:290 (three steps), so TASK-52 must re-anchor them or check fails with [source]: the check doing its job. Observation: on this machine the python on PATH is a hermes-agent venv without ruff; lint ran as uvx ruff@0.16.10 check.

Evidence: suite PASS builds/tests-20261014-122858-135891 (workflow-model/check.log: OK model docs/workflow, 7 stages, 104 steps, 100 artifacts, 16 gates, 11 loops); bun test 56 pass; typecheck clean; ruff clean; CI run 38542659141 green on ubuntu-24.04 and windows-2025 (the bun step and the suite). Reviews not run: the lead runs them.
<!-- SECTION:NOTES:END -->
