# Review round 2: short-career-layout

Stored as returned by the `code-reviewer`; the lead's dispositions follow at
the end.

# Review round 2: short-career-layout

Snapshot: feat/short-career-layout, base 48933f5, head 5470f43. I examined the round-2 fix diff (`git diff e1188d4 5470f43`) and the full change (`git diff 48933f5 5470f43`). The working tree was clean.
Lead lenses: (2) correctness, (8) repository and docs coherence
Coverage:
1. Product fit and wiring: `deck-cadet.typ`, `build-a-cv.md` §1, `new-cv` step 3/4 and `cv.py --pages 1` (the flag exists, default 2) now form one path.
2. Correctness: the spread logic is right when both closing sections are present. With either one absent it produces one hole (F5). The minimums hold: the 02 gap is 5.9 mm glyph-to-box on one-page-three, against 5.1 mm on v11 engineer p2. The capacity rule holds at every score-14 edge I tested, but it leaves out groups and wrapped rows (F6).
3. Data integrity: n/a. Fictional fixtures only, and no data or workflow paths changed.
4. Contracts: `spread` is read with `default: false`. No layout schema exists to update. Copy singular/plural is now documented.
5. Tests: the vessel singular is asserted. The `overflow` case depends on spread's minimums: with `spread: false` it fits on one page, so the suite would catch spread being removed. It would not catch unequal sharing (N10).
6. Failure handling: overflow still fails loudly ("Content overflow on planned page 1") in every failing probe.
7. Simplicity: spacing stays in the page loop, which owns outer gaps (architecture.md). The profile is only geometry and plan. No scope creep.
8. Repo/docs: files use LF and the commit scope is clean. `architecture.md` was not updated (F7), plus small wording points (N11, N12).

## Findings
### F5 Minor: with a closing section absent, `spread` makes one hole, and certificates sink to the bottom
Anchor: `flagship.typ:48-55`; `layout-and-pagination.md:32-35`
Scenario: a schema-valid record (only `identity` and `companies` are required) with no education and no languages, or with no certificates.
Expected: the doc says "a thin record has two even gaps rather than one hole".
Actual (probes `c1-v1-r4-noedu`, `c1-v1-r0`): with no education, the `v(1fr)` before 02 pushes the certificate table onto the footer, leaving about 90 mm empty under the synopsis. This is new behaviour. With no certificates, all the space sits above 03, as before.
Impact: this is D1's "missing section" look, but only for uncommon cadet records. The owner sees it at render review.
Fix: at minimum, qualify the doc sentence. Better, when only one closing section renders, also place a `v(1fr)` before the synopsis (or after the experience block) so there are still two gaps.

### F6 Minor: the capacity rule leaves out vessel-type groups and wrapped certificate rows
Anchor: `layout-and-pagination.md:18-26`
Scenario: a cadet with two vessel types in one company, or long STCW titles.
Actual: all 16 score-14 edges fit (1-3 companies, 1-7 vessels). But two companies and three vessels in two groups fit with 4 certificates (13+1) and overflow with 5 (14+1). With a real 75-character STCW title ("Proficiency in survival craft and rescue boats other than fast rescue boats"), 2 rows fit and 3 overflow, so each such row costs about 3.
Impact: an agent picks the one-page profile and gets a loud overflow. The doc already says "the render decides".
Fix: add "+1 per extra vessel-type group; count each extra line of a wrapped certificate row" beside the profile and education caveats.

### F7 Minor: `architecture.md` does not describe `spread`
Anchor: `docs/architecture.md:44`, `:168`, `:175-176`
The layout row and the composition tree list only `v(1fr) if anchor-education`. AGENTS.md says to read this file "before changing any module".
Fix: add `spread` to the layout row, and to the tree as `[v(1fr)+min if spread] certificates-section, [v(1fr) if anchor-education][min if spread] education…`.

### N10 Note: nothing pins the equal split
If the first `v(1fr)` were dropped, all free space would return above 03 and the suite would still pass. The fix would be an assertion in the one-page-one case that the gap above 02 and the gap above 03 are within about 2 mm (measured today: 22.5 / 21.7 mm). Optional.

### N11 Note: the "upper half" wording is wrong
The profile paragraph in `layout-and-pagination.md:28-31` says the tighter gaps are "in the upper half" but lists certificate rows and language boxes, which are in the lower half.

### N12 Note: record naming and glossary
Round reports are stored as `01-code-reviewer.md` and `01-design-reviewer.md`, while review.md says `<NN>.md`. That is reasonable with two reviewers, but the protocol does not say so. "Capacity rule" now recurs in three docs and is a glossary candidate.

## Checks rerun
- `python tests/run.py`: exit 0, PASS, 59 cases, exact v11 raster and text equal on both pages. Output in `builds/tests-20260928-142643-203536/`.
- Stdin probes (no source files written), with sources in `.typ.txt` next to the PDFs: `builds/review-short-career-layout-r2-20260928-142738/` (grid edges, groups, long certificates, no-education and no-certificate renders), `builds/review-short-career-layout-r2-20260928-142756/` (group and long-row cost), and `builds/review-short-career-layout-r2-nospread-20260928-142955/` (fixture cases with `spread: false`: all three fit on 1 page).
- PyMuPDF gap measurements on the rerun PDFs.

## Evidence inspected
At 5470f43: `flagship.typ`, `flagship-one-page.typ`, `flagship-v11.typ`, `sections.typ`, `certificates.typ`, `education.typ`, the `one-page.typ` fixture, `run.py` lines 145-202, `deck-cadet-example.json`, the candidate schema's required fields, `cv.py`, all changed docs and `architecture.md`. Author evidence: the PNGs in `builds/tests-20260928-142436-966133/` (deck-cadet, one-page-one, one-page-three), which match my rerun. I also read both round-1 reports and their dispositions.

## Limitations
I did not read the Trello card (external). The visual quality of the spread pages is left to the design-reviewer. Capacity was probed only with the deck cadet's profile, education and captain artwork.

## Verdict: PASS
There are no Blocking or Material findings. F5-F7 are Minor: fix them or record a deferral. F5 is the one the owner may care about if a record lacks certificates or education.

## Dispositions (lead)
- F5 fixed: with certificates or education missing, `spread` puts its second flexible gap above the synopsis, so the page still has two even gaps. New fixture cases `no-education` and `no-certificates`; the doc says what happens.
- F6 fixed: the capacity rule adds 1 per extra vessel-type group and 1 per extra line of a wrapped certificate row (a long STCW title costs about 3).
- F7 fixed: `architecture.md` names `spread` in the Layout row, the composition tree and "Who owns spacing".
- N10 fixed: the suite asserts, on `one`, `no-education` and `no-certificates`, that the two flexible gaps are each over 15mm and differ by less than 8mm.
- N11 fixed ("upper half" removed).
- N12: the `NN-<reviewer>.md` naming follows the precedent of docs/work/docs-2026-09-28 with two reviewers per round; no protocol change. `Capacity Rule` added to the glossary.
