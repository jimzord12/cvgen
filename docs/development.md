# Development protocol

Read this before starting, resuming or handing off implementation work.
Active since 2026-09-16 under the approved
[development protocol proposal](proposals/development-protocol.md), revision 2,
whose companions [review-protocol.md](proposals/review-protocol.md) and
[work-records.md](proposals/work-records.md) remain the specification history.
Claude Code implements; Codex optionally supports discussion and design.
The system is experimental: record concrete friction under
[proposal tracking](proposals/README.md) rather than changing rules silently.

## The flow

Kanban-style: work moves through explicit stages, one active implementation
task, clear acceptance criteria, independent review. Fixed sprints are optional.

| Stage | Required outcome |
|---|---|
| Queued | A useful outcome, scope and observable acceptance criteria. |
| Active | Claude owns the task and works in small coherent changes. |
| Review | Author checks are complete; a fresh `code-reviewer` examines the exact change under [review.md](review.md). |
| Ready | Acceptance criteria, required checks and review pass; ready for integration. |
| Done | The change reaches its intended branch, the push and CI result are confirmed, and evidence is recorded. |

Blocked and Cancelled are explicit side states. Design and PDF approvals are
separate gates. When a change may skip independent review is decided only by
[review.md](review.md#when-a-review-is-required); a trivial change that
skips it uses its commit as the record and states the reason.

A cancelled task moves to **Done** with a `## Cancelled` section in its
notes: the date, the reason, who decided, and what (if anything) was kept.
Cancelled work never counts as delivered.

## A fresh session

1. Read `AGENTS.md`, `docs/preferences.md` and the local profile if present.
2. Read the **session-handoff** doc as it stands on `main` (the backlog
   skill says how; a branch's copy may be stale): the previous session's
   resume point, parked owner decisions and pitfalls. Then derive state from
   the vision, relevant decisions/proposals, the tasks in `backlog/`, Git
   state and evidence for the examined revision. The handoff doc orients;
   the tasks, Git and evidence are the authority when they disagree. Flag missing or
   conflicting evidence rather than inventing certainty. Orientation is
   read-only and repeatable.
3. Give the four-line briefing, then continue within authorized scope:

```text
Goal: <Purpose from the vision.>
Now: <Implemented behaviour and active work, based on current evidence.>
Next: <One recommended step within the agreed priorities.>
You: <A ready decision and recommendation, or nothing needed.>
```

Use the briefing on fresh or resumed sessions and on status requests.
Otherwise answer briefly in everyday language, following the local
communication profile.

## Ending a session

First, run the `Session Sweep` for loose ends (owner, 2026-09-28). The list
says where to look, never what is open; check each place from its real
source, then act on what you find or name it in the handoff and the
report:

- **Reviews:** every commit that reached `main` since the handoff doc's
  `Main at` commit (`git log <sha>..main`; this includes older branch
  commits merged since, which a date window misses), from any author or
  session (an interrupted session never ran its `Session Sweep`),
  documentation included, has a review report under
  `docs/work/<id>/reviews/`, or is trivial or record-keeping
  (`docs/review.md`); run the missing round before stopping.
- **Proposals:** `status: approved` in `docs/proposals/*.md` is approved
  work not yet applied.
- **Tasks:** `backlog task list --plain -s Active -s Review -s Ready` and any task
  labelled `blocked` (the board view includes active branches).
- **Night Shift:** `night-shift status` and `night-shift follow-up list`
  show open follow-ups only. Also read the `night.json` of every night
  dated on or after the day before the `Written` date (a night is named by
  the date it starts), in the main checkout (the
  `.night-shift/nights/` folder is ignored by Git): questions with
  `"answer": null` and feedback with `"sent": null` still wait on the
  owner.
- **Git:** `git worktree list` and local or remote branches already merged
  into `main`; anything uncommitted or unpushed.
- **CI:** `gh run list --commit <main head>` shows the run on the current
  `main` head, green (not `--branch main`: see `docs/git-workflow.md`).
- **`builds/`:** clear old folders by path when they pile up.
- **Repo health:** `/repo-maintenance quick` (seconds; the `repo-maintenance`
  skill). Name any finding in the handoff; the owner approves fixes by ID.
- **`Atlas`:** `python .atlas/_kit/atlas.py check`. A STALE or UNVERIFIED
  page is re-checked against its sources, rebuilt and stamped in the same
  session; refresh the `status` of any flow the session moved.

A report says everything is finished only after the `Session Sweep`.

Then rewrite the session-handoff doc in place on `main` (one file, never a
new one, never deleted; Git keeps its history), through the route in the
backlog skill. Keep its heading and intro, then a line
`**Written:** yyyy-MM-dd, <what the session was> (<agent>)`; the skill's
read-back check looks for that date. Next, a line
`**Main at:** <short sha>` with the `main` head at the time of writing; the
next `Session Sweep` starts its review check there. Then: where things
stand, the next step in order, parked owner decisions, pitfalls that cost
time, constraints in force. Keep only what no task owns; a task's own
state goes in its Handoff note. Any other handoff file is a mirror of the
doc, not a second source. An agent that stops without rewriting the doc
leaves the next session to reconstruct the state from the tasks and Git,
which is slower but always possible.

## Where the information belongs

One authoritative home per task, decision and rule. Status is generated on
demand from those sources; `backlog/` is the one task store, and there is
no second status page, dashboard or backlog.

```text
CLAUDE.md, AGENTS.md              # Entry, roles, routing, essential constraints
docs/development.md               # This protocol
docs/review.md                    # Review protocol
backlog/tasks/                    # One authoritative brief and status per task (Backlog.md)
backlog/docs/doc-1 - session-handoff.md  # Cross-session resume point, rewritten on main at the end of each session
docs/work/<id>/reviews/NN.md      # Review reports, created only when review runs
docs/decisions/                   # Accepted architecture decisions
docs/proposals/                   # Proposals with status; rejected/ keeps declined ones
.claude/agents/code-reviewer.md   # Thin wrapper around docs/review.md
.claude/skills/backlog/           # How agents read and update the tasks
```

The task store is [Backlog.md](https://github.com/MrLesk/Backlog.md)
(ADR 0014, 2026-10-06; it replaced the Trello board adopted under
[trello-free-trial](proposals/trello-free-trial.md)). Each task is a file in
`backlog/tasks/` with a number Backlog.md gives it (`TASK-27`); its title
starts with the task id, a short kebab-case slug (`dev-setup`,
`monorepo-migration`), which also names its `docs/work/<id>/` folder. Its
status is one of the five stages; the label `blocked` marks a blocked task,
which keeps its stage, gains a `## Blocked` note with the reason, the
dependency task and the unblock condition, and loses the label only when
that condition is met. Read and write tasks through the backlog skill (the
`backlog` CLI). Review reports stay under `docs/work/<id>/reviews/` and are
linked from the task. `docs/work/<id>/task.md` is no longer created; the one
that exists (`dev-setup`) is history. A task reaching Done proves nothing by
itself.

Where a task file changes (so two branches never edit the same one): a
task a branch is working on changes only on that branch, in the same commits
as its work. Two kinds of record commit go straight to `main`, by the route
in the backlog skill: the handoff doc, and edits to tasks no branch is
working on (a new Queued task, a cancellation, the move to Done after a
merge). Both are record-keeping under `docs/review.md`.

## The task record

Keep the brief and result together in the task. Small fixes can use the
commit body; multi-session work, contract changes and migrations get a task.
The sections map onto Backlog.md's own sections:

| Section | Where in the task | How to write it |
|---|---|---|
| Header (Owner, Branch/worktree, Integration target, Depends on) and **Outcome and boundaries** | Description | `-d` on create |
| **Acceptance** | Acceptance Criteria | `--ac`, then `--check-ac N` |
| **Plan** | Implementation Plan | `--plan` |
| **Result and evidence**, **Review**, **Handoff** (each a `##` heading) | Implementation Notes | `--append-notes` |
| One-paragraph result at Done | Final Summary | `--final-summary` |

```powershell
backlog task create "<id>: <Outcome>" -s Queued --no-dod-defaults --plain `
  -d "Owner: <Claude session or agent>`nBranch/worktree: <location>`nIntegration target: <main or parent feature branch>`nDepends on: <task/decision links, or none>`n`n## Outcome and boundaries`n<What becomes possible. What this task changes and excludes.>" `
  --ac "<Observable behaviour and the evidence that will establish it>"
backlog task edit TASK-N -s Active --plan "<a few steps; omit for a small obvious change>"
backlog task edit TASK-N --append-notes "## Result and evidence`n<behaviour; exact revision; commands, exit results, artifact locations; old evidence vs current proof>"
backlog task edit TASK-N --append-notes "## Review`n<report links, Blocking/Material dispositions, remaining limitations>"
backlog task edit TASK-N --append-notes "## Handoff`n<current state, unresolved issue, one exact next action, owner authorization given and its scope>"
```

Tasks migrated from Trello keep every section inside their description, as
the cards had them; they are history and are not reshaped.

Acceptance describes product behaviour, not functions to write. A material
scope change records its decision and reason so acceptance cannot quietly
shrink around unfinished work. Out-of-scope observations get a short item in
the record with a link back. Process authorization records stay separate
from task progress. A saved status report, when explicitly useful, is a dated
snapshot, never an authority. Build artifacts under `builds/` are local and
ignored: name them honestly, and treat a missing old artifact as no proof.
Cleanup preserves the evidence still needed by active work or deliberate
milestones; clearing `builds/` by path is an agent decision.

Ready is not Done. Ready means implementation, verification and review are
complete. Done means the change reached its integration branch, the push and
CI result are confirmed, and evidence is recorded. A child task reaching a
feature branch is not the whole feature reaching `main`.

## Guardrails without constant interruptions

- The owner chooses outcomes and approved looks/PDFs. Agents choose the
  technical design and every routine implementation, Git and task step within
  that scope, under [preferences.md](preferences.md#what-he-decides-and-what-agents-decide)
  and [git-workflow.md](git-workflow.md).
- One writer per checkout. Parallel implementation needs separate worktrees,
  explicit ownership and a useful reason.
- Ask for missing product intent, architecture outside an approved item or
  an operation reserved for the owner (preferences.md), with a recommendation and consequence. Do not ask the
  owner to re-approve accepted designs or routine choices.
- Record out-of-scope discoveries. Escalate boundary changes; log bypasses in
  [framework-gaps.md](framework-gaps.md).
- At handoff, update the owning records and the task; do not create a
  second mandatory handoff document when the task holds the state.
