# Review round 4: short-career-layout

Stored as returned by the `code-reviewer`; the lead's dispositions follow at
the end.

# Review round 4: short-career-layout

Snapshot: feat/short-career-layout at 1887470 (base 48933f5). I read the round-4 fix (`git diff d3d98e9 1887470`) and the full change. The working tree was clean when I started, but during the review two uncommitted edits appeared: `flagship.typ` and `layouts/flagship-one-page.typ` (a `stack-gap: 12mm`), and `docs/architecture.md` also changed in the working tree. I reviewed the committed snapshot only. See N17.

Lead lenses: (2) correctness, (5) tests

Coverage:
1. Wiring: unchanged. `deck-cadet.typ` → `one-page()` → `spread: true` → the one page loop in `flagship.typ`.
2. Correctness: I traced every combination.
   - `spread` false (v11 and every other profile): `shared` is false and the anchor condition reduces to `anchor-education`, so behaviour is identical to before. The v11 exact match passed in my rerun.
   - `spread` with both sections: identical to round 3. The deck-cadet, one-page-one and one-page-three PNGs are pixel-identical between the author's round-3 and round-4 evidence (empty diff bounding box). Measured gaps on one: 24.9/21.7mm, the same as round 3.
   - `spread` with one or both sections missing: no `v(1fr)` anywhere, the anchor is off, and each heading keeps its own gap.
   - A section flagged in the plan but empty in the data correctly counts as missing.
   - Multi-page plans and `spread` with `anchor-education: false` fall outside the documented use (N13 docs). Nothing ships that way.
3. Data integrity: n/a. Only fictional fixtures; no data or workflow code changed.
4. Contracts: n/a. `spread` stays optional; no schema changed.
5. Tests: the assertions discriminate. Detail under "Checks rerun".
6. Failure handling: overflow still fails with "Content overflow on planned page 1".
7. Simplicity: net −2 lines in the owning loop, with one named condition. No scope creep.
8. Repo/docs: `git diff --check` is clean and all touched files are LF. Layout guide, verification.md, the architecture tree and the glossary qualifier match the snapshot. N13-N15 are resolved.

## Findings
### N17 Note: working tree changed during this review
Anchor: uncommitted `flagship.typ`, `flagship-one-page.typ` (`stack-gap`), `docs/architecture.md`
- Scenario: the working tree was edited while the review ran.
- Actual: my first `python tests/run.py` on the live checkout failed in `tests/workflow.py:67` with `engine_uncommitted_changes: True`. That failure comes from the edits, not the snapshot.
- Impact: this PASS covers 1887470 only. The `stack-gap` change alters rendering and needs its own round, including the design-reviewer.
- Fix: commit it, then request round 5 on the new head.

### N18 Note: uneven stacked rhythm at 1887470
Anchor: `builds/.../one-page-no-certificates.png`
- Actual: Experience → synopsis measures 15.2mm (Grace bottom to TOTAL top). Synopsis → next section is only 7.4mm (no-education) and 6.4mm (no-certificates).
- It meets the owner's instruction, but the rhythm is uneven. The pending `stack-gap` looks aimed at this. It is a design call.

### N19 Note: stacked assertions have only an upper bound
Anchor: `tests/run.py:212-218`
- Actual: `all(g < 17)` would not catch a gap that collapses or overlaps. The no-* cases also skip `verify(pages=1)`.
- Impact: low.
- Optional fix: add `g > 3`, or run `verify` on these two cases.

### N20 Note: architecture prose one line behind
Anchor: `docs/architecture.md:179-180` at 1887470
- Actual: "`spread` shares the free space between two such gaps" is true only when both sections are present.
- Fix: add "when both closing sections are present".

## Checks rerun
- `python tests/run.py` on the live checkout: exit 1. This was caused by the concurrent edit (N17). Evidence: `C:\Users\jimzord12\Documents\GitHub\cvgen\builds\tests-20260928-144115-877925\`
- `python tests/run.py` on a `git archive 1887470` extract: exit 0, "PASS: 61 compilation cases plus PDF/data/layout assertions". The v11 exact check is included. Extract: `C:\Users\jimzord12\Documents\GitHub\cvgen\builds\review-r4-snapshot-1887470-144214\`; evidence in its `builds\tests-20260928-144233-819673\`.
- Word positions measured read-only with PyMuPDF (PDF text library) on my PDFs and the author's (identical):

| Case | Attached | First gap | Second gap |
|---|---|---|---|
| one | 15.2mm | 24.9mm | 21.7mm |
| no-education | 15.2mm | 7.4mm | – |
| no-certificates | 15.2mm | 6.4mm | – |

All anchor words are unique, and the footer text ends at 294.3mm on every case.

What the assertions catch:
- On `one`: an extra `v(1fr)` above the synopsis (attached about 27mm), stacking applied when both sections are present (first about 7mm, below 15), and anchor-only (the difference check).
- On the no-* cases: the round-3 two gaps (54/50mm), the anchor left on (about 90mm), and a flexible gap above the synopsis.
- The 17mm threshold is 1.8mm above the measured 15.2mm. Output is deterministic, so this margin is acceptable.

- Pixel diff of the author's round-3 PNGs (`tests-20260928-143300-346332`) against round-4 (`tests-20260928-143946-383342`): the three both-section pages are identical; only the no-* pages changed.

## Evidence inspected
At 1887470:
- `flagship.typ`, `flagship-one-page.typ`
- `tests/run.py:187-218`, `tests/fixtures/one-page.typ`
- `docs/reference/layout-and-pagination.md`, `docs/reference/verification.md`, `docs/architecture.md`, `docs/glossary.md`, `docs/proposals/short-career-layout.md`
- Reviews 01-03 (code and design) with dispositions
- Author PNGs and PDFs in `builds\tests-20260928-143946-383342\`

## Limitations
- The Trello card was not read.
- Visual taste is left to the design-reviewer.
- The uncommitted `stack-gap` work is out of this snapshot and was not reviewed.

## Verdict: PASS
There are no Blocking or Material findings at 1887470. N17 means the pending `stack-gap` edit needs a fresh round once it is committed.

## Dispositions (lead)
- PASS, on 1887470.
- N17: expected; the owner asked for more gap while the round ran. `stack-gap` is committed as fa61596 and goes to round 5 with both reviewers.
- N18: addressed by `stack-gap` (owner: "Much better now").
- N19 fixed: the stacked assertions have a lower bound (17 < gap < 32 since fa61596), and the no-* cases now also run `verify(pages=1)`.
- N20 fixed: architecture.md says the sharing happens when both closing sections are present.
