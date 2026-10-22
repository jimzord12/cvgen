---
id: doc-1
title: session-handoff
type: other
created_date: '2026-10-06 07:25'
---

# session-handoff

Rewritten in place at the end of every session; the first thing a fresh session reads after AGENTS.md. Holds only what no task owns: what is next, parked owner decisions, machine facts, pitfalls. Task state stays in the tasks in `backlog/tasks/`.

**Written:** 2026-10-14, the unattended run of TASK-28 to TASK-59 (Claude Code). **Updated** 2026-10-22: owner decisions closed (Next, item 1).
**Main at:** the merge of TASK-51 (`5501c38`); everything older is on `main`. Suite PASS at that head (`builds/tests-20261014-161315-649567`, 147 cases).

## Where things stand
- Task store: Backlog.md in `backlog/` (ADR 0014). Read and write tasks only through `.claude/skills/backlog/SKILL.md`; read this doc with `git show origin/main:"backlog/docs/doc-1 - session-handoff.md"`.
- Every task from TASK-28 to TASK-59 is Done. Queued: TASK-2 travel-domain, TASK-3 deck-data, TASK-4 codex-visual-tools (untouched), and three follow-ups filed on 2026-10-14: TASK-60 (PDF font-subset check), TASK-61 (integration fallback when the `Main Folder` is not on a clean `main`), TASK-62 (the Atlas check covers `site.json` citations).
- The client workflow has one source: the `Workflow Model` in `docs/workflow/` (YAML facts, generated tables and diagrams, hand prose). `tools/workflow/` checks it (`bun run check`, levels 1 and 2), runs a fictional client through the real scripts (`bun run reality`, level 3), renders the READMEs (`bun run render`) and the Atlas client-journey page (`bun run atlas`). The guides and the `new-client`/`new-cv` skills point to step IDs.
- Layout: `studio/` holds brand, design concepts and the frozen design records; `archive/work-records/` holds review reports; the Design Review app is `apps/design-review/`. `AGENTS.md` is a map of about 780 words; rules live in the files that own them.
- Hanami Line 2 is the owner's chosen Travel & Tourism design (`studio/design-concepts/2026-10-02-hanami-line-2/`), built as a one-off `Template` for `client-2026-09-01`; TASK-2 should start from it and from the Framework Gap entries of 2026-09-29 and 2026-10-02.

## Next
1. Owner decisions waiting: TASK-2 (the travel-domain proposal is deferred; go or wait).
   - Closed 2026-10-22: P-0018 answered and applied (`docs/proposals/workflow-gaps.md`, Decisions; item 3 uncapped). TASK-4 merged. The `Three-Second Test` is page 1's job only (`docs/vision.md`). P-0011 and P-0017 marked applied.
   - Closed 2026-10-22: the two scratch copies of client files and their worktrees and branches are gone, and the `client-2026-09-01` delivery is committed in `private/` (`129214c`). The owner's `/atlas refresh` now regenerates a page whose JSON carries `"generated"` with the command it names, never hand-edits it (owner: "regenerate"); `atlas.py check` repeats that note under a stale or unverified generated page.
2. Ready for agents, no owner input needed: TASK-3 (deck data), TASK-60, TASK-61, TASK-62.
3. Owner's own checks still open: the VS Code YAML hints (TASK-36) and the Atlas client-journey map view (104 steps; walk-through view may suit better as the default).
4. Client `client-2026-09-01`: if the client holds an early Stamp Rally edition (white strip under the boarding-pass portrait, fixed 2026-10-02), the owner may send the fixed one. Owner-only clean-up at the delete-by date (2027-10-02): delete the Intake Form, answers Sheet and script project, empty the Drive Trash, delete `private/<envelope>/`.

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
- `scripts/cv.py render` and Typst refuse an `Envelope` reached through a junction: render from a checkout where `private/` is a real folder. `approve` and `export` only verify files and hashes.
- In PowerShell, `-s Active,Review` is split into separate arguments; repeat `-s` instead. `[IO.File]` paths resolve against the process directory, not `Push-Location`: pass absolute paths. The Bash tool can swallow `python` output; `bun run` checks exit 1 silently under Git Bash: use PowerShell.
- Backlog.md 1.52.0 is pinned (1.53.0 has an open web-server memory leak, #1038). `backlog browser --no-open` serves the board on http://127.0.0.1:6420.
- Codex `exec` with `--ignore-user-config` refuses any shell command; Codex reads tasks as files.
- Windows cp1252 printing can fail after a successful write with Greek text; run checks with PYTHONIOENCODING=utf-8 and read the file before any retry.

## Constraints in force
- Live owner checkpoints override older broad cleanup permissions: explicit confirmation before deletions, overwrites, directory removals, generated/cache cleanup or discarding work; destructive Git also requires it. Routine reads, targeted edits, new outputs, verification and non-destructive Git remain authorized.
