---
id: doc-1
title: session-handoff
type: other
created_date: '2026-10-06 07:25'
---

# session-handoff

Rewritten in place at the end of every session; the first thing a fresh session reads after AGENTS.md. Holds only what no task owns: what is next, parked owner decisions, machine facts, pitfalls. Task state stays in the tasks in `backlog/tasks/`.

**Written:** 2026-10-06, Hanami Line travel design built for a real client, the Design Review verdicts applied, then the repo walk-through, branch clean-up and the workflow-model merge (Claude Code).
**Main at:** the merge of `docs/workflow-model` (2026-10-06); everything older is on `main`

## Where things stand
- Task store: Backlog.md in `backlog/` (ADR 0014). Read and write tasks only through `.claude/skills/backlog/SKILL.md`; read this doc with `git show origin/main:"backlog/docs/doc-1 - session-handoff.md"`.
- Open tasks: Queued TASK-2 travel-domain, TASK-3 deck-data, TASK-4 codex-visual-tools, TASK-28 to TASK-32 (Next, item 4). TASK-5 travel-recalibration is Done (Japan Passage rejected and removed in f78a181; Hanami Line 2 met the brief).
- **Hanami Line 2 is the owner's chosen Travel & Tourism design** (`design-concepts/2026-10-02-hanami-line-2/`: Spacious, stylish, pink / indigo / light blue). It was built as a one-off `Template` in a real client's `Envelope` (`client-2026-09-01`, Greek and English, plus a Stamp Rally edition), all reviewed (design, fact, code) and reported in `docs/work/idea-runs/2026-10-02-editor-2/run.md`. The three Japanese-capable font families it needs are now in `packages/cv-framework/fonts/`. The first real production `Travel & Tourism` `Domain` (TASK-2) should start from this design and from the Framework Gap entries of 2026-09-29 and 2026-10-02 (`docs/framework-gaps.md`).
- The owner's Design Review verdicts are applied: rejected variants removed, `keep` and `maybe` variants stay `parked` (`design-concepts/README.md`, review in `docs/work/design-verdicts/reviews/`).
- Client `client-2026-09-01`: the owner forwarded all eight revisions (Hanami x3 palettes x2 languages, Stamp Rally x2) to the client, who confirmed the details are OK. All eight are stamped `status=delivered` and the `Envelope`'s README holds the single deadline (one per client, not per CV): delete by 2027-10-02. `approve` and `export` were never run (optional; the owner's act).

## Next
1. Client `client-2026-09-01` (alias only; real data stays in `private/`): delivery is recorded (see above). Open: if the client holds an early Stamp Rally edition (white strip under the boarding-pass portrait, fixed 2026-10-02), the owner may send him the fixed one.
2. Owner-only clean-up for that client: delete its Intake Form, answers Sheet and script project (links in the `Envelope`'s README, then empty the Drive Trash); delete `private/<envelope>/` and the folder of review copies kept outside the repo at the delete-by date.
3. Session Sweep gap: the merge-time changes of 2026-10-04 (`a66b448`, `1db32e8`, `74a6f82`, `1e684eb`) have no stored review report. The workflow-model handoff proposes the task (`merge-review-2026-10-04`).
4. Queued from the owner's 2026-10-06 repo walk-through: TASK-28 (proposals snapshot), TASK-29 (remove `.night-shift`), TASK-30 (`Main Folder` glossary term), TASK-31 (rename `docs/reference`), TASK-32 (one tree for every client folder, confirmed by the owner). None started.
5. The workflow-model work (inventory of the client workflow, nine open owner decisions, 12 suggested tasks plus 13 restructure tasks) is in `docs/work/workflow-model/handoff.md` and `docs/workflow/inventory/`. Those suggested tasks are not yet created in Backlog; the owner decides when.
6. The repository is down to the `main` branch and the main folder (no other branches or worktrees), as of 2026-10-06.

## Owner decisions parked
- Parked reference concepts (`keep` / `maybe` in the gallery): Woodblock Road (condensed safe and stylish, spacious stylish), Stamp Rally (condensed safe, creative, stylish, spacious safe), Concourse (spacious stylish), Hanami Line v1. Stamp Rally spacious/stylish is `chosen` (built for the client).
- Proposals with `status: approved` not yet marked applied: `codex-visual-tools.md`, `client-workflow.md` (the latter is implemented; reconcile its metadata with the evidence).

## Pitfalls and machine facts
- The owner's local settings deny any push whose refspec names `:main`; record commits go through a real `main` checkout with plain `git push origin main` (the backlog skill).
- `scripts/cv.py render` and Typst refuse an `Envelope` reached through a junction: render from a checkout where `private/` is a real folder and `packages/cv-framework/fonts/` holds the fonts. `approve` and `export` only verify files and hashes, so the main folder (which has the real `private/`) can run them.
- A tall `image(width: ...)` inside a fixed-height box is shrunk by Typst to fit the height (a flat strip and a squashed photo); give the image its full height (`height: IW * 1536 / 1024`).
- In PowerShell, `-s Active,Review` is split into separate arguments; repeat `-s` instead. `[IO.File]` paths resolve against the process directory, not `Push-Location`: pass absolute paths.
- The Bash tool can swallow output of `python` here (even a server start); use PowerShell `Start-Process` for background servers. Removing a link: `[System.IO.Directory]::Delete(path, $false)`; the harness blocks `cmd /c rmdir`.
- Backlog.md 1.52.0 is pinned (1.53.0 has an open web-server memory leak, #1038). `backlog browser --no-open` serves the board on http://127.0.0.1:6420.
- Codex `exec` with `--ignore-user-config` refuses any shell command; Codex reads tasks as files.
- Windows cp1252 printing can fail after a successful write with Greek text; run checks with PYTHONIOENCODING=utf-8 and read the file before any retry.

## Constraints in force
- Live owner checkpoints override older broad cleanup permissions: explicit confirmation before deletions, overwrites, directory removals, generated/cache cleanup or discarding work; destructive Git also requires it. Routine reads, targeted edits, new outputs, verification and non-destructive Git remain authorized.
