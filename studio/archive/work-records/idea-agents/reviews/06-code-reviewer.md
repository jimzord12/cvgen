# Review round 4: idea-agents

Snapshot: `feat/idea-agents` at `6651244` in `C:\Users\jimzord12\Documents\GitHub\cvgen-wt-ideas`. The tree was clean before and after my checks. I read the delta `5e09161..6651244` (10 files) in full. I also reviewed the net change `origin/main...6651244` (65 files). Its merge base is `db03370`, which is where `origin/main` stood at the last fetch; I did not fetch.

Lead lenses: (1) whether R3-1..R3-4 and N1..N5 are resolved, especially the exception's attribution and the narrowed fallback check; (2) whether the net change against main is consistent and ready to merge.

Coverage:
1. **Wiring:** each fix is in the file its reader loads: `review.md:20-29`, SKILL steps 3 and 8, the fallback paragraph, the three templates, and the editor's fence and drop rule.
2. **Correctness:** the exception, step 8 and the editor's write fence now agree on the README rows. The narrowed fallback check lost one ref (R4-1).
3. **Integrity:** no concept render input has changed since `a0e12ae` (only README text), so round 2's pixel check still covers the committed PDFs. The record note in 03 matches the docs-audit precedent.
4. **Access/privacy:** all three reviewers now stay out of `private/`, and the ceo-reviewer never names a real candidate. The net change has no `private/`, `.local/` or credential paths.
5. **Evidence:** suite inputs are identical to main: empty diff under packages, examples, tests, scripts, exports and archive, plus `.gitattributes` and `.gitignore`. Nothing in this delta needs a render.
6. **Failure:** the fallback check's stop/continue rule has one gap (R4-1).
7. **Ownership:** the attribution is now honest (N1 resolved). The text does not say where the owner's confirmation is tracked (R4-2).
8. **Repository:** LF endings are clean, relative links resolve, commit scope matches the dispositions and binaries are marked. The merge is conflict-free against `origin/main` as last fetched.

## Findings
### R4-1 Minor: the narrowed fallback check no longer sees a push to the published main
Anchor: `.claude/skills/idea-run/SKILL.md:71-76`
- **Scenario:** in fallback mode, drafts are committed on the run branch (step 3 now suggests this). A stand-in, for example one steered by a fetched page, runs `git push origin HEAD:main`, possibly with `--force`. Only `refs/remotes/origin/main` changes. HEAD, the status, the run branch (local and remote), `refs/heads/main` and the tags stay the same.
- **Expected:** the run stops, as it did under round 3's `git for-each-ref` check.
- **Actual:** the new text says "Other refs moving is parallel work: log it, do not stop."
- **Impact:** unreviewed drafts could land on the public main, or a force-push to main (owner-reserved, `preferences.md:53-55`) could be logged as parallel work. The probability is low.
- **Fix:** add `refs/remotes/origin/main` to the refs that stop the run. It moves together with `refs/heads/main` when a parallel task integrates, so it adds no new kind of false stop. Also record `git for-each-ref` in full: as written, only the listed refs are recorded, so "other refs moving" cannot be logged.

### R4-2 Minor: "listed for the owner to confirm" does not say where it is listed
Anchor: `docs/review.md:20-22`; disposition N1 ("the owner's list in the morning report")
- **Scenario:** the owner does not answer the morning message, and a later session rewrites the handoff card without the item. Orientation reads only proposal metadata. The exception stays in effect, the parenthesis stays in review.md, and nothing brings the question back to the owner.
- **Expected:** a decision awaiting the owner is tracked where orientation sees it. See `AGENTS.md:48-49`, `development.md:62-64` ("parked owner decisions") and the docs-audit precedent (`findings.md:79`).
- **Fix:** name the place, for example "parked on the session-handoff card", or link a short pending proposal. When the owner answers, replace the parenthesis with his dated decision. I could not read the card, so the item may already be there.

### N1 Note
- `design-concepts/README.md:14` now compiles into the committed `concept.pdf`. Typst embeds the compile time (CreationDate `D:20260925021525+03'00` in the feature-opener PDF), so every run rewrites that binary. With a wrong `--font-path`, Typst exits 0 and writes a two-page page in a fallback font (round 2's control case). Suggested line: "to check a concept without changing it, write to `builds/<new folder>/`".
- `design-reviewer.md:20-23` and `research-reviewer.md:20-23` do not list the snapshot among their inputs, and the descriptions at `ceo-reviewer.md:3` and `design-reviewer.md:3` omit it. This is harmless, because the templates say "as given in your brief".
- The editor's shell line (`magazine-editor.md:16-18`) omits removing the font family that `:112-113` now asks for.
- `SKILL.md:86-90`: the handoff sentence now comes before "A short message:", followed by two blank lines.

### N2 Note (investigation items)
- Subagent shell commands start in the session's main folder. Step 1 allows a worktree, but step 2 never tells the lead to give authors absolute worktree paths, and the editor's compile command is relative (`--root .`). Stray writes would land in the main checkout, which the fallback check (run worktree only) does not look at. One clause in step 2 would fix this. I did not reproduce it.
- `01-` and `02-research-reviewer.md` have lead-style headers, and 02 has no snapshot. If they are condensations, label them the way 03 is labelled.

## Checks rerun
- `git log`, `diff --stat` and `check-attr` on `5e09161..6651244`, `origin/main...6651244` and `a0e12ae..6651244` (console output only).
- Inline Python fed via stdin, writing nothing: none of the 49 added or modified text files at `6651244` contains a CR, and none of the 31 markdown files has a broken relative link.
- A pymupdf read of the metadata of the five committed concept PDFs.
- Nothing was written under `builds/`. The suite was not rerun because its inputs are identical to main.

## Evidence inspected
At `6651244`:
- `review.md`, the idea-run `SKILL.md` and the five idea agent files.
- `design-concepts/README.md` and the headers of the three `concept.typ` files.
- `AGENTS.md`, `preferences.md`, `development.md`, `proposals/README.md`, `git-workflow.md`, `pdf-workflow.md` and constitution section 2.
- Both run records, review records 01-05 and the metadata of the three proposals.

Earlier outputs, read but not rerun:
- Round 2's render report: `C:\Users\jimzord12\Documents\GitHub\cvgen-wt-ideas\builds\code-review-idea-agents-r2-20260925-024410\report.txt`.
- The suite report: `C:\Users\jimzord12\Documents\GitHub\cvgen\builds\tests-20260925-025450-946461\report.json` (passed, 38 cases).

## Limitations
- I did not read the Trello card or the handoff card, because both are external. Unverified as a result: the acceptance criteria, the owner's exact wording of "closed review loop", and whether the exception is parked on the card.
- I did not fetch the remote, check CI, start the agents by name or open web sources.

## Verdict: PASS

## Disposition (lead, 2026-09-25)
- R4-1: the fallback records `git for-each-ref` in full; changes to HEAD,
  status, the run branch and its remote ref, `refs/heads/main`,
  `refs/remotes/origin/main` or tags stop the run until explained; other
  refs are logged as parallel work.
- R4-2: review.md says the exception is parked on the session-handoff card
  and is replaced by the owner's dated decision; the lead adds it to the
  card at the end of this session.
- N1: the concepts README warns that compiling rewrites the PDF and says to
  check into `builds/`; the snapshot is listed among the design and research
  reviewers' inputs; the editor's shell line covers removing a unique font
  family; the SKILL blank line fixed.
- N2: step 2 tells the lead to give absolute worktree paths and run Typst
  from the worktree root; 01 and 02 research-reviewer records are labelled
  as condensations.
