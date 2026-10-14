# Workflow Model: what the YAML holds in place of a source (TASK-37)

The YAML in this folder encodes what the sources say (`main` at 362f004, after TASK-47,
and the owner's decisions of 2026-10-14 in `docs/proposals/workflow-model.md`).
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

## What the YAML leaves out

- **The refusals of `approve`, `export` and `stamp`.** A `cmd` action holds
  only its command line, so their refusals (bytes changed, no receipt, a
  status without its proof) are not encoded anywhere in the model; only
  `render`'s is, as `gate.render-ok`, because `build-a-cv.md:128-136` states
  the next step.
