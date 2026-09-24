---
name: idea-run
description: Run CVgen's idea agents in a closed review loop - the ceo (product proposals) or the magazine-editor (template concepts with mock-up PDFs) - with their reviewers until PASS. Use when the owner asks for new product ideas, design concepts or template inspiration, or when an overnight plan includes an idea run.
---

# Idea run

The lead (you) runs the loop. The agents' tool lists leave out `Agent` on
purpose, so they cannot start each other: every reviewer round then starts
fresh, the caps are enforced in one place, and the loop is visible in the
run record. Authors propose, reviewers judge, the owner decides. Nothing from
a run is built, approved or put on the roadmap without the owner.

| Run | Author | Reviewers, in order | Output |
|---|---|---|---|
| Product ideas | `ceo` (max 3 ideas) | `research-reviewer` on the market research, then `ceo-reviewer` | drafts in the run folder; passed ones moved to `docs/proposals/<slug>.md` (`status: pending`) |
| Design concepts | `magazine-editor` (2-3 concepts) | `research-reviewer` on the references, then `design-reviewer` | `design-concepts/<date>-<slug>/` with PDF and PNG |

Cadence: design concepts whenever the owner wants inspiration; product
ideas weekly at most (the roadmap is long, the owner's attention is not).

## Loop

1. Branch `docs/idea-run-<date>-<ceo|editor>` (worktree if other work is
   running). The run folder is `docs/work/idea-runs/<date>-<ceo|editor>/`,
   with `-2`, `-3` for a second run the same day. Record the run in its
   `run.md`: brief, rounds, verdicts, what reached the owner.
2. Start the author with the date, the run folder and any owner steer (a
   field, a mood, a problem). For the ceo, paste the board's card list
   (`trello.ps1 -Cards 'CVgen'`) into the brief; it has no shell. Keep the
   author's agent id: revisions go back to the same author with SendMessage
   so it keeps its context.
3. Research gate: a fresh `research-reviewer` per round on the author's
   sources (ceo: the market research in the run record; editor: the
   references in each `brief.md`). FINDINGS -> send the report to the
   author, then review again.
4. Quality gate: a fresh `ceo-reviewer` or `design-reviewer` per round, with
   all earlier reports and the author's replies. FINDINGS -> author revises
   -> review again. A reviewer starts fresh each round on purpose: judges
   drift towards whatever they have already seen.
5. Round cap per gate (owner, 2026-09-25): **5 when the owner is attending,
   10 unattended.** At the cap, the item is not dropped silently: it reaches
   the owner marked `unresolved` with the reviewer's last reason. An author
   may drop an item instead of fixing it; say so in the run record.
6. Edits after a PASS: a change that adds or alters a sourced claim goes
   back through the research gate; a layout-only change is checked by the
   lead against the render and noted in `run.md`. Name the file revision (or
   commit) each review saw in its report.
7. Store every report as `docs/work/idea-runs/<run>/reviews/NN-<reviewer>.md`.
8. Integrate. Output confined to new files in `design-concepts/`, the run
   folder and passed proposals in `docs/proposals/` is covered by the idea
   gates; say so in `run.md`. Any other change (agent files, skills, engine,
   docs outside those) goes through `docs/review.md` first. Then commit,
   merge to `main`, push (routine Git, no approval needed). Proposals stay
   `pending`; concepts stay `proposed`.

## If an agent file cannot be started by name

Subagent definitions load when a session starts. If the harness does not
list one yet, run a `general-purpose` agent told to act exactly as the file
in `.claude/agents/` defines, paste the file's `tools:` line into the brief
as a hard limit, and after every round run `git status --porcelain` in the
worktree and note in `run.md` that only the expected files changed.

## Bar (give it to every reviewer as is)

Decently strict, not perfectionist. The niche is custom, unique, premium
work: fail generic, copied, broken or unsupported work; taste and polish
are Notes, never blocking.

## What the owner gets, and what his answer does

A short message: each concept's PDF link and three-word idea, or each
proposal's one-line pitch and link; which items were dropped or are
`unresolved`; the rounds each gate took. He answers keep, park or reject:

| Answer | Proposal (`docs/proposals/README.md`) | Concept (`design-concepts/README.md`) |
|---|---|---|
| Keep, build it | `approved` (then a card) | `chosen`; a template card follows |
| Keep for later | stays `pending` | stays `proposed` |
| Park | `deferred` | `parked` |
| Reject | `rejected`, moved to `rejected/` | `rejected`; its folder is removed (Git history keeps it) and the README row names the commit |
