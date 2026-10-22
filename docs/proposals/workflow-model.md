---
id: P-0017
kind: proposal
status: applied
revision: 1
created: 2026-10-14
---

# Workflow model: one checked description of the client workflow

Origin: the 2026-10-04 audit and the workflow-model design discussion of
2026-10-04/05 (cloud session), handed over in
[the workflow-model handoff](../../archive/work-records/workflow-model/handoff.md). Source, not
approved scope: [the inventory](../workflow/inventory/README.md); where an
answer below differs from its recommendation, the answer wins. Applied by
the tasks TASK-28 to TASK-57 in `backlog/tasks/`.

## Problem

The client workflow, from first contact to deletion, is written in 4 to 11
places per stage (the guides, the `new-client` and `new-cv` skills, the
`Atlas`), and those places disagree. Only render, approval and export are
enforced by code or tests. The inventory found 34 drift items, 53 conflicts
or gaps, and nine conflicts that change behaviour and need the owner.

## Smallest suggested change

The design agreed with the owner on 2026-10-05 (handoff section 3): YAML
facts per stage, a TypeScript engine that type-checks them and checks the
flow, generated docs, diagrams and `Atlas` pages, and the old prose
descriptions removed so the model is the only source. The work is TASK-33
to TASK-44; the restructure tasks TASK-45 to TASK-57 come from the same audit,
and TASK-28 to TASK-32 from the owner's repository walk-through of 2026-10-06.

## Consequence

One source for the workflow: a change to a step is made once, checked by
the suite, and every view regenerates. Scripts refuse out-of-order states.

## Recommendation and decision requested

Answer the nine conflicts and the open restructure questions, so the tasks
can run unattended. Recommendations are in the inventory README.

## Decisions

Owner, 2026-10-14, in an interview (Claude Code session, the Questions
Tool). The owner's chosen option is quoted.

### The nine workflow conflicts (inventory README, "Decisions for the owner")

| # | Question | Owner's answer | What it means |
|---|---|---|---|
| 1 | When is "Delivered, delete by" written? | "At export" | The delete-by date is written when the approved `Revision` is exported, together with the export, and the 12 months count from `Export`. With #5, every send now follows an `Export`, so the date is at most a few days earlier than "12 months after delivery" in the consent text, which stays as it is. Lead's defaults, open to the owner: the `Envelope` README line becomes "Exported <date>, delete by <date>"; the one existing record (`client-2026-09-01`, date written at delivery, `Export` never run) keeps its date. |
| 2 | The `Text Draft` is stamped `sent` before it is sent | "Add a 'ready' status" | Compiling stamps `ready`; `sent` only when the owner confirms he sent it. |
| 3 | How long is client data kept? | First "Keep forever"; after the lead's pushback (the consent text already promises deletion 12 months after delivery, and EU data rules need a reason for unlimited keeping), "12 months after all" | Delete 12 months after `Export` unless the client asks to keep; a keep request is a field in `envelope.json`. No consent text change. |
| 4 | Does every client CV get a `design-reviewer` round? | "Every client CV" | Template-built CVs too, since every one must pass the `Batch Test`. |
| 5 | Who runs `Export`? | "Claude, after you approve" | The owner approves the exact PDF; Claude runs `export` and checks the copy. |
| 6 | Can one client's job change the public engine? | "Only via code review" | Allowed only through the normal `code-reviewer` gate; a one-off's own assets stay in its `Envelope`. |
| 7 | Is a client tracked as a task, with a closing step? | "Yes, one task per alias" | One Backlog.md task per `Alias` (never the real name: `backlog/` is public), closed by a final `after.close` step at deletion. |
| 8 | Should the scripts enforce the order of states? | "Yes, scripts refuse" | `outputs.py stamp` refuses `approved` without a receipt, `delivered` without an `Export`, `signed-off` without the screenshot. |
| 9 | The `reviews/text-NN.md` file | "Remove it" | Dropped from the `Envelope` layout and the docs; the client checks the `Text Draft` at `Sign-off`. |

### Other workflow-model questions

- **Length of `docs/workflow/README.md`:** "200-300 lines" (overview with a
  diagram and a short section per stage; details live in the stage files).
- **TASK-36, the types:** "No, proceed; show me at the end". The lead builds
  on the types unattended and explains them, with an example, in the final
  report.

### Restructure questions

- **TASK-50, large files:** "Keep in repo, dedupe fonts" after the lead
  explained Git LFS (pointer files, an install on every machine, no shrink
  of existing history without a force push). Release PDFs and README images
  stay; only the fonts stored twice are deduplicated.
- **TASK-52, review reports:** "Move to archive/". `docs/work/` moves to an
  archive folder; new reports go there too, by task.
- **TASK-53, review effort:** "Keep the loop for all". No change to
  `docs/review.md`: every non-trivial change loops until PASS (round caps in
  `docs/review.md`).
- **TASK-55, folder moves:** "Go ahead, report after". The lead makes the
  moves unattended (history kept, links fixed, suite passing); the report
  shows the tree before and after.
- **TASK-57, GitHub description:** "Hand-crafted, premium CVs made with AI
  on a custom Typst framework, for any profession." Applied by the lead on
  2026-10-14 right after the owner chose the text, with
  `gh repo edit jimzord12/cvgen --description "<that text>"`. The exact
  command was not shown to him first, as `docs/preferences.md` asks for a
  repository settings change; the lead discloses this in its report. The
  previous text was "Three distinctive marine and mechanical engineer resume
  prototypes built with Typst".
- **TASK-31, name for `docs/reference`:** "docs/engine".
- **Scope:** "All 30 queued tasks" (TASK-28 to TASK-57) run unattended, in
  dependency order, each on its own branch, reviewed and merged, with one
  report at the end.

## Application

Applied by the tasks above; each records its evidence in its own task.
- 2026-10-22, owner: marked `applied`; the change has been in effect since its tasks closed, and they hold the evidence.
