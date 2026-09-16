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

Kanban-style [work moves through explicit stages]: one active implementation
task, clear acceptance criteria, independent review. Fixed sprints are optional.

| Stage | Required outcome |
|---|---|
| Queued | A useful outcome, scope and observable acceptance criteria. |
| Active | Claude owns the task and works in small coherent changes. |
| Review | Author checks are complete; a fresh `code-reviewer` examines the exact change under [review.md](review.md). |
| Ready | Acceptance criteria, required checks and review pass; ready for integration. |
| Done | The change reaches its intended branch, the push and CI result are confirmed, and evidence is recorded. |

Blocked and Cancelled are explicit side states. Design and PDF approvals are
separate gates. Small behaviour-preserving edits may use their commit as the
record and skip independent review; judge the consequence, not line count,
and record the reason.

## A fresh session

1. Read `AGENTS.md`, `docs/preferences.md` and the local profile if present.
2. Derive state from the vision, relevant decisions/proposals, the active
   task record, Git state and evidence for the examined revision. Flag missing
   or conflicting evidence rather than inventing certainty. Orientation is
   read-only and repeatable.
3. Give the four-line briefing, then continue within authorized scope:

```text
Goal: <Purpose from the vision.>
Now: <Implemented behaviour and active work, based on current evidence.>
Next: <One recommended step within the agreed priorities.>
You: <A ready decision and recommendation, or nothing needed.>
```

## Where the information belongs

One authoritative home per task, decision and rule. Status is generated on
demand from those sources; no second status page, dashboard or backlog.

```text
CLAUDE.md, AGENTS.md              # Entry, roles, routing, essential constraints
docs/development.md               # This protocol
docs/review.md                    # Review protocol
docs/work/<id>/task.md            # One authoritative brief and result per task
docs/work/<id>/reviews/NN.md      # Review reports, created only when review runs
docs/decisions/                   # Accepted architecture decisions
docs/proposals/                   # Proposals with status; rejected/ keeps declined ones
.claude/agents/code-reviewer.md   # Thin wrapper around docs/review.md
```

Task ids are short kebab-case slugs (`dev-setup`, `monorepo-migration`).
During the authorized [Trello Free trial](proposals/trello-free-trial.md) the
two trial cards own their brief and status instead of a `task.md`; review
reports still live under `docs/work/<id>/reviews/` and are linked from the
card. When task authority changes, retire the old record explicitly rather
than keeping two ledgers in sync.

## The task record

Keep the brief and result together. Small fixes can use the commit body;
multi-session work, contract changes and migrations get a persistent file.

```markdown
# <id>: <Outcome>

Status: Queued | Active | Review | Ready | Done | Blocked | Cancelled
Owner: <Claude session or agent responsible>
Branch/worktree: <location>
Integration target: <main or the named parent feature branch>
Depends on: <task/decision links, or none>

## Outcome and boundaries
<What becomes possible. What this task changes and excludes.>

## Acceptance
- [ ] <Observable behaviour and the evidence that will establish it.>

## Plan
<A few steps; omit for a small obvious change.>

## Result and evidence
<Implemented behaviour; exact revision or patch snapshot; commands, exit
results, artifact locations. Distinguish old evidence from current proof.>

## Review
<Report links, Blocking/Material finding dispositions, remaining limitations.>

## Handoff
<Current state, unresolved issue, one exact next action, and any owner
authorization already given with its scope.>
```

Acceptance describes product behaviour, not functions to write. A material
scope change records its decision and reason so acceptance cannot quietly
shrink around unfinished work. Out-of-scope observations get a short item in
the record with a link back. Build artifacts under `builds/` are local and
ignored: name them honestly, and treat a missing old artifact as no proof.

Ready is not Done. Ready means implementation, verification and review are
complete. Done means the change reached its integration branch, the push and
CI result are confirmed, and evidence is recorded. A child task reaching a
feature branch is not the whole feature reaching `main`.

## Guardrails without constant interruptions

- The owner chooses outcomes, architecture and approved looks/PDFs. Agents
  choose routine implementation and Git steps within that scope, including
  commits, pushes and integration, under [git-workflow.md](git-workflow.md).
- One writer per checkout. Parallel implementation needs separate worktrees,
  explicit ownership and a useful reason.
- Ask for missing product intent, unresolved architecture or an existing
  safety checkpoint, with a recommendation and consequence. Do not ask the
  owner to re-approve accepted designs or routine choices.
- Record out-of-scope discoveries. Escalate boundary changes; log bypasses in
  [framework-gaps.md](framework-gaps.md).
- At handoff, update the owning records and the task record; do not create a
  second mandatory handoff document when the task record holds the state.
