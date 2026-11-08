# 0017. Backlog.md moves to 1.55.3, with milestones

Date: 2026-11-08
Status: Accepted (owner, 2026-11-08: upgrade the pin to 1.55.3 and group
every task into milestones). Amends 0014.

## Context

ADR 0014 pinned Backlog.md at 1.52.0 because 1.53.0 had a web-server memory
leak, issue #1038. That issue is closed: its reporter measured the growth gone
from 1.54 on, after the move to the Bun runtime. The owner also wants every
task grouped into milestones, which the 1.55 CLI stores natively
(`backlog milestone`, the task `milestone` field).

## Decision

The task store stays Backlog.md, pinned to 1.55.3 (`npm i -g
backlog.md@1.55.3`), and every task belongs to exactly one milestone, created
and assigned only through the CLI. Everything else in ADR 0014 stands.

## Consequences

- Progress is read by milestone (`backlog milestone list`), and the workflow
  plans as plan, then milestones, then tasks (`docs/development.md`).
- Known open upstream issues, worked around in the `backlog` skill:
  - PR #1173 (open): the terminal `board` on Windows spikes memory when many
    task files change at once (a rebase, a checkout). Close `board` first.
  - #919: `task create --milestone <name>` with a name that matches no
    milestone silently makes a "virtual" one. Create the milestone first,
    pass its exact name or id, and check with `milestone list`.
  - #1186: `task edit --title` leaves the file name with the old slug.
  - #1181: `task list --status <unknown>` exits 0 with an empty list, so a
    misspelt status looks like no tasks.
