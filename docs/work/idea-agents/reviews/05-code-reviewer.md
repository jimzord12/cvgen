# Review round 3: idea-agents

Snapshot: `feat/idea-agents` at HEAD `5e09161`. Worktree `C:\Users\jimzord12\Documents\GitHub\cvgen-wt-ideas`, clean before and after. I reviewed `a0e12ae..5e09161`. Main's part (d7e9717, second parent `db03370`) was separated out using `db03370..5e09161`. Local `main` and `origin/main` are at `db03370`.

Lead lenses: (1) are R2-1..R2-6 and N1 resolved; (2) is the idea-gate exception consistent with the merged governance docs, and are the design-concepts/ registrations accurate.

Coverage:
1. **Wiring:** every R2 fix and N1 fix is in the files the skill and agents read. The ceo-reviewer gets the card list through step 4 (see N2 for its own file).
2. **Correctness:** the answer mapping matches the proposal states. Build maps to `approved`, later/park to `deferred`, reject to `rejected` plus a move to `rejected/`, and silence changes nothing. A dated entry is added. The exception's scope has one gap (R3-1).
3. **Integrity:** the merge `d7e9717` has an empty `--cc` diff, so nothing was resolved by hand. Since `a0e12ae`, the only change to concept render inputs is the README text. One review record is unlabelled (R3-4).
4. **Access/privacy:** author fences now match their tools. The ceo has no shell. The editor fence covers new font families. Both authors are kept out of `private/`. Small gaps: N2.
5. **Evidence:** the branch changes no suite input (empty diff against `db03370` under packages, examples, tests, scripts, exports). `db03370` has the same suite inputs as `10c4bc3`, where the docs-audit reviewer's rerun passed. No render changed. Snapshot line gap: R3-2.
6. **Failure:** at the cap an item is marked `unresolved`, not dropped. The fallback check can stop runs by mistake (R3-3).
7. **Ownership:** the exception now lives in review.md and the skill points to it. `AGENTS.md:181-185` and `development.md:25-28` defer to review.md. The skill's Git line agrees with `preferences.md`, and no owner-reserved operation is touched.
8. **Repository:** `pdf-workflow.md:52` and `git-workflow.md:108` are accurate (one nit, N5). Line endings are LF, relative links resolve, commit scope is tidy.

## Findings
### R3-1 Minor: the exception covers "new files", but every editor run edits design-concepts/README.md
Anchor: `docs/review.md:20-26`, `SKILL.md:53-55`, `magazine-editor.md:103-104`
- **Scenario:** the second editor run adds rows to the existing README. That file is not new, so `review.md:24-26` ("Any other file an idea run touches … is reviewed here") calls for a code-reviewer round on a table row. The alternative is that the lead stretches the rule.
- **Impact:** friction, or a silent deviation, on every editor run after the first.
- **Fix:** in both places, write "new files in `design-concepts/` and the run's rows in `design-concepts/README.md`".

### R3-2 Minor: two reviewers cannot fill in their new Snapshot line
Anchor: `ceo-reviewer.md:4,63`, `research-reviewer.md:4,61`, `SKILL.md:33-39,51`
- **Scenario:** drafts are usually uncommitted during the loop. The template asks for "file paths with their modification time", but these two reviewers have only Read, Grep, Glob and web tools. None of them shows a time or runs git, so the line stays blank or gets invented.
- **Expected:** step 6 needs a snapshot the lead can match against later edits.
- **Fix:** in steps 3-4, the lead passes each reviewer the snapshot: a commit on the run branch, or the paths with their SHA-256. The templates then read "Snapshot: <as given in your brief>".

### R3-3 Minor: the fallback's ref check stops runs when other agents commit
Anchor: `SKILL.md:68-70`
- **Scenario:** overnight, other worktrees are active, as on 2026-09-25 (ceo `run.md:11-12`). Another task commits during a stand-in round. `git for-each-ref` then differs, and "any difference … stops the run".
- **Impact:** false stops, or a lead that learns to ignore the check.
- **Fix:** compare only the run worktree's HEAD plus `refs/heads/<run-branch>`, `refs/heads/main`, `refs/tags` and the run branch's remote ref. Log other ref changes as parallel work.
- **Optional:** the same cheap check could run for the named editor and design-reviewer. Both have a shell, and their git fence is prose only.

