# dev-setup: Activate the development protocol and the independent reviewer

Status: Active
Owner: Claude Code (implementation session of 2026-09-16)
Branch/worktree: `docs/product-direction`, main checkout
Integration target: `main`
Depends on: approved [development protocol](../../proposals/development-protocol.md)
revision 2 with its [review](../../proposals/review-protocol.md) and
[work-record](../../proposals/work-records.md) companions; ADR 0010 is not
required for this task.

## Outcome and boundaries

After this task an agent can open one file for the working rules
(`docs/development.md`), one for the review rules (`docs/review.md`), and
invoke a fresh-context `code-reviewer` subagent that follows them. The three
proposals become history with an application entry. No task tool, governance
package or CLI is installed; the Trello trial is a separate task.

## Acceptance

- [x] `docs/development.md` and `docs/review.md` exist and carry every active
  rule from the approved proposals; `AGENTS.md` routes to them.
- [x] `.claude/agents/code-reviewer.md` is a thin wrapper: no rule text that
  can drift from `docs/review.md`; tools limited to Read, Grep, Glob, Bash,
  PowerShell; no Agent tool.
- [x] Claude Code discovers and invokes `code-reviewer` with fresh context.
  Evidence: against an isolated fictional fixture it reports the planted
  defect and returns INCOMPLETE/FINDINGS when evidence is missing; against a
  satisfactory fixture it returns PASS; it edits nothing.
- [ ] This task itself passes a `code-reviewer` round whose report is stored
  under `reviews/`.
- [ ] The three proposals record the application with links to this record
  and move to `applied`.

## Plan

Execution plan for the whole handoff of 2026-09-16, one task record each:

1. `dev-setup` (this record): the two protocol files, the reviewer wrapper,
   routing, reviewer validation, first real review round.
2. `trello-trial`: `.claude/skills/trello/SKILL.md` with direct API calls,
   two fictional cards, phone verdict, adoption decision at the endpoint.
3. `monorepo-migration`: ADR 0010 layout on a feature branch; candidate facts
   separated from the Flagship input contract via the template adapter;
   frozen reference bytes and baseline preserved.
4. `pdf-workflow`: smallest `cv-workflow` boundary with local revision,
   approval and export commands, tested end to end on fictional data.

## Result and evidence

2026-09-16, branch `docs/product-direction`:

- Written: `docs/development.md`, `docs/review.md`,
  `.claude/agents/code-reviewer.md`; `AGENTS.md` routes to them.
  `claude plugin validate .claude/agents/` reports "Validation passed"
  (Claude Code 2.1.273).
- Reviewer validation against two fictional fixtures in the session
  scratchpad (a tiny `total_months` module; nothing from the product):
  - Case A (open-ended period silently skipped, tests that pass with the body
    deleted, evidence folder promised but absent): verdict **FINDINGS**, six
    findings including the planted defect (A1), two further real defects
    (A2, A3), worthless tests (A4) and the missing evidence (A6).
    Report unchanged: [evidence/reviewer-check-a.md](evidence/reviewer-check-a.md).
  - Case B (correct module, discriminating tests, evidence present): verdict
    **PASS** with two Minor hardening notes.
    Report unchanged: [evidence/reviewer-check-b.md](evidence/reviewer-check-b.md).
  - Tools reported by the reviewer in both runs: Read, Grep, Glob, Bash,
    PowerShell. SHA-256 of all seven fixture files identical before and after
    ([evidence/hashes-before.txt](evidence/hashes-before.txt),
    [evidence/hashes-after.txt](evidence/hashes-after.txt)).
- Invocation path used: `claude -p --agent code-reviewer --add-dir <fixture>
  --allowedTools "Bash(python -m pytest:*)"`, a fresh headless process. The
  in-session Agent tool could not see the subagent because `.claude/agents/`
  was created during the session; Claude Code documents that a new agents
  directory is only picked up after a restart. In-session invocation is still
  to be confirmed in the next session (see Handoff).

Observations (process friction, for later triage under proposal tracking):

- O1: the reviewer's shell sandbox in headless mode rejected compound
  commands (`cd`, `&&`, `tee`), so it could not persist its rerun output under
  `builds/` or compute hashes itself. Consequence: the brief must carry file
  hashes for uncommitted snapshots, as `docs/review.md` already requires, and a
  committed revision is the easier snapshot. Suggested step: prefer reviewing
  commits; revisit sandbox allowances if in-session runs show the same limit.
- O2: in this harness a Bash heredoc could not write into `.claude/`; the
  Write tool could. No rule change needed; noted for the next agent.

## Review

_Round 1 pending: to be run against the commit that carries this record._

## Handoff

Current state: setup written and validated headlessly; awaiting review round 1
and the proposal application entries.
Next action: after the next session restart, invoke `code-reviewer` through
the Agent tool once (any small brief) to confirm in-session discovery, and
note the result here.
Owner authorization in effect: the handoff of 2026-09-16 authorizes all four
milestones; routine Git under `docs/git-workflow.md`; no deletion or
destructive Git without an explicit checkpoint.
