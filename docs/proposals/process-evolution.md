---
kind: proposal
status: deferred
revision: 1
---

# Evolving the development system

Deferred, 2026-09-15: the owner prioritized a barely functional process and
returning to CV work. The minimal [proposal tracking convention](README.md) is
active. Broader governance/package design below is future material, not an
installation or implementation authorization. Revisit when actual task friction
justifies automation or the owner requests the reusable package.

## The recommendation

Use the smallest process that helps deliver the next CV improvement. Record an
idea, try it within authorized scope, bring the result to the owner, and apply
the decision. A reusable package remains a future option; designing or building
it is not a prerequisite for using this flow or returning to CV work.

## The owner and agent flow

1. **Notice:** an agent encounters a concrete problem and records a small proposal.
2. **Try:** within granted permission, try the change on a named task with an endpoint.
3. **Bring the decision:** at the next progress update or session start, the agent
   reads proposal/trial records and surfaces anything ready: what changed, whether
   it helped, its recommendation, and "accept, reject, or later?" The owner does
   not need to browse records or remember to ask.
4. **Apply:** record the owner's decision. For acceptance, carry out the authorized
   update to the governing rules and verify it; for rejection, stop the experiment
   and handle cleanup under existing permissions. Keep the reason either way.
5. **Continue:** each agent's startup/task check reads governing rules and relevant
   decisions. Apply adopted rules; surface approved changes awaiting integration
   and finish them when in the authorized task scope. No reliance on chat memory.

Derive pending decisions, applicable trials, and integration status from their
owning records each time. Do not maintain a second queue or status summary.
Notifications happen during active sessions; this proposal creates no background
monitor. Reporting never changes a decision or turns approval into implementation.

That flow is the initial scope. The design notes below are deferred options,
not required deliverables. Stop process work once the next CV task can proceed.

## Deferred design notes

Three responsibilities stay clear:

- **Task board:** what work exists, who owns it, and its progress.
- **Process governance:** which development rules were proposed, tried, and adopted.
- **PDF workflow:** which exact candidate PDF the owner approved for export.

The governance package has no dependency on the CV engine, PDF workflow, or
chosen board. CV rendering and delivery do not depend on it either.

## Observe without creating busywork

At a meaningful checkpoint, record concrete friction: a confusing handoff,
repeated approval interruption, conflicting instructions, review churn, missing
evidence, or excessive bookkeeping. Include the affected task, consequence,
and smallest useful improvement. A single serious gap can justify action;
routine annoyances can wait for a repeated pattern.

Use one short observation, not a proposal for every idea. Check existing entries
first. Continue the authorized task unless the gap blocks it. Do not invent a
finding quota, redesign the process mid-task, or silently change active rules.

## Proposal to adoption

The active states and transitions are defined only in the
[tracking convention](README.md#states-and-transitions). The ideas below add
possible future detail; they do not add extra required states or records.

A proposal may be withdrawn or rejected before a trial. Record why. A wording
correction with no behavior change needs no experiment; meaningful changes to
authority, gates or workflow use the lifecycle. If a trial adds no useful
evidence, the owner can explicitly accept a proposal directly with the reason
recorded. Revising or extending a trial needs a new scoped decision.

Reuse trial authorization already given; do not ask again to act within it.
Isolated exploratory checks within an authorized task can proceed under the
existing rules. Applying experimental rules to project work needs trial scope.
Keep one process trial per task by default so its effects remain understandable.

Trial plans name an endpoint: task count or date. Once reached, the variation
stops applying to new work and the baseline applies again. Record how an
in-flight task returns to baseline; if that cannot be done safely, pause the
affected part. Expiry never authorizes a file rollback or deletion. A trial may
stop early on harm or failed criteria; silence never renews it or adopts it.

Existing safety, privacy, frozen-reference, verification, and merge constraints
still apply. A trial cannot grant itself an exception. The adopted protocol
governs proposals to change that same protocol, avoiding self-approval.

## Filesystem layout

Proposed additions to the approved monorepo; these paths are not implemented:

```text
packages/
  cv-engine/
  cv-workflow/
  process-governance/
    README.md                  # Public contract and standalone usage
    schema/                    # Versioned proposal/trial/decision records
    src/                       # Transition checks, file storage, small CLI
    tests/                     # Valid/invalid decisions and transition cases
docs/
  development.md               # Current adopted working protocol
  review.md                    # Current adopted review protocol
  process/
    observations.md            # Brief friction log; link promoted entries
    changes/PROC-001/
      proposal-v1.md           # Version freezes when authorized
      trials/01.md             # Results, cost, link to the approved trial plan
      decisions/01.json        # One explicit owner decision
      completion.md            # Integration or retirement evidence
```

This tree is an earlier extraction idea, not the current storage convention.
For now proposals live in `docs/proposals/`, with rejected ones in its `rejected/`
subfolder, and decisions/trials are recorded inside the proposal. Any further
migration needs a demonstrated benefit and an
explicit decision, preserving links. A board card only links the owning record.

## What approval means

A decision records: schema version, project ID, change ID, proposal version,
decision type, authorized scope, owner identity, timestamp, authorization source,
and relevant trial evidence. Bind it to the SHA-256 of the exact approved
proposal, including its trial plan; freeze that input. New versions get new
decisions. Trial results are separate evidence, not edits to the approved plan.
Freeze completed results and reference their snapshot when deciding adoption;
append corrections with a reason instead of quietly changing the evidence.

Agents may transcribe an explicit owner decision, retaining a concise, traceable
source and scope. Public records must omit personal chat and candidate data;
private provenance can stay in ignored local records with an honest availability
note. Missing or contradictory authorization cannot be inferred from a task
column, checkbox, passing test, expired timer, or agent recommendation.

Hashing detects changed inputs; it does not prove who approved them. Initially
this is a trusted local workflow with recorded human authorization, not a
tamper-proof identity system. If later used across untrusted writers, add an
authenticated approval boundary before claiming machine-enforced owner identity.

Preserve decisions and rejection reasons. Supersede with a new linked record
instead of rewriting earlier decisions. If accepted content changes before
integration, obtain a decision covering the new version. Rejection is not
blanket permission to delete files: prepare exact cleanup commands/paths and
follow the repository's explicit confirmation checkpoint.

## Small package, practical extraction

If automation later becomes worthwhile, it could validate records, check transitions,
record decisions, and report effective state. Keep I/O at the boundary
[reading/writing files surrounds the decision rules]. Project policy and record
locations are inputs; marine terms and Claude-specific instructions stay outside.

At that point, prefer one file store and a thin CLI. Add a board adapter only when a manual link
causes a demonstrated problem. Defer a service, database, dashboard, policy
language, plugin system, and generic approval for unrelated business processes.

Before extraction, demonstrate use in a second project and standalone tests
without this repository's configuration. That evidence, not a template count,
justifies publishing a reusable package. The first pilot can exercise this
protocol with plain files; it does not require building its own automation first.
