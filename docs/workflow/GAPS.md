# Workflow Model: what the YAML holds in place of a source (TASK-37)

The YAML in this folder encodes what the sources say (`main` at 362f004,
after TASK-47, and the owner's decisions of 2026-10-14 in
`docs/proposals/workflow-model.md`).
Where the sources are silent, the YAML holds a placeholder or an inference,
and points here. This file explains each one; it decides nothing and tracks
nothing:

- the owner's decisions wait in the pending proposal
  [`docs/proposals/workflow-gaps.md`](../proposals/workflow-gaps.md) (P-0018);
- the model's open questions are in the notes of TASK-38 (workflow-check);
- since TASK-43 the guides and skills are meant to describe no step;
  prose found to disagree with the model is fixed in the prose.

It goes once those are settled.

## Placeholder loop caps

The types need a cap on every loop; these loops name themselves "(placeholder
cap)" and cite their row here.

| Loop | Cap in the YAML | What the sources say |
|---|---|---|
| `loop.draft-correction` | 1 attended | No cap; "one batch per round" allows the text draft "plus a corrected draft" (`docs/workflow/README.md`, "One batch per round") |
| `loop.research-rounds` | 3 attended | No cap on rounds; 0-3 Deep Dives per client, up to 6 for an executive (`03-research/README.md`, "Every decision gets an answer"), which a second cap cannot express |
| `loop.library-review` | 5 attended, 10 unattended | No cap for a library note; `docs/review.md:198-202`'s general reviewer cap |
| `loop.revision-fix` | 5 attended, 10 unattended | No cap; a failed render's fix is a new Revision (`docs/guides/build-a-cv.md` section 3, "render") |
| `loop.wording-fix` | 5 attended, 10 unattended | No cap; the example wording must go before approving (`gate.example-wording`) |
| `loop.owner-changes` | 5 attended | No cap; the owner's change means a new Revision (`06-deliver/README.md`, "Only a Revision counts") |

## Inferences

- **Where `Text Draft` corrections go** (`text-draft.corrections`): "corrections
  make the next number" (`04-text-draft/README.md`, "A sent draft is frozen") does not say where
  they are kept before it; the YAML uses `facts.md`, where every other fact
  lives.
- **The client's task** (`open.task-create`): decision #7 names the task and
  `after.close`, not when the task is created; the YAML creates it once the
  `Alias` exists.
- **The keep request** (`art.envelope-keep`): decision #3 makes it a field in
  `envelope.json` with no name; `envelope()`
  (`packages/cv-workflow/cv_workflow/outputs.py:57-74`) reads only alias,
  domain, candidate and rank.
- **Stopped clients** (`intake.no-consent`, the `after` erase steps): a client
  who never reaches `Export` is named to the owner after three months and
  deleted on his word (`after.stall-check`, `07-after/README.md`); no step records that
  the client stopped.
- **Concepts parked or rejected for a client** (`design.record-other-answer`):
  no source says what happens to that client's CV.
- **Repeats the owner decides**: asking for consent again
  (`02-intake/README.md`, "Branches") and a second follow-up
  (`03-research/README.md`, "The one follow-up") are one owner step each, not loops.
- **What starts a keep request** (`after.keep-request`): no source says when
  the client asks; the YAML reads the intake questions, whose consent text
  offers it (`client-workflow.md` section 2, question 1). Added by TASK-38: a step with no
  inputs is reached only as a loop's escalation step.
- **How Revisions to remove are found** (`after.revision-cleanup`):
  `pdf-workflow.md`, "Retention and migration", names failed or unapproved Revisions as
  candidates, not how they are listed; the YAML reads `cv.py status`, which
  lists every Revision with its state. Added by TASK-38, for the same reason.
- **Whether a fix after the design review needs another review**
  (`deliver.fix`): it rewrites `typst/cv.typ` and `candidate.json`, which
  `design.preview` reads, so in the model a fix after a failed render,
  example wording or the owner's change feeds the design preview again;
  no source says whether such a fix needs another `design-reviewer`
  round. Added by TASK-43, from TASK-40's review.

## What the YAML leaves out

- **What the scripts print and refuse.** A `cmd` action holds only its
  command line, so `render`'s checks and `Certificate Warning`, and the
  refusals of `approve`, `export` and `stamp`, are not model facts; only
  `render`'s outcome is, as `gate.render-ok`. They are reference detail in
  `docs/guides/build-a-cv.md` section 3 (TASK-43).
- **The folder the page images go into** (`deliver.page-png`): its command
  (`docs/workflow/06-deliver/stage.yaml:309-315`, from
  `.claude/skills/verify-cv/SKILL.md:72-76`) saves into
  `builds/<new-folder>/` but nothing makes that folder; level 3 makes it
  first, as the lead does. Added by TASK-42.
- **Order without data**: `design.clear-review-input` before
  `deliver.render` follows from gates only; render reads nothing the design
  review writes (`docs/workflow/06-deliver/stage.yaml:16-22`), so level 3,
  which runs a step once what it reads exists, renders beside
  `design.preview`, before the review returns. Added by TASK-42.
- **What the preview folder holds** (`art.design-review-input`,
  `docs/workflow/05-design/stage.yaml:482-487`): the artifact gives a folder
  and "PDF previews" (since TASK-43 its action names `cv.pdf`, from the
  `new-cv` skill's command), so level 3's stand-in for `design.preview`
  makes an empty folder and the stand-in review accepts it. Added by TASK-42.
- **The second design reviewer** (`design.run-design-gate`,
  `design.client-review`): a step has one actor, so the
  `codex-visual-reviewer` that judges the same pages beside the
  `design-reviewer` (P-0014) shows only in those steps' names, their gates'
  checks and the report artifacts' formats; it is no actor of its own, and
  the actors table and the `Atlas` client journey show one reviewer. Added
  by TASK-4.
