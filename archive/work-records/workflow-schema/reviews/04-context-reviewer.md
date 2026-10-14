## Review round 4 (context round 2): context-reviewer, 2026-10-14

Snapshot: `747d01b..74edd01` in `.worktrees/task-36`. Lens: the round-3 dispositions.

Verdict: PASS. Recorded in substance (formatting condensed).

Checked against the code: `src/model.ts:124-130` defines `given` (default false) and describes `third-party` and `ephemeral` as disposed; both schemas regenerated (`schema --check` 0); the sample uses `given: true` (`stage.yaml:116`) and `art.client-reply` is `third-party` (`:108`); a test asserts `given` defaults to false; no live `external` boolean in tools/, backlog/, ADRs, glossary or `.atlas/src` (remaining hits are dated records; site.json's `"kind": "external"` is unrelated); the README paragraph is right and findable; the TASK-37 note agrees; m1-m3 applied; TASK-38's title already says "the workflow tool". `atlas check --strict` exit 0; sample check 0; LF; no client data.

Minor
- m1: `tools/workflow/README.md:46-54` maps only the inventory's `external`; the handoff's flow rule "produced by an earlier step or marked external" (`docs/work/workflow-model/handoff.md:216`) is now `given`, and TASK-38 cites the handoff. Fix: one clause or a TASK-38 note.

Note
- TASK-36's description still says "with external artifacts"; original request text, overridden by the decision; leave it.

## Dispositions (lead)

- m1: fixed with a note on TASK-38. Note: accepted.
