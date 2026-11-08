# Review round 1: portrait preparation tool (no task record yet)

Snapshot: worktree `C:\Github\cvgen\.worktrees\portrait-prep`, branch `feat/portrait-prep`, delta 8a684e7..b50bce7 (715e39c, b50bce7). The tree was clean at b50bce7.
Lead lenses: 3 Data integrity; 6+5 Failure handling and tests
Coverage:
1. Wiring: the CLI, `prepare_portrait` and the docs (client-workflow, build-a-cv, new-cv, the Workflow Model step) all point to the same path. OK.
2. Correctness: I traced the crop math. `side` is at most every edge limit, the clamp keeps the square inside the image, and the code only ever scales down. The face share is checked. OK.
3. Integrity: the source is never written to. On Windows the path comparison resolves the path and ignores case. The sidecar matches the files. EXIF (and so GPS) is stripped. Two problems: F1 and F3.
4. Privacy: everything runs locally and the default output sits beside the source inside `private/`. The tests use only fictional images. OK.
5. Tests: they exercise the real CLI and the real model. There are gaps: F4.
6. Failures: every refusal comes before any write. A wrong result after the file is written is not reported loudly: F2. On CI, the download path fails the run rather than skipping it.
7. Simplicity: `portrait` sits in cv_workflow, is not imported by the package, and its dependencies are in an extra. OK.
8. Repository: `.onnx` is marked binary, the model is in package-data, the YuNet licence is vendored, and the Atlas and Workflow Model checks pass. One Note: N1.

## Findings

### F1 Material: the default path drops the photo's embedded ICC colour profile
Anchor: `packages/cv-workflow/cv_workflow/portrait.py:145,198-202`
- Scenario: a client sends a phone JPEG tagged Display P3, which is common for iPhone exports.
- Actual: rembg's `naive_cutout` builds a new image (`Image.new` + `composite`), which loses `info['icc_profile']`. The PNG is saved without a profile, and the `--fill` path loses it too. `--keep-background` keeps it.
- Reproduced in `builds/review-portrait-20261108-172120/`: the source `icc.jpg` had a 588-byte profile, `icc-prepared.png` had 0 bytes, and `keep.png` kept all 588 bytes.
- Impact: Typst will read the P3 values as sRGB, so skin tones in the client's portrait shift quietly. The same photo also comes out differently depending on the flag.
- Expected: the output keeps the source's colours.
- Fix: convert to sRGB with `ImageCms` at `load_photo`, or carry the profile through to `save(icc_profile=...)`. Record which one in the sidecar, and add a test fixture with an embedded profile.

### F2 Minor: a bad cut-out still exits 0
Anchor: `portrait.py:205-206`, `scripts/portrait.py:45`
- Scenario: the model removes part of the face, or a second face appears after the cut. Detection then finds 0 or 2 faces, or a centre far from the target.
- Actual: the run writes `face_centre: null` and exits 0. The CLI prints "face centre at None".
- Expected: a loud warning, or a non-zero exit, when `faces_found != 1` or the centre is more than about 2% off target.
- Impact: in practice only the human look in the rendered circle (client-workflow) would catch it.

### F3 Minor: `--replace` can overwrite any JSON with the same stem
Anchor: `portrait.py:176,181-183`
- Scenario: `--output private/<env>/candidate.png`. The refusal message itself suggests "pass --replace". With `--replace`, `candidate.json` (the candidate record) is overwritten by the sidecar.
- Fix: with `--replace`, refuse an existing sidecar or PNG that this tool did not write (check `tool` in the existing JSON).

### F4 Minor: refusal tests do not check everything they claim
Anchor: `tests/portrait.py:82-97`; `docs/engine/verification.md` item 21
- "Writes nothing" is asserted only for no-face and two-faces.
- The source-as-output case does not check that `high-left.png` is unchanged.
- The existing-output case does not check that `high-left-prepared.png/.json` are unchanged.
- The `--fill` + `--keep-background` case does not check that `x.png`/`x.json` were not created.
- The listed refusal "face over 60% of the square" (`portrait.py:124-127`) has no test at all.
- Fix: record digests and check for absent paths around each refusal, and add a close-up fixture that asserts the "too close to the … edge" message.

### N1 Note: the CI model download has no cache
`verify.yml` has no cache for `~/.rembg`, so every CI run downloads u2netp from GitHub releases. pooch has a request timeout. A failure is loud: `tests/run.py` asserts when `CI` is set. An `actions/cache` keyed on the model name would cut out the flakes.

## Checks rerun
- `C:\Github\cvgen\.venv\Scripts\python.exe tests/run.py` in the worktree: exit 0, "225 compilation cases…". All 5 `portrait:` cases ran, background removal included, with nothing skipped. Evidence: `C:\Github\cvgen\.worktrees\portrait-prep\builds\tests-20261108-171931-179046`
- `ruff check`: exit 0, "All checks passed!"
- `bun run check`, `render --check`, `atlas --check` in `tools/workflow`: all OK.
- My F1 probe (fictional engineer image, u2netp and `--keep-background`): `builds\review-portrait-20261108-172120\`

## Evidence inspected
- At b50bce7: `portrait.py`, `scripts/portrait.py`, `tests/portrait.py`, the `tests/run.py` hunk, `pyproject.toml`, `requirements.lock` (uv `--universal` with sys_platform/python markers), `verify.yml`, and the doc diffs.
- The installed rembg 2.0.87: `bg.py` and `sessions/base.py`. Model home `~/.rembg/models` and `REMBG_HOME` match the docs.
- The author's `builds/portrait-before-after-20261108-171151/comparison.png` and its sidecars (birefnet-portrait). Placement looks right.

## Limitations
- The branch has no remote ref, so I saw no CI run. The lockfile's Linux install of onnxruntime 1.31.1, opencv 4.13 and numba is unverified: hashes do not show filenames, and I contacted no external systems.
- The local venv runs Python 3.13, not CI's 3.11.
- I did not check how large the F1 colour shift looks on a real P3 photo. The dropped profile itself is shown.
- The suite reused the u2netp model already cached under the user's home folder.

## Verdict: FINDINGS
