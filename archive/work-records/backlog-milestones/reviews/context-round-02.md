**context-reviewer, round 2. TASK-69, branch docs/backlog-milestones, snapshot main..bf9ef1e**

All eleven round 1 findings and both applied notes are fixed. Here is how I checked each one:

- **#1:** `docs/development.md:37-41` now says the CLI counts tasks only, and says what to do at n/n.
- **#2:** `review.md:58-61`, `development.md:183-188` and `SKILL.md:104-111` now give the three kinds of record commit.
- **#3:** roster is ok.
- **#4:** the ceo's milestone instruction is merged into the roadmap-slot bullet in both files.
- **#5, #6, #7:** the wrap, the rename paragraph and the "id" wording are fixed.
- **#8:** an orientation check was added (but see finding 1 below).
- **#9:** the AGENTS row, the tree, `development.md:167` and the glossary `Task Store` row now point at milestones and ADR 0017.
- **#10:** "checkpoints" replaces the generic "milestones" in `git-workflow.md`.
- **#11:** the stray comma is gone.
- **Notes:** "a plan" is now defined, and the change-review citation is now 130-142, which matches the handoff paragraph.

Other checks: ADR 0014 changed only on its Status line. AGENTS.md is 797 words (main: 795). No changed file has CRLF line endings. No real client appears. The excluded plan-reviewer gate was not touched.

### Minor

1. **The orientation check misfires on completed milestones** (`.claude/skills/backlog/SKILL.md:41-44`). "every `milestone:` id in the tasks is in `milestone list`": plain `backlog milestone list --plain` collapses completed milestones. Run as worded, it would show the ids of 26 tasks today (m-0, m-1, m-4, m-6) as #919 virtual milestones, and an archived milestone's tasks likewise. The paragraph also says nothing about what to do when a hit is a task no branch is working on.
   Fix: write `milestone list --plain --show-completed`, and add "assign any other with `task edit TASK-N -m m-N` on `main` (record-keeping)".
2. **The Atlas `system-map` page is STALE at HEAD.** `atlas.py check` reports `STALE system-map archive/work-records`. The page was stamped at d9d99bb, and bf9ef1e added the new `archive/work-records/backlog-milestones/` folder. `development.md` ("Atlas" in the sweep) requires a re-stamp in the same session.
   Fix: re-stamp system-map after storing this round's report. The folder will already exist by then, so the listing should not change again.
3. **The parenthetical reads as if it applies only to tasks** (`docs/development.md:188-189`). "Create a `Milestone` on `main`, and a task on `main` first, as Queued (so two branches never take the same number)". "as Queued" sits awkwardly, and the number reason applies to `m-N` just as much.
   Fix: "Create a `Milestone`, and a task as Queued, on `main` first (so two branches never take the same number)".
4. **"checkpoints" twice in one sentence** (`docs/git-workflow.md:76`). "Commit at coherent checkpoints and push at useful checkpoints or handoffs."
   Fix: "push at useful points or handoffs", or "push at finished checkpoints or handoffs".

### Notes

- `docs/development.md:167` is 87 characters, which breaks the file's wrap.
- `SKILL.md:42` gives a POSIX `grep -L` in a skill whose blocks are all PowerShell. It works through Claude Code's Bash tool but not in PowerShell, where `grep` is usually missing. A PowerShell equivalent is `Select-String -List` with `-NotMatch`, or simply say "in Bash".
- The skill's check treats a task with no milestone as fine while a branch is working on it. That is right for TASK-63..66 today, but `development.md:32-33` has no such exception. Once those tasks merge the exception has nothing left to cover. Consider saying in the skill that it covers only tasks created before the milestones rule.
- I could not check the upstream issue states offline. This was carried over from round 1.

Verdict: PASS
