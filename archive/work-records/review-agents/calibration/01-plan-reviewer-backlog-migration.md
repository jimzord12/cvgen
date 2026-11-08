# Calibration 01: plan-reviewer on the backlog-migration plan (known answer)

Run 2026-11-08 by the lead for TASK-74 AC 3. The plan-reviewer definition at
commit 8e3e65b, run as a general-purpose Opus agent told to follow
`.claude/agents/plan-reviewer.md` (the type was not yet registered). Repository
state: a detached checkout of 1e684eb, the commit before the migration; the plan
as committed in a46ba0c (`docs/work/backlog-migration/plan.md`, SHA-256
f6ea947853d506ca...), which had passed five rounds of an earlier plan review.

**Answer key** (gaps the implementation reviews found later, absent from the plan):
A. the route for record commits to `main` (the owner's push deny on `:main`
refspecs, a detached worktree that cannot `pull --rebase`, a stale local `main`);
B. status and label filters combine, so `-s ... -l blocked` misses a blocked
Queued task; C. a child task's Done goes on its parent branch, not `main`;
D. route cases when the `main` checkout holds the agent's own uncommitted work,
or the agent's own checkout is the one on `main`.

**Score:** 0 of 4. New findings later confirmed by events: P1 (comments and
attachments came up in the implementation reviews), P3 (the repo-maintenance
config later allowed `backlog/**/*.md`), P4 (the work was in fact reviewed by
the `context-reviewer`); P2 plausible. **Diagnosis:** the blind map traces what
files a change reaches; it never walks a new procedure through the situations
it will meet. All four misses are of that class. **Change:** the plan skill's
checklist gains question 12, "Procedures", and the plan-reviewer a step to walk
each new procedure; rerun as calibration 02.

The report, verbatim (the harness's one-line notice that it neutralised
control tags is omitted; the report contains no directive):

---

# Plan review round 1: backlog-migration-plan

**Verdict: FINDINGS.** 4 Material, 5 Minor, 2 Notes, no Blocking. Most of the plan matches the map I built from the code. The four Material findings would each cost rework, a failed check, or content that can't be taken back off GitHub.

Snapshot: `docs/work/backlog-migration-plan.md` (untracked) in the km-backlog checkout at 1e684eb. SHA-256 f6ea947853d506ca… matches the brief.

Blind map: code 3 · data/contracts 5 · tests 1 · generated 3 · docs/agent context 24 · tooling/CI 4 · in flight 2 · people/decisions 5 (47 items in total; the full map is under "Impact map" below).

Checklist:
1. Impact: mostly covered. Missed: card comments and attachments, the `repo-maintenance` audit config, `context-maintainer.md`, `AGENTS.md:47` (P1, P3, P6).
2. Fit: a public-content risk (P2); the wrong review gate (P4).
3. Facts: four wrong (P7, P8).
4. Compatibility: comments and attachments do not move (P1).
5. Reversibility: closing the board is reversible and that is said. Publishing card text to a public repository is not, and the plan does not say so (P2).
6. Verification: step 5's `/repo-maintenance quick` is clean will fail (P3); parity has no check for comments or attachments (P1).
7. Failure: no rule for a migration run that stops halfway (P9).
8. Sequencing: in-flight branches get a warning but no merge order (N1).
9. Unknowns: whether task numbers can clash between parallel sessions is untested (P10).
10. Decisions: the phone tradeoff, the `trello-cli` cancellation and closing the board are each raised for veto. Good.
11. Proportion: the approach is proportionate. Doing less, keeping only the export, would lose the agents' credential-free access the owner asked for.

## Findings

