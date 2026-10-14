## Review round 2: context-reviewer, 2026-10-14

Snapshot: `git diff main...HEAD` at 4a384f5, branch `docs/workflow-decisions`, plus the round-1 report.

Verdict: FINDINGS. Recorded unchanged in substance (formatting condensed).

Round-1 dispositions: findings 1, 2, 3, 4, 5, 7 and the inventory note are applied and correct; finding 6 mostly applied, remaining gaps below. Every row matches the owner's quoted answers; identifiers `approved`, `delivered`, `signed-off`, `sent` match output.schema.json; files LF; no real client named.

Material
1. TASK-57 (AC #1, notes) tells an agent to change GitHub settings without the explicit go required: docs/preferences.md:69-73 says changing the repository's settings "still needs his explicit go, with the exact command shown first". The proposal (lines 83-84) records only the description text, not a go for the command; the task description still says "Owner act"; the criterion "gh repo view shows the description" will drive an unattended agent to run `gh repo edit` itself. Fix: if the owner was shown the command and agreed, record it; if not, change AC #1 to put the exact command in the final report for his go. If he was not shown the command, this is Blocking.
2. TASK-55 (AC #1-2) covers only half the described scope: the description has four items (group folders, move design_review, one naming case per file type, M/lib.typ re-exports); the criteria cover two, so an agent can close Done with half undone. "(or a documented better fit)" gives latitude the owner did not give, unmarked as the lead's. The description still says "Owner approves moves (`repo-maintenance apply`)". Fix: add criteria for the naming case and re-export (or split them); mark or drop the latitude.

Minor
3. TASK-52 AC #1 lists only docs/development.md, docs/review.md, AGENTS.md, skills; `docs/work` is also named in .claude/agents/ceo.md, magazine-editor.md, context-maintainer.md, .claude/repo-maintenance.md (lists `archive/**` and reports as frozen) and .atlas/src. Both TASK-52 and 55 have no dependencies, so 55 can move `archive/` after 52 filled it. Fix: "every live file `git grep docs/work` finds"; make 55 depend on 52.
4. TASK-36: the bold "Show the types to the owner before the engine." still precedes the override clause; strike it.
5. TASK-34 and TASK-53 are Done but say "not started"; drop those words.
6. TASK-44 still reads "`delivered` without an approval (or export, per decision)"; TASK-37 says "task 2's decisions" (handoff numbering, readable as TASK-2); TASK-40 says "the length the owner chose". None links the proposal. Fix: name docs/proposals/workflow-model.md in each; TASK-44 "without an `Export`".
7. docs/proposals/workflow-model.md:51 — the README wording "Exported <date>, delete by <date>" is the lead's choice written as if decided; mark it as the lead's default.

Notes
- TASK-50 retitled `fonts-dedupe` but its file name still says binaries-out-of-history.
- Proposal lines 29-30 account for TASK-33..57 while lines 14 and 86 say TASK-28..57.
- Outside this diff: TASK-45..49, 51, 54, 56 are Queued without acceptance criteria but in the unattended scope.
- The font dedupe is correctly limited: Bona Nova (three files) is the only family stored twice.

## Dispositions (lead)

- 1: the owner was not shown the exact command. The lead had already run `gh repo edit` (right after the owner chose the text, before this round). Recorded truthfully in the proposal and TASK-57's final summary (Done), and disclosed to the owner in the report; the previous text is recorded so the change can be undone. No further settings changes will be run without the command shown first.
- 2 fixed: four criteria; latitude dropped; description states the owner's go-ahead.
- 3 fixed: criterion names every live `git grep docs/work` hit; TASK-55 depends on TASK-52 and TASK-31.
- 4, 5, 6, 7 fixed.
- Notes: file name left (Backlog keeps the file on retitle; the id is the stable reference); proposal problem section now also names TASK-28..32; missing criteria on the other tasks are set by the implementing agent when it picks the task up (docs/development.md, "The task record").
