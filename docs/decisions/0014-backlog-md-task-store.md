# 0014. Backlog.md is the task store

Date: 2026-10-06
Status: Accepted (owner, 2026-10-06: "I want to migrate from Trello -> Backlog.md"; plan approved the same day)

## Context

Since 2026-09-16 every task record was a card on the Trello board "CVgen"
(`docs/proposals/trello-free-trial.md`), read and written by agents through
a REST helper that needed the owner's API credentials and the network. Task
state lived outside the repository: a task's record and the commits that
delivered it could not travel together, and a review report could not be
checked against its task without a second system. The earlier
`docs/proposals/kanban-tooling-research.md` had already ranked
[Backlog.md](https://github.com/MrLesk/Backlog.md) first: Markdown task
files in the repository, a command-line tool with plain output for agents,
and local boards in the terminal and the browser.

## Decision

The task store is Backlog.md, pinned to 1.52.0, in `backlog/`: one file
per task in `backlog/tasks/`, the session handoff as
`backlog/docs/doc-1 - session-handoff.md`, statuses Queued, Active, Review,
Ready and Done, and one label, `blocked`. Agents use the CLI through the
`backlog` skill; no MCP server and no generated agent instructions. A task
file changes on the branch that works on it; the handoff doc and edits to
idle tasks go straight to `main` as record-keeping commits. All 26 task
cards and the handoff card were migrated verbatim, the board was exported to
`docs/work/backlog-migration/` and closed, not deleted.

## Consequences

- Tasks travel with Git: a task's record and its commits merge together,
  and agents need no credentials or network to read or write them.
- Task ids gain a number (`TASK-27`); the kebab-case slug stays the first
  word of the title and names `docs/work/<id>/`.
- The owner loses the phone board. On a phone, `backlog/tasks/` on GitHub
  is readable page by page, with no Kanban view, and shows a task's status
  only once its work is merged. The boards (`backlog board`,
  `backlog browser`) run on the local machine and include active branches.
- Task changes are now commits; `docs/review.md` names the handoff doc and
  idle-task edits as record-keeping, which needs no review round.
- Supersedes the adoption decision in `docs/proposals/trello-free-trial.md`.
