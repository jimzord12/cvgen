## Review round 2 (code): code-reviewer, 2026-10-14

Snapshot: `cb705cc`; delta `613c37d..cb705cc` (7 commits); full `dbc11bd..cb705cc`. Lenses: 1 dispositions applied and wired; 8 nothing regressed.

Verdict: PASS. Recorded in substance (no client named).

Coverage: all five dispositions verified, F1 walked by hand; owner state never written on load (hash unchanged); the test goes through the real Store and server and fails without the mapping; a broken state file still returns 409 and is never overwritten; the fix is 6 lines in `Store.load`.

Notes
- N1 `apps/design-review/server.py:126-129, :161`: when both keys exist, the legacy one stays (listed under "Not in this index", kept on save); the owner's file has 0 `studio/` keys, so it cannot happen today. Optional: drop it.
- N2 the audit reports 16 more dead-path mentions (L2) than main, all historical (two frozen `Anti-example` briefs, Done tasks 8, 17, 50, the session handoff); the 5 `docs/work/` mentions resolve on main only because of a stray local `docs/work` folder.

Checks rerun: suite exit 0, 142 cases, exact_reference equal (builds/tests-20261014-125848-302071); outputs check 19 PDFs 0 problems; 5 examples compile with exactly one `#import`; audit on branch and main exit 0, both globs protected; F1 walk on a copy with `--repo --no-private`: 14 items, 0 unindexed, 6 keep, 8 maybe, 3 starred; other 10 legacy keys are rejected concepts absent on main too; copy and original hashes unchanged; `archive/work-records` 1 added file, no renames; no live `studio/archive/work-records` or `scripts/design_review` path. Limitation: ruff not rerun.

## Dispositions (lead)

- PASS. N1: accepted as is (keeping the older entry loses nothing; dropping it would). N2: accepted; the handoff is rewritten at session end; the stray local folder is checked by the lead.
