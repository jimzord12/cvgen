---
id: doc-1
title: session-handoff
type: other
created_date: '2026-10-06 07:25'
---

# session-handoff

Rewritten in place at the end of every session; the first thing a fresh session reads after AGENTS.md. Holds only what no task owns: what is next, parked owner decisions, machine facts, pitfalls. Task state stays in the tasks in `backlog/tasks/`.

**Written:** 2026-11-08, owner answers, Stage 1 review, milestones (Claude Code).
**Main at:** `c088700`.

## Where things stand
- Task store: Backlog.md 1.55.3 (ADR 0017). Every task belongs to one of nine milestones; progress: `backlog milestone list --plain --show-completed`. Plan, then milestones, then tasks (`docs/development.md`, "The flow").
- TASK-69 (backlog-milestones) is merged and Done. The plan-reviewer agent and its gate in `docs/review.md` were left to another agent at the owner's word.
- `main`'s CI was red from the Report Template merge (2026-11-04) until `2d23778`: Linux Python worded a NaN error differently. Fixed; GitHub also gave 504s on the Typst download on 2026-11-08 (rerun clears them).
- `docs/owner-answers-1108` (pushed, not merged): the owner's 2026-11-08 answers in preferences (deletion grades), vision (Essential by need, not `Rank`), git-workflow, P-0019 Decisions and TASK-67. Context rounds 1 and 2 FINDINGS, fixes applied in `e5d0f28`; a round 3 is owed. It also holds a stale copy of this handoff: drop that file's change when merging.
- `feat/template-contract` (worktree `.worktrees/template-contract`, head `235ddfa`): Stage 1 code round 2 PASS, fixes in, suite PASS. Owed before merge: a context review of its doc changes, the EDITED anchors `bun run anchors main` lists, and `backlog task edit N -m m-2` for TASK-63 to 66 (its TASK-63 Handoff note says so).
- Merged branches and worktrees from 2026-11-04 are deleted; their evidence is in `builds/from-worktree-*`.
- `scripts/board.py` is untracked in the `Main Folder` and not from this session.

## Next
1. Context round 3 on `docs/owner-answers-1108`, merge it (without its handoff change).
2. Context review on `feat/template-contract`, read its EDITED anchors, assign m-2, merge, close TASK-63, 64, 65.
3. `builds/deep-research/reports/marine-crewing-cv-expectations.md` needs a `research-reviewer` PASS before it enters `docs/research/`.
4. TASK-67, Essential's design, with TASK-66's choice step.
5. TASK-60, 61, 62 ready; TASK-2 waits on P-0013. Constitution section 6's totals wording is the owner's.

## Owner decisions parked
- Parked reference concepts (`keep` / `maybe` in the gallery): Woodblock Road (condensed safe and stylish, spacious stylish), Stamp Rally (condensed safe, creative, stylish, spacious safe), Concourse (spacious stylish), Hanami Line v1. Stamp Rally spacious/stylish is `chosen` (built for the client).
- Proposals with `status: approved` not yet marked applied: three (`python scripts/proposals.py`); reconcile their metadata with the evidence.

## Pitfalls and machine facts
- The owner's local settings deny any push whose refspec names `:main`; record commits go through a real `main` checkout with plain `git push origin main` (the backlog skill).
- Agents in worktrees slipped into the `Main Folder` four times on 2026-10-14 (relative paths, `[IO.File]` calls). Brief every agent to use absolute worktree paths and never run tools with the `Main Folder` as working directory; check `git status` in the `Main Folder` after each agent.
- `bun run anchors <base> --fix` moves shifted source anchors but never widens a span whose inside was edited: read every EDITED span by hand. Give it the commit the anchors were last checked at; an older base can shift an anchor twice. The next baseline is the head of each merged branch.
- `bun run atlas` stamps the generated page itself, but refuses (exit 1) when a cited source is already stale: re-check those sources, then `python .atlas/_kit/atlas.py stamp client-journey`.
- A hung background `git status` (not this session's; likely a status-line poll) once held `.git/index.lock` and blocked a merge: check `Get-CimInstance Win32_Process -Filter "Name='git.exe'"` before removing a lock.
- The machine runs out of memory ("paging file too small", "memory allocation failed") with more than three agents or two suite runs at once; one such suite failure passed on re-run.
- `private/` is the real repository moved inside this checkout (2026-11-03), not a sibling. `scripts/cv.py render` and Typst refuse an `Envelope` reached through a junction. `approve` and `export` only verify files and hashes.
- In PowerShell, `-s Active,Review` is split into separate arguments; repeat `-s` instead. `[IO.File]` paths resolve against the process directory, not `Push-Location`: pass absolute paths. The Bash tool can swallow `python` output; `bun run` checks exit 1 silently under Git Bash: use PowerShell.
- Backlog.md 1.55.3 is pinned (ADR 0017). `backlog browser --no-open` serves the board on http://127.0.0.1:6420. Known CLI issues are in the backlog skill; close `backlog board` before a rebase or checkout (PR #1173).
- Codex `exec` with `--ignore-user-config` refuses any shell command; Codex reads tasks as files.
- Windows cp1252 printing can fail after a successful write with Greek text; run checks with PYTHONIOENCODING=utf-8 and read the file before any retry.

## Constraints in force
- Deletions follow the Decision Grades in `docs/preferences.md` (owner, 2026-11-08, on `docs/owner-answers-1108` until it merges). The auto-mode safety check may still block a deletion the rules allow: report it, never work around it.
