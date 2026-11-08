# Review round 1: TASK-80 (travel-contract-v2)

**Verdict: PASS.** No Blocking or Material findings. There are two Minor findings and three Notes. The suite and ruff pass when I rerun them.

Snapshot: worktree `C:\Github\cvgen\.worktrees\travel-contract-v2`, head 96e9a98, clean except for the untracked `archive/work-records/travel-contract-v2/`. I reviewed `feat/travel-domain...96e9a98` (merge base 54cbd2c), including the 8419eaf resolutions. `contracts.py` is identical to `main`, so the comparison engine is the code already reviewed for Stage 2. I checked it again here against the real v2.

Lead lenses: (1) the version comparison on the real v2; (2) loud failure and data integrity for both record shapes.

Coverage:
1. Wiring: the real path is render.py:122 then 124 then 208: schema, then `choose`, then the licence warning. `cv.py contracts` prints "hanami showcase on travel: renders version 1 to 2, newest 2; 9 of 10 optional groups".
2. Correctness, all as the manual and Stage 2 say:
   - A v2 record on an up-to-1 Variation is refused with exactly `destinations changed (schemaVersion 1 to 2)` plus the fix.
   - A v2 record without destinations is refused everywhere.
   - On the test Variations `plain` and `brief`, unclaimed `travel-story` and `licences` are dropped with a warning and recorded in `dropped`.
   - A v1 record renders unchanged.
   - `broken()` and `check_domain` find no break between v1 and v2.
3. Integrity:
   - A role or licence on a v1 record is refused three times over: by the schema `allOf`, by data.typ, and by a validate.py message.
   - A v2 trip without a role, or with an unknown role, is refused in Typst.
   - In the v2 Coverage Fixture PDF each role label sits next to its own trip ("Qxperiod 9 days LED THE GROUP", "Qxspringtrip 5 days ORGANISED", "Qxwintertrip 4 days TRAVELLED").
   - The twin shows "ORGANISED" twice and never "LED THE GROUP".
   - Totals are unchanged and come from `raw.destinations`.
4. Contracts: the schema, data.typ, v2.json and the manifest agree. The claims `destinations@1`, `destinations@2`, `travel-story@1` and `licences@1` are each proved on the fixture of the matching version.
5. Tests: the refusals are checked by their messages, the v1 twin is compared with the v2 twin, the licence warning is tested at fixed dates, and the markers are unique. The v1 markers also include the route and story, so a false `destinations@1` claim would fail the suite.
6. Failure: every new field fails loudly. Page-2 overflow is caught by the page slot.
7. Simplicity: the code sits in the owning modules (data.typ, sections.typ, checks.py). Nothing was copied.
8. Docs and anchors: see m1 and n1.

**Anchors note checked by content.** I compared head against `main` for glossary lines 58, 60, 61, 64, 65, 66, 67, 69, 72, 75, 76, 77, 78 and 83. Each anchor still names its own term (`Client`, `Alias`, `Drawer`, `Research Library`, `Scout`, `CV Decisions`, `Text Draft`, `Check Page`, `Sign-off`, `Revision`, `Approval`, `Export`, `Framework Gap`). These anchors were already shifted by +2 for the two new rows, `Trip Role` and `Fictional Twin`, so the 6 MOVED lines that `anchors main` reports are false, as the author says. One anchor is genuinely stale (m1).

## Findings

### m1 Minor: the owner-approval step cites the wrong lines
Anchor: `docs/workflow/06-deliver/stage.yaml:70`
- **Scenario:** `deliver.approve` cites `docs/guides/build-a-cv.md:164-169`.
- **Expected:** the `approve` paragraph, which is at lines 165-170 at head (as on `main`).
- **Actual:** line 164 is blank, and line 170 ("...does not match.") is left out. The merge took feat/travel-domain's value. `bun run anchors 54cbd2c` reports `MOVED build-a-cv.md:164-169 -> 165-170`.
- **Impact:** the Workflow Model and the Atlas cite the wrong lines for the owner's approval step.
- **Fix:** change it to 165-170, then render the Workflow Model and stamp the Atlas again.

### m2 Minor: the advice for a one-page Variation contradicts the contract
Anchor: `docs/engine/template-contract.md:100-101`, `tests/coverage.py` (the `brief` comment), task notes line 62
- **Scenario:** the docs say a one-page Variation such as `essential` claims `upTo 2` with `destinations@1`, without `travel-story@1`.
- **Expected:** under v1, `destinations@1` includes the native name, route, seal words, stamps and story. The v1 markers check all of them, and `essential` on feat/hanami-essential already renders them.
- **Actual:** if a Variation follows this advice and renders those fields, the Meta File wrongly lists `travel-story` as dropped. If it does not render them, the suite fails.
- **Fix:**
  - A Variation that renders the v1 route and story claims `travel-story@1` as well.
  - One with no room for them declares `exactly: [2]`, so v1 records are refused loudly.
  - Update the comment on `brief` to match.

### n1 Note: wording on `destinations`
`docs/engine/candidate-schema.md` ("Version 2 requires `destinations`") and template-contract.md:78-79 read as if v1 did not require `destinations`. Since TASK-2 both versions do.

### n2 Note: an impossible licence date passes unchecked
A licence `until` of "31 Feb 2029" passes both the schema pattern and the Typst regex. checks.py then counts it as `not_date_checked` instead of warning. Unlike a certificate's review field, `until` must be a date, so it could be refused.

### n3 Note: the design gate fails on this same snapshot
The untracked `archive/work-records/travel-contract-v2/reviews/design-round-02-showcase.md` records two Blocking design findings on this snapshot:
- D14: the licence line is squeezed.
- D15: "Led the group" would wrap silently on a card with a long period.

This code PASS does not finish the task. The D14 and D15 fixes in `sections.typ` and `hanami.typ` will make this review out of date.

## Checks rerun
- `C:\Github\cvgen\.venv\Scripts\python.exe tests/run.py`: exit 0, "PASS: 242 compilation cases…, 25 passed". Evidence in `C:\Github\cvgen\.worktrees\travel-contract-v2\builds\tests-20261108-131017-814574`, compatibility report in `coverage\compatibility.txt` there.
- `ruff check`: All checks passed.
- `bun run anchors main` and `bun run anchors 54cbd2c`, read-only, without `--fix`: both exit 1, with the results above.

## Evidence inspected
All at 96e9a98:
- contracts v1/v2, `template.json`, `data.typ`, `domain.typ`, `candidate.schema.json`
- `sections.typ`, `hanami.typ`, the v1/v2 fixtures and markers
- `checks.py`, `validate.py`, `contracts.py`, `render.py`
- `tests/coverage.py`, `tests/run.py`, `tests/fixtures/travel.typ`
- template-contract.md, candidate-schema.md, verification.md, the glossary, the stage.yaml files
- the TASK-80 record
- the frozen PDF, page 2 looked at as an image
- the v2 coverage PDF text

## Limitations
- I did not compile a long-period `role: led` case. I relied on the design review's measurement for D15.
- I left page-2 design judgement to the design gate.
- I did not re-review the Stage 2 engine beyond how it behaves on the real v2.
