# Review round 2: idea-agents

Snapshot: worktree `C:\Users\jimzord12\Documents\GitHub\cvgen-wt-ideas`, branch `feat/idea-agents`, `ad53ec2..a0e12ae` (HEAD `a0e12aeb`). Sanity range `422f150..a0e12ae` is 60 files, none under packages/, examples/, tests/, scripts/ or exports/. Tree clean before and after my checks.
Lead lenses: (1) F1: agent tools lines against their fences; (2) the idea-run rewrite and the concept font move.
Coverage:
1. Wiring. Authors only propose. The ceo has no shell and the skill feeds it the board. The ceo-reviewer is not fed the board (R2-3).
2. Correctness. Post-PASS categories (R2-5) and answer mapping (R2-4). The `-2`/`-3` run suffix and `docs/idea-run-*` branch names are fine.
3. Integrity. Font renames are byte-identical and the brief SHA-256 values match the files. Main PDFs are unchanged and reproducible. Travel changes are confined to the dates.
4. Access/privacy. Both authors now carry the git/Trello fence and the data-not-instructions line. ceo-reviewer and research-reviewer have no write tools at all. design-reviewer can write only by instruction, the same stance docs/review.md accepts for code-reviewer. Data is fictional.
5. Evidence. The suite does not apply (it reads none of the changed paths). I rechecked the renders myself (N2).
6. Failure. The fallback check has blind spots (R2-2). A wrong font path compiles with exit 0 and only a warning, but the page changes, and my pixel comparison catches that.
7. Ownership. The exception to the review rule exists only in the skill (R2-6).
8. Repository. LF endings are clean. Font wording is stale in places (R2-1). Listing the folder in pdf-workflow.md and git-workflow.md (F5) is deferred as agreed.

## Findings
### R2-1 Minor: the shared fonts folder is outside the editor's write fence and stale in two docs
Anchor: `.claude/agents/magazine-editor.md:15-19` vs `:79-85`; `design-reviewer.md:49-52`; `design-concepts/README.md:8-10`
- The fence allows only "your concept folders and design-concepts/README.md". The font rule sends new families to `design-concepts/fonts/<family>/`. The next run that brings a font must break one of the two rules.
- Rubric 4 still asks for "the licence in the folder". A reviewer who reads it literally can block a concept whose licence now sits in the shared folder.
- The README still says each folder holds "any fonts it brings".

Fix: add `design-concepts/fonts/<family>/` (new families only) to the fence. Change rubric 4 to "licence beside the font files". Update the README sentence. Both compile forms work and I checked they give identical output: the parent folder (README, concept.typ) and one path per family (agent file).

### R2-2 Minor: the fallback check cannot see commits, refs, ignored paths or Trello
Anchor: `.claude/skills/idea-run/SKILL.md:57-63`
Scenario: a general-purpose stand-in reads AGENTS.md ("the working agent owns routine Git") and commits its concept. `git status --porcelain` then comes back empty, and run.md records "only the expected files changed". Local settings allow `Bash(git:*)` with no prompt (`cvgen/.claude/settings.local.json:4`).
Fix: record `git rev-parse HEAD` and `git for-each-ref` before and after each round, next to the porcelain output. Any difference stops the run. Also record the model and effort each stand-in ran at, because the frontmatter `effort: max` is not guaranteed to carry over.

### R2-3 Minor: the ceo-reviewer must check the board but never receives it
Anchor: `ceo-reviewer.md:4,38-39`; `SKILL.md:28-32,37-40`
Rubric 4 checks for duplicates on the board. The reviewer has no shell, and step 2 pastes the card list for the ceo only. The first run's reports (`2026-09-25-ceo/reviews/02`, `03`) list what they checked, and the board is not among them.
Fix: in step 4, give the ceo-reviewer the same card list.

### R2-4 Minor: the answer mapping disagrees with docs/proposals/README.md
Anchor: `SKILL.md:71-82`; `docs/proposals/README.md:43,48,59-60,69,80-82`
- "Keep for later -> stays pending" conflicts with README: `deferred` is defined as "Owner chose to leave it for later", and every `pending` item is re-reported at orientation. The owner would be asked again, every session, about an item he already answered.
- The owner answers with three words but the table has four rows. A bare "keep" could mean `approved` (which opens a build card) or `pending`, and README forbids inventing approval.
- An `unresolved` concept at the round cap merges to main as `proposed`, so it looks the same as a concept that passed. Step 8 still claims idea-gate coverage for it.

Fix:
- Map "build" to `approved`, "later" or "park" to `deferred` (concept: `parked`), and no answer to no change.
- Append the dated decision entry README requires.
- Show `unresolved` as the status in the concept's README row.

