## Review round 1: context-reviewer, 2026-10-14

Snapshot: branch `docs/workflow-decisions`, `git diff main` plus the then-untracked
`docs/proposals/workflow-model.md` (before commit 4a384f5).

Verdict: FINDINGS. The report below is recorded unchanged.

Blocking
1. docs/proposals/workflow-model.md:76-78 — states the kept review loop runs "until PASS, up to five rounds". docs/review.md:197-201 caps at **5** attended and **10** unattended. The owner just authorized an unattended run of TASK-28..57; an agent reading this approved record would stop at round 5 and report unresolved too early. It contradicts a standing rule. Fix: drop "up to five rounds" or write "(round caps in `docs/review.md`)".

Material
2. docs/proposals/workflow-model.md:50,52 — the consequences of decision #1 are not spelled out. The consent text (docs/guides/client-workflow.md:136) and the lead's own pushback in row 3 say "12 months after delivery"; row 3 then says "12 months after `Export`" with "No consent text change" and does not reconcile the gap. The README line "Delivered <date>" would be written before delivery. The one real record, `client-2026-09-01`, had its delete-by date written at delivery (2027-10-02) and `Export` never run (backlog/docs/doc-1 - session-handoff.md:20); the handoff (docs/work/workflow-model/handoff.md:230-233) flagged exactly this as why #1 was open. The proposal does not say whether that date stands. Under #5, `Export` becomes a required step before sending. Fix: one or two sentences in row 1: `Export` precedes sending, so the date may be a few days earlier than the consent wording, which stays; the README line's wording changes (or is deliberately kept); the existing client's date stays unless the owner says otherwise; sending now requires an `Export`.
3. docs/proposals/workflow-model.md:12-13 — names the inventory as a "supporting document in scope". Under docs/proposals/README.md ("Approval covers the stated revision and named supporting documents") that approves its recommendations, and recommendation #1 is the opposite of the owner's answer. Fix: name the inventory as source, not approved scope, and state that where an answer differs from a recommendation, the answer wins. The scope line says TASK-33..57 while the Scope decision (line 85) and the TASK-31/32 notes cover TASK-28..57; align them.

Minor
4. docs/proposals/workflow-model.md:57 — guard written as "`delivered` without an approval"; the question answered (docs/workflow/inventory/README.md:77) pairs `delivered` with an export, the stronger guard after #5. Fix: "`delivered` without an `Export`", or list both if both are meant.
5. TASK-34 is Done but both acceptance criteria are unchecked although both are met. Check them with `--check-ac`.
6. TASK-34, 50, 52, 53, 55, 57 still say "not started. Needs an owner interview before work starts (label owner-input)" although the label is gone; TASK-50 still says LFS or Release assets and its title "binaries-out-of-history"; TASK-52 an "orphan `records` branch"; TASK-55 "Owner approves moves". Notes carry the decisions (docs/development.md:184-185 permits that), but these tasks have no acceptance criteria, which Queued requires (docs/development.md:19). Fix: add acceptance criteria stating the decided scope.
7. docs/proposals/workflow-model.md:50 — "the approved revision" should be the glossary term `Revision` in backticks.

Notes
- docs/workflow/inventory/README.md:63-78 still presents the nine decisions as open with recommendations; a one-line pointer to the proposal would stop a reader acting on recommendation #1. Optional, since the inventory is to be superseded.
- TASK-52 sends new reports into `archive/`, which AGENTS.md describes as frozen designs; TASK-55 moves `archive/` under a grouping folder. The applying tasks should settle where reports go and update docs/development.md, docs/review.md and AGENTS.md ("review reports under `docs/work/<id>/reviews/`").
- The EU data-law reason in row 3 is the lead's claim, not the owner's; acceptable as a record of the pushback.

Privacy: no real client name; files LF.

## Dispositions (lead)

- 1 fixed: "(round caps in `docs/review.md`)".
- 2 fixed: row 1 states the consequences; keeping the existing client's date is marked as the lead's default, open to the owner.
- 3 fixed: inventory named as source, answers win; scope aligned to TASK-28..57.
- 4 fixed: "`delivered` without an `Export`".
- 5 fixed: both criteria checked.
- 6 fixed: descriptions now point to the decision; TASK-50 retitled `fonts-dedupe`; acceptance criteria added to TASK-50, 52, 55, 57 (TASK-53 is Done, closed without work).
- 7 fixed.
- Note on the inventory: pointer added. Note on `archive/`: left to TASK-52/55, whose criteria now name the rule files to update.
