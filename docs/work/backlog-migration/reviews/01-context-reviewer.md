context-reviewer report, round 1. Snapshot 1e684eb..0fbc85d (feature/backlog-migration, worktree C:\Users\jimzord12\Documents\GitHub\cvgen-backlog)

**The principle I checked against.** Backlog.md replaces Trello as the only task store. Every live rule, skill, agent and Codex mirror should send a fresh agent to `backlog/` and the `backlog` skill. The handoff is read from and written to `main`. No live instruction should still point at Trello, apart from the `trello` skill, which stays until step 7. Dated records should not be rewritten.

Overall the change is coherent. AGENTS.md, development.md, review.md, preferences.md, git-workflow.md and the skill describe one flow: same stages, a `blocked` label, task files that change on the branch working on them, and handoff and idle-task edits going to `main` as record-keeping. I checked every CLI flag in the skill and in development.md against `backlog --help` on 1.52.0, and they exist: `task list -s` (repeatable), `-l` as a list filter, `--check-ac`, `--append-notes`, `--final-summary`, `--add-label`/`--remove-label`, `--no-dod-defaults`, `search --plain` and `browser --no-open`. `task list --plain` shows Queued 3, Active 1, Review 1, Done 22. All changed blobs use LF. The repository names no real client.

## Material

1. `.claude/skills/backlog/SKILL.md:79,85-86` has a broken command. The route to `main` creates the worktree with `--detach`, then says "If the push is rejected because `main` moved, `git pull --rebase` inside the worktree". On a detached HEAD, `git pull --rebase` fails with "You are not currently on a branch". The first handoff or idle-task commit that hits a race will stall, and agents will improvise. Fix: replace it with `git -C <scratchpad>/records fetch origin; git -C <scratchpad>/records rebase origin/main`, then push again.

## Minor

2. `backlog/docs/doc-1 - session-handoff.md:10` still says "Holds only what no task card owns… Task state stays on the task cards." Line 33 also has a Trello-credentials pitfall. development.md:98 tells every session to "Keep its heading and intro", so this stale intro will be copied forward indefinitely. The intro is the live template, not history. Fix: reword the intro to "task" now. Drop the Trello pitfall at the step 7 rewrite.
3. `docs/framework-gaps.md:73,94,114`: the status lines still say "card revision-snapshot" and "card travel-domain". The plan, step 4, lists framework-gaps.md for the swap, and the step 7 wording check will hit these lines. Status lines are live, not part of the dated entry text. Fix: change "card" to "task".
4. `docs/development.md:168-171`: the `task edit` example lines leave out `--plain`. SKILL.md:19 says "Always pass `--plain`". Fix: add `--plain` to those lines.
5. `.claude/agents/context-maintainer.md:53`: the inserted text makes this line about 120 characters, while the file wraps at about 75. Fix: rewrap.

## Notes

- `docs/decisions/0014-backlog-md-task-store.md:28-30`, `docs/decisions/README.md:42`, `docs/history.md` (new entry) and the header of `docs/proposals/trello-free-trial.md` say the board "was exported … and closed". That only becomes true at step 7. This is acceptable while merge stays back to back with the freeze. At step 7, confirm that the export file name matches and that the board is actually closed. If step 7 aborts, these lines are false.
- `.claude/skills/backlog/SKILL.md:31-34` says the lists include tasks from remote branches. With `remote_operations: false` there is no fetch, so remote branches show only as fresh as the last `git fetch`. The plan, step 1, asked for this to be confirmed, and I found no record of that. Suggest adding "run `git fetch` first" before the Tasks sweep.
- The Session Sweep "Tasks" line (development.md:74) only works from a checkout that contains `backlog/`. After the merge, older branches such as the idea-run checkout will not have it. Consider saying "from a checkout of `main`".
- `.claude/agents/context-maintainer.md:53` makes the descriptions of migrated tasks immutable dated records. Queued migrated tasks (TASK-2, TASK-3, TASK-4) have acceptance that is meant to be "refined when picked up". development.md:175 only says they are "not reshaped". Consider saying that refinements go in Notes or Acceptance Criteria, not into the description.
- "task store" now appears across many files as an unnamed recurring concept. Consider a glossary row.
- The `trello` skill (`.claude/skills/trello/`) still describes itself as the task record until step 7. That was intended; it must not survive the merge.

Verdict: FINDINGS
