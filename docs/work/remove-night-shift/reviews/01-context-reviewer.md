## Review round 1: context-reviewer, 2026-10-14

Snapshot: worktree `.worktrees/task-29`, branch `chore/task-29-remove-night-shift`, diff 1b95e5e..d79f9dc.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Material
- M1. .atlas/src/pages/change-review.json:83 — the new claim "often in a worktree under `.worktrees/`" has no source; its cited sources (docs/git-workflow.md:21-33, 69-73) do not mention `.worktrees/`. The claim is true; its source is docs/git-workflow.md:40-46. Without the citation, `atlas.py check` will not notice if the worktree rule moves. Fix: add "docs/git-workflow.md:40-46" to that step's sources, then build, stamp change-review, build.

Minor
- m1. docs/review.md:54 — line is 89 characters after the clause removal; nearby lines wrap at about 75. Rewrap 53-56.

Notes
- docs/review.md:17 kept correctly: a dated provenance note naming a separate repository.
- Two citations were already off before this change: change-review "fix" step "Renaming the task never resets the round count." is at docs/review.md:213, outside its cited 178-204; the roster tl;dr's Opus-at-high claim is at docs/review.md:144-146, outside 133-143 (already off at the roster's lock commit 9765962). Cheap to widen now.
- The `Session Sweep` glossary row (docs/glossary.md:71) and the Atlas term (site.json:496) still omit the Repo health and `Atlas` items that docs/development.md:84-88 lists; pre-existing.

Checks run: `git grep -n -i "night.shift"` at d79f9dc finds only historical records, dated decision entries and docs/review.md:17; Session Sweep list coherent across development.md, glossary and Atlas; repo-maintenance.md no dangling entries; .codex/README.md seven skills matches the tree; nine agent profiles; .claude/settings.json valid JSON, only `hooks` removed, permissions intact; `atlas.py check` all five pages ok; 15 remapped citations spot-checked correct; new statements (history erase, new-client erase commands, repo settings) true; no CRLF; no client identity.

## Dispositions (lead)

- M1, m1: sent back to the author to fix.
- Notes: widen the two off citations and complete the `Session Sweep` glossary row and Atlas term (cheap, same files).
