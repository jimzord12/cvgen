## Review round 1: code-reviewer, 2026-10-14

Snapshot: `.worktrees/task-49`, head 2e5a3e8, `git diff 8d248f2..2e5a3e8`. Lead lenses: correctness at the seams; test quality.

Verdict: PASS. Recorded in substance (formatting condensed).

Coverage: build.ps1 and run.py both read examples/release.json; the engineer frozen-reference case still raster- and text-equal; the refusal check runs before Typst and before any folder is made; -ReplaceRelease with -HideVesselDurations refused early; a file appearing between check and copy makes File.Copy throw; no Release PDF in examples/ changed; outputs check 0 problems; the real build.ps1 runs under pwsh and Windows PowerShell 5.1; one shared list, small diff.

Findings
- m1 Minor: CI evidence omits the build-script logs (verify.yml:40-46 and TASK-48's version; tests/release.py:68, :83): `build-script/<shell>.log` is not uploaded and the reads-the-list assertion carries only stderr. Fix: upload builds/ci/build-script/*.log, or pass stdout+stderr.
- m2 Minor: conflicts with TASK-48 at merge: its verify.yml comments ("build.ps1 runs nowhere else in CI", "five examples"), verification.md ("the five built PDFs") and tech-stack.md lines 11/14 become wrong once the suite runs build.ps1 on both runners and the example count comes from the list. Fix: the branch merged second updates the wording.

Notes
- N1: the File.Copy second guard (build.ps1:57) has no test of its own (mutation forcing overwrite survives); only a race reaches it; acceptable defence in depth.
- N2: -ReplaceRelease can stop halfway (build.ps1:53-60); the Output Contract check catches the stale Meta File; git restores.
- N3: docs/pdf-workflow.md:210 "writes the Release only where none exists" can be read per file, but one existing Release makes -Release refuse everything; adding an example needs -ReplaceRelease (new-cv documents it). Optional wording fix.
- N4: a misspelled `examples` key gives build.ps1 an empty "Compilation failed: " before writing anything (build.ps1:24-25); a clearer message is optional.
- N5: tests/release.py:31 requires every *.typ under examples/ to be listed; the build-script test depends on tracked Release PDFs; constitution.md:45 and glossary.md:65 still true for a first write; a context-reviewer round is also required.

Checks rerun: suite exit 0, PASS 107, all 8 build-script cases and example-list passed (builds/tests-20261014-091749-682876); mutations in disposable copies: pre-check disabled -> caught (File.Copy threw, Release intact); copy overwrite forced -> survived (N1); atlas check --strict exit 0; outputs check exit 0.

Limitations: Linux path reasoned, not run; manual walk not repeated; no real -Release/-ReplaceRelease in examples/.

## Dispositions (lead)

- m1, m2, N3, N4: fix after TASK-48 merges (this branch merges second). N1, N2, N5 accepted. Context-reviewer round follows.
