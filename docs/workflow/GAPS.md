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
- the prose that still says otherwise is in the notes of TASK-43
  (workflow-consolidate).

It goes once those are settled.

## Placeholder loop caps

The types need a cap on every loop; these loops name themselves "(placeholder
cap)" and cite their row here.

| Loop | Cap in the YAML | What the sources say |
|---|---|---|
| `loop.draft-correction` | 1 attended | No cap; "one batch per round" allows the text draft "plus a corrected draft" (`docs/guides/client-workflow.md:370-372`) |
| `loop.research-rounds` | 3 attended | No cap on rounds; 0-3 Deep Dives per client, up to 6 for an executive (`client-workflow.md:241-242`), which a second cap cannot express |
| `loop.library-review` | 5 attended, 10 unattended | No cap for a library note; `docs/review.md:198-202`'s general reviewer cap |
| `loop.revision-fix` | 5 attended, 10 unattended | No cap; a failed render's fix is a new Revision (`docs/guides/build-a-cv.md:128-130`) |
| `loop.wording-fix` | 5 attended, 10 unattended | No cap; the example wording must go before approving (`build-a-cv.md:98-103`) |
| `loop.owner-changes` | 5 attended | No cap; the owner's change means a new Revision (`build-a-cv.md:174-176`) |

## Inferences

- **Where `Text Draft` corrections go** (`text-draft.corrections`): "corrections
  make the next number" (`client-workflow.md:306-307`) does not say where
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
  deleted on his word (`client-workflow.md:333-338`); no step records that
  the client stopped.
- **Concepts parked or rejected for a client** (`design.record-other-answer`):
  no source says what happens to that client's CV.
- **Repeats the owner decides**: asking for consent again
  (`client-workflow.md:191-192`) and a second follow-up
  (`client-workflow.md:275-276`) are one owner step each, not loops.
- **What starts a keep request** (`after.keep-request`): no source says when
  the client asks; the YAML reads the intake questions, whose consent text
  offers it (`client-workflow.md:164-167`). Added by TASK-38: a step with no
  inputs is reached only as a loop's escalation step.
- **How Revisions to remove are found** (`after.revision-cleanup`):
  `pdf-workflow.md:213-216` names failed or unapproved Revisions as
  candidates, not how they are listed; the YAML reads `cv.py status`, which
  lists every Revision with its state. Added by TASK-38, for the same reason.

## What the YAML leaves out

- **The refusals of `approve`, `export` and `stamp`.** A `cmd` action holds
  only its command line, so their refusals (bytes changed, no receipt, a
  status without its proof) are not encoded anywhere in the model; only
  `render`'s is, as `gate.render-ok`, because `build-a-cv.md:128-136` states
  the next step.
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
  `docs/workflow/05-design/stage.yaml:476-481`): the model gives a folder and
  "PDF previews", no file names, so level 3's stand-in for `design.preview`
  makes an empty folder and the stand-in review accepts it. Added by TASK-42.
- **What the hand-written `Atlas` page said and the model does not** (TASK-41,
  when the client-journey page became generated from the model). Each still
  lives in its source; TASK-43 decides whether it becomes a model fact:
  - the lead never opens the client's LinkedIn page; its PDF export is
    enough (`client-workflow.md:193-194`);
  - what the consent covers: AI tools and web research, private files,
    never published, deleted 12 months after delivery
    (`client-workflow.md:164-167`); the model names only "consent first";
  - the `Text Draft` underlines each fact with the copper `Fact Mark`
    (`client-workflow.md:284-285`);
  - the render checks (page count, no empty page, fonts embedded, text
    inside the page, every font family bundled) and the `Certificate
    Warning` 180 days ahead, which never blocks (`build-a-cv.md:126-128`, `build-a-cv.md:140-144`);
  - a new `Revision` inherits no approval (`build-a-cv.md:205-206`,
    `pdf-workflow.md:191`); a `cmd` action has no text to say it in;
  - the `Design Review` app shows the concepts with their status, where the
    owner may look before he picks (`.claude/skills/idea-run/SKILL.md:127-128`);
  - what the commands refuse, which a `cmd` step cannot say: `approve`
    refuses when the bytes changed since the render, the checks failed or
    are stale, or the hash passed does not match (`build-a-cv.md:181-183`);
    `export` never compiles and verifies its copy (`build-a-cv.md:189-192`);
    the stamp refuses `delivered` without the approval receipt and a verified
    `Export` (`build-a-cv.md:203-204`), and `signed-off` without the
    `Sign-off` screenshot (`pdf-workflow.md:146-151`);
  - Drive's Trash keeps deleted files 30 days (`client-workflow.md:336-338`).
  The page's "where it stands" panel (one client, as of 2026-10-04) is not a
  workflow fact and was dropped: it was out of date (the delivery is
  recorded) and a client's state belongs in its task (`art.client-task`).
