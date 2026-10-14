---
id: TASK-43
title: 'workflow-consolidate: one source for the client workflow'
status: Done
assignee: []
created_date: '2026-10-14 04:47'
updated_date: '2026-10-14 12:36'
labels:
  - workflow-model
dependencies:
  - TASK-40
  - TASK-41
  - TASK-42
ordinal: 43000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Replace `client-workflow.md`, `build-a-cv.md` and the lifecycle half of `pdf-workflow.md` with the model; reduce `new-client`/`new-cv` to step-ID pointers; fix the naming-drift items (inventory README: 34 drift items and 53 conflicts, "Fixed without asking"); update `AGENTS.md`; delete `docs/workflow/inventory/`. Source: archive/work-records/workflow-model/handoff.md, section 4, item 11 (A. Workflow model). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 No second description of any step remains (grep checks)
- [x] #2 the skills still run a fictional client end to end
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Notes from TASK-37 (prose that disagrees with the Workflow Model) -- #1: docs/guides/client-workflow.md:330 and new-client SKILL.md:76-77 write "Delivered <date>. Delete by ..."; the model writes "Exported <date>, delete by <date>" at Export. -- #3: docs/pdf-workflow.md:211 retains approved revisions and copies with no limit; the model deletes 12 months after Export unless a keep request is recorded. -- #4: new-cv SKILL.md:68-86 runs the design-reviewer loop only for a Domain with no Template; the model runs it for every client CV. -- #5: new-cv SKILL.md:111-112 names no one for Export; the model gives it to the lead after Approval. -- #6, #7: no guide or skill has the engine change through code review (design.engine-change, design.engine-review) or the client task (open.task-create, after.close). -- Stall rule, two wordings: "three months without progress" (client-workflow.md:333-336) against "no Export three months after intake" (new-client SKILL.md:97-99). -- Library-note review reports, two places: client-workflow.md:257-258 and new-client SKILL.md:51-52 say archive/work-records/research-<topic>/reviews/, docs/research/README.md:29-30 says archive/work-records/<task or client-free id>/reviews/ (TASK-52 may move both). -- new-cv SKILL.md:75-76 names the preview folder for the design-reviewer but no command. -- Owner answers to docs/proposals/workflow-gaps.md (P-0018) land in the YAML first, then here.

From TASK-42 (level 3, review round 1): open model question: deliver.render reads nothing the design review writes, so a run that starts a step once its inputs exist renders beside design.preview, before the review returns (design.clear-review-input before deliver.render follows from gates only). Decide whether render should read the review's result (or a cleared-review artifact) so the order is in the data; see docs/workflow/GAPS.md, What the YAML leaves out.

From TASK-40 context review round 1 (inference, no source): deliver.fix rewrites typst/cv.typ and candidate.json, which design.preview reads, so in the model a fix after a failed render, example wording or the owner's change feeds the design preview again; no guide or skill says whether such a fix needs another design-reviewer round. The workflow READMEs (top README under the journey diagram, 06-deliver Branches) say only the former. Decide it with the owner or record it in docs/workflow/GAPS.md.

From TASK-40's newcomer test: after.delete-by-check reads only art.readme-delete-by, not art.envelope-keep, so the rule that a keep request skips deletion is prose only; add the input when P-0018 item 5 is answered.

From TASK-40 context round 2: the glossary Workflow Model row still says levels 1 and 2; add level 3 (bun run reality, TASK-42) and the generated Atlas page (TASK-41) when the row is rewritten.

TASK-43 decisions (lead): client-workflow.md and build-a-cv.md keep their names and become reference files (no step): CW = Envelope tree (s1), question list (s2), Intake Form clicks (s3), CV Decisions example (s4), erase commands (s5); BC = entry point (s1), record and example wording (s2), what the scripts print and refuse incl. render checks, Certificate Warning, approve/export/stamp refusals and a cv.py-status-to-Meta-File map (s3), fixes (s4), custom composition (s5). Engine sections stay in build-a-cv.md rather than docs/engine/ (fewer moved links; it is the client-CV view of the engine). pdf-workflow.md Lifecycle keeps only record rules; Retention follows decision #3 (12 months after Export unless kept). Scout/Deep Dive brief stays in the new-client skill (an agent runs it). Old-Atlas/GAPS facts placed: LinkedIn rule -> 02-intake README judgement (already there); consent coverage -> CW s2 question 1 plus a 02-intake judgement bullet; Fact Mark -> 04-text-draft judgement; render checks, Certificate Warning, command refusals -> BC s3 (reference, not a step); new Revision inherits no approval -> 06-deliver judgement and pdf-workflow Lifecycle rules; Design Review app before the pick -> 05-design judgement; Drive Trash 30 days -> 07-after judgement. GAPS.md: old-Atlas list and the refusals bullet replaced by one bullet (where they now live); citations repointed; TASK-40 inference (does a fix after design review need another review) added under Inferences; P-0018 items unchanged.

