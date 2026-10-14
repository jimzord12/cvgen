## Review round 4: context-reviewer, 2026-10-14

Snapshot: `.worktrees/task-30`, `git diff 275038e..3f030c8`.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Round-3 fix verified: .claude/repo-maintenance.md:136 makes the `apply` branch in a worktree, never in the `Main Folder`, fitting the generic floor (SKILL.md:117).

Material
1. .claude/skills/idea-run/SKILL.md:32-33: an idea run branches in the current checkout unless "other work is running"; started from the `Main Folder`, it switches it to `docs/idea-run-…`, and step 8 (:82-83) merges to `main` without switching back — the triggering case, forbidden by docs/git-workflow.md:56. Round 3 called idea-run compliant; it only uses a worktree when other work runs. Fix: "Branch `docs/idea-run-<date>-<ceo|editor>` in a worktree at `.worktrees/idea-run-<date>-<ceo|editor>` (docs/git-workflow.md, "Branches")"; :45 "When the run uses a worktree" -> "The run uses a worktree:"; :47-48 "the session's main folder" -> "the folder the session started in" (lowercase "main folder" now reads as the glossary term); rebuild and restamp client-journey and design-run.

Minor
2. .claude/repo-maintenance.md:135-136 "only the names follow CVgen" now also sets a place: "only the names and the place follow CVgen".
3. Task record round-3 line: paths and `Main Folder` lack backticks, extra blank line; tidy at close.

Notes
4. .atlas/src/site.json:364 cites repo-maintenance.md:136-140 while the apply paragraph is 135-139 (pre-existing off-by-one on main); optional 135-139.
5. Generic apply preflight (SKILL.md:122) checks `git status --porcelain` before creating the branch and stops in a Main Folder with another session's untracked folders; conservative, no change.

Checked and clean: git-workflow.md:51-66 cases do not overlap; owner-branch exception consistent; no contradiction with :27, :40, :47-49 or development.md:202-204; glossary row; Sweep pointer and anchor; backlog skill :80-82; all Atlas citations into changed files opened and correct; merge only re-stamped the lock and data; check --strict ok; LF; diff --check clean; no client data or owner path.

## Dispositions (lead)

- 1, 2, 3 and note 4: sent to the author, with a sweep of every skill and agent profile that creates a branch.
