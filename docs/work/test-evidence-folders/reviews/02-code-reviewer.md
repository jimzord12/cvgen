# Review round 2: test-evidence-folders

Stored as returned by the `code-reviewer`; the lead's dispositions follow at
the end.

# Review round 2: test-evidence-folders

**Verdict: PASS.** I found no Blocking, Material or Minor findings. Two Notes only.

Snapshot: `f7a6996..7dc30f4` on `feat/test-evidence-folders`. HEAD is 7dc30f4 and the working tree was clean before and after my run. I focused on the fix diff `9f690d5..7dc30f4` and also re-read the full change.
Lead lenses: (1) wiring, (8) repository and documentation
Coverage:
1. **Wiring:** covered in depth.
   - The new CI globs `builds/ci/**/compile.log` and `builds/ci/**/page-*.png` match the real layout. My run has 48 `<case>/compile.log` files and 17 folders with `page-N.png`, and nothing is left flat at the top.
   - `report.json` stays at the top, where the existing `builds/ci/report.json` glob expects it.
   - I searched the whole repo (excluding `docs/work`, archive, history and the retired `now.md`) for `exact/`, `-check/`, `<case>.log` and flat `.log`. No reader of the old layout remains.
   - The other hand-render instructions (design-reviewer, new-theme, new-cv, git-workflow step 3) cover PDFs the suite does not render, so they do not conflict.
2. **Correctness:**
   - Every `check(` call is renamed to `check_case`; none is left. The loop variable `check` at `run.py:358` no longer shadows the helper.
   - The `workflow` guard (`run.py:122`) runs before `mkdir`.
   - In `report.json`, 60 of 61 entries have a `folder` and every named folder exists. Only `example-records-match-schema` has none, which matches the ADR's new wording.
3. **Data integrity:** n/a. Candidate data, `tests/workflow.py` and the approval code are unchanged.
4. **Contracts and privacy:** `report.json` only gained keys. The skill's hand-render example writes into `builds/`, not `private/`.
5. **Tests and evidence:** my rerun passes, the exact v11 check passed, and `engineer/` holds the PDF, `compile.log`, `page-1.png`, `page-2.png` and `check/`.
6. **Failure handling:** unchanged since round 1. The new guard fails loudly with a clear message.
7. **Simplicity:** each fix is the smallest one proposed. No scope creep.
8. **Repo and docs:** covered in depth.
   - The ADR, `verification.md` and the verify-cv skill agree with the code. The ADR index row is present.
   - `git diff --check` is clean and every changed file has zero CR characters.
   - The round 1 report is stored in `docs/work/test-evidence-folders/reviews/`, with dispositions that match the diff.

## Findings

### N1 Note: CI still does not upload the workflow's `commands.log`
Anchor: `.github/workflows/verify.yml:35-40`, `tests/workflow.py:49`
- **Scenario:** a `workflow-*` check fails in CI.
- **Actual:** `builds/ci/workflow/commands.log` has every command with its output and exit code, but no glob matches it.
- **Why only a Note:** this was already true before this change. The old `builds/ci/*.log` glob did not match it either.
- **Optional fix:** add `builds/ci/workflow/commands.log`.

### N2 Note: the ADR's PNG count is a little high
Anchor: ADR 0013, Consequences
- **Actual:** the ADR says "about 20 checked cases render PNGs", but today 17 do.
- **Impact:** negligible, since the text says "about".

## Checks rerun
- `python tests/run.py` at 7dc30f4, with Typst 0.15.1.
  - Result: exit 0, 61 cases, `passed: true`, `exact_reference.passed: true`.
  - Output: `C:\Users\jimzord12\Documents\GitHub\cvgen\builds\tests-20260928-164838-750825`
- A Python read of that run's `report.json`, checking that every `folder` key exists on disk.

## Evidence inspected
- At 7dc30f4:
  - `git diff 9f690d5 7dc30f4` and `git diff f7a6996 7dc30f4`
  - `tests/run.py`, `tests/workflow.py`
  - `.github/workflows/verify.yml` (and its f7a6996 version)
  - `docs/decisions/0013-one-evidence-folder-per-test-case.md` and its row in `docs/decisions/README.md`
  - `docs/reference/verification.md`, `.claude/skills/verify-cv/SKILL.md`
  - `.claude/agents/design-reviewer.md`, `.claude/skills/new-theme/SKILL.md`, `docs/git-workflow.md`
  - `docs/work/test-evidence-folders/reviews/01-code-reviewer.md`
- The author's run `builds\tests-20260928-164714-963133`: 61 cases, passed, 12 entries with `folder: workflow`. Its timestamp is the same second as the commit, so my own rerun is the proof tied to this snapshot.

## Limitations
- I did not run CI. The glob check comes from reading the workflow file and comparing it with the real run folder.
- The brief gave no Trello card URL, so I did not read the task record.
- I opened no PNGs this round. Round 1 already inspected `deck-cadet\page-1.png`, and the rendering code did not change.

## Verdict: PASS

## Dispositions (lead)
- PASS; the loop ends.
- N1 fixed: verify.yml also uploads `builds/ci/workflow/commands.log`.
- N2 fixed: the ADR says 17 checked cases today.
- Both are one-line trivial edits (one configuration glob, one number) taken from this report; they take the trivial path with the suite rerun and the CI run on the merge as the focused check (docs/review.md, "When a review is required").