### P1 Material: card comments and attachments are not migrated, so "every old review report still links up" is unproven
Anchor: plan step 2, step 3 and "Task names stay the same"; `.claude/skills/trello/recipes.md:19` (links to dependencies and evidence go in as attachments); `docs/development.md:137-138` (review reports are "linked from the card"); `.night-shift/history/2026-09-28-a.json:18` (the owner's comments on card premium-text-draft).
Gap: step 2 copies only the name, description, checklist, label and the card URL as `--ref`. Comments, which include the owner's input, and attachments (review-report links, "Depends on" links) survive only in the export JSON. The parity check never counts them.
Consequence: once Trello is closed, some task records in `backlog/` are incomplete, and the claim that old review reports still link up is unproven.
Smallest fix: write each card's attachments as `--ref` and its comments (date and author) into the task notes. Add comment and attachment counts per task to the step 3 parity check. If you choose to keep them in the export only, say so as a decision.

### P2 Material: private card text reaches a public repository and only the export gets a client-data scan
Anchor: step 2 and step 7 (the export scan); `recipes.md:62` (the board was created `prefs_permissionLevel = 'private'`); `docs/constitution.md` §3; `docs/git-workflow.md:66-67` ("CI … cannot prevent that first publication").
Gap: the 26 task descriptions and the handoff doc are committed in steps 2-3 and merged and pushed to public `main`, but only the export is scanned for real client data.
Consequence: one real name in a card would be published to GitHub, and that cannot be taken back.
Smallest fix: run the same scan on `backlog/` (tasks and the handoff doc) before the first commit of step 2 or step 3, and before any push. In "Rollback", state that publication is irreversible.

### P3 Material: `/repo-maintenance quick` will not come back clean
Anchor: step 5; `.claude/skills/repo-maintenance/scripts/audit.py:17,227` (N2, part of the quick set, flags any filename containing a space as Medium), `audit.py:233,247` (N3 flags any folder with more than 25 entries); `.claude/repo-maintenance.md:65-67`.
Evidence: in the installed backlog 1.55.3, the binary's naming code builds `${id} - ${sanitizeFilename(title)}.md`, so every task filename contains spaces. `backlog/tasks/` will also hold 27 or more files.
Smallest fix: name `.claude/repo-maintenance.md` as a file to change: add `backlog/**` to `allow_names` and `entry_points`, and handle the folder-size limit. Check that the 1.52.0 filename format is the same.

### P4 Material: the plan uses the wrong review gate
Anchor: step 6 (`code-reviewer` only); `docs/review.md:9-17`.
Gap: most of the change is agent context (`AGENTS.md`, `docs/`, skills, agents, glossary, an ADR). The repository's rule sends agent-context changes to a fresh `context-reviewer`, and a change that mixes code and context to both reviewers. Owner feedback that changes how agents behave also goes through the `context-maintainer` first.
Smallest fix: run `context-reviewer` together with `code-reviewer` (or `code-reviewer` alone for the script and `config.yml`), and keep the round budget.

### P5 Minor: `docs/framework-gaps.md` entries are dated records
Anchor: step 4's word-swap list; `.claude/agents/context-maintainer.md:50-54` (its entries are never edited; a later fact goes in an `Update:` line).
Fix: move those entries to "Not rewritten" and allow them in the wording check.

### P6 Minor: references missing from the step 4 list
`.claude/agents/context-maintainer.md:53` ("the Trello cards") and `AGENTS.md:47` ("a second status file or backlog") are not named. The step 7 wording check would catch the first, but its pattern does not match the second.

### P7 Minor: wrong line references
The record-keeping exemptions are at `review.md:50-54`, not 42-46. The round cap is at `review.md:192-196`, not 184-188. "Five Atlas pages": `client-journey.json` has no Trello, card or board text, and `site.json` is not a page.

### P8 Minor: wrong proposal status claims
`kanban-tooling-research.md` is `kind: reference` and has no status line to set to "applied". "Superseded" is not a state in `docs/proposals/README.md`. Fix: add a dated entry to `trello-free-trial.md` linking to ADR 0014. Separately, step 1 copies only a *summary* of the five earlier rounds, but `review.md` says reports are stored unchanged.

### P9 Minor: no rule for a migration run that stops halfway
The script refuses to run when `backlog/tasks/` is not empty, but nothing says how to retry after a crash halfway (discard the uncommitted files under `backlog/`, then rerun). Also in step 1, the `--include-remote false` fallback is checked only after init has already run.

### P10 Minor: task numbers in parallel sessions are untested
New Queued tasks are created on `main` from short-lived worktrees while `remote_operations` is off. Fix: in step 1, run a small experiment: create tasks in two worktrees, then push both, and check the numbers don't clash.

### N1 Note
The branches named in step 7 touch `.atlas/` and `docs/`, which the plan also rewrites. Merging them before step 4 avoids conflicts in the generated `atlas.data.js` and `atlas.lock.json`.

### N2 Note
The owner's Trello key and token, held in his PowerShell profile, are never revoked. The export may also contain Trello member names and usernames, which will be public.

## Impact map
(C = the plan covers it, M = the plan misses it, X = the plan excludes it on purpose)

- **Code:** the `trello` skill (`SKILL.md`, `recipes.md`, `trello.ps1`) C; the new `backlog` skill C; the migration script C.
- **Data:** cards C; checklists C; the Blocked label C; comments and attachments M (P1); the handoff card C; `backlog/config.yml` C.
- **Tests:** comment in `tests/workflow.py:321` (the wording check reaches it).
- **Generated:** `.atlas/src` site and pages C; `atlas.data.js` and `atlas.lock.json` (rebuilt) C.
- **Context:**
  - `AGENTS.md` C, except line 47 (M);
  - `development.md` C; `review.md` C; `preferences.md`, `git-workflow.md`, `glossary.md`, `client-workflow.md` C;
  - `framework-gaps.md` C, but wrongly (P5);
  - `brand/README.md` C; ADR 0011 X; `history.md` C;
  - proposals X; `docs/work/**` X; `.night-shift` X;
  - `idea-run` and `new-client` skills C;
  - agents ceo, ceo-reviewer, code-reviewer, design-reviewer, magazine-editor C; context-maintainer M;
  - `.codex` README and tomls C.
- **Tooling:**
  - `.claude/repo-maintenance.md` wording C, audit config M (P3);
  - CI `verify.yml`: not affected;
  - `.claude/settings.json` C;
  - `tech-stack.md` C.
- **In flight:** see N1; the one Review card, `travel-recalibration`, C.
- **People:** the phone board C; closing Trello C; the public repository M (P2); review gate M (P4); credential revocation M (N2).

## Facts checked
- `development.md:111-112` and `repo-maintenance.md:134` hold "no second backlog": true.
- `brand/README.md:139` mentions the Trello board: true.
- `review.md:42-46` and `:184-188`: false (P7).
- Trial doc line 60 is the phone reason: true.
- The CLI flags `init --integration-mode/--agent-instructions/--check-branches/--include-remote/--defaults`; `task create -s -d --ref --ac -l --no-dod-defaults --plain`; `task edit --check-ac --append-notes --add-label/--remove-label`, with `-l` replacing all labels; `doc create`; `browser --no-open`: all true in 1.55.3, not checked in 1.52.0.
- The config's camelCase keys are documented; the snake_case YAML names the plan uses are unconfirmed (step 1 already re-reads the generated file).
- ADR 0014 is the next free number: true (the last is 0013).
- `.claude/settings.json` is tracked and has no permissions block: true.

## Limitations
- I could not read the live board, so these are unverified: 27 cards, the counts per list, and which cards have comments or attachments.
- Unverified: the installed 1.52.0 and latest 1.53.0 versions, and issue #1038. I checked the 1.55.3 CLI only, through read-only help and strings in its binary.
- The branches the plan names do not appear in the snapshot (1e684eb says every branch was merged), so I couldn't confirm the in-flight work.
- I did not read the five earlier review rounds; they are not in the checkout.

## Verdict: FINDINGS
