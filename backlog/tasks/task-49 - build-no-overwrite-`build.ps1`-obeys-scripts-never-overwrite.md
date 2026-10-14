---
id: TASK-49
title: 'build-no-overwrite: `build.ps1` obeys "scripts never overwrite"'
status: Active
assignee: []
created_date: '2026-10-14 04:48'
updated_date: '2026-10-14 06:14'
labels:
  - restructure
dependencies: []
ordinal: 49000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
`Copy-Item -Force` at `scripts/build.ps1:39` contradicts constitution rule 2; one shared example list instead of two (`build.ps1` and `run.py`). Consider porting to the TypeScript tooling. Source: docs/work/workflow-model/handoff.md, section 4, item 17 (B. Restructure, from the 2026-10-04 audit). Created 2026-10-14 at the owner's request; not started.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 build.ps1 -Release refuses while any Release PDF exists beside its entry point: non-zero exit, a message naming the files and the owner-only -ReplaceRelease, nothing built, the PDF and Meta File byte-identical (suite case build-script-<shell>-release-refuses-to-overwrite, pwsh 7 and Windows PowerShell 5.1)
- [x] #2 -ReplaceRelease is the one documented way to replace the Release, named as the owner's go in docs/preferences.md, git-workflow.md and pdf-workflow.md; -Release still writes a Release where none exists
- [x] #3 examples/release.json is the one example list: build.ps1 builds exactly what it lists and tests/run.py compiles from it and fails when an entry point under examples/ is missing from it (suite cases example-list and build-script-<shell>-reads-the-list)
- [x] #4 At least one check is mutation-proved; manual walk of ./scripts/build.ps1, -Release and -ReplaceRelease in a disposable copy under builds/ (never the real examples/) under both shells, recorded in the notes
- [ ] #5 python tests/run.py PASS and python scripts/outputs.py check clean; Atlas check --strict exit 0; no Release PDF in examples/ changed
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
1. examples/release.json holds the list (source, title, variant). 2. build.ps1 reads it; -Release checks every target first and refuses if any exists unless -ReplaceRelease; File.Copy without overwrite as a second guard. 3. tests/release.py: examples() drift check used by run.py to compile the examples; run_build_script() drives build.ps1 under each PowerShell in a throwaway copy. 4. Docs, skills, Atlas.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Result and evidence

Design: `examples/release.json` is the one example list (source, title with the `Release` version, variant). `scripts/build.ps1` reads it; with `-Release` it first checks every target beside its entry point and, if any `Release` PDF exists, throws before building or writing anything ("Refused: the Release already exists (...). Replacing it needs the owner's explicit go (docs/preferences.md); with it he runs ./scripts/build.ps1 -ReplaceRelease. Nothing was built or written."). `-ReplaceRelease` (implies `-Release`) is the owner's switch; the copy itself is `[IO.File]::Copy(src, dst, overwrite=$ReplaceRelease)`, so even past the check nothing overwrites without it. A byte comparison was rejected: Typst embeds the compile time, so every rebuild differs (checked: two builds of deck-cadet differ only in CreationDate/ModDate). `tests/release.py`: `examples()` (run.py compiles the five examples from it; fails on an entry point missing from the list or a listed one that does not exist) and `run_build_script()` (the real build.ps1 under pwsh and, on Windows, Windows PowerShell 5.1, in a throwaway copy under the run's `build-script/`).

Suite: `python tests/run.py` PASS, 107 cases, evidence `builds/tests-20261014-091300-463690` (new: `example-list`, `build-script-{pwsh,powershell}-{reads-the-list,release-refuses-to-overwrite,first-release-written,replace-release-with-owners-go}`). `python scripts/outputs.py check`: 19 PDFs indexed, 0 problems. No PDF in `examples/` changed.

Mutation proofs (each restored after, hash-checked):
1. build.ps1 guard off (`if ($false)`, copy overwrite `$true`, i.e. the old `Copy-Item -Force` behaviour) -> `AssertionError: 1 CVs created in builds/refused ... Release written` (refusal case fails).
2. build.ps1 back to a hard-coded five-example list -> `AssertionError: build.ps1 ignored the list`.
3. `examples()` missing-entry assert removed -> `AssertionError: the suite accepted a list that leaves entry points out`.

Manual walk (disposable copies of packages/, examples/, scripts/build.ps1, scripts/outputs.py under `builds/t49-walk/repo` and `repo51`; never the real examples/):
- pwsh 7.6.6: `./scripts/build.ps1` -> "5 CVs created in builds/library-20261014-091000-053" (5 PDFs). `./scripts/build.ps1 -Release` -> throws the refusal naming all five PDFs; examples/ unchanged (10 files hash-equal), no new builds folder. `-ReplaceRelease -HideVesselDurations` -> "The Release shows vessel durations; drop -HideVesselDurations." `./scripts/build.ps1 -ReplaceRelease` -> 5 CVs built, "Release written ... stamped"; engineer.pdf and deck-cadet.pdf equal the new build; `python scripts/outputs.py check` in the copy -> 5 PDFs indexed, 0 problems; engineer Meta File title "Marine Engineer CV v12", status release, date 2026-10-14.
- Windows PowerShell 5.1.26100: same sequence (`builds/t49-walk/walk51.ps1`): 5 CVs; refusal with examples unchanged and 1 builds folder; `-ReplaceRelease` writes and stamps; outputs check 5 indexed, 0 problems.

Not done here, on purpose: porting build.ps1 to the TypeScript tooling (the task said "consider"; the smallest fix keeps PowerShell), and enforcing a raised version number on -ReplaceRelease (constitution section 2 asks for one; it stays a documented step in git-workflow.md "Releasing a new render"). Limitation: the build-script case was run here on Windows only; on CI (ubuntu) it runs under pwsh, which GitHub's ubuntu runners ship, and fails rather than skips if none is found.
<!-- SECTION:NOTES:END -->
