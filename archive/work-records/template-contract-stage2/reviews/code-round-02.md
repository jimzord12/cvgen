# Review round 2: TASK-68

Snapshot: worktree `C:\Github\cvgen\.worktrees\contract-stage-2`, `feat/contract-stage-2`, c1a5761..e91e270. That covers 5ee2afb ("fix: Stage 2 review round 1") and e91e270 (the Atlas restamp, which arrived after your message). HEAD is confirmed and the tree is clean.
Lead lenses: (1) the section 6 table and the "rose, held, error" rule, now including the new claimed-shape branch; (2) regressions in Stage 1 `choose()`/`coverage()` and in the schema.
Coverage:
1. Product fit and wiring: unchanged; `render.py` still reaches `choose`.
2. Correctness: M1, m2 and N3 are fixed; one new defect (R2-M1).
3. Data integrity: `dropped` is now right for a required group that turned optional.
4. Contracts: R2-M1 departs from the approved rule.
5. Tests: the new tests would fail on the round 1 defects; nothing pins the new branch against the table's error rows.
6. Failure handling: the refusals are clear and name the fix.
7. Simplicity: `shown_by` is small and well placed.
8. Repository and docs: ruff is clean; the manual matches the code (including R2-M1's row).

## Round 1 dispositions verified
- **M1, resolved.** `shown_by()` is used for `dropped` in `contracts.py:197-198` and for coverage at `:336-337`. My round 1 probe now gives `dropped: []` with only the "rank became optional by version 2" warning. Coverage is "1 of 2" for that case, and the 'shift' test pins "4 of 4".
- **m2, resolved.** `exactly [1,3]` with a v2 record is refused with the fix text (`:191-194`); the 'gap' test covers it.
- **m3, resolved.** `run.py:132-138` refuses `{'brnad'}` and `{'brand': 5}`.
- **m4, accepted.** `conventions.md:140-142` forbids rewriting an ADR beyond its Status line, and the Status line already says Stage 2 was built on 2026-11-08. The TASK-68 note you promised is still to be written.
- **N3, resolved** ("by version N").
- **N2 and N4** stay as Notes.
- **Stage 1 regression check.** The real marine `choose()` gives the default (dropped `[]`, no warnings), and the `narrow` design drops `portrait` and `skills` as before. With `last = version`, `shown_by` only adds required groups, which `check_groups` never drops, so the result is the same as Stage 1.

## Findings
### R2-M1 Material: a claimed new `schemaVersion` turns the table's errors into warnings, on a claim nothing proves
Anchor: `packages/cv-workflow/cv_workflow/contracts.py:263-266`; `docs/engine/template-contract.md`, table row "An optional group it claims changed…".

Scenarios (probe):
- **(a)** A required group that stays required rises 1 to 2, and the manifest claims `x@2`. The result is `error: 'never'`, a warning. Section 6 says "A required group is new, changed or removed: Error".
- **(b)** A Variation declares `exactly [1]` and claims `places@1` and `places@2`. A v2 record that holds `places` renders with a warning, and `cv.py contracts` counts the group as covered ("2 of 2").

Expected: P-0019 section 6: "A group the `Template Variation` renders whose `schemaVersion` rose is an error whenever the record holds it, whatever else moved." ADR 0016 also says claims are proved.

Actual: the claim `places@2` is never rendered on a fixture. `coverage()` checks only that the current version's `schemaVersion` is among the claimed ones, so extra claims pass unseen. A manifest entry nobody has proved now lets a record with a changed shape through, contrary to the approved rule.

My round 1 N1 suggested this direction; as built, it overreaches.

Smallest fix: revert the branch and its table wording, so N1 stays a Note. If the owner later wants the behaviour, first make `coverage()` refuse a claim at a `schemaVersion` that no rendered version has. Once that is done, the branch can never trigger, because a `schemaVersion` only rises.

### R2-N1 Note: `shown_by` replaces a claim set instead of joining it
`shown_by` (`:213-216`) overwrites the claimed set of any group that is required at the last version, instead of uniting the two. This is harmless today, since only optional groups are claimed.

### R2-N2 Note: stray spaces in a test line
`tests/compatibility.py:149` has a run of spaces inside the line (`==             '4 of 4…'`), a leftover from formatting.

## Checks rerun
- `run_compatibility` plus `run.check_example_records()` with `C:\Github\cvgen\.venv` on e91e270: exit 0; 6 compatibility checks and the example-record check pass. Output in `C:\Github\cvgen\.worktrees\contract-stage-2\builds\review-task68-r2-20261108-122743\compatibility\`.
- `ruff check`: all passed.
- Read-only probes: `probe.py` and `probe3.py` in `C:\Users\jimzord12\AppData\Local\Temp\claude\0bad7b43ffb974fe\bd07fd7a-826f-4da0-ace1-f4e996f70146\scratchpad\`, covering Stage 1 `choose()` on real marine plus scenarios (a) and (b).

## Evidence inspected
- `git diff c1a5761 e91e270` (contracts.py, tests/compatibility.py, tests/run.py, the manual, Atlas).
- `docs/conventions.md:140-142`; P-0019 section 6.

## Limitations
- I did not rerun the full suite or the Typst coverage renders.
- There is no author suite run for e91e270 in the brief.

## Verdict: FINDINGS
