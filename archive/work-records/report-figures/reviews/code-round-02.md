# Review round 2: report figures (1097d95..39e507d, no task record)

Snapshot: worktree C:\Github\cvgen\.worktrees\report-figures, branch feat/report-figures, head 39e507d. Delta 1097d95..39e507d, 10 files. The worktree was clean before and after my checks.
Lead lenses: (2) correctness and escaping of the new page code and of `placement`; (5) tests.
Coverage:
1. Product fit: met. In the rendered sample, Figure B is a thumbnail in card 2 with an "⤢ Enlarge" chip. Figure A sits under Figures with back links "Card 4 ↑" and "Decision ↓".
2. Correctness: I found no defect. I ran `placement()` on synthetic data:
   - no evidence and no cards gives `{cards:[],figures:[]}`;
   - evidence with no cards puts the figure under Figures;
   - an uncited figure, a figure only a decision cites, and a figure shared by two cards all go under Figures;
   - a figure one card alone cites goes into that card;
   - ids `a` and `A` stay distinct.
   Every link the page makes has a target: a card links only to figures that are not its own, and a figure a decision cites can never sit in a card.
3. Data integrity: n/a. The page is built output.
4. Escaping and contracts: safe.
   - A `placement` key in the JSON is overwritten by `build()` (report.py:186) before it is embedded. I passed `"<script>…"` as `placement` and the built page used the computed value instead.
   - The new interpolations escape their values with `e()`: `data-enlarge`, `aria-label`, captions, card and decision titles.
   - The `src` values are data URIs the script made, as before.
   - The `ask-N`, `dec-N` and `fig-X` prefixes keep ids apart. The rendered DOM has no duplicate ids.
5. Tests: see M1. The F1 refusal has a test that checks its exact message.
6. Failure handling: the duplicate citation is refused before any folder is written. The suite confirms no folder is left.
7. Simplicity: placement is now decided once, in the owning script, and the page only reads it.
8. Repository and docs: the changed files are LF. The README table is whole again. See N2 and N3.

Round 1, point by point:
- F1: fixed. report.py:141-143 refuses it, with a test at tests/report.py:96.
- F2: fixed. The paragraph now sits below the table.
- F3: fixed. Cards use ↓ and decisions use ↑. The rendered back links point the right way. The README now says "below the cards".
- F4: fixed. A comparison in a card opens in the lightbox with its slider. The design round-2 probe `d1100-cic-dark-lb-slide30.png` shows the slider at 30% inside the dialog.

## Findings
### M1 Minor: the placement test covers only the sample's two cases
Anchor: tests/report.py:30-34
Scenario: the sample has one figure that only a card cites (B) and one cited by a card and a decision (A). It has no uncited figure and no figure that only a decision cites.
Expected: a test that fails if either of those cases is placed wrongly.
Actual: suppose `placement` changed to list under Figures only the figures that more than one item cites. An uncited figure, or one only a decision cites, would then vanish from the page, and the suite would still pass. The test does fail for the likely mutations: if decisions are not counted, A moves into card 4 and the test fails; if A or B is placed wrongly, it fails too. It also does not prove the page reads `placement`, because the page's script is not run, as verification.md says.
Impact: low. I checked by hand that the current code handles both cases.
Fix: add one direct call that imports the script's `placement` (or one built synthetic file) with an uncited figure and a figure only a decision cites, and assert `figures` holds both.

### N1 Note: the Close button scrolls out of view
In `d1100-dark-lb-scrolled.png`, a full page enlarged in the lightbox scrolls inside the dialog and the Close button leaves the top. Escape and a click on the backdrop still close it. This is for the design reviewer; `.lb-bar{position:sticky;top:0}` would keep it visible.

### N2 Note: the context changes need context round 2
Context round 1 returned FINDINGS. This delta changes preferences.md and verification.md in answer to it. My PASS does not cover those two files as agent context.

### N3 Note: records
- The review files are named `code-round-01.md` and similar. Elsewhere the pattern is `NN-<reviewer>.md`.
- There is no task record or dispositions file yet (docs/review.md, "Report and persistence").
- "Decision ↓" back links carry no number, while card links carry one ("Card 4 ↑"). This is optional.

## Checks rerun
- `C:\Github\cvgen\.venv\Scripts\python.exe tests/run.py`: exit 0, "PASS: 220 compilation cases…". Evidence: builds/tests-20261108-162923-713768. Its report.json includes "report: figures placed: one in its card, one shared under Figures".
- `ruff check`: exit 0, "All checks passed!"
- A headless Chrome `--dump-dom` of that run's sample page, saved to builds/review-code-r2-20261108-163019/sample-dom.html. It has no duplicate ids, every `href="#…"` resolves, there is one thumbnail (B), and the lightbox is present.
- `placement()` and `refusal()` on synthetic data, from a script in my scratchpad.

## Evidence inspected
At 39e507d:
- scripts/report.py, studio/brand/report/report.html, README.md, sample.json, tests/report.py;
- docs/engine/verification.md §19, docs/preferences.md;
- the stored round-1 code and context reports.

Also the design reviewer's builds/design-review-report-r2-20261108-162901/*.png, which is their evidence, not a check I ran.

## Limitations
I clicked nothing myself, so the lightbox and the slider are seen only in the design reviewer's screenshots. Focus return when the lightbox closes is not verified.

## Verdict: PASS
There are no Blocking or Material findings. M1 is Minor: fix it or record a reason. N2: the context files still need their own round.
