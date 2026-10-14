---
id: TASK-29
title: >-
  remove-night-shift: delete the retired .night-shift folder, its two skills and
  every mention
status: Done
assignee: []
created_date: '2026-10-06 09:41'
updated_date: '2026-10-14 05:35'
labels:
  - docs cleanup
dependencies: []
priority: low
ordinal: 29000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner asked 2026-10-06 to delete .night-shift. It holds three tracked history files (2026-09-27/28) plus ignored local nights/ and input.json (about 2 MB). Also remove the skills .claude/skills/start-night-shift and do-night-shift-follow-up, and every reference: .gitignore, .claude/settings.json, .claude/repo-maintenance.md, .codex/README.md, docs/development.md (the Night Shift lines), docs/review.md (history commits line), docs/glossary.md, docs/proposals/certificate-validity-check.md, and the Atlas pages that cite it (rebuild and stamp the Atlas). Leave old task records untouched except where they would now link to a missing path.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 No .night-shift folder and no night-shift skill remain; git grep -i 'night-shift' finds only historical task records and decision logs
- [x] #2 python tests/run.py and the Atlas check pass
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. git rm .night-shift/ and the two Night Shift skills. 2. Remove live mentions: .gitignore, .claude/settings.json hook, .claude/repo-maintenance.md, .codex/README.md, docs/development.md Session Sweep item, docs/review.md record-keeping clause, docs/glossary.md Session Sweep row. 3. Atlas: drop the night-shift actor and sweep mentions in src, re-check pages against changed sources, build, stamp. 4. Leave dated records (docs/work, decisions, history, other tasks, proposal decision entries). 5. Verify: tests/run.py, atlas check, outputs check, git grep.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Result and evidence (2026-10-14, branch chore/task-29-remove-night-shift)

Removed: `.night-shift/history/` (three tracked files), `.claude/skills/start-night-shift/`, `.claude/skills/do-night-shift-follow-up/`.
Live mentions removed: `.gitignore` (the `.night-shift` rules), `.claude/settings.json` (the `night-shift meter` SessionEnd hook, the only hook), `.claude/repo-maintenance.md` (ignore and protected entries), `.codex/README.md` (skill list now seven), `docs/development.md` (the Night Shift item of the `Session Sweep`), `docs/review.md` (the `.night-shift/history` record-keeping clause), `docs/glossary.md` (`Session Sweep` row).
Atlas: dropped the `night-shift` skill actor, its `uses` on the change-review sweep step and the Night Shift words in the sweep step and the `Session Sweep` term. All five pages were already STALE on main (private-repo, worktrees and erase changes since 2026-10-06); re-checked each against its changed sources: every line-range citation remapped to the current files (difflib from each page's lock commit, spot-checked), the retention step and the owner, new-client and change-review owner-only notes now name the private-repo history erase, change-review's branch step names `.worktrees/`, system-map counts corrected (seven skills, nine agent profiles). Then `build`, `stamp` all five, `build`.
Left as written (dated records): `docs/work/**`, `docs/workflow/inventory/` (dated read-only snapshot), other tasks in `backlog/tasks/`, the session-handoff doc, the dated decision entries in `docs/proposals/certificate-validity-check.md` and `vessel-particulars.md`, and the dated provenance in `docs/review.md` line 17 ("after the same pair in the sibling night-shift repository", a separate repository, not this folder).

Checks:
- `python tests/run.py`: PASS, 94 compilation cases plus assertions; evidence `builds/tests-20261014-082526-925233` (in the task worktree).
- `python .atlas/_kit/atlas.py check`: all five pages `ok`, verified 2026-10-14.
- `python scripts/outputs.py check`: 19 PDFs indexed, 0 problems.
- `python .claude/skills/repo-maintenance/scripts/audit.py --mode quick`: no link findings; only the pre-existing AGENTS.md length and deep-path/dir-size notes.
- `git grep -n -i "night.shift"`: only the dated records listed above.

## Review

Round 1, `context-reviewer`, 2026-10-14: FINDINGS (report `docs/work/remove-night-shift/reviews/01-context-reviewer.md`).
- M1 fixed: change-review branch step now also cites `docs/git-workflow.md:40-50` (the worktree bullets, 40-50 rather than 40-46 so the whole `.worktrees/` rule is covered).
- m1 fixed: `docs/review.md` record-keeping paragraph rewrapped to about 75 characters (same line count, no citation shift).
- Notes done: change-review "fix" step cites `docs/review.md:178-213`, roster tl;dr cites `docs/review.md:133-146`; the `Session Sweep` glossary row and Atlas term now list repo health and the `Atlas` check, matching `docs/development.md`.
- Merged origin/main (5c61091) cleanly; Atlas rebuilt, all five pages stamped, rebuilt. `python tests/run.py` PASS (`builds/tests-20261014-083204-927112`); `atlas.py check` all ok.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Removed the retired .night-shift tool: its tracked history files, the start-night-shift and do-night-shift-follow-up skills, the SessionEnd hook in .claude/settings.json, ignore/protect entries, and every live mention (development.md Session Sweep, review.md, glossary, .codex/README.md, repo-maintenance.md, Atlas). Dated records keep their wording. Atlas pages re-checked and stamped (they were already stale on main). Reviews: context-reviewer round 1 FINDINGS (1 Material citation, 1 Minor), round 2 PASS; reports in docs/work/remove-night-shift/reviews/. Suite PASS.
<!-- SECTION:FINAL_SUMMARY:END -->
