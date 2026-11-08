---
id: TASK-69
title: >-
  backlog-milestones: Backlog.md 1.55.3, every task in a milestone, milestones
  in the workflow
status: Ready
assignee: []
created_date: '2026-11-08T09:06:00Z'
updated_date: '2026-11-08T09:23:00Z'
labels: []
milestone: m-8
dependencies: []
ordinal: 69000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Move the Backlog.md pin from 1.52.0 to 1.55.3 (#1038 closed) with an amending ADR; group every task into milestones through the CLI; make plan -> milestones -> tasks part of the main workflow (development.md, backlog skill, glossary, Codex counterparts). The plan-reviewer agent and its gate in review.md are another agent's work.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Every live mention of the pin says 1.55.3 with the reason; only archive/work-records/ holds 1.52 or #1038
- [x] #2 Every task has exactly one milestone with a done-condition; verified with milestone list and task list
- [x] #3 development.md, the backlog skill, the glossary and .codex/ carry milestones as principles
- [x] #4 Suite and ruff pass; context-reviewer PASS; reports verbatim under archive/work-records/backlog-milestones/reviews/
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. Pin to 1.55.3 with ADR 0017 (0014 amended). 2. Nine milestones and every idle or done task assigned on main through the CLI (1d3bec7). 3. Milestones in development.md, the backlog skill, glossary, idea-run, ceo and .codex. 4. context-reviewer to PASS, merge, Done on main, handoff.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Milestone grouping (Major, agent, 2026-11-08)

| Milestone | Done-condition (short) | Tasks | Why |
|---|---|---|---|
| m-0 Framework and Domains | Framework imports no Domain; marine is a package; Flagship follows the component contract, pixel-identical | 6, 13, 14, 16, 19, 22, 25, 45, 56, 58, 59 | vision Direction items 1 and 4: the engine structure |
| m-1 Marine careers in Flagship | every marine career form renders in Flagship without a bypass | 3, 10, 15, 23 | items 3 and 6: what real seafarers' records need |
| m-2 Template Contract | renders checked against contracts, choice recorded, Essential approved, versions compared at contract v2 | 63, 64, 65, 66, 67, 68 | item 9, ADR 0016; Essential is that item's first use |
| m-3 Travel Domain | Travel & Tourism Domain with a first Template and fictional example | 2, 5 | item 2 |
| m-4 Local client workflow | a Client goes from first message to Export through guarded scripted steps | 8, 11, 18, 20, 21, 32, 44 | the PDF workflow and intake, local |
| m-5 Workflow Model and Atlas | one checked model generates docs and the Atlas page, matches a real run, every citation checked | 34-43, 62 | ADR 0015 and the Atlas |
| m-6 Design studio | Idea Run agents with a second visual reviewer; logo and Text Draft exist | 4, 17, 24, 26 | how designs are made and judged |
| m-7 Verified builds | suite and CI prove every PDF: evidence folders, pinned toolchain, bundled fonts, no overwrite | 9, 46, 48, 49, 50, 60 | trust in output |
| m-8 Agent-ready repository | any agent orients, plans, works, reviews and integrates from the repo alone | 1, 7, 12, 27-31, 33, 47, 51-55, 57, 61, 69 | governance, task store, Git and review rules |

No Maintenance milestone was needed. Completed milestones (m-0, m-1, m-4, m-6) are not archived, so `milestone list --show-completed` keeps the full progress. TASK-63 to 66 are m-2 but change only on feat/template-contract (a handoff note there says so). Milestones thought missing (not created, no task exists): A second marine template (item 5), More themes (item 7), The hosted workflow (item 8).

## Result and evidence

Pin 1.55.3 in tech-stack, the backlog skill and ADR 0017 (0014 Status and index row amended); the handoff line is rewritten on main at session end. `git grep "1.52.0\|#1038"` outside archive/work-records/ finds only ADR 0014 (unedited by the brief), ADR 0017 (the reason), this task, and the handoff until its rewrite. Nine milestones on main (1d3bec7); `backlog milestone list --plain --show-completed`: 5 active, 4 completed, every task but 63-66 (on feat/template-contract) assigned. Suite PASS 198 cases, builds/tests-20261108-112253-985346 in the worktree; ruff clean; workflow anchors and Atlas check clean.

## Review

context-reviewer round 1 FINDINGS (4 Material, 7 Minor), round 2 PASS (4 Minor, applied): archive/work-records/backlog-milestones/reviews/. The plan-reviewer and its gate are another agent's work and were not run here.
<!-- SECTION:NOTES:END -->
