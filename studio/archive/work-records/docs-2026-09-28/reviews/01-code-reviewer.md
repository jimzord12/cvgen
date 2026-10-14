# Review round 1: documentation batch of 2026-09-28

Stored as returned by the `code-reviewer` (anchors shortened to repository
paths); the lead's dispositions follow at the end.

Snapshot: main at 11bb256 (clean). Commits 57fad21, 81bf319, 4c08e38, 49a4eed, 11bb256, 028689e, plus the AGENTS.md brand row as f91987f left it. I read revision 1 with `git show 57fad21:<path>`.
Lead lenses: (1) honest and consistent; (2) workability.
Coverage:
1. Wiring: review.md, AGENTS.md and the development.md sweep all state the new rule. code-reviewer.md still defers to review.md. review.md is stricter than the global rule (which counts "one config value" as trivial) and adds a term-row exemption. The two fit together apart from F3. See F1, F4.
2. Correctness: F1, F2, F5.
3. Integrity: no candidate data path is touched. See N2.
4. Contracts/access: no code contract is touched. F1 opens a path around owner approval.
5. Tests/evidence: this batch is documentation only. tests/run.py, verify.py and workflow.py read none of these files, so a suite run would add nothing.
6. Failure handling: the sweep can report a false all-clear (F4, F5).
7. Simplicity: each rule still has one home. The sweep names places to look, not a second status list.
8. Repository/docs: LF endings and `git diff --check` are clean. `Sign-off` is misused (F1). "small" now has two meanings (F3). The brand row matches brand/README.md.

## Findings

### F1 Material: travel-domain revisit condition fires before the one-off exists and skips approval
Anchor: docs/proposals/travel-domain.md:47-49, 61-65
- Scenario: the first travel client OKs the text draft.
- Expected: the owner's process in the Decisions entry is "create a one-off CV… study the one-off CV, create a template out of it". So the revisit comes once that CV exists and has been delivered.
- Actual: the trigger is the one-off's `Sign-off`. glossary.md:60 and client-workflow.md step 8 define `Sign-off` as the client's OK on the text draft "before design starts"; the one-off `Template` is built only in step 9. The text also allows "(or open the build task directly)" and says steps 3-4 are "started after…". The owner deferred revision 2; he did not approve it. proposals/README.md:48 returns a deferred proposal to `pending`, and vision.md:86-87 says no item "is started on an agent's initiative".
- Impact: an agent reopens or starts the `Domain` build with no CV to study and no approval.
- Fix: change the condition to "Return to `pending` when the first Travel & Tourism client's one-off CV reaches `Export`"; delete "or open the build task directly" and align lines 47-49; update the trigger on the travel-domain card; optional: a one-line "Decision requested" for when it returns.

### F2 Minor: short-career-layout misstates today's behaviour
Anchor: docs/proposals/short-career-layout.md:12-14, 18-23
- The proposal says juniors get "a thin two-page CV", and a one-company cadet "fills only a small part" of the flagship-v11 plan.
- In fact the v11 plan fails with fewer than six companies ("Page plan company index out of bounds": pagination.typ:9, new-cv step 3). The documented per-CV `pages` override (layout-and-pagination.md:19-28) can already put a short record on one page with v11 geometry. The real gap is geometry tuned to fill a page. A profile's `pages` lists company indices, so choosing the profile alone will not serve records with 1, 2 or 3 companies.
- Fix: the approval and scope stand. Add a dated correction note so the implementer sees the real gap.

### F3 Minor: the exception wording contradicts itself
Anchor: docs/review.md:21, 23, 30, 32; docs/development.md:27; AGENTS.md:206-207
- "Only" versus "one other": review.md says "The only exceptions are truly trivial", then "Idea runs are the one other exception". AGENTS.md says "only truly trivial changes are exempt" and never mentions the idea gates.
- Two meanings of "small": "small-change path" (review.md:30) and "small changes that skip it" (development.md:27) still treat small as exempt; review.md:21 batches "small changes" into a review round; the global rule says size is no exemption.
- Term renames: glossary rule 3 makes a rename or drop update prose in the same change. Only the row itself is exempt, and the text does not say so.
- Fix: call it the "trivial path"; say idea runs "are reviewed by their own gates (not an exemption)", and that later revisions of an idea-run proposal come to this gate; add "the prose a rename or drop updates is reviewed".

