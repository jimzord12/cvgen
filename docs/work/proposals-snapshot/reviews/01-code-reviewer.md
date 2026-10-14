## Review round 1: code-reviewer, 2026-10-14

Snapshot: `feature/task-28-proposals-snapshot` at e5bf194 against origin/main 9a8ed1c. Lead lenses: correctness; test strength.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Coverage: AGENTS.md, the README, `tests/run.py` and the Atlas reach the script; counts verified by hand (13 proposals: 0 pending, 0 trial, 3 approved, 2 deferred, 7 applied, 1 rejected); ids follow git creation order, `created` dates match git add dates; CRLF accepted; BOM, quoted value, inline comment, missing closing `---`, empty file, lowercase or 5-digit id refused loudly; proposal files only gained `id`/`created`; nothing written on a refusal; one stdlib file.

Material
- R1-1: the summary-line test cannot catch mixed-up state counts (`tests/proposals.py:34-44, 63-64, 100-101`): the fixture has exactly one of each of trial, approved, deferred, applied, rejected and the real-folder check matches `\d+`; a swap of deferred and applied survives. Fix: give each state a different count.

Minor
- R1-2: idea-run proposals will be written without `id`/`created` (`.claude/agents/ceo.md:84-85`, `.codex/agents/ceo.toml:110-111`, `.claude/skills/idea-run/SKILL.md:16`). Fix: add both to the ceo instructions and the skill's move step.
- R1-3: five refusal rules untested (`scripts/proposals.py:57-73`): reference-has-no-status, only-rejected-in-`rejected/`, `kind`, `revision`, `created`. Fix: one `BROKEN` entry each.
- R1-4: parallel branches pick the same `next_id` (`docs/proposals/README.md:38-39`). Fix: the later branch renumbers before it merges.

Notes
- R1-5: `AGENTS.md:44` "No dedicated reporting command exists yet" now partly stale.
- R1-6: a proposal reopened from `deferred` counts as older than 7 days at once; a future `created` gives a negative age.
- R1-7: a context-reviewer round is also required.

Checks rerun: script exit 0 with the same line; the 10 proposals checks pass; mutations (12 variants): survived swap-applied-deferred, ref-status-unchecked, rejected-one-direction, no-kind-check, no-revision-check, created-optional; caught stale `>=`, removed duplicate-id check, print before mkdir, last `---` block, writing despite problems; parser edge probes; Atlas check exit 0. Full suite not rerun.

## Dispositions (lead)

- R1-1, R1-2, R1-3, R1-4, R1-5: fix. R1-6: refuse a future `created`; reopened-age accepted as is (age is from creation by design). Round 2 follows, then a context-reviewer round.
