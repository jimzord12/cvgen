# Review round 2: TASK-2 (travel-domain)

Snapshot: worktree `C:\Github\cvgen\.worktrees\travel-domain`, branch `feat/travel-domain`, head `9b582dc`, tree clean. I read the fixes as `git diff 9298891..9b582dc` and checked them against the full patch `main...9b582dc`.
Lead lenses: (2+6) correctness and loud failure (the new measure-and-assert checks, the petal check); (4) contracts and privacy (`destinations` required, the twin's replaced facts).
Coverage:
1. Wiring: OK. `render.py:195-196` reaches `decoration_errors` with `choice['template']`. Marine gets `[]` before pymupdf loads.
2. Correctness: R2-1.
3. Integrity: OK. The totals are 2 trips / 30 days / 14 stops, and Fukuoka is on both trips.
4. Contracts and privacy: F2 and F4 verified, see below.
5. Tests: R2-2, R2-3.
6. Failure handling: R2-1, N-a.
7. Simplicity: OK. The petal check now lives in cv-workflow, and the gap entry is updated.
8. Repository and docs: LF endings, `ruff` clean. The Framework and marine diff is empty. The `Fictional Twin` glossary row is added.

## Round 1 findings
- **F1:** largely fixed. The new checks fire: in my stress run the rank, email, right-side contact, city and many-link cases each failed with their own message. The twin and the indigo theme compile, and the seal guard can now fail (right edge ≤ GX+36 mm). One part is still open: R2-1.
- **F2:** fixed. Contract `v1.json:11`, the schema `required`, `data.typ:30`, and the `coverage.py` refusal all agree, and `template.json` no longer claims the group.
- **F3:** fixed (`data.typ:62`, plus the schema text). The `story2` stress case fails loudly.
- **F4:** the replacements are in place and consistent:
  - All 15 kanji are correct. The stamp counts are 4 and 11, the rim words are known stops, and the "Knows well" list matches the known flags (9).
  - The route is SKG to FUK.
  - The reference PDF text has no old values (Osaka, +30, Erasmus, Ljubljana and the like). Outside `archive/`, no old wording remains except the kept "two cousins".
- **F5:** fixed. **F6:** partly fixed, see R2-3. **N1, N2:** done.

## Findings
### R2-1 Material: three fields outside the slots still overflow without an error (constitution 4)
Anchor:
- `components/stamp.typ:57-60`: the stamp's kanji is placed with no measure.
- `components/hero.typ:156-161`: the page-2 line with rank · region · native is not width-checked, and the height check at `:167-174` leaves it out.
- The claims in `hanami.typ:5-7` and `docs/architecture.md`.

Scenario: all of the following compiled with exit 0. Evidence: `builds/review-travel-r2b-20261108-125701/` and `builds/review-travel-r2-20261108-125558/`.
- `destinations.native` "日本・韓国・台湾" (region "East Asia"): on page 1 the kanji cross the region seal's inner ring (`crop-eastasia-p1.png`).
- A trip's `stamp.kanji` "福岡・長崎・熊本": the kanji run into the rim words (`crop-tripkanji-p2.png`).
- Region "Japan and Korea" with native "日本・韓国・台湾・中国": the page-2 line ends at 103.3 mm. That is past GX = 100 mm, under the travellers (`eastasia2-sakura-p2.png`).

Expected: a compile error that names the field, as the other fields now give.
Fix:
- Measure the kanji against the stamp's inner disc and assert.
- Assert that the rank · region · native line is ≤ GX−19 mm, and include it in the height measure.
- Add `long-native` and `long-stamp-kanji` cases to `tests/fixtures/travel.typ`.
- Neither schema field has a length bound, so the template has to catch it.

### R2-2 Minor: nothing proves the petal check can fire
Anchor: `tests/run.py:318-319`. The suite only asserts the check returns empty on the twin and `[]` for flagship.
My probe shows the check works: I placed text on known petal boxes on pages 1 and 2, and it reported both. Probe at `builds/review-travel-r2c-*/probe.typ`.
Impact: a broken box calculation (or a bounds mistake) would still pass, and this check now gates client renders.
Fix: keep a small positive case like the probe in the suite.

### R2-3 Minor: some markers are still proved by other markers (F6 residual)
Anchor: `fixtures/coverage-v1.markers.json`. With `squeeze` substring matching:
- "QXA" is contained in Qxarealabel, Qxarea, Qxarrival and Qxavailable.
- "QXB" is contained in Qxbullet, Qxbadge and Qxbasic.
- "Qxarea", "Qxstory" and "Qxcell" are prefixes of their sibling markers.

Result: the route codes are proved without being shown.
Fix: use markers that are not substrings of each other (for example `ZQA`), or match on token boundaries.

### Notes
- **N-a:** in the render path:
  - The `assert layer` and a missing `petals-p3` file would surface as a traceback after `render.json` is written. `approve` refuses a revision without `checks.json`, so this is safe, but the message is unclear.
  - A custom `cv.typ` whose choice has no `template` skips the petal check.
- **N-b:** `hero.typ:151`: the message tells the user to "give fewer contacts a link" even when the plain line is the one too long. My no-links case got exactly that wrong advice.
- **N-c:** the tab fits "Tour Leader 添乗員" with little room: "Tour Director" fails. The failure is loud and correct; the owner may want a wider tab.
- **N-d:** twin realism:
  - IELTS 8.0 maps to C1 officially, while the record shows English C2.
  - "Has passed through: the Seto Inland Sea coast" does not fit Toyama, Sendai or Hakodate.
  - Trip 2 goes Himeji, then Okayama, then Naoshima, which backtracks.

## Checks rerun
- `.venv\Scripts\python.exe tests/run.py` at `9b582dc`: exit 0, PASS, 220 cases. Evidence in `builds/tests-20261108-125530-083323`.
- Stress compiles (19 variants, two themes for the twin), script `scratchpad/r2/stress2.py` and `stress3.py`. Output in the two folders above.
- The petal probe (above). `ruff check`: passed.

## Evidence inspected
At `9b582dc`:
- `hero.typ`, `stamp.typ`, `sections.typ`, `art.typ`, `hanami.typ`, `template.json`, `indigo.typ`;
- `data.typ`, the contract, the schema, the fixtures and markers;
- `decoration.py`, `render.py`, `contracts.py` (`choose`, `claims`, `coverage`);
- `tests/run.py`, `coverage.py`, `fixtures/travel.typ`;
- the twin JSON and the reference PDF text;
- the docs diffs and the task record.

## Limitations
- I did not read `private/`, so F4 rests on the lead's comparison plus my consistency checks.
- I did not run `render_revision` end to end for a Hanami workspace. I verified its wiring by reading the code and by the `choose` test.
- The design verdict on the visual changes belongs to the design-reviewer.

## Verdict: FINDINGS
