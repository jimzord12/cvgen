---
name: backlog
description: Read and update this project's tasks and milestones, stored as Backlog.md files in backlog/, through the `backlog` CLI. Every task's record is a task there, in one milestone; the session-handoff doc lives beside them. Use it for session orientation, progress by milestone, creating or editing a task or milestone, moving a task between the five stages, acceptance criteria, the blocked label, notes, or reading and rewriting the session handoff.
---

# Backlog

The task store is [Backlog.md](https://github.com/MrLesk/Backlog.md)
**1.55.3** (ADR 0014, amended by ADR 0017; install: `npm i -g
backlog.md@1.55.3`). Tasks are Markdown files in `backlog/tasks/`,
milestones in `backlog/milestones/`, the session handoff is
`backlog/docs/doc-1 - session-handoff.md`, and the config is
`backlog/config.yml`. Workflow rules (stages, the task record, what a task
may and may not prove) are in `docs/development.md`; this skill only covers
mechanics, and `docs/development.md` also says what a milestone is. No MCP server and no network: the CLI reads and writes files, and
`auto_commit` is off, so every change is committed by you.

## Reading

Always pass `--plain` (agent-readable output, no terminal UI).

```powershell
backlog task list --plain                       # every task, grouped by status
backlog task list --plain -s Active -s Review -s Ready
backlog task list --plain -l blocked
backlog task list --plain -m m-2                # one milestone's tasks
backlog milestone list --plain --show-completed  # progress by milestone: done/total
backlog task view TASK-27 --plain               # one task in full
backlog search "<words>" --plain
backlog board                                    # terminal Kanban (humans)
backlog browser --no-open                        # web board on http://127.0.0.1:6420 (humans)
```

The board and the lists include tasks changed on other local and remote
branches touched in the last 30 days (`check_active_branches`), so they
show work in progress before it merges. Remote branches are only as fresh
as your last `git fetch` (the CLI never fetches: `remote_operations` is off),
so fetch first. A branch untouched for longer drops out of that view.

## Writing

```powershell
backlog task create "<id>: <Outcome>" -s Queued -m m-N -d "<description>" --ac "<item>" --no-dod-defaults --plain
backlog task edit TASK-N -m m-N --plain                     # move a task to another milestone
backlog task edit TASK-N -s Active --plain                  # stages: Queued, Active, Review, Ready, Done
backlog task edit TASK-N --check-ac 2 --plain               # 1-based; --uncheck-ac, --remove-ac, --ac to add
backlog task edit TASK-N --plan "<steps>" --plain
backlog task edit TASK-N --append-notes "## Result and evidence`n..." --plain
backlog task edit TASK-N --final-summary "<one paragraph>" --plain
backlog task edit TASK-N --add-label blocked --plain        # and --remove-label blocked
```

- Every new task names its milestone with `-m`, by id (`m-2`), taken from
  `milestone list`. A name that matches no milestone silently makes a
  "virtual" one (#919): create the milestone first and check the result
  with `milestone list`.
- Never `-l` on `task edit`: it replaces every label. Use `--add-label` and
  `--remove-label`.
- Always `--no-dod-defaults` on create; the project has no Definition of Done
  list.
- In PowerShell, write a newline inside a double-quoted argument as
  `` `n ``; build long text in a here-string first.
- **Verify every write by reading it back** with `task view --plain`.
- Title starts with the task id (`monorepo-migration: ...`). Backlog.md adds
  its own number (`TASK-27`); the id names the `archive/work-records/<id>/` folder.
- Edit a task file by hand only for something the CLI cannot do, keep its
  `<!-- SECTION:... -->` and `<!-- AC:... -->` markers intact, and check the
  result with `task view --plain`.
- Keep real candidate data and credentials out of tasks and docs:
  `backlog/` is public like the rest of the repository.
- A task moving to Done proves nothing by itself; completion criteria in
  `docs/development.md` still apply.

## Milestones

```powershell
backlog milestone add "<Outcome>" -d "Done when <one-line done-condition>."
backlog milestone rename m-N "<New name>"        # updates the tasks in this checkout only
backlog milestone archive m-N                    # only when nothing more is planned for it
```

A milestone file is never written by hand. Its name uses the glossary's
words and its description holds the done-condition. Tasks store the id, so
a rename leaves them pointing at the right milestone, but the CLI updates
only the tasks it can see in this checkout: a task on another branch keeps
its old value until that branch changes it. Milestone files are
record-keeping and go to `main` like a new Queued task.

## Known CLI issues (1.55.3)

- PR #1173 (open): the terminal `board` on Windows spikes memory when many
  task files change at once. Close `board` before a rebase or checkout.
- #919: `--milestone` with an unknown name makes a virtual milestone (above).
- #1186: `task edit --title` keeps the old slug in the file name.
- #1181: `task list --status <unknown>` exits 0 with an empty list, so a
  misspelt status looks like no tasks.

## Which branch a task change goes on

A task a branch is working on changes only on that branch, committed with
its work. Two kinds of record commit go straight to `main`, by the route
below: the session-handoff doc, and edits to tasks no branch is working on
(a new Queued task, a cancellation, the move to Done after a merge into
`main`; a child task's Done goes on its parent branch). Both are
record-keeping (`docs/review.md`). Create new tasks and milestones on `main`; an abandoned
branch's task is cancelled on `main` (`docs/development.md`).

**Route to `main`.** Always from a checkout that has `main` itself checked
out, pushed with plain `git push origin main`: the owner's local settings
refuse any push whose refspec names `:main` (`HEAD:main` included).

- If `git worktree list` shows a checkout on `[main]` (normally the `Main
  Folder`; your own checkout counts) with no uncommitted changes other than
  this record edit, use it.
- If no checkout has `main`, add a short-lived one and remove it after:

```powershell
git worktree add <scratchpad>/records main
git -C <scratchpad>/records pull --rebase --autostash origin main   # so **Main at:** is the real head
# edit and commit inside <scratchpad>/records, then:
git -C <scratchpad>/records push origin main
git worktree remove <scratchpad>/records
```

- If the only checkout on `main` has uncommitted changes that are not part
  of this record edit, do not touch it: carry a task edit in your own
  branch's next merge, or leave the handoff unwritten, and say so in your
  report.

Pull with `git pull --rebase --autostash origin main` before editing (and
again, the same way, if the push is rejected because `main` moved). Before
pushing, `git status -sb` must show `[ahead 1]`: your record commit only. If
it shows more, do not push; never publish someone else's unpushed commits.
Treat it like the third case above.

## The session handoff

Read it from `main`, never from a branch's copy, which may be stale:

```powershell
git fetch origin
git show "origin/main:backlog/docs/doc-1 - session-handoff.md"
```

Rewrite it in place at the end of a session (format in
`docs/development.md`, "Ending a session") through the route to `main`
above. It is never recreated, renamed or deleted; Git keeps its history.
After pushing, read it back with `git show origin/main:...` and confirm the
`**Written:**` line carries your date and the `**Main at:**` line the head
you meant.
