Round 2 review of 27dd4a8 (the fixes are 0ea5f6f..27dd4a8). Every round 1 finding is fixed. One anchor was missed, which is a Material finding, so the verdict is still FINDINGS.

## Round 1 findings, now fixed

- **B1, `docs/preferences.md:57-58`:**
  - Major is limited to files committed to "this repository's Git, except what Critical names", so `private/` and the `Release` PDFs stay Critical.
  - The Critical row's catch-all now spares what Major or the agents' bullet names, so clearing `builds/` is routine again.
  - Refs are back in the catch-all, and files Git does not hold go on a list for the owner.
- **M1, `:74-76`:** "merged or hold no unmerged work that matters" matches the owner's words.
- **M2, `:77-78`:** the evidence clause is gone, and the worktree condition is now the owner's.
- **M3, `docs/vision.md:64-66`:** the tie to a job tier is removed, with the owner's dated words.
- **m1, TASK-67:** the crewing check is back, and the totals pointer to constitution §6 is correct.
- **m3, `docs/git-workflow.md:80-81`:** now points to `preferences.md` instead of restating the rule.
- **Anchors in `docs/workflow/*.yaml`, `catalog.yaml` and the two Atlas pages:** all checked against the new line numbers, and all correct:
  - `78-80`: clearing `builds/`.
  - `86-94` and `86-98`: "Still needs his explicit go".
  - `92-94`: revisions.
  - `104`: Reports.

All changed files are LF only. No client details appear in the diff.

## Material

**M4. `.atlas/src/site.json:41` (and the built copy at `.atlas/atlas.data.js:43`) still cites `docs/preferences.md:60-96`.**
- That range covered "He decides" through "Still needs his explicit go". The two added lines push the end of that bullet to line 98, so the range now stops mid-sentence and drops the `Release` PDF clause.
- This is the owner's "You" card, and it was missed by the re-pointing pass.
- **Fix:** change the range to `60-98` in `site.json`, rebuild `atlas.data.js` and re-stamp, as `.atlas/README.md` says.
- Leave `backlog/tasks/task-46…:74` (`69-80`) as it is: TASK-46 is Done, so it is a dated record.

## Minor

**m4. `docs/git-workflow.md:81` now runs to about 107 characters, against the file's roughly 78.** Rewrap the bullet.

**m5. `docs/preferences.md:77-78`: worktrees and branches are now treated differently.**
- A branch that is unmerged but holds nothing that matters may be deleted.
- A worktree on that same branch may not be removed, because the worktree rule requires the branch to be merged. It falls to Critical.
- "add, and remove and prune once…" also reads awkwardly, and the condition means nothing for `prune`, which only clears records of worktrees that are already missing.
- **Fix:** "`git worktree` add and prune, and remove once its branch may be deleted as above and it holds no uncommitted work".

## Notes

- "the operator" (`vision.md:65`, TASK-67) is the owner's own phrase and is not a glossary term. That is acceptable: it reads as the person who runs the work for a `Client`, and the `scan-first` bar stays the owner's to set (`vision.md:66`, glossary `scan-first`), so nothing conflicts.
- The ADR 0016 Context and P-0019 "Who it helps" still say "ordinary jobs". Both are records and are correctly left alone; the 2026-11-08 decision entry supersedes them.
- `backlog/docs/doc-1 - session-handoff.md:24-25` still lists both questions as waiting on the owner. Update it at session end.
- I did not run `atlas.py check`, because it may write files. Running it would confirm M4 and any other stale Atlas page.

Verdict: FINDINGS
