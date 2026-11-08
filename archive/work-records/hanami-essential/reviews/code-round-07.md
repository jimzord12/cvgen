# Review round 7: TASK-79

**Verdict: PASS.** No Blocking or Material findings. There is one Minor finding (R7-1) and some Notes. Merging main will conflict in the Workflow Model and Atlas files only; the code, tests and docs merge cleanly.

Snapshot: worktree C:\Github\cvgen\.worktrees\hanami-essential, head 1d9c75a (clean tree). Delta reviewed: 56144c4..1d9c75a (ef3cf13, 3017eb5, 44af07c, 1d9c75a).
Lead lenses: (6) loud failure and correctness of the fill logic; (3) integrity of the main-pinned paths and the showcase pixel check.
Coverage:
1. Wiring: the fill gate, the warnings and the trip-tag shape all reach the real `essential()`, `band` and `destinations` paths. `scripts/cv.py render` picks up the new warning text (tests/workflow.py).
2. Correctness: roomy now needs both columns at 80% or more (essential.typ:139), and the warning fires below 80% (:155). So a page can never be both stretched and warned. Gaps are still capped at `least + share`, so the column cannot overflow. The warning wording for every fixture case is listed under Checks rerun.
3. Integrity: all 63 paths pinned in main's tests/baseline.json (c8b7480) match on disk and in the HEAD blobs. HEAD's baseline is identical to main's. The showcase reference is raster- and text-equal on both pages, and its PDF is not in the delta. In the essential reference, only the consultant highlight cell's words changed. Its "25 to 40 trips a year" comes from the record's own bullet (tour-leader-essential-example.json:82).
4. Contracts: the two new loud failures, an unnamed pack and an arc SVG without the weight strings, fail with their own messages.
5. Tests: on the round 6 render, the trip-tag test fails (April 2024's tag sat on its date line, y0 488.7 < 499.7) and it passes now. The role gap is 10.38 mm against the 9.5 mm floor, and the 8 mm cap leaves about 7.4 mm.
6. Failure handling: see R7-1.
7. Simplicity: the change stays in the owning files. Note: essential.typ:138 and :145 measure the same rail twice.
8. Repository and docs: template-contract.md and verification.md match the code. No stale "14 mm" or "page is N% filled" wording remains outside archive/. `git diff --check` is clean.

Earlier findings: R6-1, R6-2 and R6-3 are resolved. Of R6-4, the comment, the `compile_case` modes, the verification.md update and the date-gap assertion are done. The arc remedy is done in part (R7-1).

## Findings
### R7-1 Minor: the arc warning's remedy does not fit when the name sets the width
Anchor: packages/domains/travel/templates/hanami/components/essential.typ:136-138
- **Scenario:** `plain-long-name`, a long name with no portrait.
- **Actual:** "...leaves 33 mm of the 45 mm it needs; shorten the seal words or the specialty, or let the portrait carry the band". The rank row is not what binds here, so shortening it changes nothing. This record has no portrait, so "let the portrait carry the band" reads as "add one", and adding one narrows the room further.
- **Impact:** the operator spends a render on a change that does nothing.
- **Smallest fix:** compare `measure(name)` with `measure(rank)`. When the name binds, say the arc stays out for a name this long and that this is expected. Keep the seal-words advice for the rank row.

### R7-2 Note
- **Trip-tag test (tests/run.py:467):** `zip` with `search_for('LED THE GROUP')` would pass with no checks at all if the tags were never found. Assert `len(...) == 2` first; the count is 2 today.
- **Role-gap test:** it has a floor only. A return to the 14 mm cap (13.38 mm measured on the round 6 render) would still pass. That design is guarded by the design reviewer.
- **Both columns thin:** only the thinner column is named. Sparse names the rail at 34%, while its career column is also about 38%. The operator learns about the second column only after the next render.

### R7-3 Note: merging main (TASK-83) will conflict
`git merge-tree 8e4c1be HEAD main`, which writes nothing, shows clean merges for tests/run.py, docs/engine/verification.md, docs/guides/build-a-cv.md, docs/architecture.md and packages/cv-workflow/README.md. There are no add/add conflicts.

Files with conflicts:

| File | Conflict regions |
|---|---|
| .atlas/atlas.data.js | 20 |
| .atlas/atlas.lock.json | 10 |
| .atlas/src/pages/client-journey.json | 15 |
| .atlas/src/pages/system-map.json | 2 |
| docs/workflow/04-text-draft/stage.yaml | 2 |
| docs/workflow/05-design/README.md | 1 |
| docs/workflow/05-design/stage.yaml | 16 |
| docs/workflow/06-deliver/stage.yaml | 20 |
| docs/workflow/catalog.yaml | 1 |

Almost all of these are `file:line` source anchors and Atlas hashes. Neither side's anchors will be right after the merge, because build-a-cv.md merges from both sides. Regenerate them against the merged tree rather than picking a side.

Two conflicts carry real content and must take main's wording:
- the 05-design step "place the portrait" versus "prepare the portrait", with its client-workflow.md:69-94 source;
- the `lead.write-candidate-json` row in 05-design/README.md.

## Checks rerun
- `C:\Github\cvgen\.venv\Scripts\python.exe tests/run.py`: exit 0, 289 cases. Evidence: C:\Github\cvgen\.worktrees\hanami-essential\builds\tests-20261108-175351-705922\report.json. hanami_reference and hanami_essential_reference both pass, raster- and text-equal on every page.
- `ruff check` (C:\Github\cvgen\.venv\Scripts\ruff.exe; plain `ruff` is not on PATH): exit 0, "All checks passed!"
- `git diff --check 56144c4..1d9c75a`: clean. `scripts/outputs.py check`: 19 PDFs indexed, 0 problems.
- `template_warnings` on 15 fixture cases and the reference:
  - three-quarters: "career column is 60%";
  - sparse: "rail is 34%";
  - plain-long-rank and plain-long-name: the arc warning (9 mm and 33 mm);
  - every other case, and the reference: none.
- A pymupdf probe of the round 6 and round 7 renders, and a word diff of the 56144c4 and HEAD essential references.
- My scripts are in C:\Users\jimzord12\AppData\Local\Temp\claude\0bad7b43ffb974fe\bd07fd7a-826f-4da0-ace1-f4e996f70146\scratchpad (pins.py, probe.py, warn.py, mt.txt).

## Evidence inspected
At 1d9c75a: essential.typ, components/essential.typ (band, destinations), tests/run.py, tests/workflow.py, tests/fixtures/travel-essential.typ, tour-leader-generic.json, tour-leader-essential-example.json, template-contract.md, verification.md and the TASK-79 notes. Also main's baseline.json (c8b7480), the 56144c4 essential reference PDF, and the round 6 build at builds/tests-20261108-174055-132983.

## Limitations
- I did not run the merged tree. The merge result is predicted by merge-tree only.
- I did not judge the design of the 11 mm gap, the remedy wording or the tag-on-own-line shape.

## Verdict: PASS
