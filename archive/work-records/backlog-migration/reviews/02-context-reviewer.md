Context-reviewer report, round 2. Snapshot 1e684eb..63c157d (feature/backlog-migration, worktree C:\Users\jimzord12\Documents\GitHub\cvgen-backlog). The round 1 fixes are in 0fbc85d..63c157d.

**The principle I checked against (written before reading the diff).** Backlog.md replaces Trello as the only `Task Store`. A fresh agent gets exactly one correct instruction for each lifecycle step: read the handoff from `main`, create a task, move it through the stages, block and unblock it, cancel it, merge, mark it Done, rewrite the handoff. Every file that restates a step agrees with every other. The rule should not fire on dated records.

**Round 1 fixes: all verified correct.**
- The skill's rebase route (SKILL.md:86-93) is now valid on a detached worktree: fetch, rebase onto `origin/main`, then push `HEAD:main`.
- The handoff intro, the three framework-gaps status lines and the `--plain` flags in the development.md examples are fixed.
- The context-maintainer.md wrap is fixed, and its wording on migrated tasks ("a later fact goes in the task's notes or acceptance criteria") matches development.md:176-179.
- The `Task Store` glossary row (glossary.md:70) follows the glossary's rules: a one-line meaning, a code name that matches the tree, a date, and a backtick-free lowercase "task store" in documents is allowed by rule 2. The dispositions name it as a new term for the owner.
- Every changed file is LF, and `atlas.py check` is all ok.

**Lifecycle trace.** These steps are consistent across AGENTS.md:35-48, development.md, review.md:50-58, git-workflow.md, preferences.md:58-67 and SKILL.md:
- start: handoff read via `git show origin/main:...`;
- stage moves on the branch that does the work;
- `--add-label`/`--remove-label blocked` plus a `## Blocked` note;
- record commits for idle tasks and the handoff, exempt from review;
- Done after the merge;
- handoff rewrite with a read-back.

I found no contradiction. The remaining items are edge cases and wording.

## Minor

1. **development.md:74-76, the Session Sweep "Tasks" line.** It says "`backlog task list --plain -s Active -s Review -s Ready` and `-l blocked`". `backlog task list --help` shows that status and label filters combine as AND. An agent that appends `-l blocked` to that command, which is a natural reading of the sentence, gets only the blocked tasks in Active, Review or Ready, and misses a blocked Queued task. SKILL.md:23-24 lists them correctly as two commands. Fix: "...`-s Ready`, then separately `backlog task list --plain -l blocked`".

2. **SKILL.md:74-75, the route to `main` through the main checkout.** "commit there, `git pull --rebase`, push" edits a possibly stale local `main`. Two things go wrong:
   - The handoff's `**Main at:**` line can record an old head.
   - A concurrent handoff rewrite turns into a rebase conflict on the doc.

   The worktree branch of the route fetches first; this one does not. Fix: "`git pull --rebase` first, then edit, commit and push".

3. **The Done move for a child task** (development.md:147-150, SKILL.md:69-71, review.md:55-56; versus git-workflow.md:36-42 and :80-81). "The move to Done after a merge" is listed as an idle-task edit that goes straight to `main`. That is correct for a branch merged into `main`. For a child task merged into its parent feature branch, though, Done means reaching that parent. The parent branch still carries the task file, so a Done commit on `main` would be premature and would conflict when the parent merges. Fix: one clause, "...after a merge into `main`; a child task's Done goes on its parent branch".

## Notes

- **Cancelling a task a branch is working on** is not spelled out. Read literally, the cancellation belongs on that branch, but an abandoned branch never merges, so `main` keeps showing it Active or Queued. Consider: "if the branch is abandoned, cancel on `main` once the branch is gone, and copy any notes worth keeping".
- **Creating a task for work about to start is implicit.** development.md says a new Queued task goes to `main`, while TASK-27 was created directly on its branch as Active. Both are defensible. One line in development.md, "create on `main` first; it moves to Active on the branch", would remove the guess and also avoid duplicate task numbers across branches.
- **"(a `main` checkout or branch from it)"** at development.md:75 reads awkwardly. "or a branch made after the migration" says what is meant.
- **Not re-raised (declined or accepted in round 1):**
  - The framework-gaps status lines are treated as live.
  - The ADR and history say the board was "exported and closed" ahead of step 7.
  - The `trello` skill stays until step 7.

  All three still depend on step 7 completing before the merge.

Verdict: PASS
