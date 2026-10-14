## Review round 2: code-reviewer, 2026-10-14

Snapshot: `.worktrees/task-36` at 52d3165; round-1 fixes in e41a49d, the rest is the origin/main merge (docs/engine rename) and Atlas stamps. Lead lenses: the round-1 fixes; test strength.

Verdict: PASS. Recorded in substance (formatting condensed).

Coverage: the sample's `text.sign-off-stamp` is anchored correctly (`client-workflow.md:54, 266-269`); spaced, backslash and `C:/` paths behave as intended; Zod and the committed schema agree on every probe except reversed ranges (schema cannot express them; documented); errors give line, path, reason; glossary row and `--frozen-lockfile` right; LF.

Findings
- R2-1 Minor: three checks survive mutation (`tools/workflow/src/model.ts:24-25`, `:19` `.meta`): removing the reserved-prefix lookahead from `StageId`, resetting `StageId`'s message, and dropping `patternErrorMessage` from the ID `.meta` all keep 22 tests green. Fix: a broken-stage test with `id: art` checking the message, and an assertion that `stage.schema.json` carries the step-ID `patternErrorMessage`.

Notes
- R2-2: backslash paths (`docs\guides\x.md:3`) are accepted; decide in TASK-37/38 if anchors get resolved. A quoted newline inside a path matches `[^:]*`.
- R2-3: the saved LSP broken copy cannot be re-run in place (its `$schema` path); the evidence is genuine (re-run matches).

Checks rerun: LSP driver with yaml-language-server 1.24.0 on a byte-identical copy of the committed schema: sample 0 diagnostics; a broken copy flags reserved stage ID, `:L4` and `C:/x.md` with the custom `patternErrorMessage` text (so the editor shows it); spaced path accepted; reversed range flagged by the tool only. `bun run check`: sample 0, broken 1 with 6 problems. Mutations on a disposable copy: range refine removed, old source regex, `StepId` message caught; M4-M6 survived (R2-1). Outputs under `builds/review-task-36-r2/` in the worktree.

Limitations: VS Code itself not opened (the language server is its engine); suite and typecheck not rerun.

## Dispositions (lead)

- R2-1: fix (two tests). R2-2: carried to TASK-37's record. R2-3: accepted. A context-reviewer round follows.
