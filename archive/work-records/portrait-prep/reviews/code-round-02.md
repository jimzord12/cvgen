# Review round 2: portrait preparation tool (no task record yet)

Snapshot: worktree `C:\Github\cvgen\.worktrees\portrait-prep`, branch `feat/portrait-prep`, head 0c23428. I reviewed the delta b50bce7..0c23428 (code part). The tree was clean.
Lead lenses: 3 Integrity; 6+5 Failure handling and tests
Coverage:
1. Wiring: the CLI passes `--face-y` through. The client-workflow guide documents exit 2 and `--replace`. OK.
2. Correctness: `--face-y` changes only the vertical target and the `top`/`bottom` limits. NaN is refused, because comparisons with NaN are false. A grayscale photo that carries a grey profile is refused: R2-2.
3. Integrity: the conversion runs once, in `load_photo`. The profile is read before `exif_transpose`. RGB and CMYK go through `profileToProfile`, and alpha is put back. An untagged source is recorded as `converted_to: null`, and every output is tagged `sRGB built-in`. The sidecar records `crop.target.y`, `check`, `source.colour` and `output.profile` truthfully. Nothing misstates the source. **F1: resolved.**
4. Privacy: no change. OK.
5. Tests:
   - F1 test: it would fail without the conversion (the raw-vs-got gap must be above 30) and without the sRGB tag (the description is asserted).
   - F2 test: it would fail if the re-check were removed, because `returncode == 2` and `passed is False` are both asserted. Only the "two faces" branch is covered: N2.
   - **F4: resolved.** `refuses()` fingerprints the folder around every refusal. The close-up case reaches the `MAX_FACE_SHARE` message.
6. Failures: **F2 resolved.** The check fails loudly and both files are kept. Exit 2 is ambiguous: R2-1. **F3 resolved.** `written_by_tool` requires the tool name, the file name and the PNG hash. A missing sidecar, foreign JSON or an edited PNG is refused, and the test covers all three.
7. Simplicity: everything stays in `cv_workflow/portrait.py`. OK.
8. Repository: LF line endings and `git diff --check` are clean. **N1: resolved.** `actions/cache@55cc8345863c7cc4c66a329aec7e433d2d1c52a9` is the commit behind `refs/tags/v6.1.0`. I checked with `gh api repos/actions/cache/git/ref/tags/v6.1.0`, and v6.1.0 is also the latest release. The cache path `~/.rembg/models/u2netp` matches `model_dir()` in rembg 2.0.87 (`<home>/models/<name>/u2netp.onnx`), and that version is pinned in `requirements.lock`.

## Findings

### R2-1 Minor: exit 2 also means "usage error", and it inverts the repo's own exit-code convention
Anchor: `scripts/portrait.py:9-11,57-59`; argparse's default `parser.error`.
- **Scenario:** `prepare e.jpg --keep-background --repalce` after an earlier run. Probe: exit 2, `error: unrecognized arguments`, and the old `e-prepared.png` is still there. `--face-y abc` also exits 2.
- **Expected:** exit 2 means only "written, check failed", as the docstring and `client-workflow.md:86-88` say ("look at it before using it").
- **Actual:** argparse also uses exit 2 for usage errors, where nothing was written. An agent that follows the documented meaning would inspect the previous portrait as if it were the new one.
- **Also:** `cv.py` and `proposals.py` use exit 2 for "refused, nothing written". `gate.render-ok` in `06-deliver/README.md:177` uses the same meaning. This tool uses 1 for that and 2 for "written".
- **Impact:** low, because stderr names the cause. But the exit code alone, which is what a gate reads, is ambiguous.
- **Smallest fix:** use a code argparse never uses for the check failure (for example 3), or override `parser.error` to exit 1. Document the chosen code wherever exit 2 is mentioned now. This is the author's Major decision, so I raise it once with this evidence.

### R2-2 Minor: a photo tagged with a grey profile is refused with a misleading message
Anchor: `packages/cv-workflow/cv_workflow/portrait.py:89-90`
- **Scenario:** a black-and-white JPEG tagged with a Gray Gamma 2.2 profile, as editors such as Photoshop write.
- **What happens:** `base` is converted to RGB, then a GRAY-to-sRGB transform is built. The probe got exit 1: `bw-tagged.jpg is not an image Pillow can read in colour: cannot build transform`. The same image without the profile prepares fine.
- **Impact:** it fails loudly and nothing is written, but the message sends the user the wrong way.
- **Fix:** for `L`/`LA` sources, transform from `upright.convert('L')` with `outputMode='RGB'` when the profile's colour space is GRAY. At minimum, name the profile in the refusal.

### N2 Note: the off-target and no-face branches of the check are untested
Anchor: `portrait.py:255`, `tests/portrait.py:176-187`. If the tolerance comparison were broken (for example, always true when `placed` is set), every case would still pass. One crafted case would close this, for example a result whose face sits more than 2% off target. Otherwise, record the gap.

### N3 Note: a partial write locks out `--replace`
Anchor: `portrait.py:250,270`
- The PNG is written before the sidecar. If the run dies in between (the detector raises, or the disk is full), there is a new PNG with no sidecar, or an old sidecar whose hash does not match.
- After that, both a plain run and `--replace` refuse, so the file has to be deleted by hand. The refusal message does not say this.
- Optional fix: write the sidecar last to a temporary file and rename it, or mention the case in the message.

### N4 Note: nothing downstream reads `check.passed`
A kept CHECK FAILED `portrait.png` sits at the very path `cv.typ` reads. Only a reader of stderr stops it. This follows the author's "keep the files" decision. The context review may want the `new-cv` skill and the `design.fill-data` step to say "exit 2: look before rendering".

## Checks rerun
- `C:\Github\cvgen\.venv\Scripts\python.exe tests/run.py` in the worktree: exit 0. It reported "PASS: 228 compilation cases…". All 8 `portrait:` cases passed and none were skipped (rembg ran). Evidence: `C:\Github\cvgen\.worktrees\portrait-prep\builds\tests-20261108-173244-122624`
- `ruff check`: exit 0, "All checks passed!"
- My probes for R2-1 and R2-2 (fictional engineer image): `C:\Github\cvgen\.worktrees\portrait-prep\builds\review-portrait-r2-20261108-173446\`. The script itself is outside the tree, in the session scratchpad.

## Evidence inspected
At 0c23428:
- `packages/cv-workflow/cv_workflow/portrait.py`, `scripts/portrait.py`, `tests/portrait.py` and `.github/workflows/verify.yml`, read in full or in the changed regions;
- the `portrait` lines of `docs/guides/client-workflow.md:70-95`, `docs/engine/verification.md` item 21, `.claude/skills/new-cv/SKILL.md`, `.claude/agents/magazine-editor.md` and `docs/workflow/05-design/stage.yaml`;
- the sidecar the suite wrote for the exit-2 case;
- the round 1 report;
- in the venv: `rembg/sessions/base.py` and `u2netp.py`.

## Limitations
- The branch has no remote ref, so I saw no CI run. Whether ubuntu-24.04 sets `XDG_DATA_HOME`, which would send rembg to `$XDG_DATA_HOME/rembg` and make the cache miss, is unverified. A miss is harmless.
- I tested no real Display P3 or CMYK file. The CMYK path is read, not run.
- The local run is Python 3.13, not CI's 3.11.

## Verdict: PASS
F1–F4 and N1 are resolved. No Blocking or Material findings remain. R2-1 and R2-2 are Minor: fix them or record a reason to defer.
