---
id: TASK-40
title: 'workflow-prose: the stage READMEs and the journey README'
status: Active
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 11:08'
labels:
  - workflow-model
dependencies:
  - TASK-39
ordinal: 40000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Hand-written purpose, judgement and branches per stage; the top README at 200-300 lines (owner decision, docs/proposals/workflow-model.md). Refers to IDs and never restates contracts. Source: archive/work-records/workflow-model/handoff.md, section 4, item 8 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 A context-reviewer PASS
- [ ] #2 a newcomer test: an agent answers five "what happens if" questions from these files alone
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
From TASK-39 context review: the generated summary block already prints each stage's Purpose from the YAML; write judgement and branches, not a second purpose line. In 05-design, design.fill-data is entered only from gate.template-exists pass; on the no-Template path port-concept reads art.candidate-json but nothing leads into fill-data: check against the guides and fix the model or explain the branch in prose.

Decisions (TASK-40): (1) fill-data on the no-Template path: the guides write candidate.json on every path (new-cv SKILL.md:43-53 step 1 precedes the Idea Run of step 3; client-workflow.md:44 lists candidate.json in every Envelope; build-a-cv.md:130-136 render refuses without it), so the model was fixed, not explained: gate.template-exists now passes to design.flagship-fit, and design.fill-data reads art.sign-off-png (new-cv SKILL.md:11-15) so it follows the Sign-off on both branches; check and render pass, only 05-design changed. (2) Layout of every stage README: title, summary block, then hand prose (Judgement, Branches, Common mistakes, Where the detail lives until TASK-43), then the generated blocks under hand headings (Diagram, Steps, Gates, Loops, Artifacts, Actions). (3) Top README: 251 lines; stages and journey blocks near the top, handovers and actors under Reference at the end. (4) Glossary Workflow Model row no longer says rendering later. Observation for TASK-43: 05-design stage.yaml (builds/ preview artifact) and 06-deliver stage.yaml (page PNGs) cite GAPS.md for the visibility of an ignored builds/ file, but GAPS.md has no such entry.

Newcomer test (AC #2), five questions with the expected answers, each findable in docs/workflow alone. Q1 The client never answers the follow-up? A: no step models it; research.facts-update waits for the answers; three months after intake after.stall-check names the client to the owner, who decides to wait, ask again or delete; a second follow-up is only the owner's call (P-0018 item 3). Where: 03-research/README.md, Branches; README.md, The main branches (two kinds of waiting). Q2 The Template does not fit the data? A: gate.template-fits fails, design.custom-composition composes the page by hand from the same components (never copied library code), design.framework-gap records it, then the design review as usual. Where: 05-design/README.md, Branches (table and bullet); README.md, The main branches. Q3 The owner rejects every concept? A: gate.owner-pick fails, design.record-other-answer records parked or rejected; no source says what happens next (GAPS.md inference); P-0018 item 7 recommends a new Idea Run steered by his reasons with the owner telling the client of the delay; until he answers, the lead asks him. Where: 05-design/README.md, Branches; README.md, Where the model holds a placeholder. Q4 A render fails the checks? A: gate.render-ok fails to deliver.fix; a refusal writes nothing, a failed compile or check keeps the Revision with its log; the fix is a new Revision, never an edit, and goes back through design.preview and design.client-review; loop.revision-fix has a placeholder cap, then deliver.cap-reached and the owner decides. Where: 06-deliver/README.md, Judgement and Branches. Q5 The client asks us to keep his data? A: after.keep-request through the owner, after.keep-record writes it into envelope.json, the delete-by check then skips him; the field name waits on P-0018 item 5. Where: 07-after/README.md, Branches; README.md, Where the model holds a placeholder.

Correction to Q4 after context round 1: the 06-deliver README now says only that deliver.fix's files feed design.preview again in the model; whether a fix needs another design review is an inference recorded in TASK-43's notes. Round 1 fixes: Atlas pages re-verified and stamped after the glossary edit; one stalled-client wording (wait or delete) in both READMEs; the P-0017 sentence narrowed; glossary Domain row cited in 01-open; inference list says among them.
<!-- SECTION:NOTES:END -->
