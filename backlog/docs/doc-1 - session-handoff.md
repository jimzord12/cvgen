---
id: doc-1
title: session-handoff
type: other
created_date: '2026-10-06 07:25'
---

# session-handoff

Rewritten in place at the end of every session; the first thing a fresh session reads after AGENTS.md. Holds only what no task owns: what is next, parked owner decisions, machine facts, pitfalls. Task state stays in the tasks in `backlog/tasks/`.

**Written:** 2026-11-04, P-0019 session (Claude Code).
**Main at:** the merge of feat/deck-data plus `0775dac`. Suite PASS on `feat/template-contract`, 203 cases.

## Where things stand
- Task store: Backlog.md in `backlog/` (ADR 0014). The CLI is installed on this machine now.
- P-0019 is approved. Merged: the Report Template (`scripts/report.py`, `studio/brand/report/`), Decision Grades, the vision and constitution changes, ADR 0016, TASK-3.
- `feat/template-contract` (worktree `.worktrees/template-contract`, pushed, not merged) holds TASK-63, 64, 65 and part of 66. Code round 1 and context round 1 are answered; both need a round 2 before merge. The context round's point on ADR 0016's Consequences line stays as it is: an accepted ADR's text is not edited, and P-0019's Decisions records the move to Stage 2.
- Real marine records pass the new checks (both are custom compositions); the travel client has no contract.

## Next
1. Round 2 reviews on `feat/template-contract`, then merge and close TASK-63, 64, 65.
2. `builds/deep-research/reports/marine-crewing-cv-expectations.md` needs a `research-reviewer` PASS before it enters `docs/research/`. Its evidence is employer forms; nearly all other advice is vendors'.
3. TASK-67, Essential's design, after the owner answers the report's cards: who it is for, the photo, long careers. It must say what authorises a brief to name the `scan-first` bar before he approves, and update idea-run and `docs/workflow/05-design`. TASK-66's choice step comes with it.
4. Owner decides: whether refactors may delete files (the Critical row), and cleanup of merged branches and worktrees, which the auto-mode check blocked.
5. TASK-60, 61, 62 are still ready; TASK-2 waits on P-0013.
6. Review reports for the Report Template, P-0019, TASK-3 and Stage 1 are summaries, not verbatim as `docs/review.md` asks. The owner knows. Store verbatim from now on.
7. Constitution section 6 names marine totals as months, vessels and companies; contracts are now one too. The rule holds; the wording is the owner's.

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
- Live owner checkpoints override older broad cleanup permissions: explicit confirmation before deletions, overwrites, directory removals, generated/cache cleanup or discarding work; destructive Git also requires it. Routine reads, targeted edits, new outputs, verification and non-destructive Git remain authorized.
