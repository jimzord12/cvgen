---
id: P-0004
kind: reference
---

# Proposal tracking

Use this convention when recording proposals, briefing the owner, or applying
a decision. Established on 2026-09-15 under the owner's request to settle the
tracking system. This does not approve the proposals being tracked.

## Proposal locations

Keep proposals in `docs/proposals/`, with rejected proposals under
`docs/proposals/rejected/`. Other status changes leave the file in place.
Keep rejected and applied proposals so their reasons remain available.
Use short descriptive filenames. Rough ideas stay in the relevant work record
until they are ready for a decision.

On rejection, record the decision and `status: rejected`, then move the file
into `rejected/`. Update affected incoming and outgoing relative links; never
overwrite an existing destination. On explicit reopening, move it back to
`docs/proposals/`, set `status: pending`, and retain its decision history.

Each decision-ready proposal starts with this metadata:

```yaml
---
id: P-NNNN
kind: proposal
status: pending
revision: 1
created: YYYY-MM-DD
---
```

Read metadata only from the opening block, not from examples in the document.
`id` is stable for the file's life, moves included: take the `next_id` of
`python scripts/proposals.py --json`, never reuse one; when two branches took
the same one, the later to merge renumbers before it merges. `created` is the
date the file was added (never in the future); it gives the proposal's age.
Use `kind: reference` for supporting material, with an `id` but no
independent status or approval request. A proposal names any supporting
documents included in its scope. The README is the tracking convention, not a pending proposal.

`python scripts/proposals.py` reads every file here, refuses by name any file
that breaks the rules above, and prints the one line a
session gives the owner (`N proposals: X pending (Y older than 7 days), ...`).
With `--json` it also writes the snapshot (id, title, status, revision, age in
days, path, `next_id`) into a new `builds/proposals-<timestamp>/`: a derived
view for reading, never a second queue.

## States and transitions

| Status | Meaning | Who moves it onward |
|---|---|---|
| `pending` | Ready for an owner decision, including a completed trial. | Owner approves, rejects, defers, or authorizes a trial. |
| `trial` | A scoped experiment is authorized; its record distinguishes awaiting setup from execution. | Agent records its result and returns it to `pending` at its endpoint. |
| `approved` | Owner accepted this revision; applying it remains outstanding. | Responsible agent applies and verifies the authorized change. |
| `applied` | The approved change is in effect, with evidence linked. | Closed; a later change needs a new proposal. |
| `rejected` | Owner declined it; file and reason live in `rejected/`. | Closed unless the owner explicitly reopens it as `pending`. |
| `deferred` | Owner chose to leave it for later. | Return to `pending` when the owner requests it or a recorded revisit condition is met. |

The usual path is `pending -> approved -> applied`. The optional experiment
is `pending -> trial -> pending`. Silence does not change status. Trials have
a named scope and endpoint; trial permission is not permanent approval. The
owner may also stop a trial into `rejected` or `deferred`, or revoke an
unapplied approval into either state. Stop affected work when permission ends.

## One record, enough context

The proposal contains the problem, smallest suggested change, consequence,
recommendation, and decision requested. Append brief dated entries for owner
decisions, trial results, and application evidence. Record authorization scope
and a traceable source without copying private chat into public documentation.
Update the status with the corresponding event; never maintain a second queue.

Approval covers the stated revision and named supporting documents. Material
changes to that scope need a new revision and decision; preserve the previously
approved content and reason. An applied rule is changed through a new linked
proposal, not by rewriting the old approval.

An agent records decisions; it cannot invent owner approval. Applying a proposal
follows task priority, harness roles, and existing permissions. Design approval
does not grant deletion or unrelated implementation authority. Routine Git work
is authorized separately by the [Git workflow](../git-workflow.md). Rejected
trials may still have cleanup work; link that task and follow existing checkpoints.

## What the owner hears

At session orientation and meaningful progress updates, run
`python scripts/proposals.py`, tell the owner its line, then read the metadata
and evidence of the items that need him directly from the main proposals folder. Consult
`rejected/` for relevant history or reopening, not as an approval queue.
Report pending decisions with a short explanation,
recommendation, and link. Also distinguish approved work awaiting application
from active trials. Deferred/rejected/applied items do not demand another decision.

Before acting, check applicable rules and approvals for the task. Reuse granted
permission; do not ask again. If status conflicts with recorded decisions or
evidence, flag the discrepancy and resolve it before dependent work. Orientation
itself is read-only: no state changes, saved status summary, or background watcher.
