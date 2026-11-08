Context review, round 4 (confirmation). Report figures, delta ff82d46..d9d7fd3, worktree C:\Github\cvgen\.worktrees\report-figures

**Round 3 findings, rechecked**

1. **Material, the record's shape: resolved.** C:\Github\cvgen\.worktrees\report-figures\backlog\tasks\task-82 - report-figures-every-picture-where-it-is-needed-in-owner-reports.md now follows docs/development.md "The task record":
   - :17-23 has the header and Outcome and boundaries, including the exclusions.
   - :26-31 has three acceptance criteria, all checked.
   - :36-37 is `## Result and evidence`, at a named revision. I checked it against `builds/tests-20261108-164241-061442/report.json`: `passed: true`, 220 cases.
   - :39-44 is `## Review`.
   - The approval-batch sentence at :37 names no client.
2. **Minor, "Fixed next": resolved.** Every round now says which commit fixed it (:41-43).
3. **Minor, the short line in item 19: resolved.** C:\Github\cvgen\.worktrees\report-figures\docs\engine\verification.md:227-234 runs 71-79 characters. Only the paragraph's last line (:234) is short. The wording has not changed.

All three touched files are LF (0 CRLF).

## Minor

1. **C:\Github\cvgen\.worktrees\report-figures\studio\brand\report\README.md:44-50 is no longer complete after eea6751.**
   - **What is wrong:** it gives the Enlarge button only to "a picture that one `needs_you` card alone cites". Since eea6751, a shared figure under Figures also has a "⤢ Enlarge" or "⤢ Compare" button in its heading (report.html `shared`). Nothing else in docs/ mentions Enlarge, so this paragraph is the only description.
   - **Why it matters:** a reader will conclude that shared pictures cannot be opened full size. That contradicts AC #2.
   - **Smallest fix:** move the button into a sentence that covers both places. For example, after "…the way to scroll.": "Every picture, in a card or under Figures, has an Enlarge button that opens it full size (a comparison opens with its slider)." Then drop the clause from :46-47.
   - **The lightbox bar:** the README does not need to describe the bar naming the open figure; it never described the bar. Everything else in :44-52 is still true: placement, "named above it", the back links, the refusals.

2. **task-82 :29, AC #2's evidence was gathered before the behaviour it checks.**
   - **What is wrong:** it cites "design-reviewer round 3 PASS", but that round reviewed ff82d46. Shared-figure Enlarge, the bar naming the figure and the Close button that stays on one line all came in eea6751, after it.
   - **Why it matters:** the next reader takes the checked box as proven by a review that never saw the shared Enlarge.
   - **Smallest fix:** cite the design round that covers eea6751 once it is stored, and add it to the `## Review` notes (`--append-notes`).
   - **If no such round is planned:** the design gate is owed one for the new page behaviour. That is a gate issue rather than a wording issue.

## Note: the known deviation (TASK-82 created on the branch)

The rule's purpose is that two branches never take the same number (docs/development.md:188-190). Today nothing collides:
- main (379e425, which is also the merge base) ends at task-81;
- no other local or remote branch holds a task-82.

The risk is still live, though. Any task created on `main` or on another branch before this one merges will be numbered 82 too, and the two will clash at merge. So noting the deviation is not quite enough. Either is the smallest remedy:
- **Commit the task file to `main` now.** docs/development.md:185-188 allows record-keeping commits on `main`.
- **Check before merging** that `main` has no task-82, and renumber this task if it does.

Also add one line to the record's notes saying the task was created on the branch, and why.

## Note

- I am not re-raising the `round-NN` file naming that round 3 declined (:44).
- "Recap" at :23 is used the way docs/glossary.md:28 uses it. `Report Template` matches the glossary (:69).

Verdict: FINDINGS (two Minor and the deviation remedy; no Blocking or Material, so this would pass once the README clause is fixed and AC #2 cites current evidence)
