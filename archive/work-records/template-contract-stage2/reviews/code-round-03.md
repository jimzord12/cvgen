# Review round 3: TASK-68

**Verdict: PASS.** The only open Material finding (R2-M1) is resolved and nothing new blocks the change. One Minor finding about the new suite check remains; you can fix it or record why you defer it.

Snapshot: worktree `C:\Github\cvgen\.worktrees\contract-stage-2`, branch `feat/contract-stage-2`, e91e270..cac5b60 (one commit: "fix: Stage 2 review round 2 - a claim never overrides a changed group"). HEAD confirmed, tree clean.
Lead lenses: (1) the section 6 table and the rule "a group it renders whose `schemaVersion` rose is an error whenever the record holds it"; (2) regressions in Stage 1 `choose()`/`coverage()` and in the schemas.
Coverage:
1. Product fit and wiring: unchanged since round 2.
2. Correctness: the rule is back to the approved text; `shown_by` now joins the claimed and required sets.
3. Data integrity: unchanged; `dropped` stays correct.
4. Contracts: matches P-0019 section 6; a claim now has to be proved.
5. Tests: both claimed-shape cases are pinned. The new suite check has no negative case (R3-m1).
6. Failure handling: the new check's message can mislead in one edge case (R3-m1).
7. Simplicity: the branch is removed and the code is smaller.
8. Repository and docs: the manual table and `verification.md` match the code; ruff is clean.

## Round 2 dispositions verified
- **R2-M1, resolved.** The claimed-shape branch is gone from `contracts.py:262-265` and the manual's table row is reverted. `tests/compatibility.py` pins `one(g(True), g(True,2), {'x':{1,2}})` as `'always'` and the optional claimed case as `'held'`. Both would fail if the branch came back.
- **R2-N1, resolved.** `shown_by` (`contracts.py:213-217`) joins the claimed and required sets.
- **R2-N2, resolved.** The test line is rewritten with a named variable and an assertion message.
- **m4.** The TASK-68 note is still to be written, as you said; I have not verified it.

## Findings
### R3-m1 Minor: the new "every claim is proved" check is untested, and it fires with a misleading message when a Variation renders no version
Anchor: `tests/coverage.py:71-75`.

1. **Untested.** The check runs only on the real manifests, which pass. No case shows that it refuses an unproved claim, although `docs/engine/verification.md` says "Negative cases assert on the exact error text". If someone weakens the check, nothing turns red.
2. **Misleading when nothing is rendered.** When `renders` is empty (`oldestSupported` has passed every version the Variation names), `at` is empty and every claim is reported as "claims …, which no version it renders has". P-0019 section 7 treats a Variation that is behind as reported, never a failure. In practice the frozen-record check would fail first, because a Variation's `Frozen Reference` record sits on a version it names. So the outcome is fine, but the message points at the wrong cause.

Smallest fix:
- Move the check into a small function and give it one negative case, for example a manifest claiming `skills@2` while the contract has `@1`.
- Skip the check when `renders` is empty, and leave that case to the "renders no version the engine still reads" report line.

## Checks rerun
All against cac5b60, with `C:\Github\cvgen\.venv`, output in `C:\Github\cvgen\.worktrees\contract-stage-2\builds\review-task68-r3-20261108-122928\`:
- `run_compatibility`: exit 0, all 6 checks pass.
- `run_coverage` with real Typst 0.15.1 and the strict fonts: all 7 checks pass, including both Flagship coverage renders (7 of 7) and the Stage 1 `choose` refusals.
- `run.check_example_records()`: passes, including the new `copy` refusals.
- `ruff check`: all checks passed.

## Evidence inspected
- `git diff e91e270 cac5b60`: `contracts.py`, `tests/compatibility.py`, `tests/coverage.py`, `docs/engine/template-contract.md`, `docs/engine/verification.md`.
- Earlier rounds' probes and reports.
- Author suite run `builds/tests-20261108-122916-141989` started after the cac5b60 commit time and had no `report.json` yet. I have no completed full-suite run on cac5b60.

## Limitations
- I did not rerun the full suite. The author's run on cac5b60 has to finish and pass before "done".
- There is still no real v2 Domain Contract, so Stage 2 is proved only on synthetic contracts.

## Verdict: PASS
