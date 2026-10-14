## Review round 1 (code): code-reviewer, 2026-10-14

Snapshot: `feature/task-38-workflow-check` at 1d85aaa, `git diff origin/main...HEAD` (base dbc11bd, 71 files). Lenses: 1 correctness and test strength; 2 wiring and failure modes.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Coverage: `bun run check` reaches the real model; 6 mutations of the real model, 5 caught by the right rule; cycle/loop logic hid nothing tried; new inputs recorded in GAPS.md; re-anchored anchors pass `source`; each fixture test asserts exactly its own rule at the expected path; missing Python or failing `--help` fails loudly; missing-Bun skip and CI failure correct; check.ts one module; LF, `diff --check` clean.

Material
- R1-1 `bun run anchors` does not exist: `tools/workflow/package.json` has only check, schema, typecheck, test; promised in `tools/workflow/README.md:34,121`, `AGENTS.md:112`, task note (9). Rerun: `Script not found "anchors"`, exit 1. Tests call the function directly. Fix: add the script and one test that `bun run anchors no-such-ref` exits 2.

Minor
- R1-2 `tools/workflow/src/check.ts:287,302-311`: when `--help` has no `{a,b}` group any subcommand passes; only `python`/`python3` matched; the rule executes `<script> --help` for any script named (a non-argparse script would run). Safe today (cv.py, outputs.py). Fix: report when a subcommand is given but no list parsed, and/or an allowlist.
- R1-3 task record evidence stale (cites tests-20261014-122858-135891, CI 38542659141; newer: tests-20261014-123544-045887, CI 38543503891).

Notes
- R1-4 CI does not upload `builds/ci/workflow-model/check.log`; low impact.
- R1-5 m5 (export without approval input) passes; order without data is outside levels 1-2 by the settled decision; name it for TASK-42.

Checks rerun (builds/review-task38-r1-20261014-123944/): `bun run check` exit 0 with NOTE; `bun test` 56 pass; typecheck exit 0; `bun run anchors` exit 1; mutations m1 drop loop.wording-fix -> [cycle]; m2 -> [cycle]+[unreachable]; m3 -> [unreachable]; m4 `cv.py exprot` -> [command]; m5 pass; m6 -> [cycle]. Full suite not rerun; CI and Atlas not inspected.

## Dispositions (lead)

- R1-1: fix (script plus the exit-2 test).
- R1-2: fix the silent pass (an issue when a subcommand is named but no list was parsed) and limit the rule to scripts under `scripts/` that the model names; no wider allowlist.
- R1-3: fix. R1-4: fix (add the log to the upload paths). R1-5: note added to TASK-42.
