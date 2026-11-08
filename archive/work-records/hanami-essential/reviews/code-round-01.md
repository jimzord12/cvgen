# Review round 1: TASK-79 (hanami-essential)

**Snapshot:** worktree `C:\Github\cvgen\.worktrees\hanami-essential`, head 062cd0b. I reviewed `git diff feat/travel-contract-v2...062cd0b` (54 files). `git diff f5365de 062cd0b --stat` gives the same totals, so the merge brought in nothing beyond the delta.
**Lead lenses:** (3) data and document integrity, with loud failure (6); and the render-path change in render.py (6 and 2).

**Coverage:**
1. Wiring: OK. The example, release.json, layout check against the manifest's `layouts`, and cv.py printing via `result['warnings']` all reach the change.
2. Correctness: OK. I probed an older role still held ("06/2005 – present"), equal start months, a full rail with Education in the column (5 earlier roles), and no Education.
3. Integrity: OK. Every role is either in full or on its own summary line. The span is earliest start to latest end; service time is never summed. Totals come from `experience-totals` and `destination-totals`. Trips, languages and licences are all printed or fail loudly. Only travel-story is dropped, and it warns.
4. Contracts and privacy: OK. `exactly: [2]` is enforced by `choose` and tested. The fixtures are fictional (example.com, 000 numbers, disclosures).
5. Tests: one gap, F3.
6. Failure handling: OK, with F1, F2 and N1.
7. Simplicity: OK. Totals live in the domain and the layout lives in the template.
8. Repository and docs: OK. LF endings, ruff clean, docs match the code. The Frozen Reference candidate is clearly marked as not yet approved by the owner.

## Findings

### F1 Minor: an overflow can blame the wrong part
Anchor: `packages/domains/travel/templates/hanami/essential.typ:96,108`
- **Scenario:** a seasonal career of 37 roles (my probe: newest role plus 36 short roles). The newest role fits easily alone, but its summary of 36 lines does not. A long Education list kept in the column, because the rail is full, does the same.
- **Expected:** the error names the real cause (the earlier-roles summary or Education).
- **Actual:** "even the newest role alone overflows the career column; shorten its bullets or its support cases".
- **Impact:** the failure is still loud, but the operator is told to fix the wrong thing. Seasonal tourism careers are a realistic way to hit this.
- **Fix:** when `k == none`, measure `career(ctx, d, 1, false, least)` against `H` and pick the message from that.

### F2 Minor: `cv.py status` drops the template warnings
Anchor: `packages/cv-workflow/cv_workflow/__init__.py:28`, `scripts/cv.py:102`
- **Scenario:** a thin essential revision is rendered, and later someone runs `cv.py status` before approving it.
- **Expected:** status lists the warnings recorded in checks.json, as it already does for certificate warnings.
- **Actual:** status reads only `certificate_summary`, so `template_warnings` appears only once, at render time.
- **Fix:** append `checks.get('template_warnings', [])` to `warnings`, guarded to a list of strings the way `certificate_summary` guards its block.

### F3 Minor: the render-path wiring and two loud failures are untested
Anchor: `tests/run.py:473-478`, `tests/workflow.py:324-326`
- **What is tested:** run.py calls `template_warnings` directly. workflow.py proves marine adds no warning (it expects exactly 3).
- **What is not tested:**
  - that `render_revision` writes `checks.json['template_warnings']`, prints `WARNING` and leaves `passed` true for a thin essential workspace;
  - the "could not be read" path;
  - the rail-overflow and profile-row-overflow assertions (`essential.typ:88,98`).
- I probed both overflow assertions and they fire. Deleting line 210 of render.py would still pass the suite.
- **Fix:** add one sparse essential workspace render to workflow.py, plus two `compile_case` error cases.

### N1 Note: `template_warnings` robustness
Anchor: `packages/cv-workflow/cv_workflow/render.py:238-243`
- `command[2:-2]` ties the function to the compile command's shape.
- `json.loads` is unguarded. A parse error would abort after `cv.pdf` is written and before `checks.json` is.
- I confirmed on 0.15.1: eval's default output is JSON, a failed eval returns the warning text, and marine returns `[]`. A missing binary raises `FileNotFoundError`, but that cannot happen right after a successful compile.
- Each render now compiles twice.
- Optional: build the flags explicitly and catch `ValueError` into the same warning.

### N2 Note: Typst does not refuse a version 1 record
The refusal of a version 1 record lives only in `choose` (the cv.py path). A Typst-only compile (`build.ps1`) would render a version 1 record in essential without refusing it. This matches ADR 0016's split and is not a defect.

## Checks rerun
- `C:\Github\cvgen\.venv\Scripts\python.exe tests/run.py`: exit 0, "PASS: 264", 25/25 workflow checks; evidence in `builds/tests-20261108-140237-649135`.
- `ruff check packages/cv-workflow tests scripts`: clean.
- Probe compiles in `builds/review-probe-20261108-140449/`:
  - many trips: rail-overflow error
  - long profile: profile-row-overflow error
  - 37 roles: F1
  - older role still held, equal start months, full rail with Education, no Education: each renders 1 page with a correct summary
- Direct `template_warnings` calls: marine `[]`; sparse "36% filled"; missing entry returns the warning.

## Evidence inspected
All at 062cd0b:
- `packages/cv-workflow/cv_workflow/render.py`, `__init__.py`, `scripts/cv.py`
- `packages/domains/travel/data.typ`, `domain.typ`, `lib.typ`, `templates/hanami/{hanami,essential,layouts,copy}.typ`, `components/essential.typ`, `components/hero.typ`, `layouts/essential.typ`, `template.json`, `contracts/v2.json`, `schema/candidate.schema.json`
- `tests/run.py`, `tests/coverage.py`, `tests/workflow.py`, `tests/fixtures/{travel-essential.typ,tour-leader-long-career.json,tour-leader-sparse.json}`
- Docs diff (`template-contract.md`, `verification.md`, `architecture.md`, `build-a-cv.md`, `glossary.md`)
- Raster images of the Frozen Reference candidate and the long-career, sparse and Greek PDFs
- Author report `builds/tests-20261108-140047-075375/report.json`: passed, essential reference matches raster and text

## Limitations
- The probe source files were written under `builds/review-probe-*/`, which is ignored; Typst needs the repository as its root, so they could not go elsewhere.
- Design quality is outside this round (separate design reviews).
- I did not run an end-to-end `cv.py render` on an essential `Envelope`, because that needs a workspace under `private/`.

## Verdict: PASS
No Blocking or Material findings. F1, F2 and F3 are Minor: fix them or record a reason to defer.
