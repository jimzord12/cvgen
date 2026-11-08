# Review round 2: TASK-79 (hanami-essential)

**Snapshot:** worktree `C:\Github\cvgen\.worktrees\hanami-essential`, head 8f1ee01. I reviewed `git diff c0069b8..8f1ee01` (5eb12b7, c80f149, 8f1ee01): render.py, `__init__.py`, decoration.py, essential.typ, tests/run.py, tests/workflow.py, the fixture, Workflow Model anchors and the Atlas.
**Lead lenses:** (6) failure handling, focused on the decoration change; (5) tests.

**Coverage:**
1. Wiring: OK. `decoration_errors` has one production caller, render.py:196, and it now passes `choice.get('variation')`.
2. Correctness: OK. I traced the F1 cause logic for n = 1, for no Education, and for a rail with or without room. Each message is reached only for its real cause.
3. Integrity: OK. The `passed` flag is unchanged by warnings.
4. Contracts: OK. `choose` still cross-checks the envelope's Variation against cv.typ.
5. Tests: F1 and N3.
6. Failure handling: OK, with N1.
7. Simplicity: OK.
8. Repository and docs: F2 and N2. LF endings are fine, ruff is clean, and the anchors match the new line ranges.

**Round 1, point by point:**
- F1: fixed. essential.typ:108-116, covered by `summary-overflow`.
- F2: fixed, with the list-of-strings guard.
- F3: fixed. workflow.py section 13, the "could not be read" case, and the `rail-overflow`, `profile-overflow` and `summary-overflow` compile cases.
- N1: addressed. Explicit flags; `ValueError` and a non-list result become the warning.
- N2: no action needed.

**Lens 6, can showcase skip the petal check?** No, not today. For `template == 'hanami'`, `choose` always records a Variation: the envelope's, else the manifest default `showcase`. It refuses any mismatch with cv.typ. I probed `choose` directly:
- no variation, `variation: none`, `variation: "showcase"`, and an envelope saying showcase all give `'showcase'`;
- an envelope saying essential over a showcase entry is refused, and so is the reverse.

So production never passes `None`, and showcase is always checked. On the probe PDF, `decoration_errors` gives 2 errors with `'showcase'`, 2 with `None`, and 0 with `'essential'`. Essential draws no `petals-p*` layer: it calls neither `band-petals` nor the `petals-*-field` art.

## Findings

### F1 Minor: no test proves the petal check runs on the value production passes
Anchor: `tests/run.py:419`, `tests/run.py:361`
- **Scenario:** a regression that skips every named Variation, for example `PETAL_VARIATIONS = {'hanami': set()}` or a condition reduced to `variation is not None`.
- **Expected:** the suite fails.
- **Actual:** I ran the regression in-process with a monkeypatch; no source was edited. run.py:355, :361 and :419 all still hold, and the probe through `'showcase'` returns `[]`.
  - :361 tests only `variation=None`, which render.py never passes.
  - :419's `decoration_errors(twin, 'hanami', 'showcase') == []` cannot fail, because the twin has no collisions.
  - workflow.py renders only essential through cv.py.
- **Impact:** petals over words in a showcase client revision could pass checks unnoticed.
- **Fix:** add `assert len(decoration_errors(probe, 'hanami', 'showcase')) == 2`, beside or instead of the twin clause.

### F2 Minor: two places still say the petal check runs on every Hanami render
Anchor: `docs/framework-gaps.md:138`, `packages/cv-workflow/cv_workflow/decoration.py:4`
- **Actual:**
  - The gap entry says the check runs "in every Hanami render through `scripts/cv.py`".
  - The module docstring says the petals are drawn "on every Hanami page".
- **Expected:** both say showcase only, since c80f149 (essential draws none).
- **Fix:** one sentence in each.

### N1 Note: the petal check is skipped for any Variation not on the list
`PETAL_VARIATIONS` lists the Variations to check. A future Hanami Variation that draws petals but is not added to the list skips the check silently. Listing the exempt Variations instead (`{'hanami': {'essential'}}`) would fail loudly, with false errors at its first test render. Optional.

### N2 Note: the task record has no code-review rounds yet
The task file lists only design rounds 1-2. Link code round 1, its dispositions, and the c80f149 bug the new test found. Code round 2 can be added the same way.

### N3 Note: two failure paths remain untested
The Education `panic` (essential.typ:115) and the `ValueError` / non-list branches of `template_warnings` (render.py:246-251) have no test. Both read correctly to me.

**Lens 5:**
- If render.py:210 is removed, workflow.py:525 fails (no note in `warnings`) and so does :529 (`KeyError`).
- If the status change is removed, :530's equality fails, since the sparse record has no certificate warnings.
- If the variation argument is dropped at render.py:196, section 13 gets the petal errors and fails, as the author's c80f149 shows.

## Checks rerun
- `C:\Github\cvgen\.venv\Scripts\python.exe tests/run.py`: exit 0, "PASS: 268 compilation cases", 25 workflow checks passed (including `thin-page-warns-only`). Evidence in `C:\Github\cvgen\.worktrees\hanami-essential\builds\tests-20261108-141216-475128`.
- `ruff check`: "All checks passed!"
- In-process probes (no files written): `choose` on the showcase and essential entry forms; `decoration_errors` on `travel-petal-probe.pdf` with each Variation value; the F1 monkeypatch simulation.

## Evidence inspected
All at 8f1ee01:
- `packages/cv-workflow/cv_workflow/{render,decoration,contracts,__init__}.py`, `scripts/cv.py`
- `packages/domains/travel/templates/hanami/{hanami,essential}.typ`, `components/{hero,essential}.typ`, `template.json`
- `tests/run.py`, `tests/workflow.py`, `tests/fixtures/travel-essential.typ`
- `docs/framework-gaps.md`, `docs/workflow/06-deliver/stage.yaml`, `docs/workflow/catalog.yaml`, the `.atlas` lock diff
- the TASK-79 record, round 1 report

## Limitations
- I did not run the suite with mutated source. The regression simulation was an in-process monkeypatch against the rerun's PDFs.
- I ran no `cv.py render` under `private/`.
- Design quality is outside this round.

## Verdict: PASS
No Blocking or Material findings. F1 and F2 are Minor: fix them or record a reason to defer.
