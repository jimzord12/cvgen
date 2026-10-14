# Review round 5: short-career-layout

Stored as returned by the `code-reviewer`; the lead's dispositions follow at
the end.

# Review round 5: short-career-layout

Snapshot: feat/short-career-layout at fb32960 (base 48933f5). I read the round-5 fix (`git diff 1887470 fb32960`) against the full change. HEAD was fb32960 when I checked it. The only other change in the working tree was an untracked `docs/work/short-career-layout/reviews/05-design-reviewer.md`, a report file and not source.
Lead lenses: (2) correctness, (8) docs coherence

Coverage:
1. Wiring: unchanged. The path is `deck-cadet.typ` → `one-page()` → `spread: true`, then `stack-gap: 12mm` from the profile, then the only page loop in `flagship.typ`.
2. Correctness:
   - `stacked = spread and not shared`. Every layout without `spread` (v11 and the rest) gets `stacked` false, so it never reads `stack-gap`. The v11 exact match passed in my rerun (raster and text equal on both pages).
   - Pages with both closing sections are unchanged. The deck-cadet, one-page-one and one-page-three PNGs are pixel-identical to round 4 (empty diff bbox), and their word positions match to 0.1mm.
   - Stacked pages: Typst's weak block spacing is not removed next to a fixed `v()` (unlike next to `v(1fr)`). So each heading keeps its own gap and `stack-gap` adds to it. Measured text to text: Experience→synopsis went from 15.2 to 27.2mm. Synopsis→section went from 7.4 to 19.4mm (no-education) and from 6.4 to 18.4mm (no-certificates). Each is exactly +12mm. The footer still ends at 294.3mm.
   - Capacity: the extra 24mm does not reduce the `Capacity Rule`. My probes all fit on one page: no certificates with 3 companies and 5 or 6 vessels (score 14 and 15), and no education with 1 company, 1 vessel and 10 certificates.
3. Data integrity: n/a. Fictional fixtures only; no data or workflow code touched.
4. Contracts: `stack-gap` is a new layout key. It is needed only when `spread` is on and a section is missing (M1). No schema changed.
5. Tests:
   - Every regression I tried falls outside the 17-32mm band: `stack-gap` removed (15.2mm), gap only above the synopsis (about 7mm), gap only above the section (15.2mm), or a return to `v(1fr)` (about 50mm or more).
   - The no-* cases now run `verify(pages=1)` (N19 resolved).
   - The upper bound of 32mm leaves 4.8mm of room above the widest gap.
6. Failure handling: overflow still fails loudly. A spread layout without `stack-gap` fails loudly but with a cryptic message (M1).
7. Simplicity: 9 lines in the owning loop, one named condition, and one key in the profile. No scope creep.
8. Repo/docs:
   - LF endings throughout and `git diff --check` is clean.
   - The layout guide, verification.md, the architecture tree and "Who owns spacing" match the code (N20 resolved).
   - Small gaps remain (N21, N22). The glossary needs no new term: `stack-gap` is a key name, not a concept.

## Findings
### M1 Minor: `spread: true` without `stack-gap` fails with a missing-key error
Anchor: `packages/domains/marine/templates/flagship/flagship.typ:54,59,65`; `docs/reference/layout-and-pagination.md` §anchor-education and spread
- Scenario: a custom layout built on v11 with `spread: true`, and a record without education.
- Expected: it renders stacked, or the docs say `stack-gap` is required.
- Actual: `error: dictionary does not contain key "stack-gap"` at flagship.typ:54. Probe source: `builds/review-r5-probe-20260928-144831/probe.typ.txt`.
- Impact: low. No shipped layout does this, and any layout built on the one-page profile inherits the key. The failure is loud, not silent.
- Smallest fix: one of these two:
  - Say in the guide that `spread` needs `stack-gap` (the one-page profile sets it).
  - Or read it as `layout.at("stack-gap", default: 0mm)`.

### N21 Note: "each `stack-gap` (12mm) apart" reads as the full gap
Anchor: `docs/reference/layout-and-pagination.md:39`
- `stack-gap` is added on top of each heading's own gap. The real text-to-text gaps are 27.2 and 19.4mm, not 12mm.
- Suggest: "with `stack-gap` (12mm) added above each".

### N22 Note: architecture drift, small
Anchor: `docs/architecture.md:44`, `:170`
- The Layout row names `spread` but not `stack-gap`.
- Tree line 170 runs past the file's wrap width.
- "with one missing" also covers the case where both sections are missing (`stacked` is then true and the gap sits only above the synopsis). This is harmless, and the docs could say "one or both".

### N23 Note: uneven stacked rhythm persists (design call)
- The two stacked gaps are 27.2 and 19.4mm, the same 8mm spread as N18, now shifted up by 12mm.
- The owner approved the render ("Much better now"), so this is recorded only for the design-reviewer.

## Checks rerun
- `python tests/run.py` at fb32960: exit 0, "PASS: 61 compilation cases plus PDF/data/layout assertions". Evidence: `C:\Users\jimzord12\Documents\GitHub\cvgen\builds\tests-20260928-144750-666165\`. The v11 `exact/result.json` has raster_equal and text_equal true. My no-education render matches the author's.
- Read-only PyMuPDF word positions and a PIL pixel diff comparing the author's round-4 (`tests-20260928-143946-383342`) and round-5 (`tests-20260928-144538-716844`) PDFs and PNGs.
- Probes from stdin, sources saved next to the PDFs:
  - `builds/review-r5-probe-20260928-144831/`: the M1 error.
  - `builds/review-r5-capacity-20260928-144856/`: three capacity probes, all 1 page.

## Evidence inspected
At fb32960:
- `flagship.typ`, `layouts/flagship-one-page.typ`
- `tests/run.py:200-220`, `tests/fixtures/one-page.typ`
- `docs/architecture.md`, `docs/reference/layout-and-pagination.md`, `docs/reference/verification.md`, `docs/glossary.md`
- Reviews 01-04 (code and design) with the lead's dispositions
- The author's PNGs and PDFs in `builds\tests-20260928-144538-716844\`

## Limitations
- I did not read the Trello card.
- Visual taste is left to the design-reviewer. The 05 design report was untracked and I did not read it.
- Probes used only the deck cadet record and the captain artwork.

## Verdict: PASS
There are no Blocking or Material findings at fb32960. M1 is a low-impact Minor: fix it or record why it is deferred. N21-N23 are optional.

## Dispositions (lead)
- PASS; the review loop ends here (round 5 of 5, both reviewers PASS).
- M1 fixed by the reviewer's first option, in documentation only: the layout guide says a layout that sets `spread` must also set `stack-gap`, and the missing key fails loudly.
- N21 fixed with the reviewer's wording ("added above each on top of its usual gap"). N22 fixed: the Layout row names `stack-gap`, the tree line is rewrapped and says "one or both missing".
- N23: approved by the owner; no change.
- These last edits are documentation wording taken from this report's own suggestions, with no code, test or render change; they take the trivial path with a focused check (the suite rerun) instead of a sixth round (docs/review.md, "When a review is required").
