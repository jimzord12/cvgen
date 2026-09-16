---
kind: proposal
status: pending
revision: 2
---

# Development protocol

Status: Proposal, 2026-09-15. Harness roles are decided: Claude Code implements;
Codex optionally supports discussion and design. This process is not yet adopted.
Decision scope includes the linked review protocol and work-record conventions.
It excludes installing task tooling or implementing a governance package.
Revision 2, 2026-09-16: align with the owner's active agent-managed Git and no-PR
policy. The remaining development/review proposal still awaits approval.

## The recommendation

Use a Kanban-style flow [work moves through explicit stages], one active
implementation task, clear acceptance criteria, and independent review. Borrow
flow and explicit policies from [Kanban](https://kanbanguides.org/the-kanban-guide/2025.5/);
add process when experience justifies it. Fixed sprints are optional.

This system is experimental, not battle-tested. Agents should notice concrete
friction and gaps and use the [proposal tracking convention](README.md) to record
and apply decisions. Broader [process evolution ideas](process-evolution.md) are deferred.

## A fresh session

1. Read the entry instructions and communication preferences.
2. Derive state from the vision, relevant decisions/proposals, active task,
   Git state, and evidence for the examined revision. Flag missing/conflicting
   evidence rather than inventing certainty. This action does not modify sources.
3. Give a short briefing in this shape, then continue within authorized scope:

```text
Goal: <Purpose from the vision.>
Now: <Implemented behavior and active work, based on current evidence.>
Next: <One recommended step within the agreed priorities.>
You: <A ready decision and recommendation, or nothing needed.>
```

Use the briefing on fresh/resumed sessions and status requests. Otherwise,
answer briefly in everyday language. Follow the local communication profile;
keep occasional advanced teaching separate from routine reporting.

## Where the information belongs

Keep one authoritative home for each task, decision, and rule. Generate status
from those sources on demand; do not save another manually maintained summary.
Unchanged sources should produce the same factual report without side effects.
Historical evidence records remain useful when their scope and revision are clear.

```text
CLAUDE.md                       # Implementation entry; imports AGENTS.md
AGENTS.md                       # Roles, routing, and essential constraints
docs/development.md             # This working protocol after acceptance
docs/review.md                  # Review protocol after acceptance
<task-store>/<id>               # One authoritative brief/result, chosen by trial
docs/work/<id>/reviews/01.md     # Reports, created only when review runs
docs/decisions/                 # Accepted architecture decisions and rationale
docs/proposals/                 # Proposals with status
docs/proposals/rejected/        # Declined proposals and their reasons
.claude/agents/code-reviewer.md  # Thin Claude wrapper around docs/review.md
```

Personal details stay local. Link to existing safety rules, conventions, and Git workflow.
Without a task tool, use `docs/work/<id>/task.md`. If Backlog.md is adopted,
use its native task records instead; keep review artifacts linked by task ID.

## Work from intention to delivery

| Stage | Required outcome |
|---|---|
| Queued | A useful outcome, scope, and observable acceptance criteria. |
| Active | Claude owns the task and works in small coherent changes. |
| Review | Author checks are complete; an independent Claude reviewer examines the exact change. |
| Ready | Acceptance criteria, required checks, and review pass; ready for integration/publication. |
| Done | The change reaches its intended branch, the push and CI result are confirmed, and evidence is recorded. |

Blocked and cancelled are explicit side states. Design and PDF approvals are
separate. Small behavior-preserving edits may use their commit as the record and
skip independent review; judge the consequence, not line count.

## Guardrails without constant interruptions

- The owner chooses outcomes, architecture, and approved looks/PDFs. Agents
  choose routine implementation and Git steps within that scope, including
  commits, pushes and integration, under [Git workflow](../git-workflow.md).
  An explicit owner-managed Git session suspends agent Git mutations.
- One writer per checkout. Parallel implementation needs separate worktrees,
  explicit ownership, and a useful reason.
- Ask for missing product intent, unresolved architecture, or an existing
  safety checkpoint. Give a recommendation and consequence.
- Record out-of-scope discoveries. Escalate boundary changes; log bypasses.
- At handoff, record new evidence and decisions in their owning records, and
  update the authoritative task. Generate the catch-up from these sources;
  preserve what cannot be inferred without maintaining a second status page.

## Review and adoption

Use the [eight-lens review protocol](review-protocol.md) and
[work-record templates](work-records.md). The default is one fresh reviewer,
with up to eight review rounds only when findings require them.

After acceptance, Claude establishes the minimum agreed instructions/reviewer
and uses them on the next meaningful CV task. Learn from actual friction there.
Plain records suffice; the [Backlog.md pilot](kanban-tooling-research.md) and
governance package are optional follow-up work. Neither blocks CV development.
