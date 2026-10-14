---
id: TASK-30
title: >-
  main-folder-term: name the repository's default folder (Main Folder) and its
  rules
status: Active
assignee: []
created_date: '2026-10-06 09:41'
updated_date: '2026-10-14 05:55'
labels:
  - docs
dependencies: []
priority: low
ordinal: 30000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner coined the need 2026-10-06: a term for the default checkout of the repo (the `Main Folder`), as opposed to extra worktrees. Define it in docs/glossary.md with the rule that agents leave it on main (or on the owner's chosen branch) and do real work in a worktree; today it was left on an old merged branch 48 commits behind main with another session's untracked folders, which made the project look older than it is.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 docs/glossary.md defines Main Folder in the existing row style
- [x] #2 docs/git-workflow.md uses the term and states the rule: Main Folder stays on main, clean and synced; branch work in a worktree
- [x] #3 docs/development.md Session Sweep and the backlog skill use the term consistently
- [x] #4 tests/run.py passes and atlas check is clean
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Result and evidence
The `Main Folder` is defined in `docs/glossary.md` (row after `Atlas`). `docs/git-workflow.md` "Branches" states its rule: keep it on `main` (or the owner's chosen branch), clean and synced, do branch work in a worktree, and handle a stale one in three cases (fast-forward on `main`; switch an agent-left branch with no tracked changes to `main` and fast-forward; otherwise leave it, use a worktree and name it in the `Session Sweep` and handoff). The `Session Sweep` Git bullet in `docs/development.md` points to the rule, and the backlog skill's route-to-`main` bullet uses the term. Atlas citations into `git-workflow.md`, `development.md` and the backlog skill were shifted and verified in `site.json` and `change-review.json`, then rebuilt and stamped. Final run: `python tests/run.py` PASS (94 cases, `builds/tests-20261014-084935-049380`), `atlas.py check --strict` clean. Not Done: the lead merges.

## Review
Round 1 (`docs/work/main-folder-term/reviews/01-context-reviewer.md`): FINDINGS (2 Material, 1 Minor); fixed the contradictory recovery steps, the duplicated rule in the glossary and Sweep, the reason placement, the Added column and the task record.
Round 2 (`.../02-context-reviewer.md`): FINDINGS (1 Material, 4 Minor); fixed six stale Atlas ranges plus a wording slip, the overlapping cases, a merged branch counting as agent-left, leaving untracked files that are not the session's, the task title prefix `main-folder-term:`, and these notes.
Round 3 (`.../03-context-reviewer.md`): FINDINGS (1 Material); the CVgen layer `.claude/repo-maintenance.md` now makes the `apply` branch in a worktree under `.worktrees/`, never in the `Main Folder`.
Round 4 (`.../04-context-reviewer.md`): FINDINGS (1 Material); `.claude/skills/idea-run/SKILL.md` now always branches in a worktree `.worktrees/idea-run-<date>-<ceo|editor>`, says "the folder the session started in" instead of "main folder", and `.claude/repo-maintenance.md` reads "only the names and the place follow CVgen". `site.json` cites `repo-maintenance.md:135-139`. `docs/git-workflow.md` "Releasing a new render" step 1 now says the branch is made in a worktree.

## Sweep: instructions that create or switch a branch
Searched for `git switch`, `git checkout`, `checkout -b`, `worktree add`, "branch `", "new branch", "create the branch" and every `branch`/`checkout`/`worktree` mention in: `.claude/skills/**` (new-client, new-cv, verify-cv, new-theme, backlog, idea-run, repo-maintenance incl. checklist), `.claude/agents/**`, `.claude/repo-maintenance.md`, `.codex/**` (README and all agent profiles), `docs/**` except dated records (`docs/work`, `docs/history.md`, `docs/decisions`, `docs/research`, `docs/proposals/*` bodies), `AGENTS.md`, `CLAUDE.md`, `README.md`.
Result: compliant or fixed. Fixed: idea-run step 1, repo-maintenance `apply`, git-workflow release step 1. Already compliant: backlog skill (short-lived worktree in the scratchpad, or an existing `main` checkout), `docs/git-workflow.md` ("Branches": worktrees, the `Main Folder` rule), `docs/development.md` (worktrees for parallel writers), context-maintainer (read-only Git, no checkout). Left as is on purpose: the generic `.claude/skills/repo-maintenance/SKILL.md:117,122` (portable floor; the CVgen layer overrides the place), and `docs/workflow/inventory/*` (dated 2026-10-04 snapshot, a record). No other file instructs creating or switching a branch.

Final: `python tests/run.py` PASS (94 cases, `builds/tests-20261014-085852-556640`), `atlas.py check --strict` exit 0.<!-- SECTION:NOTES:END -->