### R3-4 Minor: the round-1 report is a condensation but does not say so
Anchor: `docs/work/idea-agents/reviews/03-code-reviewer.md:1-3`, `review.md:168-169`
- **Scenario:** a reader takes file 03 as the reviewer's own text. The brief says it is the lead's condensation.
- **Precedent:** the merged docs-audit files label theirs (`docs-audit/reviews/01.md:53`, `02.md:60`).
- **Fix:** add the same one-line record note.

### N1 Note (investigation item): the owner attribution cannot be traced
`review.md:20` says "(owner, 2026-09-25)". The repository holds only F4, R2-6 and the lead's dispositions. `proposals/README.md:66-69` says an applied rule changes through a new proposal and that agents cannot invent approval. If the card records the owner's instruction, cite it. If not, attribute the exception to the lead adopting F4/R2-6 and put it on the owner's list.

### N2 Note
- `ceo-reviewer.md:3` and `:18-22` do not mention the card list it now receives.
- Its reports are committed publicly, but it lacks the line in `ceo.md:81` against naming a real candidate. A card name could contain one.
- None of the three reviewers has the `private/` line the authors got.

### N3 Note
- When the author drops a concept (`magazine-editor.md:110-112`), a new font family it brought stays behind. Cleanup exists only for owner rejection (`SKILL.md:90`).
- The editor's shell-use line (`:16-17`) does not list the delete or hashing steps the file asks for elsewhere.

### N4 Note
Concepts still waiting for an answer are never surfaced at orientation, which reads only proposal metadata (`proposals/README.md:77-82`). Nothing tells the lead to carry them on the handoff card.

### N5 Note
- `git-workflow.md:108` says "OFL fonts", but Apache 2.0 fonts are also allowed (`magazine-editor.md:81-82`).
- `design-concepts/README.md:14` compiles into `builds/`, which is outside the editor's write fence.

## Checks rerun
- `git show --cc d7e9717`: empty combined diff (console only).
- `git diff --stat db03370 5e09161 -- packages examples tests scripts exports .gitattributes .gitignore`: empty.
- `a0e12ae..5e09161` under design-concepts/, examples/ and the engine fonts: only `design-concepts/README.md` changed.
- Inline Python fed via stdin, writing nothing: none of the 84 changed text files at 5e09161 contains a CR, and none of the 64 changed markdown files has a broken relative link.
- Suite not rerun: its inputs are byte-identical to `10c4bc3`. Nothing was written under `builds/`.

## Evidence inspected
- At 5e09161: the five idea agent files, the idea-run `SKILL.md`, `AGENTS.md`, and `docs/review.md`, `preferences.md`, `development.md`, `proposals/README.md`, `git-workflow.md`, `pdf-workflow.md`, `constitution.md`, `vision.md`. Also `design-concepts/README.md`, both run records, the idea-run review headers, the metadata of the three proposals, reports 03 and 04 with their dispositions, and `trello.ps1 -Cards`.
- Main checkout at db03370: `review.md` and `AGENTS.md`. The docs-audit reviewer's suite run at `C:\Users\jimzord12\Documents\GitHub\cvgen\builds\tests-20260925-025450-946461\report.json`: passed, 38 cases, exact reference passed. I read it; I did not rerun it.

## Limitations
- I did not read the Trello card or the board, so N1 and the card's dispositions are unverified.
- I could not start the agents by name, did not fetch web sources, and did not check CI.
- The brief named no author checks. None are needed for this documentation and agent-instruction change.

## Verdict: PASS

## Disposition (lead, 2026-09-25)
- R3-1: review.md and skill step 8 cover the run's rows in
  `design-concepts/README.md`.
- R3-2: skill step 3 has the lead give every reviewer its snapshot (commit
  or paths with SHA-256); the three templates read "as given in your brief".
- R3-3: the fallback compares only the run worktree's HEAD, status and the
  run branch, main, tags and the run branch's remote ref; other refs are
  logged as parallel work; the check is suggested for the two named agents
  with a shell.
- R3-4: 03 carries the record note.
- N1: the owner asked for a closed review loop for idea work, not for an
  exception to the code-review gate; review.md now attributes the exception
  to the lead carrying out that instruction and it is on the owner's list
  in the morning report.
- N2: ceo-reviewer's inputs name the card list and the snapshot; all three
  reviewers stay out of `private/`; the ceo-reviewer never names a real
  candidate.
- N3: dropping a concept also removes a font family only it used; the
  editor's shell line lists hashing and removing a dropped folder.
- N4: skill says concepts awaiting an answer go on the handoff card.
- N5: git-workflow says OFL or Apache 2.0; the README example writes the
  concept's own PDF instead of `builds/`.
