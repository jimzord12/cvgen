# Review protocol

Read this before requesting, performing or recording a code review. Active
since 2026-09-16 under the approved
[development protocol](proposals/development-protocol.md); its original
specification is [review-protocol.md](proposals/review-protocol.md) and stays
there as history. Implementation reviews run in Claude Code through the
`code-reviewer` subagent defined in `.claude/agents/code-reviewer.md`, which
is a thin wrapper around this file. Codex may critique design proposals; that
does not satisfy a code review gate.

## When a review is required

Review behaviour, data-contract, dependency, rendering, persistence, approval,
security, migration and test-logic changes independently. Pure spelling,
comments, mechanical formatting or a term row added, renamed or dropped in
`docs/glossary.md` (its Rules section is not a row) can skip the
independent round after a focused check; for a term row, that check is
that its code name matches the tree at that commit and anything unbuilt
says so. The term-row path was adopted by the lead on 2026-09-25 under the
owner's "as little friction as possible". A one-line configuration change can be high risk; file count
is not the criterion. Record the reason when taking the small-change path.

Idea runs are the one other exception (adopted by the lead on 2026-09-25 to
carry out the owner's instruction that idea work runs in its own closed
review loop; parked for the owner to confirm on the session-handoff card,
and replaced here by his dated decision when he answers): new files in
`design-concepts/`, the run's rows in `design-concepts/README.md`, an idea
run's folder under
`docs/work/idea-runs/` and proposals that passed both gates in
`docs/proposals/` are reviewed by the idea gates of
`.claude/skills/idea-run/SKILL.md` instead of this gate. Any other file an
idea run touches, and every change to the idea agents or the skill
themselves, is reviewed here.

## Give the reviewer a precise brief

- Task outcome, acceptance criteria, scope exclusions and settled decisions.
- Exact base/head revisions. For uncommitted work, an identifiable patch
  snapshot plus relevant file hashes; a branch name alone is insufficient.
- Changed entry points and contracts, author checks and evidence locations.
- Affected PDFs/screens and direct visual evidence from the reviewed version.
- Round number, two lead lenses, and prior reports with finding dispositions.

Invoke `code-reviewer` fresh for every round (the Agent tool with
`subagent_type: code-reviewer`), never a fork of the implementation
conversation and never an author self-review. It reads surrounding code
independently and gets facts and evidence rather than the author's account
of correctness.

## The eight lenses

Cover all eight; briefly mark a lens not applicable with a reason. Start
deeply with the two most relevant to the change. These are prompts for
investigation, not eight quotas of findings.

| Lens | What to establish in this project |
|---|---|
| 1. Product fit and wiring | Does the real example/local command/backend path reach the change? Does it meet the agreed outcome and accepted design? |
| 2. Correctness and edge cases | Unknown service time, duplicate vessels, long names, empty sections, page splits, role variations and sibling paths behave correctly. |
| 3. Data and document integrity | Candidate facts are preserved; revisions, hashes, approvals, retries, copies and migrations cannot silently corrupt data or release the wrong PDF. |
| 4. Contracts, access and privacy | Candidate and template schemas agree at their boundary; compatibility is deliberate; private records and credentials stay out of public artifacts; future approval/download access is enforced when implemented. |
| 5. Tests and visible evidence | Tests can detect the relevant defect, real compiler/PDF paths are exercised, and visual evidence shows the actual reviewed version. |
| 6. Failure handling and recovery | Overflow and missing data fail clearly; partial renders/exports cannot appear successful; retries have defined behaviour and useful diagnostics. |
| 7. Simplicity and ownership | Responsibilities stay in their owning module/package, duplication or abstraction is justified, and scope has not expanded without authorization. |
| 8. Repository and documentation | Imports, packaging, frozen references, examples, docs, task state, LF endings and commit scope remain coherent. Prose uses the official terms of `docs/glossary.md`; a new recurring term, a synonym or a word with two meanings is a Note proposing a glossary term. |

Choose lead lenses from risk: wiring plus tests for integration work;
integrity plus contracts for approval or migration; correctness plus visual
evidence for rendering. Findings from any lens count in every round. Do not
demand future web features in a change that only implements the local engine.

## Depth and evidence

Trace the real caller and configuration path, not just the changed function.
Inspect adjacent paths for the same defect. Mark genuinely unrelated findings
outside scope and retain them for triage; widen the task only with
authorization. A pre-existing problem that prevents the acceptance criteria
from being met is still relevant to the current verdict.

