Context review, round 3 (confirmation). Report figures, delta 39e507d..ff82d46, worktree C:\Github\cvgen\.worktrees\report-figures

**Round 2 findings, rechecked**

1. **Minor, "shared, cited twice": resolved.** C:\Github\cvgen\.worktrees\report-figures\docs\engine\verification.md:232-233 now lists "two figures with one id, one item citing an id twice or citing one that is absent". That matches the refusals in tests/report.py.
2. **Minor, the 99-character line: resolved.** :221-234 are all 80 characters or fewer, but the reflow left a new ragged line (Minor 2 below).

**Item 19 against tests/report.py at ff82d46: true.** The sample assertion places B in its card and A under Figures. The direct `placement()` call uses U (cited by no one), D (cited only by a decision), C (cited by one card) and S (cited by two cards), and expects `{'cards': [['C'], [], []], 'figures': ['U', 'D', 'S']}`. That matches `placement()` in scripts/report.py:176-182. The item names the uncited and decision-only cases, and "too" covers the rest. The check string in the test says the same thing.

**C:\Github\cvgen\.worktrees\report-figures\studio\brand\report\README.md against this round's report.html: still true.** Three things changed in report.html: the lightbox bar is now sticky and shows the comparison's "Left / Right" labels (`#lb-sides`), the page is edge to edge at 200% width with sideways scroll below 760 px, and the comparison thumbnail is half and half. None of them contradicts :44-52. "Opens it full size (a comparison opens with its slider)" is truer now on phones. The README does not need to describe the bar. Placement is unchanged, and so are "named above it" and the back links (the new `<span>` only groups the name with the caption).

All touched files are LF (0 CRLF). No skill, agent or `AGENTS.md` row needs a pointer change.

## Material

1. **C:\Github\cvgen\.worktrees\report-figures\backlog\tasks\task-82 - report-figures-every-picture-where-it-is-needed-in-owner-reports.md:14-27: the record lacks the shape `docs/development.md` sets out in "The task record" (:193-215).**
   - **Description (:17):** it has no header (Owner, Branch/worktree, Integration target, Depends on) and no "Outcome and boundaries". The branch only appears in the notes.
   - **Acceptance:** there is no Acceptance Criteria section. The stage table (:44-50) asks for acceptance criteria from Queued onward, and requires them to pass before Ready.
   - **Notes:** there are no `## Review` or `## Result and evidence` headings, and there is no evidence at all: no suite run, no revision with its result, no `builds/tests-*` path, no `ruff check`. Compare TASK-68.
   - **Why it matters:** the next agent cannot tell what "Ready" means for this task, or where the proof is, and Review requires the author checks to be complete.
   - **Smallest fix:**
     - Edit the description to add the header and a two-line Outcome and boundaries.
     - Add two or three `--ac` lines (pictures placed by citation; enlarge and lightbox; refusals).
     - Put the existing round bullets under `## Review`.
     - Append `## Result and evidence` with the suite and ruff run at the head.

## Minor

1. **task-82 record :25 says "Fixed next:".** In a dated record this reads as future work, yet the fixes are in ff82d46, the same commit. Write "Fixed in ff82d46:". If the hash cannot be known when you commit, write "Fixed in the round-2 fix commit:".
2. **C:\Github\cvgen\.worktrees\report-figures\docs\engine\verification.md:228 is cut short at 43 characters** ("page, then one refusal per rule, each on"), between lines of 71-79 characters. A reader notices the ragged edge. Reflow :227-229.

## Note

- The record keeps the `round-NN` file naming. `docs/review.md:230` names `NN-<reviewer>.md`, but eight other recent folders use `round-NN` too, and the code-reviewer raised it only as optional. I do not raise it.
- The record's tallies are accurate: code round 1 PASS F1-F4, context round 1 1 Material and 4 Minor, design D1/D2 then D3, and code M1.

Verdict: FINDINGS
