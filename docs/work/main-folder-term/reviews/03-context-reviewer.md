## Review round 3: context-reviewer, 2026-10-14

Snapshot: `.worktrees/task-30`, `git diff b2a0dde..19aa680`.

Verdict: FINDINGS. Recorded in substance (formatting condensed).

Round-2 fixes verified: all six re-pointed Atlas ranges hold the claimed text (git-workflow.md 40-66, 85-89, 90-103; development.md 58-89, 91-105, 107-195); backlog skill 1-118 matches; branch-step summary "in a worktree"; `check --strict` ok; the three cases in git-workflow.md:58-66 no longer overlap and the triggering case lands in case 2 (switch, fast-forward, leave the folders); task retitled `main-folder-term`; LF; no client data, owner path or dated record edited.

Material
1. .claude/repo-maintenance.md:135-136 (with .claude/skills/repo-maintenance/SKILL.md:117, 122): the `apply` protocol creates the branch in the current checkout and step 8 says do not merge, so `/repo-maintenance apply` run from the `Main Folder` switches it to a branch and stops — the pattern the new rule forbids (git-workflow.md:56). The only skill path left that does this (idea-run already uses a worktree). Fix, in the CVgen layer only: "the branch is `chore/maintenance-<topic>`, in a worktree under `.worktrees/`, never in the `Main Folder` (docs/git-workflow.md, "Branches")"; restamp the roster page.

Notes
2. Task record line 20 still repeats "Proposed term: Main Folder."; drop at close.
3. Task file name keeps the `glossary-…` slug; harmless.
4. git-workflow.md:62 "untracked files survive the switch": git refuses if one would be overwritten; the refusal is safe and falls into case 3. No change.

## Dispositions (lead)

- 1 and note 2: sent to the author. Notes 3, 4 accepted.
