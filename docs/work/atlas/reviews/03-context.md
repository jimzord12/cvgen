Context review, round 1 (general-purpose stand-in acting as `context-reviewer`, Opus, high effort), on 7aabd70.

**Verdict: FINDINGS** (2 Material, 7 Minor, 6 Notes; nothing Blocking)

Reviewed snapshot: HEAD 7aabd70 against base b83795e. I acted as `context-reviewer`, with its tools line as a hard limit. I did not read `private/`, `.local/` or Trello.

The worktree has **uncommitted edits** to `change-review.json`, `client-journey.json` and `design-run.json`: loop labels, plus a new `move` in change-review's status. I did not review them.

Checks I ran:
- A script over all 164 citations: every file exists, but 9 line ranges run past the end of the file on main.
- `atlas.py check`: all 5 pages report UNVERIFIED.
- LF line endings on every touched file: OK.
- A privacy grep.

## Material

**M1. The design-run shape (`Density`, 18 designs) is presented as current, but it exists only on the unmerged branch `docs/idea-run-2026-09-29-editor`. The citations point at main paths using that branch's line numbers.**
- Affected entries:
  - site.json `actors.magazine-editor.role`, `terms.Density`, `terms.Style`
  - design-run `tldr`, `setup/ask` (the Spacious page count), `draw/draw`, `gates/revise`, `decide/decide`, `decide/restamp`, `decide/follows`
  - client-journey `design/design-run` ("two `Densities`"), `design/pick` ("one `Density`")
- What main actually says:
  - `.claude/agents/magazine-editor.md:3,11-12,49-58`: "nine real one-page … three tiers".
  - `.claude/skills/idea-run/SKILL.md:17`: "9 pages".
  - `new-cv/SKILL.md:64-65`: "a style and `Design Tier`".
  - `docs/glossary.md` has no `Density` row, and `Style` (:77) is "drawn in three `Design Tier`s".
- The cited ranges match the branch, not main:
  - Past the end of the file on main: `magazine-editor.md:88-209` and `:211-219` (file is 199 lines), `idea-run/SKILL.md:122-134` and `:129-134` (133 lines), `design-concepts/README.md:44-47` (46 lines). The same off-by-one also hits `new-cv/SKILL.md:104-114` and `client-workflow.md:316-318`.
  - `atlas.py check` hashes main's files, so a "verified" stamp would bind to text that does not say these things.
- Fix: cite `git:docs/idea-run-2026-09-29-editor:<path>:<lines>` for the `Density` claims, and mark `Density` as "owner 2026-09-29, on the run branch, reaches main with the run" (the way the roster marks `planned` items). Or hold the Atlas until the run lands. Then correct the main ranges.

**M2. change-review routes agent-context changes to `context-reviewer`, a rule that exists nowhere on main.**
- Where: change-review `review/review` (`with`, `does[2]`, `uses`) and `tldr[1]`, citing `docs/review.md:7-59`.
- What main says: only the `code-reviewer` (`review.md:7-10,70-74,175`; `development.md:21`).
- Where the rule actually lives: `git:docs/codex-visual-tools:docs/review.md` (commit 4aea8d1). Its own round there (`docs/work/design-core/reviews/03-context-reviewer.md` F1) is FINDINGS, not applied.
- This breaks the glossary's "Never the source of a rule": the Atlas is the only place on main that states this routing.
- Fix: cite the branch file and mark that lane `planned`, as the roster already does. Say that on main the gate is `code-reviewer`, and that a stand-in has been used in practice (`docs/work/anti-examples/reviews/01-context.md`).

## Minor

