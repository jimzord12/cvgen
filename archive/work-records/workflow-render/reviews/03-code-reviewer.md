## Review round 2 (code): code-reviewer, 2026-10-14

Snapshot: 38d49b1, delta `e9a6acb..38d49b1`. Lenses: 1 the F2/F3/N2/N3/minor-1 fixes; 2 no regression.

Verdict: FINDINGS. Recorded in substance.

Coverage: both new tests fail with their fix reverted; fixes stay in `render.ts`; docs match the code apart from F4.

Material
- F4 `tools/workflow/src/render.ts:56-64, 85-96`: an unclosed `~~~` (or backtick fence with no closer of equal or greater length) above the blocks makes every real marker skipped, so all blocks are appended at the end, inside the open fence; each run adds them again (84, 162, 240, 318 lines); `--check` stays STALE and the troubleshooting text makes it worse. Introduced by this round's fence fix. Fix: after the loop, fail at the fence's opening line ("code fence never closed"), plus one test.

Note
- N1 the same-`when` rule depends on identical text; generic texts such as "The review returned FINDINGS." on unrelated steps would be merged; no such case today; the fixture's `make.side` uses that kind of text.

Lens-1 audit: the rule drops 7 arrows (02 `form-create->form-test-cleanup`; 03 `dive-save->library-note`, `dive-save->decisions-update`; 05 `run-draw->run-design-gate`, `->run-integrate`, `->pick`, `->record-choice`), each still reached through a step of the same branch; stages 01, 04, 06, 07 and the journey changed only in the comment line; every repeated `when` belongs to one coherent branch. Fence probes (info string, 3-space indent, `~~~` inside a backtick fence, closer with trailing text) follow CommonMark; a 4-space-indented marker fails loudly. N2, N3 done.

Checks rerun (builds/review-task39-r2-20261014-133356/): bun test 90 pass; typecheck 0; check 0; render --check "8 match"; scratch copy rendered twice, 1 then 0 changed, identical hashes; F4 probe in `probe-unclosed-tilde/`. Suite and CI not rerun.

## Dispositions (lead)

- F4: fix (fail at the fence's opening line, one test). N1: guard it cheaply: the transparency rule applies only when the shared `when` text is not one of the generic review outcomes; otherwise record it in the README as a known limit. The author picks the smaller of the two.
