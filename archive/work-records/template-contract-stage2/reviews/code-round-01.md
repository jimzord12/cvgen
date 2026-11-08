# Review round 1: TASK-68

Snapshot: worktree `C:\Github\cvgen\.worktrees\contract-stage-2`, branch `feat/contract-stage-2`, base 55811be, head c1a5761 (HEAD confirmed, tree clean).
Lead lenses: (1) how the section 6 table maps to `compare()`/`worst()`/`judge()`; (2) regressions in Stage 1 `choose()`/`coverage()` and in the schema change.
Coverage:
1. Product fit and wiring: `render.py:121-123` reaches `choose`. `cv.py contracts` works (exit 0, text and `--json`).
2. Correctness: every row of the table and the combined cases checked; one defect (M1), plus edge cases m2 and N1.
3. Data integrity: M1 writes a wrong `dropped` entry into the `Meta File`.
4. Contracts: the Flagship schema accepts and refuses exactly what it did before; the facts schema now accepts `copy` (N2).
5. Tests: the table rows are well pinned; M1 and m3 have no test.
6. Failure handling: a broken contract makes `cv.py contracts` exit 2; errors name the fix.
7. Simplicity: the code stays in `contracts.py`; acceptable.
8. Repository and docs: ruff is clean and the Atlas/workflow anchors match `cv.py`; the ADR body is stale (m4).

## Findings
### M1 Material: a required group that became optional is reported as dropped although the Variation renders it
Anchor: `packages/cv-workflow/cv_workflow/contracts.py:186-189` (`check_groups` against the record's version, with `claimed` holding only optional claims); `compatibility()` at line 319.
Scenario: v1 has `rank` required, v2 has it optional; the Variation is `upTo 1`; a v2 record holds `rank`. I reproduced this on synthetic contracts in a temp folder.
Expected: one warning, "rank became optional", and nothing dropped. The Variation renders `rank`, because a group that was required at its last version is always rendered and the suite proves it.
Actual: `dropped: ['rank']`, plus the warning "card a does not show rank: this CV leaves those facts out". `compatibility()` also undercounts coverage ("0 of 2" where `rank` is shown).
Impact: the `Meta File` records a fact as dropped that is printed, and the owner gets a false warning. This breaks the rule "extra data the Variation drops is a warning".
Fix: in the behind path, treat the groups required in contract `last` as claimed when computing `dropped`, and do the same in `compatibility()`. Add a `pick()` case to `tests/compatibility.py`.

### m2 Minor: a version missing from an `exactly` list renders through `compare`
Anchor: `contracts.py:190-197`.
Scenario: the Variation declares `exactly [1, 3]`; a record on v2 is compared with v1 and renders with warnings. The message says "supports … up to version 1", although the Variation supports 3.
Impact: the author's deliberate exclusion of v2 is overridden, and the wording misleads. The proposal's "newer version" can be read either way, and the manual documents what the code does.
Fix: refuse a version below the highest declared one that the list does not name, or reword the message and record the rule.

### m3 Minor: no test that Flagship still refuses a bad `copy` key
Anchor: `tests/run.py:130-140`.
`copy` is now closed only by the Template schema's own `properties`, next to its `$ref` to a facts schema whose `copy` is open. My probe shows it works: `'brnad' was unexpected` and `copy/brand: 5 is not of type 'string'`. But no test would catch a regression.
Fix: add one negative `validate_record` case.

### m4 Minor: ADR 0016's body is stale
Anchor: `docs/decisions/0016-template-contract.md:43-45` ("built when a contract first reaches version 2") and `:53-55` ("go when Stage 1 reaches them"). The TASK-68 description has the same wording. Stage 2 was built while marine is still at v1.
Fix: align the wording, or record the timing change.

### N1 Note: `compare` ignores the claimed schema versions
`compare` ignores which schema versions the Variation claims. If a Variation claims `places@1` and `places@2` but declares `exactly [1]`, a v2 record that holds `places` is refused even though the Variation renders that shape. A claim at a schema version that no declared version has is also never proved by coverage.

### N2 Note: the facts schema now accepts any `copy` object
An entry point that resolves to `candidate.schema.json` (no `lib.typ`, no Template) now accepts any `copy` object, misspelt keys included, without a warning. This is documented in `candidate-schema.md:136-137`.

### N3 Note: finding texts can name the wrong version
Across a gap of several versions, the texts give the newest version as where a change happened (for example "became optional in version 3" when it happened in 2).

### N4 Note: `registry()` import and scanning
`registry()` imports `referencing` outside the `ImportError` guard in `validate.py:74-77`, and it rescans every schema on each validation.

## Checks rerun
- `tests/compatibility.py::run_compatibility` with the project venv, against c1a5761: exit 0, all 6 checks pass. Output in `C:\Github\cvgen\.worktrees\contract-stage-2\builds\review-task68-r1-20261108-122359\compatibility\`.
- `python scripts/cv.py contracts` and `--json`: exit 0, "flagship showcase on marine: renders version 1, newest 1; 7 of 7 optional groups at version 1".
- `ruff check` on the six changed Python files: passed.
- Two read-only probes: the M1, m2 and N1 cases on synthetic contracts in a temp folder, and `validate_record` on schema cases (old vs new acceptance). Scripts in `C:\Users\jimzord12\AppData\Local\Temp\claude\0bad7b43ffb974fe\bd07fd7a-826f-4da0-ace1-f4e996f70146\scratchpad\`.
- Old vs new schema comparison: the old Flagship schema was exactly the old facts schema plus a closed `copy`; the new pair gives the same set for Flagship.

## Evidence inspected
- `git diff 55811be c1a5761` (all 19 files).
- `docs/proposals/template-contract.md` sections 4-8 and Decisions; `docs/review.md`.
- `render.py:110-123`, `output.schema.json`, `tests/coverage.py`, `tests/run.py:80-170`, `packages/domains/marine/contracts/v1.json`, `template.json`.
- Author suite reports `builds/tests-20261108-121745-788832` and `builds/tests-20261108-122012-137032`: both 211 cases, passed. Neither records its commit, so I cannot confirm the second is the run on c1a5761.

## Limitations
- I did not rerun the full suite. Stage 1 render paths rest on the author's runs plus the focused checks above.
- There is no real v2 contract, so Stage 2 is proved only on synthetic data.

## Verdict: FINDINGS
