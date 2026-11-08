# Review round 8: TASK-79

Snapshot: C:\Github\cvgen\.worktrees\hanami-essential, branch feat/hanami-essential, head b436a2d (clean tree). The delta is 1d9c75a..b436a2d, and the merge 78b498e has parents 9b60224 and c8b7480 (c8b7480 = main = origin/main).
Lead lenses: (3) integrity of the merge; (2) correctness of the R7-1 remedy and its test.
Coverage:
1. Wiring: the arc warning reaches `scripts/cv.py render` through `template_warnings`. The portrait tests from main run in the suite.
2. Correctness: `name-binds` compares the same two measures that set `left`, so the cause it names is always the element that set the room. See N-1 for one edge.
3. Integrity:
   - `git merge-tree` of the two parents differs from 78b498e only in the 9 conflicted files.
   - Outside source anchors, the Workflow Model gained only main's portrait content, and the branch's Variation content is kept.
   - system-map.json keeps both sides: main's n-portrait node and client-workflow ranges, and the branch's travel node and build-a-cv ranges.
   - The six hand-fixed anchors cite the right lines (render.py:102-215, 192-211, 212-215; __init__.py:14-35; cv.py:30-41; build-a-cv.md:1-131, 15-82, 55-82).
   - All 63 pins in tests/baseline.json match, both on disk and as blobs, and the baseline equals main's. No PDF, PNG or `tests/approved` file changes in the delta.
4. Contracts: the record, schema and envelope contract are unchanged. The fixture rename keeps the record fictional.
5. Tests: R7-2's count assert and R7-1's per-case cause assert would both fail if the cause were inverted or fixed to one value (N-2).
6. Failure handling: the warning now gives the right remedy for each cause.
7. Simplicity: one comparison was added in the owning component.
8. Repository and docs: see R8-1, R8-2 and R8-3. LF line endings; `git diff --check` is clean.

## Findings
### R8-1 Minor: two Atlas pages are STALE at the head
Anchor: .atlas/atlas.lock.json (tests/run.py f7ee683); docs/development.md:122-124
- **Scenario:** 330f0f5 changed tests/run.py (blob b9ee76b) after the restamp in 78b498e.
- **Actual:** `atlas.py check` prints "STALE system-map tests/run.py" and "STALE roster tests/run.py". The author's "all five ok" holds at 78b498e, not at b436a2d. atlas.data.js matches the page sources.
- **Impact:** the two pages show an amber banner.
- **Fix:** re-check both pages against the one-word assertion change, then stamp and rebuild them.

### R8-2 Minor: two descriptions of the arc warning are stale after R7-1
Anchor: docs/engine/verification.md:112-113 ("a warning saying what to change"); task note line 90 ("the arc warning says what to change")
- **Actual:** for `plain-long-name` the warning now says nothing needs changing.
- **Fix:** "a warning naming what binds: the rank row, with what to cut, or a long name, which needs nothing".

### R8-3 Minor: the task record does not link code rounds 4-7 or give their dispositions
Anchor: backlog/tasks/task-79*.md notes; docs/review.md ("links it from the task record with its dispositions")
- **Actual:**
  - The notes cover code rounds 1-3 only.
  - There is no entry for the R7 fixes, the merge or the fixture rename.
  - "Depends on TASK-83 merging into main first" is now satisfied but still reads as open.
- **Fix:** add one entry covering these before the task leaves Active.

### N Notes
- **N-1:** if both the rank row and the name are over about 123 mm (no portrait), the rank row is named first. Shortening it then only flips the warning to the name message: one extra render. This is rare.
- **N-2:** the test checks the cause prefix, not the remedy text after it.
- **N-3:** tests/fixtures/portraits/provenance.json still says "not yet on main". That is now history.
- **N-4:** `bun run anchors 9b60224` reports two items, both main's own anchors:
  - SKILL.md:85-86 is the false positive the README describes; lines 85-86 are still the export.
  - studio/design-concepts/README.md:13-15 is flagged as edited but still holds the folder tree.
- **N-5:** the generic rail's language notes have one-word last lines ("English", "timetables"). This is outside this delta and is for the design reviewer.

## Checks rerun
- `.venv python tests/run.py`: exit 0, 297 cases, no skips. All three references (engineer, hanami, hanami_essential) are raster- and text-equal. Evidence: C:\Github\cvgen\.worktrees\hanami-essential\builds\tests-20261108-180741-727112
- `ruff check`: exit 0.
- In tools/workflow:
  - `check`, `render --check` and `atlas --check`: OK.
  - `anchors origin/main`: OK (382 anchors, 0 moved, 0 edited).
  - `anchors 9b60224`: exit 1 (N-4).
- `python .atlas/_kit/atlas.py check`: 3 ok, 2 STALE (R8-1).
- `template_warnings` on 15 fixture cases and the reference:
  - plain-long-rank: "the rank row leaves 9 mm".
  - plain-long-name: "the name leaves 33 mm…nothing needs changing".
  - three-quarters and sparse: their thin-page warnings.
  - Every other case: none.
- My scratch scripts (pins.py, warn.py, r8rev/atlasdata.py) and the suite log are in C:\Users\jimzord12\AppData\Local\Temp\claude\0bad7b43ffb974fe\bd07fd7a-826f-4da0-ace1-f4e996f70146\scratchpad.

## Evidence inspected
- At b436a2d: components/essential.typ:109-145, tests/run.py:460-540 and 750-760, tests/fixtures/travel-essential.typ, tour-leader-generic.json, docs/guides/build-a-cv.md, render.py, __init__.py, scripts/cv.py, docs/workflow/*, .atlas/src/pages/system-map.json, atlas.data.js, docs/engine/verification.md and the TASK-79 record.
- Diffs against c8b7480, 9b60224 and the merge-tree result 38125da.

## Limitations
- I did not judge the look of the renamed fixture or the wording of the remedy.
- N-1 is from reading the code; I did not render it.

## Verdict: PASS

**Next:** the lead stores this report, fixes R8-1 to R8-3 (or records why they are deferred), and goes on to the merge steps.