TASK-43 notes worked through: #1 Delivered wording -> Exported <date>, delete by (skills, CW tree, 06 README); #3 retention -> pdf-workflow fixed; #4 every client CV gets design-reviewer -> new-cv; #5 lead exports after Approval -> new-cv; #6/#7 engine change and client task -> new-cv design.engine-change/review, new-client open.task-create/after.close; stall rule -> no Export three months after intake everywhere; library review path -> research README now archive/work-records/research-<topic>/reviews/; preview command -> added to new-cv (lead.compile-previews names it); P-0018 answers still land in YAML first. Left as is: TASK-42 render-reads-nothing-from-review (model question, GAPS Order without data); TASK-40 delete-by-check input waits on P-0018 item 5. Inventory: of 34 drift + 53 conflicts, fixed now: drift 1,2 (main prose),4,7,10,13,17,18,19,20,21,22,23,24,25,26 and conflicts a2,a4,a5,a11,a20(prose),b1,b2,b4,b5,b6,b17,b19 plus check 6 (House Design) and 9 (builds/ clearing rule in 06 README); already resolved before: 17 drift and 16+9 conflicts (A/B); left: E items (accepted or code-level) and two owner questions in neither P-0018 nor GAPS: drift 11 (agents edit list in docs/preferences.md misses messages.md, form-NN.gs, reviews/) and a17 (Check Page language for a client who does not read Greek) - flagged, not decided.

TASK-43 walk (AC #2): followed new-client then new-cv literally for fictional Alex Morgan (engineer example) in a scratch Envelope builds/walk-task43/repo/private/alex-morgan-second-engineer, stand-ins for client messages, design review and owner. Followed from the skill text alone: every-run checks, open.envelope/alias/envelope-json (CW s1), intake.questions/consent, research facts/scout/decisions, text-draft write (header of scripts/text-draft.typ), compile, stamps ready/sent/signed-off (signed-off refused before the screenshot, as documented), fingerprint from the Meta File, design.fill-data, entry point (BC s1), preview command, clear previews, render, page PNGs, wording check (caught the example record values: deliver.fix, new Revision, [] on the second), export refused before approval, approve --test-only, export, delete-by line, stamp delivered, status (rendered, exported). Adapted, not stuck: outputs.py stamp needed --root builds/walk-task43/repo because a scratch Envelope sits outside private/ (real clients do not); open.task-create skipped so no public task for a fictional client. Fixed after the walk: new-cv design.fill-data now says every value replaced (the walk copied a record and kept example values the wording check then caught). Judgement noted: BC s1 says a real candidate always overrides pages; with six companies the base plan was used. bun run reality: level 3 passes (builds/workflow-reality-20261014-120553).

TASK-43 review round 1 fixes applied (content M1, M2, m3-m5, notes; sources minors 1-2, note 4). The next anchor baseline is e9cf613 (bun run anchors e9cf613); against 6e93bad it reports false MOVED for hand-moved anchors. Owner questions drift 11 and a17 are now P-0018 items 8 and 9 (revision 2).
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
The Workflow Model is the one description of the client journey: client-workflow.md (373 to 222 lines), build-a-cv.md and the pdf-workflow Lifecycle now hold only reference detail headed Used by <step id> or Not a step; new-client and new-cv are step-ID checklists; facts the model lacked moved into stage README prose; 25 inventory items fixed, inventory deleted; client review renders and batch sheets now live in the cleared input folder; two new owner questions are P-0018 items 8 and 9. Walked a fictional client through both skills to export; bun run reality passes. Context rounds FINDINGS (2 lenses), FINDINGS, PASS. Suite PASS builds/tests-20261014-151137-713958, CI 38563765531 green.
<!-- SECTION:FINAL_SUMMARY:END -->