### F4 Minor: the Reviews sweep misses commits and cannot be met literally
Anchor: docs/development.md:65-67; docs/review.md:21-25
- Commits it misses: the check covers only "every commit of the session". It would have missed today's 57fad21 and 028689e, which came from night session 017Aus…. An interrupted session never runs its sweep; night 2026-09-27-a ended `interrupted`. Codex may commit documentation (AGENTS.md:23, 55) but cannot run the code-reviewer (review.md:7-10).
- Commits it cannot clear: commits that store reports, merges of already-reviewed work and `.night-shift/history` commits have no report of their own. They are not on the closed trivial list either; only review.md:190-192 implies they are exempt.
- Batching: review.md:21 limits batching to "one session", yet this round rightly spans two.
- Fix: check every commit since the handoff card's last `Written` date, from any author; state that record-keeping commits need no round; batch "since the last handoff".

### F5 Minor: the Night Shift item claims more than its commands show
Anchor: docs/development.md:71-72
- With no night open, `night-shift status` prints only open follow-up items (night-shift v14 src/night.ts:313-320). `follow-up list` reads follow-up files only (cli.ts:142-148). A follow-up file exists only after the owner creates it in the Viewer (followup.ts:2, server.ts:227-233).
- Result: a closed night's unanswered questions (before that step) and feedback with `sent: null` never appear. The sweep can report all clear while something waits on the owner.
- Fix: also read the last night's `night.json` for `answer: null` and `sent: null`.

## Notes
- N1: two sweep lines could be sharper. Board lists only Review/Ready; Active and Blocked cards are the likeliest loose ends. "Latest run on main" invites the `--branch` pitfall that git-workflow.md:73-77 warns about; name `gh run list --commit <main head>` instead.
- N2: travel-domain.md:39-41 describes a "fictional twin… modelled on the real client". Say only the shape follows the real CV, and that names, employers, dates and certificates are invented (constitution §3). The phrase is a candidate pending glossary term.
- N3: the rules do not say when the review happens. May documentation reach main before its round? Is a proposal reviewed before it goes to the owner? The F1/F2 text reached the owner unreviewed.
- N4 (pre-existing): review.md:115-116 and code-reviewer.md pin max effort as "the owner's standing preference". The global rule (2026-09-26) says high effort, with max only for extremely complex changes. More rounds now make this gap costlier.
- N5: the term-row exemption rests on a lead adoption from 2026-09-25. Given the owner's newer "only truly trivial" rule, it is worth one line to the owner. "Night Shift" and "Day Shift" recur without a glossary row.

## Checks rerun
None under builds/; this batch is documentation only. Read-only git checks: `git diff --check 57fad21~1 11bb256` on the five changed docs: exit 0. `git ls-files --eol` on the same five: LF. `git worktree list`: the sweep's command exists; one worktree.

## Evidence inspected (at 11bb256 unless noted)
Changed docs: docs/review.md, docs/development.md, AGENTS.md, docs/proposals/travel-domain.md and short-career-layout.md (also at 57fad21). Rule and reference docs: CLAUDE.md, .claude/agents/code-reviewer.md, docs/proposals/README.md, docs/vision.md, docs/glossary.md, docs/constitution.md, docs/git-workflow.md, docs/guides/client-workflow.md, docs/reference/layout-and-pagination.md and domains-and-roles.md. Skills: new-client, new-cv, idea-run. Code and examples: packages/cv-framework/core/pagination.typ, the Flagship composition and flagship-v11.typ, tests/run.py, examples/marine/flagship/*.typ. Other: brand/README.md, .night-shift nights and follow-ups JSON. Outside the repository: the night-shift v14 source and the owner's global delivery rules.

## Limitations
I did not read the Trello cards; the owner's words come from the brief and the Decisions entries. Night Shift behaviour comes from its source; I did not run the CLI. I checked only the brand row's accuracy, not the brand assets themselves.

## Verdict: FINDINGS

## Dispositions (lead)
- F1 fixed: the revisit condition is the one-off CV reaching `Export`, returning to `pending` for the owner's approval; "or open the build task directly" removed; steps 3-4 start only after that approval; "Decision requested when it returns" added; card trigger updated.
- F2 fixed: a dated correction section for the implementer; approval and scope unchanged.
- F3 fixed: "trivial path"; idea runs "are not exempt; they are reviewed by their own gates"; later revisions of an idea-run proposal come here; the prose a rename or drop updates is reviewed; development.md says "a trivial change"; AGENTS.md names the idea gates.
- F4 fixed: the sweep checks every commit on `main` since the handoff card's last `Written` date, any author; record-keeping commits named in review.md; batching "since the last handoff".
- F5 fixed: the sweep also reads the last night's `night.json` for unanswered questions and unsent feedback.
- N1 fixed (Active and Blocked added; `gh run list --commit <main head>`). N2 fixed (twin wording). N3 fixed (timing paragraph in review.md). N4 fixed: code-reviewer effort high, review.md updated to the 2026-09-26 preference. N5: reported to the owner; no glossary change for Night Shift terms (the protocol trial that named them ended 2026-09-26).
