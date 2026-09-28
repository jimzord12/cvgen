# Review round 2: docs-2026-09-28

Stored as returned by the `code-reviewer` (absolute paths shortened to
repository paths); the lead's dispositions follow at the end.

Snapshot: main at 9e2248a (working tree clean); fix diff 11bb256..9e2248a, read with round 1's report and its dispositions.
Lead lenses: (1) the fixes close F1-F5 and N1-N4 without new contradictions; (2) the rewritten sweep is workable.

Coverage:
1. Wiring. Closed: F1 (`Export` is a glossary term that a one-off reaches, client-workflow.md:216-226, and the approval step is now explicit), F2, F5 (the fields match the live night.json and the tool's source) and N1-N3. F3 is closed apart from leftover wording (N8). F4 is closed in scope, but its date window cannot be run safely (F6). N4 is fixed only for the code-reviewer (F7, N7).
2. Correctness: F6, N6.
3. Integrity: no candidate data path is touched; N9.
4. Contracts/access: n/a. No schema, contract or access path changed.
5. Tests/evidence: documentation only; the suite reads none of these files. The short-career correction is accurate: pagination.typ:9 raises the quoted error, flagship-v11.typ:26 names companies 0-5, and layout-and-pagination.md:19-28 documents the override.
6. Failure handling: F6 fails silently. The CI line works: verify.yml runs on every push with no path filter, and gh 2.89.0 has `-c, --commit`.
7. Simplicity: each rule keeps one home, and the sweep lists places to look rather than recording state.
8. Repository/docs: `git diff --check` is clean and every file is LF. "Constitution section 3" is the fictional-content rule. "Sweep" now has two meanings (N8).

## Findings

### F6 Material: the Reviews window lists nothing when run the obvious way
Anchor: docs/development.md:65-69 (with :88, where the `Written` line holds only a date)
- Scenario: this session ends and runs its sweep. The night of 2026-09-28 rewrote the handoff card during 01:26-02:24 (its own night.json says so). So the card very likely reads 2026-09-28, the same date as every commit in this batch.
- Actual: git reads a date-only `--since` as that date at the current clock time. At 12:59 today, `git log main --since=2026-09-28` listed 0 commits, while `--since='2026-09-28 00:00'` listed 28, including 57fad21 through 9e2248a.
- Expected: every commit from the start of the `Written` date.
- Impact: the line F4 fixed can report all clear without any warning, in the usual night-then-day pattern. It even drops the session's own commits, which the old wording "every commit of the session" covered. For this line, the answer to lens 2 is no.
- Fix: write "from the start of that date (`git log main --since='<date> 00:00'`)". Alternative: record the main SHA on the card and use `git log <sha>..main`.

### F7 Minor: three reviewers still pin max effort
Anchor: .claude/agents/design-reviewer.md:6, research-reviewer.md:6, ceo-reviewer.md:6; docs/review.md:128-130
- review.md now states that high effort is "the owner's standing preference for reviewers since 2026-09-26". These three were raised to max only because review.md used to call max that preference (docs/work/idea-agents/reviews/03-code-reviewer.md:27, 74). The design-reviewer serves this gate (review.md:19).
- Impact: every design, research and idea round runs at max, against the settled preference; the only recorded reason for max no longer holds.
- Fix: set `effort: high`, or record why these three stay at max.

## Notes
- N6: the Night Shift line reads only the last night. A closed night whose follow-up the owner never created keeps its `answer: null` only in its own night.json, and `start` checks open follow-ups only (night-shift v14 night.ts:123-147, followup.ts:1-2). Read every night dated on or after `Written`. `nights/` is ignored by git, so it exists only in the main checkout.
- N7: "set in the brief" (review.md:130) has no mechanism behind it. Effort is a frontmatter field (idea-agents/research.md:21), so a brief cannot raise it. Say how instead: edit `effort:` for that round, or use the idea-run stand-in and record the effort used.
- N8: leftover wording. review.md:29 says "the only exemption", but :39-42 adds a second class (record-keeping commits). AGENTS.md:207 leaves record-keeping out. idea-run SKILL.md:62 still says review.md "names this exception". "Sweep" now means both glossary rule 3's rename sweep and the end-of-session sweep; a candidate glossary term.
- N9: travel-domain revision 2 was edited in place after the owner deferred it, with no dated line. short-career-layout got one; one line here would keep the history consistent.

## Checks rerun
None under builds/ (documentation only). Read-only: `git diff --check 11bb256 9e2248a`: exit 0. `git ls-files --eol` on the seven changed files: LF. `git rev-parse --since=2026-09-28` resolves to 2026-09-28 12:59:44 +0300. The two `git log` counts above: 0 and 28. `gh run list --help` and `night-shift --help`: local help only. JSON reads of both nights' night.json and the history copy at ee55294 (still `null`, so pointing the sweep at `nights/` is correct).

## Evidence inspected
At 9e2248a: review.md, development.md, AGENTS.md and the four reviewer agent files; proposals/README.md, travel-domain.md, short-career-layout.md; git-workflow.md, glossary.md, the constitution headings, client-workflow.md §8-9, layout-and-pagination.md; pagination.typ, flagship-v11.typ, the flagship.typ page loop, .github/workflows/verify.yml; trello SKILL.md and recipes.md, idea-run SKILL.md; idea-agents research.md and review 03, and round 1's report. Also the ignored local `.night-shift/nights/2026-09-2{7,8}-a/night.json` and, outside the repo, the night-shift v14 source.

## Limitations
I did not read Trello; the card's date is inferred from the night's record, and the travel-domain card's trigger is unverified. I did not run `night-shift status` or query GitHub. F6 predicts how an agent would behave; only git's behaviour is demonstrated. The stored round-1 report says its anchors were shortened, and I cannot compare it with what was actually returned. Codex cannot run a review round, so it cannot meet the new Timing paragraph; Codex has never committed here, so I did not raise it.

## Verdict: FINDINGS

## Dispositions (lead)
- F6 fixed: the Reviews line reads "from the start of the handoff card's last `Written` date (`git log main --since='<date> 00:00'`)" and explains the bare-date trap.
- F7 fixed: design-reviewer, research-reviewer and ceo-reviewer set to `effort: high`; review.md names all four.
- N6 fixed: every night dated on or after `Written`, in the main checkout. N7 fixed: the lead raises the `effort:` frontmatter for that round, restores it, and records it. N8 fixed: "the only exemption for a change itself"; record-keeping explained as records, not changes; AGENTS.md names it; idea-run SKILL.md reworded; glossary rule 3 says "prose update" and a new term `Session Sweep` names the end-of-session check. N9 fixed: a dated lead entry in travel-domain's Decisions.
- Codex limitation noted; no rule change (Codex has not committed here).
