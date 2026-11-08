# Review round 5: TASK-79

Snapshot: worktree C:\Github\cvgen\.worktrees\hanami-essential, branch feat/hanami-essential, head 5adde85 (clean). Delta reviewed: 504abc5..5adde85 (6cceec5, 7ba4198, 946e7f1, 5adde85).
Lead lenses: (1) Loud failure (6); (2) Integrity (3)
Coverage:
1. Wiring: the plain pack, the pack-name check, `soft-field-petals` and `portrait-plate` all reach the real paths (`hanami.typ`, `band`, `art`).
2. Correctness: the arc stays clear of words in every case the band allows. Its left edge sits 10 mm past the wider of the name and the rank row. The arc is at most 19.2 mm tall, so it ends 25.2 mm down the band, and the contacts start at about 29 mm whatever the record. Its right end sits 6 mm before the portrait's ring. Probes: builds/review-r5-probe/*-band.png.
3. Integrity: I checked all 63 paths that main (8e4c1be) pins in tests/baseline.json, 28 of them travel. Every one matches byte for byte, both on disk and in the HEAD blobs. The sakura showcase still matches its Frozen Reference in my suite run. With the default theme, `field-strip` is `none`, so sakura's output is unchanged.
4. Contracts: both changed fixtures pass the travel schema (`validate_record`). Each manifest `artwork` list is now enforced.
5. Tests: the arc and word-intersection check would have caught R4-1 (plain-long-name). The 80% threshold is not tested (R5-3).
6. Failure handling: when the arc is left out, nobody is told (R5-1).
7. Simplicity: the change stays in the essential parts, the theme file and the pack files.
8. Repository and docs: LF line endings and `git diff --check` are clean. The guide names a script this branch does not have (R5-2).

Earlier findings: R4-1 is resolved. R4-2 is resolved, and the showcase-plain message is asserted. R4-3 is resolved: generic-japan runs and the motif swap is asserted. R4-4: the time and URL unit cases were added. R4-5: the glossary term was added. The other R4-5 Notes are not raised again.

## Findings
### R5-1 Minor: when the arc is left out, the operator is not told
Anchor: packages/domains/travel/templates/hanami/components/essential.typ:130
- **Scenario:** a record with a portrait whose name or rank row is wider than 95.4 mm (151.4 − 30 − 10 − 16). A rank row with seal words reaches that easily: see plain-long-rank, builds/review-r5-probe/plain-long-rank-band.png.
- **Actual:** the plain pack's only motif disappears and the band is bare. Nothing in `checks.json` or the render output says so.
- **Expected:** no words are lost and the behaviour is documented, so this is not Material. But this Template already has a warning channel, `<cvgen-warning>`, and a plain-pack client with a portrait and seal words will often hit this case.
- **Fix:** when `w < 30mm`, emit a `<cvgen-warning>` ("the route arc is left out: the name or rank row leaves under 30 mm"). Assert it for plain-long-rank through `template_warnings`.

### R5-2 Minor: the fixture portrait points to a script this branch does not have, and its provenance is not recorded
Anchor: docs/guides/build-a-cv.md:68; tests/fixtures/travel-essential.typ:55
- **Source of the cut-out:** it does come from the fictional pinned image. The best match is a 1228-px square crop at (0,0) of examples/candidates/fictional-engineer.png, resized to 640 px. The mean difference on opaque pixels is 1.4 of 255; a wrong crop gives 27.7. That original still matches its pinned hash (262b1055…).
- **The grey copy:** the tool did not make it; the tool has no grey option. It is a standard luminance conversion of the colour cut-out (mean difference 0.25), with identical alpha.
- **The script:** `scripts/portrait.py` is on neither HEAD nor main; feat/portrait-prep is not an ancestor. If this branch merges first, the guide sends operators to a script that does not exist.
- **Committing the PNGs is sound:** they are static, fictional fixtures, and no test depends on the tool. Only their reproducibility and the guide depend on the unmerged branch.
- **Fix:** do one of two things. Merge feat/portrait-prep first and record that order in the task, or word the guide line as pending that branch. Also add a short provenance record beside the PNGs (a README, or the tool's sidecar JSON) with: the source path and its sha256, the crop, the tool commit (715e39c), and how the grey copy was made.

### R5-3 Minor: no test can tell the 80% threshold from 60%
Anchor: tests/run.py:479-483
- **Actual:** the sparse case warns at 36% and every other case gives no warning (my `template_warnings` sweep of 11 cases plus the example). Reverting the threshold to 0.6 keeps the suite green.
- **Fix:** add one case filled between 60% and 80% (for example sparse with a few more bullets) and assert that it warns.

### R5-4 Note
- **Glossary:** the `Lead-in` row gives the five-word limit but not the 40-character one that `lead-of` and the guide apply.
- **Unnamed packs:** `artwork.at("name", default: "japan")` lets a pack with no `name` pass as japan.
- **Arc weight:** the heavier no-portrait arc depends on exact SVG strings in `swaps`, which `art()` replaces silently. A re-exported SVG would lose the weight without any error.
- **Brief:** it says render.py changed. It did not: the threshold lives only in essential.typ, and the docs and README follow it.
- **Design gate:** the fixture pairs a male portrait with "Daphne Kontou". Monochrome now changes showcase's petals, so the design reviewer still needs to look at it.

## Checks rerun
- `C:\Github\cvgen\.venv\Scripts\python.exe tests/run.py`: exit 0, "PASS: 286 compilation cases plus PDF/data/layout assertions", 25 workflow checks passed. Output in builds/tests-20261108-172830-866731.
- `ruff check`: exit 0, "All checks passed!"
- The baseline hash comparison against main's tests/baseline.json (read-only). Its copy is in my scratchpad.
- `template_warnings` (typst eval, writes nothing) for 11 fixture cases and the example.
- `validate_record` on tour-leader-generic.json and tour-leader-long-career.json.
- Band renders and pixel provenance probes, in builds/review-r5-probe/.

## Evidence inspected
At 5adde85:
- components/essential.typ, art.typ, hero.typ, hanami.typ, essential.typ
- themes/monochrome.typ, the japan and plain artwork packs, template.json, assets/plain/route-arc.svg
- tests/run.py, the travel-essential fixture, the portrait PNGs
- template-contract.md, verification.md, build-a-cv.md, glossary.md, cv-workflow/README.md, render.py

Elsewhere:
- main 8e4c1be: tests/baseline.json
- feat/portrait-prep b50bce7: scripts/portrait.py

## Limitations
- I did not rerun the portrait tool: it needs rembg and its models, which are not installed here, and installing them is outside my remit. Provenance rests on the pixel match.
- I did not judge the design (arc weight, monochrome, portrait plate); that is the design reviewer's gate.

## Verdict: PASS