1. **change-review `status`.** It says "you asked to stop that work for now", sets `paused` and `waitingOn: owner`. The cited records say something else: `codex-visual-tools/reviews/01.md:71-76` and `03-context-reviewer.md:41-47` say the owner stopped the *session* and the findings "stay open for the next session", which is the lead's work. "The last twelve changes on main" cannot be checked from the repo. Fix: cite the handoff card's words and its `Main at` sha, or reword. The same applies to the uncommitted `move`.
2. **roster `tldr[2]`.** "Planned means approved but not built" is wrong for the context agents. No approval record exists; they are built on a branch and their review is FINDINGS.
3. **No `atlas.lock.json` at HEAD.** Every page is UNVERIFIED, so the glossary's "marked stale when they change" is not yet true, and the Sweep line (`development.md:90-92`) handles only STALE. Fix: stamp after PASS, commit the lock file, and have the Sweep line cover UNVERIFIED too.
4. **site.json `github-ci`.** It says "every push to `main`", but `verify.yml` runs on every push to any branch and on pull requests.
5. **site.json `client` note.** "At most three messages" drops "(plus a corrected draft…)" from `client-workflow.md:315-317`.
6. **change-review `land/merge` note.** The "Yours only" list leaves out `.local/`, rewriting published `main` history, deleting outside the repo, and revisions, receipts, portraits and source documents (`preferences.md:68-77`). Fix: say "including".
7. **design-run `gates/revise`.** It leaves out the second post-PASS case: a change to a concept's idea or data needs goes back through the quality gate (`idea-run/SKILL.md:65-69`).

## Notes

- `close/report` cites `preferences.md:49-51`. The "HTML for finished work" rule is at `:83`.
- Two snapshot claims sit outside a `status` block and cannot be checked from the repo: system-map `n-state` "empty today", and site `moves` "You said you would do it later".
- `codex-image` `calledBy` says "(through the lead)". Proposal :75-78 has the editor commission images directly.
- Atlas `terms` drift from the glossary: `Session Sweep` drops Night Shift and "places to look", and `Check Page` says "in Greek" where the glossary says the client's language.
- The glossary `Atlas` row and `.atlas/README.md` point to an `/atlas` skill that is not in the repo. Consider adding "(outside this repository)".
- The "owner" attribution in the glossary row's date could not be verified.

## Checks that passed

- **Privacy: PASS.** Clients appear only as `client-2026-09-01`. No `private/<name>` path, and no Greek names in the sources or in `atlas.data.js`.
- **Placement and terms: OK.**
  - The AGENTS.md row sits in "Where things are".
  - The glossary row is well formed and states "Never the source of a rule".
  - The Sweep line fits the list and its tone, and does not duplicate the README's mechanics.
- **Snapshot statements verified:**
  - All 18 run Meta Files are `proposed`: 9 condensed at 1 page, 9 spacious at 2 pages.
  - Neither gate has run, and the owner set cap 10 (`run.md:14,31-38`).
  - "Line Diagram" quote: `run.md:10-13`.
  - Sign-off of `draft-02` on 2026-09-29: `travel-cv-01/reviews/01.md:39`.
  - The codex proposal is approved, not built, with 2 open Material findings: `reviews/01.md` F1, F2.
- **Roster against agent files: matches.** Models, effort (`repo-auditor-lite` inherit/medium) and tools match all 7 files in `.claude/agents/` and the 2 files on the codex branch. The magazine-editor's role is the exception (M1).

## Dispositions (lead, 2026-10-01)

- M1: fixed. Every citation whose cited lines differ between `main` and the run branch (37) now points at `git:docs/idea-run-2026-09-29-editor:<path>:<lines>`; the design-run page, the magazine-editor's card and the `Density` term say the two `Densities` are the 2026-09-29 run's change and reach `main` with it. When the run merges, those sources go stale and the page is refreshed.
- M2: fixed. The review step says `main`'s gate is `code-reviewer`, the `context-reviewer` is on an unmerged branch, and a stand-in has been used; cites the branch file and the stand-in record. Both context agents are labelled "On a branch, not merged".
- Minor 1: fixed. The status now says the reports stay open for the next session and that on 2026-10-01 the owner set his pending decisions aside, including the context-agent merge (the lead's recommendation); the board claim is dated. The `move` is the owner's decision.
- Minor 2: fixed (roster wording). Minor 3: fixed (pages stamped after the review loop and the lock committed; the Sweep line covers UNVERIFIED). Minors 4 to 7: fixed as suggested.
- Notes: all applied (report source, dated snapshot wording, codex-image caller, the two terms, "outside this repository"). The glossary row's "owner" stands: the owner asked for the Atlas in this session (2026-10-01).
