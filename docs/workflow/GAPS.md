# Workflow Model: what the YAML holds in place of a source (TASK-37)

The YAML in this folder encodes what the sources say (`main` at 362f004,
after TASK-47, and the owner's decisions of 2026-10-14 in
`docs/proposals/workflow-model.md`).
Where the sources are silent, the YAML holds an inference, and points
here. This file explains each one; it decides nothing and tracks nothing:

- the owner's decisions on the placeholder caps and on the points the
  sources left to him are in
  [`docs/proposals/workflow-gaps.md`](../proposals/workflow-gaps.md)
  (P-0018, applied 2026-10-22), which the YAML cites;
- the model's open questions are in the notes of TASK-38 (workflow-check);
- since TASK-43 the guides and skills are meant to describe no step;
  prose found to disagree with the model is fixed in the prose.

It goes once those are settled.

## Inferences

- **Where `Text Draft` corrections go** (`text-draft.corrections`): "corrections
  make the next number" (`04-text-draft/README.md`, "A sent draft is frozen") does not say where
  they are kept before it; the YAML uses `facts.md`, where every other fact
  lives.
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

- **Repeats that are not loops** (P-0018 items 2, 3 and 7): asking for consent
  once more (`intake.no-consent`), each further follow-up on the owner's
  word (`lead.update-facts`) and a new `Idea Run` after the owner parks
  or rejects every concept (`design.record-other-answer`) are rules in
  their step's text, not loops: the single repeat of item 2 is part of its step,
  and a loop needs a cap, which the owner set for neither of the other two.
- **The `Stopped <date>: <reason>` line** (P-0018 item 6): the lead writes
  it into the `Envelope`'s `README.md` (`art.envelope-readme`'s format,
  `manual.decide-on-no-consent`), but no step outputs it: `open` reads
  that `README.md`, so an intake step writing it would close a cycle.
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
  `docs/workflow/05-design/stage.yaml:485-490`): the artifact gives a folder
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
