---
id: TASK-83
title: >-
  portrait-prep: prepare client portraits - background removed, face centred or
  a little high
status: Done
assignee: []
created_date: '2026-11-08T15:36:00Z'
updated_date: '2026-11-08T15:53:00Z'
labels: []
milestone: m-8
dependencies: []
ordinal: 83000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Owner: Claude Code session (lead)
Branch/worktree: feat/portrait-prep in .worktrees/portrait-prep
Integration target: main
Depends on: none

## Outcome and boundaries
Owner, 2026-11-08: "remove the background from the profile image ... make sure when you are using an image the face in the center of the shape or just a tiny bit higher if that way it looks better." scripts/portrait.py prepares a portrait for any template: one face found, a square crop with the face centred and a little high, the background removed, colours in sRGB, a sidecar as evidence. The rule reaches the design reviewer, the magazine-editor and the component contract. Excludes changing any existing Frozen Reference portrait.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 A prepared portrait has its face within 2% of the target and a transparent background (tests/portrait.py)
- [x] #2 Every refusal is loud and writes nothing; a failed check after writing exits with its own code
- [x] #3 Designers and reviewers carry the rule (design-reviewer, magazine-editor, conventions)
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## Result and evidence
- Code head 8ab61de (the merge of main into feat/portrait-prep; the round 2 fixes are b9e1812).
- Suite: python tests/run.py, exit 0, "PASS: 265 compilation cases", 8 portrait cases ran, none skipped. Evidence: builds/tests-20261108-174340-234481
- ruff check: All checks passed. Workflow Model: check (levels 1 and 2), render --check and atlas --check OK; anchors fixed against main and the edited ranges reread by hand. Atlas: all five pages ok after restamp and build.
- Before and after of the fictional portrait: builds/portrait-before-after-20261108-171151/comparison.png

## Review
- Round 1, code-reviewer: FINDINGS (archive/work-records/portrait-prep/reviews/code-round-01.md). F1 Material, ICC profile dropped: fixed, converted to sRGB at load, recorded, output tagged sRGB, tested with a built profile. F2 a bad cut-out exited 0: fixed, the result is checked and a failure is loud. F3 --replace could overwrite any same-stem JSON: fixed, only the tool's own output. F4 refusal tests incomplete: fixed, every refusal fingerprints its folder, close-up fixture added. N1 no CI model cache: fixed, actions/cache v6.1.0.
- Round 1, context-reviewer: FINDINGS (context-round-01.md). Material 1-4 (rule in design-reviewer, magazine-editor and conventions; stale portrait.jpg examples and schema note; AGENTS.md, architecture and Atlas maps; tech-stack points to the rule): all fixed. Minor 5-7 and the Note (look-before-the-round moved to the 05-design judgement): fixed.
- Round 2, code-reviewer: PASS (code-round-02.md). R2-1 exit 2 shared with argparse: fixed, check failure exits 3, usage errors exit 1. R2-2 grey profiles refused: fixed, converted, any refusal names the profile. N2 off-target untested: fixed, check_result tested on real detections. N3 partial write: fixed, .partial files renamed into place, sidecar last, recovery in the message. N4: the new-cv skill and design.fill-data say "exit 3: look before rendering"; --keep-background kept, documented as for checking a crop only.
- Round 2, context-reviewer: PASS (context-round-02.md). Minor: concepts README sentence fixed and rewrapped.
- Major decisions (agent's): YuNet vendored in cv_workflow/models/ over a Haar cascade, OpenCV pinned to 4.13; birefnet-portrait (about 930 MB, ~/.rembg) as the default model, u2netp in the suite; face target 50% across, 45% down, face box 45% of the side, calibrated on the fictional engineer portrait; minimum 600 px, never upscaled; --face-y (0.40-0.50) as the one way to move the face; exit codes 0 written and checked, 1 refused or usage error, 3 written but look; a hand-built ICC profile in the test.

- Round 3 (2a8300b): code PASS, R3-1 Minor (a failed rename left .partial files and a raw traceback), N3-1 Note (no fsync, accepted); context PASS, 1 Minor, 3 Notes. Fixed by the lead in the next commit: the write wraps the renames, removes any .partial file and raises a WorkflowError saying whether the portrait was already replaced (lead-checked, no automated test for a locked file); the guide's exit-1 bracket sits on the refusal; the new-cv skill rewrapped and now names travel's Hanami beside the Flagship. Suite PASS after it: builds/tests-20261108-175034-198447 (265 cases), ruff clean, Workflow Model and Atlas checks clean.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
scripts/portrait.py prepares any client portrait: one face found, a square crop with the face centred and a little high (--face-y), the background removed with rembg, colours converted to sRGB, a sidecar as evidence; refusals exit 1 with nothing written, a failed result check exits 3. The owner's rule reaches the design reviewer, the magazine-editor and the component contract. Reviewed over three code and three context rounds; merged to main.
<!-- SECTION:FINAL_SUMMARY:END -->
