---
id: doc-1
title: session-handoff
type: other
created_date: '2026-10-06 07:25'
---

# session-handoff

Rewritten in place at the end of every session; the first thing a fresh session reads after AGENTS.md. Holds only what no task owns: what is next, parked owner decisions, machine facts, pitfalls. Task state stays in the tasks in `backlog/tasks/`.

**Written:** 2026-11-08, owner-answers session (Claude Code). Stopped by the owner: next he refactors the backlog tasks into milestones.
**Main at:** `656f336`. Two branches wait to merge, both pushed.

## Where things stand
- Task store: Backlog.md in `backlog/` (ADR 0014). The CLI is installed on this machine.
- P-0019 is approved. Merged: the Report Template, Decision Grades, the vision and constitution changes, ADR 0016, TASK-3.
- The owner answered the 2026-11-04 report (2026-11-08): Essential is not tied to a `Rank`, the operator chooses it when a `Client` needs a practical one-page CV; the portrait is optional per `Client`; long careers show recent contracts plus totals, never a second page; deleting files Git holds during approved work is Major, files Git does not hold are listed for him; merged branches and worktrees go once checked. Recorded on `docs/owner-answers-1108` (preferences, vision, git-workflow, P-0019 Decisions, TASK-67, Atlas). Context review: round 1 and 2 FINDINGS, round 2 fixes applied in `e5d0f28`; a round 3 confirmation is owed before merge. Reports verbatim in `archive/work-records/owner-answers-1108/reviews/`.
- `feat/template-contract` (worktree `.worktrees/template-contract`, head `a35c291`): code review round 2 PASS, its Minor findings fixed, suite PASS 203 cases (`builds/tests-20261108-105311-691907` there). Still owed before merge: a `context-reviewer` round 2 on Stage 1's doc changes, and the EDITED anchors `bun run anchors main` lists (new-cv skill, client-workflow guide). Deferred notes in TASK-65.
- Merged branches `feat/deck-data`, `feat/report-template`, `docs/p0019-*` and their worktrees are deleted; the worktrees' evidence is in `builds/from-worktree-*`.
- `scripts/board.py` is untracked and not from this session; left alone.

## Next
1. Wait for the owner's milestone refactor of the backlog.
2. Context round 3 on `docs/owner-answers-1108`, then merge.
3. Context round 2 on `feat/template-contract`, read the EDITED anchors, merge, close TASK-63, 64, 65.
4. `builds/deep-research/reports/marine-crewing-cv-expectations.md` needs a `research-reviewer` PASS before it enters `docs/research/`.
5. TASK-67, Essential's design, with TASK-66's choice step.
6. TASK-60, 61, 62 ready; TASK-2 waits on P-0013. Constitution section 6's totals wording is the owner's.

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
- Backlog.md 1.52.0 is pinned (1.53.0 has an open web-server memory leak, #1038). `backlog browser --no-open` serves the board on http://127.0.0.1:6420.
- Codex `exec` with `--ignore-user-config` refuses any shell command; Codex reads tasks as files.
- Windows cp1252 printing can fail after a successful write with Greek text; run checks with PYTHONIOENCODING=utf-8 and read the file before any retry.

## Constraints in force
- Deletions follow the Decision Grades in `docs/preferences.md` (owner, 2026-11-08). The auto-mode safety check may still block a deletion the rules allow: report it, never work around it.
