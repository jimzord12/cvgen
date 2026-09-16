---
kind: reference
---

# Small work records

Approved with the development protocol on 2026-09-16; application remains pending.
Companion to the
[development protocol](development-protocol.md). These are Markdown records,
not a new task-tracking application.
Approval is included in the development proposal's scope.

## Generate current state on demand

Read the vision, decisions, authoritative tasks, repository state, and relevant
evidence to produce Goal / Now / Next / You. Show ready owner decisions without
maintaining a separate approval queue. Repeating this read-only action must not
change the sources; unchanged inputs yield the same factual state. Do not use
the retired `docs/now.md` snapshot. No reporting command is implemented yet.

Keep original facts, decisions, and evidence in their owning records. Avoid
copying changing state into summaries, dashboards, or handoffs that must be kept
in sync. A saved report, when explicitly useful, is a dated snapshot rather than
an authority. Missing or contradictory evidence stays visible as uncertainty.

## One record per meaningful implementation task

Keep the brief and result together. Small fixes can use the commit body instead;
multi-session work, contract changes, or migrations deserve a persistent file.
The template below becomes `docs/work/<id>/task.md` after adoption if no task
tool is chosen. If the [Backlog.md trial](kanban-tooling-research.md) succeeds,
map these sections into its native task record and link review reports under
`docs/work/<id>/reviews/`. Keep one authoritative brief and status, not copies
in both stores. A future hosted board would need an explicit migration/export
plan rather than an automatically synchronized second ledger.

```markdown
# <ID>: <Outcome>

Status: Queued | Active | Review | Ready | Done | Blocked | Cancelled
Owner: <Claude session or agent responsible; no ambiguity between writers>
Branch/worktree: <location>
Integration target: <main or the named parent feature branch>
Depends on: <task/decision links, or none>

## Outcome and boundaries
<What becomes possible. What this task changes and excludes.>

## Acceptance
- [ ] <Observable behavior and the evidence that will establish it.>

## Plan
<A few steps; omit for a small obvious change.>

## Result and evidence
<Implemented behavior; exact code revision or patch snapshot; commands, exit
results, and artifact locations. Distinguish old evidence from current proof.>

## Review
<Report links, Blocking/Material finding dispositions, remaining limitations.>

## Handoff
<Current state, unresolved issue if any, one exact next action, and any owner
authorization already given with the specific scope it applies to.>
```

Acceptance describes product behavior rather than merely listing functions to
write. For a migration, an example is: all existing public examples still build
and the engineer PDF remains pixel-identical to the frozen reference.

Update the current sections as work progresses; preserve original review reports
and decision records. A material scope change needs its decision and reason
recorded, so the acceptance criteria cannot quietly shrink around unfinished
work. Observations outside scope get a short backlog item, with a link back.
Process friction follows [proposal tracking](README.md): begin with
a short observation, then link a proposal only when an experiment is useful.
Process authorization records remain separate from task progress.

## What survives a session

At a meaningful checkpoint or handoff, save what the next agent cannot infer:
scope decisions, approval references, relevant changed paths, exact evidence,
unresolved findings, and next action. Use relative repository links for public
records; real candidate material remains in the private workspace.

Do not create a second mandatory handoff document when the task record already
contains the needed state. An explicit owner request for a separate handoff can
still be fulfilled. Do not copy entire conversations or private preferences into
shared records.

Build artifacts are usually local and ignored. Mark their availability honestly;
keep a committed concise result summary plus retained release/CI evidence when
available. A missing old artifact is not current proof. Cleanup must preserve
the evidence still needed by active work or deliberate milestones and follow
the existing confirmation checkpoint.

## Ready is not Done

Ready means the requested implementation and required verification/review are
complete. Done means the change reaches its intended integration branch, the
push and CI result are confirmed, and evidence is recorded. The agent manages
that Git work unless the owner takes it over for the session. Record the commit
and target; a child task reaching a feature branch is not the whole feature
reaching `main`. Design approval alone does not make an implementation task Done.
