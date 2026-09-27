# Review round 3: premium-text-draft

Stored as returned by the `code-reviewer`; the lead's dispositions follow
at the end.

Snapshot: 8c0eb38 on `feat/text-draft-first-fitting`, worktree `C:\Users\jimzord12\Documents\GitHub\cvgen-main` (clean before and after my runs). The round-3 changes are 8a7ddfb..8c0eb38; the base is 25469c9. `main` is now at fe4d8f7, 14 commits ahead of the base.
Lead lenses: 5 Tests (the round-2 mutants m2/m3/m4); 8 Repository and documentation (is it safe to merge now).
Coverage:
1. Wiring: the guide's compile command, the script's header comment and new-client step 8 all reach the script. The owner's four changes are intact. Main's `design-concepts/README.md` already says "built into scripts/text-draft.typ"; that becomes true on merge.
2. Correctness: the F9 assert refuses a headline given as a string or as three lines. D28's `par(leading)` applies only inside the samples block. A wrapped sample's line pitch went from 8.16 mm (round 2) to 6.86 mm; the row pitch is 9.25 mm. D26: the knot now ends on the tag card's top edge (8x close-up).
3. Integrity: no candidate data path is touched. The four `Release` PDFs rebuild pixel-identical at 2x. No PDF other than the drafts embeds Bona Nova.
4. Contracts: the API change is settled. No tracked file uses `version:` or `check:`. No `.typ` under the main checkout's `private/` imports the script (I scanned file names only).
5. Tests (lead): I ran each mutant through the full suite in an isolated `git archive` copy:
   - m2: the reply `place`d at the foot, as in eac00ec.
   - m3: the page-1 assert removed.
   - m4: both.
   - All three fail at `('text-draft-full', '')`: the compile succeeds where a loud failure is required. m2 and m4 give 2 pages with the reply on page 1. m3 gives 3 pages with the reply on page 2.
   - The unchanged control copy passes 55 cases.
   - Extra m1 (round 1's fixed 12 mm rows) is caught by the overflow assert in text-draft-long.
   - Extra m5 (fixed 3.75 mm rows at the same pitch, so nothing overflows) is caught by the long case's overlap check. The D28 wrapper kept "rows grow" guarded.
   - m2 is caught because the page holds more, not because anything overprints: at eight rows the italic line and the reply touch (0.0 mm apart).
   - By bisection, the long case has 4.7 mm to spare and the full case is about 4.5 mm over. A spacing change of about 5 mm either way will fail one of the two cases loudly.
6. Failure handling: the full case fails with the named message. m3 shows this guard is what stops a silent spill onto page 2.
7. Simplicity: one script, and the fonts sit where every compile already points. No scope creep.
8. Docs and merge (lead):
   - No file changed on both main and the branch. A simulated merge (fe4d8f7 plus the 21 branch files) passes 55 cases.
   - The Bona Nova blobs are identical to main's `design-concepts/fonts/bona-nova`, so the repository does not grow. The OFL notice is present.
   - Font lists are updated in README, tech-stack, theme.md, new-theme and magazine-editor. All files use LF.

## Findings

### F10 Minor: Bona Nova is bundled but not pinned
Anchor: `tests/baseline.json`; `docs/constitution.md` section 1.
- Scenario: section 1 says the manifest pins "the bundled fonts". Source Sans 3, Barlow and Cormorant are pinned; the three `BonaNova-*.ttf` files are not.
- Expected: every bundled font is pinned; section 1 calls adding one "routine".
- Actual: a replaced Bona Nova file passes `check_frozen`, and the constitution's sentence is false once merged.
- Impact: low.
- Fix: add the three SHA-256 entries, or record in the task why the `Text Draft` font stays unpinned.

### F11 Minor: the stored review reports are summaries
Anchor: `docs/work/premium-text-draft/reviews/01-code-reviewer.md` and `02-code-reviewer.md`; `docs/review.md` (loop step 2, "Report and persistence").
- Scenario: neither file has per-lens coverage, anchors, "Checks rerun", "Evidence inspected" or "Limitations"; they are headed "Coverage (summary)". The mutant IDs this brief uses (m2/m3/m4) appear nowhere, so I had to reconstruct them. `revision-snapshot/reviews/03-ci-linux.md` on main has the same shape.
- Expected: each returned report is stored unchanged, with dispositions kept separately.
- Impact: the record on main cannot show what each reviewer reran themselves.
- Fix: store this report and later ones verbatim. If the originals are lost, label the two existing files as lead summaries.

### F12 Note: the F9 guard has no refusal case
If the guard were removed, the suite would still pass. A `case=headline` refusal would pin it. Also, verification.md says `case=english` "names the missing keys", but run.py only checks the start of the message.

### F13 Note: glossary
"house copy" recurs without a term: `house-copy` in the script, the error text, new-client step 8, the `Check Page` row and verification.md. I propose a `House Copy` term. The `Text Draft` row and guide section 8 say "copper stitch" where the official term `Fact Mark` now exists (Rule 1).

### F14 Note: the approved client-workflow proposal still says "plain"
`docs/proposals/client-workflow.md` item 7 says "A plain text draft PDF". Add a dated line to its Decisions section pointing to the owner's First Fitting pick (idea-run `run.md` on main).

## Checks rerun
- `python -B tests/run.py --output builds/tests-review-r3-20260928-020737` at 8c0eb38: exit 0, PASS, 55 cases. Both text-draft PDFs are pixel-identical to the author's `tests-20260928-020128-014319`.
- `builds/review-r3-mutants-20260928-020903/`: folders `ctl`, `m1`-`m5` and `merged`, each running its own full `tests/run.py`. ctl and merged exit 0 (PASS, 55 cases); m1-m5 exit 1 as described above.
- `builds/review-r3-renders-20260928-020737/`: page renders and the knot close-up.

## Evidence inspected
- At 8c0eb38: the script, the fixture, `run.py`, `verify.py`, `baseline.json`, the docs and skills above, the constitution, the proposals README and the client-workflow proposal, the four review files, the fonts and the licence.
- Author runs: `tests-20260928-020128-014319` and `tests-20260928-020200-825238` (the author's mutation run).
- Main at fe4d8f7: the files changed since 25469c9, `design-concepts/README.md` and the idea run's `run.md`.

## Limitations
- I did not read the Trello card. I did not check CI on 8c0eb38.
- I rebuilt m2-m4 from the stored round-2 text and eac00ec's source.
- I judged D26-D28 from my own renders. The design PASS belongs to 8a7ddfb.
- I simulated the merge; I did not perform it. Rerun the suite on the real merge commit.

## Verdict: PASS

## Dispositions (lead)

- F10 fixed: the three Bona Nova files are pinned in `tests/baseline.json`.
- F11 fixed: this report is stored as returned; files 01 and 02 are
  labelled as lead summaries (the original texts were not kept).
- F12 deferred: the headline guard is a drafting aid on a copy override;
  the drafter looks at every page.
- F13 fixed: `House Copy` added to the glossary; the `Text Draft` row and
  guide section 8 use `Fact Mark`.
- F14 fixed: a dated decision line in `docs/proposals/client-workflow.md`.
- The suite is rerun on the real merge commit before pushing `main`.
