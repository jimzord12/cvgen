## Review round 1 (code): code-reviewer, 2026-10-14

Snapshot: `302123d..df0ec7e`. Lenses: 2 correctness; 5 tests and wiring.

Verdict: FINDINGS. Recorded in substance.

Coverage: wiring in place (package.json, cli.ts, CI after `render --check`, suite case); output deterministic; every `[[client-journey#...]]` link resolves (only design-run.json:320); a failing model or an actor missing from site.json writes nothing; docs consistent.

Material
- F1 `tools/workflow/src/cli.ts:126-133`; task decision (4); verification.md "STALE ... client-journey.json": an unrelated model edit clears real staleness. Reproduced on a scratch copy: an edit inside the span cited by `intake.consent` made client-journey STALE and `bun run atlas` correctly did not stamp; then an unrelated step-name change in `07-after/stage.yaml` and `bun run atlas` wrote and stamped all 23 sources, client-journey `ok`. `bun run check` never compares the text inside a cited span. Fix: run the kit's staleness check first; if any source is already stale, write but do not stamp, print the stale files, point to `bun run anchors <base>` and a manual stamp, exit non-zero; a scratch-copy test.

Minor
- F2 `tools/workflow/test/atlas.test.ts:66-80`: no test exercises the stamping path (incl. stamp failure); removing `stamp()` leaves all 99 tests green. Fix: one test on a temporary copy of `.atlas/` plus `docs/workflow`, with F1's.

Notes
- N1 merging main conflicts in 12 files (28 hunks); main moved anchors in 04, 06, 07 stage.yaml, so client-journey.json must be regenerated, which runs into F1.
- N2 `bun run atlas` also rewrites `atlas.data.js` (`builtAt` changes every run) and every `.atlas/*.html` shell, deletes orphaned shells; nothing outside `.atlas/`.

Checks rerun: `bun run atlas --check` 0; `atlas check --strict` 0; bun test 99; typecheck 0; scratch copy (git archive of df0ec7e) `atlas.py build` reproduces atlas.data.js except builtAt and commit; F1 scenarios; headless shots: map and drawer render (104 steps, 7 phases). Suite and CI not rerun.

## Dispositions (lead)

- F1, F2: fix as proposed. N1: merge main, regenerate, do not hand-merge the page. N2: accepted.
