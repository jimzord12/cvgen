---
name: idea-run
description: Run CVgen's idea agents in a closed review loop - the ceo (product proposals) or the magazine-editor (template concepts with mock-up PDFs) - with their reviewers until PASS. Use when the owner asks for new product ideas, design concepts or template inspiration, or when an overnight plan includes an idea run.
---

# Idea run

The lead (you) runs the loop. The agents' tool lists leave out `Agent` on
purpose, so they cannot start each other: every reviewer round then starts
fresh, the caps are enforced in one place, and the loop is visible in the
run record. Authors propose, reviewers judge, the owner decides. Nothing from a run is built,
approved or put on the roadmap without the owner.

| Run | Author | Reviewers, in order | Output |
|---|---|---|---|
| Product ideas | `ceo` (max 3 ideas) | `research-reviewer` on the market research, then `ceo-reviewer` | `docs/proposals/<slug>.md` (`status: pending`) |
| Design concepts | `magazine-editor` (2-3 concepts) | `research-reviewer` on the references, then `design-reviewer` | `design-concepts/<date>-<slug>/` with PDF and PNG |

Cadence: design concepts whenever the owner wants inspiration; product
ideas weekly at most (the roadmap is long, the owner's attention is not).

## Loop

1. Branch `ideas/<date>-<ceo|editor>` (worktree if other work is running).
   Record the run in `docs/work/idea-runs/<date>-<ceo|editor>/run.md`:
   brief, rounds, verdicts, what reached the owner.
2. Start the author with the date and any owner steer (a field, a mood, a
   problem). Keep its agent id: revisions go back to the same author with
   SendMessage so it keeps its context.
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
6. Store every report as `docs/work/idea-runs/<run>/reviews/NN-<reviewer>.md`.
7. Integrate: commit, merge to `main`, push (routine Git, no approval
   needed). Proposals stay `pending`; concepts stay `proposed`.

## Bar (give it to every reviewer as is)

Decently strict, not perfectionist. The niche is custom, unique, premium
work: fail generic, copied, broken or unsupported work; taste and polish
are Notes, never blocking.

## What the owner gets

A short message: each concept's PDF link and three-word idea, or each
proposal's one-line pitch and link; which items were dropped or are
`unresolved`; the rounds each gate took. He answers with keep, park or
reject; record that in the proposal or in `design-concepts/README.md`.

## When an agent file is new

Subagent definitions load when a session starts. If the harness does not
list one yet, run a `general-purpose` agent told to act exactly as the
file in `.claude/agents/` defines; say so in the run record.
