Context review, round 4: TASK-73, context placement (db7b106, 8b37936, bd9f03c)

**What I expected before opening the diff.** If the owner keeps a convention for an activity in every project, it goes in that activity's skill (question 4). If only CVgen chose it, it stays in the document that owns it (question 2). Question 3 covers only working with the owner. Private detail about the owner still goes to `.local/preferences/`. `*.spec.*` is not a rule anywhere. Every file that said "personal preferences go to `.local/`" without any limit had to be narrowed, so it no longer catches a convention question 4 sends to a skill.

**Each round 3 finding holds**
- **Material 1 (fixed).** Both changed places now limit `.local/preferences/` to private preferences and personal detail, and send his activity conventions to question 4:
  - `C:\Github\cvgen\.worktrees\review-agents\.claude\agents\context-maintainer.md:39`, the table row.
  - `C:\Github\cvgen\.worktrees\review-agents\.claude\agents\context-reviewer.md:45-47`.
  - The hard rule at `context-maintainer.md:135-136` was left alone, as I advised. "Personal detail" reads as private detail, and it matches the row.
  - None of the three places now contradicts questions 2 to 4 or `context-maintainer.md:73-76`.
- **Minor 2 (fixed).** The D1 summary in `C:\Github\cvgen\.worktrees\review-agents\archive\work-records\review-agents\plan.md:44-47` now matches questions 3 and 4: "working with the owner"; "his own cross-project ones included" goes to the skill, else the agent file. The plan-reviewer will no longer meet two versions.
- **Note 3 (fixed).** The task description at line 26 now says "working with the owner". The description belongs to a task created for this work, not one migrated from Trello, so editing it is allowed.
- **Note 4.** No change, as I advised.

**No regressions**
- No stale wording: "Personal preferences", "the owner as a person" and `*.spec.*` no longer appear in `AGENTS.md`, `CLAUDE.md`, `docs/preferences.md`, `docs/review.md`, `docs/development.md`, `docs/conventions.md`, `.claude/`, `.codex/` or the plan.
- No `.codex` counterpart of either agent needs a change.
- Line endings: 0 CRLF in all five touched files, each ending in LF. The only long lines are the frontmatter, table rows and the task's single-line fields, as before.
- Records: no dated record was edited. The round 3 report is stored as a new file. The dispositions are added to the task notes, below the owner-decision entry.
- No client data. English.
- Only the files the findings reach were touched.

**Notes**

1. `context-reviewer.md:47`: "placed by question 4". In this file, item 4 of "What to do" is **Semantics**, one line below. The same paragraph names "its four placement questions" (`:37-38`), so the meaning resolves, and the wording was mine in round 3. A reader skimming the list could still look at the wrong item 4. If the file is touched again: "placed by the fourth placement question".
2. `context-maintainer.md:127-128`: the hard rule allows edits to `.local/preferences/` "when the feedback is personal to the owner". This text was not touched. Feedback like the triggering one ("I do not prefer it") could be called personal. The rule only sets which files may be edited, and questions 3 and 4 decide placement, so no agent is misdirected. "when the feedback is private to the owner" would match the row at `:39`.

Neither note blocks.

Verdict: PASS
