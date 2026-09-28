# Review round 1: short-career-layout

Stored as returned by the `code-reviewer`; the lead's dispositions follow at
the end.

# Review round 1: short-career-layout

Snapshot: `git diff 48933f5 e1188d4` on feat/short-career-layout (one commit, e1188d4). The working tree was clean when I started.
Lead lenses: (2) correctness and edge cases, (5) tests and visible evidence
Coverage:
1. Product fit and wiring: the example and suite reach the profile. The real-client path (`new-cv` skill, `build-a-cv.md`, `cv.py render`) does not point to it (F2).
2. Correctness: 0, 1, 2 and 3 companies were probed. The singular captions work in the contract path and, by construction, the legacy path. One copy-composition gap (F3).
3. Data integrity: the cadet record is fictional (example.com, +00 phone). No data paths changed.
4. Contracts: the Flagship input schema, domain copy and `data.typ` expectation agree. The facts schema carries no `copy`, so it needs no change.
5. Tests: the new cases detect a broken plan helper, a reverted geometry and a broken company singular. The vessel singular is untested (F4).
6. Failure handling: overflow fails loudly with "Content overflow on planned page 1". Zero companies fails with "Experience requires at least one vessel".
7. Simplicity: `one-page()` lives in the layout file (geometry and page plan), `count-caption` in `sections.typ`, and `flagship.typ` is untouched. Scope matches the settled decisions.
8. Repo and docs: files use LF, AGENTS.md and verification.md are updated, and nothing references the renumbered items. Two doc gaps (F1, F5).

## Findings
### F1 Minor: the capacity claim sits exactly at the measured limit, and the bottom-margin change is undisclosed
Anchor: `docs/reference/layout-and-pagination.md` "Choosing a profile"; `flagship-one-page.typ:8`
Scenario: a real cadet with three companies, four vessels and five certificates (common in practice).
Expected: the doc's "up to about three companies and four vessels with a short certificate list" fits.
Actual (my probes): 3 companies, 4 vessels and 4 certificates fit with about 2 mm to spare (see `one-page-three.png`: the "03" heading touches the table). Adding a 5th certificate overflows. Two companies with three vessels take up to 8 certificates; 9 overflows.

Separately, the profile lowers `opening-margin.bottom` from 15 to 12 mm. This change is in neither the brief's settled list nor the doc's "tighter vertical gaps" list. Its side effect is that the page-1 footer moves about 6 pt down: the word box ends 1.8 pt above the paper edge, against 7.8 pt on v11 page 1. At 11 mm the footer leaves the page.
Impact: agents pick the wrong profile, and the footer may be clipped when printed. Both failures are loud or cosmetic, not silent.
Fix: state the measured ceiling (for example "three companies and four vessels with four certificate rows, or two companies with up to eight rows"). Name the bottom margin and its footer effect in the doc, or restore 15 mm if the owner prefers.

### F2 Minor: the real-client path does not lead to the profile
Anchor: `docs/guides/build-a-cv.md` §1 (lines 27-50); `.claude/skills/new-cv/SKILL.md` steps 3-4; `scripts/cv.py` (`--pages` defaults to 2)
Scenario: an agent follows `new-cv` for a cadet.
Actual: the guide says a real candidate "always overrides `pages`" on v11. With v11 geometry the cadet overflows one page (probe `v11-cadet-onepage`), which pushes the agent to two pages. Even with the new profile, `cv.py render` checks for 2 pages, and `approve` requires passing checks. Nothing says to use `--pages 1`.
Fix: one line in `build-a-cv.md` §1 and in `new-cv` pointing short careers to `one-page(candidate)` and `--pages 1`.

### F3 Minor: overriding only a plural copy key leaves a mismatched singular
Anchor: `sections.typ:27`; `adapter.typ` merge order
Scenario: a record or `copy:` argument sets `companies: "Employers"` without `company`.
Actual: a count of 1 shows the domain default "Company". The fallback to the plural only works when the key is absent from the composed copy, and the domain always supplies it. Only the legacy caller can benefit from the fallback.
Fix: a sentence in `candidate-schema.md` saying to override singular and plural together. Alternatively, have the singular fall back to the plural whenever the plural differs from the domain default.

### F4 Minor: the vessel singular is untested
Anchor: `tests/run.py` one-page loop
Scenario: `count-caption` is broken for vessels only, and the suite still passes. Nothing renders exactly one vessel. My probe `one-vessel` shows "1 VESSEL 1 COMPANY" correctly today.
Fix: make `case=one` use company index 1 (Saronic, one ship) and assert `1 VESSEL`.

### N1 Note: the one-company page has a large empty band
Anchor: `one-page-one.png`
Education is anchored to the bottom, which leaves about 40 mm blank between the certificates and education. The proposal's pitch was "a full, confident page". This is for the owner to judge when he approves the look. Show him this render, not only `deck-cadet.png`.

### N2 Note: four companies falls between the two rows
The "Choosing a profile" table covers "up to about three" and "about five or more". The fallback sentence covers four implicitly. Optional wording fix.

## Checks rerun
- `python tests/run.py`: exit 0, PASS, 59 cases including `engineer` exact v11. Output in `builds/tests-20260928-141652-915248/`.
- Isolated probes compiled from stdin (no source files created), with PDFs and logs in `builds/review-short-career-layout-r1-20260928-141652/`:
  - `v11-cadet-onepage` overflows.
  - `onepage-fixed-layout` fails with "index out of bounds", as the doc says.
  - `one-vessel` passes.
  - `five-certs-three` overflows.
  - `cadet-certs-5`..`8` pass; `cadet-certs-9` overflows.
  - `zero-companies` fails loudly.
  - `footer-11/12/15` and the footer crops back the F1 measurements.

## Evidence inspected
At e1188d4: all 13 changed files, `flagship.typ`, `flagship-v11.typ`, `hero.typ`, `adapter.typ`, `legacy.typ`, `core/page.typ`, `cv_workflow/render.py`, `approve.py`, `build.ps1`, `build-a-cv.md`, `new-cv/SKILL.md`, and the proposal including its correction. Author evidence: the `deck-cadet`, `one-page-one` and `one-page-three` PNG/PDF files in `builds/tests-20260928-141357-063126/`. They were written at 14:13:59-14:14:27, after the 14:13:53 commit, and match my rerun.

## Limitations
I did not read the Trello card (external system). I did not inspect `private/` for existing plural-only copy overrides. The footer print-clipping risk is inferred from coordinates, not from a printed page.

## Verdict: PASS
No Blocking or Material findings. F1-F4 are Minor: fix them or record a reason to defer. The owner should see `one-page-one.png` and `one-page-three.png` before a frozen reference is considered.

## Dispositions (lead)
- F1 fixed: capacity re-measured after the round-1 design fixes on a grid of 1-3 companies, 1-7 vessels and 2-10 certificate rows, and stated as a rule in the layout guide. The bottom-margin change is reverted (design D2), so there is no footer effect to disclose.
- F2 fixed: `build-a-cv.md` section 1 and the `new-cv` skill point short careers to `one-page(candidate)` and `--pages 1`.
- F3 fixed by documentation: `candidate-schema.md` says to override singular and plural together.
- F4 fixed: `case=one` uses the one-vessel company, and the suite asserts "1 VESSEL" and "1 COMPANY".
- N1: resolved by design D1 (`spread`); the owner is shown the one-company render.
- N2 fixed: the profile table now reads "about four companies up" for v11.
