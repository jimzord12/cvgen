# Review round 1: report figures (commit 1097d95, no task record)

Snapshot: worktree C:\Github\cvgen\.worktrees\report-figures, branch feat/report-figures, 379e425..1097d95 (6 files). The worktree was clean.
Lead lenses: (2) correctness of placement and escaping; (5)/(6) loud failure and tests.
Coverage:
1. Product fit: met. A picture cited by one card only sits in that card (Figure B in card 2 of the screenshot). Card 4 shows "Look at Figure A ↓".
2. Correctness: I found no case where a figure disappears. One case shows a figure twice (F1). The arrows on decision links point the wrong way (F3).
3. Data integrity: n/a. The page is built output and changes no records.
4. Contracts and escaping: safe. Ids must match `[A-Za-z0-9]{1,4}`, a citation must name a known id, and `e()` still escapes the `id`/`href` values. The README contract is damaged (F2).
5. Tests and evidence: every new refusal has a test that checks its exact message. The page's placement script has no automated check (N2).
6. Failure handling: the old messages are unchanged. An old JSON file now fails first with "evidence: an item needs id", which is clear.
7. Simplicity: the logic is about 6 lines in the owning template.
8. Repository and docs: line endings are LF. See F2 and N1.

## Findings
### F1 Minor: a figure cited twice by the same item renders twice
Anchor: scripts/report.py:133-140; studio/brand/report/report.html:237-238
Scenario: a card has `"figures": ["B","B"]` and nothing else cites B. The script accepts it. I ran the page's `cites`/`owned` functions in Node: `cites('B')` is 1 and `owned` returns `['B','B']`.
Expected: one picture, or a refusal.
Actual: the card shows the picture twice, with two `id="fig-B"` elements. A decision with the same duplicate shows two identical links.
Impact: low, but the brief asked exactly this question, and the script's rule is to refuse bad data rather than build a bad page.
Fix: refuse it, e.g. `len(set(cited)) != len(cited)` → "'X' cites Figure B twice", and add a test.

### F2 Minor: README field table cut in two
Anchor: studio/brand/report/README.md:43-50
The new "Where a picture goes…" paragraph sits inside the table. The `changes` and `evidence_path` rows now follow the paragraph and render as plain text with pipes, not as table rows.
Fix: move the paragraph below line 50.

### F3 Minor: decision links point down to a section that is above them
Anchor: report.html:253-255 (order of sections), 240 (`↓`), 267; README.md:46
Sections render in this order: Needs you, Figures, Reviews, Decided without you, Changes. A "Figure A ↓" link in a decision therefore points up. The README also says the Figures section is "at the foot", which is wrong.
Fix: drop the arrow or use ↑ for decision links, and correct the README wording.

### F4 Minor: a comparison picture inside a card cannot be enlarged
Anchor: report.html:154, 278; README.md:45
A comparison picture cited by only one card sits in a column no wider than 260px. The zoom handler is attached only to `.shows .sheet`, which only plain pages have, and the slider covers the whole comparison anyway. The README promises "a click enlarges it". Neither the sample nor the screenshot shows this case.
Fix: make a comparison picture span the full card width (`.shows figure:has(.compare){grid-column:1/-1}`), or reword the README.

### N1 Note: docs/preferences.md is agent context and needs its own reviewer
Under docs/review.md, a change that mixes code and context gets a code-reviewer and a context-reviewer. Owner feedback that changes agent behaviour also goes through the context-maintainer first. This review does not cover the new preferences.md bullet.

### N2 Note: nothing checks where figures are placed
The test at tests/report.py:30-31 checks only the sample's data, not the built page. It would still pass if B were cited by a decision rather than by a card. docs/engine/verification.md:229 says the page's script is not run by the suite, so the screenshot is the only proof of placement. The screenshot ends before the decisions section, so the links in decisions are shown in no evidence.

## Checks rerun
- `C:\Github\cvgen\.venv\Scripts\python.exe tests/run.py`: exit 0, "PASS: 218 compilation cases…". Evidence in C:\Github\cvgen\.worktrees\report-figures\builds\tests-20261108-162224-683016, whose report.json lists all 7 new `report: refused:` cases.
- `ruff check`: exit 0, "All checks passed!"
- A Node simulation of the placement functions, in my scratchpad, not the repository. Results: the uncited figure stayed under Figures, the figure shared by a card and a decision went under Figures with a link, and the duplicate case is F1.

## Evidence inspected
- At 1097d95: scripts/report.py, studio/brand/report/report.html, sample.json, README.md, tests/report.py, docs/preferences.md, docs/engine/verification.md §19.
- The author's builds/report-161817-chk/shot.png and report.html. Its `<script>` block is byte-identical to the template at 1097d95.

## Limitations
I opened no browser, so I did not see the zoom toggle, the `:target` outline, or how the links in decisions look. No earlier rounds.

## Verdict: PASS
No Blocking or Material findings. F1-F4 are Minor: fix each or record a reason. This PASS does not cover the preferences.md change (N1).
