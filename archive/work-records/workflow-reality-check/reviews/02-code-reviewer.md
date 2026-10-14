## Review round 1 (code): code-reviewer, 2026-10-14

Snapshot: `origin/main...HEAD`, base a84e303, head 9051736. Lenses: 1 safety and truth; 2 tests and wiring.

Verdict: PASS (no Blocking or Material). Recorded in substance (Alias only).

Coverage: `bun run reality` and `envelope` wired through cli.ts and package.json, suite via `tests/workflow.py:run_reality`; CI 38550875459 green on 9051736; wave and gate walk checked, the 54 steps not taken explained in reality.log; both proofs fail for the stated reasons; `stamp --root` keeps the TASK-44 guards; `envelope` read-only and leaks nothing; deleting reality.ts fails the suite case and `bun test`; first problem stops the run naming the step; reuses TASK-38's loader via `entities()`; docs, GAPS, Atlas updated; LF, `git diff --check` clean.

Minor
- F1 `tools/workflow/src/reality.ts:403`: an output that already existed is accepted unchanged (`text-draft.draft-sent`, `text-draft.sign-off-stamp`, `deliver.stamp-delivered` re-stamp an existing Meta File); a wrong status or a no-op stamp still passes. Fix: hash pre-existing declared outputs before a `cmd` step and fail if byte-identical after, or record the limit in GAPS.md.

Notes
- N1 `docs/workflow/05-design/stage.yaml:621` `design.preview` is a lead stand-in that makes an empty folder, and the design-review stand-in then passes it; one line in GAPS.md.
- N2 cli.ts `"schema" &&(rest`: missing space.

Checks rerun: `bun run reality` exit 0, 50 steps (10 commands, 40 stand-ins), about 6 s, final statuses draft signed-off and cv delivered, every command line inside the run's copy under builds/; `run_reality` 3 cases pass in 15.1 s (renamed output: `FAIL deliver.render: art.render-json ... render-record.json is not there`; export before approval: real cv.py `REFUSED ... not approved`, `FAILED level 3 at deliver.export`); `outputs.py stamp --root` walked with scratch PDFs: approved without receipt, delivered without receipt, signed-off without the PNG refused (exit 2); render allowed; without `--root` refused; loose PDF refused; real-tree PDF with a builds/ root refused; `reference.pdf` delivered allowed (existing legacy exception); `envelope` on Alias client-2026-09-03: Envelope 22 entries and whole `private/` 926 entries, identical hashes of paths, mtimes and sizes before and after; worktree status unchanged; output names no folder or candidate; 17 complete, 1 partial, 23 none; 18 of 37 present. Limitations: suite not rerun; report.json does not record its commit; CI checked by SHA and conclusion only.

## Dispositions (lead)

- F1: fix (hash before, fail if unchanged after, for re-stamp steps). N1: one GAPS.md line (merged into the context round's reorganised section). N2: fix.
