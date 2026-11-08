# Review round 3: TASK-82 (report figures)

Snapshot: worktree C:\Github\cvgen\.worktrees\report-figures, branch feat/report-figures, head ff82d46969bd. I examined the delta 39e507d..ff82d46: tests/report.py, studio/brand/report/report.html, docs/engine/verification.md, the TASK-82 record and the stored round-2 reports. The worktree was clean before and after my checks.

Lead lenses: (6) failure handling and escaping in the new lightbox code; (5) whether the new test fails for the M1 mutation.

Coverage:
1. Product fit: met. A compare cited by one card now shows as a two-half thumbnail in that card. Its lightbox names the sides in the bar, and the bar stays at the top.
2. Correctness: I found no defect.
   - The top image is `before`, clipped from the right, so "Left: before · Right: after" matches the picture.
   - With dialog padding 0, a click inside the content hits `.lb-frame`, so only a backdrop click closes the dialog.
   - The sticky bar's scroll container is the modal dialog.
3. Data integrity: n/a. The page is built output.
4. Escaping and contracts: safe.
   - `lb-sides` is set with `textContent`, and `before_label` and `after_label` are required for a compare (report.py:45).
   - The new thumbnail `src` values are data URIs that `picture()` makes. The `shared` caption span still escapes its values with `e()`.
   - I tested a hostile label, `<img src=x onerror=alert(1)>Classic`. It showed as literal text in the bar and in the slider labels, and no `img[src="x"]` element was created.
5. Tests: M1 is fixed. The new assertion fails for the M1 mutation (Figures listing only figures cited more than once returns `['S']`), and it also fails if uncited figures are dropped. Not counting decisions passes the new mixed case, but the sample assertion at tests/report.py:34 still catches it, because A would move into card 4. The sample never puts a compare inside a card, so the new thumbnail code is not run by the suite; verification.md says the page's script is not run there. My probe below covered it.
6. Failure handling: a bad probe input of mine (an empty `figures` list) was refused with the documented message, and no report folder was written. At real phone widths (360 and 390 px, rendered in iframes), the Close button stays in view even with labels about 28 characters long. The bar text wraps. See N1.
7. Simplicity: placement is still decided once, in scripts/report.py. The test imports `placement()` rather than copying it.
8. Repository and docs: the changed files are LF and `git diff --check` is clean. The wording of verification.md item 19 matches the refusal cases at tests/report.py:99-106. TASK-82 records the round-1 and round-2 dispositions, including why the review file names and the unnumbered decision back links were kept.

## Findings
### N1 Note: the Close label wraps on phones when the side labels are long
Anchor: studio/brand/report/report.html:177-181 (`.lb-bar`, `.lb-bar button`)
- Scenario: a compare with labels of about 25 characters, at 360-390 px.
- Expected: "Close ✕" stays on one line.
- Actual: the button shrinks to "Close / ✕" on two lines. The button stays visible and works (builds/review-code-r3-20261108-163830/f-long.png).
- Impact: cosmetic only.
- Fix, optional: `flex:none;white-space:nowrap` on `.lb-bar button`.

## Checks rerun
- `C:\Github\cvgen\.venv\Scripts\python.exe tests/run.py`: exit 0, "PASS: 220 compilation cases plus PDF/data/layout assertions". Evidence: builds/tests-20261108-163710-704063. Its report.json has the case "report: figures placed: … uncited and decision-only figures stay under Figures".
- `ruff check`: exit 0, "All checks passed!"
- A mutation probe from my scratchpad that imports scripts/report.py and runs three changed versions of `placement` against the test's expected value. Two were caught; the third is caught by the sample assertion, as described in lens 5.
- `scripts/report.py` on a changed copy of the sample, with A cited only by card 1 and hostile labels, into builds/review-code-r3-20261108-163830/page/.
- Headless Chrome on copies of that page with a click script added, in the same folder:
  - clicked-dom.html: the lightbox is open, the bar text is escaped, and no `img[src="x"]` exists.
  - f-*.png: the page in 360 px and 390 px iframes.
  - The 512 px headless minimum made clicked-390.png and m-*-390.png crops of a wider page, so I discarded them as evidence.

## Evidence inspected
At ff82d46:
- tests/report.py;
- scripts/report.py (`placement`, `build`, `picture`, the refusal rules);
- studio/brand/report/report.html and sample.json;
- docs/engine/verification.md §19;
- the TASK-82 record;
- archive/work-records/report-figures/reviews/code-round-02.md.

## Limitations
I did not open the lightbox on a real touch device. Focus return after the dialog closes is still not verified. The design reviewer owns how the new thumbnail and the bar look.

## Verdict: PASS
There are no Blocking or Material findings. M1 from round 2 is resolved. N1 is optional.