For each changed test, identify the behaviour it protects and whether it would
fail for the relevant broken behaviour. Prefer a recorded pre-fix failure or a
safe isolated regression case where appropriate. Do not delete or neuter
source in the working checkout to demonstrate this. Avoid tests that only
restate the implementation. Existing real-compiler/PDF checks remain required;
`conventions.md` continues to apply. See also
[Google's review guidance](https://google.github.io/eng-practices/review/reviewer/looking-for.html).

For a changed CV, the author supplies the rendered affected pages and the
comparison evidence required by the frozen design rule. For future web
behaviour, the author exercises the actual local flow and supplies screenshots
or a recording. The reviewer inspects that evidence and checks its revision.
Missing required evidence is INCOMPLETE, not a clean PASS. Reviewers do not
manufacture the author's missing manual verification and then call it
independent proof.

## Reviewer boundaries

The reviewer is source-read-only: no source edits, commits, approvals,
installs, cleanup, live delivery or delegation. It may inspect files and rerun
vetted local checks that create fresh disposable outputs under `builds/`. This
is an explicit exception for test artifacts, not permission to overwrite
existing outputs, modify candidate workspaces or touch external systems.

The subagent definition exposes `Read`, `Grep`, `Glob`, `Bash` and
`PowerShell` only: no editing tools and no `Agent` tool, so it cannot spawn
nested agents. It pins Opus at maximum effort, the owner's standing
preference for reviewers; the protocol itself mandates no model. Shell
access can still write, so the tool list is relied on together with the
reviewer's instructions and a read of its report; it is not a security
sandbox. Verified on 2026-09-16 against fictional fixtures; see
`docs/work/dev-setup/task.md`.

Current non-trivial implementation changes still require the full repository
suite. Reviewers may rerun focused checks against the exact reviewed snapshot
and inspect the author's full-suite report. Additional runs must resolve a
specific uncertainty. A missing dependency or unsafe command is reported,
never worked around by installing packages or changing the environment.

## Findings and verdicts

| Severity | Meaning and handling |
|---|---|
| Blocking | Data loss, unauthorized release/access, or a broken critical path; must resolve. |
| Material | A demonstrable acceptance, correctness, contract or verification defect; must resolve. |
| Minor | A concrete low-impact improvement; author fixes or records a reason to defer. |
| Note | Observation or optional preference; does not block. |

Each finding needs a stable ID, code or document anchor, concrete scenario,
expected versus actual behaviour, impact and the smallest useful correction.
Label uncertainty; an unsupported suspicion is an investigation item, not a
proven defect. Required evidence gaps can still make the review INCOMPLETE.
Architecture tastes do not override settled decisions. No finding quota.

- **PASS:** all applicable lenses considered, required evidence available,
  and no unresolved Blocking or Material findings.
- **FINDINGS:** one or more unresolved Blocking or Material findings.
- **INCOMPLETE:** access, environment, missing evidence or an unidentified
  snapshot prevents a justified verdict. Never treat this as PASS.

## The loop and its stopping rule

1. Claude finishes author checks and requests one fresh `code-reviewer`.
2. The author records the returned report unchanged and dispositions
   separately. It fixes Blocking/Material findings and reruns checks affected
   by the fixes. Disagreements need evidence and adjudication by the next
   reviewer; the author cannot relabel a material defect to manufacture a pass.
3. Fixes that affect the reviewed implementation require another fresh review
   of the updated snapshot, with earlier reports and dispositions. Review
   fixes and their impact; consider all lenses without repeating a declined
   minor preference unless there is new evidence or an explained disagreement.
4. Stop at PASS. Maximum reviewer rounds (owner's instruction, 2026-09-25):
   **5** when the owner is attending the session, **10** when the work runs
   unattended (for example overnight). At the cap, keep the task unresolved
   and bring the owner the remaining problem and the recommended next step.
   Further rounds require an explicit owner decision.

For INCOMPLETE, resolve the missing evidence or environment issue before
asking for another review. Do not spend rounds rediscovering an unchanged
blocker.

For an independently separable high-risk concern, a second focused reviewer
may join a round, for example approval/access or a data migration. The lead
agent owns consolidation and contradictions; every uncovered lens must still
be reviewed. Prefer one reviewer unless the additional coverage is useful.

Repeated review churn is evidence for an observation or proposal under
[proposal tracking](proposals/README.md), not permission to weaken review
gates or reset the round count by renaming the same task.

## Report and persistence

Each report is under about 600 words unless findings need more and includes
the reviewed snapshot, lead lenses, eight-lens coverage, findings, checks
actually rerun, evidence inspected, limitations and verdict. Never report an
author-run check as personally rerun. The lead agent stores the report
unchanged as `docs/work/<task-id>/reviews/<NN>.md`, links it from the task
record with its dispositions, and summarizes product impact to the owner in a
few lines.

A PASS belongs to the examined implementation snapshot. Subsequent source,
configuration, fixture or relevant contract changes invalidate affected
verification and review evidence. Appending a faithful review report or
status summary alone does not restart the loop.
