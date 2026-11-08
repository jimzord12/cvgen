# Review round 4: TASK-79

Snapshot: worktree C:\Github\cvgen\.worktrees\hanami-essential, branch feat/hanami-essential, head 665df97 (clean). I reviewed the delta 546f5bc..665df97, which is 6366397, f619782 and 665df97.
Lead lenses: (1) Data integrity and loud failure (3, 6); (2) Contracts (4)
Coverage:
1. Wiring: the essential example reads the new twin. `hanami` sends `essential` to the new parts. The plain pack reaches `band()` through `band-motif`.
2. Correctness: lead-ins are correct on every edge I tried. The route arc collides with text (R4-1).
3. Integrity: all 29 travel paths that main pins (`tests/baseline.json`) match byte for byte, both on disk and in the HEAD blobs. That includes `tour-leader-example.json`, every `japan/*.svg` and the showcase PDF. The showcase components (hero.typ, sections.typ, art.typ, hanami.typ) are untouched. In the suite, showcase still equals its Frozen Reference. The lead-in rule drops no words.
4. Contracts: contracts/, schema and data.typ are untouched, so "no contract change" holds. Both new records pass the facts schema. `choose()` gives essential `dropped: []` for the generic fixture and `['travel-story']` for the twin. The manifest's `artwork` list is not enforced (R4-2).
5. Tests: the `lead-of` unit asserts and the pixel comparison against the candidate cover the twin. Gaps are in R4-3.
6. Failure handling: the arc is never measured (R4-1). Showcase with the plain pack fails loudly, but its message points to the wrong fix (R4-2).
7. Simplicity: the change is small and stays in the essential parts, a theme file and a pack file.
8. Repository and docs: the docs agree with the code. Glossary and merge Notes are in R4-5.

## Findings
### R4-1 Material: the plain pack's route arc sits on fixed coordinates and is never checked against the name block
Anchor: packages/domains/travel/templates/hanami/components/essential.typ:118-123 (`band`, else branch)
- **Scenario:** the essential twin with no portrait, rendered with `hanami-artwork.plain` (probe: builds/review-r4-probe/twin-plain-noportrait-band.png).
- **Actual:** the arc's start circle lands on "2024" in the rank row. With a portrait, the arc starts at about x 99 mm, but the name may run to x 149 mm (`W`). "ANDREAS KALAMARIS" ends at 93 mm, so a slightly longer valid name runs into the arc. Nothing fails or warns: the petal check exempts essential, and the name and rank checks measure only against `W`.
- **Expected:** Hanami's own rule, that every element placed outside the slots measures itself and fails loudly. Decoration should not lie on words.
- **Impact:** a generic client page can ship with the motif drawn over their credentials.
- **Smallest fix:** set the arc's left edge from the measured widths of the name and rank row plus a gap. Shorten or omit the arc, or fail clearly, when the room left is too small. Add suite cases for the plain pack with no portrait and with a long name.

### R4-2 Minor: the manifest's `artwork` list is not enforced, and the showcase error gives the wrong fix
Anchor: hanami.typ:47-49; components/art.typ:18
- **Actual:** showcase with `hanami-artwork.plain` fails with "The artwork pack has no seigaiha-band; add it to the pack" (probe showcase-plain). `choose()` reads neither `themes` nor `artwork`, which template-contract.md:180 documents.
- **Expected:** the error should say that showcase allows only `japan`, the way `layouts` is already asserted.
- **Fix:** give each pack a `name` and assert it against `design.variations.at(name).artwork`.

### R4-3 Minor: fixture and test gaps
Anchor: tests/fixtures/travel-essential.typ (case `generic-japan`); tests/run.py:491-496
- `generic-japan` is defined but run.py never compiles it.
- The comment says "no sakura", but only the missing 添乗員 is asserted. Nothing checks that the arc replaced the canopy.
- **Fix:** run or remove the case, and assert the motif swap. An image or drawing count would do.

### R4-4 Note: lead-in behaviour verified; some heuristic quirks
Probe builds/review-r4-probe/edges.pdf and edges-bullets.png keep every character of six bullets:
- "Departure at 10:30: meet…"
- "See https://example.com: the brochure"
- `He said: "Welcome aboard"`
- "Ώρα: 10:30…"
- ": orphan lead"
- "A: B: C"

Quirks:
- A quoted sentence like `He said:` gets a bold lead.
- Words are counted on ASCII spaces only.
- Practical `basics.label` is now bold only if it passes the rule; before, it was always bold.
- The unit asserts could add the 10:30 and URL cases.

### R4-5 Note: the rank's Japanese word, glossary and merge
- **Rank word:** `native-words: false` drops `copy.tab-native` even when the record's own `copy` sets it. build-a-cv.md documents this, but nothing warns.
- **Glossary:** "lead-in" now recurs in code and three docs, so propose a glossary term.
- **Pre-existing, out of scope:** template-contract.md:180 says nothing reads `layouts`, but `hanami` does (line 30).
- **Merge:** merging main will conflict in .atlas/* and docs/architecture.md. tests/run.py and baseline.json merge cleanly.
- **Design gate:** monochrome is now offered on the owner-approved showcase, so it needs the design reviewer.

## Checks rerun
- `C:\Github\cvgen\.venv\Scripts\python.exe tests/run.py`: exit 0, "PASS: 271 compilation cases…". Output in builds/tests-20261108-171235-283565.
- `ruff check`: exit 0, "All checks passed!"
- An isolated probe (builds/review-r4-probe/probe.typ) compiled with typst into that folder. The cases: twin-plain, twin-plain-noportrait and edges exit 0; showcase-plain exit 1 with the art assert.
- `validate_record` and `choose()` run in Python, read-only, on both new records.

## Evidence inspected
At 665df97:
- components/essential.typ, art.typ, hero.typ, hanami.typ
- template.json, themes/monochrome.typ, artwork/plain.typ, assets/plain/route-arc.svg
- cv_workflow/contracts.py and decoration.py
- tests/run.py, the two travel fixtures, tour-leader-generic.json, tour-leader-essential-example.json
- docs/engine/template-contract.md, verification.md, build-a-cv.md
- The Essential candidate PDF, rendered page 1

From main (8e4c1be): tests/baseline.json.

## Limitations
- The brief named no author evidence location, so I relied on my own rerun and renders.
- I did not judge the design (monochrome showcase, arc aesthetics); that is the design reviewer's gate.
- The suite cannot tell bold from regular text with the variable font, so I checked bold visually.

## Verdict: FINDINGS
