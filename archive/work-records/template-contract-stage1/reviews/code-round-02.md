# Review round 2: TASK-63, TASK-64, TASK-65 (P-0019 Stage 1, Template Contract)

**Snapshot:** worktree `C:\Github\cvgen\.worktrees\template-contract`, merge-base `0775dac` to head `5db3362`. HEAD was confirmed and the tree was clean before and after my run.
**Lead lenses:** (1) correctness of `contracts.py` choose()/coverage() and how `render.py` calls them; (2) whether `tests/coverage.py` proves what it claims.

**Coverage:**
1. Wiring: `render.py:123` calls choose() before any revision folder exists. The Meta File gets the choice fields through `stamp(**choice)`. The real CLI path is asserted in `tests/workflow.py:105-106`. A later approval re-stamp keeps the fields, because `stamp` merges the earlier Meta File.
2. Correctness: all round 1 fixes hold. I probed choose() with 15 edge inputs. Results are in F2 and F3.
3. Integrity: refusals happen before anything is written. `dropped` is recorded in both render.json and the Meta File.
4. Contracts: `domainContract` was added to both marine schemas the same way. The output schema now has the four new fields.
5. Tests: see F1. I checked the narrow manifest test, the empty-marker test and the path-resolution test, and each would fail if its behaviour broke.
6. Failures: see F3. A refusal ends with exit 2 and leaves nothing behind.
7. Simplicity: the logic sits in `contracts.py`, its owning module. No scope creep found.
8. Docs: see N1 and N4.

## Findings

### F1 Minor: the per-vessel duration marker cannot detect that the duration was dropped
Anchor: `packages/domains/marine/fixtures/coverage-v1.markers.json` (experience, `"6 months"`); `docs/engine/template-contract.md:40-42`
- **What happens:** the months fixture has one ship of 6 months. In the rerun PDF, "6 months" appears three times: the company total, the vessel row and the summary. A Template Variation that hides per-vessel months would still pass. The company `service-months` form (vessel months unknown, company total given) is in no fixture.
- **Expected:** the manual says "a marker in every printed field".
- **Impact:** low. `show-vessel-durations: false` already makes vessel durations a display option, and the totals still carry the facts. Still, the round 1 fix "fixtures mark durations" is only half proven.
- **Fix:** use two ships with different months (e.g. 4 and 7) and mark "4 months" and "7 months". Alternatively, record that per-vessel durations are a display option, not part of the group.

### F2 Minor: reading `variation` with a regex fails open in one case and closed in others
Anchor: `packages/cv-workflow/cv_workflow/contracts.py:120`
- **Fails open:** with a space before the colon (`variation : "x"`), the regex finds nothing, so the check assumes the default. I believe this is valid Typst but did not compile it.
- **Fails closed (wrong refusals, all probed):** `layout-variation: auto`, copy text containing `variation: a`, and `variation: none` (a valid Flagship call meaning the default) are all refused.
- **Impact:** none today, since only `showcase` exists and Flagship asserts the name. It becomes live when Essential (TASK-67) lands.
- **Fix:** use `(?<![-\w])variation\s*:\s*`, treat `none` as the default, and add a test case for each.

### F3 Minor: a malformed `variation` in `envelope.json` crashes the render
Anchor: `contracts.py:117-118`
- **What happens:** `"variation": ["x"]` raises `TypeError: unhashable type: 'list'` (probed). The CLI shows a Python error instead of a `REFUSED` line with exit 2. `outputs.envelope()` validates only alias, domain, candidate and rank.
- **Fix:** refuse a `template` or `variation` that is not a string, inside choose().

### F4 Minor: no evidence that existing records were checked for `contacts`
Anchor: P-0019 §8 ("`contacts` becoming required is checked against every existing record when this is applied")
- **What happens:** no such check is recorded. I ran the contract over the 4 example records and all pass. I did not read `private/`. A real record without contacts would be refused on its next render.
- **Fix:** run the group check over `private/*/candidate.json` and record only the count in the task notes.

### N1 Note: the fixture name pattern is out of date
The glossary's `Coverage Fixture` code name and the module map in `docs/architecture.md` give `coverage-v<N>.json` and miss the `-contracts` fixture. The glob `coverage-v{version}*.json` (`tests/coverage.py:66`) would also pick up a future `coverage-v10*` fixture when checking version 1.

### N2 Note: the suite does not schema-check the fixtures
The suite never validates the fixtures against `candidate.schema.json`, and the path-resolution test reads only `coverage-v1.json`. Both fixtures do validate today (I checked).

### N3 Note: the `image` marker counts any raster image
It is sound today because the portrait is the only raster image; all marine artwork is SVG, and the rerun PDFs each have 1 image. Adding a raster asset would let a dropped portrait pass.

### N4 Note: the context files need their own reviewer
This change also edits the agent context: constitution §1, the ADR status, the glossary, the guides, the `new-cv` skill and the Workflow Model. `docs/review.md` requires a `context-reviewer` for those as well; this report covers the code.

### N5 Note: two choices pass without a warning
- In a custom composition, an `envelope.json` `variation` is silently ignored.
- `show-vessel-durations: false` in a client's entry point is not listed under `dropped`.

## Checks rerun
`C:\Github\cvgen\.venv\Scripts\python.exe tests/run.py` on `5db3362`: exit 0, PASS, 203 cases. Evidence is in `C:\Github\cvgen\.worktrees\template-contract\builds\tests-20261108-105010-900691`, including `coverage/` (7 of 7 optional groups, no warnings, for both fixtures).

I also ran three read-only probe scripts, kept in my scratchpad: choose() edge cases, the contract checked against the example records, and the fixtures checked against the schema.

## Evidence inspected
All at `5db3362`:
- Code: `packages/cv-workflow/cv_workflow/contracts.py`, `render.py`, `outputs.py` (`stamp`, `envelope`), `approve.py`, `output.schema.json`; `scripts/cv.py`
- Contracts and fixtures: `packages/cv-framework/contracts/base-v1.json`; `packages/domains/marine/contracts/v1.json`; both fixtures and their markers; `data.typ`; both schemas
- Flagship: `flagship.typ`, `template.json`, `tests/coverage.typ`
- Tests: `tests/coverage.py`, `tests/run.py`, `tests/workflow.py`
- Docs: ADR 0016, P-0019, `docs/engine/template-contract.md`, the doc diffs
- The author's evidence folder `builds/tests-20261104-235751-345947` (its `report.json` and the coverage PDFs)

## Limitations
- I did not compile Typst probes, so the claim that `variation : "x"` is valid Typst (F2) is unverified.
- I did not read `private/` (F4).
- The doc changes were read for consistency with the code only.

## Verdict: PASS
There are no Blocking or Material findings. F1 to F4 are Minor: fix each or record a reason to defer.
