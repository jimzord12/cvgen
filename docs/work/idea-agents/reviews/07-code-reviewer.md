# Review round 5: idea-agents

Snapshot: `feat/idea-agents` at `27c41ba` (parent `6651244`), in the worktree `C:\Users\jimzord12\Documents\GitHub\cvgen-wt-ideas`. The tree was clean before and after my checks, and `origin/feat/idea-agents` is also at `27c41ba`. I read the delta `6651244..27c41ba` (9 files) in full. The net change `db03370...27c41ba` is 66 files. `db03370` is an ancestor of `27c41ba`, so merging is a fast-forward against local `main` and `origin/main`. I did not fetch (see Limitations).

Lead lenses: (1) the fallback check is complete and consistent with the owner-reserved operations; (2) the branch is ready to merge.

Coverage:
1. **Wiring:** each fix is in the file its reader loads. The lead reads SKILL step 2 and the fallback paragraph. The lead and the code-reviewer read `review.md:20-23`. The editor and checkers read the README. The reviewers read their "What you receive" sections.
2. **Correctness:** R4-1 is resolved. `for-each-ref` is recorded in full. The run stops on HEAD, the status, the run branch and its remote ref, both `main` refs, or tags, so "other refs" can now be logged. The "both main refs move together" hint is accurate. A fetch after an outside push moves only `origin/main`, and that still stops the run, which is correct. Remote-only gaps are in N1.
3. **Integrity:** no concept render input has changed since `a0e12ae` (empty diff), so round 2's pixel check still holds. The README's claim that Typst embeds the compile time matches the CreationDate of all five PDFs. Files 01 and 02 now carry 03's record note (round 4's N2 is resolved).
4. **Access/privacy:** the change has no `private/`, `.local/` or credential paths. Recording refs in full exposes only `<type>/<topic>` branch names.
5. **Evidence:** suite inputs are identical to `10c4bc3` and `db03370`, where the suite passed (38 cases). Nothing in this change needs a render.
6. **Failure:** "stops until explained" works as a rule, but the text does not say what happens when a stand-in caused the change (N1).
7. **Ownership:** R4-2 is resolved. The exception is parked on the handoff card, whose "parked owner decisions" orientation reads first (`development.md:37-39,63-64`). All four parts of round 4's N1 are resolved.
8. **Repository:** all nine touched files are LF. No changed file contains a CR, and the relative links in all 32 changed markdown files resolve. `diff --check` is clean for this round; the net change shows only trailing spaces in the unmodified upstream OFL.txt files. Both parallel branches touch `AGENTS.md`, but at lines that do not overlap this branch's.

## Findings
No Blocking or Material finding.

### N1 Note: remote-only changes stay invisible, and the text has no case for a change a stand-in made
Anchor: `.claude/skills/idea-run/SKILL.md:74-81`; `docs/preferences.md:53-55`
- **Scenario:** a stand-in steered by a fetched page runs `git push origin --delete archive/pre-domains`, or pushes to main by URL instead of `origin`. Git keeps no remote-tracking copy of a tag, and a push by URL updates nothing under `refs/remotes/`. Every recorded value therefore stays the same. This follows from Git's refspec rules; I did not reproduce it, because that needs a push.
- Separately, if the explanation is "the stand-in did it", the text lets the run resume. Undoing a force-push to main is the owner's call.
- **Impact:** low probability, and recoverable while the local copies exist. This is Minor-level, so it is a Note here.
- **Fix:** also record `git ls-remote origin` before and after each round, and stop on changes to main or tags. Add: "a change made by a stand-in keeps the run stopped and goes to the owner with the restoring command". GitHub settings, `private/` and paths outside the repository stay beyond any Git check, as known since R2-2.

### N2 Note: wording
- `SKILL.md:31-33`: a subagent's shell starts in the main folder on every call. "Run Typst from the worktree root" therefore needs the `cd` in the same command. If the two are split, the compile fails loudly for a new concept.
- `design-concepts/README.md:17-18` sends checks to `builds/`, which is outside the editor's write fence (`magazine-editor.md:19-21`). This is harmless, but adding "(reviewers and the lead)" would remove the doubt.
- `README.md:19-20`: with a wrong font path, Typst also prints "warning: unknown font family" (round 2's control case). That warning is a cheaper signal than comparing the page with its PNG.

## Checks rerun
- Git commands, console output only:
  - `log`, `status` and `for-each-ref`.
  - `diff --stat` on `6651244..27c41ba` and `db03370...27c41ba`.
  - Suite-input diff against `db03370` and `10c4bc3`: empty.
  - `merge-base --is-ancestor db03370 27c41ba`: exit 0.
  - `diff --check` and `ls-files --eol`.
- Inline Python fed via stdin, writing nothing:
  - A CR scan and a relative-link check over the 66 changed files at `27c41ba`: none found.
  - A pymupdf read, in memory, of the metadata of the five concept PDFs.
- Nothing was written under `builds/`. I did not rerun the suite.

## Evidence inspected
- At `27c41ba`:
  - The nine touched files and `ceo-reviewer.md`.
  - Reports 03-06 with their dispositions.
  - `preferences.md`, `development.md`, `proposals/README.md` and `git-workflow.md`.
  - The net diffs of `AGENTS.md`, `pdf-workflow.md` and `review.md`.
- The main checkout's `review.md` at `db03370`.
- Read but not rerun:
  - `C:\Users\jimzord12\Documents\GitHub\cvgen-wt-ideas\builds\code-review-idea-agents-r2-20260925-024410\report.txt`
  - `C:\Users\jimzord12\Documents\GitHub\cvgen\builds\tests-20260925-025450-946461\report.json` (passed, 38 cases)

## Limitations
- I did not run the requested `git fetch`. It contacts GitHub and rewrites remote-tracking refs, which is outside my boundaries.
  - Local `origin/main` is `db03370`, from this worktree's last fetch at 2026-09-25 03:01:50 +0300.
  - Fetch before merging. If main has moved, the merge is no longer the fast-forward I reviewed.
- I could not read the Trello task card or the handoff card. The acceptance criteria are unverified. So is whether the exception is parked there yet; the lead's disposition says it goes on at the end of the session.
- I did not start the agents by name. The subagent working-folder behaviour comes from the harness notes; I did not reproduce it.

## Verdict: PASS

## Disposition (lead, 2026-09-25)
- N1: the fallback also records `git ls-remote origin` and stops on a change
  to `main` or a tag on the remote; a change the stand-in made keeps the run
  stopped and goes to the owner with the restoring command.
- N2: step 2 says to `cd` to the worktree root in the same command as each
  Typst call; the concepts README names reviewers and the lead for the
  `builds/` check and points at the `unknown font family` warning.
- Note-level only; no further round. The branch merges main (now carrying
  candidate-validation, and the component contract if it lands first)
  before integration; the suite runs on the merge.
