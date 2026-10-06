---
id: doc-1
title: session-handoff
type: other
created_date: '2026-10-06 07:25'
---

# session-handoff

Rewritten in place at the end of every session; the first thing a fresh session reads after AGENTS.md. Holds only what no task owns: what is next, parked owner decisions, machine facts, pitfalls. Task state stays in the tasks in `backlog/tasks/`.

**Written:** 2026-10-02, professional Travel & Tourism recalibration (Codex).
**Main at:** 0488c4f8496b06af201db4969e88f7298b52d7f5

## Current orientation
- Current checkout: docs/idea-run-2026-10-02-editor at aa179c32035a71de33b6bbfe284df0c9da43b1e5, pushed and clean. It inherits codex/repo-agents and docs/idea-run-2026-09-29-editor. Do not merge this ancestry wholesale into main: the older full idea run had its gates stopped. The new concept alone has closed gates; its task owns all current evidence: https://trello.com/c/tbvLsYim .
- Owner explicitly recalibrated toward professional, clean, well-organized, premium and controlled creativity; the earlier originality request was a reaction to generic designs. Future briefs must apply this latest steer while preserving Batch Test, Three-Second Test and Flagship craft.
- Main did not change. Exact-head main CI remains green: https://github.com/jimzord12/cvgen/actions/runs/36901796640 . No commits reached main since the prior handoff, so no missing main review was introduced.
- The seven repo-scoped Codex counterparts remain on codex/repo-agents and in this checkout. Setup evidence: https://trello.com/c/pc3a0vY1 . Shared repo skills remain under .claude/skills. Claude still owns production implementation and its review gate.

## Next and owner decisions
- Owner reviews the new Japan Passage two-page Spacious Stylish design, which remains proposed. Its PDF and brief are linked on the completed task card. Approval as a production Template has not been inferred; adoption would be a separate implementation task.
- Woodblock Road, Stamp Rally and Concourse remain proposed reference concepts; the new steer does not retroactively reject or approve their variants. The older full run still has its own open gates.
- Existing Queued cards remain trello-cli (conditional), travel-domain, deck-data and codex-visual-tools. No other Active/Review/Ready or Blocked work was listed after this task's completion.
- codex-visual-tools and docs/codex-visual-tools branch retain older open review context: inspect docs/work/codex-visual-tools/reviews/01.md and docs/work/design-core/reviews/03-context-reviewer.md before resuming. Do not infer that tool implementation is done because current design reviews used scoped general-purpose stand-ins.

## Inherited friction and machine facts
- Atlas check still reports five STALE pages: client-journey, design-run, change-review, system-map, roster. Existing generated files were not overwritten during this scoped concept task. The roster still lacks the Codex counterparts.
- client-workflow proposal metadata remains approved although the task is Done and implementation exists. Reconcile metadata with its evidence; do not invent an unapplied product decision.
- No night or follow-up is open. The last night was 2026-09-28-a, before the current handoff's day-before window; no new night exists. No branch/worktree or build cleanup was performed.
- Native Codex CLI 0.160.0 loads standalone .codex/agents/*.toml; actual native model-driven role invocation remains untested. codex debug prompt-input is not discovery proof. User config mcp_servers.Sanity.type warning is unrelated and remains untouched.
- Restricted Claude review needs an explicit --agents definition in this environment. See the Codex setup task for exact evidence and prior PASS.
- Windows cp1252 printing can fail after a successful metadata write with Greek text. Read the file and verify it before any retry; do not overwrite it. Run checks with PYTHONIOENCODING=utf-8. Trello credentials must never be copied into PowerShell variables.

## Constraints in force
- Live owner checkpoints override older broad cleanup permissions: explicit confirmation before deletions, overwrites, directory removals, generated/cache cleanup or discarding work; destructive Git also requires it. Routine reads, targeted edits, new outputs, verification and non-destructive Git remain authorized.
- Every render iteration uses a fresh path. New final review PDFs have a current Meta File and stay proposed until the owner chooses them. Never approve a real Client PDF.
- Public data is fictional; real candidate data remains private. Codex design work does not replace Claude's implementation/test/review gate.
