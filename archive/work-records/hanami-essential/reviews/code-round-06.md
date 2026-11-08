# Review round 6: TASK-79

Snapshot: worktree C:\Github\cvgen\.worktrees\hanami-essential, head 96742f4 (clean). Delta reviewed: 87ab779..96742f4 (478464d, 96742f4).
Lead lenses: (1) Loud failure (6); (2) Integrity (3)
Coverage:
1. Wiring: the arc warning, the per-column fill and the roomy gaps all reach the real `essential()` and `band` paths. The example's frozen render is unchanged apart from the trip gap.
2. Correctness: the gaps cannot overflow. Each gap is at most `least + share`, and height grows linearly with the gaps: in generic, spare fell by exactly 17.01 + 17.0 pt. So the column stays at or under H. Every probed case has positive spare.
3. Integrity: all 63 paths pinned in main's tests/baseline.json (8e4c1be and the current main, bf8f0d7) match byte for byte, on disk and in the HEAD blobs. HEAD's baseline neither adds nor changes a pin. The showcase is raster- and text-equal on both pages, and so is the essential reference. Between the old and new essential reference, only the six words after each trip's date move, each by 2.83 pt. Every highlight in the generic row comes from the record itself: the first bullet, the third bullet, practical item 2, and education plus English C2. Korea is backed by the Seoul and Busan stops. Both fixtures pass `validate_record`.
4. Contracts: every pack must now have a `name`; japan and plain both do. The provenance claims I could check hold: the source sha256 262b1055…, its 1254 px size, and the two 640 px RGBA files.
5. Tests: R5-3 is resolved. With the threshold at 0.6, or with the round-5 average, three-quarters gives no warning, so the test fails. The roomy gaps are untested (R6-2).
6. Failure handling: see R6-1 and R6-3.
7. Simplicity: the change stays in essential.typ, components/essential.typ, hanami.typ and the fixtures.
8. Repository and docs: `git diff --check` is clean, LF throughout. One stale comment, and verification.md is not updated (R6-4).

Earlier findings: R5-1 is resolved, with the warning asserted for both cases. R5-2 is resolved: provenance.json is added, and the task notes record the TASK-83 merge order (the frontmatter `dependencies: []` does not). R5-3 is resolved. R5-4: the glossary row, the pack name and the SVG strings are all done.

## Findings
### R6-1 Minor: the thin-page warning does not say which column is thin, and its remedies fit only the career column
Anchor: packages/domains/travel/templates/hanami/essential.typ:148-151
- **Scenario:** in `sparse`, the career column is 43% filled and the rail 34%.
- **Actual:** "the page is 34% filled; fill out the record (more bullets, a highlight, availability)". More bullets do not move 34%, and a highlight lands in neither column.
- **Expected:** the operator learns which column to fill.
- **Fix:** name the thinner column, with remedies for it: "the career column is N% filled: more bullets or a role", or "the rail is N% filled: availability, languages, destinations or know-how". Assert the column word in the sparse and three-quarters cases.

### R6-2 Minor: no test can tell whether the roomy gaps exist
Anchor: essential.typ:19,130-132; tests/run.py:523
I tested a probe copy with roomy set to the `most` caps. Generic's career column reads 82.5% instead of 88.9%, so it still gives no warning. The example's spare is 4.8 mm, so the Frozen Reference never reaches roomy. The suite stays green without the feature.
- **Fix:** in the generic PDF, assert that the gap between the two roles, or before Education, is at least 12 mm.

### R6-3 Minor: the roomy gaps count toward "filled", so they can silence the warning
Anchor: essential.typ:138,148
Fill is measured after the stretch. In my probes the roomy gaps raise three-quarters from 60.5% to 63.7%, and sparse's career column from 37.6% to 43.1%.
- **Scenario, computed from the formula (not rendered):** a column of five slots whose content at `least` gaps is 70% of H (H ≈ 188 mm). At the `most` caps it reads about 79% and warns. With the roomy gaps it reads about 95% and stays silent.
- **Fix:** compute `fill` from the height at the `most` caps, before roomy, so the warning judges the record and not the stretch. Or record the choice as deliberate.

### R6-4 Note
- tests/run.py:502-503: the comment still says "under 30 mm".
- The two new loud failures, an unnamed pack and an SVG missing the weight strings, have no `compile_case` error mode.
- docs/engine/verification.md item 6 does not list three-quarters, the arc-warning cases, or that generic must not warn.
- The new assertion `'September 2024 14 days'` also passes with the old 1.4 mm gap (probe v2). The 2.4 mm gap is guarded only by the essential reference's raster check.
- The arc warning says why the arc is left out, but not what to change (the seal words, or the portrait). It recurs on every render for that client.

## Checks rerun
- `C:\Github\cvgen\.venv\Scripts\python.exe tests/run.py`: exit 0, 287 cases. Report: builds/tests-20261108-174055-132983/report.json (hanami_reference and hanami_essential_reference both pass, raster- and text-equal).
- `ruff check`: exit 0, "All checks passed!"
- `git diff --check 87ab779..96742f4`: clean.
- A comparison of every pinned path against 8e4c1be's and bf8f0d7's baseline.json: no mismatches. The script is in my scratchpad.
- `validate_record` on both changed fixtures: passed. `scripts/outputs.py check`: 0 problems.
- `typst eval` probes on disposable copies in builds/review-r6-probe/: v0 instrumented, v1 without roomy, v2 with the 1.4 mm gap, v3 with average fill. Also a word-position diff of the old and new essential reference.

## Evidence inspected
At 96742f4: essential.typ, components/essential.typ, hanami.typ, artwork/plain.typ, tests/run.py, travel-essential.typ, tour-leader-generic.json, tour-leader-long-career.json, portraits/provenance.json and the PNGs, template-contract.md, verification.md, glossary.md, cv-workflow/README.md, render.py `template_warnings`, the TASK-79 record, and the essential reference PDF. Also the 87ab779 reference PDF, main's tests/baseline.json, and commit 715e39c (on feat/portrait-prep).

## Limitations
- I did not rerun the portrait tool, nor verify the tool-output sha256 in provenance.json.
- I did not judge the design: the 14/16 mm gaps, the 45 mm arc threshold, the highlight row's look.
- R6-3's five-slot case is computed from the code, not rendered.

## Verdict: PASS
