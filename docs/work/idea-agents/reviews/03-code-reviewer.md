# Review round 1: idea-agents (code-reviewer)

Snapshot: `feat/idea-agents`, 422f150..ad53ec2, clean. Lead lenses: the
agent files and skill implement the request safely; repository fit.
Coverage: the request is met in shape (two authors, three reviewers, closed
loop, caps 5/10, one bar); both runs used general-purpose stand-ins; public
content fictional; fonts OFL with licence; all five concept pages recompile
pixel-identical to the committed PDFs and PNGs.

## Findings

### F1 Material: the two web-reading authors can reach owner-only actions; only prose stops them
`ceo.md:4,29-30`, `magazine-editor.md:4`. Both hold Bash, PowerShell,
Write, Edit; local settings pre-approve `trello.ps1:*`, `git:*` and
`Edit(/docs/**)` (a proposal's `status:` line); neither author says fetched
text is data. Fix: the data-not-instructions line in both authors, extended
in reviewers to fetched pages; ceo drops Bash and takes the board list from
the brief; authors and design-reviewer never run git or trello.ps1.

### F2 Minor: the fallback drops tool limits; the limits were never exercised
Fix: start each agent by name once in a fresh session; paste the tool list
into fallback briefs as a hard limit; `git status --porcelain` after each
fallback round, noted in run.md.

### F3 Minor: reviewers at `effort: high`, not the owner's standing reviewer effort
`docs/review.md:91` pins Opus at maximum effort. Fix: `max`, or record why.

### F4 Minor: step 7 merges to main without relating to the review gate
Fix: output confined to new files in design-concepts/, docs/proposals/ and
the run folder is covered by the idea gates (stated in run.md); anything
else goes through docs/review.md.

### F5 Minor: design-concepts/ missing from the approved tree and committed-files table; it grows by design
About 3.0 MB of binaries in the first run (fonts 1.88 MB). Fix: list the
folder in pdf-workflow.md and git-workflow.md; size rule (engine fonts
first, reuse a committed family); decide what happens to rejected concepts.

### F6 Minor: owner answers and unfinished items do not map onto proposal states
Drafts written as `pending` before review; unresolved or dropped items
would merge as `pending`. Fix: ceo drafts in the run folder, the lead moves
passed proposals; map keep/park/reject to states.

### N1 Note
Research gate not rerun when the quality gate changes sourced claims; post-
PASS edits (D12-D13 changed the travel page); branch name `ideas/...` not
`<type>/<topic>`; report naming; same-day runs reuse a folder; proposals say
"tonight's"; briefs lack font URL/SHA-256; the travel sample shows two
certificates "valid to Jun 2026", expired on a 2026-09-25 page.

## Checks rerun
Recompiled all five concept pages from ad53ec2: exit 0, pixel-identical to
committed PDF and PNG, one A4 page, declared fonts only
(`builds/code-review-idea-agents-r1-20260925-022450/report.txt`). LF check
clean. Suite not rerun (no engine, tests, examples, scripts or exports
touched).

## Limitations
Trello not read; web sources not rechecked; agents not startable by name;
CI not checked; cited permissions are local settings outside the snapshot.

## Verdict: FINDINGS

## Disposition (lead, 2026-09-25)
- F1: both authors carry the data-not-instructions line and a hard fence
  (never git or Trello, write only in their folders); reviewers' line covers
  fetched pages; design-reviewer never runs git or Trello; ceo has no shell
  (Read, Grep, Glob, WebSearch, WebFetch, Write, Edit) and gets the board
  list in its brief.
- F2: skill fallback pastes the tool line as a hard limit and records
  `git status --porcelain` per round. Starting each agent by name once is
  on the handoff card for the next fresh session.
- F3: the three reviewers now run at `effort: max`.
- F4: skill step 8 states idea-gate coverage and routes anything else
  through docs/review.md; both run records state their coverage.
- F5: downloaded families move to a shared `design-concepts/fonts/<family>/`
  (reuse instead of copy), with source URL and SHA-256 in each brief; the
  three existing families moved there, main pages pixel-identical. Rejected
  concepts: folder removed, README row names the commit. Listing the folder
  in pdf-workflow.md and git-workflow.md is done at integration, after the
  docs-audit branch (which edits both files) lands on main.
- F6: ceo drafts in the run folder; the lead moves passed proposals; a
  keep/park/reject table maps answers to proposal and concept states.
- N1: skill step 6 covers post-PASS edits (sourced change -> research gate;
  layout-only -> lead check noted in run.md; reviews name the revision);
  branch `docs/idea-run-<date>-<author>`; same-day runs `-2`, `-3`;
  proposals name dates instead of "tonight"; font provenance added; travel
  sample dates changed to Jun 2027 and both travel variants re-rendered.
  This report is filed as `03-code-reviewer.md`.
