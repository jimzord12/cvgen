# Plan review: backlog-migration

Reviewed artifact: the migration plan, `docs/work/backlog-migration/plan.md`
(written 2026-10-06 in plan mode, before any change). Five fresh-context
reviewer rounds (Plan subagent, Opus), each given the plan, the settled
decisions, the round number, two lead lenses and every earlier report with
its dispositions. This file records the findings and dispositions in
summary; the plan itself carries every fix. The implementation review loop
follows in `01.md` onwards.

| Round | Lead lenses | Verdict | Findings |
|---|---|---|---|
| 1 | CLI feasibility; wiring completeness | FINDINGS | 5 Material |
| 2 | Fix correctness; agent session flow and rollback | FINDINGS | 3 Material, 4 Notes |
| 3 | End-to-end consistency; owner clarity | FINDINGS | 1 Material, 5 Notes |
| 4 | Regression after rewrite; owner-reserved operations | FINDINGS | 1 Material, 3 Notes |
| 5 | Round 4 fixes; executability against CLI help | PASS | 3 Notes |

## Findings and dispositions

- R1-M1 `created_date` cannot be set from the CLI. Fixed: dropped; dates stay in the Trello export.
- R1-M2 The migration task was created before `backlog init`. Fixed: init runs first.
- R1-M3 Parity counts were contradicted by the new task and the `trello-cli` cancellation. Fixed: parity is checked right after migration (26 tasks), then the deltas are stated.
- R1-M4 Split status edits across branches; `review.md` did not exempt task-status commits. Fixed: a task file changes only on its working branch; the handoff doc and idle-task edits are named in the record-keeping exemption.
- R1-M5 The wording check would hit unlisted files. Fixed: `brand/README.md`, the five agents and the `idea-run` command added; allowed folders named.
- R2-M1 The Trello skill was deleted before the export needed it. Fixed: deleted only after export and close.
- R2-M2 Cards edited after the parity check would be lost. Fixed: a late-change check by `dateLastActivity` runs before the freeze.
- R2-M3 The handoff doc on `main` was unreachable from worktrees. Fixed: read with `git show origin/main:<path>`, written from a clean `main` checkout or a short-lived `main` worktree.
- R3-M1 The board would sit closed through the review loop while `main` still pointed to Trello. Fixed: the review loop runs with Trello live, then freeze and merge happen back to back.
- R4-M1 Review rounds could exceed the five-round cap. Fixed: the implementation loop has at most four rounds before the freeze, and round 5 is the focused round on the freeze diff; a non-PASS reopens the board and goes to the owner.
- Notes adopted: `-l` vs `--add-label`; `--check-ac` via `task edit`; `doc create` returns the path; `--no-dod-defaults`; counts after the merge; open branches warned; plain-language owner decisions; check that init made no commit; checklist item text compared in parity.
