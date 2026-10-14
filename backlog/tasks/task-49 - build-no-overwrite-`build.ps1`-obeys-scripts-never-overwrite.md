---
id: TASK-49
title: 'build-no-overwrite: `build.ps1` obeys "scripts never overwrite"'
status: Active
assignee: []
created_date: '2026-10-14 04:48'
updated_date: '2026-10-14 06:52'
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
- [x] #5 python tests/run.py PASS and python scripts/outputs.py check clean; Atlas check --strict exit 0; no Release PDF in examples/ changed
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

Atlas: facts for build.ps1 and the suite updated (site.json, system-map), shifted line ranges fixed (new-cv SKILL +2, preferences +1); all five pages stamped, system-map last; check --strict exit 0.

## Review round 1 follow-up (after merging origin/main with TASK-48)

- m1: `.github/workflows/verify.yml` uploads `builds/ci/build-script/*.log` on both runners.
- m2: TASK-48 wording made true after the merge: verify.yml comments (the suite drives build.ps1 on both runners; the Windows step builds every example in examples/release.json on the checkout), docs/reference/verification.md (CI paragraph; "every listed example"), docs/tech-stack.md (Build and CI rows).
- N3: docs/pdf-workflow.md says one existing Release makes -Release refuse the whole run.
- N4: build.ps1 refuses a list with no `examples` key, an empty array or an entry lacking source/title/variant ("examples/release.json needs an \"examples\" array ... Nothing was built or written."); suite case build-script-<shell>-malformed-list-refused. Mutation: guard disabled -> `AssertionError: 0 CVs created in builds/malformed`.
- Walk (copy under builds/t49-walk2, pwsh 7.6.6 and 5.1.26100): misspelt key, empty array, entry without title each throw that message with no output folder; the restored list builds 5 CVs.
- Suite on the merged head: PASS 109, builds/tests-20261014-094030-541892; outputs check 19 indexed, 0 problems.

## Review rounds 2 (code) and 3 (context 1) follow-up

Both PASS; reports in docs/work/build-no-overwrite/reviews/. Fixed: second malformed case (an entry without title; mutation removing the field check -> AssertionError ('no-title', '1 CVs created ...')); key-check comment simplified; README count from examples/release.json; AGENTS.md repeats trimmed; refusal text 'with it, run ./scripts/build.ps1 -ReplaceRelease'; new-theme restores 'and its assertions in tests/run.py'; verify-cv rewrapped with a pointer to docs/preferences.md.
<!-- SECTION:NOTES:END -->
