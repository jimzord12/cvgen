## Review round 1 (code): code-reviewer, 2026-10-14

Snapshot: `dbc11bd..613c37d` (8 commits). Lenses: 1 nothing broke for a real person; 8 links and the rest of the tree.

Verdict: FINDINGS. Recorded in substance (formatting condensed; the owner's review counts kept, no client named).

Coverage: app starts, `Output Contract` works, examples compile; lib.typ modules add no name collisions, no private entry point uses `lib.typ: *`; baseline hashes unchanged, frozen reference pixel-equal; CONCEPTS home consistent across outputs.py, Meta Files and the test; private files mention old paths only in comments and prose.

Material
- F1 `apps/design-review/server.py:52` (`id=rel`), `:271`: the owner's `.local/design-review/state.json` keys reviews by repo-relative path; 14 of 24 `design-concepts/...` entries point at PDFs now under `studio/design-concepts/`; their 6 keep, 7 maybe and 3 stars stay in the file but the Board shows them unreviewed and the export lists them under "Not in this index". Fix: migrate legacy keys on load; a test case with a legacy key in `tests/design_review.py`.
- F2 `.claude/repo-maintenance.md:38,:59` still `"archive/**"`; `audit.py` anchors globs at the root, so `studio/archive/design-studies/...` is no longer protected; the audit could propose moving frozen, baseline-pinned studies. Fix: repoint both.

Minor
- F3 `.claude/skills/new-theme/SKILL.md:30,:41`: does not say to register a new theme in `templates/flagship/themes.typ` or a pack in `artwork.typ` for the one-import modules.
- F4 `docs/conventions.md:93-99` vs `docs/workflow/GAPS.md`: the only file breaking the new naming table.

Notes
- N1 `studio/archive/work-records/` (code and process reviews) under a folder named for design work reads oddly; the owner's TASK-52 words were "Move to archive/". Preferred: `studio/` for brand, design-concepts, design-studies, anti-examples; a top-level `archive/` holding only the work records (also within the limit).
- N2 Git paired the byte-identical v11 renders with the README v12 images (R100 both ways); `git log --follow` on the frozen render shows the README image's history.

Checks rerun: suite exit 0, 142 cases, exact_reference raster and text equal (builds/tests-20261014-124715-592168); `outputs.py check` 19 PDFs 0 problems; Atlas 5 pages ok; Design Review app on 8791: `/` 200, `/api/items` 19 items, 0 unindexed; 4 concepts, intake-header, deck-cadet compile; audit.py glob test. Limitations: ruff not rerun; 4 of 14 concept entry points compiled.

## Dispositions (lead)

- F1: fix: on load, a legacy `design-concepts/` key maps to its new path when the new key is absent, in memory; the file is rewritten only by the owner's next save (no write on load); a test with a legacy key.
- F2: fix (`studio/archive/**`, and keep `archive/**` for the work records per N1).
- F3: fix. F4: list `docs/workflow/GAPS.md` as an exception (temporary; it goes with TASK-43), no rename (TASK-38 edits it in parallel).
- N1: adopted: `archive/work-records/` stays top-level where TASK-52 put it; `studio/` holds brand, design-concepts and `studio/archive/` (design-studies, anti-examples). This also keeps TASK-38's report path valid.
- N2: accepted; recorded in the task notes.
