## Review round 3 (code): code-reviewer, 2026-10-14

Snapshot: 5dd4a97, delta `b3c60d6..5dd4a97`. Lenses: 1 the `removeTmp` helper and the rm audit; 2 the docs fixes and the client-journey restamp.

Verdict: PASS. Recorded in substance.

Coverage: every test that deletes a folder uses the helper; the helper throws when it refuses; F4 fixed; README blank line back; the restamp is legitimate (GAPS.md changed only at 78-110; client-journey cites 34-61 and the cap table 21-30, unchanged); the new anchor `05-design/stage.yaml:482-487` matches `art.design-review-input`; `atlas.test.ts:172` deletes one file inside a temp folder; `src/` deletes nothing.

Minor
- F5 `tools/workflow/test/tmp.test.ts:9-11` calls the real `removeTmp` on `""`, `.` and `tools/workflow`; if the guard ever broke, `bun test` would wipe `tools/workflow`. Fix: a pure `isInsideTmp(path)` check, `removeTmp` uses it, refusals tested on the check.

Note
- N2 the guard compares paths as text, not after resolving links; a junction inside tmpdir could reach elsewhere; no test can produce one (all paths from `mkdtempSync`); a child named like `..x` is refused, harmless.

Checks rerun (builds/review-task41-r3-20261014-143824/): bun test 107; typecheck; check (104 steps); render --check; atlas --check; `atlas check --strict` 5 ok; tree clean. Suite, CI, junction probe not run.

## Dispositions (lead)

- PASS. F5: fixed by the lead (pure `isInsideTmp`, refusals tested on it, including a `..` escape; one real removal of a fresh temp folder). N2: accepted.