### R2-5 Minor: the post-PASS rule has only two categories
Anchor: `SKILL.md:45-48`; editor `run.md:39-45`
- The fictional travel date fix was labelled "layout-only".
- The three new "Font files" tables add source URLs, arguably sourced claims, after the research PASS. There was no research-gate rerun and no recorded reason.
- A substantive change that cites no source, for example a proposal's cost changed after the ceo-reviewer PASS, has no route back to the quality gate.
- None of the three reviewer templates has a place to name the revision a review saw.

Fix:
- Use three categories: a sourced change goes to the research gate; content the owner decides on goes to the quality gate; layout, typos or sample data get a lead check noted in run.md.
- Add a `Snapshot:` line to the three reviewer templates.
- Add one run.md line about the provenance URLs.

### R2-6 Minor: idea-gate coverage conflicts with AGENTS.md
Anchor: `SKILL.md:50-55` vs `AGENTS.md:183-185` ("Every non-trivial change of any kind ends with a fresh code-reviewer round"). The "When a review is required" section of docs/review.md says nothing about idea runs.
Fix: add one sentence to docs/review.md or AGENTS.md that names the exception and its limits. This can land at integration with the deferred F5 edits.

### N1 Note
- The ceo, now without a shell, cannot repeat the first run's own PyMuPDF measurements (`2026-09-25-ceo/run.md:113-131`); the lead would have to run and paste them.
- Neither author is told to stay out of `private/` when reading.
- Rejecting a concept leaves its font family in the shared folder.

### N2 Note
The author's pixel-identity claim has no stored evidence: `builds/fontmove/` is empty. My rerun below covers it.

## Checks rerun
- Inline Python (Typst 0.15.1, pymupdf 1.28.2) against HEAD a0e12ae. Compiled all five pages three ways: README form, per-family form, and a control with no concept fonts.
  - README and per-family forms: exit 0, no warnings, one A4 page each, pixel-identical to the committed PDFs at 96 and 200 dpi. Each committed PNG equals its PDF rendered at 96 dpi.
  - Control: warns "unknown font family" and the page differs, which shows the comparison can catch a wrong font path.
  - Travel PDFs, ad53ec2 vs a0e12ae: the text diff is only the two "Jun 2026 -> Jun 2027" lines. Every differing pixel lies inside the date boxes: 120/98 at 96 dpi, 402/304 at 200 dpi, 0 outside.
  - Font SHA-256 values match the briefs, and the OFL headers match the families.
  - Output: `C:\Users\jimzord12\Documents\GitHub\cvgen-wt-ideas\builds\code-review-idea-agents-r2-20260925-024410\report.txt`
- CR scan of the 44 changed text files via `git show`: no CR found.
- Suite not rerun, because none of its inputs changed.

## Evidence inspected
At a0e12ae:
- The five idea agent files, the idea-run skill and AGENTS.md
- `design-concepts/` in full
- The three proposals
- Both run records and their reviews
- `03-code-reviewer.md` with its dispositions
- docs/review.md, development.md, proposals/README.md, git-workflow.md
- `.gitattributes`

Also: the ad53ec2 travel PDFs and PNGs via `git show`, the round-1 builds folder, and the main checkout's `.claude/settings.local.json` (outside the snapshot).

## Limitations
- The Trello card and board were not read.
- Web sources and the upstream font URLs were not fetched.
- I could not start the agents by name.
- CI was not checked.

## Verdict: PASS

## Disposition (lead, 2026-09-25)
- R2-1: fence includes `design-concepts/fonts/<family>/` for new families;
  design-reviewer rubric 4 says "licence beside the font files"; README
  sentence updated.
- R2-2: the fallback records `git rev-parse HEAD`, `git for-each-ref` and
  porcelain before and after each round, stops on any difference, and
  records each stand-in's model and effort.
- R2-3: step 4 gives the ceo-reviewer the same card list.
- R2-4: mapping rewritten to the proposal states: build -> `approved`,
  later or park -> `deferred` (concept `parked`), reject -> `rejected`, no
  answer -> no change, dated decision entry appended; an `unresolved`
  concept's README row says `unresolved` and it is not claimed as covered.
- R2-5: three categories (sourced -> research gate; owner-decided content ->
  quality gate; layout, typos, sample data -> lead check); `Snapshot:` line
  in the three reviewer templates; the editor run record notes the font
  provenance URLs as recorded facts, checked against the google/fonts paths
  by the lead, not new claims.
- R2-6: one sentence in docs/review.md at integration, together with F5.
- N1: the ceo brief says the lead supplies measurements it asks for; both
  authors are told not to read `private/`; a rejected concept's font family
  is removed if no other concept uses it.
- N2: covered by the reviewer's rerun.
