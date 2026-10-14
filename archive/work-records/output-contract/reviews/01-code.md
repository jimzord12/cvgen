# Review round 1: output-contract (code)

Snapshot: `8c2657f..56d5549` on `feat/output-contract` (worktree `C:\Users\jimzord12\Documents\GitHub\cvgen.worktrees\output-contract`). HEAD was 56d5549. During the review the lead had uncommitted edits to docs, skills and `.gitignore`. There were none under `packages/`, `scripts/`, `tests/` or `examples/`, so the code I examined and the suite I reran are exactly the snapshot.
Lead lenses: (2) correctness, (5) tests
Coverage:
1. Wiring: cv.py render and approve, build.ps1 -Release, the app and the suite all reach `outputs.py`. OK.
2. Correctness: one Material (M1) and one Minor (m1), below.
3. Integrity: Meta File hash and pages come from the bytes. The moved Release PDFs are pixel-identical to the old ones (I reran the comparison). M1 touches approval state.
4. Contracts: the schema matches the proposal's vocabularies. The `envelope.json` precheck is weaker than the schema (M1).
5. Tests: they catch stale, missing, outside-home, retired `exports/`, envelope refusal and render/approve stamping. Gaps are in m2.
6. Failure handling: late refusal leaves a partial revision (M1).
7. Simplicity: the app lost about 140 lines of path guessing to the one owning module. Good.
8. Repository: renames are clean and the suite is green. See N1 and N2.

## Findings
### M1 Material: envelope.json is only checked for non-empty strings, so render and approve can fail after their side effects
Anchor: `packages/cv-workflow/cv_workflow/outputs.py:55-65`, `render.py:106,187`, `approve.py:38-39`
Scenario: an agent writes `envelope.json` with `"domain": "Marine"`, or `"alias": "client-2026-9-1"`. Separately, `cv.py render --input lang=EN` has the same effect.
Expected: render refuses before the revision folder exists. The code comment at `render.py:103` promises exactly this.
Actual: `envelope()` accepts those values. The compile runs and writes `cv.pdf`, `render.json` and `checks.json`. Only then does `stamp` fail the schema, and cv.py prints REFUSED with no revision summary. I confirmed in memory that `validate()` rejects `domain: 'Marine'`, `alias: 'client-2026-9-1'` and `lang: 'EN'`.
Approve has the same shape: it writes `cv.approval.json` first and then stamps. If the stamp fails (for example `envelope.json` was edited or removed after the render), the receipt exists but the Meta File still says `render`. A retry takes the `already_approved` early return and never re-stamps, so the app shows an approved CV as a plain render for good.
Smallest fix:
- Validate the envelope fields against the schema's property rules inside `envelope()`.
- Call it in approve before the receipt is written.
- Re-stamp idempotently on the `already_approved` path.
- In render, lowercase `lang` (or drop it) before the stamp.
- Add one refusal case to `tests/workflow.py`: an envelope with `domain: "Marine"` must leave no `revisions/`.

### m1 Minor: the flat concept home accepts any PDF name
Anchor: `outputs.py:41-43`
`home_of(design-concepts/2026-09-27-two-inks/old-render.pdf)` returns `{'variant': 'old-render'}`, so the PDF counts as "in a home". The proposal limits this home to `concept.pdf` and `concept-<variant>.pdf`. It is still loud today (reported as "no Meta File"), but stamping it would make a leftover render legitimate. Fix: require `concept(-[a-z0-9-]+)?\.pdf`.

### m2 Minor: two behaviours pass even when broken
Anchor: `tests/workflow.py:105-106`, `outputs.py:148-150`
- The approve test asserts `stamped['date'] == meta['date']`. Both stamps happen on the same day, so it would pass even if `stamp` always wrote today's date.
- The place-versus-meta mismatch check in `load()` (for example a Meta File saying `tier: safe` in `/creative/`) has no case.

Fix: stamp with an explicit old date, re-stamp without changing the bytes, and assert the date is kept. Then change the bytes and assert today. Add one mismatched Meta File to the design-review tree.

### N1 Note: the suite scans ignored working-tree files (the question in your brief)
I ran the worktree's `scan` read-only against the main checkout. It reports 12 leftover PDFs under `exports/`. All are ignored through the old `.gitignore` rules, so `git status` hides them. It also reports the 23 concept and 7 private PDFs that have no Meta File yet.

I judge the suite failure correct: it is the same drift the app would show, the message names the fix, and deleting the leftovers is one step. Make sure the `.gitignore` edit drops the `exports/` rules, so leftovers do not stay invisible to Git.

### N2 Note: the private backfill is incomplete as specified
One envelope has a pre-contract revision dated 2026-09-20 beside its `reference.pdf`. The proposal's backfill list does not mention it, so it will show as Unindexed. No `envelope.json` exists yet under the main checkout's `private/`.

### N3 Note: the app now needs `jsonschema`
Through `outputs.validate`, the Design Review app now needs `jsonschema` as well as `pymupdf`. `tests/run.py:362` imports `cv_workflow` only because `design_review` put it on the path first. It works but is fragile.

## Checks rerun
- `python scripts/outputs.py check` in the worktree: exit 0, "10 PDFs indexed, 0 problem(s)" (console only).
- `python tests/run.py`: exit 0. Evidence in `builds/tests-20260930-011331-473294` (worktree), including case `output-contract (10 PDFs)`.
- `tests/verify.verify(new, old)` for the four moved Release PDFs against `builds/cmp/*-old.pdf`: all passed. Output in `builds/review-cmp-<timestamp>/`. I confirmed the `builds/cmp` copies are byte-identical to the `exports/` PDFs at 8c2657f.
- Read-only `scan(root=main checkout, include_private=True)` in memory; nothing written.

## Evidence inspected
- At 56d5549: `outputs.py`, `output.schema.json`, `render.py`, `approve.py`, `workspace.py`, `scripts/outputs.py`, `scripts/build.ps1`, `scripts/design_review/server.py` and `index.html`, `tests/run.py`, `tests/workflow.py`, `tests/design_review.py`, all 10 Meta Files, and `docs/proposals/output-contract.md`.
- The idea-run branch's PDF list: all 18 match the concept home.
- Main checkout `private/`: file names only.

## Limitations
- I did not run `build.ps1 -Release`, because it writes into `examples/`. I read the script and checked its output: the stamped Meta Files and the pixel comparison.
- I did not run the app's server.
- I did not validate `deck-cadet.pdf` against a fresh compile; the suite's hash check and page count stand in for that.

## Verdict: FINDINGS

## Dispositions (lead, 2026-09-30)

- M1: fixed. `envelope()` checks each field against the schema's own
  property rule and names the bad values; `approve` checks the envelope
  before the receipt and re-stamps `approved` on the `already_approved` path;
  render lowercases `lang` and drops it unless it is two letters. The
  workflow test now refuses an envelope with `domain: "Marine"` and leaves no
  `revisions/`, and renders with `--input lang=EN` (stamped `en`).
- m1: fixed. The flat home accepts only `concept.pdf` and
  `concept-<variant>.pdf`; tested.
- m2: fixed. The design-review test stamps an explicit old date, re-stamps
  unchanged bytes (date kept), changes the bytes (today), and plants a Meta
  File whose `tier` contradicts its place (reported as unindexed).
- N1: agreed. `.gitignore` drops the old `exports/` rules; a leftover shows in
  `git status` and fails the suite until the owner deletes it.
- N2: the 2026-09-20 revision is stamped `render` in the backfill.
- N3: `tests/run.py` puts `packages/cv-workflow` on the path itself.
  `jsonschema` was already required by `cv.py`; the app's docstring notes it.
