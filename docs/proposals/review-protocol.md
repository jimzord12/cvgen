---
kind: reference
---

# Review protocol: eight lenses, bounded rounds

Approved with the development protocol on 2026-09-16; Claude setup remains pending.
Implementation reviews run in Claude Code.
Codex may critique design proposals; that does not satisfy a code review gate.
Companion to the [development protocol](development-protocol.md).
Approval is included in that proposal's scope; this is not a separate decision item.

## When a review is required

Review behavior, data-contract, dependency, rendering, persistence, approval,
security, migration, and test-logic changes independently. Pure spelling,
comments, or mechanical formatting can skip the independent round after a
focused check. A one-line configuration change can be high risk; file count is
not the criterion. Record the reason when taking the small-change path.

## Give the reviewer a precise brief

- Task outcome, acceptance criteria, scope exclusions, and settled decisions.
- Exact base/head revisions. For uncommitted work, provide an identifiable
  patch snapshot plus relevant file hashes; a branch name alone is insufficient.
- Changed entry points and contracts, author checks, and evidence locations.
- Affected PDFs/screens and direct visual evidence from the reviewed version.
- Round number, two lead lenses, and prior reports with finding dispositions.

Use a newly invoked custom reviewer with fresh context, not a fork of the
implementation conversation. It reads surrounding code independently and gets
facts and evidence rather than the author's persuasive account of correctness.
Claude supports separate-context custom subagents; a fork inherits the parent
conversation. See [Claude subagents](https://code.claude.com/docs/en/subagents#how-forks-differ-from-other-subagents).

## The eight lenses

Cover all eight; briefly mark a lens not applicable with a reason. Start deeply
with the two most relevant to the change. These are prompts for investigation,
not eight quotas of findings.

| Lens | What to establish in this project |
|---|---|
| 1. Product fit and wiring | Does the real example/local command/backend path reach the change? Does it meet the agreed outcome and accepted design? |
| 2. Correctness and edge cases | Unknown service time, duplicate vessels, long names, empty sections, page splits, role variations, and sibling paths behave correctly. |
| 3. Data and document integrity | Candidate facts are preserved; revisions, hashes, approvals, retries, copies, and migrations cannot silently corrupt data or release the wrong PDF. |
| 4. Contracts, access, and privacy | Candidate and template schemas agree at their boundary; compatibility is deliberate; private records and credentials stay out of public artifacts; future approval/download access is enforced when implemented. |
| 5. Tests and visible evidence | Tests can detect the relevant defect, real compiler/PDF paths are exercised, and visual evidence shows the actual reviewed version. |
| 6. Failure handling and recovery | Overflow and missing data fail clearly; partial renders/exports cannot appear successful; retries have defined behavior and useful diagnostics. |
| 7. Simplicity and ownership | Responsibilities stay in their owning module/package, duplication or abstraction is justified, and scope has not expanded without authorization. |
| 8. Repository and documentation | Imports, packaging, frozen references, examples, docs, task state, LF endings, and commit scope remain coherent. |

Choose lead lenses from risk: wiring plus tests for integration work; integrity
plus contracts for approval or migration; correctness plus visual evidence for
rendering. Findings from any lens count in every round. Do not demand future
web features in a change that only implements the local engine.

## Depth and evidence

Trace the real caller and configuration path, not just the changed function.
Inspect adjacent paths for the same defect. Mark genuinely unrelated findings
outside scope and retain them for triage; widen the task only with authorization.
A pre-existing problem that prevents the acceptance criteria from being met is
still relevant to the current verdict.

For each changed test, identify the behavior it protects and whether it would
fail for the relevant broken behavior. Prefer a recorded pre-fix failure or a
safe isolated regression case where appropriate. Do not delete or neuter source
in the working checkout to demonstrate this. Avoid tests that only restate the
implementation. Existing real-compiler/PDF checks remain required; project
test conventions continue to apply. See also
[Google's review guidance on tests and complexity](https://google.github.io/eng-practices/review/reviewer/looking-for.html).

For a changed CV, the author supplies the rendered affected pages and the
comparison evidence required by the frozen design rule. For future web behavior,
the author exercises the actual local flow and supplies relevant screenshots or
recording. The reviewer inspects that evidence and checks its revision. Missing
required evidence is INCOMPLETE, not a clean PASS. Reviewers do not manufacture
the author's missing manual verification and then call it independent proof.

## Reviewer boundaries

The reviewer is source-read-only: no source edits, commits, approvals, installs,
cleanup, live delivery, or delegation. It may inspect files and rerun vetted
local checks that create fresh disposable outputs under `builds/`. This is an
explicit exception for test artifacts, not permission to overwrite existing
outputs, modify candidate workspaces, or touch external systems.

The future Claude definition should expose only the necessary read tools and
shell access for those checks; it should omit editing tools and disable nested
agents. Shell access can still write, so a tool list alone is not a security
sandbox. Confirm actual permissions and safe commands in Claude Code during
setup; do not claim that Markdown instructions enforce isolation.

Current non-trivial implementation changes still require the full repository
suite. Reviewers may rerun focused checks against the exact reviewed snapshot
and inspect the author's full-suite report. Additional runs must resolve a
specific uncertainty. A missing dependency or unsafe command is reported, never
worked around by installing packages or changing the environment silently.

## Findings and verdicts

| Severity | Meaning and handling |
|---|---|
| Blocking | Data loss, unauthorized release/access, or a broken critical path; must resolve. |
| Material | A demonstrable acceptance, correctness, contract, or verification defect; must resolve. |
| Minor | A concrete low-impact improvement; author fixes or records a reason to defer. |
| Note | Observation or optional preference; does not block. |

Each finding needs a stable ID, code or document anchor, concrete scenario,
expected versus actual behavior, impact, and the smallest useful correction.
Label uncertainty; an unsupported suspicion is an investigation item, not a
proven defect. Required evidence gaps can still make the review INCOMPLETE.
Architecture tastes do not override settled decisions. No finding quota.

Verdicts:
- **PASS:** all applicable lenses considered, required evidence available, and
  no unresolved Blocking or Material findings.
- **FINDINGS:** one or more unresolved Blocking or Material findings.
- **INCOMPLETE:** access, environment, missing evidence, or an unidentified
  snapshot prevents a justified verdict. Never treat this as PASS.

## The loop and its stopping rule

1. Claude finishes author checks and requests one fresh independent reviewer.
2. The author records the returned report unchanged and dispositions separately.
   It fixes Blocking/Material findings and reruns checks affected by the fixes.
   Disagreements need evidence and adjudication by the next reviewer; the author
   cannot unilaterally relabel a material defect to manufacture a pass.
3. Fixes that affect the reviewed implementation require another fresh review
   of the updated snapshot, with earlier reports and dispositions. Review fixes
   and their impact; consider all lenses without repeating a declined minor
   preference unless there is new evidence or an explained disagreement.
4. Stop at PASS. Owner-selected maximum: eight reviewer rounds. At the limit,
   keep the task unresolved and summarize the remaining problem and recommended
   next step. Further rounds require an explicit decision; there is no overnight
   doubling or endless loop looking for zero Notes.

For INCOMPLETE, resolve the missing evidence or environment issue before asking
for another review. Do not spend rounds rediscovering an unchanged blocker.

For an independently separable high-risk concern, a second focused reviewer
may join a round, for example approval/access or a data migration. The lead
Claude agent owns consolidation and contradictions; every uncovered lens must
still be reviewed. Prefer one reviewer unless the additional coverage is useful.
Choose a capable model available in the Claude session; no fixed model version
or maximum-effort setting is mandated by this proposal.

Repeated review churn is evidence for an observation or proposal under the
[tracking convention](README.md), not permission to weaken review gates
or reset the eight-round count by renaming the same task.

## Report and persistence

Keep each report under about 600 words unless findings need more. Include the
reviewed snapshot, lead lenses, eight-lens coverage, findings, checks actually
rerun, evidence inspected, limitations, and verdict. Never report an author-run
check as personally rerun. The lead agent stores the report under
`docs/work/<task-id>/reviews/`, links it from the authoritative task record,
and summarizes product impact to the owner in a few lines.

A PASS belongs to the examined implementation snapshot. Subsequent source,
configuration, fixture, or relevant contract changes invalidate affected
verification/review evidence. Appending a faithful review report or status
summary alone does not restart the code-review loop.

## Inspiration and adaptations

Adapted from the owner's supplied ICS reviewer and its eight-lens protocol.
Keep fresh context, real caller tracing, meaningful tests, visible evidence,
severity, and finding dispositions. Use this repository's privacy and LF rules;
do not import ICS-specific data-handling exceptions, CRLF rules, fiscal-domain
checks, or overnight review budgets. Preserve dates where they belong in
decisions and evidence records. Digital-signature verification is deferred
until it is an implemented requirement, rather than a speculative review gate.
