## Review: the 2026-10-04 merges (TASK-33), context-reviewer, 2026-10-14

Scope: merge-time changes of a66b448, 1db32e8, 74a6f82 and 1e684eb, each file compared against both parents and the merge base; cited Atlas lines checked blob by blob; all LF. Read-only.

Verdict: FINDINGS. The conflict resolutions are clean; the Material findings come from what the merges brought onto main and left inaccurate or untracked. Recorded in substance (formatting condensed).

What the merges did is correct:
- a66b448: clean; every branch change arrived unchanged; nothing on main changed.
- 1db32e8: exactly 8 add/add conflicts. The 6 files resolved to the Hanami side lose nothing (editor-b differs only in status and font paths); design-concepts/README.md keeps the editor-b intro and rows and swaps in the two Hanami rows exactly; the reworded run-record paragraph was true at that commit.
- 74a6f82: the AGENTS.md conflict kept both paragraphs; everything else from one side; docs/review.md auto-merged correctly.
- 1e684eb: 10 of 11 re-pointed sources identical on main; the 11th (design-concepts/README.md) differs as a file but its cited lines (3-6, 44-47) hold the same text; both context agents on main, so `built` is true; status claims held at that commit.

Material
1. docs/work/workflow-model/handoff.md:43-45 says each branch "had been reviewed on its own branch". Not so: a66b448 brought the 18 designs of the 2026-09-29 run, committed "(unreviewed)" (e63292d, 7441f6e), gates never run; 74a6f82 brought context-maintainer and context-reviewer with two review reports still at FINDINGS. The owner asked for the merges, so merging was allowed, but this record must not certify ungated content. Fix: say so here and correct the handoff sentence.
2. a66b448 left two run records saying the opposite of main (still true): docs/work/idea-runs/2026-09-29-editor/run.md:37 "The run is not integrated"; docs/work/idea-runs/2026-10-02-editor/run.md:9 "its ancestry must not be merged wholesale into main". Fix: one dated line each (merged 2026-10-04 at the owner's request, gates still not run); don't rewrite the old text.
3. 74a6f82 brought open Material findings onto main with no task (still true): docs/work/design-core/reviews/03-context-reviewer.md F1 (the loop's first step and the Review stage still name only `code-reviewer`: docs/review.md:187, docs/development.md:21) and F2 ("specialty and role" vs the glossary's `Role`/`Rank`, docs/glossary.md:77); docs/work/codex-visual-tools/reviews/01.md: `--ephemeral` and `--ignore-user-config` still missing from docs/proposals/codex-visual-tools.md and TASK-4. Fix: a task for F1/F2 and a pointer in TASK-4.

Minor
4. .atlas/src/site.json:218, :238: "the two review reports … stay open" cites only codex-visual-tools/reviews/01.md; design-core/reviews/03-context-reviewer.md missing. Still true.
5. .atlas/src/pages/change-review.json:10, :127: "`code-reviewer` for … everything else" next to "A `context-reviewer` reviews changes to agent rules". Fix: "everything not agent context". Still true.
6. docs/work/idea-runs/2026-10-02-editor-2/run.md: the reworded paragraph dropped the branch's evidence line ("`outputs.py check` on this branch: 10 PDFs, 0 problems"). Put it back.

Notes
- design-concepts/2026-10-02-hanami-line/brief.md:6 still "Status: proposed" while its README row and Meta File say `parked`.
- change-review status (1e684eb) stale since 2026-10-04: step `merge`, waiting on `lead`, no next move.
- Already fixed since: duplicate fonts gone; the Hanami v1 brief's "OFL.txt beside it" claim gone.

## Dispositions (lead)

- All findings and notes are fixed inside TASK-33 rather than a new task (smaller, same files): 1 handoff sentence corrected and stated here; 2 dated lines added; 3 design-core F1 and F2 fixed in docs/review.md, docs/development.md and the glossary/wording, TASK-4 gets the pointer to codex-visual-tools/reviews/01.md and the missing flags; 4-6 and the notes fixed. The 2026-09-29 designs were never gated by the idea-run reviewers, but the owner has since judged every one in the Design Review app (kept, parked or rejected, applied 2026-10-06), so no retroactive gate is run.
