# Review round 4: TASK-82 (report figures)

**Verdict: PASS.** There are no Blocking or Material findings. N1 from round 3 is fixed: Close stays on one line at 360 px, 390 px and 1000 px. I found one Minor (M2) and two Notes (N2, N3).

Snapshot: worktree C:\Github\cvgen\.worktrees\report-figures, branch feat/report-figures, head d9d7fd3.
- Delta examined: ff82d46..d9d7fd3. That is studio/brand/report/report.html (4 lines), docs/engine/verification.md item 19, the TASK-82 record and the stored round-3 reports.
- eea6751..d9d7fd3 changes only the TASK-82 record.
- The worktree was clean when I started. I wrote only under builds/.

Lead lenses: (4) escaping of the new strings; (2) duplicate listeners or ids from the new button.

Coverage:
1. Product fit: met. A shared figure's heading now has "⤢ Enlarge" or "⤢ Compare". It opens the lightbox, and the lightbox bar names the open figure. This was round 3's open design Nits.
2. Correctness: I found no duplicate listener or id.
   - The `[data-enlarge]` binding (report.html:312) runs once, after `#page` is filled (line 306). Nothing re-renders `#page` later; the only other `innerHTML` writes are `#lb-body` and `#tally`.
   - The lightbox content (`visual()` plus a figcaption) holds no `[data-enlarge]` and no `[id]`.
   - The new button has no id. No other selector catches it: `.choice button`, `[data-best]` and `.lb-bar button` all miss it.
   - The headless probe confirms this: 3 buttons (B in a card; A and C in Figures headings), exactly 1 click listener each, 0 duplicate ids on the page.
3. Data integrity: n/a. This is built output.
4. Escaping: safe.
   - `data-enlarge="${e(x.id)}"` is escaped, and `e()` covers `"`. Ids are also format-checked in report.py.
   - `#lb-sides` takes its strings through `textContent`. With a hostile caption (`<img src=x onerror=alert(1)>`, `"quoted"`), a label `<b>Classic</b>` and a `<script>` caption, the bar showed literal text with 0 child elements, 0 `img[src="x"]` and 0 alerts.
5. Tests: the suite still does not run the page's script, as verification.md item 19 says. My browser probe covered the new paths.
6. Failure handling: Close stays in view and on one line at 360, 390 and 1000 px. See M2 for a long unbroken caption.
7. Simplicity: one handler and one `.ref` style serve both kinds of button; the change is small.
8. Repository and docs:
   - LF line endings; `git diff --check` is clean.
   - The verification.md change is a pure reflow with the same words.
   - The record now has the task-record shape. See N2.

## Findings
### M2 Minor: a long unbroken caption pushes "Figure X" out of view in the lightbox bar
Anchor: studio/brand/report/report.html:178-179 (`.lb-bar`, `.lb-bar span`)
- **Scenario:** a page figure's caption contains a long token with no spaces, such as a builds/ path. I tested a 120-character token.
- **Expected:** the bar text wraps, and "Figure C · …" stays readable.
- **Actual:** the span keeps its min-content width. With `justify-content:flex-end`, it spills off the left edge, where no one can scroll to it, so "Figure C · Shared page" is cut off at every width. Close stays visible and works. Screenshot: builds/review-code-r4-20261108-164500/phone-C.png.
- **Impact:** the bar's new purpose, naming the open figure, fails only for such captions.
- **Fix:** add `min-width:0;overflow-wrap:anywhere` to `.lb-bar span`.

### N2 Note: acceptance criterion #2 cites evidence older than the shared Enlarge button
Anchor: the TASK-82 record, acceptance criterion #2.
- It cites "design-reviewer round 3 PASS" as proof that each shared picture opens in a lightbox.
- Round 3 examined ff82d46, before shared figures had a button; it listed their missing Enlarge as an open Nit.
- **Fix:** cite this round's or design round 4's evidence when the record is next updated.

### N3 Note: the shared button's accessible name does not name the figure
Anchor: report.html:271.
- The in-card thumbnail has `aria-label="Enlarge Figure X: caption"`. The new heading button reads only "⤢ Enlarge" or "⤢ Compare".
- **Fix (optional):** give it the same `aria-label`.

## Checks rerun
- `C:\Github\cvgen\.venv\Scripts\python.exe tests/run.py`: exit 0. "25 passed, 0 failed; PASS: 220 compilation cases plus PDF/data/layout assertions". Evidence: builds/tests-20261108-164442-539690.
- `ruff check`: exit 0, "All checks passed!"
- `scripts/report.py` on a changed copy of the sample (hostile caption and label, plus a shared page figure C cited by cards 1 and 3), into builds/review-code-r4-20261108-164500/page/. I also built the plain sample into …/sample/.
- Headless Chrome on copies with an added probe script, in the same folder:
  - probe-dom.html: listener counts, the bar text, duplicate ids, injection check.
  - phone-A.png, phone-C.png: the lightbox open in 360, 390 and 1000 px iframes.
  - phone-fig.png: the Figure A heading with its Compare button; no page overflow at 360 px.

## Evidence inspected
At d9d7fd3:
- studio/brand/report/report.html (style, the `shared`, `thumb`, `visual` and `compare` functions, the listeners);
- studio/brand/report/sample.json;
- docs/engine/verification.md item 19;
- the TASK-82 record;
- archive/work-records/report-figures/reviews/code-round-03.md and design-round-03.md.

## Limitations
- I did not test on a real touch device.
- Focus return after Close is still not verified.
- The design reviewer owns how the new heading button looks.

## Verdict: PASS
