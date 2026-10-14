## Review round 2: code-reviewer, 2026-10-14

Snapshot: `.worktrees/task-28` at 41c9b4d; work under review d8c884f against round 1's e5bf194 (the rest is a merge of reviewed main plus Atlas re-stamps). Lead lenses: the round-1 fixes; test strength.

Verdict: PASS. Recorded in substance (formatting condensed).

Coverage: `tests/run.py:445` calls `run_proposals`; AGENTS.md:45 names the script; ceo agent, Codex mirror and the idea-run move step carry `created`, the lead adds `id`; future-date check `created > today` (`scripts/proposals.py:75`) right, `--today` defaults to the local date; refusals write nothing and exit 2; README rules agree with the code; verification.md item 14 matches the tests. R1-1 to R1-6 resolved.

Findings
- M2-1 Minor: no "created today" fixture (`tests/proposals.py:32-39, 67`): mutant `created >= today` is caught only because `workflow-model.md` happens to carry today's date; from tomorrow it survives. Fix: a `VALID` file whose `created` equals `--today`, accepted with age 0.
- M2-2 Minor: the real-folder check reads the clock twice (`tests/proposals.py:108, 116`); a run across midnight can fail spuriously. Fix: pass `--today` and reuse the value.

Note
- M2-3: the real-folder check is an independent oracle, not a tautology; a real file with `status:pending` (no space) would stop on StopIteration rather than a clear assertion; loud, acceptable.

Checks rerun: script exit 0 with the expected line; 13 mutants in separate copies (`builds/review-task-28-r2-20261014-100718/` in the worktree): unchanged copy passes; all six round-1 survivors now caught; future-off-by-one, stale-all-states, next-id-len, summary-counts-references caught; `future-ge` caught only via the real folder (M2-1); `title-from-any-heading` survived (low value).

Limitations: conflicts with later main not reviewed; local-date timezone risk theoretical.

## Dispositions (lead)

- M2-1, M2-2: fix. M2-3: accepted.
