# Workflow Model: gaps found while encoding (TASK-37)

The YAML in this folder encodes what the sources say today (`main` at
`70631ed`, the owner's decisions of 2026-10-14 in
`docs/proposals/workflow-model.md`). Where the sources are silent or
disagree, the entity follows them and the gap is listed here. Nothing below
is decided by the model; each item waits for the owner (product) or for a
later task (model and prose). Goes when the items are settled.

## For the owner

1. **Loop caps no source sets.** The types need a cap on every loop. These
   carry a placeholder:
   - `loop.draft-correction`: 1, from "one batch per round" (the text draft
     "plus a corrected draft", `docs/guides/client-workflow.md:370-372`).
   - `loop.revision-fix`, `loop.wording-fix`, `loop.owner-changes`
     (`06-deliver`) and `loop.library-review` (`03-research`): the general
     review cap of `docs/review.md:198-202`, 5 attended and 10 unattended
     (`loop.owner-changes` 5 only).
   - `loop.research-rounds`: 3, the `Deep Dive` count; the executive's 6
     (`client-workflow.md:241-242`) cannot be written as a second cap.
2. **Repeats the owner decides, with no path or cap.** Asking for consent
   again (`client-workflow.md:191-192`) and a second follow-up
   (`client-workflow.md:275-276`) are one owner step each
   (`intake.no-consent`; the follow-up rule sits in `lead.update-facts`), not
   loops.
3. **The client's task (decision #7).** No source says when it is created,
   or its title and stage; encoded as `open.task-create`, once the `Alias`
   exists, and closed by `after.close`.
4. **The keep request (decision #3).** The `envelope.json` field has no
   name, and `envelope()` (`packages/cv-workflow/cv_workflow/outputs.py:57-74`)
   reads only alias, domain, candidate and rank, so nothing checks it.
5. **Concepts parked or rejected for a client.** `design.record-other-answer`
   records the answer; no source says what happens to that client's CV.
6. **Where `Text Draft` corrections go.** "Corrections make the next number"
   (`client-workflow.md:306-307`) does not say where they are kept before it;
   encoded as `facts.md` (`text.corrections`).
7. **Library-note review reports, two places.** `client-workflow.md:257-258`
   and `new-client` (`SKILL.md:51-52`) say `docs/work/research-<topic>/reviews/`;
   `docs/research/README.md:29-30` says `docs/work/<task or client-free id>/reviews/`.
   Encoded with the guide.
8. **The preview command for the `design-reviewer`.** `new-cv`
   (`SKILL.md:75-76`) names the folder, not the command; encoded as the
   lead's own act (`lead.compile-previews`).

## Decisions the prose does not carry yet (for TASK-43)

The model follows the decisions of 2026-10-14; these sources still say
otherwise or nothing:

- #1: `client-workflow.md:330` and `new-client` (`SKILL.md:76-77`) write
  "Delivered <date>. Delete by ..."; the model writes "Exported <date>,
  delete by <date>" at `Export` (the lead's default wording).
- #3: `docs/pdf-workflow.md:211` retains approved revisions and their copies
  with no limit; the model deletes 12 months after `Export` unless the
  client asks to keep.
- #4: `new-cv` (`SKILL.md:68-86`) runs the `design-reviewer` loop only when
  the `Domain` has no `Template`; the model runs it for every client CV.
- #5: `new-cv` (`SKILL.md:111-112`) names no one for `Export`; the model
  gives it to the lead, after `Approval`.
- #6, #7: no guide or skill has the engine change through code review
  (`design.engine-change`, `design.engine-review`) or the client's task
  (`open.task-create`, `after.close`).
- The stall rule: "three months without progress"
  (`client-workflow.md:333-336`) against "no `Export` three months after
  intake" (`new-client`, `SKILL.md:97-99`); the model cites both.

## For the workflow tool (TASK-38)

- **Gates are binary.** A three-way choice is a chain of two gates:
  `gate.template-exists` (fail: an `Idea Run`), then `gate.template-fits` on
  `design.flagship-fit` (Flagship or a custom composition). A choice that is
  not a check (chat or form, voice messages, a test answer) is a `when` text.
  A code refusal with no stated next step (`approve`, `export`, `stamp`)
  stays in its action's description; `render`'s is `gate.render-ok`, since
  `build-a-cv.md:128-136` states the next step (a new `Revision`).
- **The per-item repeat** is the `when` text "Once per Deep Dive question the
  owner chose." on every `Deep Dive` step.
- **Versions of one file.** A file rewritten later in the flow and read
  earlier gets one ID per version, so derived edges run forward:
  `facts.md` (`art.facts-md`, `art.facts-final`), `messages.md`
  (`art.messages-md`, `art.messages-follow-up`), `README.md` (one ID per line
  or section).
- **In-place edits still join loops.** `typst/cv.typ` and `candidate.json`
  are written in design and edited again by `design.fix` and `deliver.fix`,
  so the derived edges merge the design and deliver loops into one cycle of
  16 steps with five declared loops. The check needs a rule for this, or
  those steps their own artifact IDs.
- **Order with no data between steps.** `design.clear-review-input` before
  `deliver.render`, and `design.record-choice` before `design.fill-data` on
  the one-off path, follow only from the gates.
- **Visibility of `builds/`.** The reviewer's previews and the page PNGs are
  neither tracked, under `private/` nor with a third party; encoded
  `ephemeral`. The types may want a value for an ignored local file.
- **Anchors.** All resolve on disk today, with no backslashes. The implicit
  steps cite `docs/work/workflow-model/handoff.md:290`, which TASK-52 may
  move.
