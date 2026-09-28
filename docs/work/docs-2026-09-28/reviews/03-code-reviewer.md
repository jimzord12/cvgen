# Review round 3: docs-2026-09-28

Stored as returned by the `code-reviewer` (absolute paths shortened to
repository paths); the lead's dispositions follow at the end.

Snapshot: main at 36b3349, with a clean working tree and origin/main at the same SHA. I read the fix diff 9e2248a..36b3349 alongside reports 01 and 02 and their dispositions.
Lead lenses: (1) the fixes close F6, F7 and N6-N9 without new contradictions; (2) I ran the `Session Sweep` myself as written, read-only.

Coverage:
1. Wiring: all six closed. F6: `--since='2026-09-28 00:00'` lists 30 commits and the bare date lists 0. F7: all four reviewer files say `effort: high`. N6 and N9 are fixed as described. N7 is closed in wording, but the mechanism is doubtful (F9). N8: review.md:29 and :39-43 now fit together, and AGENTS.md:207 and SKILL.md:62 agree with them.
2. Correctness: F8, N10.
3. Integrity: no candidate data is touched.
4. Contracts/access: n/a, no contracts or access paths changed.
5. Tests/evidence: documentation only, and the suite reads none of these files.
6. Failure handling: F8 can list fewer commits without any warning.
7. Simplicity: each rule still has one home.
8. Repository/docs: `git diff --check` exits 0 and every changed file is LF. The `Session Sweep` row meets glossary rule 3, since the concept came up twice and "sweep" had two meanings. Its code name matches the tree, and development.md uses the term in backticks. N12.

## Findings

### F8 Minor: the Reviews window uses commit dates, so older branch commits merged later are skipped
Anchor: docs/development.md:65-71
- Scenario: a feature branch holds commits dated before the handoff card's `Written` date and is merged into `main` after the card was written.
- Actual: `git log main --since=` filters by commit date, not by when a commit reached `main`. Today's instance is merge 72a1277 (09-28), which brought in 54ae030, c66ebee, 96ac749 and 13938f2, all dated 09-27. None of them appear in the window. They are idea-run commits covered by their own gates, so nothing was missed today.
- Impact: the gap is narrow but silent. The Git line does not catch it either, because it only flags branches that are already merged, uncommitted or unpushed.
- Smallest fix: add "and, for each merge in that window, the commits it brings in (`git log <merge>^1..<merge>^2`)". Alternatively, keep the `main` SHA on the card and use `git log <sha>..main`.

### F9 Minor: raising effort mid-session may not take effect
Anchor: docs/review.md:131-134; compare .claude/skills/idea-run/SKILL.md:73 ("Subagent definitions load when a session starts")
- Scenario: the lead edits `effort: xhigh` and then starts the round in the same session.
- Actual (unverified): by the repo's own note, the loaded definition is still `high`, yet the report records "xhigh". The edit also leaves `.claude/` dirty during the round. The reviewer cannot know its own effort, so "records the effort used in the report" really means the lead's disposition.
- Fix: say the raise needs a new session, or use the idea-run stand-in (a general-purpose agent with the effort recorded). Also say that the lead records the effort in its dispositions.

## Notes
- N10: I can only infer that nights are named by their start date (both local nights started after midnight). If so, a night that starts before midnight and writes the card after it gets an id one day before `Written` and falls outside "on or after". "On or after the day before `Written`" would cover it at no cost.
- N11 (sweep output, not a defect): run as written, the sweep flags 7e9f619 (the owner-directed removal of three concepts and their fonts, from Night Shift task T3). No review report names it. It is not trivial and not record-keeping, and deleting files is not "new files in design-concepts/", so the idea gates do not cover it either. It predates the rule of 11bb256, but the sweep does not account for rule timing. The lead should classify it or review it. The sweep also surfaces `status: approved` on client-workflow.md and short-career-layout.md. The lead should confirm that client-workflow's approval is still unapplied.
- N12: development.md:68 says "its sweep" in lowercase. review.md:29 and :41 overrun the wrap width.

## Checks rerun
None under builds/. Read-only: the two `git log` window counts (30 and 0); merge-parent ranges for today's three merges; `night-shift status` and `night-shift follow-up list` (exit 0, "No night is open", "No open follow-up items"); `night.json` for both nights (every `answer` and `sent` filled); `git worktree list` (one worktree); `git branch -a --merged main` (only main); `git status -sb` (in sync with the local origin ref; no fetch); `grep status:` over proposals; builds/ has 175 entries. `gh run list --commit`: not run (external API); `gh` 2.89.0 has `-c/--commit`, and git-workflow.md:75 agrees.

## Evidence inspected
At 36b3349: review.md, development.md, glossary.md, AGENTS.md, all seven agent files in .claude/agents, idea-run SKILL.md, travel-domain.md, git-workflow.md, verify.yml, and review reports 01 and 02. Also the ignored `.night-shift/nights/2026-09-2{7,8}-a/night.json`, `builds/night/handoff.md` (a mirror dated 2026-09-27) and the git show of 7e9f619.

## Limitations
I did not read Trello, so the card's actual `Written` date is unknown (the mirror says 2026-09-27; with that date the window lists 55 commits). F9 rests on the repo's own note, not on a harness test. I did not query CI.

## Verdict: PASS

## Dispositions (lead)
- F8 fixed: the handoff card gains a `**Main at:** <sha>` line, and the Reviews check uses `git log <sha>..main`, which includes merged older commits.
- F9 fixed: a raised effort runs in a new session, or through a general-purpose agent with the reviewer's instructions; the lead records the effort in its dispositions.
- N10 fixed ("on or after the day before the `Written` date"). N12 fixed.
- N11: 7e9f619 is classified as the rejection step of the idea-run skill ("Reject: … its folder is removed (Git history keeps it) … and its font family goes too if no other concept uses it"), carried out on the owner's decision; its rows and run record were reviewed with the idea run's closure, and it predates the rule of 11bb256. No further round. client-workflow's approval is still unapplied: it is applied at the first real client (the proposal says so).
