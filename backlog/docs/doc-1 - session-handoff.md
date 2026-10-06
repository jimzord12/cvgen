---
id: doc-1
title: session-handoff
type: other
created_date: '2026-10-06 07:25'
---

# session-handoff

Rewritten in place at the end of every session; the first thing a fresh session reads after AGENTS.md. Holds only what no task owns: what is next, parked owner decisions, machine facts, pitfalls. Task state stays in the tasks in `backlog/tasks/`.

**Written:** 2026-10-06, task store moved from Trello to Backlog.md (Claude Code).
**Main at:** 968c3f8

## Where things stand
- The task store is now Backlog.md in `backlog/` (ADR 0014, TASK-27 Done). Read and write tasks only through `.claude/skills/backlog/SKILL.md`; read this doc with `git show origin/main:"backlog/docs/doc-1 - session-handoff.md"`. The Trello board is closed (not deleted); its full export is `docs/work/backlog-migration/trello-export-2026-10-06.json`. Deleting the board is the owner's call.
- `main` CI green on 968c3f8: https://github.com/jimzord12/cvgen/actions/runs/37433119964 .
- Open tasks: Queued TASK-2 travel-domain, TASK-3 deck-data, TASK-4 codex-visual-tools; Review TASK-5 travel-recalibration (Japan Passage concept, waiting on the owner). trello-cli (TASK-1) is cancelled.

## Next
1. Session Sweep gap: 30 commits from other sessions reached `main` between 0488c4f and 1e684eb (merges of docs/codex-visual-tools, feature/hanami-client-cv, docs/idea-run-2026-10-02-editor-b, plus an Atlas refresh). The 2026-10-06 migration session did not verify their review reports; check `git log 0488c4f..1e684eb` against `docs/work/*/reviews/` and run any missing round.
2. Open branches made before the migration (`fix/atlas-step-under-labels`, `docs/private-repo`, `docs/worktrees-folder`, the idea-run branches) still carry Trello wording and the old trello skill. On their next merge, resolve toward `main` and re-run `rg -i --hidden trello` outside `docs/work`, `docs/proposals`, `.night-shift`, `backlog/tasks`, ADRs and history.
3. TASK-5: owner decision on the Japan Passage two-page Spacious Stylish design (still proposed).

## Owner decisions parked
- Japan Passage (TASK-5); Woodblock Road, Stamp Rally and Concourse stay proposed reference concepts.
- Proposals with `status: approved` not yet marked applied: `codex-visual-tools.md`, `client-workflow.md` (the latter is implemented; reconcile its metadata with the evidence).

## Pitfalls and machine facts
- The owner's local settings deny any push whose refspec names `:main`; record commits go through a real `main` checkout with plain `git push origin main` (the backlog skill).
- In PowerShell, `-s Active,Review` is split into separate arguments; repeat `-s` instead. `[IO.File]` paths resolve against the process directory, not `Push-Location`: pass absolute paths.
- Backlog.md 1.52.0 is pinned (1.53.0 has an open web-server memory leak, #1038). `backlog browser --no-open` serves the board on http://127.0.0.1:6420.
- Codex `exec` with `--ignore-user-config` refuses any shell command; Codex reads tasks as files.
- Windows cp1252 printing can fail after a successful write with Greek text; run checks with PYTHONIOENCODING=utf-8 and read the file before any retry.

## Constraints in force
- Live owner checkpoints override older broad cleanup permissions: explicit confirmation before deletions, overwrites, directory removals, generated/cache cleanup or discarding work; destructive Git also requires it. Routine reads, targeted edits, new outputs, verification and non-destructive Git remain authorized.
