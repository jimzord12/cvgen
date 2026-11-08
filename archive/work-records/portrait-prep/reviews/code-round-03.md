# Review round 3: TASK-83 (portrait preparation tool)

**Verdict: PASS.** No Blocking or Material findings. There is one Minor finding and one Note. The merge lost nothing from main, and no conflict markers remain.

Snapshot: worktree `C:\Github\cvgen\.worktrees\portrait-prep`, head 2a8300b, tree clean. I reviewed the delta 0c23428..2a8300b: b9e1812, the merge 8ab61de (parents b9e1812 and bf8f0d7, merge base 8a684e7) and 2a8300b.
Lead lenses: 6 Failure handling; Merge integrity (lenses 3 and 8)
Coverage:
1. Wiring: the docs agree everywhere on `--output .../portrait.png` and on "exit 3: look at it before rendering": `new-cv/SKILL.md:29-31`, `client-workflow.md:74-92`, `05-design/stage.yaml:580-582` and `magazine-editor.md:185`. No portrait "exit 2" remains outside the archive. OK.
2. Correctness: the profile's colour space decides the source mode (GRAY to `L`, CMYK, otherwise RGB). Any other failure is refused with the profile's name. Subparsers inherit `Parser`, because argparse uses `type(self)`. Both usage-error paths are tested. **R2-2 resolved.**
3. Integrity: the sidecar hashes the `.partial` PNG, whose bytes are the ones renamed into place. The merge is in the section below.
4. Privacy: no change.
5. Tests: `check_result` is asserted on real detections. A prepared square passes; the raw photo is off target, with `placed` set and `passed` False; the no-face image gives `(None, False)`. The "always true" defect from N2 would now fail. The tests also cover the misspelt flag and `--face-y abc`, and assert that no `.partial` file is left. **N2 resolved.**
6. Failures: **R2-1 resolved:** exit 3 is used only for "written, check failed". **N3 resolved.** See R3-1 for the case where a rename itself fails.
7. Simplicity: everything stays in `cv_workflow/portrait.py`. OK.
8. Repository: ruff is clean. The task record matches the work. N4 is addressed in the skill and in `design.fill-data`.

**Lens 6, the renames.** Both `.partial` files sit next to their targets, written with `with_name`, so each `os.replace` stays on one filesystem.
- On Linux this is `rename(2)`, which is atomic.
- On Windows it is `MoveFileExW(REPLACE_EXISTING)` within one volume. Python documents it as atomic only on POSIX, but in practice a reader sees either the old file or the new one.

I probed a crash between the two renames by making the second `os.replace` raise. The result was a new PNG next to the old sidecar. A plain run then refused with "pass --replace", `--replace` refused with "...delete both files and run again", and after the deletion the run succeeded. So the state can be recovered, and the message says how.

**Merge integrity.**
- All 87 files that only main changed are byte-identical to bf8f0d7, including all of `packages/domains/travel/`, `tests/baseline.json`, `tests/coverage.py` and the TASK-82 report files.
- All 27 files that only the branch changed are identical to b9e1812.
- The merge touched no file that neither side had changed.
- 8 of the 16 files both sides changed merged cleanly and are identical to `git merge-tree` output.
- For the 8 that conflicted, I read every hunk. The resolutions keep main's content (the travel and Hanami gate text, glossary anchors) together with the branch's edits ("prepare the portrait", the portrait guide anchors).
- Against main, `verification.md` has 26 lines added and none removed.
- `git grep` found no conflict markers at 2a8300b, and `atlas.py check` shows all five pages "ok".

## Findings
### R3-1 Minor: a failed rename gives a traceback, leaves `.partial` files, and after the first rename breaks the exit-1 contract
Anchor: `packages/cv-workflow/cv_workflow/portrait.py:295-296`
- **Scenario:** on Windows, `prepare --replace` while a viewer has `portrait.png` open.
- **Probe:** exit 1 with a raw `PermissionError: [WinError 5] Access is denied: '.e-prepared.png.partial' -> 'e-prepared.png'`. The old pair stays intact and is still recognised as the tool's own output, but `.e-prepared.png.partial` and `.e-prepared.json.partial` are left behind.
- **Second-rename case:** when the second rename fails (a locked sidecar or a disk error), the run still exits 1, which is documented as "nothing written". But the PNG that `cv.typ` reads has already been replaced by a new, unrecorded file.
- **Visible leftovers:** on Windows, and in `private/<envelope>/images/portrait/`, the leftover `.partial` files are not hidden and could be committed to the private repository.
- **Impact:** low. This needs a lock or an I/O error, and the next run's refusal leads to recovery.
- **Fix:** wrap the save and the renames in `try/except OSError`.
  - Delete any `.partial` files that remain.
  - Raise a `WorkflowError` that names the file and says whether the PNG was already replaced, with the same "delete both files" recovery step.
  - Optionally, rename the sidecar first, so the PNG a CV renders is the last thing to change.

### N3-1 Note: no fsync before the rename
On Linux, a power loss can leave a renamed file empty. The hash check would then refuse it and print the recovery message, so this is acceptable. Recording it only.

## Checks rerun
- `C:\Github\cvgen\.venv\Scripts\python.exe tests/run.py` (in the worktree): exit 0. "PASS: 265 compilation cases..." All 8 `portrait:` cases ran, none were skipped, and no `.partial` files were left. Evidence: `C:\Github\cvgen\.worktrees\portrait-prep\builds\tests-20261108-174702-117563`
- `ruff check`: exit 0, "All checks passed!"
- `python .atlas/_kit/atlas.py check`: exit 0, all five pages ok.
- Probes for the crash and the lock, using a copy of the fictional engineer image: `C:\Github\cvgen\.worktrees\portrait-prep\builds\review-portrait-r3-20261108-174748\`. The probe script is outside the tree, in the session scratchpad.

## Evidence inspected
- At 2a8300b: `scripts/portrait.py`, `cv_workflow/portrait.py` (the load, check and write paths), `tests/portrait.py` (the helpers and new cases), `client-workflow.md:68-95` and the TASK-83 record.
- The diffs b9e1812 vs 0c23428, 8ab61de vs merge-tree `0971064`, 8ab61de vs bf8f0d7, and 8ab61de vs b9e1812.
- My round 2 report.

## Limitations
- The CMYK path was read, not run.
- I saw no CI run, so Linux behaviour comes from reasoning, not execution.
- The suite ran on Python 3.13.

## Verdict: PASS
