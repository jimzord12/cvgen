## Review round 3 (code): code-reviewer, 2026-10-14

Snapshot: 0219f94 (delta `38d49b1..0219f94`). Lenses: 1 the F4 fix and the N1 sentence; 2 idempotence across the marker parser.

Verdict: PASS. Recorded in substance.

Coverage: the real `render`/`--check` CLI reaches the fix; 18 probes; failures write nothing; every failure names file and line; the fix stays in `applyBlocks`; README matches the code; LF enforced by `.gitattributes`.

F4: an unclosed fence stops `render` and `--check` (exit 1) at its opening line, file unchanged after 3 runs, for: `~~~` at the top (round-2 probe, 84 lines every run), backticks between blocks, `~~~yaml` between blocks, backticks after the last block, a python fence with no final newline, `~~~` followed only by backticks, backticks inside a block. Lens 2: a marker with trailing spaces and an unknown block fail loudly and write nothing; CRLF with a fenced marker, a CRLF stale block, empty file, no final newline, trailing blank lines, a 4-space-indented closer and a stale block are byte-identical from the second run.

Notes
- N1 `render.ts:59`: an open backtick fence above a mermaid block is closed by the mermaid block's closer; render then stops at the `generated:end diagram` line instead of naming the fence's line; loud, stable; a hint optional.
- N2 `render.ts:415-417`: an existing empty README gets every block but no heading; stable; optional.
- N3 `applyBlocks` docstring (lines 41-43) does not mention the unclosed fence.

Checks rerun (builds/review-task39-r3-20261014-134115/): bun test 91 pass; typecheck 0; check 0; render --check "8 match"; probes. Limitation: the test was not run with the fix reverted (source read-only); shown by reasoning and the round-2 evidence.

## Dispositions (lead)

- PASS. Notes accepted as is (N3 is a docstring; the README states the rule).
